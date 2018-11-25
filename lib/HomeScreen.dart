import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:image_picker/image_picker.dart';
//import 'Talla.dart';
//import 'package:english_words/english_words.dart';


class HomeScreen extends StatefulWidget {
final String userName;
 HomeScreen({Key key, this.userName}) : super(key: key);

 @override
 _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
 @override
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: AppBar(title: Text("BBRecord")),
 //body: Center(child: Text("Home Screen"),),
 //------------------------------------------------
body:
Container(
          child: new ListView(
            children: <Widget>[
              
              new Card(
                child: new ListTile(
                  leading: Icon(Icons.date_range,size: 40.0,color: Colors.green),
                  title: Text('Medidas',style: TextStyle(color: Colors.green[300], fontSize: 15.0)),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Crecimiento()),
                    );
                  },
                ),
              ),

              new Card(
                child: new ListTile(
                  leading: Icon(Icons.fastfood,size: 40.0,color: Colors.orange),
                  title: Text('Solidos',style: TextStyle(color: Colors.orange, fontSize: 15.0)),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Talla()),
                    );
                  },
                ),
              ),
              new Card(
                child: new ListTile(
                  leading: Icon(Icons.colorize,size: 40.0,color: Colors.red),
                  title: Text('Vacunas',style: TextStyle(color: Colors.red, fontSize: 15.0)),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Vacuna()),
                    );
                  },
                ),
              ),
              new Card(
                child: new ListTile(
                  leading: Icon(Icons.brightness_3,size: 40.0,color: Colors.purple),
                  title: Text('Sueño',style: TextStyle(color: Colors.purple, fontSize: 15.0)),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Medida()),
                       );
                  },
                ),
              ),
              new Card(
                child: new ListTile(
                  leading: Icon(Icons.local_hospital,size: 40.0,color: Colors.redAccent),
                  title: Text('Medico',style: TextStyle(color: Colors.brown, fontSize: 15.0)),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Medico()),
                    );
                  },
                ),
              ),
               new Card(
                child: new ListTile(
                  leading: Icon(Icons.local_see,size: 40.0,color: Colors.blue),
                  title: Text('Fotos',style: TextStyle(color: Colors.blue, fontSize: 15.0)),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Medida()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
 //--------------------------------------------------
 
 drawer: Drawer(
 child: ListView(children: <Widget>[
 UserAccountsDrawerHeader(
 accountName: Text(widget.userName),
 accountEmail: Text(widget.userName),
 currentAccountPicture: CircleAvatar(
 // backgroundColor: Colors.black26,
 child: Text(widget.userName[0]),
 ),
 //decoration: BoxDecoration(color: Colors.orange),
 ),
 AboutListTile(
 child: Text("About"),
 applicationName: "My Login App",
 applicationVersion: "v1.0.0",
 applicationIcon: Icon(Icons.adb),
 icon: Icon(Icons.info)
 ),
 Divider(),
 ListTile(
 leading: new Icon(Icons.close),
 title: new Text("Cerrar"),
 onTap: () {
 setState(() {
 // pop closes the drawer
 Navigator.pop(context);
 });
 },
 )
 ],
 ),
 ),
 );
 }
}
//-------


//----------------------------Solidos-------------------------------------
class Talla extends StatefulWidget {
  @override
  _TallaState createState() => _TallaState();
}


class _TallaState extends State<Talla> {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Talla')),
     body: _buildBody(context),
   );
 }
  Widget _buildBody(BuildContext context) {
 return StreamBuilder<QuerySnapshot>(
   stream: Firestore.instance.collection('solidos').snapshots(),
   builder: (context, snapshot) {
     if (!snapshot.hasData) return LinearProgressIndicator();

     return _buildList(context, snapshot.data.documents);
   },
  );
  }

 Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
   return ListView(
     padding: const EdgeInsets.only(top: 8.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
 }

 Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
 final record = Record.fromSnapshot(data);

   return Padding(
     key: ValueKey(record.solido),
     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.lightBlue),
         borderRadius: BorderRadius.circular(500.0),
       ),
       
       child: ListTile(
         leading: Icon(Icons.local_dining,size: 30.0,color: Colors.indigo),
         title: Text(record.solido,style:TextStyle(color: Colors.black,fontSize: 18.0)),
         
         trailing: Text(record.cantidad.toString()),
         onTap: () => Firestore.instance.runTransaction((transaction) async {
     final freshSnapshot = await transaction.get(record.reference);
     final fresh = Record.fromSnapshot(freshSnapshot);
      print(fresh.cantidad.toString());
     if(fresh.cantidad<3) 
    
     await transaction
         .update(record.reference, {'cantidad': fresh.cantidad + 1});
   }),
       ),
     ),
   );
 }
}
class Record {
 final String solido;
 final int cantidad;
 final DocumentReference reference;

 Record.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['solido'] != null),
       assert(map['cantidad'] != null),
       solido = map['solido'],
       cantidad = map['cantidad'];

 Record.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$solido:$cantidad>";
}

///---------------------------------Fotos---------------------------------
/*class Foto extends StatefulWidget {
  @override
  _FotoState createState() => _FotoState();
}

class _FotoState extends State<Foto> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Image Picker Example'),
      ),
      body: new Center(
        child: _image == null
            ? new Text('No image selected.')
            : new Image.file(_image),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
}*/


///-------------------------------Vacunas----------------------------------
class Vacuna extends StatefulWidget {
  @override
  _VacunaState createState() => _VacunaState();
}

/*class _VacunaState extends State<Vacuna> {
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Vacunas'),
      ),
     body: _buildSuggestions(),
    );
  }
  var data = ["Hepatitis","Poleomelitis","Tetano" ];
  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: data.length,
      itemBuilder: (context, int index) {
        return Text(
          data[index],
          );
      },
    );
  }
} */
class _VacunaState extends State<Vacuna> {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Vacunas')),
     body: _buildBody(context),
   );
 }
  Widget _buildBody(BuildContext context) {
 return StreamBuilder<QuerySnapshot>(
   stream: Firestore.instance.collection('vacuna').snapshots(),
   builder: (context, snapshot) {
     if (!snapshot.hasData) return LinearProgressIndicator();

     return _buildList(context, snapshot.data.documents);
   },
  );
  }

 Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
   return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
 }

 Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
 final record = Record1.fromSnapshot(data);

   return Padding(
     key: ValueKey(record.vacuna),
     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
     child: Container(
       decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]),
         borderRadius: BorderRadius.circular(10.0),
       ),
       
       child: ListTile(
         //leading: Icon(Icons.local_dining,size: 30.0,color: Colors.indigo),
         title: Text(record.vacuna,style:TextStyle(color: Colors.black,fontSize: 18.0)),
         trailing: Icon(Icons.colorize,size: 30.0,color: Colors.grey[300]),
       //trailing: new Icon(   // Add the lines from here... 
      //alreadySaved ? Icons.favorite : Icons.favorite_border,
      //color: alreadySaved ? Colors.red : null,
    //),

         //trailing: Text(record.cantidad.toString()),
         onTap: () => Firestore.instance.runTransaction((transaction) async {
     final freshSnapshot = await transaction.get(record.reference);
     final fresh = Record.fromSnapshot(freshSnapshot);

     //await transaction
       // .update(record.reference, {'cantidad': fresh.cantidad + 1});
   }),
       ),
     ),
   );
 }
}
class Record1 {
 final String vacuna;
 //final int cantidad;
 final DocumentReference reference;

 Record1.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['vacuna'] != null),
       //assert(map['cantidad'] != null),
       vacuna = map['vacuna'];
       //cantidad = map['cantidad'];

 Record1.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$vacuna:d>";
}
//-----------Medico---------------
class Medico extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // IMplementando la fila del Titulo
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Salvador Vaca Hernandez',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Pediatra Neonatologo',
                  style: TextStyle(
                    color: Colors.green[500],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          Text('10'),
          Icon(
            Icons.phone,
            color: Colors.blue[500],
          ),
          Text('Cita')
        ],
      ),
    );
     // Crea la fila para el boton de Regresar
    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new RaisedButton(onPressed: (){
            Navigator.pop(context);
          },
              child: Text("Menu")),
        ],
      ),
    );

// Defines la sección del parrafo de texto
    Widget textSection = Container(
      padding: const EdgeInsets.all(32.0),
      
      child: Text(
        '''
Hospital General de MExico-CMN 
Siglo XXI-UNAM
DGP:5183622 SSA:11533 ESP:8129473 ESP:8630448


Calle Dr. JAvier Castañeda Coutiño 516 Col. San Pedro Irapuato,Gto CP. 36520
        ''',
        softWrap: true,
      ),
    );

    return MaterialApp(
      title: 'Pediatra',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pediatra'),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
            )
          ],
        ),
        // Implementa la sección de la imagen
        body: ListView(
           children: [
           /* Image.asset(
              'imagenes/LittleBoy.jpg',
              width: 600.0,
              height: 240.0,
              fit: BoxFit.cover,
            ),*/
            titleSection,
            textSection,
            buttonSection,
          ],
        ),
      ),
    );

// Implementando función para las columnas de los botones
    Column buildButtonColumn(IconData icon, String label) {
      Color color = Theme.of(context).primaryColor;

      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }
  }
}
//-------------Medida-------------

class Medida extends StatefulWidget {
  @override
  _MedidaState createState() => _MedidaState();
}


class _MedidaState extends State<Medida> {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Medida')),
   );
 }
}

//------------------------------------Crecimiento----------
class Crecimiento extends StatefulWidget {
  @override
  _CrecimientoState createState() => _CrecimientoState();
}

class _CrecimientoState extends State<Crecimiento> {
  TextEditingController edadController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController tallaController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //String _infoText = "El área es:";

  void _resetFields(){
    edadController.text = "";
    pesoController.text = "";
    tallaController.text="";
    //setState(() {
      //_infoText = "";
    //});
  }

  void _calculate(){
    setState(() {
      double edad = double.parse(edadController.text);
      double peso = double.parse(pesoController.text);
      double talla = double.parse(tallaController.text);
     // double area = base * altura;
     // _infoText = "El área es: (${area.toString()})";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crecimiento'),
        backgroundColor: Colors.lightBlue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFields,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.date_range, size: 80.0, color: Colors.lightBlue),
              TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 15.0),
                  controller: edadController ,
                 /* validator: (value) {
                    if(value.isEmpty){
                      return "Ingrese base del rectangulo";
                    }
                  },*/
                  decoration: InputDecoration(
                      labelText: "Edad",
                      labelStyle: TextStyle(color: Colors.grey))),
              TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 15.0),
                  controller: pesoController,
                  /*validator: (value) {
                    if(value.isEmpty){
                      return "Ingresa la altura del rectangulo";
                    }
                  },*/
                  decoration: InputDecoration(
                      labelText: "Peso",
                      labelStyle: TextStyle(color: Colors.grey))),
                TextFormField(
                 keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 15.0),
                  controller: tallaController,
                  /*validator: (value) {
                    if(value.isEmpty){
                      return "Ingresa la altura del rectangulo";
                    }
                  },*/
                  decoration: InputDecoration(
                      labelText: "Talla",
                      labelStyle: TextStyle(color: Colors.grey))),
              /*Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  height: 30.0,
                  child: RaisedButton(
                    child: Text("Guardar",
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    onPressed: () {
                      if(_formKey.currentState.validate()){
                      _calculate();
                      }
                    },
                    color: Colors.lightBlue,
                  ),
                ),
              ),*/
              /*Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.lightBlue, fontSize: 25.0),
              )*/
            ],
            
          ),
        ),
      ),
    );
  }
}


 