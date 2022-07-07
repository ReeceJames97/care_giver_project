import 'package:care_giver/DatabaseHandler/DbHelper.dart';
import 'package:care_giver/models/user_model.dart';
import 'package:care_giver/utils/colors.dart';
import 'package:care_giver/utils/strings.dart';
import 'package:care_giver/utils/toast.dart';
import 'package:care_giver/views/login_view.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  late DbHelper dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
  }

  signUp() async {
    String userName = userNameController.text.toString();
    String email = emailController.text.toString();
    String password = passwordController.text.toString();
    String confirmPassword = confirmPasswordController.text.toString();

    if (_formKey.currentState!.validate()) {
      if (password != confirmPassword) {
        showToast("Password does not match");
      } else {
        _formKey.currentState!.save();

        var userModel = UserModel(
            {'username': userName, 'email': email, 'password': password});
        await dbHelper.saveData(userModel).then((userData) {
          showToast(STRINGS.successfully_saved);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginView()));
        }).catchError((error) {
          if (kDebugMode) {
            print(error);
          }
          showToast(STRINGS.signup_failed);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(STRINGS.sign_up),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ///Image
                  Image.asset(
                    'assets/images/flutter.png',
                    width: 100,
                    height: 100,
                  ),

                  const SizedBox(height: 20),

                  ///UserName
                  TextFormField(
                    controller: userNameController,
                    keyboardType: TextInputType.text,
                    validator: (userName) =>
                        userName != null && userName.isEmpty
                            ? STRINGS.pls_enter
                            : null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: STRINGS.user_name,
                        prefixIcon: const Icon(Icons.person)),
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  ///Email
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? STRINGS.enter_a_valid_email
                            : null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: STRINGS.email,
                        prefixIcon: const Icon(Icons.email_outlined)),
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 10),

                  ///Password
                  TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: !isPasswordVisible,
                      validator: (userName) =>
                          userName != null && userName.isEmpty
                              ? STRINGS.pls_enter
                              : null,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: STRINGS.password,
                          prefixIcon: const Icon(Icons.key),
                          suffixIcon: IconButton(
                            icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: COLORS.color_tint),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          )),
                      style: const TextStyle(fontSize: 15)),

                  const SizedBox(height: 10),

                  ///Confirm Password
                  TextFormField(
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.text,
                      obscureText: !isConfirmPasswordVisible,
                      validator: (userName) =>
                          userName != null && userName.isEmpty
                              ? STRINGS.pls_enter
                              : null,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: STRINGS.confirm_password,
                          prefixIcon: const Icon(Icons.key),
                          suffixIcon: IconButton(
                            icon: Icon(
                                isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: COLORS.color_tint),
                            onPressed: () {
                              setState(() {
                                isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible;
                              });
                            },
                          )),
                      style: const TextStyle(fontSize: 15)),

                  const SizedBox(height: 10),

                  ///Sign Up Btn
                  ElevatedButton.icon(
                    onPressed: signUp,
                    icon: const Icon(Icons.login),
                    label: const Text(STRINGS.sign_up),
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),

                  const SizedBox(height: 10),

                  ///New User Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(STRINGS.already_registered),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginView()),
                              (Route<dynamic> route) => false);
                        },
                        child: const Text(
                          STRINGS.login,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
