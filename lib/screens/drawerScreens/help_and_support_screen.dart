import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:texops/resources/colors/app_colors.dart'; // Adjust path if needed

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});


  Future<void> _launchPhone() async
  {
    final Uri url = Uri.parse('tel:03366553121');
    if (!await launchUrl(url)) {
      Get.snackbar('Error', 'Could not open phone dialer');
    }
  }

  Future<void> _launchEmail() async
  {
    final Uri url = Uri.parse('mailto:team@glitch.com?subject=TexOps%20ERP%20Support%20Request');
    if (!await launchUrl(url)) {
      Get.snackbar('Error', 'Could not open email client');
    }
  }

  Future<void> _launchWhatsApp() async
  {

    final Uri url = Uri.parse('https://wa.me/923366553121');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication))
    {
      Get.snackbar('Error', 'Could not open WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDarkTeal),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Help & Support",
          style: TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Need Immediate Help?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDarkTeal)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionCard(icon: Icons.phone_outlined, title: "Call\nAdmin", onTap: _launchPhone),
                _buildActionCard(icon: Icons.mail_outline, title: "Email\nIT", onTap: _launchEmail),
                _buildActionCard(icon: Icons.chat_bubble_outline, title: "WhatsApp", onTap: _launchWhatsApp),
              ],
            ),

            const SizedBox(height: 30),

            const Text("Frequently Asked Questions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDarkTeal)),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: const [
                  FaqTile(
                    question: "How do I scan a Bale QR Code?",
                    answer: "Open the side drawer and select 'Scan'. Point your device's camera at the bale's QR tag to instantly view its inventory and quality status.",
                  ),
                  Divider(height: 1, color: Colors.black12),
                  FaqTile(
                    question: "Why can't I edit Gate Pass data?",
                    answer: "Core Gate Pass logistics (like Arrival Time and Gate ID) are locked once generated to maintain strict inventory integrity. You may only edit specific physical metrics.",
                  ),
                  Divider(height: 1, color: Colors.black12),
                  FaqTile(
                    question: "What do Lab Test statuses mean?",
                    answer: "'Pending Check' means the bale is awaiting lab analysis. 'Completed' or 'Passed' indicates that detailed metrics for Fibre, Yarn, or Fabric have been securely logged.",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text("Guides & Resources", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDarkTeal)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.primaryDarkTeal.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.code, color: AppColors.primaryDarkTeal),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Developed by", style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                          Text("Team Glitch", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryDarkTeal)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTeamMember("Muhammad Abdullah", "Lead Developer"),
                  const SizedBox(height: 10),
                  _buildTeamMember("Muhammad Ali", "Core Engineer"),
                  const SizedBox(height: 10),
                  _buildTeamMember("Muhammad Ibrahim", "UI/UX & Engineering"),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Center(
              child: Text(
                "TexOps ERP v1.0.0\nTerms of Service | Privacy Policy",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12, height: 1.5),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primaryDarkTeal, size: 28),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.primaryDarkTeal, fontSize: 13, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role) {
    return Row(
      children: [
        const Icon(Icons.person_outline, size: 16, color: AppColors.accentOrange),
        const SizedBox(width: 10),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDarkTeal, fontSize: 14)),
      ],
    );
  }
}

class FaqTile extends StatefulWidget {
  final String question;
  final String answer;

  const FaqTile({super.key, required this.question, required this.answer});

  @override
  State<FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<FaqTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => isExpanded = !isExpanded),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDarkTeal, fontSize: 14),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
                  color: AppColors.textGrey,
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  widget.answer,
                  style: const TextStyle(color: AppColors.textGrey, fontSize: 13, height: 1.5),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}