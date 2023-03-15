import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/layout/cubit/states.dart';

import '../../models/message_model.dart';
import '../../models/post_model.dart';
import '../../models/social_user_model.dart';
import '../../modules/chats/chats_screen.dart';
import '../../modules/feeds/feeds_screen.dart';
import '../../modules/new_post/new_post_screen.dart';
import '../../modules/settings/settings_screen.dart';
import '../../modules/users/users_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/network/remote/firestore_helper.dart';
import '../../shared/network/remote/storege_helper.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      //print(value.data());
      userModel = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];
  void changeBottomNav(int index) {
    if (index == 1) getUsers();
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File? selectedprofileImage;

  selectImage() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    selectedprofileImage = File(xFile!.path);
    emit(SocialProfileImagePickedSuccessState());
  }

  updateUserprofileImage({
    required String name,
    required String phone,
    required String bio,
  }) async {
    String? imageUrl;
    if (selectedprofileImage != null) {
      imageUrl =
          await StorageHelper.storageHelper.uplodeimage(selectedprofileImage!);
    }
    SocialUserModel newUser = SocialUserModel(
        email: userModel!.email,
        name: name,
        phone: phone,
        uId: uId,
        image: imageUrl ?? userModel!.image,
        cover: userModel!.cover,
        bio: bio,
        isEmailVerified: false);

    await FirestoreHelper.firestoreHelper.updateUserprofile(newUser);
    getUserData();
  }

  File? selectedprofileCoverImage;

  selectCoverImage() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    selectedprofileCoverImage = File(xFile!.path);
    emit(SocialProfileImagePickedSuccessState());
  }

  updateUserprofileCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) async {
    String? imageUrl;
    if (selectedprofileCoverImage != null) {
      imageUrl = await StorageHelper.storageHelper
          .uplodeimage(selectedprofileCoverImage!);
    }
    SocialUserModel newUser = SocialUserModel(
        email: userModel!.email,
        name: name,
        phone: phone,
        uId: uId,
        image: userModel!.image,
        cover: imageUrl ?? userModel!.cover,
        bio: bio,
        isEmailVerified: false);

    await FirestoreHelper.firestoreHelper.updateUserprofile(newUser);
    getUserData();
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
  }) async {
    String? imageUrl;
    if (selectedprofileCoverImage != null) {
      imageUrl = await StorageHelper.storageHelper
          .uplodeimage(selectedprofileCoverImage!);
    }
    String? imageUrl2;
    if (selectedprofileImage != null) {
      imageUrl =
          await StorageHelper.storageHelper.uplodeimage(selectedprofileImage!);
    }
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: userModel!.email,
      image: imageUrl2 ?? userModel!.image,
      cover: imageUrl ?? userModel!.cover,
      uId: userModel!.uId,
      isEmailVerified: false,
    );

    await FirestoreHelper.firestoreHelper.updateUserprofile(model);
    getUserData();
  }

  File? postImage;
  var picker = ImagePicker();

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());

    FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(
          text: text,
          dateTime: dateTime,
          postImage: value,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());

    PostModel model = PostModel(
      name: userModel!.name!,
      image: userModel!.image!,
      uId: userModel!.uId!,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      getPosts();
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];

  void getPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      posts = [];
      for (var element in value.docs) {
        element.reference.collection('likes').get().then((value) {
          posts.add(PostModel.fromJson(element.data()));
          emit(SocialGetPostsSuccessState());
          likes.add(value.docs.length);
          postsId.add(element.id);
        }).catchError((error) {});
      }
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikePostSuccessState());
      getPosts();
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  List<SocialUserModel> users = [];

  void getUsers() {
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel!.uId)
            users.add(SocialUserModel.fromJson(element.data()));
        });

        emit(SocialGetAllUsersSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetAllUsersErrorState(error.toString()));
      });
    }
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel model = MessageModel(
      text: text,
      senderId: userModel!.uId!,
      receiverId: receiverId,
      dateTime: dateTime,
    );

    // set my chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    // set receiver chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];

      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });

      emit(SocialGetMessagesSuccessState());
    });
  }

  signUot() async {
    await FirebaseAuth.instance.signOut();
    CacheHelper.removeData(
      key: 'token',
    ).then((value) {
      emit(SocialsingOutSuccessState());
    });
  }
}
