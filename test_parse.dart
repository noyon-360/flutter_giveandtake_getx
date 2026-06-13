 import 'dart:convert';
import 'dart:io';

void main() async {
  try {
    final res = Process.runSync('curl', ['-s', 'https://test.evpitch.com/api/v1/countries']);
    final Map<String, dynamic> data = jsonDecode(res.stdout);
    final countryList = data['data'] as List<dynamic>? ?? [];
    print('Found count: ${countryList.length}');
  } catch(e) {
    print('Error: $e');
  }
}
