import 'package:dio/dio.dart';

class ChatBotService {
  static const String _baseUrl = 'https://flutter-n8n.app.n8n.cloud';
  static const String _webhookPath = '/webhook/chatbot';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    ),
  );

  static Future<String> sendMessage({
    required String message,
    required String sessionId,
    required List<Map<String, String>> history,
  }) async {
    try {
      final response = await _dio.post(
        _webhookPath,
        data: {
          'message': message,
          'session_id': sessionId,
          'history': history,
        },
      );

      final data = response.data;
      if (data is Map) {
        final reply = data['reply'] ?? data['output'];
        if (reply is String && reply.trim().isNotEmpty) {
          return reply;
        }
      }
      return 'No response received.';
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}
