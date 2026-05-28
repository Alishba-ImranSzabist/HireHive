const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const db = require('../db');

// Freelancer: Apply for a job
router.post('/', auth, (req, res) => {
  const { job_id } = req.body;
  const freelancer_id = req.user.id;

  db.query(
    'SELECT * FROM applications WHERE job_id = ? AND freelancer_id = ?',
    [job_id, freelancer_id],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      if (results.length > 0) return res.status(400).json({ message: 'You have already applied for this job.' });

      db.query(
        'INSERT INTO applications (job_id, freelancer_id) VALUES (?, ?)',
        [job_id, freelancer_id],
        (err, result) => {
          if (err) return res.status(500).json({ error: err.message });
          res.status(201).json({ message: 'Apply successfully!', id: result.insertId });
        }
      );
    }
  );
});

// Freelancer: Meri applications
router.get('/my', auth, (req, res) => {
  const freelancer_id = req.user.id;
  db.query(
    `SELECT a.id, a.status, a.created_at,
            j.title as job_title, j.budget, j.posted_by
     FROM applications a
     JOIN jobs j ON a.job_id = j.id
     WHERE a.freelancer_id = ?
     ORDER BY a.created_at DESC`,
    [freelancer_id],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(results);
    }
  );
});

// Client: Apni jobs ki applications — client_id se match
router.get('/client', auth, (req, res) => {
  const client_id = req.user.id;
  db.query(
    `SELECT a.id, a.status, a.created_at,
            j.title as job_title, j.id as job_id,
            u.name as freelancer_name, u.email as freelancer_email, u.id as freelancer_id
     FROM applications a
     JOIN jobs j ON a.job_id = j.id
     JOIN users u ON a.freelancer_id = u.id
     WHERE j.client_id = ?
     ORDER BY a.created_at DESC`,
    [client_id],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(results);
    }
  );
});

// Client: Accept or Reject
router.put('/:id', auth, (req, res) => {
  const { status } = req.body;
  db.query(
    'UPDATE applications SET status = ? WHERE id = ?',
    [status, req.params.id],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: `Application ${status}!` });
    }
  );
});

module.exports = router;
