import 'package:ampushare/pages/change_password_page/change_password_page.dart';
import 'package:ampushare/pages/login/login_page.dart';
import 'package:ampushare/services/dio_helper.dart';
import 'package:ampushare/widgets/layouts/auth_layout/auth_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordPage extends HookWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final emailController = useTextEditingController();

    void handleCheckEmail() async {
      String email = emailController.text;
      if (email.isEmpty) {
        Fluttertoast.showToast(
            msg: "Email cannot be empty",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }

      // Validate email
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(email)) {
        Fluttertoast.showToast(
            msg: "Invalid email format",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }

      // Make a POST request
      DioHelper.getDioForAuth().then((dio) async {
        try {
          final response = await dio.post(
            '/api/user/password/reset',
            data: {
              "email": email,
            },
          );

          if (response.statusCode == 200) {
            Fluttertoast.showToast(
                msg: "Email was found, you can now change your password",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePasswordPage(email: email),
              ),
            );
          } else {
            Fluttertoast.showToast(
                msg: "Error occurred while sending password reset link",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: "email not found in the database",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          const AuthLayout(),
          SingleChildScrollView(
            child: SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.8,
                    // height: screenHeight * 0.37,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 6,
                          offset: Offset(1, 0),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Forgot your password?',
                              style: TextStyle(
                                color: Color(0xFF9B9B9B),
                                fontSize: 25,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: emailController,
                            style: const TextStyle(
                              color: Color(0xFF9B9B9B),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter Email",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                    color: Color(0xff009781), width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                    color: Color(0xff009781), width: 1.0),
                              ),
                              prefixIcon: const Icon(
                                Icons.alternate_email,
                                color: Color(0xff9B9B9B),
                              ),
                              suffixIcon: IconButton(
                                onPressed: handleCheckEmail,
                                icon: const Icon(
                                  Icons.send_rounded,
                                  color: Color(0xff009781),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '*if your email exists, you can change the password',
                              style: TextStyle(
                                color: Color(0xFF9B9B9B),
                                fontSize: 11,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                width: 1.0,
                                color: Color(0xFF009781),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: const Size.fromHeight(52),
                            ),
                            child: const Text(
                              'Back to Login',
                              style: TextStyle(
                                color: Color(0xFF009781),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          )
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
    );
  }

  String formatSecond(int seconds) {
    return seconds.toString().padLeft(2, '0');
  }
}
