import 'package:ampushare/pages/login/login_page.dart';
import 'package:ampushare/services/dio_helper.dart';
import 'package:ampushare/widgets/layouts/auth_layout/auth_layout.dart';
import 'package:ampushare/widgets/or_line/OrLine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordPage extends HookWidget {
  final String email;

  const ChangePasswordPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final newPasswordController = useTextEditingController();
    final isPasswordVisible = useState<bool>(false);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    void changePassword() async {
      String newPassword = newPasswordController.text;
      if (newPassword.isEmpty || newPassword.length < 8) {
        Fluttertoast.showToast(
            msg: "Password must be at least 8 characters long",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }

      DioHelper.getDioForAuth().then((dio) async {
        try {
          final response = await dio.post(
            '/api/user/password/reset/confirm',
            data: {
              "email": email,
              "new_password": newPassword,
            },
          );

          if (response.statusCode == 200) {
            Fluttertoast.showToast(
                msg: "Password changed successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          } else {
            Fluttertoast.showToast(
                msg: "Error occurred while changing password",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Error occurred while changing password",
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
                              'Change Password',
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
                            controller: newPasswordController,
                            obscureText: !isPasswordVisible.value,
                            style: const TextStyle(
                              color: Color(0xFF9B9B9B),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter new Password",
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
                                Icons.password,
                                color: Color(0xff9B9B9B),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  isPasswordVisible.value =
                                      !isPasswordVisible.value;
                                },
                                icon: Icon(
                                  isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xff9B9B9B),
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
                              '*type your new password',
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
                            height: 10.0,
                          ),
                          ElevatedButton(
                            onPressed: changePassword,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF009781),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: const Size.fromHeight(52)),
                            child: const Text(
                              'Change Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const OrLine(),
                          const SizedBox(
                            height: 10.0,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
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
                              'Back',
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
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
