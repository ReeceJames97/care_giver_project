import 'package:care_giver/DatabaseHandler/DbHelper.dart';
import 'package:care_giver/models/user_model.dart';
import 'package:care_giver/utils/colors.dart';
import 'package:care_giver/utils/strings.dart';
import 'package:care_giver/utils/toast.dart';
import 'package:care_giver/views/home_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  late DbHelper dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
  }

  login() async {
    String userName = userNameController.text.toString();
    String password = passwordController.text.toString();

    if (userName.isEmpty) {
      showToast(STRINGS.pls_enter_user_name);
    } else if (password.isEmpty) {
      showToast(STRINGS.pls_enter_password);
    } else {
      if (kDebugMode) {
        print(userName);
      }
      if (kDebugMode) {
        print(password);
      }
      await dbHelper.getLoginUser(userName, password).then((userData) async {
        if (userData != null) {
          showToast(STRINGS.successful);

          setSp(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeView("Admin")),
                (Route<dynamic> route) => false);
          });
        } else {
          showToast(STRINGS.user_not_found);
        }
      }).catchError((error) {
        if (kDebugMode) {
          print(error);
        }
        showToast(STRINGS.login_failed);
      });
    }
  }

  Future setSp(UserModel user) async {
    final SharedPreferences sp = await _pref;
    sp.setString("username", user.userName);
    sp.setString("email", user.email);
    sp.setString("password", user.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(STRINGS.login),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///Image
                Image.asset(
                  'assets/images/flutter.png',
                  width: 100,
                  height: 100,
                ),

                const SizedBox(height: 20),

                ///UserName
                TextField(
                  controller: userNameController,
                  keyboardType: TextInputType.text,
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

                ///Password
                TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: !isPasswordVisible,
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

                ///Login Btn
                ElevatedButton.icon(
                  onPressed: login,
                  icon: const Icon(Icons.login),
                  label: const Text(STRINGS.login),
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
                    const Text(STRINGS.not_registered),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeView("User")),
                            (Route<dynamic> route) => false);
                      },
                      child: const Text(
                        STRINGS.go_to_news_feed,
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
    );
  }
}
