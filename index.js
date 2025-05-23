const express = require('express');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

app.use(express.static(path.join(__dirname, 'public')));

app.get('/healthz', (req, res) => {
  res.send('ok');
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
