import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(RandomRabbitApp());
}

class RandomRabbitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Rabbit App',
       theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), // モダンなカラースキーム
    useMaterial3: true, // Material Design 3を有効に
    textTheme: TextTheme(
      bodyMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500), // テキストのデザイン
    ),
  ),
  home: RabbitHomePage(),
    );
  }
}

class RabbitHomePage extends StatefulWidget {
  @override
  _RabbitHomePageState createState() => _RabbitHomePageState();
}

class _RabbitHomePageState extends State<RabbitHomePage> {
  String currentImage = '';
  final String apiKey = 'your API key'; // Pixabay APIキーをここに入力

  @override
  void initState() {
    super.initState();
    _fetchRandomImage();
  }

  Future<void> _fetchRandomImage() async {
    final url = Uri.parse('https://pixabay.com/api/?key=$apiKey&q=rabbit&image_type=photo&per_page=100');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final images = data['hits'];
        if (images.isNotEmpty) {
          final randomImage = (images..shuffle()).first;
          setState(() {
            currentImage = randomImage['webformatURL'];
          });
        } else {
          throw Exception('No images found');
        }
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error fetching image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Rabbit App'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade100, // 上側の色
              Colors.teal.shade700, // 下側の色
            ],
            begin: Alignment.topCenter, // グラデーションの開始位置
            end: Alignment.bottomCenter, // グラデーションの終了位置
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              currentImage.isNotEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          currentImage,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 50,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : CircularProgressIndicator(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchRandomImage,
                child: Text('Show Another Rabbit!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
