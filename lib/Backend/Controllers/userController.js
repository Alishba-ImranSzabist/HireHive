const db = require('../db');

// GET all users
const getAllUsers = (req, res) => {
  db.query('SELECT * FROM users', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
};

// GET single user
const getUserById = (req, res) => {
  db.query('SELECT * FROM users WHERE id = ?',
  [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(404).json({ message: 'User not found' });
    res.json(results[0]);
  });
};

// POST create user
const createUser = (req, res) => {
  const { name, email, password, role, phone, skills, company, bio } = req.body;
  if (!name || !email || !password || !role) {
    return res.status(400).json({ message: 'Name, email, password and role required!' });
  }
  db.query(
    'INSERT INTO users (name, email, password, role, phone, skills, company, bio) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
    [name, email, password, role, phone, skills, company, bio],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: 'User created!', id: results.insertId });
    }
  );
};

// PUT update user
const updateUser = (req, res) => {
  const { name, phone, skills, company, bio } = req.body;
  db.query(
    'UPDATE users SET name=?, phone=?, skills=?, company=?, bio=? WHERE id=?',
    [name, phone, skills, company, bio, req.params.id],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      if (results.affectedRows === 0) return res.status(404).json({ message: 'User not found' });
      res.json({ message: 'User updated!' });
    }
  );
};

// DELETE user
const deleteUser = (req, res) => {
  db.query('DELETE FROM users WHERE id = ?',
  [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.affectedRows === 0) return res.status(404).json({ message: 'User not found' });
    res.json({ message: 'User deleted!' });
  });
};

module.exports = {
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser
};