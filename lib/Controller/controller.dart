import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' ;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/screens/home_page.dart';
import 'package:firebase_authentication/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AuthController extends GetxController {
//AuthController instance
  static AuthController instance = Get.find();

  //emai, password,name
  late Rx<User?> _user;

  FirebaseAuth auth = FirebaseAuth.instance;
  bool isTeacherDetails = false;
  bool isEdit = false;
  String? usermail;
  String? userDepartment;
  String? nameOndetail;
  String? departmentOndetail;
  bool isSignUp = false;
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordResetController = TextEditingController();
  TextEditingController emailResetController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  TextEditingController studentName = TextEditingController();
  TextEditingController studentAge = TextEditingController();
  TextEditingController studentCourse = TextEditingController();
  TextEditingController studentSemester = TextEditingController();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

//login integration

  String? userMailid = "";

  _initialScreen(User? user) {
    if (user == null) {
      print("Login page");
      Get.offAll(() => LoginPage());
    } else {
      userMailid = user.email;
      profilePicChek();
      Get.offAll(() => HomePage());
    }
  }

  void register(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      userMailid = mailController.text.trim();
      //mailController.clear();
      passwordController.clear();
    } catch (e) {
      Get.snackbar(
        "About user",
        "User message",
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Regestration failed",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        messageText: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      //mailController.clear();
      passwordController.clear();
    } catch (e) {
      Get.snackbar(
        "About Login",
        "Login message",
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Login failed",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  logout() async {
    update();
    await auth.signOut();
  }

  disposeFunction() {
    studentName.clear();
    studentAge.clear();
    studentSemester.clear();
    studentCourse.clear();
  }

  //firestore operations
  Future createStudent() async {
    String stname =
        studentName.text.trim().isEmpty ? "default" : studentName.text.trim();
    String course =
        studentCourse.text.trim().isEmpty ? "" : studentCourse.text.trim();
    int age = int.parse(
        studentAge.text.trim().isEmpty ? "0" : studentAge.text.trim());
    int semester = int.parse(studentSemester.text.trim().isEmpty
        ? "0"
        : studentSemester.text.trim());
    final user =
        UserModel(name: stname, age: age, semester: semester, course: course);
    final json = user.toJsonMap();
    var docUser =
        FirebaseFirestore.instance.collection(userMailid!).doc(stname);

    // final json= {
    //   "name":studentName.text.trim(),
    //   "age" :int.parse(studentAge.text.trim()),
    //   "semester":int.parse(studentSemester.text.trim()),
    //   "course"  : studentCourse.text.trim()
    // };
    await docUser.set(json);
    disposeFunction();
  }

  Future createTeacher(
      // {required String userName,String? department,int? age,int? semester}
      ) async {
    String userName = userNameController.text.trim().isEmpty
        ? "default"
        : userNameController.text.trim();
    String department = departmentController.text.trim().isEmpty
        ? ""
        : departmentController.text.trim();
    int age = int.parse(
        studentAge.text.trim().isEmpty ? "0" : studentAge.text.trim());
    int semester = int.parse(studentSemester.text.trim().isEmpty
        ? "0"
        : studentSemester.text.trim());
    print(
        "^^^^^---------------------------- name:$userName,dep: $department,age: $age, Semester: $semester,mailid:${userMailid}");
    final user = UserModel(
        name: userName, age: age, semester: semester, course: department);
    final json = user.toJsonMap();
    // String userColl="${userMailid.toString()}UD";
    final docUserNew = FirebaseFirestore.instance
        .collection("${userMailid.toString()}UD")
        .doc("${userMailid.toString()}");

    // final json= {
    //   "name":studentName.text.trim(),
    //   "age" :int.parse(studentAge.text.trim()),
    //   "semester":int.parse(studentSemester.text.trim()),
    //   "course"  : studentCourse.text.trim()
    // };
    await docUserNew.set(json);

    disposeFunction();
  }

  editDetails(String name, String depart) {
    print(
        "################################  mail: $userMailid, %%%%%%% ,name:$name, department: $depart");
    final docUserEdit = FirebaseFirestore.instance
        .collection("${userMailid.toString()}UD")
        .doc("${userMailid.toString()}");
    docUserEdit.update({'name': name, 'course': depart});
  }

  Stream<List<UserModel>> readUsers() => FirebaseFirestore.instance
      .collection(userMailid.toString())
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());

  Future<UserModel?> readUser() async {
    print(
        "============================================================${userMailid.toString()}UD");
    final docUser2 = FirebaseFirestore.instance
        .collection("${userMailid.toString()}UD")
        .doc(userMailid);
    final snapshot = await docUser2.get();
    if (snapshot.exists) {
      return UserModel.fromJson(snapshot.data()!);
    }
  }

  //update email or password
  final currentUser = FirebaseAuth.instance.currentUser;

  chagePassword() async {
    try {
      await currentUser!.updatePassword(passwordResetController.text);
      //logout();
      Get.snackbar("title", "",
          messageText:
              Center(child: Text("Your paswword has been changed login again")),
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      return e;
    }
  }

  chageEmail() async {
    try {
      await currentUser!.updateEmail(emailResetController.text.trim());
      //logout();
      Get.snackbar("title", "",
          messageText:
              Center(child: Text("Your email has been changed, login again")),
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      return e;
    }
  }

  File? image;
  String? uploadedFileUrl;
  UploadTask ? task;
  var urlDownload;

  Future imagePick() async {
    print("---------------imageAddress-------");
    try {
      print("---------------imageAddress-------");
      final pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.gallery,maxWidth: 115,maxHeight: 115, )
          .then((value) {
        image = File(value!.path);

      }).whenComplete(() =>
          uploadImage()
          //displayImage()
      );
      task =uploadImage();
      if(task==null) return;
      final snapshot = await task!.whenComplete(() => (){});
       urlDownload =snapshot.ref.getDownloadURL();
      print('===================== url :$urlDownload');
      update(["profileArea"]);

      //.then((value) => null);
      // if (image == null) {
      //   return;
      // }
      // final imageTemperory = File(pickedImage!.path);
      // image= imageTemperory;
      // print("---------------imageAddress-------");
      // update();
    } on PlatformException catch (e) {
      print("failed to pick image: $e");
    }
  }
  Future downloadUrl()async{


  }

  late File? dummy;


  displayImage()async{
     print("The Image fetched is $image");
     dummy = image;
     //update(["profileArea"]);
  }
  // Future downloadImage()async{
  //   final snapshot = await uploadImage().whenComplete(() {});
  //   final urlDownload = await snapshot.r
  // }

 UploadTask? uploadImage(){
    var putImg;
   try{
     print("----------------downloadlink: urlDownload");
      final fileName = basename(image!.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref("profilePic/${fileName}");
     putImg = ref.putFile(image!);
     print("------------====================================----downloadlink: urlDownload2");

      print("-----------==================-----downloadlink3: urlDownload");
      return putImg;
    } on FirebaseException catch(e){
         return null;
   }
  }
    File ?imageFile;
  Future profilePic()async{
    final image = await FilePicker.platform.
    pickFiles(allowMultiple: false,type: FileType.image);
    if(image==null) return;
    final path = image.files.single.path;
    update();
    imageFile = File(path!);
  }
  UploadTask? task2;
  var url2;

Future saveProf()async{
print("-----------------------------================= Mubasheer help1 $userMailid");
    if(imageFile==null) return;
print("-----------------------------================= Mubasheer help2 $userMailid");
    final destination = "${userMailid}/profilePic";
print("-----------------------------================= Mubasheer help 3$userMailid");
    task2 = uploadTask(destination,imageFile!);
print("-----------------------------================= Mubasheer help4 $userMailid");
    if(task2==null) return;
print("-----------------------------================= Mubasheer help5 $userMailid");
    final snapshot = await task2!.whenComplete(() => (){});
print("-----------------------------================= Mubasheer help6 $userMailid");
    url2 = await snapshot.ref.getDownloadURL();
    update(["profileArea"]);
    print("======================================== $url2");

}
UploadTask? uploadTask(String destination, File file){
  try{
    Reference storageRef = FirebaseStorage.instance.ref(destination);
    return storageRef.putFile(file);
  } on FirebaseException catch(e){
    print(e);
  }
}
profilePicChek()async{
  final destination = "${userMailid}/profilePic";
  try{
    var dbRef = FirebaseStorage.instance.ref(destination);
    url2 =await dbRef.getDownloadURL();
    update();
    print("------- $url2");
  }catch(e){
    return;
  }

}


}




class UserModel {
  String? name = "";
  int? age = 0;
  int? semester = 0;
  String? course = "";

  UserModel({this.name, this.age, this.semester, this.course});

  Map<String, dynamic> toJsonMap() => {
        "name": name,
        "age": age,
        "semester": semester,
        "course": course,
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      name: json["name"],
      age: json["age"],
      semester: json["semester"],
      course: json["course"]);
}
