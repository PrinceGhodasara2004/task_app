import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoDecryptPlayer extends StatefulWidget {
  const VideoDecryptPlayer({super.key});
  @override
  State<VideoDecryptPlayer> createState() => _VideoDecryptPlayerState();
}

class _VideoDecryptPlayerState extends State<VideoDecryptPlayer> {
  VideoPlayerController? _controller;
  bool _loading = false;

  // AES key and IV must be same as encryption script
  final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32 chars
  final _iv = encrypt.IV.fromUtf8('8bytesiv12345678'); // 16 chars

  Future<void> _pickAndPlayEncryptedVideo() async {
    setState(() {
      _loading = true;
    });

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['enc'],
    );

    if (result == null) {
      // User cancelled picking file
      setState(() {
        _loading = false;
      });
      return;
    }

    final encryptedFile = File(result.files.single.path!);
    final encryptedBytes = await encryptedFile.readAsBytes();

    final encrypter = encrypt.Encrypter(encrypt.AES(_key));

    try {
      // Decrypt bytes
      final decryptedBytes =
          encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: _iv);

      // Save decrypted video temporarily to cache directory
      final tempDir = await getTemporaryDirectory();
      final decryptedFilePath = '${tempDir.path}/decrypted_video.mp4';
      final decryptedFile = File(decryptedFilePath);
      await decryptedFile.writeAsBytes(decryptedBytes);

      // Initialize VideoPlayerController with decrypted file
      _controller?.dispose();
      _controller = VideoPlayerController.file(decryptedFile);

      await _controller!.initialize();
      await _controller!.setLooping(false);
      await _controller!.play();

      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Decryption failed or invalid file: $e')),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Encrypted Video Player')),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _controller != null && _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : const Text('Pick and play an encrypted .enc video'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loading ? null : _pickAndPlayEncryptedVideo,
        child: const Icon(Icons.video_file),
      ),
    );
  }
}
