const jwt = require('jsonwebtoken');
const SECRET = "hirehive_secret_key";

module.exports = (req, res, next) => {
  const header = req.headers['authorization'];
  if (!header) return res.status(401).json({ message: 'No token!' });
  const token = header.split(' ')[1];
  try {
    req.user = jwt.verify(token, SECRET);
    next();
  } catch (e) {
    return res.status(401).json({ message: 'Invalid token!' });
  }
};
