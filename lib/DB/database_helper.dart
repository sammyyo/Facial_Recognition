import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabaseHelper {
  final CollectionReference faceCollection =
      FirebaseFirestore.instance.collection('faces'); // Collection reference

  // Inserts data into Firestore
  Future<void> insert(Map<String, dynamic> row) async {
    await faceCollection.add(row);
  }

  // Retrieve all documents in the 'faces' collection
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    QuerySnapshot querySnapshot = await faceCollection.get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Count the number of documents in the 'faces' collection
  Future<int> queryRowCount() async {
    QuerySnapshot querySnapshot = await faceCollection.get();
    return querySnapshot.size;
  }

  // Update a document in the 'faces' collection
  Future<void> update(String id, Map<String, dynamic> row) async {
    await faceCollection.doc(id).update(row);
  }

  // Delete a document from the 'faces' collection
  Future<void> delete(String id) async {
    await faceCollection.doc(id).delete();
  }
}