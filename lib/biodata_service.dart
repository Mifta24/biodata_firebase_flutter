import 'package:cloud_firestore/cloud_firestore.dart';

class BiodataService {
  final FirebaseFirestore db;
  
  const BiodataService(this.db);
  
  Future <String> add(Map<String, dynamic> data) async {
    // Add a new document with a generated id.
    final document = await db.collection('biodata').add(data);
    // Return the document id
    return document.id;
  }

  Future <void> update(String id, Map<String, dynamic> data) async {
    // Update the document with the given id
    await db.collection('biodata').doc(id).update(data);
  }

  Future <void> delete(String id) async {
    // Delete the document with the given id
    await db.collection('biodata').doc(id).delete();
  }

  Stream <QuerySnapshot<Map<String, dynamic>>> getBiodata() {
    // Get the collection of biodata
    return db.collection('biodata').snapshots();
  }

}