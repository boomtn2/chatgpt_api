import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tool_merge_file/extentions.dart';
import 'package:tool_merge_file/screens/home.dart';
import 'controller.dart';
import 'model.dart';
import 'screens/chatgpt.dart';
import 'supbase_helper.dart';

void main() async {
  await Supabase.initialize(
      url: SupbaseHelper.supabaseUrl, anonKey: SupbaseHelper.supabaseKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Controller controller;

  void updateView() {
    setState(() {});
  }

  @override
  void initState() {
    controller = Controller(updateView: () {
      updateView();
    });
    controller.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.indexTab == 0) {
      return _supabaseClient();
    } else if (controller.indexTab == 1) {
      return _chatGpt();
    } else if (controller.indexTab == 2) {
      return Scaffold(
        body: Row(
          children: [_slideBar(), const Expanded(child: Home())],
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: Text('Chua dinh nghia'),
        ),
      );
    }
  }

  Widget _chatGpt() {
    return Scaffold(
      body: Row(
        children: [
          _slideBar(),
          Expanded(child: ChatGptTranslate()),
        ],
      ),
    );
  }

  Widget _supabaseClient() {
    return Scaffold(
      body: Row(
        children: [
          _slideBar(),
          Expanded(
            child: Column(
              children: [
                _button(),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      controller.error.isNotEmpty
                          ? Text(
                              controller.error,
                              style: const TextStyle(color: Colors.red),
                            )
                          : const SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: _textInput(),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          color: Colors.black,
                          height: 1,
                        ),
                      ),
                      const Center(
                          child: Text(
                        'TÌM KIẾM',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          color: Colors.black,
                          height: 1,
                        ),
                      ),
                      20.sh,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          20.sw,
                          _buttonText(
                            text: 'Fetch Data',
                            onPressed: () {
                              controller.getTruyenFillCategory();
                            },
                          ),
                        ],
                      ),
                      10.sh,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Total Result: ${controller.list.length}'),
                      ),
                      _tableResponse()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _slideBar() {
    return SidebarX(
      controller: controller.controllerSlideBar,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: const TextStyle(color: Colors.white),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        // itemDecoration: BoxDecoration(
        //   border: Border.all(color: Colors.green),
        // ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [Colors.grey, Colors.black],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        margin: EdgeInsets.only(right: 10),
      ),
      footerDivider: Divider(),
      items: [
        SidebarXItem(
          icon: Icons.add,
          label: 'Insert Supbase',
          onTap: () {
            debugPrint('Hello');
          },
        ),
        const SidebarXItem(
          icon: Icons.translate,
          label: 'ChatGPT',
        ),
        const SidebarXItem(
          icon: Icons.file_copy_outlined,
          label: 'Merger File',
        ),
      ],
    );
  }

  Widget _tableResponse() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          // Cập nhật vị trí cuộn dựa trên chuyển động vuốt
          controller.scrollControllerTable.jumpTo(
            controller.scrollControllerTable.offset - details.delta.dx,
          );
        },
        child: Scrollbar(
          controller: controller.scrollControllerTable,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: controller.scrollControllerTable,
            scrollDirection: Axis.horizontal,
            child: DataTable(
              border: TableBorder.all(color: Colors.black, width: 1),
              columns: const [
                DataColumn(
                  label: Text(
                    'ID',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Embedding',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Title',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Points',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Views',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Author',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Publicdate',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Create',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Context_year',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Source',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Image_banner',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: [
                for (var item in controller.list)
                  DataRow(
                      onLongPress: () {
                        controller.selectItemTable(item);
                      },
                      cells: [
                        _customDataCell(item.id),
                        _customDataCell('${item.embedding?.substring(0, 10)}'),
                        _customDataCell(item.title),
                        _customDataCell(
                            '${item.description?.substring(0, 10)}'),
                        _customDataCell('${item.points}'),
                        _customDataCell('${item.views}'),
                        _customDataCell('${item.author}'),
                        _customDataCell('${item.type}'),
                        _customDataCell('${item.publicdate}'),
                        _customDataCell('${item.create}'),
                        _customDataCell('${item.contextYear}'),
                        _customDataCell('${item.source}'),
                        _customDataCell('${item.imageBanner}'),
                      ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  DataCell _customDataCell(String text) {
    return DataCell(
      ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 150),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
    );
  }

  Widget _button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _buttonText(
              onPressed: () {
                controller.insertTruyen();
              },
              text: 'Insert'),
          5.sw,
          _buttonText(
              onPressed: () {
                controller.delete();
              },
              text: 'Delete'),
          5.sw,
          _buttonText(
              onPressed: () {
                controller.update();
              },
              text: 'Update'),
          5.sw,
          _buttonText(
              onPressed: () {
                controller.clear();
              },
              text: 'Clear'),
        ],
      ),
    );
  }

  Widget _buttonText({required String text, GestureTapCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.black),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _textInput() {
    return Column(
      children: [
        TextField(
          controller: controller.idTextController,
          decoration: InputDecoration(
              errorText: controller.errorID,
              labelText: 'ID',
              border: const OutlineInputBorder()),
        ),
        10.sh,
        TextField(
          controller: controller.titleTextController,
          decoration: InputDecoration(
              errorText: controller.errorTitle,
              labelText: 'Title',
              border: const OutlineInputBorder()),
        ),
        10.sh,
        TextField(
          controller: controller.descriptionTextController,
          decoration: const InputDecoration(
              labelText: 'Description', border: OutlineInputBorder()),
        ),
        10.sh,
        TextField(
          controller: controller.authorTextController,
          decoration: const InputDecoration(
              labelText: 'Author', border: OutlineInputBorder()),
        ),
        10.sh,
        TextField(
          controller: controller.typeTextController,
          decoration: const InputDecoration(
              labelText: 'Type', border: OutlineInputBorder()),
        ),
        10.sh,
        TextField(
          controller: controller.publicdateTextController,
          inputFormatters: [controller.maskFormatterDateTime],
          decoration: const InputDecoration(
              labelText: 'Publicdate',
              hintText: 'yyyy-month-day hh:mm:ss',
              border: OutlineInputBorder()),
        ),
        10.sh,
        TextField(
          controller: controller.imageTextController,
          decoration: const InputDecoration(
              labelText: 'Image Banner', border: OutlineInputBorder()),
        ),
        10.sh,
        TextField(
          controller: controller.categoryTextController,
          decoration: InputDecoration(
              labelText: 'Category',
              hintText: 'VD: ngontinh, hiendai',
              suffix: controller.progressFillCategory
                  ? const SizedBox(
                      height: 20, width: 20, child: CircularProgressIndicator())
                  : _buttonText(
                      text: 'generate category',
                      onPressed: () {
                        controller.fillCategory();
                      },
                    ),
              border: const OutlineInputBorder()),
        ),
        Wrap(
          children: controller.category.map(
            (e) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(e),
              );
            },
          ).toList(),
        ),
        10.sh,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Content Year:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            5.sw,
            _dropdownContenYear(),
            40.sw,
            const Text(
              "Source:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            5.sw,
            _dropdownSource(),
          ],
        ),
        10.sh,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Embedding",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            5.sw,
            controller.progressGenerateEmbedding
                ? const SizedBox(
                    height: 20, width: 20, child: CircularProgressIndicator())
                : _buttonText(
                    onPressed: () {
                      controller.generateEmbedding();
                    },
                    text: 'Embedding',
                  ),
          ],
        ),
        Text(
          '${controller.stEmbedding}',
          maxLines: 1,
          style: const TextStyle(color: Colors.blue),
        )
      ],
    );
  }

  Widget _dropdownSource() {
    return DropdownButton<String>(
      value: controller.source,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          controller.source = value!;
        });
      },
      items:
          CodeSource.values.map<DropdownMenuItem<String>>((CodeSource value) {
        return DropdownMenuItem<String>(
          value: value.name,
          child: Text(value.name),
        );
      }).toList(),
    );
  }

  Widget _dropdownContenYear() {
    return DropdownButton<String>(
      value: controller.contentYear,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          controller.contentYear = value!;
        });
      },
      items: CodeContenYear.values
          .map<DropdownMenuItem<String>>((CodeContenYear value) {
        return DropdownMenuItem<String>(
          value: value.name,
          child: Text(value.name),
        );
      }).toList(),
    );
  }
}
