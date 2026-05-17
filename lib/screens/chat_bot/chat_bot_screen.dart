import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:texops/controllers/chat_bot/chat_bot_controller.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_responsive_text.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/app_bar_with_back.dart';
import 'package:texops/screens/chat_bot/models/chat_message.dart';
import 'package:texops/screens/chat_bot/widgets/chat_suggestion_card.dart';
import 'package:texops/screens/chat_bot/widgets/prompt_area.dart';
import 'package:texops/screens/chat_bot/widgets/send_icon_button.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatBotController controller = Get.isRegistered<ChatBotController>()
        ? Get.find<ChatBotController>()
        : Get.put(ChatBotController());

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      appBar: AppBarWithBack(
        title: 'Bobbin AI',
        trailingWidget: CircleAvatar(
          backgroundColor: AppColors.accentOrange,
          child: const Text('AK', style: TextStyle(color: AppColors.cardWhite)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 35),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.gps5,
                            size: 100,
                            color: AppColors.primaryDarkTeal,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Meet Bobbin, Textile AI Expert',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: AppColors.primaryDarkTeal,
                          ),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: QualityResponsiveText(
                          text:
                              'Lab Assistant, ready to help with formulas,\n care, GSM, weaves and more ',
                          style: TextStyle(color: AppColors.textGrey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: QualityResponsiveText(
                          text: 'Start with a topic',
                          style: TextStyle(
                            color: AppColors.primaryDarkTeal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            ChatSuggestionCard(
                              title: controller.suggestions[0],
                              leadingIcon: Icons.grid_3x3,
                              onTap: () => controller.sendMessage(
                                controller.suggestions[0],
                              ),
                            ),
                            const SizedBox(height: 10),
                            ChatSuggestionCard(
                              title: controller.suggestions[1],
                              leadingIcon: Icons.layers_outlined,
                              onTap: () => controller.sendMessage(
                                controller.suggestions[1],
                              ),
                            ),
                            const SizedBox(height: 10),
                            ChatSuggestionCard(
                              title: controller.suggestions[2],
                              leadingIcon: Icons.handshake_outlined,
                              onTap: () => controller.sendMessage(
                                controller.suggestions[2],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: controller.messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final ChatMessage message = controller.messages[index];
                  return _buildMessageBubble(message);
                },
              );
            }),
          ),
          Obx(
            () => controller.isLoading.value
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryDarkTeal,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Bobbin AI is thinking...',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: PromptArea(
                        controller: controller.promptController,
                        onSubmitted: (_) => controller.sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SendIconButton(
                      onTap: controller.sendMessage,
                      isDisabled: controller.isLoading.value,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryDarkTeal,
              child: Text(
                'B',
                style: TextStyle(
                  color: AppColors.cardWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppColors.primaryDarkTeal
                    : AppColors.cardWhite,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(message.isUser ? 18 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser
                      ? AppColors.cardWhite
                      : AppColors.primaryDarkTeal,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
