import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'contact.dart';

class OpenBox {
  static List<Box> boxList = [];

  static Future<List<Box>> openBox() async {
    var contacts = await Hive.openBox('contacts');
    var favorites = await Hive.openBox<Contact>('favoritesBox');
    boxList.add(contacts);
    boxList.add(favorites);
    return boxList;
  }

  static Future<void> registerAdapter() async {
    WidgetsFlutterBinding.ensureInitialized();
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter(ContactAdapter());
  }
}
