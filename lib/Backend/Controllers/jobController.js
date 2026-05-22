const db = require('../db');

// GET all jobs
const getAllJobs = (req, res) => {
  db.query('SELECT * FROM jobs', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
};

// GET single job
const getJobById = (req, res) => {
  db.query('SELECT * FROM jobs WHERE id = ?',
  [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(404).json({ message: 'Job not found' });
    res.json(results[0]);
  });
};

// POST create job
const createJob = (req, res) => {
  const { title, budget, description, posted_by } = req.body;
  if (!title || !budget) {
    return res.status(400).json({ message: 'Title and budget required!' });
  }
  db.query(
    'INSERT INTO jobs (title, budget, description, posted_by) VALUES (?, ?, ?, ?)',
    [title, budget, description, posted_by],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: 'Job created!', id: results.insertId });
    }
  );
};

// PUT update job
const updateJob = (req, res) => {
  const { title, budget, description } = req.body;
  db.query(
    'UPDATE jobs SET title=?, budget=?, description=? WHERE id=?',
    [title, budget, description, req.params.id],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      if (results.affectedRows === 0) return res.status(404).json({ message: 'Job not found' });
      res.json({ message: 'Job updated!' });
    }
  );
};

// DELETE job
const deleteJob = (req, res) => {
  db.query('DELETE FROM jobs WHERE id = ?',
  [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.affectedRows === 0) return res.status(404).json({ message: 'Job not found' });
    res.json({ message: 'Job deleted!' });
  });
};

module.exports = {
  getAllJobs,
  getJobById,
  createJob,
  updateJob,
  deleteJob
};