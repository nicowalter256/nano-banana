import 'package:google_generative_ai/google_generative_ai.dart';

/// Service class for integrating Google's Gemini AI
class GeminiService {
  static const String _apiKey =
      'AIzaSyDW-AxBGMh51ll9jV7g8cJn4NCOU7gCv9A'; // Replace with your actual API key
  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  GeminiService() {
    _initializeModel();
  }

  /// Initialize the Gemini model
  void _initializeModel() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
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
    return _apiKey != 'YOUR_GEMINI_API_KEY';
  }

  /// Update API key
  void updateApiKey(String newApiKey) {
    // Note: In a real app, you'd want to store this securely
    // and reinitialize the model
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
