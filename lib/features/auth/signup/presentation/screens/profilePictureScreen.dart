import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/features/auth/signup/data/models/profileInfo.dart';
import 'package:qenan/features/auth/signup/presentation/blocs/signup_bloc.dart';
import 'package:qenan/features/auth/signup/presentation/blocs/signup_event.dart';
import 'package:qenan/features/auth/signup/presentation/blocs/signup_state.dart';
import 'package:qenan/features/common/errorFlushbar.dart';
import 'package:qenan/features/home/presentation/blocs/home_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_event.dart';
import 'package:qenan/l10n/l10n.dart';

class ProfilePictureScreen extends StatefulWidget {
  final PageController pageController;
  const ProfilePictureScreen({super.key, required this.pageController});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  final List<FocusNode> _focusNodes = List.generate(3, (_) => FocusNode());
  final List<TextEditingController> dobControllers =
      List.generate(3, (_) => TextEditingController());

  bool dobEmpty = false;
  bool isLoading = false;
  String? selectedSex;

  File? _selectedImage;

  @override
  void dispose() {
    for (var controller in dobControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          print(state);
          if (state is ProfileInfoLoadingState) {
            isLoading = true;
          } else if (state is ProfileInfoSuccessfulState) {
            isLoading = false;
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text("Profile photo added Successfully!"),
            //     backgroundColor: Colors.green,
            //   ),
            // );
            BlocProvider.of<CategoryBloc>(context).add(GetCategoryEvent());
            widget.pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          } else if (state is ProfileInfoFailureState) {
            isLoading = false;
            errorFlushbar(context: context, message: state.error);
          }
        },
        builder: (context, state) {
          return buildInitialInput();
        },
      ),
    );
  }

  Widget buildInitialInput() {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 32, right: 32, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.customizeYourProfile,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.addProfilePicture,
                  style: TextStyle(
                      color: grayTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: width < 391 ? 30 : 60),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _pickImageFromGallery();
                    },
                    child: Container(
                        height: width < 391 ? 200 : 231,
                        width: width < 391 ? 200 : 231,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: _selectedImage != null
                                    ? FileImage(_selectedImage!)
                                    : const AssetImage(
                                            "images/profilePicture.jpg")
                                        as ImageProvider,
                                fit: BoxFit.cover))),
                  ),
                ),
                SizedBox(height: width < 391 ? 15 : 30),
                Container(
                  padding: EdgeInsets.all(width < 391 ? 14 : 21),
                  decoration: BoxDecoration(
                    border: Border.all(color: textFormBorderColor, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.chooseProfile,
                        style: TextStyle(
                            color: profileTxtColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _pickImageFromGallery();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.select,
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(darkBlue),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 20),
                  child: Text(
                    AppLocalizations.of(context)!.dateOfBirth,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _buildDobTextField(0, width < 391 ? 75 : 85,
                        AppLocalizations.of(context)!.dd),
                    _buildDobTextField(1, width < 391 ? 75 : 85,
                        AppLocalizations.of(context)!.mm),
                    _buildDobTextField(2, width < 391 ? 115 : 130,
                        AppLocalizations.of(context)!.yyyy),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 20),
                  child: Text(
                    AppLocalizations.of(context)!.sex,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                        child: selectSex(AppLocalizations.of(context)!.male)),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: selectSex(AppLocalizations.of(context)!.female)),
                  ],
                ),
                const SizedBox(
                  height: 180,
                ),
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 17,
            left: 17,
            right: 17,
            child: Container(
              width: width,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: darkBlue,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    AppLocalizations.of(context)!.profilePage,
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              FocusScope.of(context).unfocus();

                              if (_selectedImage == null) {
                                errorFlushbar(
                                    context: context,
                                    message: AppLocalizations.of(context)!
                                        .emptyProfile);
                              } else if (dobControllers.any(
                                  (controller) => controller.text.isEmpty)) {
                                errorFlushbar(
                                    context: context,
                                    message:
                                        AppLocalizations.of(context)!.emptyDob);
                              } else if (selectedSex == null) {
                                errorFlushbar(
                                    context: context,
                                    message:
                                        AppLocalizations.of(context)!.emptySex);
                              } else {
                                String day = dobControllers[0].text.padLeft(
                                    2, '0'); // Pad with 0 to ensure two digits
                                String month = dobControllers[1].text.padLeft(
                                    2, '0'); // Pad with 0 to ensure two digits
                                String year = dobControllers[2]
                                    .text; // Year should already be four digits

                                String formattedDate = '$year-$month-$day';

                                final profileInfoCustomization =
                                    BlocProvider.of<SignupBloc>(context);
                                profileInfoCustomization.add(
                                    PostProfileInfoEvent(ProfileInfo(
                                        dob: formattedDate,
                                        photo: _selectedImage!,
                                        sex: selectedSex
                                            .toString()
                                            .toUpperCase())));
                              }
                            },
                      style: ButtonStyle(
                          backgroundColor: isLoading
                              ? MaterialStateProperty.all(
                                  primaryColor.withOpacity(0.7))
                              : MaterialStateProperty.all(primaryColor)),
                      child: Text(
                        isLoading
                            ? "${AppLocalizations.of(context)!.submitting}..."
                            : AppLocalizations.of(context)!.continueBtn,
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ))
                ],
              ),
            ))
      ],
    );
  }

  Widget _buildDobTextField(int index, double width, String hintText) {
    return SizedBox(
      width: width,
      height: 50,
      child: TextField(
        controller: dobControllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: index == 2 ? 4 : 2,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        ],
        onChanged: (value) {
          _onDobChanged(index, value);
        },
        style: const TextStyle(
            color: blackColor, fontSize: 16, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          counterText: '',
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: otpFieldColor)),
        ),
      ),
    );
  }

  Widget selectSex(String sex) {
    double width = MediaQuery.of(context).size.width;
    bool isSelected = selectedSex == sex;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSex = sex;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0C2566), primaryColor],
                )
              : null,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 35),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              sex,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey,
                fontSize: width < 390 ? 14 : 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onDobChanged(int index, String value) {
    // Update the date of birth controllers with the new value
    dobControllers[index].text = value;

    // Check if all date of birth fields are filled
    bool allFilled =
        dobControllers.every((controller) => controller.text.isNotEmpty);
    setState(() {
      dobEmpty = !allFilled;
    });

    // Determine the maximum length for each field
    int maxLength = index == 2 ? 4 : 2;

    // Check if the current input length equals the maximum length
    if (value.length == maxLength) {
      // Move focus to the next text field if it exists
      if (index < dobControllers.length - 1) {
        _focusNodes[index].unfocus();
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      }
    } else {
      // Move focus to the previous text field if it exists and current value is empty
      if (index > 0 && value.isEmpty) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }
}
