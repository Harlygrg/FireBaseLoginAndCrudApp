import 'dart:io';

import 'package:firebase_authentication/Controller/controller.dart';
//import 'package:firebase_authentication/screens/profile_page.dart';
import 'package:firebase_authentication/screens/sign_up_page.dart';
import 'package:firebase_authentication/widgets/refacored_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class HomePage extends StatelessWidget {
   HomePage({Key? key}) : super(key: key);
  Widgets _widgets = Widgets();
  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;
    AuthController.instance.isSignUp=false;
     profileImg(){
      if(AuthController.instance.image!=null){
        return FileImage(AuthController.instance.image!);
      }
      else{
        return AssetImage("imageAssets/profilePic2.PNG");
      }
    }
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            _widgets.divider(height: 25),
             GetBuilder<AuthController>(
               id: "profileArea",
               builder: (controller) {
                 return Container(
                   width:_w,
                   height: _w/3,
                   decoration:const BoxDecoration(
                     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),
                       bottomRight: Radius.circular(20),),
                     //color: Color(0xff0040ff),

                   ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Center(
                         child: GestureDetector(
                           onTap: () async {
                             //await AuthController.instance.imagePick();
                           await AuthController.instance.profilePic();
                           AuthController.instance.saveProf();

                           },
                           child: Container(
                            //margin:const EdgeInsets.only(right: 10,top: 10),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(width: 2,color: Colors.white),
                                // image: DecorationImage(
                                //     image:!,
                                //     //AssetImage("imageAssets/profilePic2.PNG",)
                                //     fit:BoxFit.fill )
                            ),
                            child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white,
                                child: ClipOval(


                                  child: (AuthController.instance.url2 != null)
                                      ? Image.network("${AuthController.instance.url2!}")
                                      : Image.asset("imageAssets/profilePic2.PNG"),
                                )
                            ),
            ),
                         ),
                       ),
                     ],
                   ),
                 );
               }
             ),

           FutureBuilder<UserModel?>(

             future: AuthController.instance.readUser(),
             builder: (context,snapshot) {
               if(snapshot.hasError){
                 return Text("Something went wrong");
               }
               else if(snapshot.hasData){
                 final user = snapshot.data;
                 AuthController.instance.nameOndetail=user!.name;
                 AuthController.instance.departmentOndetail=user!.course;
                 AuthController.instance.update();
                 return user==null?Text("No user"): Padding(
                   padding: EdgeInsets.all(8.0),
                   child: Column(
                     children: [
                       Card(
                         child: ListTile(title: Text(user.name!),),
                       ),
                       _widgets.divider(height: 8),
                       Card(
                         child: ListTile(title: Text(user.course!),),
                       )
                     ],
                   ),
                 );
               }
               else{
                 return Center(child: CircularProgressIndicator(),);
               }

             }
           ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(title: Text("${AuthController.instance.userMailid}"),),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _widgets.elevatedButton(
                    context: context,
                    onpressed: (){
                      AuthController.instance.isEdit=true;
                      Get.to(()=>SignUp());
                    },
                    buttonName: "Edit Details"),
                _widgets.elevatedButton(
                    context: context,
                    onpressed: (){
                      AuthController.instance.isEdit==false;
                      Get.back();
                    },
                    buttonName: "Home"),
              ],
            ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Spacer(),
            Text("Change"),
            // TextButton(onPressed:(){
            //
            //   showDialog(
            //       context: context,
            //       builder: (context){
            //         return _widgets.emaiOrPasswordChangePopUp(context: context,
            //             controller: AuthController.instance.emailResetController,
            //             hintText: "Enter New email",
            //             onTap: (){
            //               AuthController.instance.chageEmail();
            //               Get.to(()=>HomePage());
            //             },
            //             buttonName: "Set new Email");
            //       });
            //
            // }, child: Text(" Email ")),

           // Text("or"),
              TextButton(onPressed: (){

                showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _widgets.textField(
                                context: context,
                                hintText: "Enter New password",
                                controller: AuthController.instance.passwordResetController
                            ),
                            _widgets.elevatedButton(
                                context: context,
                                onpressed: (){
                                  AuthController.instance.chagePassword();
                                  Navigator.pop(context);
                                },
                                buttonName: "Set new password")
                          ],
                        ),
                      );
                    });

              }, child: Text("Password")),

              Spacer(),
          ],),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Welcome ${AuthController.instance.userMailid=AuthController.instance.userMailid}.",
          style:const TextStyle(fontSize: 20),),
        // leading: IconButton(icon:const Icon(
        //   Icons.menu_outlined,
        // ),
        // onPressed: (){},),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: _w,
            height: _h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                _widgets.divider(),
                // Padding(
                //   padding: const EdgeInsets.all(5.0),
                //   child: Text("Welcome ${AuthController.instance.userMailid}.",
                //     style: TextStyle(fontSize: 20,color: Colors.black)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: _h*.6,
                    child: StreamBuilder<List<UserModel>>(
                      stream: AuthController.instance.readUsers(),
                      builder: (context,snapshot){
                        if(snapshot.hasError){
                          return Text("Something went wrong");
                        }
                            else if(snapshot.hasData){
                              final users = snapshot.data;
                              return ListView(
                                children: users!.map(buildList).toList(),
                              );
                            } else{
                              return Center(child: CircularProgressIndicator(),);
                        }
                      },
                    ),
                  ),
                ),

                _widgets.divider(),
                _widgets.divider(),
                      //Spacer(flex: 100,),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding:  EdgeInsets.only(bottom: _h/10),
                    child: SizedBox(width: _w*.60,
                      height: 50,
                      child: _widgets.elevatedButton(context: context,
                          onpressed: (){
                        AuthController.instance.isEdit=true;
                        AuthController.instance.isSignUp =false;
                        AuthController.instance.update();
                        AuthController.instance.userNameController.clear();
                        AuthController.instance.departmentController.clear();
                        AuthController.instance.logout();
                           // Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                          },
                          buttonName: "Logout"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          backgroundColor: Color(0xff0080ff),
          onPressed: (){
            showDialog(
                context: context, builder: (BuildContext context){
                  return AlertDialog(
                    title: Text("Add Student Details",
                      style: TextStyle(fontSize: 20,color: Colors.black),),
                    actions: [
                      Form(child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                      _widgets.signUpTextField(
                          controller:AuthController.instance.studentName ,
                          context: context, hintText: "Student name"),
                          _widgets.divider(height: 10),
                      _widgets.signUpTextField(
                          controller:AuthController.instance.studentCourse ,
                          context: context, hintText: "Student Course"),
                          _widgets.divider(height: 10),
                      _widgets.signUpTextField(
                        keyboardType: TextInputType.number,
                          controller:AuthController.instance.studentAge ,
                          context: context, hintText: "Age"),
                          _widgets.divider(height: 10),
                      _widgets.signUpTextField(
                          controller:AuthController.instance.studentSemester,
                          keyboardType: TextInputType.number,
                          context: context, hintText: "Semester"),
                          _widgets.divider(),
                          //save button
                          _widgets.elevatedButton(context: context, onpressed:(){

                            AuthController.instance.createStudent();
                            AuthController.instance.disposeFunction();
                            Get.snackbar("Data Saved", "",
                            backgroundColor: Colors.deepPurple,
                              snackPosition: SnackPosition.BOTTOM,

                            );
                           // Get.back();
                            Navigator.pop(context);
                          }, buttonName:"Save")
                        ],
                      ))
                    ],
                  );
            });
          }),
    );
  }

  Widget buildList(UserModel user)=>ListTile(
    leading: Text(user.name!),
    title: Text(user.course!),
    subtitle: Text("semester: ${user.semester}"),
    trailing: Text("age : ${user.age}"),
  );
}
