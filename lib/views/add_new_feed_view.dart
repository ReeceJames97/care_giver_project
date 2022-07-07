import 'package:care_giver/DatabaseHandler/DbHelper.dart';
import 'package:care_giver/models/new_feed_model.dart';
import 'package:care_giver/utils/strings.dart';
import 'package:care_giver/utils/toast.dart';
import 'package:care_giver/views/home_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddNewFeedView extends StatefulWidget {
  late final String user;


  AddNewFeedView(this.user);

  @override
  State<AddNewFeedView> createState() => _AddNewFeedViewState();
}

class _AddNewFeedViewState extends State<AddNewFeedView> {

  TextEditingController nameController = TextEditingController();
  TextEditingController instructionController = TextEditingController();
  TextEditingController cautionController = TextEditingController();
  TextEditingController photoPathController = TextEditingController();

  late DbHelper dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUserData();
    dbHelper = DbHelper();
  }


  save() async{
    String photo = "";
    String name = nameController.text.toString();
    String instruction = instructionController.text.toString();
    String caution = cautionController.text.toString();
    String photoPath = photoPathController.text.toString();

    if(name.isEmpty){
      showToast(STRINGS.pls_enter_name);
    }else if(instruction.isEmpty){
      showToast(STRINGS.pls_enter_instruction);
    }else if(caution.isEmpty){
      showToast(STRINGS.pls_enter_caution);
    }else{
      if(photoPath.isEmpty){
        photo = "-";
      }else{
        photo = photoPathController.text.toString();
      }
      var newFeed = NewFeedModel({'name' : name, 'instruction' : instruction, 'caution' : caution, 'photo' : photo});
      await dbHelper.createNewFeed(newFeed).then((value) {
        showToast(STRINGS.successfully_saved);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>  HomeView(widget.user.toString())),
                (Route<dynamic> route) => false);
      }).catchError((error){
        if (kDebugMode) {
          print(error);
        }
        showToast(STRINGS.failed_to_save);
      });

    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(STRINGS.app_name),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              ///Name
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                // validator: (userName) => userName != null && userName.isEmpty ? STRINGS.pls_enter : null ,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: STRINGS.name,
                  // prefixIcon: const Icon(Icons.person)
                ),
                style: const TextStyle(fontSize: 15),
              ),

              const SizedBox(
                height: 10,
              ),

              ///Instruction
              TextFormField(
                controller: instructionController,
                maxLines: 3,
                keyboardType: TextInputType.text,
                // validator: (userName) => userName != null && userName.isEmpty ? STRINGS.pls_enter : null ,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: STRINGS.instruction,
                  // prefixIcon: const Icon(Icons.person)
                ),
                style: const TextStyle(fontSize: 15),
              ),

              const SizedBox(
                height: 10,
              ),

              ///Caution
              TextFormField(
                controller: cautionController,
                maxLines: 3,
                keyboardType: TextInputType.text,
                // validator: (userName) => userName != null && userName.isEmpty ? STRINGS.pls_enter : null ,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: STRINGS.caution,
                  // prefixIcon: const Icon(Icons.person)
                ),
                style: const TextStyle(fontSize: 15),
              ),

              const SizedBox(
                height: 10,
              ),

              ///PhotoPath
              TextFormField(
                controller: photoPathController,
                keyboardType: TextInputType.url,
                // validator: (userName) => userName != null && userName.isEmpty ? STRINGS.pls_enter : null ,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: STRINGS.photo_path,
                  // prefixIcon: const Icon(Icons.person)
                ),
                style: const TextStyle(fontSize: 15),
              ),

              const SizedBox(
                height: 10,
              ),

              ///Save Btn
              ElevatedButton.icon(
                onPressed: save,
                icon: const Icon(Icons.save),
                label: const Text(STRINGS.save),
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
