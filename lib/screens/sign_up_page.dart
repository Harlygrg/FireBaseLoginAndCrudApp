import 'dart:io';

import 'package:firebase_authentication/Controller/controller.dart';
import 'package:firebase_authentication/widgets/refacored_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatelessWidget {
  Widgets _widgets = Widgets();
  GlobalKey _globalKey = GlobalKey();
  String? editedName;
  String? editDep;
  File? image;

  @override
  Widget build(BuildContext context) {
    if (AuthController.instance.isEdit == true) {
      AuthController.instance.userNameController.text =
          AuthController.instance.nameOndetail.toString();
      AuthController.instance.departmentController.text =
          AuthController.instance.departmentOndetail.toString();
      AuthController.instance.update();
    }

    return Scaffold(
      appBar: AppBar(
        title: AuthController.instance.isEdit == true
            ? Text("Edit Details")
            : Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              GetBuilder<AuthController>(
                builder: (controller) {
                  AuthController.instance.update();
                  return Form(
                    key: _globalKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _widgets.divider(height: 10),
                          _widgets.signUpTextField(
                              initValue: AuthController.instance.isEdit,
                              initialValue:
                                  AuthController.instance.nameOndetail.toString(),
                              controller: AuthController.instance.userNameController,
                              hintText: "Name",
                              context: context,
                              onChanged: (data) {
                                editedName = data;
                                print(
                                    "-----------------------------------editedname-----$editedName");
                              }),
                          _widgets.divider(height: 10),
                          _widgets.signUpTextField(
                              initValue: AuthController.instance.isEdit,
                              initialValue: AuthController.instance.departmentOndetail
                                  .toString(),
                              controller:
                                  AuthController.instance.departmentController,
                              hintText: "Department",
                              context: context,
                              onChanged: (data) {
                                editDep = data;
                                print(
                                    "-----------------------------------editedDep-----$editDep");
                              }),
                          _widgets.divider(height: 10),
                          AuthController.instance.isEdit == true
                              ? _widgets.divider()
                              : _widgets.signUpTextField(
                                  controller: AuthController.instance.mailController,
                                  hintText: "Email",
                                  context: context),
                          _widgets.divider(height: 10),
                          AuthController.instance.isEdit == true
                              ? _widgets.divider()
                              : _widgets.signUpTextField(
                                  controller:
                                      AuthController.instance.passwordController,
                                  obscureText: true,
                                  hintText: "Password",
                                  context: context),
                          _widgets.divider(),
                          _widgets.elevatedButton(
                              context: context,
                              onpressed: () {
                                if (AuthController.instance.isEdit == false) {
                                  AuthController.instance.userMailid = AuthController
                                      .instance.mailController.text
                                      .trim();
                                  AuthController.instance.usermail = AuthController
                                      .instance.mailController.text
                                      .trim();

                                  AuthController.instance.createTeacher(
                                      // userName:AuthController.instance.userNameController.text.trim().isEmpty?"default":
                                      //           AuthController.instance.userNameController.text.trim(),
                                      // age: int.parse(AuthController.instance.studentAge.text.trim().isEmpty?"0":
                                      //       AuthController.instance.studentAge.text.trim()),
                                      // department: AuthController.instance.departmentController.text.trim().isEmpty?"":
                                      //           AuthController.instance.departmentController.text.trim(),
                                      // semester: int.parse(AuthController.instance.studentSemester.text.trim().isEmpty?"0":
                                      //           AuthController.instance.studentSemester.text.trim())
                                      );
                                  AuthController.instance.register(
                                      AuthController.instance.mailController.text
                                          .trim(),
                                      AuthController.instance.passwordController.text
                                          .trim());
                                  //AuthController.instance.mailController.clear();
                                  //AuthController.instance.passwordController.clear();
                                  //AuthController.instance.disposeFunction();
                                } else {
                                  print(
                                      "=============================================${editedName}");
                                  if (editedName == null) {
                                    editedName = AuthController.instance.nameOndetail
                                        .toString();
                                  }
                                  if (editDep == null) {
                                    editDep = AuthController
                                        .instance.departmentOndetail
                                        .toString();
                                  }
                                  AuthController.instance.editDetails(
                                      editedName.toString(), editDep.toString());
                                  AuthController.instance.isEdit = false;
                                  AuthController.instance.mailController.clear();
                                  AuthController.instance.passwordController.clear();
                                  AuthController.instance.disposeFunction();
                                  Get.back();
                                }
                              },
                              buttonName: "Submit"),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
