import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/services/app_user.dart';
import '../auth/services/auth_networking.dart';

class ConnectionsNetworking {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<AppUser>> loadConnections() async {
    try {
      String currentUserId = _auth.currentUser?.uid ?? '';

      QuerySnapshot connectionsSnapshot = await _firestore
          .collection('connections')
          .where(Filter.or(Filter('accepted', isEqualTo: currentUserId),
              Filter('sent', isEqualTo: currentUserId)))
          .get();

      List<String> connectedUserIds = connectionsSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data['accepted'] == currentUserId
            ? data['sent'] as String
            : data['accepted'] as String;
      }).toList();

      List<AppUser> connections =
          await Future.wait(connectedUserIds.map((userId) async {
        Map<String, dynamic>? userDoc =
            await AuthNetworking().getUserDocument(userId);
        AppUser user = AppUser.fromJson(userDoc!);
        user.id = userId;
        return user;
      }));

      return connections;
    } catch (error) {
      print("Error loading connections: $error");
      throw error;
    }
  }
}
