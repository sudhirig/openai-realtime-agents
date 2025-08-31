// Simple test to verify OpenAI API connection
const fetch = require('node-fetch');

async function testConnection() {
  try {
    console.log('Testing OpenAI API connection...');
    
    const response = await fetch('http://localhost:3000/api/session');
    const data = await response.json();
    
    if (data.client_secret?.value) {
      console.log('✅ API connection working - ephemeral key generated');
      console.log('Key length:', data.client_secret.value.length);
      return true;
    } else {
      console.log('❌ API connection failed:', data);
      return false;
    }
  } catch (error) {
    console.log('❌ Connection test failed:', error.message);
    return false;
  }
}

testConnection();
