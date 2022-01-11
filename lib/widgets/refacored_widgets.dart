import 'package:flutter/material.dart';
 class Widgets {


   Widget textField({required BuildContext context,required String hintText,Icon ?icon,
     TextEditingController ?controller,bool obscureText= false,
                      }){
    return SizedBox(
      width: MediaQuery.of(context).size.width*.90,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            hintText: hintText,
          prefixIcon: icon,
        ),
      ),
    );
   }

   Widget  elevatedButton({
   required BuildContext context,
     required Function() onpressed,
     required String buttonName
 }){
     return ElevatedButton(
         onPressed: onpressed,
         style: ElevatedButton.styleFrom(
           primary: Color(0xff1a53ff),
         ),
         child: Text(buttonName));
   }

   Widget divider({double height=25}){
     return  SizedBox(height: height,);
   }

   Widget listTile({Icon ?icon,required String text}){
     return  ListTile(leading: icon,title: Text(text),

     );
   }


   Widget signUpTextField({required BuildContext context,required String hintText,Icon ?icon,
     TextInputType keyboardType= TextInputType.text,
     TextEditingController ?controller,bool obscureText= false,bool initValue=false,String initialValue="",
     Function(String data)? onChanged,
   }){
     return SizedBox(
       width: MediaQuery.of(context).size.width*.90,
       child: initValue==false? TextFormField(
         //initialValue: ,
         controller: controller,
         keyboardType: keyboardType,
         obscureText: obscureText,
         decoration: InputDecoration(
           // border: OutlineInputBorder(
           //   borderRadius: BorderRadius.all(Radius.circular(30)),
           // ),
           hintText: hintText,
           prefixIcon: icon,
         ),
       ):TextFormField(
         initialValue: initialValue,
         keyboardType: keyboardType,
         obscureText: obscureText,
         onChanged: onChanged,
         decoration: InputDecoration(
           // border: OutlineInputBorder(
           //   borderRadius: BorderRadius.all(Radius.circular(30)),
           // ),
           hintText: hintText,
           prefixIcon: icon,
         ),
       ),
     );

   }

   Widget emaiOrPasswordChangePopUp({
     context,required TextEditingController controller
     ,required String hintText,
     required Function() onTap,
     required String buttonName
   }){
     return AlertDialog(
       content: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           signUpTextField(
               context: context,
               hintText: hintText,
               controller: controller
           ),
           elevatedButton(
               context: context,
               onpressed: onTap,
               buttonName: buttonName)
         ],
       ),
     );
   }


 }