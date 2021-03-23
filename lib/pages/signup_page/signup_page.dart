import 'package:flutter/material.dart';
import 'package:time_counter/helpers/local_data_manager.dart';
import 'package:time_counter/home_screen.dart';
import 'package:time_counter/models/local_user.dart';
import 'package:time_counter/values/avatars.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int selectedAvatar = 0;
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: Colors.purple,
        onPressed: () {
          _verifyAndGo(context);
        },
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Image.asset(
                "assets/icon.png",
                width: 50,
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              Text(
                "Oi! Algumas novas funcionalidades só estão disponívels após um pequeno cadastro!",
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
              ),
              Text(
                "Escolhe um avatar ae:",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      for (int i in [0, 1, 2])
                        // ignore: deprecated_member_use
                        RaisedButton(
                          color: (this.selectedAvatar == i)
                              ? Colors.purple
                              : Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          onPressed: () {
                            setState(() {
                              this.selectedAvatar = i;
                              print(this.selectedAvatar);
                            });
                          },
                          child: Image.asset(
                            getAvatarByInt(i),
                            width: 50,
                            height: 50,
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      for (int i in [3, 4, 5])
                        // ignore: deprecated_member_use
                        RaisedButton(
                          color: (this.selectedAvatar == i)
                              ? Colors.purple
                              : Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          onPressed: () {
                            setState(() {
                              this.selectedAvatar = i;
                              print(this.selectedAvatar);
                            });
                          },
                          child: Image.asset(
                            getAvatarByInt(i),
                            width: 50,
                            height: 50,
                          ),
                        ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Coloca um apelido também:",
                  labelStyle: TextStyle(fontSize: 12),
                ),
                controller: _nicknameController,
                maxLength: 20,
                validator: (value) {
                  if (value == null || value.length < 5) {
                    return "Coloca um apelido maiorzinho.";
                  }
                  return null;
                },
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "E um e-mail válido:",
                  labelStyle: TextStyle(fontSize: 12),
                ),
                controller: _emailController,
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.length < 5) {
                    return "Esse e-mail tá muito pequeno não?";
                  } else if (!value.contains("@")) {
                    return "Isso não me soa como um e-mail";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _verifyAndGo(BuildContext context) {
    if (_formKey.currentState.validate()) {
      LocalUser _lu = LocalUser(
          avatarId: this.selectedAvatar,
          name: _nicknameController.text,
          email: _emailController.text);
      LocalDataManager().saveLocalUser(_lu);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    localUser: _lu,
                  )));
    }
  }
}
