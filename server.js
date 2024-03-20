const express = require('express');
const app = express();
const path = require('path');
const cors = require('cors');

const port = 4046;

// Define the directory to serve static files
const publicDirectoryPath = path.join(__dirname, 'public');

// Middleware to serve static files
app.use(express.static(publicDirectoryPath));

// Middleware to enable CORS
app.use(cors());

// Start the server
app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
});
