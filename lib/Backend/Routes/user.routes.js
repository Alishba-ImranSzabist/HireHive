const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const upload = require('../middleware/upload');
const db = require('../db');
const path = require('path');
const fs = require('fs');

// ─── GET all users (admin use) ─────────────────────────────────────────────
router.get('/', auth, (req, res) => {
  db.query(
    'SELECT id, name, email, role, phone, skills, company, bio, image_url, created_at FROM users ORDER BY id DESC',
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(results);
    }
  );
});

// ─── GET single user by ID ─────────────────────────────────────────────────
router.get('/:id', auth, (req, res) => {
  db.query(
    'SELECT id, name, email, role, phone, skills, company, bio, image_url, created_at FROM users WHERE id = ?',
    [req.params.id],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      if (results.length === 0) return res.status(404).json({ message: 'User not found!' });
      res.json(results[0]);
    }
  );
});

// ─── PUT update profile (text fields) ─────────────────────────────────────
// Only the logged-in user can update their own profile
router.put('/:id', auth, (req, res) => {
  // Security: user can only update their own profile
  if (req.user.id !== parseInt(req.params.id)) {
    return res.status(403).json({ message: 'You can only update your own profile!' });
  }

  const { name, phone, skills, company, bio } = req.body;

  if (!name || name.trim() === '') {
    return res.status(400).json({ message: 'Name cannot be empty!' });
  }

  db.query(
    'UPDATE users SET name=?, phone=?, skills=?, company=?, bio=? WHERE id=?',
    [name.trim(), phone || '', skills || '', company || '', bio || '', req.params.id],
    (err) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: 'Profile updated successfully!' });
    }
  );
});

// ─── POST upload profile image ─────────────────────────────────────────────
// POST /users/:id/image
router.post('/:id/image', auth, upload.single('image'), (req, res) => {
  // Security: only own profile image
  if (req.user.id !== parseInt(req.params.id)) {
    return res.status(403).json({ message: 'You can only update your own image!' });
  }

  if (!req.file) {
    return res.status(400).json({ message: 'No image file provided!' });
  }

  const imageUrl = `http://localhost:3000/uploads/${req.file.filename}`;

  // Delete old image if exists
  db.query('SELECT image_url FROM users WHERE id = ?', [req.params.id], (err, results) => {
    if (!err && results.length > 0 && results[0].image_url) {
      const oldFile = results[0].image_url.replace('http://localhost:3000/uploads/', '');
      const oldPath = path.join(__dirname, '../uploads', oldFile);
      if (fs.existsSync(oldPath)) fs.unlinkSync(oldPath);
    }

    // Save new image URL to database
    db.query(
      'UPDATE users SET image_url=? WHERE id=?',
      [imageUrl, req.params.id],
      (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'Profile image updated!', image_url: imageUrl });
      }
    );
  });
});

// ─── DELETE user ───────────────────────────────────────────────────────────
router.delete('/:id', auth, (req, res) => {
  if (req.user.id !== parseInt(req.params.id)) {
    return res.status(403).json({ message: 'You can only delete your own account!' });
  }
  db.query('DELETE FROM users WHERE id = ?', [req.params.id], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Account deleted successfully!' });
  });
});

module.exports = router;
