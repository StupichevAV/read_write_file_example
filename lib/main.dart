import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Чтение/Запись в локальный файл',
      home: ReadWriteFileExample(),
    );
  }
}

class ReadWriteFileExample extends StatefulWidget {
  const ReadWriteFileExample({Key? key}) : super(key: key);

  @override
  _ReadWriteFileExampleState createState() => _ReadWriteFileExampleState();
}

class _ReadWriteFileExampleState extends State<ReadWriteFileExample> {
  final TextEditingController _textController = TextEditingController();

  static const String kLocalFileName = 'demo_localfile.txt';
  String _localFileContent = '';
  String _localFilePath = kLocalFileName;

  @override

  void initState() {
    // При запуске приложения получаем файл и читаем его
    super.initState();
    _readTextFromLocalFile();
    //Получаем путь
    _getLocalFile.then((file) => setState(() => _localFilePath = file.path));
  }

  @override
  Widget build(BuildContext context) {
    FocusNode textFieldFocusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Чтение/Запись в локальный файл'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          const Text('Запись в локальный файл', style: TextStyle(fontSize: 20)),
          TextField(
            focusNode: textFieldFocusNode,
            controller: _textController,
            maxLines: null,
            style: const TextStyle(fontSize: 20)
          ),
          ButtonBar(
            children: <Widget>[
              MaterialButton(
                  child: const Text('Загрузить', style: TextStyle(fontSize: 20)),
                  onPressed: () async {
                    _readTextFromLocalFile();
                    _textController.text = _localFileContent;
                    // Фокусируемся в текстовом поле
                    FocusScope.of(context).requestFocus(textFieldFocusNode);
                    // Запишем лог в файл
                    log('Строка успешно загрузилась из локального файла');
                  },
              ),
              MaterialButton(
                child: const Text('Сохранить', style: TextStyle(fontSize: 20)),
                onPressed: () async {
                  _writeTextToLocalFile(_textController.text);
                  _textController.clear();
                  await _readTextFromLocalFile();
                  // Запишем лог в файл
                  log('Строка успешно записана в локальноый файл');
                },
              ),
            ],
          ),
          const Divider(height: 20.0,),
          Text('Локальный путь:', style: Theme.of(context).textTheme.caption),
          Text(_localFilePath, style: Theme.of(context).textTheme.subtitle1),
          const Divider(height: 20.0,),
          Text('Содержание локального файла:', style: Theme.of(context).textTheme.caption),
          Text(_localFileContent, style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
    );
  }

  Future<String> get _getLocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
// Ссылка на наш локальный файл
  Future<File> get _getLocalFile async {
    final path = await _getLocalPath;
    return File('$path/$kLocalFileName');
  }

  // Метод записи данных в файл
  Future<File> _writeTextToLocalFile(String text) async {
    final file = await _getLocalFile;
    return file.writeAsString(text);
  }

  // Метод чтения данных из файла
  Future _readTextFromLocalFile() async {
    String content;
    try {
      final file = await _getLocalFile;
      content = await file.readAsString();
    } catch(e) {
      content = 'Ошибка загрузки локального файла: $e';
    }
    // После чтения файла нам нужно обновить пользовательский интерфейс
    setState(() {
      _localFileContent = content;
    });

  }
}

