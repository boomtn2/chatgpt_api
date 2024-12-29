import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sidebarx/sidebarx.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'model.dart';
import 'openai_helper.dart';
import 'supbase_helper.dart';

class Controller {
  final supabase = Supabase.instance.client;
  Function updateView;
  Controller({required this.updateView});

  TextEditingController idTextController = TextEditingController();
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController authorTextController = TextEditingController();
  TextEditingController typeTextController = TextEditingController();

  //format yyyy-month-day hh:mm:ss
  TextEditingController publicdateTextController = TextEditingController();
  TextEditingController imageTextController = TextEditingController();
  // TextEditingController sourceTextController = TextEditingController();

  TextEditingController categoryTextController = TextEditingController();

  SidebarXController controllerSlideBar = SidebarXController(selectedIndex: 0);

  final maskFormatterDateTime = MaskTextInputFormatter(
    mask: '####-##-## ##:##:##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  String error = '';
  String? errorID;
  String? errorTitle;
  String? contentYear = CodeContenYear.HienDai.name;
  String? source = CodeSource.internet_archive.name;

  Truyen? truyen;
  List? embedding;
  String? _stEmbedding;
  String? get stEmbedding => _stEmbedding ?? embedding?.toString();

  final ScrollController scrollControllerTable = ScrollController();

  void init() {
    controllerSlideBar.addListener(_listenerSlidebar);
  }

  int indexTab = 0;

  void _listenerSlidebar() {
    final newIndex = controllerSlideBar.selectedIndex;
    if (indexTab != newIndex) {
      indexTab = newIndex;
      updateView();
    }
    print(indexTab);
  }

  void insertTruyen() async {
    if (idTextController.text.isEmpty) {
      errorID = 'Chua nhap ID';
      updateView();
      return;
    } else {
      errorID = null;
    }

    if (titleTextController.text.isEmpty) {
      errorTitle = 'Chua nhap title';
      updateView();
      return;
    } else {
      errorTitle = null;
    }

    truyen = Truyen(
        id: idTextController.text,
        title: titleTextController.text,
        author: authorTextController.text,
        contextYear: contentYear,
        description: descriptionTextController.text,
        source: source,
        type: typeTextController.text,
        imageBanner: imageTextController.text,
        publicdate: publicdateTextController.text,
        embedding: embedding?.toString());

    if (truyen?.description == null && truyen?.description?.isEmpty == true) {
      error = 'nhập mô tả';
      updateView();
      return;
    }

    try {
      await SupbaseHelper.insert(truyen!, supabase);
    } catch (e) {
      error = e.toString();
      updateView();
    }
  }

  void addLike() async {
    final data = await supabase
        .rpc('add_live', params: {'id_truyen': 'an-theo-thuo-o-theo-thoi.sna'});

    print(data);
  }

  final openaiHelper = OpenaiHelper();

  bool progressGenerateEmbedding = false;

  void generateEmbedding() async {
    embedding = null;
    progressGenerateEmbedding = true;
    updateView();
    final response =
        await openaiHelper.getEmbedding(descriptionTextController.text);
    embedding = response;
    if (response == null) {
      error = 'embedding rỗng lỗi api';
    }
    progressGenerateEmbedding = false;

    updateView();
  }

  List<CategoryEmbedding> listCategoryEmbedding = [];

  void categoryEmbedding() async {
    await supabase
        .from('category_embedding')
        .select('*')
        .isFilter('embedding', null)
        .withConverter(
      (data) {
        for (var element in data) {
          listCategoryEmbedding.add(CategoryEmbedding(name: element['name']));
        }
      },
    );
  }

  void updateCategoryEmbedding() async {
    for (var item in listCategoryEmbedding) {
      final response = await openaiHelper.getEmbedding(item.name);
      if (response != null) {
        await supabase
            .from('category_embedding')
            .update({'embedding': response}).eq('name', item.name);
        print(item.name);
      }
    }
  }

  List<String> category = [];

  bool progressFillCategory = false;

  void fillCategory() async {
    progressFillCategory = true;
    updateView();
    category.clear();
    String porm = categoryTextController.text;

    if (porm.isNotEmpty) {
      List<String> list = porm.split(',');
      for (String item in list) {
        final response = await openaiHelper.getEmbedding(item);

        if (response != null) {
          final list =
              await SupbaseHelper.getRelatedCategory(response, supabase);
          category.addAll(list);
          updateView();
        }
      }
    } else {
      error = 'Chua nhap the loai';
      updateView();
    }
    progressFillCategory = false;
    updateView();
  }

  List<Truyen> list = [];

  void getTruyenFillCategory() async {
    list = await SupbaseHelper.getTruyenFillCategory(['kiem_hiep'], supabase);
    updateView();
  }

  void delete() {}

  void update() {}

  void selectItemTable(Truyen truyen) {
    idTextController.text = truyen.id;
    titleTextController.text = truyen.title;
    descriptionTextController.text = truyen.description ?? '';
    authorTextController.text = truyen.author ?? '';
    typeTextController.text = truyen.type ?? '';
    publicdateTextController.text = truyen.publicdate ?? '';

    if (truyen.contextYear?.contains('Không xác định') == true) {
      contentYear = CodeContenYear.KhongXacDinh.name;
    } else {
      contentYear = truyen.contextYear ?? CodeContenYear.HienDai.name;
    }

    source = truyen.source ?? CodeSource.internet_archive.name;
    imageTextController.text = truyen.imageBanner ?? '';
    _stEmbedding = truyen.embedding;
    updateView();
  }

  void clear() {
    idTextController.text = '';
    titleTextController.text = '';
    descriptionTextController.text = '';
    authorTextController.text = '';
    typeTextController.text = '';
    publicdateTextController.text = '';

    contentYear = CodeContenYear.KhongXacDinh.name;

    source = CodeSource.internet_archive.name;
    imageTextController.text = '';
    categoryTextController.text = '';
    category = [];
    _stEmbedding = null;
    embedding = null;
    updateView();
  }
}
