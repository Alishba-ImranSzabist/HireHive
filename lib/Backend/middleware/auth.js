const jwt = require('jsonwebtoken');
const SECRET = "hirehive_secret_key_2024";

module.exports = (req, res, next) => {
  const header = req.headers['authorization'];
  if (!header) return res.status(401).json({ message: 'Access denied. No token provided!' });

  const parts = header.split(' ');
  if (parts.length !== 2 || parts[0] !== 'Bearer') {
    return res.status(401).json({ message: 'Token format must be: Bearer <token>' });
  }

  const token = parts[1];
  try {
    const decoded = jwt.verify(token, SECRET);
    req.user = decoded; // { id, role, iat, exp }
    next();
  } catch (e) {
    if (e.name === 'TokenExpiredError') {
      return res.status(401).json({ message: 'Token expired. Please login again!' });
    }
    return res.status(401).json({ message: 'Invalid token!' });
  }
};
