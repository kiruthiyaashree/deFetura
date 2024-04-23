import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/models/user_models.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection("Users").add(user.toJson());
    } catch (error) {
      print("Error creating user: $error");
      rethrow; // Rethrow the error to handle it in the calling code
    }
  }
  Future<List<UserModel>> getUsers() async {
    try {
      // Query Firestore to retrieve all user documents
      final querySnapshot = await _db.collection('Users').get();

      // Convert query snapshot to a list of UserModel objects
      final List<UserModel> users = querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();

      return users;
    } catch (error) {
      // Handle error appropriately (e.g., logging, error reporting, etc.)
      throw error;
    }
  }

  Future<UserModel?> loginUser(String email, String password) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection("Users")
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: password)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve user data from Firestore and cast it to Map<String, dynamic>
        Map<String, dynamic> userData = (querySnapshot.docs.first.data() as Map<
            String,
            dynamic>);
        String name = userData['name'];
        // UserModel user = UserModel.fromMap(userData);
        UserModel user = UserModel(name: name,email: email,password: password);
        // Create a UserModel object from retrieved data
        return user;
      } else {
        // Return null if no user found with matching credentials
        return null;
      }
    } catch (error) {
      print("Login error: $error");
      return null;
    }
  }
}