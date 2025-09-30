import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_e_commerce_app/auth/models/userModel.dart';
import 'package:flutter_e_commerce_app/data/models/cart_product.dart';
import 'package:flutter_e_commerce_app/data/models/my_order.dart';
class Firebaseservices {
  final FirebaseFirestore _firestore =FirebaseFirestore.instance;
  final FirebaseStorage _storage=FirebaseStorage.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn=GoogleSignIn.instance;
  final String orderCollection="order";
  static String customersCollection="customers";
  static String cartCollection="cart";



  Future<UserModel?> getCurrentUser()async {
    final user=_auth.currentUser;
    if(user==null) return null;
    try {
      final doc = await _firestore
          .collection(customersCollection)
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return _customerFromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get customer data: $e');
    }
  } 
      

  Future<String?> signUpWithEmailandPAssword({
    required String email,
    required String password,
  })async{
    try {
      final credential =await  _auth.createUserWithEmailAndPassword(email: email, password: password);
    if(credential.user==null){
      throw Exception('Failed to create account');
    }
    return credential.user!.uid;
    }on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  



  Future<UserModel?> createUserProfile( 
    {
     required UserModel user
    }
  )async{
    // File file=File(user.profilePicture);
    // String _image=await uploadProfileImage(user.id,file);
    try {
      final doc = await _firestore
          .collection(customersCollection).doc(user.id)
          .set({
            'email':user.email,
            'name':user.name,
            'nickName':user.nickName,
            'id':user.id,
            'phoneNumber':user.phoneNumber,
            'gender':user.gender,
            'dateofBirth':user.dateofBirth,
            'profilePicture':user.profilePicture,
            'password':user.password
    });
      return null;
    } catch (e) {
      throw Exception('Failed to add customer data: $e');
    }
  }


  Future<String> uploadProfileImage(String uid, File imageFile) async {
    Reference ref = _storage.ref().child('profile_images').child('$uid.jpg');
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  } 



  Future<String> signInWithEmail({required String email, required String password})async{
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        return '';
      }on FirebaseAuthException catch(firebaseAuthException) {
        return  _handlerOnFirebaseException(firebaseAuthException);
      }
  }

  Future<String> addtoCart(CartItem product,String id)async{
    product.id=id;
    UserModel? user=await getCurrentUser();
    if(user==null){
      return "Not Authenticated";
    }
    var data =await _firestore
    .collection(customersCollection)
    .doc(user.id)
    .collection(cartCollection)
    .doc(id).get();
    if(!data.exists){
      await _firestore
    .collection(customersCollection)
    .doc(user.id)
    .collection(cartCollection)
    .doc(id)
    .set(product.toJson());
    return "done";
    }else{
      return "Already";
    }
  }



  Future<List<CartItem>> getAllCartProducts()async{
    UserModel? user=await getCurrentUser();
    if(user==null){
      throw Exception("User is Not Authenticated");
    }
    return await _firestore
    .collection(customersCollection)
    .doc(user.id)
    .collection(cartCollection)
    .get().then((value) => value.docs.map((e) => CartItem.fromJson(e.data(),e.id),).toList(),);
  }



  Future<void> removeProductInCart(String id)async{
    UserModel? user=await getCurrentUser();
    if(user==null){
      throw Exception("User is Not Authenticated");
    }
    try {
      var p=await _firestore.collection(customersCollection).doc(user.id).collection(cartCollection).doc(id).delete();
    } catch (e) {
      throw Exception(e);
    }
  }




  Future<bool> signOut()async{
    UserModel? user=await getCurrentUser();
    if(user==null){
      throw Exception("User is Not Authenticated");
    }
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }



  Future<List<CartItem>> getAllOrderProducts()async{
    try{
    List<CartItem> list=[];
    UserModel? user=await getCurrentUser();
    if(user==null){
      throw Exception("User is Not Authenticated");
    }
    var items =await _firestore
    .collection(customersCollection)
    .doc(user.id)
    .collection(orderCollection)
    .get();
    items.docs.forEach((element){ List<dynamic> items=element.data()['items'];
    list.addAll(items.map((e) => CartItem.fromJson(e,user.id),).toList());
    });
    return list;
    }catch(e){
      throw Exception(e.toString());
    }
  }




  Future<String> addtoOrder(MyOrder order)async{
    UserModel? user=await getCurrentUser();
    if(user==null){
      return "Not Authenticated";
    }
    await deleteCollection(cartCollection);
    var data =await _firestore
    .collection(customersCollection)
    .doc(user.id)
    .collection(orderCollection)
    .add(order.toJson());
    return "done";
  }

  Future<UserCredential?> signInWithGoogle() async {
  // Trigger the authentication flow
  await _googleSignIn.initialize();
  final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = googleUser!.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}


  Future<void> deleteCollection(String collectionPath) async {
    UserModel? user=await getCurrentUser();
    if(user==null){
      throw Exception("User is not authorized");
    }
    final collection = _firestore.collection(customersCollection).doc(user.id).collection(collectionPath);

    final snapshot = await collection.get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
     }
  }



    Future<UserModel> getInfo()async{
     UserModel? user=await getCurrentUser();
    if(user==null){
      throw Exception("User is not authorized");
    }
    return await _firestore
    .collection(customersCollection)
    .doc(user.id).get().then((value) => UserModel.fromJson(value.data()!),);
    }



    

    
    
    Future<bool> updateUser(UserModel user)async{
      try {
    UserModel? a=await getCurrentUser();
    if(a==null){
      throw Exception("User is not authorized");
    }
    await _firestore
    .collection(customersCollection)
    .doc(user.id)
    .update(user.toJson());
    return true;
      } catch (e) {
        throw Exception(e.toString());
      }
    }


  String _handlerOnFirebaseException(FirebaseAuthException e){
    switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email';
        case 'wrong-password':
          return 'Incorrect password';
        case 'invalid-email':
          return 'Invalid email address';
        case 'user-disabled':
          return 'This account has been disabled';
        case 'too-many-requests':
          return 'Too many failed attempts. Try again later';
        case 'invalid-credential':
          return 'Invalid email or password';
        case 'network-request-failed':
          return 'Network error. Please check your connection';
        default:
          return e.message ?? 'Authentication failed';
      }
  }
  UserModel _customerFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(id: doc.id,name: data['name']??'',
     nickName: data['nickName']??'',
      dateofBirth: data['dateofBirth']??'',
       email: data['email']??'',
        password: data['password']??'',
         phoneNumber: data['phoneNumber']??'',
          gender: data['gender']??'',
           profilePicture: data['profilePicture']??'');
  }
}