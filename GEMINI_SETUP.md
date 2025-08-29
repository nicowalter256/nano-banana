# Gemini AI Integration Setup

This Flutter project now includes Google's Gemini AI integration for generative AI features.

## Files Created

1. **`lib/gemini_service.dart`** - Core service class for Gemini AI integration
2. **`lib/gemini_example_widget.dart`** - Example Flutter widget demonstrating the integration
3. **`GEMINI_SETUP.md`** - This setup guide

## Setup Instructions

### 1. Get a Gemini API Key

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy your API key (it starts with "AIza...")

### 2. Configure the API Key

**Option A: Update the service directly**

- Open `lib/gemini_service.dart`
- Replace `'YOUR_GEMINI_API_KEY'` on line 6 with your actual API key

**Option B: Use the app's UI (Recommended)**

- Run the app
- Enter your API key in the setup screen
- Click "Save API Key"

### 3. Run the App

```bash
flutter run
```

## Features

The Gemini integration includes:

### Text Generation

- Generate text responses to any prompt
- Creative content generation (stories, poems, etc.)
- Code generation in various programming languages
- Text analysis and insights

### Chat Functionality

- Maintain conversation context
- Chat history tracking
- Session management

### Helper Functions

- Pre-built prompt templates
- Easy-to-use helper methods
- Error handling and validation

## Usage Examples

### Basic Text Generation

```dart
final geminiService = GeminiService();
final response = await geminiService.generateText('Tell me about Flutter');
```

### Code Generation

```dart
final code = await geminiService.generateCode(
  'a function that sorts a list of numbers',
  'Dart'
);
```

### Creative Content

```dart
final story = await geminiService.generateCreativeContent(
  'A robot learning to paint',
  'short story'
);
```

### Text Analysis

```dart
final analysis = await geminiService.analyzeText(
  'Your text here',
  'sentiment'
);
```

## API Key Security

⚠️ **Important Security Notes:**

1. **Never commit your API key to version control**
2. **Use environment variables or secure storage in production**
3. **Consider using a backend service to proxy API calls**

For production apps, consider:

- Using `flutter_dotenv` for environment variables
- Implementing secure key storage with `flutter_secure_storage`
- Creating a backend service to handle API calls

## Dependencies Added

- `google_generative_ai: ^0.4.7` - Official Google Generative AI SDK
- `http: ^1.1.0` - HTTP client for API requests

## Troubleshooting

### Common Issues

1. **"API key not configured"**

   - Make sure you've entered a valid API key
   - Check that the key starts with "AIza"

2. **Network errors**

   - Ensure you have internet connectivity
   - Check if the Gemini API is available in your region

3. **Rate limiting**
   - The free tier has usage limits
   - Consider upgrading for higher limits

### Getting Help

- [Google AI Studio Documentation](https://ai.google.dev/docs)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Google Generative AI Dart Package](https://pub.dev/packages/google_generative_ai)

## Next Steps

1. **Customize the UI** - Modify the example widget to match your app's design
2. **Add more features** - Implement image generation, multi-modal content, etc.
3. **Optimize performance** - Add caching, request batching, etc.
4. **Add error handling** - Implement retry logic and better error messages
5. **Security improvements** - Move API key handling to a secure backend

## Example Prompts to Try

- "Write a haiku about programming"
- "Create a Dart function that validates email addresses"
- "Explain quantum computing in simple terms"
- "Generate a short story about time travel"
- "Analyze the sentiment of this text: 'I love this new app!'"
