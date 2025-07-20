import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:katlavan24/core/enums/auth_status.dart';
import 'package:katlavan24/core/network/dio_client.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/feat/auth/presentation/intro_page.dart';
import 'package:katlavan24/feat/client_home/presentation/client_home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.mainColor,
      bottomNavigationBar: SizedBox(
        height: 150,
        child: Center(child: CupertinoActivityIndicator(color: Colors.white,)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(30),

        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/auth/logo.png', width: MediaQuery.of(context).size.width*0.45,),
            SizedBox(height: 40,),
            Image.asset('assets/auth/truck.png',width: MediaQuery.of(context).size.width*0.7,),
          ],
        )),
      ),
    );
  }

  Future load() async {
    AuthenticationStatus status = await checkUser();
    if (status == AuthenticationStatus.authenticated && mounted) {
      return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ClientHomePage()),
        (route) => false,
      );
    }

    if (mounted) {
      return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => status == AuthenticationStatus.unauthenticated ? IntroPage() : NoInternetPage(message: 'Connect to Internet'),
        ),
        (route) => false,
      );
    }
  }

  Future<AuthenticationStatus> checkUser() async => DioClient().init();
}
class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:AppColors.mainColor,body: Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wifi_off_rounded,size: 100,color: Colors.white,),
        SizedBox(height: 30,),
        Text(message,style: AppStyles.s32w600.copyWith(color: Colors.white),),
      ],
    ),),);
  }
}
