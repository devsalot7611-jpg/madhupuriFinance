import 'package:flutter/material.dart';
import 'package:madhupurifinance/resetPassword.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'Controller/LoginController.dart';
import 'Login.dart';
import 'Utils.dart';
import 'package:pinput/pinput.dart';

class EmailOtp extends StatefulWidget {
  const EmailOtp({super.key});

  @override
  State<EmailOtp> createState() => _EmailOtpState();
}

class _EmailOtpState extends State<EmailOtp> {

  final LoginController loginController = Get.put(LoginController());
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
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
                  height: 300,
                  width: 550,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // color: Colors.white.withOpacity(0.9), // slightly transparent to see video behind
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [ // make sure to import
                      Container(
                        height: 300,
                        width: 275,
                        color: Colors.white,
                        padding: EdgeInsets.all(20),
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
                            SizedBox(height: 20),
                            Text(
                              "Verification Code",
                              style: TextStyle(
                                color: Utils().text,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 20),

                            Center(
                              child: Pinput(
                                controller: loginController.OTPController,
                                length: 6, // number of OTP digits
                                defaultPinTheme: PinTheme(
                                  width: 50,
                                  height: 50,
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    color: Utils().text,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Utils().border_1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                focusedPinTheme: PinTheme(
                                  width: 50,
                                  height: 30,
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    color: Utils().text,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Utils().button),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                showCursor: true,
                                onCompleted: (pin) {
                                  print('Completed: $pin');
                                },
                              ),
                            ),
                            SizedBox(height: 30),
                            Center(
                              child: GestureDetector(
                                onTap: () async{
                                  // verify OTP logic
                                  print("OTP check ${loginController.OTPController}");
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResetPassword(),));
                                },
                                child: Container(
                                  height: 30,
                                  width: 311,
                                  decoration: BoxDecoration(
                                    color: Utils().text,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Verify OTP",
                                      style: TextStyle(
                                        color: Utils().background,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => Login()),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_back, color: Utils().text, size: 16),
                                  SizedBox(width: 5),
                                  Text(
                                    "Back to login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Utils().text,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 450,
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
