import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:h2n_app/utils/constants.dart';
import 'package:h2n_app/screens/models/forms.dart';
import 'package:h2n_app/utils/common.dart';
import 'package:h2n_app/request/request_handler.dart';

class AuthScreen extends StatefulWidget {
  final String name;
  const AuthScreen({Key? key, required this.name}) : super(key: key);

  @override
  AuthScreenState createState() => AuthScreenState();

}

class AuthScreenState extends State<AuthScreen> {
  final RequestHandler _client = RequestHandler();
  GlobalKey<FormState> formKey =  GlobalKey();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -20.0,
            child: Image.asset(
              "assets/images/background.png",
              scale: 0.5,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 15.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "${widget.name} to your account",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40.0,),
                Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  padding: const EdgeInsets.only(top: 100.0),
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 100.0,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                    color: Constants.scaffoldBackgroundColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getForm(widget.name, formKey, context, scaffoldKey),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getForm(entity, formKey, context, scaffoldKey) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      child: Form(
        key: formKey,
        child: Column(
            children: getFields(entity, formKey, context, scaffoldKey)
        ),
      ),
    );
  }

  // Widget _buildFacebookButton() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     height: 40.0,
  //     padding: EdgeInsets.symmetric(horizontal: 15.0),
  //     margin: EdgeInsets.only(top: 15.0),
  //     child: RaisedButton.icon(
  //       color: Colors.indigoAccent,
  //       onPressed: () async {
  //         final _prefs = await PreferenceManager.getInstance();
  //         dynamic token = await signUpWithFacebook();
  //         if (_prefs.getItem("token") == token) {
  //           Navigator.popAndPushNamed(context, screenHome);
  //         } else if (_prefs.getItem("token") != token) {
  //           scaffoldKey.currentState
  //               .showSnackBar(buildSnackBar("LOGIN FAILED"));
  //         }
  //       },
  //       icon: Icon(
  //         FontAwesomeIcons.facebookF,
  //         size: 30.0,
  //       ),
  //       label: Text("SIGN UP WITH FACEBOOK"),
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(18.0),
  //           side: BorderSide(color: Colors.black)),
  //     ),
  //   );
  // }

  // Widget _buildGoogleButton() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     height: 40.0,
  //     padding: EdgeInsets.symmetric(horizontal: 15.0),
  //     margin: EdgeInsets.only(top: 15.0),
  //     child: RaisedButton.icon(
  //       color: Colors.white,
  //       onPressed: () {signIn();},
  //       icon: Icon(
  //         FontAwesomeIcons.googlePlusG,
  //         size: 30.0,
  //       ),
  //       label: Text("SIGN UP WITH GOOGLE"),
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(18.0),
  //           side: BorderSide(color: Colors.black)),
  //     ),
  //   );
  // }

  submitForm(entity, formskey, context, scaffoldKey) async {
      String? path;
    if (formskey.currentState.validate()) {
      formskey.currentState.save();
      dynamic body = await createMap(entity);

      switch (entity) {
        case 'Login': path = '/login';
        break;
        case 'Register': path = '/register';
        break;
      }
      _client.post(path!, body: body).then((value) {

        switch(entity) {
          case 'Login':
            if(value == "200"){
              Navigator.of(context).pop();
              Navigator.popAndPushNamed(context, screenHome);
            } else {
              scaffoldKey.currentState.showSnackBar(buildSnackBar(value));
            }
            break;
          case 'Register':
            if(value == "200"){
              Navigator.of(context).pop();
              Navigator.popAndPushNamed(context, screenHome);
            } else {
              scaffoldKey.currentState.showSnackBar(buildSnackBar(value));
            }
            break;
        }
      });
    }
  }
}