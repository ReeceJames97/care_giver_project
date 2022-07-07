import 'dart:async';

import 'package:care_giver/DatabaseHandler/DbHelper.dart';
import 'package:care_giver/models/new_feed_model.dart';
import 'package:care_giver/models/user_model.dart';
import 'package:care_giver/utils/colors.dart';
import 'package:care_giver/utils/strings.dart';
import 'package:care_giver/utils/toast.dart';
import 'package:care_giver/views/add_new_feed_view.dart';
import 'package:care_giver/views/alarm_view.dart';
import 'package:care_giver/views/empty_view.dart';
import 'package:care_giver/views/hospital_view.dart';
import 'package:care_giver/views/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  late final String user;

  HomeView(this.user);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  String name = "";
  TextEditingController mTxtSearch = TextEditingController();
  late DbHelper dbHelper;
  bool isPasswordVisible = false;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  bool isFirst = true;
  String title = "No Records";
  String errorMessage = "There are no records to show you.";

  List allNewFeed = [];
  List items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
    getUserData();
  }

  void filterSearch(String query) {
    var searchList = allNewFeed;
    if (query.isNotEmpty) {
      var listData = [];
      searchList.forEach((item) {
        var newfeed = NewFeedModel.fromMap(item);
        if (newfeed.name.toLowerCase().contains(query.toLowerCase())) {
          listData.add(item);
        }
      });
      setState(() {
        items = [];
        items.addAll(listData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items = allNewFeed;
      });
    }
  }

  ///cmt
  // deleteBtn() async {
  //   String deleteUser = userIdDeleteController.text.toString();
  //   await dbHelper.deleteUser(deleteUser).then((value){
  //     if(value == 1) {
  //       showToast(STRINGS.successfully_deleted);
  //
  //       updateSp(null, false).whenComplete(() {
  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => const LoginView()),
  //                 (Route<dynamic> route) => false);
  //       });
  //     }
  //   }).catchError((error){
  //     print(error);
  //   });
  // }

  // updateBtn() async{
  //   String userId = userIdController.text.toString();
  //   String userName = userNameController.text.toString();
  //   String email = emailController.text.toString();
  //   String password = passwordController.text.toString();
  //
  //   if(_formKey.currentState!.validate()){
  //     _formKey.currentState!.save();
  //
  //     UserModel userModel = UserModel(userId, userName, email, password);
  //     await dbHelper.updateUser(userModel).then((value){
  //       if(value == 1){
  //         showToast(STRINGS.successfully_updated);
  //         updateSp(userModel,true).whenComplete((){
  //           Navigator.pushAndRemoveUntil(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => const LoginView()),
  //                   (Route<dynamic> route) => false);
  //         });
  //       }else{
  //         showToast(STRINGS.update_failed);
  //       }
  //     }).catchError((error){
  //       if (kDebugMode) {
  //         print(error);
  //       }
  //       showToast("Error");
  //     });
  //   }
  // }

  Future updateSp(UserModel? user, bool add) async {
    final SharedPreferences sp = await _pref;

    if (add) {
      // sp.setString("userid", user.userid);
      sp.setString("username", user!.userName);
      sp.setString("email", user.email);
      sp.setString("password", user.password);
    } else {
      sp.remove("userid");
      sp.remove("username");
      sp.remove("email");
      sp.remove("password");
    }
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      name = sp.getString("username")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(STRINGS.app_name),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              // margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0xFFDDDDDD),
                        offset: Offset(0.0, 6.0),
                        blurRadius: 5),
                    BoxShadow(
                        color: Color(0xFFDDDDDD),
                        offset: Offset(0.0, -1.0),
                        blurRadius: 2)
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: mTxtSearch,
                            decoration: const InputDecoration(
                              isDense: true,
                              hintText: "Search...",
                              fillColor: Color(0x80e5e8ff),
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                            style: const TextStyle(fontSize: 16),
                            onChanged: (value) {
                              filterSearch(value);
                            },
                          ),
                        ),
                      ]),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                header: const WaterDropHeader(
                  waterDropColor: COLORS.colorPrimary,
                  complete: SizedBox(
                    height: 0,
                  ),
                ),
                onRefresh: refresh,
                child: (items == null || items.length <= 0)
                    ? getEmptryView(isFirst,
                        message: errorMessage, title: title)
                    : ListView.separated(
                        // shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, i) => buildCtn(i),
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 20,
                            color: Colors.transparent,
                          );
                        }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayColor: Colors.black12,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.location_on),
              label: 'Search Hospital',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HospitalView()));
              }),
          SpeedDialChild(
              child: const Icon(Icons.alarm_add),
              label: 'Set Alarm Time',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AlarmView()));
              }),
          SpeedDialChild(
              child: const Icon(Icons.newspaper),
              label: 'Add New Feed',
              onTap: () {
                if (widget.user.toLowerCase() == "user") {
                  showToast("Admin only");
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddNewFeedView(widget.user.toString())));
                }
              }),
          SpeedDialChild(
              child: const Icon(Icons.add),
              label: 'Registration',
              onTap: () {
                if (widget.user.toLowerCase() == "user") {
                  showToast("Admin only");
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpView()));
                }
              }),
        ],
      ),
    );
  }

  Widget buildCtn(int i) {
    NewFeedModel newFeed = NewFeedModel.fromMap(items[i]);
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    STRINGS.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    newFeed.name.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    STRINGS.instruction,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    newFeed.instruction.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    STRINGS.caution,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    newFeed.caution.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    STRINGS.photo_path,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    newFeed.photo.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                ],
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          dbHelper.deleteNewFeed(newFeed.name).then((value) {
                            showToast(STRINGS.successfully_deleted);
                            _refreshController.requestRefresh();
                          }).catchError((error) {
                            print(error);
                          });
                        });
                      }),
                ],
              ),
            ],
          ),
        ));
  }

  void refresh() {
    // items.clear();
    setState(() {
      isFirst = true;
    });

    dbHelper.allNewFeed().then((data) {
      setState(() {
        isFirst = false;
        _refreshController.refreshCompleted();
        allNewFeed = data;
        items = allNewFeed;
      });
    }).catchError((error) {
      setState(() {
        showToast(STRINGS.no_data);
        // showMessageDialogAction(context, dialogActionCallBack, STRINGS.no_data);
        isFirst = false;
        _refreshController.refreshCompleted();
      });
    });
  }

  void dialogActionCallBack() {
    Navigator.pop(context);
  }
}
