import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/shared/components/components.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).selectedprofileImage;
        var coverImage = SocialCubit.get(context).selectedprofileCoverImage;

        nameController.text = userModel!.name!;
        phoneController.text = userModel.phone!;
        bioController.text = userModel.bio!;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                IconBroken.Arrow___Left_2,
              ),
            ),
            titleSpacing: 5.0,
            title: const Text(
              'Edit Profile',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  SocialCubit.get(context).updateUser(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text);
                },
                child: Text(
                  'Update'.toUpperCase(),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoadingState)
                    const LinearProgressIndicator(),
                  if (state is SocialUserUpdateLoadingState)
                    const SizedBox(
                      height: 10.0,
                    ),
                  SizedBox(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          // ignore: sort_child_properties_last
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              coverImage == null
                                  ? Container(
                                      height: 140.0,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(
                                            4.0,
                                          ),
                                          topRight: Radius.circular(
                                            4.0,
                                          ),
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(userModel.cover!),
                                          fit: BoxFit.cover,
                                        ),
                                      ))
                                  : Container(
                                      height: 140.0,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(
                                            4.0,
                                          ),
                                          topRight: Radius.circular(
                                            4.0,
                                          ),
                                        ),
                                        image: DecorationImage(
                                          image: FileImage(coverImage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              IconButton(
                                icon: const CircleAvatar(
                                  radius: 20.0,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 16.0,
                                  ),
                                ),
                                onPressed: () {
                                  SocialCubit.get(context).selectCoverImage();
                                },
                              ),
                            ],
                          ),
                          alignment: AlignmentDirectional.topCenter,
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                                radius: 64.0,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: profileImage == null
                                    ? CircleAvatar(
                                        radius: 60.0,
                                        backgroundImage: NetworkImage(
                                          '${userModel.image}',
                                        ))
                                    : CircleAvatar(
                                        radius: 60.0,
                                        backgroundImage:
                                            FileImage(profileImage),
                                      )),
                            IconButton(
                              icon: const CircleAvatar(
                                radius: 20.0,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 16.0,
                                ),
                              ),
                              onPressed: () {
                                SocialCubit.get(context).selectImage();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  if (SocialCubit.get(context).selectedprofileImage != null ||
                      SocialCubit.get(context).selectedprofileCoverImage !=
                          null)
                    Row(
                      children: [
                        if (SocialCubit.get(context).selectedprofileImage !=
                            null)
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      5.0,
                                    ),
                                    color: Colors.blue,
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {
                                      SocialCubit.get(context)
                                          .updateUserprofileImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text,
                                      );
                                    },
                                    child: Text(
                                      'upload profile'.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                if (state is SocialUserUpdateLoadingState)
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                if (state is SocialUserUpdateLoadingState)
                                  const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        if (SocialCubit.get(context)
                                .selectedprofileCoverImage !=
                            null)
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      5.0,
                                    ),
                                    color: Colors.blue,
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {
                                      SocialCubit.get(context)
                                          .updateUserprofileCoverImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text,
                                      );
                                    },
                                    child: Text(
                                      'upload cover'.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                if (state is SocialUserUpdateLoadingState)
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                if (state is SocialUserUpdateLoadingState)
                                  const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  if (SocialCubit.get(context).selectedprofileImage != null ||
                      SocialCubit.get(context).selectedprofileCoverImage !=
                          null)
                    const SizedBox(
                      height: 20.0,
                    ),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'name must not be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(
                        IconBroken.User,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: bioController,
                    keyboardType: TextInputType.text,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'bio must not be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      prefixIcon: Icon(
                        IconBroken.Info_Circle,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'phone number must not be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      prefixIcon: Icon(
                        IconBroken.Call,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
