import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage {
  static final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  static Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref('test').listAll();
    results.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });
    results.prefixes.forEach((firebase_storage.Reference ref) {
      print('Found directory: $ref.name');
    });
    return results;
  }
}
