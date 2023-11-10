import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/user_bloc.dart';
import 'package:quiz_app/configs/color_config.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/services/firebase_service.dart';
import 'package:quiz_app/utils/snackbars.dart';
import 'package:quiz_app/utils/user_image.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../configs/app_config.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.userData}) : super(key: key);
  final UserModel userData;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameCtlr = TextEditingController();
  final _btnCtlr = RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedAssetString;
  late ScrollController _scrollController;

  File? _selectedImageFile;
  String? _fileName;
  String? _imageUrl;

  _onSelection(int index, String assetString) {
    setState(() {
      _selectedImageFile = null;
      _imageUrl = null;
      _selectedAssetString = assetString;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    _nameCtlr.text = widget.userData.name!;
    _selectedImageFile = null;
    _selectedAssetString = widget.userData.avatarString;
    _imageUrl = widget.userData.imageUrl;
    Future.delayed(const Duration(milliseconds: 500)).then((value) => _scrollToIndex());
  }

  void _scrollToIndex() {
    int destinationIndex = Config.userAvatars
        .indexWhere((element) => element == _selectedAssetString);
    _scrollController.animateTo(160 * destinationIndex.toDouble(),
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  _handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _btnCtlr.start();
      if(_selectedImageFile != null){
        //with image
        await _uploadToHosting().then((String? imageUrl)async{
          if(imageUrl != null){
            await FirebaseService().updateUserProfileOnEditScreen(widget.userData.uid!, _nameCtlr.text, null, imageUrl);
            _btnCtlr.reset();
            // ignore: use_build_context_synchronously
            openSnackbar(context, 'Updated Successfully!');
          }else{
            _btnCtlr.reset();
            openSnackbar(context, 'Error on uploading image. Please try again');
          }
        });
      }else{
        //with avatar
        if(_selectedAssetString != null){
          await FirebaseService().updateUserProfileOnEditScreen(widget.userData.uid!, _nameCtlr.text, _selectedAssetString, null);
          _btnCtlr.reset();
          // ignore: use_build_context_synchronously
          openSnackbar(context, 'Updated Successfully!');
        }else{
          _btnCtlr.reset();
          openSnackbar(context, "Please Select an Avatar");
        }
      }
      // ignore: use_build_context_synchronously
      context.read<UserBloc>().getUserData();
    }
  }

  Future _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    if (image != null) {
      setState(() {
        _selectedImageFile = File(image.path);
        _fileName = image.name;
        _selectedAssetString = null;
        _imageUrl = null;
      });
    }
  }

  Future<String?> _uploadToHosting() async {
    String? imageUrl;
    final Reference storageReference = FirebaseStorage.instance.ref().child('user_pictures/$_fileName');
    final UploadTask uploadTask = storageReference.putFile(_selectedImageFile!);
    await uploadTask.whenComplete(()async{
      imageUrl = await storageReference.getDownloadURL();  
    });
    return imageUrl;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('edit-profile', style: TextStyle(color: Colors.white),).tr(),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('image-upload').tr(),
                    const SizedBox(height: 10,),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        InkWell(
                          onTap: ()=> _pickImage(),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                image: getUserImageforEditProfile(context, _imageUrl, _selectedImageFile, _selectedAssetString),
                                shape: BoxShape.circle,
                                color: Colors.green[100]),
                          ),
                        ),
                        const IgnorePointer(
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              LineIcons.editAlt,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Text('----OR----', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorConfig.bodyTextColor
                    ),),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: const Text('update-avatar').tr(),
            ),
            SizedBox(
              height: 220,
              //color: Colors.grey,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                itemCount: Config.userAvatars.length,
                separatorBuilder: ((context, index) => const SizedBox(
                      width: 20,
                    )),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      _avatarCard(index, Config.userAvatars[index]),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('update-name').tr(),
                  const SizedBox(
                    height: 5,
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      color: Colors.white,
                      child: TextFormField(
                        controller: _nameCtlr,
                        validator: (value) {
                          if (value!.isEmpty) return "Name can't be empty!";
                          return null;
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            hintText: 'Full Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: _nameCtlr.clear)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  RoundedLoadingButton(
                    animateOnTap: false,
                    borderRadius: 5,
                    controller: _btnCtlr,
                    onPressed: () => _handleUpdate(),
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).primaryColor,
                    elevation: 0,
                    child: Wrap(
                      children: [
                        const Text(
                          'update',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ).tr()
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell _avatarCard(int listIndex, String assetString) {
    bool selected = assetString == _selectedAssetString ? true : false;
    return InkWell(
      onTap: () => _onSelection(listIndex, Config.userAvatars[listIndex]),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                border: Border.all(
                    color: selected ? Colors.blueGrey : Colors.transparent),
                shape: BoxShape.circle,
                color: Colors.green[100],
                image: DecorationImage(image: AssetImage(assetString))),
          ),
          Visibility(
            visible: selected,
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.done,
                size: 60,
                color: Colors.grey[800],
              ),
            ),
          )
        ],
      ),
    );
  }
}
