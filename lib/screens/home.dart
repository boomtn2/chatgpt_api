// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controllerText = TextEditingController();
  final controllerKytu = TextEditingController();
  final controllerKythaythe = TextEditingController();
  final controllerKytucanthaythe = TextEditingController();
  final pathFolder = TextEditingController();
  final controllerTextNameChina = TextEditingController();
  final controllerTextNameVietNam = TextEditingController();

  List<DataFile> list = [];

  void updateList(List<DataFile> listFile) {
    setState(() {
      list = listFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đọc File TXT')),
      body: ListView(
        children: [
          FileScreen(
            updateList: updateList,
            controllerPath: pathFolder,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controllerKytu,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'ký tự cần loại bỏ',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextField(
                    controller: controllerKytucanthaythe,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ký tự cần thay thế',
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: controllerKythaythe,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ký tự thay thế',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height / 3,
              width: MediaQuery.sizeOf(context).width,
              child: SingleChildScrollView(
                child: TextField(
                  controller: controllerText,
                  maxLines: null, // Cho phép nhập không giới hạn số dòng
                  minLines: 10, // Chiều cao tối thiểu của TextField (10 dòng)
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nhập nội dung ở đây...',
                  ),
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    thayDoiKyTu();
                  },
                  child: const Text('Ky tu')),
              ElevatedButton(
                  onPressed: () {
                    gopFile();
                  },
                  child: const Text('Gộp file')),
              ElevatedButton(
                  onPressed: () {
                    for (int i = 0; i < list.length; ++i) {
                      list[i] = fileKyTu(list[i]);
                    }
                  },
                  child: const Text('Xóa ký tự trong tất cả file')),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      list = [];
                    });
                  },
                  child: const Text('Clear')),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height / 3,
                    width: MediaQuery.sizeOf(context).width,
                    child: SingleChildScrollView(
                      child: TextField(
                        controller: controllerTextNameChina,
                        maxLines: null, // Cho phép nhập không giới hạn số dòng
                        minLines:
                            10, // Chiều cao tối thiểu của TextField (10 dòng)
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Tên trung',
                        ),
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          listNameChina =
                              textRegx(controllerTextNameChina.text);
                          listNameVietNam =
                              textRegx(controllerTextNameVietNam.text);
                        });
                      },
                      child: const Text('Ghép tên')),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        String path =
                            'C:/Users/PC/Desktop/auto/name/data_name.txt';
                        Map data = {};
                        try {
                          data.addAll(readFileName(path));
                        } catch (e) {
                          print('lỗi đọc file name $e');
                        }
                        for (int i = 0; i < listNameChina.length; ++i) {
                          data.addAll({listNameChina[i]: listNameVietNam[i]});
                        }
                        saveFile(path, jsonEncode(data));
                      },
                      child: const Text('Xuất file')),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        thayTen();
                      },
                      child: const Text('Thay tên File')),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        String path =
                            'C:/Users/PC/Desktop/auto/name/data_name.txt';
                        Map data = {};
                        try {
                          data.addAll(readFileName(path));
                          for (var element in data.keys) {
                            listNameChina.add('$element');
                          }

                          for (var element in data.values) {
                            listNameVietNam.add('$element');
                          }
                          setState(() {});
                        } catch (e) {
                          print('lỗi đọc file name $e');
                        }
                      },
                      child: const Text('Lấy dữ liệu từ file')),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          listNameChina = [];
                          listNameVietNam = [];
                        });
                      },
                      child: const Text('Clear')),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height / 3,
                    width: MediaQuery.sizeOf(context).width,
                    child: SingleChildScrollView(
                      child: TextField(
                        controller: controllerTextNameVietNam,
                        maxLines: null, // Cho phép nhập không giới hạn số dòng
                        minLines:
                            10, // Chiều cao tối thiểu của TextField (10 dòng)
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Tên việt',
                        ),
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          for (var item in list) Text(item.nameFile),
          for (int i = 0; i < listNameChina.length; ++i)
            Text('${listNameChina[i]} : ${listNameVietNam[i]}'),
        ],
      ),
    );
  }

  void gopFile() {
    final outputBuffer = StringBuffer();
    for (var fileData in list) {
      String text = fileData.content.replaceAll(RegExp(r'\n\s*\n'), '\n');
      outputBuffer.writeln('$text');
      print(fileData.stt);
    }

    String path = pathFolder.text.replaceAll(r'\', '/');
    path = '${path}/gop.txt';

    // Ghi nội dung vào file .txt
    final outputFile = File(path); // Thay bằng đường dẫn của bạn);
    outputFile.writeAsStringSync(outputBuffer.toString());
  }

  void thayTen() {
    for (var fileData in list) {
      String text = fileData.content;
      for (int i = 0; i < listNameChina.length; ++i) {
        text = text.replaceAll(listNameChina[i], listNameVietNam[i]);
      }
      String path = pathFolder.text.replaceAll(r'\', '/');
      path = '${path}/name_${fileData.stt}.txt';

      // Ghi nội dung vào file .txt
      final outputFile = File(path); // Thay bằng đường dẫn của bạn);
      outputFile.writeAsStringSync(text);
      print(fileData.stt);
    }
  }

  Map readFileName(String path) {
    final file = File(path);
    final data = file.readAsStringSync();
    return jsonDecode(data);
  }

  void saveFile(String path, String text) {
    // Ghi nội dung vào file .txt
    final outputFile = File(path); // Thay bằng đường dẫn của bạn);
    outputFile.writeAsStringSync(
      text,
    );
  }

  DataFile fileKyTu(DataFile fileText) {
    var unescape = HtmlUnescape();
    String text = fileText.content;
    String data = unescape.convert(text);

    if (controllerKytu.text.isNotEmpty) {
      data = data.replaceAll(controllerKytu.text, '');
    }

    if (controllerKytucanthaythe.text.isNotEmpty) {
      if (controllerKythaythe.text.isNotEmpty) {
        data = data.replaceAll(
            controllerKytucanthaythe.text, controllerKythaythe.text);
      } else {
        data = data.replaceAll(controllerKytucanthaythe.text, '\n');
      }
    }

    data = data.replaceAll(RegExp(r'<[^>]*>'), '');

    fileText.content = data;

    return fileText;
  }

  void thayDoiKyTu() {
    var unescape = HtmlUnescape();
    String text = controllerText.text;
    String data = unescape.convert(text);

    if (controllerKytu.text.isNotEmpty) {
      data = data.replaceAll(controllerKytu.text, '');
    }

    if (controllerKytucanthaythe.text.isNotEmpty) {
      if (controllerKythaythe.text.isNotEmpty) {
        data = data.replaceAll(
            controllerKytucanthaythe.text, controllerKythaythe.text);
      } else {
        data = data.replaceAll(controllerKytucanthaythe.text, '\n');
      }
    }

    data = data.replaceAll(RegExp(r'<[^>]*>'), '');

    setState(() {
      controllerText.text = data;
    });
  }

  List<String> listNameChina = [];
  List<String> listNameVietNam = [];

  List<String> textRegx(String text) {
    List<String> temps = [];

    RegExp regExp = RegExp(r'[^\n]+');
    temps =
        regExp.allMatches(text.trim()).map((match) => match.group(0)!).toList();
    return temps;
  }
}

class FileScreen extends StatefulWidget {
  const FileScreen(
      {super.key, required this.updateList, required this.controllerPath});
  final Function(List<DataFile>) updateList;
  final TextEditingController controllerPath;
  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controllerPath,
        ),
        ElevatedButton(
            onPressed: () {
              file();
            },
            child: const Text('file'))
      ],
    );
  }

  void file() {
    // Đường dẫn tới thư mục
    final directoryPath = widget.controllerPath.text
        .replaceAll(r'\', '/'); // Thay bằng đường dẫn của bạn
    print(directoryPath);
    // Hàm liệt kê tệp
    listAndSortFiles(directoryPath);
  }

  void listAndSortFiles(String path) {
    final directory = Directory(path);

    // Kiểm tra thư mục có tồn tại
    if (!directory.existsSync()) {
      print('Thư mục không tồn tại.');
      return;
    }

    // Lấy danh sách các file trong thư mục
    final files = directory.listSync();

    // Lọc các file, bỏ qua thư mục con và loại bỏ đuôi .txt
    final fileContents = files
        .whereType<File>() // Chỉ lấy các file
        .map((file) {
      // Lấy tên file
      String fileName = file.path.split(Platform.pathSeparator).last;
      String fileNameWithoutExtension =
          fileName.replaceAll('.txt', ''); // Loại bỏ .txt

      // Chuyển tên file thành số nguyên
      int fileNumber = int.tryParse(fileNameWithoutExtension) ?? 0;
      print(fileName);
      // Lấy nội dung file
      String content = file.readAsStringSync();

      // Trả về map chứa số thứ tự và nội dung file
      return DataFile(content: content, stt: fileNumber, nameFile: fileName);
    }).toList();

    // Sắp xếp danh sách theo số thứ tự tăng dần
    fileContents.sort((a, b) => a.stt.compareTo(b.stt));

    // In ra các số đã sắp xếp
    widget.updateList(fileContents);
  }
}

class DataFile {
  String content;
  int stt;
  String nameFile;
  DataFile({required this.content, required this.stt, required this.nameFile});
}
