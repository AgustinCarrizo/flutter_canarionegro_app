import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationFMC {
  sennotification() async {
    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAW9y1Pzk:APA91bEq0h8nqgjYtlTEWlCRpDNPuoY-H83dAFl7143PPtCKvLfgV83EeL5aZ2TNKI94ov2hwcj3jZvnIhMTWNvwRMRvjUA6OSzyg_mN1acXkYWsLft3_wsN1DEv8Zv6qQFMpV6lzWk9',
    };
      var data = {
        'condition': '\'admins\' in topics ',
        'data': {
          'via': 'FlutterFire Cloud Messaging!!!',
          'count': 1,
        },
        'notification': {
          'title': 'Nueva Orden',
          'body': 'Revisa tienes una nueva orden',
        },
      };
    await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );
  }
}
