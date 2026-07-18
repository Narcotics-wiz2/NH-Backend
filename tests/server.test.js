const test = require('node:test');
const assert = require('node:assert/strict');

process.env.STRIPE_SECRET_KEY = '';
process.env.PAYPAL_CLIENT_ID = '';
process.env.PAYPAL_CLIENT_SECRET = '';
process.env.PORT = '0';

const { app } = require('../index.js');

test('health endpoint responds without payment secrets configured', async () => {
  const server = app.listen(0);

  try {
    await new Promise((resolve, reject) => {
      server.once('listening', resolve);
      server.once('error', reject);
    });

    const address = server.address();
    const response = await fetch(`http://127.0.0.1:${address.port}/health`);
    const body = await response.json();

    assert.equal(response.status, 200);
    assert.equal(body.status, 'ok');
  } finally {
    await new Promise((resolve, reject) => {
      server.close((err) => (err ? reject(err) : resolve()));
    });
  }
});
