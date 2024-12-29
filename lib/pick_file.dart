import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<void> pickAndReadFile(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['txt'],
  );

  if (result != null && context.mounted) {
    String filePath = result.files.single.path!;
    String content = await File(filePath).readAsString();
    showDialog(
      context: context,
      builder: (context) => Material(
        child: AlertDialog(
          title: const Text('Nội dung file'),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'))
          ],
        ),
      ),
    );
  }
}
