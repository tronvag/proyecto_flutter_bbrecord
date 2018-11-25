import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'HomeScreen.dar.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();  //Id. único del formulario
  String _userName;  //variable que almacena el correo del usuario
  String _password;  //variable que almacena la contraseña

  bool _formValidate(){
    if (_formKey.currentState.validate())  // Verifica su hace la validación
        {
      _formKey.currentState.save();
      return true;
    }
    return false;
  }

  // función del boton para verificar validaciones
  void _registerAccount() async{
    if (_formValidate()){
      try {
        print("UserName:"+ _userName);
        print("Password:"+ _password);
        FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _userName,password: _password);
        print ("Create user Ok: ${user.uid}");
        Navigator.pop(context);
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
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Image.asset('imagenes/baby_pies.jpg',width: 400.0,height: 130.0,fit: BoxFit.cover
          ),
          //FlutterLogo(
            //size: 100.0,
          //),
          Center(
            child: Text("Registro de la cuenta", style: TextStyle(fontSize: 20.0),),
          ),
          SizedBox(height: 30.0,),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    //filled: true,
                    labelText: 'Correo Electronico',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (input)=> _validateEmail(input) ,
                  onSaved: (input)=> _userName = input,
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    //filled: true,
                    labelText: 'Contraseña',
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (input)=> _validatePassword(input),
                  onSaved: (input)=> _password = input,
                ),
              ],
            ),

          ),
          SizedBox(height: 15.0,),
          RaisedButton(
              color: Theme.of(context).accentColor,
              elevation: 5.0,
              splashColor: Colors.blue[200],
              child: Text('Crear Usuario'),
              onPressed: () => _registerAccount()
          ),
          FlatButton(
              child: Text('Ya tienes cuenta? Iniciar sesión'),
              onPressed: () => Navigator.pop(context)
          ),
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
