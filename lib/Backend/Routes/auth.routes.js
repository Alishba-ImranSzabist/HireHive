const express = require('express');
const router = express.Router();
const db = require('../db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const SECRET = "hirehive_secret_key_2024"; // same as middleware/auth.js

// ─── REGISTER ─────────────────────────────────────────────────────────────────
router.post('/register', async (req, res) => {
  const { name, email, password, role, phone, skills, company, bio } = req.body;

  // Validation
  if (!name || !email || !password || !role) {
    return res.status(400).json({ message: 'Name, email, password and role are required!' });
  }
  if (!['client', 'freelancer'].includes(role)) {
    return res.status(400).json({ message: 'Role must be client or freelancer!' });
  }

  // Check if email already exists (uses INDEX on email column)
  db.query('SELECT id FROM users WHERE email = ?', [email], async (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length > 0) {
      return res.status(400).json({ message: 'This email is already registered!' });
    }

    // Hash password
    const hashed = await bcrypt.hash(password, 10);

    db.query(
      'INSERT INTO users (name, email, password, role, phone, skills, company, bio) VALUES (?,?,?,?,?,?,?,?)',
      [name, email.toLowerCase().trim(), hashed, role, phone || '', skills || '', company || '', bio || ''],
      (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(201).json({ message: 'Account created successfully!' });
      }
    );
  });
});

// ─── LOGIN ────────────────────────────────────────────────────────────────────
router.post('/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password are required!' });
  }

  // Uses INDEX on email — fast lookup
  db.query('SELECT * FROM users WHERE email = ?', [email.toLowerCase().trim()], async (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(401).json({ message: 'No account found with this email!' });

    const user = results[0];
    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.status(401).json({ message: 'Wrong password!' });

    // JWT token contains id and role — each user gets unique token
    const token = jwt.sign(
      { id: user.id, role: user.role },
      SECRET,
      { expiresIn: '7d' }
    );

    // Return token + user info (NO password)
    res.json({
      token,
      role: user.role,
      name: user.name,
      id: user.id,
      email: user.email,
      phone: user.phone || '',
      skills: user.skills || '',
      company: user.company || '',
      bio: user.bio || '',
      image_url: user.image_url || '',
    });
  });
});

module.exports = router;
