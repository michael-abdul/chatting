import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<Map<String, String>?> uploadFile(File file) async {
  try {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:3000/upload/file'),
    );

    // Faylni so'rovga qo'shish
    request.files.add(await http.MultipartFile.fromPath('files', file.path));

    // Fayl nomini bodyga qo'shish
    final filename = file.path.split('/').last; // Fayl nomini olish
    request.fields['files'] = filename; // Body qismiga qo'shish

    // So'rovni yuborish
    final response = await request.send();

    // So'rov natijasini oqish
    final responseData = await response.stream.bytesToString();

    print('Response upload data: $responseData');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(responseData); // JSON ma'lumotlarni parse qilish

      print('File uploads successfully: $data');
      return {
        'fileName': data['files'][0]['fileName'], // JSONdagi fayl nomini olish
        'fileUrl': data['files'][0]['fileUrl'],   // JSONdagi fayl URLni olish
      };
    } else {
      print('Server xatolik bilan javob qaytardi: ${response.statusCode}');
    }
  } catch (e) {
    print('Fayl yuklashda xatolik: $e');
  }
  return null;
}
