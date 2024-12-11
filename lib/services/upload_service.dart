import 'dart:convert';
import 'dart:io';
import 'package:chatting_app/utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

Future<Map<String, String>?> uploadFile(File file) async {
  try {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:3000/upload/file'),
    );

    request.files.add(await http.MultipartFile.fromPath('files', file.path));

    final filename = file.path.split('/').last;
    request.fields['files'] = filename;

    final response = await request.send();

    final responseData = await response.stream.bytesToString();

    print('Response upload data: $responseData');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(responseData);

      print('File uploads successfully: $data');
      return {
        'fileName': data['files'][0]['fileName'],
        'fileUrl': data['files'][0]['fileUrl'],
      };
    } else {
      print('Server xatolik bilan javob qaytardi: ${response.statusCode}');
    }
  } catch (e) {
    print('Fayl yuklashda xatolik: $e');
  }
  return null;
}

Future<void> downloadAndOpenFile(
    BuildContext context, String url, String fileName) async {
  try {
    final mimeType = getMimeType(fileName);
    print('Downloading file with mime type: $mimeType');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    const String baseURL = 'http://localhost:3000';
    final String filePath = '/upload/files/$fileName';
    final response = await http.get(Uri.parse('$baseURL$filePath'));
    Navigator.of(context).pop();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      print('Saving file to: ${file.path}');
      await file.writeAsBytes(response.bodyBytes);

      await OpenFile.open(file.path);
    } else {
      throw Exception('Failed to download file: ${response.reasonPhrase}');
    }
  } catch (e) {
    Navigator.of(context).pop();
    print('File download error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to download file: $e')),
    );
  }
}
