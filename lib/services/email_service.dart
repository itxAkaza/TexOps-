import 'dart:convert';

import 'package:http/http.dart' as http;

class EmailService {
  // Your EmailJS Service ID
  static const _serviceId = 'service_me48bep';

  // The Template ID you confirmed from the dashboard list
  static const _templateId = 'template_7k8wscn';

  // Your Public Key
  static const _publicKey = 'TETv5WMyVtiKS601A';

  /// Sends login credentials to new employees for the TexOps project.
  static Future<bool> sendCredentials({
    required String toEmail,
    required String name,
    required String employeeId,
    required String generatedEmail,
    required String password,
  }) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Origin': 'http://localhost',
        },
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': {
            'to_email': toEmail,
            'to_name': name,
            'employee_id': employeeId,
            'login_email': generatedEmail,
            'password': password,
          },
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
