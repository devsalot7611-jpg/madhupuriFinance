import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madhupurifinance/HomeSacreen.dart';
import 'package:madhupurifinance/Login.dart';
import 'package:video_player/video_player.dart';

import 'Controller/LoginController.dart';
import 'Utils.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final LoginController loginController = Get.put(LoginController());
  bool _password = true;
  bool _Confirmpassword = true;
  late VideoPlayerController _controller;
  bool login = false;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/backgroundVideo.mp4")
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Video
          _controller.value.isInitialized
              ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          )
              : Container(color: Colors.black),
          Center(
              child: Card(
                color: Colors.transparent,
                elevation: 4,
                child: Container(
                  height: 310,
                  width: 550,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // color: Colors.white.withOpacity(0.9), // slightly transparent to see video behind
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 310,
                        width: 275,
                        color: Colors.white,
                        padding: EdgeInsets.all(20), // added padding around content
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.asset(
                                "assets/images/mflogo.png",
                                height: 50,
                                width: 50,
                              ),
                            ),
                            SizedBox(height: 15), // spacing
                            Text(
                              "Reset Password",
                              style: TextStyle(
                                color: Utils().text,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Password",
                              style: TextStyle(
                                color: Utils().text,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              height: 35,
                              width: 400,
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                obscureText: _password,
                                controller: loginController.newPasssword,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Utils().hintText,
                                    fontSize: 12
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _password = !_password;
                                      });
                                    },
                                    icon: Icon(
                                      _password
                                          ? Icons.lock_outline
                                          : Icons.lock_open,
                                      color: Utils().text,
                                      size: 14,
                                    ),
                                  ),

                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Confirm Password",
                              style: TextStyle(
                                color: Utils().text,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              height: 35,
                              width: 400,
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                obscureText: _Confirmpassword,
                                controller: loginController.confPasssword,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Utils().hintText,
                                    fontSize: 12,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _Confirmpassword = !_Confirmpassword;
                                      });
                                    },
                                    icon: Icon(
                                      _Confirmpassword
                                          ? Icons.lock_outline
                                          : Icons.lock_open,
                                      color: Utils().text,
                                      size: 14,
                                    ),
                                  ),

                                ),
                              ),
                            ),

                            SizedBox(height: 10,),
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  if(loginController.newPasssword == loginController.confPasssword) {
                                    await loginController.resetPassword(context);
                                  }
                                  else{
                                    Get.snackbar("please enter the same password", "new passsword conform passsword are same");
                                  }
                                },
                                child: Container(
                                  height: 28,
                                  width: 311,
                                  decoration: BoxDecoration(
                                    color: Utils().text,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text("Reset Password",style: TextStyle(
                                        color: Utils().background,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                    ),),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_back,color: Utils().text,size: 16,),
                                  Text("Back to login",style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Utils().text,
                                  ),)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 310,
                        width: 275,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/img.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}
