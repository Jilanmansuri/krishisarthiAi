const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const helmet = require('helmet');
const compression = require('compression');
const path = require('path');
require('dotenv').config();
const connectDB = require('./config/db');

const app = express();
const PORT = process.env.PORT || 5000;

// Connect to MongoDB
connectDB();

// Middleware
app.use(helmet({
  contentSecurityPolicy: false, // Turn off CSP if it interferes with frontend during migration
}));
app.use(compression());
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));


// Routes - Trigger nodemon restart 2
const authRoute = require('./routes/auth');
const recommendationRoute = require('./routes/recommendations');
const soilLabsRoute = require('./routes/soilLabs');
const schemesRoute = require('./routes/schemes');
const voiceAssistantRoute = require('./routes/voiceAssistant');
const profitAnalysisRoute = require('./routes/profitAnalysis');
const soilRoute = require('./routes/soil');
const weatherRoute = require('./routes/weather');
const diseaseRoute = require('./routes/disease');

// Use routes
app.use('/api/auth', authRoute);
app.use('/api/recommendations', recommendationRoute);
app.use('/api/soil-labs', soilLabsRoute);
app.use('/api/schemes', schemesRoute);
app.use('/api/voice-assistant', voiceAssistantRoute);
app.use('/api/ai', voiceAssistantRoute); // Alias for voice-assistant as requested
app.use('/api/profit-analysis', profitAnalysisRoute);
app.use('/api/soil', soilRoute);
app.use('/api/weather', weatherRoute);
app.use('/api/disease', diseaseRoute);

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'Server is running', timestamp: new Date().toISOString() });
});


// Base endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'KrishiSaarthi AI - Smart Farming Advisor API',
    version: '1.0.0',
    endpoints: {
      health: '/api/health',
      recommendations: '/api/recommendations/get',
      soilLabs: '/api/soil-labs/:state',
      schemes: '/api/schemes/list'
    }
  });
});


// Serve static assets in production
if (process.env.NODE_ENV === 'production') {
  // Set static folder
  app.use(express.static(path.join(__dirname, '../frontend/build')));

  app.get('*', (req, res) => {
    res.sendFile(path.resolve(__dirname, '../frontend', 'build', 'index.html'));
  });
} else {
  // 404 handler for development (otherwise, static serving + SPA route handles it in production)
  app.use((req, res) => {
    res.status(404).json({ error: 'Endpoint not found' });
  });
}

// Start server
app.listen(PORT, () => {
  console.log(`\n🚀 KrishiSaarthi AI Server running on http://localhost:${PORT}`);
  console.log(`📡 Environment: ${process.env.NODE_ENV || 'development'}`);
});

module.exports = app;
