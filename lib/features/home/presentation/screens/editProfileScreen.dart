import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass/glass.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/features/auth/signin/data/models/updateProfile.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_bloc.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_event.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_state.dart';
import 'package:qenan/features/auth/signup/presentation/widgets/transformPhoneNumber.dart';
import 'package:qenan/features/common/emailFormField.dart';
import 'package:qenan/features/common/emailValidator.dart';
import 'package:qenan/features/common/errorText.dart';
import 'package:qenan/features/common/phoneFormField.dart';
import 'package:qenan/features/common/submitButton.dart';
import 'package:qenan/features/common/textFormFIeld.dart';
import 'package:qenan/features/home/presentation/screens/changePasswordScreen.dart';
import 'package:qenan/features/home/presentation/screens/mainTabs/indexScreen.dart';
import 'package:qenan/features/home/presentation/widgets/urlToFile.dart';
import 'package:qenan/l10n/l10n.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final List<FocusNode> _focusNodes = List.generate(3, (_) => FocusNode());
  final List<TextEditingController> dobControllers =
      List.generate(3, (_) => TextEditingController());

  final updateProfileFormKey = GlobalKey<FormState>();

  bool dobEmpty = false;
  String? selectedSex;
  String profilePicture = "";

  File? _selectedImage;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool isFirstNameEmpty = false;
  bool isLastNameEmpty = false;
  bool isUserNameEmpty = false;
  bool isEmailEmpty = false;
  bool isPhoneEmpty = false;
  bool isPhoneInvalid = false;
  bool isEmailInvalid = false;

  bool titleVisible = false;
  ScrollController screenScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    screenScrollController.addListener(_printPosition);
  }

  void fetchUserProfile() async {
    final profileBloc = BlocProvider.of<UpdateProfileBloc>(context);
    profileBloc.add(GetUserProfileEvent());

    profileBloc.stream.listen((state) {
      if (state is UserProfileSuccessfulState) {
        final userProfile = state.userProfile;

        setState(() {
          String phoneNumber = userProfile.phone;
          if (phoneNumber.startsWith('251')) {
            phoneNumber = '0' + phoneNumber.substring(3);
          }

          List<String> dobParts = userProfile.dob.split('-');
          firstNameController.text = userProfile.first_name;
          lastNameController.text = userProfile.last_name;
          userNameController.text = userProfile.username;
          phoneController.text = phoneNumber;
          emailController.text = userProfile.email;
          dobControllers[0].text = dobParts[2];
          dobControllers[1].text = dobParts[1];
          dobControllers[2].text = dobParts[0];
          selectedSex = userProfile.sex;
          profilePicture = userProfile.attachments.user_photo.toString();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    firstNameController.dispose();
    phoneController.dispose();
    for (var controller in dobControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
  }

  void _printPosition() {
    print('Scroll position: ${screenScrollController.position.pixels}');
    if (screenScrollController.position.pixels > 110) {
      setState(() {
        titleVisible = true;
      });
    } else {
      setState(() {
        titleVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: Container(
          child: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor:
                titleVisible ? blackColor.withOpacity(0.1) : Colors.transparent,
            toolbarHeight: height * 0.08,
            title: Text(
              titleVisible ? AppLocalizations.of(context)!.editProfile : "",
              style: const TextStyle(
                  color: whiteColor, fontSize: 18, fontWeight: FontWeight.w500),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 25, top: 6),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => IndexScreen(pageIndex: 3)));
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: blackColor,
                  )),
            ),
          ),
        ).asGlass(enabled: titleVisible, tintColor: Colors.transparent),
      ),
      extendBodyBehindAppBar: true,
      body: BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
          listener: (context, state) {
        if (state is UpdateProfileSuccessfulState) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => IndexScreen(pageIndex: 3)));
        }
      }, builder: (context, state) {
        return buildInitialInput();
      }),
    );
  }

  Widget buildInitialInput() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Form(
      key: updateProfileFormKey,
      child: SingleChildScrollView(
        controller: screenScrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: headerBgColor,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.editProfile,
                        style: TextStyle(
                            color: blackColor,
                            fontSize: 34,
                            fontWeight: FontWeight.w900),
                      ),
                      Text(
                        ".",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 34,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: width < 390 ? 25 : 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      _pickImageFromGallery();
                    },
                    child: Container(
                      width: width < 390 ? 155 : 180,
                      height: width < 390 ? 155 : 180,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : NetworkImage(profilePicture)
                                      as ImageProvider,
                              fit: BoxFit.cover)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            width: 67,
                            height: 20,
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(AppLocalizations.of(context)!.edit,
                                  style: TextStyle(
                                      color: Color(0xFF464646),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      AppLocalizations.of(context)!.editProfilePicture,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 15, bottom: 5),
                    child: Text(
                      AppLocalizations.of(context)!.firstName,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  textFormField(
                      controller: firstNameController,
                      hintText: AppLocalizations.of(context)!.firstName,
                      onInteraction: () {
                        setState(() {
                          isFirstNameEmpty = false;
                        });
                      }),
                  isFirstNameEmpty
                      ? errorText(
                          text: AppLocalizations.of(context)!.emptyFirstName)
                      : SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 15, bottom: 5),
                    child: Text(
                      AppLocalizations.of(context)!.lastName,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  textFormField(
                      controller: lastNameController,
                      hintText: AppLocalizations.of(context)!.lastName,
                      onInteraction: () {
                        setState(() {
                          isLastNameEmpty = false;
                        });
                      }),
                  isLastNameEmpty
                      ? errorText(
                          text: AppLocalizations.of(context)!.emptyLastName)
                      : SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 15, bottom: 5),
                    child: Text(
                      AppLocalizations.of(context)!.userName,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  textFormField(
                      controller: userNameController,
                      hintText: AppLocalizations.of(context)!.userName,
                      onInteraction: () {
                        isUserNameEmpty = false;
                      }),
                  isUserNameEmpty
                      ? errorText(
                          text: AppLocalizations.of(context)!.emptyUserName)
                      : SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 15, bottom: 5),
                    child: Text(
                      AppLocalizations.of(context)!.email,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  emailFormField(
                      controller: emailController,
                      hintText: AppLocalizations.of(context)!.emailAddress,
                      onInteraction: () {
                        setState(() {
                          isEmailEmpty = false;
                          isEmailInvalid = false;
                        });
                      }),
                  isEmailEmpty
                      ? errorText(
                          text: AppLocalizations.of(context)!.emptyEmail)
                      : SizedBox.shrink(),
                  isEmailInvalid
                      ? errorText(
                          text: AppLocalizations.of(context)!.invalidEmail)
                      : SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 15, bottom: 5),
                    child: Text(
                      AppLocalizations.of(context)!.phone,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  phoneFormField(
                      controller: phoneController,
                      hintText: AppLocalizations.of(context)!.phone,
                      onInteraction: () {
                        setState(() {
                          isPhoneEmpty = false;
                          isPhoneInvalid = false;
                        });
                      }),
                  isPhoneEmpty
                      ? errorText(
                          text: AppLocalizations.of(context)!.emptyPhone)
                      : SizedBox.shrink(),
                  isPhoneInvalid
                      ? errorText(
                          text: AppLocalizations.of(context)!.invalidPhone)
                      : SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 15, bottom: 5),
                    child: Text(
                      AppLocalizations.of(context)!.dateOfBirth,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _buildDobTextField(0, width < 391 ? 75 : 130,
                            AppLocalizations.of(context)!.dd),
                        const SizedBox(width: 12),
                        _buildDobTextField(1, width < 391 ? 75 : 130,
                            AppLocalizations.of(context)!.mm),
                        const SizedBox(width: 12),
                        _buildDobTextField(2, width < 391 ? 115 : 220,
                            AppLocalizations.of(context)!.yyyy),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 15, bottom: 5),
                    child: Text(
                      AppLocalizations.of(context)!.sex,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(child: selectSex("MALE")),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(child: selectSex("FEMALE")),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => ChangePasswordScreen())));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.changePassword,
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  submitButton(
                      text: AppLocalizations.of(context)!.done,
                      disable: false,
                      onInteraction: () async {
                        print(dobControllers[0].text +
                            " " +
                            dobControllers[1].text +
                            " " +
                            dobControllers[2].text +
                            " ");
                        if (updateProfileFormKey.currentState!.validate()) {
                          if (firstNameController.text.isEmpty) {
                            return setState(() {
                              isFirstNameEmpty = true;
                            });
                          }
                          if (lastNameController.text.isEmpty) {
                            return setState(() {
                              isLastNameEmpty = true;
                            });
                          }
                          if (userNameController.text.isEmpty) {
                            return setState(() {
                              isUserNameEmpty = true;
                            });
                          }
                          if (emailController.text.isEmpty) {
                            return setState(() {
                              isEmailEmpty = true;
                            });
                          }
                          if (phoneController.text.isEmpty) {
                            return setState(() {
                              isPhoneEmpty = true;
                            });
                          }
                          if (emailController.text.isNotEmpty) {
                            if (!isEmailValid(emailController.text)) {
                              return setState(() {
                                isEmailInvalid = true;
                              });
                            }
                          }
                          if (!RegExp(r'^09[0-9]{8}$')
                              .hasMatch(phoneController.text)) {
                            return setState(() {
                              isPhoneInvalid = true;
                            });
                          }
                          String day = dobControllers[0].text.padLeft(
                              2, '0'); // Pad with 0 to ensure two digits
                          String month = dobControllers[1].text.padLeft(
                              2, '0'); // Pad with 0 to ensure two digits
                          String year = dobControllers[2]
                              .text; // Year should already be four digits

                          String formattedDate = '$year-$month-$day';
                          final updateProfile =
                              BlocProvider.of<UpdateProfileBloc>(context);
                          File profileImage;
                          if (_selectedImage != null) {
                            profileImage = _selectedImage!;
                          } else {
                            profileImage = await urlToFile(
                                profilePicture); // Convert URL to File
                          }

                          updateProfile.add(PatchUpdateProfileEvent(
                              UpdateProfile(
                                  first_name: firstNameController.text,
                                  last_name: lastNameController.text,
                                  email: emailController.text,
                                  dob: formattedDate,
                                  phone: transformPhoneNumber(
                                      phoneController.text),
                                  sex: selectedSex.toString(),
                                  photo: profileImage)));
                        }
                      }),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
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
          padding: EdgeInsets.symmetric(
              vertical: 16, horizontal: width < 390 ? 32 : 35),
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
              sex == "MALE"
                  ? AppLocalizations.of(context)!.male
                  : AppLocalizations.of(context)!.female,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey,
                fontSize: width < 390 ? 13 : 16,
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
