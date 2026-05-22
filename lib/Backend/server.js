const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

// Routes
const jobRoutes = require('./Routes/jobs');
const userRoutes = require('./Routes/user');

app.use('/api/jobs', jobRoutes);
app.use('/api/users', userRoutes);

app.listen(3000, () => {
  console.log('Server running on port 3000');
});