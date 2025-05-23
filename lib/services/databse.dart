import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userDetails, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userDetails);
  }
}
