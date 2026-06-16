const { GoogleGenAI } = require('@google/genai');

class GeminiService {
  constructor() {
    this.apiKey = process.env.GEMINI_API_KEY;
    if (this.apiKey) {
      this.ai = new GoogleGenAI({ apiKey: this.apiKey });
    } else {
      console.log('[Gemini] GEMINI_API_KEY is not defined in environment variables.');
    }
  }

  async generateResponse(systemPrompt, userMessage, temperature = 0.3) {
    if (!this.apiKey) {
      throw new Error('GEMINI_API_KEY is not defined in environment variables.');
    }

    if (!this.ai) {
      this.ai = new GoogleGenAI({ apiKey: this.apiKey });
    }

    const response = await this.ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: userMessage,
      config: {
        systemInstruction: systemPrompt,
        temperature: temperature,
      }
    });

    if (response.text) {
      return response.text;
    }
    throw new Error('Unexpected Gemini API response structure or empty response text');
  }
}

const geminiServiceInstance = new GeminiService();

console.log('[Gemini] Service initialized. API key present:', !!process.env.GEMINI_API_KEY);

module.exports = geminiServiceInstance;
