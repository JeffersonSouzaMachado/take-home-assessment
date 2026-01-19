// Mock analytics data for assessment
const mockAnalytics = {
getOverview: () => {
  const cap = 2500000000000 + (Math.random() - 0.5) * 100000000000; // +-100B
  const vol = 85000000000 + (Math.random() - 0.5) * 10000000000;   // +-10B

  const solPrice = 98.25 + (Math.random() - 0.5) * 2;  // +-2
  const solChange = 5.3 + (Math.random() - 0.5) * 1;   // +-1

  const ethPrice = 2650.75 + (Math.random() - 0.5) * 50; // +-50
  const ethChange = -1.2 + (Math.random() - 0.5) * 1;    // +-1

  return {
    totalMarketCap: cap,
    totalVolume24h: vol,
    activeMarkets: 1250 + Math.floor((Math.random() - 0.5) * 10),
    topGainer: { symbol: 'SOL/USD', change: solChange, price: solPrice },
    topLoser: { symbol: 'ETH/USD', change: ethChange, price: ethPrice },
    marketDominance: { btc: 42.5, eth: 28.3, others: 29.2 },
    lastUpdated: new Date().toISOString()
  };
},


  getTrends: (timeframe) => {
    const trends = [];
    const now = Date.now();
    const hours = timeframe === '24h' ? 24 : timeframe === '7d' ? 168 : 720;
    const interval = hours / 20;

    for (let i = 19; i >= 0; i--) {
      const timestamp = now - (i * interval * 3600000);
      trends.push({
        timestamp: new Date(timestamp).toISOString(),
        marketCap: 2500000000000 + (Math.random() - 0.5) * 100000000000,
        volume: 85000000000 + (Math.random() - 0.5) * 10000000000,
        priceIndex: 100 + (Math.random() - 0.5) * 5
      });
    }

    return {
      timeframe,
      data: trends,
      summary: {
        change: (Math.random() - 0.5) * 10,
        volatility: Math.random() * 5 + 2
      }
    };
  },

getSentiment: () => {
  // score 0..100 com leve variação
  const score = Math.round(73 + (Math.random() - 0.5) * 10); // 68..78
  const fearGreedIndex = Math.round(67 + (Math.random() - 0.5) * 12); // 61..73

  // helper: clamp 0..100
  const clamp = (n) => Math.max(0, Math.min(100, n));

  // Cria 3 partes que somam 100 (positivo/neutro/negativo)
  const makeSplit = (basePos, baseNeu) => {
    const pos = clamp(Math.round(basePos + (Math.random() - 0.5) * 10));
    const neu = clamp(Math.round(baseNeu + (Math.random() - 0.5) * 10));
    let neg = 100 - pos - neu;

    // se estourar, ajusta para caber
    if (neg < 0) neg = 0;
    const sum = pos + neu + neg;
    // normaliza caso tenha sum != 100 por clamp/ajustes
    const fix = 100 - sum;
    return { positive: pos + fix, neutral: neu, negative: neg };
  };

  const newsSentiment = makeSplit(62, 25);
  const socialSentiment = makeSplit(58, 30);

  let overallSentiment = 'Neutral';
  if (score >= 70) overallSentiment = 'Bullish';
  else if (score <= 40) overallSentiment = 'Bearish';

  return {
    overallSentiment,
    score,
    fearGreedIndex,
    newsSentiment,
    socialSentiment,
    lastUpdated: new Date().toISOString(),
  };
},


};

module.exports = { mockAnalytics };
