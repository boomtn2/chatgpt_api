// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tool_merge_file/extentions.dart';

import '../openai_helper.dart';

class ChatGptTranslate extends StatefulWidget {
  const ChatGptTranslate({super.key});

  @override
  State<ChatGptTranslate> createState() => _ChatGptTranslateState();
}

class _ChatGptTranslateState extends State<ChatGptTranslate> {
  final openAI = OpenaiHelper();
  List<TranslateResponse> list = [];
  TextEditingController controllerTextInput = TextEditingController();
  TextEditingController controllerTextInputNameTrung = TextEditingController();

  TextEditingController controllerTextInputNameViet = TextEditingController();

  List<String> listInput = [];
  List<String> nameTrung = [];
  List<String> nameViet = [];

  int index = 0;

  void clear() {
    list.clear();
    listInput.clear();
    nameTrung.clear();
    nameViet.clear();
  }

  int totalToken() {
    int total = 0;
    for (var element in list) {
      total += element.token;
    }
    return total;
  }

  int startIndexTranslate = 0;
  bool runTranslate = false;

  void stopTranslate() {
    setState(() {
      runTranslate = false;
    });
  }

  int getIndexInput() {
    int? index = int.tryParse(_textControllerIndexTranslate.text);
    if (index == null) {
      return 0;
    } else {
      return index;
    }
  }

  Future autoTranslate() async {
    setState(() {
      runTranslate = true;
      startIndexTranslate = getIndexInput();
    });
    for (int i = startIndexTranslate; i < listInput.length; ++i) {
      String element = listInput[i];
      String textOrigin = rename(element);

      final textTranslalte = await openAI.getTranslate(textOrigin);
      final token = textTranslalte['usage']['total_tokens'];
      final textResponse = textTranslalte['choices'];

      String text = '';
      if (textResponse is List) {
        for (var element in textResponse) {
          text += element['message']['content'];
        }
      }
      setState(() {
        startIndexTranslate = i;
        list.add(TranslateResponse(
            textOrigin: textOrigin, textTranslate: text, token: token));
      });
      await Future.delayed(const Duration(seconds: 2));

      if (runTranslate == false) {
        break;
      }
    }
  }

  Future slipText() async {
    String text = controllerTextInput.text;
    text = text.replaceAll(r'\n\n', r'\n');
    setState(() {
      listInput = splitTextIntoChunks(text, 30);
    });
    showMess('Tách chuỗi xong');
  }

  Future slipTextFile(String text) async {
    text = text.replaceAll(r'\n\n', r'\n');
    setState(() {
      listInput = splitTextIntoChunks(text, 30);
    });
    showMess('Tách chuỗi xong');
  }

  List<String> splitTextIntoChunks(String text, int linesPerChunk) {
    // Tách văn bản thành các dòng
    final textTrim = text.trim();
    final lines = textTrim.split('\n');

    // Chia thành các đoạn nhỏ với mỗi đoạn tối đa 'linesPerChunk' dòng
    List<String> chunks = [];
    for (int i = 0; i < lines.length; i += linesPerChunk) {
      chunks.add(lines
          .sublist(
              i,
              i + linesPerChunk > lines.length
                  ? lines.length
                  : i + linesPerChunk)
          .join('\n'));
    }

    return chunks;
  }

  List<String> textRegx(String text) {
    List<String> temps = [];

    RegExp regExp = RegExp(r'[^\n]+');
    temps = regExp
        .allMatches(text.trim())
        .map((match) => match.group(0)!.trim())
        .toList();

    return temps;
  }

  String rename(String text) {
    for (int i = 0; i < nameTrung.length; ++i) {
      text = text.replaceAll(nameTrung[i].trim(), nameViet[i].trim());
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _textInputData(),
            5.sh,
            _inputPathFileTXT(),
            5.sh,
            _nameWidget(),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      slipText();
                    },
                    child: const Text('Cắt chuỗi')),
                ElevatedButton(
                    onPressed: () async {
                      autoTranslate();
                    },
                    child: const Text('Translate')),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        nameTrung = textRegx(controllerTextInputNameTrung.text);
                        nameViet = textRegx(controllerTextInputNameViet.text);
                      });
                    },
                    child: const Text('Thay tên')),
              ],
            ),
            Text('Chuỗi tách${listInput.length}'),
            Text('${totalToken()}'),
            _progressTranslate(),
            _responseTranslate()
          ],
        ),
      ),
    );
  }

  TextEditingController _textControllerIndexTranslate = TextEditingController();
  TextEditingController pathFileController = TextEditingController();

  String? errorPath;

  Future<String> readFile(String path) async {
    try {
      // Kiểm tra đường dẫn và chuẩn hóa
      path = path.trim();
      final file = File(path);

      // Sử dụng phương thức bất đồng bộ để đọc tệp
      final data = await file.readAsString();

      showMess('File Success');
      setState(() {
        errorPath = null;
      });

      return data;
    } catch (e) {
      // Hiển thị lỗi chi tiết
      showMess('File Fail');
      debugPrint('Error reading file: $e');

      setState(() {
        errorPath = e.toString();
      });
      return '';
    }
  }

  showMess(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _inputPathFileTXT() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Row(
          children: [
            IconButton(
                onPressed: () async {
                  String text = await readFile(pathFileController.text);
                  if (text.isNotEmpty) {
                    slipTextFile(text);
                  }
                },
                icon: const Icon(Icons.file_download)),
            5.sw,
            Expanded(
              child: TextField(
                controller: pathFileController,
                decoration: InputDecoration(
                    hintText: 'Nhập đường dẫn file txt', errorText: errorPath),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressTranslate() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            runTranslate ? CircularProgressIndicator() : SizedBox.shrink(),
            runTranslate
                ? IconButton(
                    onPressed: () {
                      stopTranslate();
                    },
                    icon: Icon(
                      Icons.stop,
                      color: Colors.red,
                    ))
                : SizedBox.shrink(),
            SizedBox(
              width: 120,
              child: TextField(
                controller: _textControllerIndexTranslate,
                decoration: const InputDecoration(
                  hintText: 'Index translate',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép số
                ],
                keyboardType: TextInputType.number,
              ),
            ),
            Text('Tiến trình: ${startIndexTranslate}')
          ],
        ),
      ),
    );
  }

  Widget _responseTranslate() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Expanded(child: SelectableText(list[index].textOrigin)),
              10.sw,
              Expanded(child: SelectableText(list[index].textTranslate)),
            ],
          );
        },
      ),
    );
  }

  Widget _textInputData() {
    return TextField(
      controller: controllerTextInput,
      maxLines: 5, // Cho phép nhập không giới hạn số dòng
      minLines: 5, // Chiều cao tối thiểu của TextField (10 dòng)
    );
  }

  Widget _nameWidget() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              showAboutDialog(context: context, children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        nameTrung.clear();
                        nameViet.clear();
                      });
                    },
                    child: const Icon(Icons.delete)),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2,
                  height: MediaQuery.sizeOf(context).height / 2,
                  child: ListView.builder(
                    itemCount: nameTrung.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(nameTrung[index])),
                              Expanded(child: Text(nameViet[index]))
                            ],
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                        ],
                      );
                    },
                  ),
                )
              ]);
            },
            icon: const Icon(Icons.table_chart_rounded)),
        Expanded(
          child: TextField(
            maxLines: 2, // Cho phép nhập không giới hạn số dòng
            minLines: 2, // Chiều cao tối thiểu của TextField (10 dòng)
            controller: controllerTextInputNameTrung,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Tên Trung',
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controllerTextInputNameViet,
            maxLines: 2, // Cho phép nhập không giới hạn số dòng
            minLines: 2, // Chiều cao tối thiểu của TextField (10 dòng)
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Tên việt',
            ),
          ),
        ),
      ],
    );
  }
}

class TranslateResponse {
  String textOrigin;
  String textTranslate;
  int token;
  TranslateResponse({
    required this.textOrigin,
    required this.textTranslate,
    required this.token,
  });
}
