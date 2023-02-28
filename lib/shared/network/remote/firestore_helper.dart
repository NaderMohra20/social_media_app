import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/social_user_model.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static FirestoreHelper firestoreHelper = FirestoreHelper._();
  CollectionReference<Map<String, dynamic>> usersCollectionRefrence =
      FirebaseFirestore.instance.collection("users");
  // CollectionReference<Map<String, dynamic>> photosCollectionRefrence =
  //     FirebaseFirestore.instance.collection("photos");
  // CollectionReference<Map<String, dynamic>> offersCollectionRefrence =
  //     FirebaseFirestore.instance.collection("offers");
  // addNewCategory(Category category) async {
  //   DocumentReference<Map<String, dynamic>> documentReference =
  //       await categoriesCollectionRefrence.add(category.toMap());
  //   category.catId = documentReference.id;
  //   return category;
  // }

//   Future<List<Category>> getAllCategories() async {
//     QuerySnapshot<Map<String, dynamic>> querySnapshot =
//         await categoriesCollectionRefrence.get();
//     List<Category> categories = querySnapshot.docs.map((e) {
//       Category category = Category.fromMap(e.data());
//       category.catId = e.id;
//       return category;
//     }).toList();
//     return categories;
//   }

//   deleteCategory(Category category) async {
//     await categoriesCollectionRefrence.doc(category.catId).delete();
//   }

  updateUserprofile(SocialUserModel userModel) async {
    await usersCollectionRefrence.doc(userModel.uId).update(userModel.toMap());
  }

//   Future<Prodect> addNewProdect(Prodect prodect, String catId) async {
//     DocumentReference<Map<String, dynamic>> documentReference =
//         await FirebaseFirestore.instance
//             .collection("categories")
//             .doc(catId)
//             .collection("prodects")
//             .add(prodect.toMap());
//     prodect.id = documentReference.id;
//     return prodect;
//   }

//   Future<List<Prodect>> getAllProdects(String catId) async {
//     QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
//         .instance
//         .collection("categories")
//         .doc(catId)
//         .collection("prodects")
//         .get();
//     List<Prodect> products = querySnapshot.docs.map((e) {
//       Map<String, dynamic> data = e.data();
//       data["id"] = e.id;
//       Prodect prodect = Prodect.fromMap(data);

//       return prodect;
//     }).toList();
//     return products;
//   }

//   deleteProdect(Prodect prodect, String catId) async {
//     await FirebaseFirestore.instance
//         .collection("categories")
//         .doc(catId)
//         .collection("prodects")
//         .doc(prodect.id)
//         .delete();
//   }

//   updateProdect(Prodect prodect, String catId) async {
//     await FirebaseFirestore.instance
//         .collection("categories")
//         .doc(catId)
//         .collection("prodects")
//         .doc(prodect.id)
//         .update(prodect.toMap());
//   }

//   addNewphoto(Photo photo) async {
//     DocumentReference<Map<String, dynamic>> documentReference =
//         await photosCollectionRefrence.add(photo.toMap());
//     photo.id = documentReference.id;
//     return photo;
//   }

//   Future<List<Photo>> getAllPhoto() async {
//     QuerySnapshot<Map<String, dynamic>> querySnapshot =
//         await photosCollectionRefrence.get();
//     List<Photo> photos = querySnapshot.docs.map((e) {
//       Photo photo = Photo.fromMap(e.data());
//       photo.id = e.id;
//       return photo;
//     }).toList();
//     return photos;
//   }

//   deletePhoto(Photo photo) async {
//     await photosCollectionRefrence.doc(photo.id).delete();
//   }

//   updatePhoto(Photo photo) async {
//     await photosCollectionRefrence.doc(photo.id).update(photo.toMap());
//   }

//   addNewOffer(Offer offer) async {
//     DocumentReference<Map<String, dynamic>> documentReference =
//         await offersCollectionRefrence.add(offer.toMap());
//     offer.id = documentReference.id;
//     return offer;
//   }

//   Future<List<Offer>> getAllOffers() async {
//     QuerySnapshot<Map<String, dynamic>> querySnapshot =
//         await offersCollectionRefrence.get();
//     List<Offer> offers = querySnapshot.docs.map((e) {
//       Offer offer = Offer.fromMap(e.data());
//       offer.id = e.id;
//       return offer;
//     }).toList();
//     return offers;
//   }

//   deleteOffer(Offer offer) async {
//     await offersCollectionRefrence.doc(offer.id).delete();
//   }

//   updateOffer(Offer offer) async {
//     await offersCollectionRefrence.doc(offer.id).update(offer.toMap());
//   }

//   // insertDummyDatainFirestore() async {
//   //   firebaseFirestore
//   //       .collection(categorcollectionname)
//   //       .add({"nameAr": "طعام", "nameEn": "Food", "imageUrl": "imageUrl"});
//   // }

//   // addUserToFirestore(AppUser AppUser) async {
//   //   FirebaseFirestore.instance
//   //       .collection("user")
//   //       .doc(AppUser.id)
//   //       .set(AppUser.tomap());
//   // }

//   // getuserfromeFirestore(String id) async {
//   //   DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
//   //       await FirebaseFirestore.instance.collection("user").doc(id).get();
//   //   documentSnapshot.data();
//   // }
// }
}
