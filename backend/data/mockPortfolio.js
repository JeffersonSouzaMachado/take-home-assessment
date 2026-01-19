// Mock portfolio data for assessment
let holdings = [
  {
    id: '1',
    symbol: 'BTC/USD',
    quantity: 0.5,
    averagePrice: 42000.00,
    currentPrice: 43250.50,
    value: 21625.25,
    pnl: 625.25,
    pnlPercent: 2.98,
    allocation: 45.2
  },
  {
    id: '2',
    symbol: 'ETH/USD',
    quantity: 5.0,
    averagePrice: 2700.00,
    currentPrice: 2650.75,
    value: 13253.75,
    pnl: -246.25,
    pnlPercent: -1.82,
    allocation: 27.7
  },
  {
    id: '3',
    symbol: 'SOL/USD',
    quantity: 100.0,
    averagePrice: 95.00,
    currentPrice: 98.25,
    value: 9825.00,
    pnl: 325.00,
    pnlPercent: 3.42,
    allocation: 20.5
  },
  {
    id: '4',
    symbol: 'ADA/USD',
    quantity: 5000.0,
    averagePrice: 0.50,
    currentPrice: 0.52,
    value: 2600.00,
    pnl: 100.00,
    pnlPercent: 4.00,
    allocation: 5.4
  }
];

let transactions = [
  {
    id: '1',
    type: 'buy',
    symbol: 'BTC/USD',
    quantity: 0.5,
    price: 42000.00,
    timestamp: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString()
  },
  {
    id: '2',
    type: 'buy',
    symbol: 'ETH/USD',
    quantity: 5.0,
    price: 2700.00,
    timestamp: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString()
  },
  {
    id: '3',
    type: 'buy',
    symbol: 'SOL/USD',
    quantity: 100.0,
    price: 95.00,
    timestamp: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString()
  },
  {
    id: '4',
    type: 'buy',
    symbol: 'ADA/USD',
    quantity: 5000.0,
    price: 0.50,
    timestamp: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString()
  }
];

const mockPortfolio = {
getSummary: () => {
  mockPortfolio.getHoldings();

  const totalValue = holdings.reduce((sum, h) => sum + h.value, 0);
  const totalPnl = holdings.reduce((sum, h) => sum + h.pnl, 0);

  const totalCost = totalValue - totalPnl;
  const totalPnlPercent = totalCost === 0 ? 0 : (totalPnl / totalCost) * 100;

  return {
    totalValue: totalValue.toFixed(2),
    totalPnl: totalPnl.toFixed(2),
    totalPnlPercent: totalPnlPercent.toFixed(2),
    totalHoldings: holdings.length,
    lastUpdated: new Date().toISOString(),
  };
},


getHoldings: () => {
  holdings = holdings.map((holding) => {
    const randomFactor = 1 + (Math.random() - 0.5) * 0.001;
    const currentPrice = holding.currentPrice * randomFactor;

    const value = holding.quantity * currentPrice;
    const pnl = (currentPrice - holding.averagePrice) * holding.quantity;
    const pnlPercent = holding.averagePrice === 0 ? 0 : ((currentPrice - holding.averagePrice) / holding.averagePrice) * 100;

    return {
      ...holding,
      currentPrice,
      value,
      pnl,
      pnlPercent,
      lastUpdated: new Date().toISOString(),
    };
  });

  const totalValue = holdings.reduce((sum, h) => sum + h.value, 0);
  holdings = holdings.map((h) => ({
    ...h,
    allocation: totalValue === 0 ? 0 : (h.value / totalValue) * 100,
  }));

  return holdings;
},


  getPerformance: (timeframe) => {
    const days = timeframe === '7d' ? 7 : timeframe === '30d' ? 30 : 90;
    const data = [];
    const now = Date.now();

    for (let i = days; i >= 0; i--) {
      const timestamp = now - (i * 24 * 60 * 60 * 1000);
      const baseValue = 45000;
      const variation = (Math.random() - 0.5) * 0.05;
      data.push({
        timestamp: new Date(timestamp).toISOString(),
        value: baseValue * (1 + variation),
        pnl: (baseValue * variation).toFixed(2),
        pnlPercent: (variation * 100).toFixed(2)
      });
    }

    return {
      timeframe,
      data,
      summary: {
        startValue: data[0].value.toFixed(2),
        endValue: data[data.length - 1].value.toFixed(2),
        totalReturn: ((data[data.length - 1].value - data[0].value) / data[0].value * 100).toFixed(2)
      }
    };
  },

addTransaction: (transaction) => {
  const newTransaction = {
    id: (transactions.length + 1).toString(),
    ...transaction,
    quantity: Number(transaction.quantity),
    price: Number(transaction.price),
  };

  transactions.push(newTransaction);

  const { type, symbol, quantity, price } = newTransaction;

  const idx = holdings.findIndex((h) => h.symbol === symbol);

  if (type === 'buy') {
    if (idx >= 0) {
      const h = holdings[idx];
      const oldQty = Number(h.quantity);
      const oldAvg = Number(h.averagePrice);

      const newQty = oldQty + quantity;
      const newAvg = ((oldQty * oldAvg) + (quantity * price)) / newQty;

      holdings[idx] = {
        ...h,
        quantity: newQty,
        averagePrice: newAvg,
      };
    } else {
      holdings.push({
        id: (holdings.length + 1).toString(),
        symbol,
        quantity,
        averagePrice: price,
        currentPrice: price,
        value: quantity * price,
        pnl: 0,
        pnlPercent: 0,
        allocation: 0,
        lastUpdated: new Date().toISOString(),
      });
    }
  }

  if (type === 'sell') {
    if (idx >= 0) {
      const h = holdings[idx];
      const oldQty = Number(h.quantity);
      const newQty = oldQty - quantity;

      if (newQty <= 0) {
        holdings.splice(idx, 1);
      } else {
        holdings[idx] = { ...h, quantity: newQty };
      }
    }
  }

  return newTransaction;
},

};

module.exports = { mockPortfolio };
