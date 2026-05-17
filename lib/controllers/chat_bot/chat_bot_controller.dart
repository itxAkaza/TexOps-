import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/screens/chat_bot/models/chat_message.dart';
import 'package:texops/screens/chat_bot/services/chat_bot_service.dart';

class ChatBotController extends GetxController {
  final TextEditingController promptController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;

  final List<String> suggestions = <String>[
    'What is GSM in Fabric',
    'Difference between Cotton and Polyester',
    'How to care for Silk Fabric',
  ];

  final String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> sendMessage([String? value]) async {
    final String text = (value ?? promptController.text).trim();
    if (text.isEmpty || isLoading.value) return;

    messages.add(
      ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ),
    );
    promptController.clear();
    isLoading.value = true;
    _scrollToBottom();

    try {
      final List<Map<String, String>> history = messages
          .sublist(0, messages.length - 1)
          .map((ChatMessage message) => message.toHistoryMap())
          .toList();

      final String reply = await ChatBotService.sendMessage(
        message: text,
        sessionId: _sessionId,
        history: history,
      );

      messages.add(
        ChatMessage(
          text: reply,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } catch (_) {
      messages.add(
        ChatMessage(
          text: 'Sorry, I could not connect. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } finally {
      isLoading.value = false;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void onClose() {
    promptController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
