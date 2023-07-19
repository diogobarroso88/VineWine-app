import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyScreen extends StatefulWidget {
  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 100,
                      left: 50,
                      right: 50,
                      bottom: 10,
                    ),
                    child: Image.asset('assets/images/logo_homepage.png'),
                  ),


                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,100,0,0),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(12,0,12,0),
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff336db0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                offset: const Offset(4, 4),
                                blurRadius: 8.0),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              print ("OLA");
                              final Uri toLaunch =
                              Uri(scheme: 'https', host: 'mysenseapi.utad.pt', path: 'docs/privacy');

                              if (await canLaunchUrl(toLaunch)) {
                                await launchUrl(toLaunch);
                              } else {
                                throw 'Could not launch $toLaunch';
                              }
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  AppLocalizations.of(context).privacy,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
