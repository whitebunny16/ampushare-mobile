import 'package:ampushare/pages/login/login_page.dart';
import 'package:ampushare/pages/register/register_continue_page.dart';
import 'package:ampushare/widgets/cover_image/AmpuShareBackgroundCover.dart';
import 'package:ampushare/widgets/or_line/OrLine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegisterPage extends HookWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    double SCREEN_WIDTH = MediaQuery.of(context).size.width;
    double SCREEN_HEIGHT = MediaQuery.of(context).size.height;
    double FORM_CARD_WIDTH = (SCREEN_WIDTH * 0.8);

    final _formKey = useMemoized(() => GlobalKey<FormState>());

    final _isPasswordVisible = useState<bool>(false);

    final _usernameController = useTextEditingController();
    final _passwordController = useTextEditingController();

    void handleRegister() {
      if (_formKey.currentState!.validate()) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterContinuePage(
              username: _usernameController.text,
              password: _passwordController.text,
            ),
          ),
        );
      }
    }

    return Scaffold(
      body: SizedBox(
        width: SCREEN_WIDTH,
        height: SCREEN_HEIGHT,
        child: Stack(
          children: [
            const AmpuShareBackgroundCover(),
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15.0,
                        ),

                        // Username Label
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Username',
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
                        // Username Input Field
                        TextFormField(
                          controller: _usernameController,
                          style: const TextStyle(
                            color: Color(0xFF9B9B9B),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Username",
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
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Color(0xff9B9B9B),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 15.0,
                        ),

                        // Password Label
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(
                              color: Color(0xFF9B9B9B),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        // Password Input Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isPasswordVisible.value,
                          style: const TextStyle(
                            color: Color(0xFF9B9B9B),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Password",
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
                            prefixIcon: const Icon(
                              Icons.key,
                              color: Color(0xff9B9B9B),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _isPasswordVisible.value =
                                    !_isPasswordVisible.value;
                              },
                              icon: Icon(
                                  _isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xff9B9B9B)),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20.0,
                        ),

                        // Create Account Button
                        ElevatedButton(
                          onPressed: handleRegister,
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

                        const SizedBox(
                          height: 14.0,
                        ),

                        // ---OR---
                        const OrLine(),

                        const SizedBox(
                          height: 10.5,
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size.fromHeight(52),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xFF009781),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
