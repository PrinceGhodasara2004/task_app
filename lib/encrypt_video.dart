// encrypt_video.dart
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;

void main() async {
  final inputPath = 'sample.mp4';  // This file must be here
  final outputPath = 'sample_encrypted.enc';

  final inputFile = File(inputPath);
  if (!inputFile.existsSync()) {
    print('❌ sample.mp4 not found!');
    return;
  }

  final videoBytes = await inputFile.readAsBytes();

  final key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
  final iv = encrypt.IV.fromUtf8('8bytesiv12345678');
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  final encrypted = encrypter.encryptBytes(videoBytes, iv: iv);
  await File(outputPath).writeAsBytes(encrypted.bytes);

  print('✅ Encrypted file saved: $outputPath');
}
