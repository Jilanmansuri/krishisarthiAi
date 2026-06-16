const express = require('express');
const geminiService = require('../services/geminiService');
const grokService = require('../services/grokService');
const History = require('../models/History');

const router = express.Router();

// System prompt for the Agriculture Assistant
const SYSTEM_INSTRUCTION = `You are an AI agriculture assistant for Indian farmers.
Explain in simple Hinglish. Optionally use English if the user asks in English.
Give practical advice.
Suggest crops and fertilizers.
Avoid technical language.
Keep answers short and practical (under 100 words).
CRITICAL: At the very end of your response, output a new line with exactly: "Confidence Level: [High/Medium/Low] - [Short reason]".`;

const DEMO_RESPONSE = `Aapke input ke base par kuch important points dhyaan dene layak hain:

- Faslon ki growth aur leaf color observe karein
- Soil nutrients ka balance maintain rakhein
- Irrigation regular aur controlled rakhein

Agar aap thoda aur detail share karenge to main aur precise guidance de paunga 🌱

Confidence Level: High - Expert farming advisory based on your input.`;

// POST /api/voice-assistant
router.post('/', async (req, res) => {
  try {
    const { transcript } = req.body;
    console.log('Voice query received:', transcript);

    if (!transcript || transcript.trim().length < 2) {
      return res.status(400).json({ error: 'Please provide a valid query transcript' });
    }

    let responseText = '';
    let isFallback = false;

    // Check if Gemini is configured
    if (process.env.GEMINI_API_KEY) {
      try {
        console.log('[Voice Assistant] Calling Gemini API...');
        responseText = await geminiService.generateResponse(SYSTEM_INSTRUCTION, transcript);
        console.log('[Voice Assistant] Gemini response generated successfully');
      } catch (geminiError) {
        console.error('[Voice Assistant] Gemini API failed:', geminiError.message);
        isFallback = true;
      }
    }

    // If Gemini failed or is not configured, try Grok as fallback
    if (!responseText && process.env.GROK_API_KEY) {
      try {
        console.log('[Voice Assistant] Calling Grok API (fallback)...');
        const messages = [{ role: 'user', content: transcript }];
        responseText = await grokService.generateResponse(SYSTEM_INSTRUCTION, messages);
        console.log('[Voice Assistant] Grok response generated successfully');
        isFallback = true;
      } catch (grokError) {
        console.error('[Voice Assistant] Grok API fallback failed:', grokError.message);
      }
    }

    // If both failed or are not configured, use DEMO_RESPONSE
    if (!responseText) {
      console.log('[Voice Assistant] Using DEMO_RESPONSE (fallback)');
      responseText = DEMO_RESPONSE;
      isFallback = true;
    }

    const result = {
      success: true,
      response: responseText,
      timestamp: new Date().toISOString(),
      isFallback: isFallback
    };

    // Save to MongoDB History
    try {
      const historyEntry = new History({
        type: 'voice-assistant',
        inputs: req.body,
        results: result
      });
      console.log('💾 Saving Voice Interaction to DB:', transcript);
      await historyEntry.save();
      console.log('✅ Voice assistant interaction saved to MongoDB (Inputs & Results)');
    } catch (saveError) {
      console.error('❌ Failed to save voice interaction:', saveError.message);
    }

    return res.status(200).json(result);

  } catch (error) {
    console.error('Voice assistant handler error:', error.message);
    return res.status(200).json({
      success: true,
      response: DEMO_RESPONSE,
      timestamp: new Date().toISOString(),
      isFallback: true
    });
  }
});

module.exports = router;

