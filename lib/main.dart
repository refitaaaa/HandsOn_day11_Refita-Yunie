import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'products.dart'; // pastikan file ini ada di folder lib/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Display JSON, Audio & Video Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- Audio Player ---
  final AudioPlayer _player = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;

  // --- Video Player ---
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();

    // Listener untuk audio
    _player.onPlayerStateChanged.listen((state) {
      setState(() => _playerState = state);
    });

    // Inisialisasi video
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
    )
      ..initialize().then((_) {
        setState(() => _isVideoInitialized = true);
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _player.dispose();
    _videoController.dispose();
    super.dispose();
  }

  // --- Fungsi Audio ---
  Future<void> _playFromUrl() async {
    await _player.play(
      UrlSource('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    );
  }

  Future<void> _playFromAsset() async {
    await _player.play(AssetSource('audios/SoundHelix-Song-2.mp3'));
  }

  Future<void> _pause() async => await _player.pause();
  Future<void> _stop() async => await _player.stop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎬 Audio, Video & Produk')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              '🎵 Play Audio Demo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Tombol kontrol audio
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _playFromUrl, child: const Text('Play URL')),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _playFromAsset, child: const Text('Play Asset')),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _playerState == PlayerState.playing ? _pause : null,
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _stop, child: const Text('Stop')),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 2),

            // Bagian Video
            const Text(
              '🎥 Video Player Demo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _isVideoInitialized
                ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                : const CircularProgressIndicator(),

            const SizedBox(height: 24),
            const Divider(thickness: 2),

            // Bagian Produk JSON
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '📦 Product List',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(
              height: 300, // supaya scroll bisa terlihat
              child: ProductPage(),
            ),
          ],
        ),
      ),
    );
  }
}
