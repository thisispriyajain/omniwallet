import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static Future<Map<String, dynamic>?> getUserPreferences(String userId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (docSnapshot.exists) {
        return docSnapshot.data()?['preferences'] as Map<String, dynamic>?;
      }
    } catch (e) {
      print('Error fetching user preferences: $e');
    }
    return null;
  }
}