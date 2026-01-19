const express = require('express');
const cors = require('cors');
const http = require('http');
const WebSocket = require('ws');
const { marketDataController } = require('./controllers/marketDataController');
const { analyticsController } = require('./controllers/analyticsController');
const { portfolioController } = require('./controllers/portfolioController');
const { errorHandler } = require('./middlewares/errorHandler');
const { requestLogger } = require('./middlewares/requestLogger');
const { rateLimiter } = require('./middlewares/rateLimiter');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(requestLogger);
app.use(rateLimiter);

// Routes
app.use('/api/market-data', marketDataController);
app.use('/api/analytics', analyticsController);
app.use('/api/portfolio', portfolioController);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.use(errorHandler);

const server = http.createServer(app);

const wss = new WebSocket.Server({ server });

wss.on('connection', (ws) => {
  console.log('WebSocket client connected');
  const symbols = ['BTC/USD', 'ETH/USD', 'SOL/USD', 'ADA/USD'];


  const makeUpdate = (symbol) => ({
    type: 'market_update',
    data: {
      symbol,
      price: (100 + Math.random() * 1000).toFixed(2),
      change24h: (Math.random() * 10 - 5).toFixed(2),
      volume: (100000000 + Math.random() * 2000000000).toFixed(0),
      timestamp: new Date().toISOString(),
    },
  });

  for (const s of symbols) {
    if (ws.readyState === WebSocket.OPEN) {
      ws.send(JSON.stringify(makeUpdate(s)));
    }
  }

  let idx = 0;
  const interval = setInterval(() => {
    const symbol = symbols[idx % symbols.length];
    idx++;

    const update = makeUpdate(symbol);

    if (ws.readyState === WebSocket.OPEN) {
      ws.send(JSON.stringify(update));
    }
  }, 2000);

  ws.on('close', () => {
    console.log('WebSocket client disconnected');
    clearInterval(interval);
  });

  ws.on('error', (error) => {
    console.error('WebSocket error:', error);
    clearInterval(interval);
  });
});


server.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
  console.log(`WebSocket server ready on ws://localhost:${PORT}`);
});
