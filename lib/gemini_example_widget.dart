import 'package:flutter/material.dart';
import 'gemini_service.dart';

/// Example widget demonstrating Gemini AI integration
class GeminiExampleWidget extends StatefulWidget {
  const GeminiExampleWidget({super.key});

  @override
  State<GeminiExampleWidget> createState() => _GeminiExampleWidgetState();
}

class _GeminiExampleWidgetState extends State<GeminiExampleWidget> {
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();

  String _response = '';
  bool _isLoading = false;
  bool _showApiKeyInput = false;
  String? _selectedModel;

  @override
  void initState() {
    super.initState();
    _checkApiKey();
    _selectedModel = _geminiService.currentModel;
  }

  void _checkApiKey() {
    if (!_geminiService.isConfigured()) {
      setState(() {
        _showApiKeyInput = true;
      });
    }
  }

  void _onModelChanged(String? newModel) {
    if (newModel != null) {
      setState(() {
        _selectedModel = newModel;
      });
      _geminiService.changeModel(newModel);
      _showSnackBar('Model changed to: $newModel');
    }
  }

  Future<void> _generateText() async {
    if (_promptController.text.trim().isEmpty) {
      _showSnackBar('Please enter a prompt');
      return;
    }

    setState(() {
      _isLoading = true;
      _response = '';
    });

    try {
      final result = await _geminiService.generateText(_promptController.text);
      setState(() {
        _response = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _generateCode() async {
    if (_promptController.text.trim().isEmpty) {
      _showSnackBar('Please enter a code description');
      return;
    }

    setState(() {
      _isLoading = true;
      _response = '';
    });

    try {
      final result = await _geminiService.generateCode(
        _promptController.text,
        'Dart',
      );
      setState(() {
        _response = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _generateCreativeContent() async {
    if (_promptController.text.trim().isEmpty) {
      _showSnackBar('Please enter a creative prompt');
      return;
    }

    setState(() {
      _isLoading = true;
      _response = '';
    });

    try {
      final result = await _geminiService.generateCreativeContent(
        _promptController.text,
        'story',
      );
      setState(() {
        _response = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _updateApiKey() {
    if (_apiKeyController.text.trim().isNotEmpty) {
      _geminiService.updateApiKey(_apiKeyController.text.trim());
      setState(() {
        _showApiKeyInput = false;
      });
      _showSnackBar('API key updated successfully');
    } else {
      _showSnackBar('Please enter a valid API key');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini AI Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // API Key Input Section
            if (_showApiKeyInput) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Setup Required',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please enter your Gemini API key to get started:',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _apiKeyController,
                        decoration: const InputDecoration(
                          labelText: 'Gemini API Key',
                          border: OutlineInputBorder(),
                          hintText: 'Enter your API key here',
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _updateApiKey,
                        child: const Text('Save API Key'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Model Selection Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select AI Model:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedModel,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Choose Model',
                      ),
                      items: _geminiService.models.map((String model) {
                        return DropdownMenuItem<String>(
                          value: model,
                          child: Text(model),
                        );
                      }).toList(),
                      onChanged: _onModelChanged,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current Model: ${_selectedModel ?? 'None selected'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Prompt Input Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter your prompt:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _promptController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'What would you like to generate?',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _generateText,
                            child: const Text('Generate Text'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _generateCode,
                            child: const Text('Generate Code'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : _generateCreativeContent,
                            child: const Text('Creative Story'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Response Section
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Response:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if (_isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _response.isEmpty
                                  ? 'Generated response will appear here...'
                                  : _response,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }
}
