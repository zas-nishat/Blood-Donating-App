import 'package:url_launcher/url_launcher.dart';

void makePhoneCall(String phoneNumber) async {
  final url = 'tel:$phoneNumber';
  // ignore: deprecated_member_use
  if (await canLaunch(url)) {
    // ignore: deprecated_member_use
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
