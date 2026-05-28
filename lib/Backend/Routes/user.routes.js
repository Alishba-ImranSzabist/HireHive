const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const db = require('../db');

// GET all users
router.get('/', auth, (req, res) => {
  db.query('SELECT id, name, email, role, phone, skills, company, bio, created_at FROM users', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// GET single user
router.get('/:id', auth, (req, res) => {
  db.query('SELECT id, name, email, role, phone, skills, company, bio FROM users WHERE id = ?', [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(404).json({ message: 'User not found!' });
    res.json(results[0]);
  });
});

// PUT update user
router.put('/:id', auth, (req, res) => {
  const { name, phone, skills, company, bio } = req.body;
  db.query(
    'UPDATE users SET name=?, phone=?, skills=?, company=?, bio=? WHERE id=?',
    [name, phone, skills, company, bio, req.params.id],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: 'Profile update Successfully!' });
    }
  );
});

// DELETE user
router.delete('/:id', auth, (req, res) => {
  db.query('DELETE FROM users WHERE id = ?', [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'User delete successfully!' });
  });
});

module.exports = router;
