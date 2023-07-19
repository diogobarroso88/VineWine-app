import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



import '../APIservices/apiservice.dart';
import '../app_theme.dart';
import '../main.dart';


class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  Future<bool> _onBackPressed() async {
    return false;
  }


  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppTheme.nearlyWhite.withOpacity(0.1),
          body: SingleChildScrollView(
            child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 150,
                      left: 50,
                      right: 50,
                    ),
                    child: Image.asset('assets/images/logo_homepage.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 50,
                      right: 50,
                    ),
                    child: Image.asset('assets/images/logo_simbolos.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 300,
                      left: 180,
                      right: 50,
                      bottom: 10,
                    ),
                    child: const Text("POWERED BY",
                      style: TextStyle(
                          color: Color(0xFF346cb0),
                          fontSize: 10,
                          fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 230,
                      right: 50,
                      bottom: 100,
                    ),
                    child: Image.asset('assets/images/my_sense.png'),
                  ),


                ]
            ),
          )
      ),
    );
  }
}
