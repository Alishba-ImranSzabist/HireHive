const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const db = require('../db');

// GET all jobs
router.get('/', auth, (req, res) => {
  db.query('SELECT * FROM jobs ORDER BY created_at DESC', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// GET single job
router.get('/:id', auth, (req, res) => {
  db.query('SELECT * FROM jobs WHERE id = ?', [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(404).json({ message: 'Job not found!' });
    res.json(results[0]);
  });
});

// POST create job — client_id token se lena
router.post('/', auth, (req, res) => {
  const { title, budget, description, posted_by } = req.body;
  const client_id = req.user.id; // token se automatic
  if (!title || !budget) return res.status(400).json({ message: 'Title and budget neccessary!' });
  db.query(
    'INSERT INTO jobs (title, budget, description, posted_by, client_id) VALUES (?, ?, ?, ?, ?)',
    [title, budget, description, posted_by, client_id],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.status(201).json({ message: 'Job post successfully!', id: results.insertId });
    }
  );
});

// PUT update job
router.put('/:id', auth, (req, res) => {
  const { title, budget, description } = req.body;
  db.query(
    'UPDATE jobs SET title=?, budget=?, description=? WHERE id=?',
    [title, budget, description, req.params.id],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      if (results.affectedRows === 0) return res.status(404).json({ message: 'Job not found!' });
      res.json({ message: 'Job update successfully!' });
    }
  );
});

// DELETE job
router.delete('/:id', auth, (req, res) => {
  db.query('DELETE FROM jobs WHERE id = ?', [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.affectedRows === 0) return res.status(404).json({ message: 'Job not found!' });
    res.json({ message: 'Job delete successfully!' });
  });
});

module.exports = router;
