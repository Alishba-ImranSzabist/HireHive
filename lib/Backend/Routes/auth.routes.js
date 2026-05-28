const express = require('express');
const router = express.Router();
const db = require('../db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const SECRET = "hirehive_secret_key";

// REGISTER
router.post('/register', async (req, res) => {
  const { name, email, password, role, phone, skills, company, bio } = req.body;
  if (!name || !email || !password || !role) {
    return res.status(400).json({ message: 'Name, email, password and role are Compulsory!' });
  }
  const hashed = await bcrypt.hash(password, 10);
  db.query(
    'INSERT INTO users (name, email, password, role, phone, skills, company, bio) VALUES (?,?,?,?,?,?,?,?)',
    [name, email, hashed, role, phone||'', skills||'', company||'', bio||''],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      res.status(201).json({ message: 'Account created Successfully!' });
    }
  );
});

// LOGIN
router.post('/login', (req, res) => {
  const { email, password } = req.body;
  db.query('SELECT * FROM users WHERE email = ?', [email], async (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(401).json({ message: 'User not found!' });
    const user = results[0];
    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.status(401).json({ message: 'Wrong Password!' });
    const token = jwt.sign({ id: user.id, role: user.role }, SECRET, { expiresIn: '7d' });
    res.json({ token, role: user.role, name: user.name, id: user.id });
  });
});

module.exports = router;
