import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final speechText = SpeechToText();
  final translator = GoogleTranslator();
  String text = "Hold the btn and start speaking";
  var isListening = false;
  String whatLang = 'en';
  _translator(String en) async {
    final translated = await translator.translate(text, to: en, from: whatLang);
    setState(() {
      text = translated.text;
    });
  }

  void startListening() async {
    if (!isListening) {
      var available = await speechText.initialize();
      if (available) {
        setState(() {
          isListening = true;
          speechText.listen(
            onResult: (result) {
              setState(() {
                text = result.recognizedWords;
              });
            },
          );
        });
      }
    }
  }

  void stopListening() {
    setState(() {
      isListening = false;
    });
    speechText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: chooseLang(context)),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          physics: const BouncingScrollPhysics(),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: GestureDetector(
        onTapDown: (details) {
          startListening();
        },
        onTapUp: (details) {
          stopListening();
        },
        child: !isListening
            ? const CircleAvatar(child: Icon(Icons.mic))
            : const CircleAvatar(child: Icon(Icons.stop)),
      ),
    );
  }

  DropdownButton chooseLang(BuildContext context) => DropdownButton(
      underline: const SizedBox.shrink(),
      icon: const Icon(
        Icons.translate,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      onChanged: (value) {
        _translator(value);
        whatLang = value;
      },
      items: const [
        DropdownMenuItem(
          value: 'en',
          child: Text(
            'EN',
          ),
        ),
        DropdownMenuItem(
          value: 'ru',
          child: Text(
            'RU',
          ),
        ),
        DropdownMenuItem(
          value: 'ky',
          child: Text('KG'),
        ),
        DropdownMenuItem(
          value: 'ar',
          child: Text('AR'),
        ),
      ],
      selectedItemBuilder: (context) {
        return [
          const Text(
            'EN',
          ),
          const Text(
            'RU',
          ),
          const Text(
            'KG',
          ),
          const Text(
            'AR',
          ),
        ];
      });
}
