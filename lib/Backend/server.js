const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

app.use('/auth', require('./Routes/auth.routes'));
app.use('/jobs', require('./Routes/job.routes'));
app.use('/users', require('./Routes/user.routes'));
app.use('/applications', require('./Routes/application.routes'));

app.listen(3000, () => {
  console.log('Server running on port 3000');
});
