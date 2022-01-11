import 'package:firebase_authentication/screens/sign_up_page.dart';
import 'package:firebase_authentication/widgets/refacored_widgets.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  Widgets _widgets = Widgets();
  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: _w,
              height:  _h/2.8,
              decoration:const BoxDecoration(
               //color: Colors.red,
                // borderRadius: BorderRadius.only(
                //   bottomLeft: Radius.circular(_w*.50),
                // bottomRight:Radius.circular(_w*.50), )
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left:-_w/4,
                    top: -_w,
                    child: Center(
                      child: Container(
                        width: _w*1.5,
                        height: _w*1.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(300),
                            gradient:const LinearGradient(colors: [Color(0xff4000ff),Color(0xff00ffff)],
                              stops: [.6,1],
                              begin:Alignment.topCenter,
                              end: Alignment.bottomCenter
                            )
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left:_w/2-75,
                    top: _h/7,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(75),
                          border: Border.all(color: Colors.white,width: 2),
                          color: Colors.blue,
                      ),
                    ),
                  ),
                 const Positioned(
                    left:100 ,
                    top: 50,
                    child: Text("Welcome ",style: TextStyle(fontSize: 20,color: Colors.white),),
                  ),

                ],
              ),
            ),
            _widgets.divider(),
            _widgets.listTile(
              text: "Name",icon:const  Icon(
              Icons.perm_identity_outlined,
            ),),
            _widgets.listTile(text: "Email",icon:const  Icon(
              Icons.email_outlined,
            )),
            _widgets.listTile(text: "Password",icon:const Icon(
              Icons.visibility_sharp,
            ),),
            _widgets.divider(),
            _widgets.elevatedButton(context: context,
                onpressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                },
                buttonName: "Edit details")
          ],
        ),
      ),
    );
  }
}
