import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service class for integrating Google's Gemini AI
class GeminiService {
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  late GenerativeModel _model;
  late ChatSession _chatSession;
  String _currentModel = 'gemini-2.5-flash';

  // Available Gemini models
  static const List<String> availableModels = [
    'gemini-2.5-flash',
    'gemini-1.5-flash',
    'gemini-1.5-pro',
    'gemini-1.0-pro',
    'gemini-1.0-pro-vision',
  ];

  GeminiService() {
    _initializeModel();
  }

  /// Get the currently selected model
  String get currentModel => _currentModel;

  /// Get list of available models
  List<String> get models => availableModels;

  /// Initialize the Gemini model
  void _initializeModel() {
    _initializeModelWithName(_currentModel);
  }

  /// Initialize the Gemini model with a specific model name
  void _initializeModelWithName(String modelName) {
    _model = GenerativeModel(
      model: modelName,
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );
    _chatSession = _model.startChat();
  }

  /// Change the model
  void changeModel(String modelName) {
    if (availableModels.contains(modelName)) {
      _currentModel = modelName;
      _initializeModelWithName(modelName);
    }
  }

  /// Generate text using Gemini AI
  ///
  /// [prompt] - The input text prompt
  /// Returns a Future<String> with the generated response
  Future<String> generateText(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text != null) {
        return response.text!;
      } else {
        return 'No response generated';
      }
    } catch (e) {
      return 'Error generating text: $e';
    }
  }

  /// Send a message in the chat session
  ///
  /// [message] - The message to send
  /// Returns a Future<String> with the chat response
  Future<String> sendChatMessage(String message) async {
    try {
      final response = await _chatSession.sendMessage(Content.text(message));

      if (response.text != null) {
        return response.text!;
      } else {
        return 'No response from chat';
      }
    } catch (e) {
      return 'Error in chat: $e';
    }
  }

  /// Generate creative content (stories, poems, etc.)
  ///
  /// [prompt] - The creative prompt
  /// [contentType] - Type of content to generate
  /// Returns a Future<String> with the generated content
  Future<String> generateCreativeContent(
    String prompt,
    String contentType,
  ) async {
    final enhancedPrompt =
        '''
Generate a $contentType based on the following prompt:
$prompt

Please make it creative, engaging, and well-structured.
''';

    return await generateText(enhancedPrompt);
  }

  /// Generate code based on a description
  ///
  /// [description] - Description of the code to generate
  /// [language] - Programming language (e.g., 'Dart', 'Python', 'JavaScript')
  /// Returns a Future<String> with the generated code
  Future<String> generateCode(String description, String language) async {
    final codePrompt =
        '''
Generate $language code for the following:
$description

Please provide:
1. Clean, well-commented code
2. Brief explanation of the solution
3. Any important notes or considerations
''';

    return await generateText(codePrompt);
  }

  /// Analyze text and provide insights
  ///
  /// [text] - Text to analyze
  /// [analysisType] - Type of analysis (e.g., 'sentiment', 'summary', 'key_points')
  /// Returns a Future<String> with the analysis
  Future<String> analyzeText(String text, String analysisType) async {
    final analysisPrompt =
        '''
Please provide a $analysisType analysis of the following text:

$text

Focus on providing clear, actionable insights.
''';

    return await generateText(analysisPrompt);
  }

  /// Reset the chat session
  void resetChat() {
    _chatSession = _model.startChat();
  }

  /// Get chat history
  Iterable<Content> getChatHistory() {
    return _chatSession.history;
  }

  /// Check if the service is properly configured
  bool isConfigured() {
    return _apiKey.isNotEmpty;
  }

  /// Update API key
  void updateApiKey(String newApiKey) {
    // Note: In a real app, you'd want to store this securely
    // For now, we'll update the environment variable
    dotenv.env['GEMINI_API_KEY'] = newApiKey;
    _initializeModel();
  }
}

/// Example usage and helper functions
class GeminiHelpers {
  /// Create a simple text generation prompt
  static String createSimplePrompt(String topic) {
    return 'Tell me about $topic in a simple and engaging way.';
  }

  /// Create a coding prompt
  static String createCodingPrompt(String feature, String language) {
    return 'Create a $language function that $feature';
  }

  /// Create a creative writing prompt
  static String createCreativePrompt(String genre, String theme) {
    return 'Write a short $genre story with the theme of $theme';
  }

  /// Create an analysis prompt
  static String createAnalysisPrompt(String text, String focus) {
    return 'Analyze this text focusing on $focus: $text';
  }
}
