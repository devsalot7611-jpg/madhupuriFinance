import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madhupurifinance/Controller/FormController.dart';
import 'package:madhupurifinance/Controller/LoginController.dart';
import 'package:madhupurifinance/Utils.dart';
import 'package:madhupurifinance/kycList.dart';
import 'package:madhupurifinance/resetPassword.dart';
import 'package:pinput/pinput.dart';
import 'package:video_player/video_player.dart';

import 'Controller/KycListController.dart';
import 'forgotPass-user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.put(LoginController());
  final FormController formController = Get.put(FormController());
  bool _obscureText = true;
  bool login = false;
  bool _password = true;
  bool _Confirmpassword = true;
  late VideoPlayerController _controller;
  final int _count = 4;
  late TabController _tabController;
  var userIdDev;

  void goToNextTab() {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  void goToPreviousTab() {
    if (_tabController.index > 0) {
      _tabController.animateTo(_tabController.index - 1);
    }
  }

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
    getKycCode();
    _tabController = TabController(length: 4, vsync: this);
  }

  final KycListController kycListController = Get.put(KycListController());


  getKycCode()async {
    await kycListController.kycID();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose(); // properly dispose video controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Utils().background,
        body: TabBarView(
            controller: _tabController,
            children: [
              Stack(
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
                                width: isMobile ? 400 : 550,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 300,
                                      width: isMobile ? 200 : 275,
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Image.asset("assets/images/mflogo.png", height: 50, width: 50),
                                          ),
                                          SizedBox(height: 15,),
                                          Text(
                                            "User Name",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Utils().text,
                                            ),
                                          ),
                                          // const SizedBox(height: 8),
                                          SizedBox(
                                            height: 32,
                                            width: isMobile ? double.infinity : 400,
                                            child: TextFormField(
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              controller: loginController.userName,
                                              decoration: InputDecoration(
                                                hintText: "User Name",
                                                hintStyle: TextStyle(color: Utils().hintText,fontSize: 12),
                                                suffixIcon: Icon(Icons.email_outlined, color: Utils().text,size: 16,),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15,),
                                          Text(
                                            "Password",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Utils().text,
                                            ),
                                          ),
                                          // const SizedBox(height: 8),
                                          SizedBox(
                                            height: 32,
                                            width: isMobile ? double.infinity : 400,
                                            child: TextFormField(
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              onFieldSubmitted: (value) async {
                                                await loginController.loginApi(context);
                                              },
                                              obscureText: _obscureText,
                                              controller: loginController.password,
                                              decoration: InputDecoration(
                                                hintText: "Password",
                                                hintStyle: TextStyle(color: Utils().hintText,fontSize: 12),
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _obscureText = !_obscureText;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    _obscureText ? Icons.lock_outline : Icons.lock_open,
                                                    color: Utils().text,size: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  goToNextTab();
                                                  // Navigator.pushReplacement(
                                                  //   context,
                                                  //   MaterialPageRoute(builder: (context) => ForgotPass()),
                                                  // );
                                                },
                                                child: Text(
                                                  "Forgot Password?",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Utils().text,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Center(
                                            child: GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  loginController.loading.value = true;
                                                });
                                                FocusScope.of(context).unfocus(); // dismiss keyboard
                                                await loginController.loginApi(context);
                                                // Utils.dev = loginController.user['id'].toString();
                                                // print("abcduihidf id ${Utils.dev.toString()}");
                                                await kycListController.kycID();
                                                setState(() {
                                                  loginController.loading.value = false;
                                                });
                                                
                                              },
                                              child: Obx(() => Container(
                                                height: 28,
                                                width: isMobile ? double.infinity : 400,
                                                decoration: BoxDecoration(
                                                  color: Utils().text,
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Center(
                                                  child: loginController.loading.value
                                                      ? CircularProgressIndicator(
                                                    color: Utils().background,
                                                  )
                                                      : Text(
                                                    "Login",
                                                    style: TextStyle(
                                                      color: Utils().background,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: isMobile ? 200 : 275,
                                      height: isMobile ? double.infinity : 500,
                                      // padding: const EdgeInsets.all(20),
                                      // color: Colors.white,
                                      child: Image.asset(
                                        "assets/images/img.png",
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
              Stack(
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
                          width: isMobile ? 400 : 550,
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
                                  width: isMobile ? 200 : 275,
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
                                            final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
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
                                              goToNextTab();
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
                                width: isMobile ? 200 : 275,
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
              Stack(
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
                          width: isMobile ? 400 : 550,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            // color: Colors.white.withOpacity(0.9), // slightly transparent to see video behind
                          ),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [ // make sure to import
                              Container(
                                height: 300,
                                width: isMobile ? 200 : 275,
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
                                width: isMobile ? 200 : 275,
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
              Stack(
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
                          width: isMobile ? 400 : 550,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            // color: Colors.white.withOpacity(0.9), // slightly transparent to see video behind
                          ),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 310,
                                width: isMobile ? 200 :275,
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
                                width: isMobile ? 200 : 275,
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
            ])
      ),
    );
  }
  // body:
  // Stack(
  //           children: [
  //             // Background Video
  //             _controller.value.isInitialized
  //                 ? SizedBox.expand(
  //               child: FittedBox(
  //                 fit: BoxFit.cover,
  //                 child: SizedBox(
  //                   width: _controller.value.size.width,
  //                   height: _controller.value.size.height,
  //                   child: VideoPlayer(_controller),
  //                 ),
  //               ),
  //             )
  //                 : Container(color: Colors.black),
  //
  //             Center(
  //               child: Card(
  //                 color: Colors.transparent,
  //                 elevation: 4,
  //                 child: ConstrainedBox(
  //                   constraints: BoxConstraints(maxWidth: 550),
  //                   child: SizedBox(
  //                     height: 300,
  //                     width: isMobile ? double.infinity : 550,
  //                     child: isMobile
  //                         ? SingleChildScrollView(child: _buildLeftSection(isMobile, context))
  //                         : Row(
  //                       children: [
  //                         _buildLeftSection(isMobile, context),
  //                         _buildRightSection(isMobile, context),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  // Widget _buildLeftSection(bool isMobile, BuildContext context) {
  //   return Container(
  //     width: isMobile ? double.infinity : 275,
  //     padding: const EdgeInsets.all(20),
  //     color: Colors.white,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Center(
  //           child: Image.asset("assets/images/mflogo.png", height: 50, width: 50),
  //         ),
  //         SizedBox(height: 15,),
  //         Text(
  //           "User Name",
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w600,
  //             color: Utils().text,
  //           ),
  //         ),
  //         // const SizedBox(height: 8),
  //         SizedBox(
  //           height: 32,
  //           width: isMobile ? double.infinity : 400,
  //           child: TextFormField(
  //             style: TextStyle(
  //               fontSize: 12,
  //               fontWeight: FontWeight.bold
  //             ),
  //             controller: loginController.userName,
  //             decoration: InputDecoration(
  //               hintText: "User Name",
  //               hintStyle: TextStyle(color: Utils().hintText,fontSize: 12),
  //               suffixIcon: Icon(Icons.email_outlined, color: Utils().text,size: 16,),
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: 15,),
  //         Text(
  //           "Password",
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w600,
  //             color: Utils().text,
  //           ),
  //         ),
  //         // const SizedBox(height: 8),
  //         SizedBox(
  //           height: 32,
  //           width: isMobile ? double.infinity : 400,
  //           child: TextFormField(
  //             style: TextStyle(
  //                 fontSize: 12,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             onFieldSubmitted: (value) async {
  //               await loginController.loginApi(context);
  //             },
  //             obscureText: _obscureText,
  //             controller: loginController.password,
  //             decoration: InputDecoration(
  //               hintText: "Password",
  //               hintStyle: TextStyle(color: Utils().hintText,fontSize: 12),
  //               suffixIcon: IconButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     _obscureText = !_obscureText;
  //                   });
  //                 },
  //                 icon: Icon(
  //                   _obscureText ? Icons.lock_outline : Icons.lock_open,
  //                   color: Utils().text,size: 16,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(builder: (context) => ForgotPass()),
  //                 );
  //               },
  //               child: Text(
  //                 "Forgot Password?",
  //                 style: TextStyle(
  //                   fontSize: 11,
  //                   fontWeight: FontWeight.w600,
  //                   color: Utils().text,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 10,),
  //         Center(
  //           child: GestureDetector(
  //             onTap: () async {
  //               setState(() {
  //                 loginController.loading.value = true;
  //               });
  //               FocusScope.of(context).unfocus(); // dismiss keyboard
  //               await loginController.loginApi(context);
  //               await kycListController.kycID();
  //               setState(() {
  //                 loginController.loading.value = false;
  //               });
  //             },
  //             child: Obx(() => Container(
  //               height: 28,
  //               width: isMobile ? double.infinity : 400,
  //               decoration: BoxDecoration(
  //                 color: Utils().text,
  //                 borderRadius: BorderRadius.circular(5),
  //               ),
  //               child: Center(
  //                 child: loginController.loading.value
  //                     ? CircularProgressIndicator(
  //                   color: Utils().background,
  //                 )
  //                     : Text(
  //                   "Login",
  //                   style: TextStyle(
  //                     color: Utils().background,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ),
  //             )),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildRightSection(bool isMobile, BuildContext context) {
  //   // Since we are conditionally calling this only on non-mobile, you don’t need isMobile here
  //   return SizedBox(
  //     width: isMobile ? double.infinity : 275,
  //     height: isMobile ? double.infinity : 500,
  //     // padding: const EdgeInsets.all(20),
  //     // color: Colors.white,
  //     child: Image.asset(
  //       "assets/images/img.png",
  //       fit: BoxFit.fill,
  //     ),
  //   );
  // }

}
