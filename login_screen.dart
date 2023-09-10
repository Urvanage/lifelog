import 'package:flutter/material.dart';
import 'package:lifelog/screens/lost_pw_screen.dart';
import 'package:lifelog/screens/signup_screen.dart';
//import 'package:lifelog/password/password_controller.dart';

//import 'package:lifelog/amplifyconfiguration.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:lifelog/screens/my_page.dart';

class LoginData {
  String email;
  String password;

  LoginData({
    required this.email,
    required this.password,
  });
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mailaddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _isSignedIn = false;
  bool _isChecked = false;
  bool _isObscure = true;

  String _mailaddressValue = "";
  String _passwordValue = "";

  @override
  void dispose() {
    _mailaddressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _verifyCode(LoginData data, String code) async {
    safePrint("verifying code: $code");
    try {
      SignUpResult res = await Amplify.Auth.confirmSignUp(
          username: data.email, confirmationCode: code);
      if (res.isSignUpComplete) {
        safePrint("Confirmed!");
      }
    } on AuthException catch (e) {
      safePrint("Error occurred: ${e.message}");
      // 에러 핸들링
    }
  }

  Future<String> _onSignUp(LoginData data) async {
    try {
      await Amplify.Auth.signUp(
        username: data.email,
        password: data.password,
      );
      return 'Sign Up successful';
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
  }

  Future<String> _onLogin(LoginData loginData) async {
    safePrint("Loggin in");
    try {
      SignInResult res = await Amplify.Auth.signIn(
          username: loginData.email, password: loginData.password);

      _isSignedIn = res.isSignedIn;

      return 'Login successfully';
    } on AuthException catch (e) {
      if (e.message.contains('already a user which is signed in')) {
        await Amplify.Auth.signOut();
        return 'Problem logging in. Please try again.';
      }
      safePrint("Error occurred: ${e.message}");
      return '${e.message} - ${e.recoverySuggestion}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            const Center(
                child: Text(
              'Lifelog',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            )),
            const SizedBox(
              height: 60,
            ),
            SizedBox(
              width: 330,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _mailaddressController,
                      decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          hintText: '이메일을 입력하세요.',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(25.0), // 원하는 경계 모양을 지정
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 30.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(25.0))),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          hintText: '비밀번호를 입력하세요.',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(25.0), // 원하는 경계 모양을 지정
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 30.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(25.0)),
                          suffixIcon: IconButton(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ))),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          hintText: '코드를 입력하세요.',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(25.0), // 원하는 경계 모양을 지정
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 30.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(25.0))),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Transform.translate(
                            offset: const Offset(0, 1),
                            child: Transform.scale(
                              scale: 0.6,
                              child: Checkbox(
                                value: _isChecked,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _isChecked = newValue ?? false;
                                  });
                                },
                                activeColor: Colors.black,
                                checkColor: Colors.white,
                                // fillColor: const MaterialStatePropertyAll(Colors.black),
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(-15, 0),
                            child: const Text(
                              "로그인 유지",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LostPwScreen()));
                        },
                        child: const Text(
                          "비밀번호 찾기",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(81, 80, 80, 1)),
                      fixedSize:
                          MaterialStateProperty.all<Size>(const Size(330, 50)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25.0), // 원하는 값을 지정
                        ),
                      ),
                    ),
                    onPressed: () {
                      _passwordValue = _passwordController.text;
                      _mailaddressValue = _mailaddressController.text;

                      _onLogin(LoginData(
                          email: _mailaddressValue, password: _passwordValue));
                      safePrint(_isSignedIn);
                      if (_isSignedIn) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyPage()));
                      }
                      setState(() {});
                    },
                    child: const Text(
                      "이메일로 로그인",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  // ElevatedButton(
                  //   style: ButtonStyle(
                  //     backgroundColor: MaterialStateProperty.all<Color>(
                  //         const Color.fromRGBO(81, 80, 80, 1)),
                  //     fixedSize:
                  //         MaterialStateProperty.all<Size>(const Size(330, 50)),
                  //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //       RoundedRectangleBorder(
                  //         borderRadius:
                  //             BorderRadius.circular(25.0), // 원하는 값을 지정
                  //       ),
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     _passwordValue = _passwordController.text;
                  //     _mailaddressValue = _mailaddressController.text;
                  //     safePrint("$_mailaddressValue $_passwordValue ");
                  //     safePrint("Pressed!");
                  //     _onSignUp(LoginData(
                  //         email: _mailaddressValue, password: _passwordValue));
                  //     _verifyCode(
                  //         LoginData(
                  //             email: _mailaddressValue,
                  //             password: _passwordValue),
                  //         "332326");
                  //   },
                  //   child: const Text(
                  //     "가입하기",
                  //     style: TextStyle(
                  //       fontSize: 13,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          safePrint("$_mailaddressValue $_passwordValue ");
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const Register()));
                          _onSignUp(LoginData(
                              email: _mailaddressValue,
                              password: _passwordValue));
                        },
                        child: const Text(
                          "회원가입",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Text(
                        "|",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const LostPwScreen()));
                      //   },
                      //   child: const Text(
                      //     "이메일 찾기",
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 12,
                      //     ),
                      //   ),
                      // ),
                      TextButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const LostPwScreen()));
                          _verifyCode(
                              LoginData(
                                  email: _mailaddressValue,
                                  password: _passwordValue),
                              _codeController.text);
                        },
                        child: const Text(
                          "코드 확인",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
