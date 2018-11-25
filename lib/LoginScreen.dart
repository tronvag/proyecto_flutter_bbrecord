import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomeScreen.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _userName;
  String _password;

  bool _formValidate() {
    if (_formKey.currentState.validate()) {
      //Ejecuta la validación del formulario
      _formKey.currentState
          .save(); //Ejecuta el evento onSaved de cada TextFormField
      return true;
    }
    return false;
  }

  void _registerAccount() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
  }

  void _loginAuth() async {
    if (_formValidate()) {
      //Firebase authentication
      try {
        print("UserName:" + _userName);
        print("Password:" + _password);
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _userName, password: _password);
        print("Signed In Ok: ${user.uid}");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => HomeScreen(
                      userName: _userName,
                    )));
      } catch (e) {
        print("AuthError: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("INICIAR SESIÓN"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: //<Widget>
        [
          SizedBox(
            height: 10.0,
          ),
          Image.asset('imagenes/LittleBoy.jpg',width: 600.0,height: 130.0,fit: BoxFit.cover
          ),
          //new Image.network('https://www.google.com.mx/search?hl=es-419&biw=1242&bih=553&tbm=isch&sa=1&ei=zqr1W6jYDcrGsQWnk5S4Cg&q=BABY&oq=BABY&gs_l=img.3..0i67j0l5j0i67j0l3.3827.4251..4972...0.0..0.81.310.4......1....1..gws-wiz-img.KykAZSczL4o#imgrc=Cq4Orcz5melQEM:',
          //fit:BoxFit.cover,
          //),
          // Agregamos un contenedor para el texto
          //FlutterLogo(
            //size: 100.0,
          //),
          Center(
            child: Text("BBRecord", style: TextStyle(fontSize: 20.0)),
          ),
          SizedBox(
          height: 20.0,
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    //filled: true
                    labelText: 'Correo Electronico',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) => _validateEmail(input),
                  onSaved: (input) => _userName = input,
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    //filled: true,
                    labelText: 'Contraseña',
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  validator: (input) => _validatePassword(input),
                  onSaved: (input) => _password = input,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          RaisedButton(
              color: Theme.of(context).accentColor,
              elevation: 2.0,
              splashColor: Colors.blue,
              child: Text('INICIAR SESIÓN'),
              onPressed: () => _loginAuth()),
          FlatButton(
              child: Text('No tienes cuenta? Crear Cuenta'),
               onPressed: () => _registerAccount()),
        ],
      ),
    );
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'El Correo no es válido';
    else
      return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty)
      return "Escriba una contraseña";
    else if (value.length < 6)
      return "La contraseña debe tener por lo menos 6 caracteres";
    else
      return null;
  }
}
