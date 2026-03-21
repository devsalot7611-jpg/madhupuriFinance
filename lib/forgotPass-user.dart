import 'package:flutter/material.dart';
import 'package:madhupurifinance/Controller/LoginController.dart';
import 'package:madhupurifinance/HomeSacreen.dart';
import 'package:madhupurifinance/Login.dart';
import 'package:madhupurifinance/Utils.dart';
import 'package:get/get.dart';
import 'package:madhupurifinance/emailOTP.dart';
import 'package:video_player/video_player.dart';


class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {

  final LoginController loginController = Get.put(LoginController());
  late VideoPlayerController _controller;

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
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils().background,
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
                  height: 300,
                  width: 550,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // color: Colors.white.withOpacity(0.9), // slightly transparent to see video behind
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Form(
                        key: _formKey,
                        child: Container(
                          height: 300,
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
                              SizedBox(height: 10), // spacing
                              Text(
                                "Forgot Password",
                                style: TextStyle(
                                  color: Utils().text,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 30),
                              Text(
                                "Email",
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
                                      fontWeight: FontWeight.bold
                                  ),
                                  onFieldSubmitted: (value) async {
                                    loginController.verifyEmailLoader = true.obs;

                                    if (_formKey.currentState!.validate()) {
                                      await loginController.email(context);
                                    } else {
                                      // Invalid email
                                    }
                                    loginController.verifyEmailLoader = false.obs;
                                  },
                                  controller: loginController.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      color: Utils().hintText,
                                      fontSize: 12,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Utils().text,
                                      size: 18,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email is required';
                                    }
                                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                    if (!emailRegex.hasMatch(value)) {
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 30,),
                              Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      loginController.verifyEmailLoader = true.obs;
                                    });
                                    if (_formKey.currentState!.validate()) {
                                      await loginController.email(context);
                                    } else {
                                      // Invalid email
                                    }
                                    setState(() {
                                      loginController.verifyEmailLoader = false.obs;
                                    });
                                  },
                                  child: Obx(() => Container(
                                    height: 28,
                                    width: 311,
                                    decoration: BoxDecoration(
                                      color: Utils().text,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: loginController.verifyEmailLoader.value
                                          ? CircularProgressIndicator(
                                        color: Utils().background,
                                      )
                                          : Text(
                                        "Verify Email",
                                        style: TextStyle(
                                          color: Utils().background,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )),
                                  // child: Container(
                                  //   height: 28,
                                  //   width: 311,
                                  //   decoration: BoxDecoration(
                                  //     color: Utils().text,
                                  //     borderRadius: BorderRadius.circular(5),
                                  //   ),
                                  //   child: Center(
                                  //     child: Text("Verify Email",style: TextStyle(
                                  //         color: Utils().background,
                                  //         fontSize: 16,
                                  //         fontWeight: FontWeight.w600
                                  //     ),),
                                  //   ),
                                  // ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_back,color: Utils().text,size: 14,),
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
                      ),
                      Container(
                        height: 300,
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
