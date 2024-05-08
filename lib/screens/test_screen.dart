import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://cloud-gaming-server.onrender.com'),
  );

  @override
  Widget build(BuildContext context) {
    StreamSubscription<dynamic> a = _channel.stream.listen((event) {
      print("Recibo: $event");
    });
    a.onData((data) {
      print("Data: $data");
    });
    a.onError((error) {
      print("Error: $error");
    });
    a.onDone(() {
      print("Done");
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            // StreamBuilder(
            //   stream: _channel.stream,
            //   builder: (context, snapshot) {
            //     print("recibo algo: ${snapshot.data}");
            //     return Text(snapshot.hasData ? '${snapshot.data}' : '');
            //   },
            // )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _sendMessage();
        },
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _sendMessage() async {
    try {
      await _channel.ready;
      print("se conecto ok");
    } on SocketException catch (e) {
      print("Error: $e");
    } on WebSocketChannelException catch (e) {
      print("Error: $e");
    }

    if (_controller.text.isNotEmpty) {
      _channel.sink.add("getUsersForGames|Cuphead");
      print("Mando");
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
