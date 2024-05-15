import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/models/customer_details_model.dart';
import 'package:get/get.dart';

class CustomerDetailsRepository extends GetxController {
  static CustomerDetailsRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addCustomerDetails(CustomerDetailsModel customerDetailsModel) async {
    try {
      await _db.collection("customerDetails").add(customerDetailsModel.toJson());
    } catch (error) {
      print("Error creating user: $error");
      rethrow; // Rethrow the error to handle it in the calling code
    }
  }

  Future<CustomerDetailsModel?> getCustomerDetails(String customerName) async {
    try {
      final snapshot = await _db.collection("customerDetails").where('name', isEqualTo: customerName).get();
      if (snapshot.docs.isNotEmpty) {
        return CustomerDetailsModel.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (error) {
      print("Error retrieving customer details: $error");
      rethrow;
    }
  }

  Future<bool> checkCustomerDetailsExist(String customerName) async {
    try {
      final snapshot = await _db.collection("customerDetails").where('name', isEqualTo: customerName).get();
      return snapshot.docs.isNotEmpty; // Return true if any document exists with the given customerName
    } catch (error) {
      print("Error checking customer details existence: $error");
      throw error;
    }
  }
  Future<String?> getCustomerCity(String customerName) async {
    try {
      final snapshot = await _db.collection("customerDetails").where('name', isEqualTo: customerName).get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.get('city') as String?;
      }
      return null;
    } catch (error) {
      print("Error retrieving customer city: $error");
      rethrow;
    }
  }

  Future<String?> getCustomerEmail(String customerName) async {
    try {
      final snapshot = await _db.collection("customerDetails").where('name', isEqualTo: customerName).get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.get('email') as String?;
      }
      return null;
    } catch (error) {
      print("Error retrieving customer email: $error");
      rethrow;
    }
  }
}
