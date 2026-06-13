const express = require('express');
const cors = require('cors');
const path = require('path');
const app = express();

app.use(cors());
app.use(express.json());

// Serve uploaded images as static files
// Access via: http://localhost:3000/uploads/filename.jpg
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

app.use('/auth', require('./Routes/auth.routes'));
app.use('/jobs', require('./Routes/job.routes'));
app.use('/users', require('./Routes/user.routes'));
app.use('/applications', require('./Routes/application.routes'));

app.listen(3000, () => {
  console.log('HireHive server running on port 3000');
});
