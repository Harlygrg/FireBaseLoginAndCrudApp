import 'package:firebase_authentication/Controller/controller.dart';
import 'package:firebase_authentication/screens/profile_page.dart';
import 'package:firebase_authentication/screens/sign_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_authentication/widgets/refacored_widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class LoginPage extends StatelessWidget {
   LoginPage({Key? key}) : super(key: key);
  final Widgets  _widgets = Widgets();
   @override
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    AuthController.instance.isSignUp=true;
    return  Scaffold(
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: w,
                height: h*.3,
                //205,
                child: Stack(
                  //clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left:200,
                      top: -h/5,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(125),
                          gradient:const LinearGradient(colors: [Color(0xff4000ff),Color(0xff00ffff)])
                        ),
                      ),
                    ),
                    Positioned(
                      left:-50,
                      top: -h/4.7,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          gradient:const LinearGradient(colors: [Color(0xff4000ff),Color(0xff00ffff)]),
                        ),
                      ),
                    ),
                    // const Positioned(
                    //   left: 30,
                    //   top: 70,
                    //   child: Text("Welcome\n",style: TextStyle(fontSize: 30,color: Colors.white),),
                    // ),
                  ],
                ),
              ),
                SizedBox(height:h/20 ,),
              Form(child:
              Column(
                children: [
                  _widgets.textField(
                    hintText: "Email",context: context,
                    controller:AuthController.instance.mailController,
                    icon:const Icon(
                      Icons.email_outlined,
                    ),
                  ),
                  const SizedBox(height: 25,),
                  _widgets.textField(
                    controller: AuthController.instance.passwordController,
                      hintText: "Password",context: context,
                    obscureText: true,
                    icon:const Icon(
                      Icons.lock_outlined,
                    ),
                  ),

                ],
              ),
              ),
              const SizedBox(height: 25,),
              _widgets.divider(),
              SizedBox(width: w/1.5,
                height: 50,
                child: _widgets.elevatedButton(context: context,
                    onpressed: (){
                  // Get.to(ProfilePage());
                      AuthController.instance.usermail =AuthController.instance.mailController.text.trim();
                      AuthController.instance.login(AuthController.instance.mailController.text.trim(),
                          AuthController.instance.passwordController.text.trim());
                    }, buttonName: "Submit"),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*.60,
                child: Row(
                  children: [
                    const Text("Don't have an account ? "),
                    TextButton(onPressed: (){
                      Get.to(SignUp());
                    }, child:const Text("Sign Up"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
