import 'dart:io';
import 'dart:math';
import '../main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../APIservices/apiservice.dart';
import '../database/token_storage.dart';
import 'login_screen.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSomeProgress = false;

  //objectbox
  late String nome = "";
  late String image = "";
  late String username = "";
  late String email = "";
  late String imageUrl= "";
  late int nrServicos = 0;
  late int nrObs = 0;
  late List<String> subsSlugs = [];
  late List<String> _slugs = [];
  late int id = 0;
  late List<String> userGroupsName = [];
  late List<String> userGroupsSlug = [];

  void readAll() async {
    var list = await objectbox.queryAllUsers();
    String _emailController = await TokenStorage.readSecureData("authed");
    for (int i = 0; i < list.length; i++) {
      if (list[i]["Email"] == _emailController) {
        setState(() {
          nome = list[i]["Nome"];
          image = list[i]["Endereco Foto"];
          username = list[i]["Username"];
          email = list[i]["Email"];
          nrObs = list[i]["Numero de Observações"];
          nrServicos = list[i]["Slugs Subscritas"].length;
        });
      }
    }
    print (image);
  }

  void refreshData() async {
    Random random = new Random();
    int randomNumber = random.nextInt(10000);
    setState(() {
      isSomeProgress =true;
    });

    var list = await objectbox.queryAllUsers();
    String _emailController = await TokenStorage.readSecureData("authed");
    for (int i = 0; i < list.length; i++) {
      if (list[i]["Email"] == _emailController) {
        id = list[i]["id"];
      }
    }

    var person = await objectbox.queryPerson(id);

    var _data = await APIService.getService();
    var _data1 = await APIService.getUser();

    setState(() {
      nome = _data1[0];
      imageUrl = _data1[1];
      email = _data1[2];
      username = _data1[3];
    });
    Uri uriUrl = Uri.parse(imageUrl);
    final response = await http.get(uriUrl);
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(path.join(documentDirectory.path, 'avatar$randomNumber$nome.png'));
    file.writeAsBytesSync(response.bodyBytes);
    setState(() {
      image = file.path;
    });

    String _nameslug;
    String _slug;
    setState(() {
      nrObs = 0 ;
      subsSlugs.clear();
      _slugs.clear();
    });

    for(int i=0;i<_data.length;i++) {
      if (_data[i]["subscribed"] == true) {
        _nameslug = _data[i]["name"];
        _slug = _data[i]["slug"];
        setState(() {
          subsSlugs.add(_nameslug);
          _slugs.add(_slug);
        });
      }
    }

    setState(() {
      nrServicos = subsSlugs.length;
    });

    for(int i=0; i<_slugs.length; i++){
      var _data2 = await APIService.getNrObs(_slugs[i]);
      setState(() {
        nrObs = nrObs + _data2;
      });
    }

    person?.nome = nome;
    person?.username = username;
    person?.filePath = image;
    person?.email = email;
    person?.subSlug = subsSlugs;
    person?.subSlugname = _slugs;
    person?.nrObs = nrObs;
    await objectbox.addUser(nome, username, image, email, nrObs, subsSlugs, _slugs, userGroupsName, userGroupsSlug);
    print("Sucessfully updated an object with $id");

    setState(() {
      isSomeProgress =true;
    });

    setState(() {
      isSomeProgress =true;
    });


    _updateInfo(context);


  }

  Future<bool> _onBackPressed() async {
    return false;
  }

  void initState() {
    readAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Stack(
          key: _scaffoldKey,
          children: [
            Column(
              children: [
                Expanded(
                  flex:5,
                  child:Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF346cb0),
                    ),
                    child: Column(
                        children: [
                          const SizedBox(height: 110.0,),
                          ClipOval(
                              child: Image.file(
                                File(image),
                                fit: BoxFit.fill,
                              )
                          ),
                          const SizedBox(height: 10.0,),
                          Text(nome,
                              style: const TextStyle(
                                color:Colors.white,
                                fontSize: 20.0,
                              )),
                        ]
                    ),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Expanded(
                  flex: 5,
                  child: Container(
                    color: Colors.grey[200],
                    child: Align(
                        alignment: const Alignment(0,-0.4),
                        child:Card(
                            child: Container(
                                width: 370.0,
                                height:290.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppLocalizations.of(context).info,
                                        style: const TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w800,
                                        ),),
                                      Divider(color: Colors.grey[300],),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.person_pin,
                                            color: Color(0xFF346cb0),
                                            size: 35,
                                          ),
                                          const SizedBox(width: 20.0,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(nome,
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                ),),
                                              Text(AppLocalizations.of(context).name,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey[400],
                                                ),)
                                            ],
                                          )

                                        ],
                                      ),
                                      const SizedBox(height: 20.0,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.person_outlined,
                                            color: Color(0xFF346cb0),
                                            size: 35,
                                          ),
                                          const SizedBox(width: 20.0,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(username,
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                ),),
                                              Text(AppLocalizations.of(context).username,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey[400],
                                                ),)
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 20.0,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.email,
                                            color: Color(0xFF346cb0),
                                            size: 35,
                                          ),
                                          const SizedBox(width: 20.0,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(email,
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                ),),
                                              Text(AppLocalizations.of(context).email,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey[400],
                                                ),)
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20.0,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.refresh,
                                            color: Color(0xFF346cb0),
                                            size: 35,
                                          ),
                                          const SizedBox(width: 20.0,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextButton(
                                                onPressed: () async {

                                                  try {
                                                    final result = await InternetAddress.lookup('google.com');
                                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                                      refreshData();
                                                    }
                                                  } on SocketException catch (_) {
                                                    _offlineError(context);
                                                  }
                                                },
                                                child: Text(AppLocalizations.of(context).reload_info,
                                                  style: const TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black,
                                                  ),),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            )
                        )
                    ),
                  ),
                ),
              ],
            ),
            Stack(
                children: [
                  Positioned(
                      top:MediaQuery.of(context).size.height*0.45,
                      left: 5.0,
                      right: 5.0,
                      child: Card(
                          child: Padding(
                            padding:const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: Column(
                                      children: [
                                        Text(AppLocalizations.of(context).subs_serv,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0
                                          ),),
                                        const SizedBox(height: 5.0,),
                                        Text("$nrServicos",
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                          ),)
                                      ]),
                                ),
                                Container(
                                    child:Column(
                                      children: [
                                        Text(AppLocalizations.of(context).subs_obs,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0
                                          ),),
                                        const SizedBox(height: 5.0,),
                                        Text("$nrObs",
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                          ),)
                                      ],
                                    )
                                ),
                              ],
                            ),
                          )
                      )
                  ),
                ]
            )
          ],

        ),
      ),
    );
  }

  _offlineError(BuildContext context) {
    Alert(
      context: _scaffoldKey!.currentContext!,
      type: AlertType.info,
      title: AppLocalizations.of(context).no_connection,
      desc: AppLocalizations.of(context).check_connection,
      buttons: [
        DialogButton(
          onPressed: () => Navigator.of(context,rootNavigator: true).pop(),
          width: 120,
          child: Text(
            AppLocalizations.of(context).ok,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  _updateInfo(BuildContext context) {
    Alert(
      context: _scaffoldKey!.currentContext!,
      type: AlertType.success,
      title: AppLocalizations.of(context).success,
      desc: AppLocalizations.of(context).reload_S,
      buttons: [
        DialogButton(
          onPressed: () async {
            await TokenStorage.deleteSecureData("logged");
            await TokenStorage.deleteSecureData("authed");
            Navigator.of(context,rootNavigator: true).pop();
            await Navigator.pushReplacement(context,
                new MaterialPageRoute(builder:(context)=> LoginScreen()
                ));
          },
          width: 120,
          child: Text(
            AppLocalizations.of(context).ok,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }
}