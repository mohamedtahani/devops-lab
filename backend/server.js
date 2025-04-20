const mongoose = require('mongoose');
const express = require('express');
const cors = require('cors');

const app = express();
const port = 5000;

app.use(cors());
app.use(express.json());

// Prevent Mongoose model overwriting
let Message;
try {
  Message = mongoose.model('Message');
} catch (error) {
  const messageSchema = new mongoose.Schema({ text: String });
  Message = mongoose.model('Message', messageSchema);
}

// Connect to MongoDB
const mongoUri = process.env.MONGO_URI || 'mongodb://localhost:27017/fullstackapp';
mongoose.connect(mongoUri, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('✅ Connected to MongoDB'))
  .catch(err => console.error('❌ MongoDB connection error:', err));

// Route to fetch a message
app.get('/', async (req, res) => {
  const message = await Message.findOne();
  res.send(message?.text || 'No message found');
});

app.listen(port, () => {
  console.log(`🚀 Backend running on http://localhost:${port}`);
});
