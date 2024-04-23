import 'dart:io';

import 'package:ampushare/data/models/user_registration/user_registration_model.dart';
import 'package:ampushare/services/dio_helper.dart';
import 'package:ampushare/widgets/avatar_picker_bottom_modal_sheet/AvatarPickerBottomModalSheet.dart';
import 'package:ampushare/widgets/decorations/top_right_Decoration.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RegisterContinuePage extends HookWidget {
  final String username;
  final String password;

  const RegisterContinuePage(
      {super.key, required this.username, required this.password});

  @override
  Widget build(BuildContext context) {
    double SCREEN_WIDTH = MediaQuery.of(context).size.width;
    double SCREEN_HEIGHT = MediaQuery.of(context).size.height;
    double FORM_CARD_WIDTH = (SCREEN_WIDTH * 0.8);
    const AVATAR_WIDTH = 150.0;

    final _image = useState<File?>(null);
    final _firstNameController = useTextEditingController();
    final _lastNameController = useTextEditingController();
    final _emailAddressController = useTextEditingController();
    final _dateOfBirth = useState<DateTime?>(null);

    final _gender = useState<String?>(null);

    const GENDERS = <String>["Male", "Female", "Others"];

    final _formKey = useMemoized(() => GlobalKey<FormState>());

    pickImage() => showModalBottomSheet(
        context: context,
        builder: (ctx) => buildAvatarPickerBottomModalSheet(ctx, _image));

    void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      if (args.value is DateTime) {
        _dateOfBirth.value = args.value;
        Navigator.pop(context);
      }
    }

    Future<void> _alertDialog() async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SizedBox(
                width: FORM_CARD_WIDTH,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: SfDateRangePicker(
                    selectionMode: DateRangePickerSelectionMode.single,
                    allowViewNavigation: true,
                    initialSelectedDate: DateTime.now(),
                    onSelectionChanged: _onSelectionChanged,
                  ),
                ),
              ),
              title: const Text('Select your Birth Date'),
            );
          });
    }

    void handleCreateAccount() async {
      if (_image.value == null) {
        Fluttertoast.showToast(
            msg: "Please select a profile picture",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      if (_dateOfBirth.value == null) {
        Fluttertoast.showToast(
            msg: "Please select your date of birth",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      if (_formKey.currentState!.validate()) {
        if (_image.value == null || _dateOfBirth.value == null) {
          return;
        }

        UserRegistrationModel user = UserRegistrationModel(
          username: username,
          email: _emailAddressController.text,
          password: password,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          profile: Profile(
            dateOfBirth: _dateOfBirth.value!,
            profilePic: _image.value!.path,
            gender: _gender.value![0],
          ),
        );

        try {
          FormData formData = FormData.fromMap({
            "username": user.username,
            "email": user.email,
            "password": user.password,
            "first_name": user.firstName,
            "last_name": user.lastName,
            "profile": {
              "profile_pic": await MultipartFile.fromFile(_image.value!.path),
              "date_of_birth":
                  "${user.profile.dateOfBirth.year.toString().padLeft(4, '0')}-${user.profile.dateOfBirth.month.toString().padLeft(2, '0')}-${user.profile.dateOfBirth.day.toString().padLeft(2, '0')}",
              "gender": user.profile.gender[0]
            }
          });

          Dio dio = await DioHelper.getDioForAuth();
          final response = await dio.post(
            '/api/user/register',
            data: formData,
          );

          if (response.statusCode == 201) {
            Fluttertoast.showToast(
                msg: "Account created successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.of(context).pop();
          } else {
            Fluttertoast.showToast(
                msg: "Error occurred while creating account",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } catch (e) {
          print(e.toString());
          Fluttertoast.showToast(
              msg: "Error occurred while creating account",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: SCREEN_HEIGHT,
          width: SCREEN_WIDTH,
          child: Stack(
            children: [
              const TopRightDecoration(),
              Positioned(
                left: (SCREEN_WIDTH * 0.5) - (FORM_CARD_WIDTH / 2),
                bottom: (SCREEN_WIDTH - FORM_CARD_WIDTH * 1.1),
                child: Container(
                  width: FORM_CARD_WIDTH,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 12,
                        offset: Offset(2, 3),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -AVATAR_WIDTH / 2,
                        left: (FORM_CARD_WIDTH - AVATAR_WIDTH) / 2,
                        child: InkWell(
                          onTap: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'png', 'mp4'],
                            );

                            if (result != null) {
                              _image.value = File(result.files.single.path!);
                            }
                          },
                          customBorder: const CircleBorder(),
                          child: Container(
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 9,
                                  offset: Offset(2, 3),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 75,
                              backgroundImage: _image.value != null
                                  ? Image.file(_image.value!).image
                                  : const AssetImage(
                                      "assets/icons/add-profile-image.png"),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16, AVATAR_WIDTH / 2, 16, 16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 15.0,
                              ),
                              // First name Label
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'First Name',
                                  style: TextStyle(
                                    color: Color(0xFF9B9B9B),
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              // First name Input Field
                              TextFormField(
                                controller: _firstNameController,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  color: Color(0xFF9B9B9B),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Enter First name",
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xff009781), width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xff009781), width: 1.0),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 15.0,
                              ),
                              // Last name Label
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Last Name',
                                  style: TextStyle(
                                    color: Color(0xFF9B9B9B),
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              // Last name Input Field
                              TextFormField(
                                controller: _lastNameController,
                                keyboardType: TextInputType.name,
                                style: const TextStyle(
                                  color: Color(0xFF9B9B9B),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Enter Last name",
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xff009781), width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xff009781), width: 1.0),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 15.0,
                              ),
                              // Email Address Label
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Email Address',
                                  style: TextStyle(
                                    color: Color(0xFF9B9B9B),
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              // Email Address Input Field
                              TextFormField(
                                controller: _emailAddressController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(
                                  color: Color(0xFF9B9B9B),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Enter Email address",
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xff009781), width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xff009781), width: 1.0),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 15.0,
                              ),
                              // Date of Birth Label
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Date of Birth',
                                  style: TextStyle(
                                    color: Color(0xFF9B9B9B),
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),

                              // Date of Birth Input Field
                              GestureDetector(
                                onTap: _alertDialog,
                                child: Container(
                                  width: double.infinity,
                                  height: 53.36,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Color(0xFF009781)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 16, 8, 16),
                                    child: Text(
                                      "${_dateOfBirth.value?.day}-${_dateOfBirth.value?.month}-${_dateOfBirth.value?.year}",
                                      style: const TextStyle(
                                        color: Color(0xFF9B9B9B),
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 15.0,
                              ),
                              // Gender Label
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Gender',
                                  style: TextStyle(
                                    color: Color(0xFF9B9B9B),
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              // Gender Input Field

                              DropdownButtonFormField<String>(
                                hint: const Text(
                                  "Select Gender",
                                ),
                                itemHeight: 48,
                                value: _gender.value,
                                items: GENDERS
                                    .map(
                                      (String item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(item),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  _gender.value = val!;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your gender';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  color: Color(0xFF9B9B9B),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xff009781), width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xff009781), width: 1.0),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 20.0,
                              ),

                              // Create Account Button
                              ElevatedButton(
                                onPressed: handleCreateAccount,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF009781),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: const Size.fromHeight(52)),
                                child: const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
