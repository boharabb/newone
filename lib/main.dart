import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:subject/CustomAppBar.dart';
import 'package:subject/newlist.dart';
import 'CustomShapeClipper.dart';
import 'newlist.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
//import 'package:cached_network_image/chched_network_image.dart';
Future<void> main() async{
  final FirebaseApp app = await FirebaseApp.configure(
     name: 'firebase-project',
     options: Platform.isIOS
  ?const FirebaseOptions(
     googleAppID: '1:637630795977:ios:d7fe58512b5d65f2',
     gcmSenderID: '637630795977',
     databaseURL: 'https://fir-project-3c37a.firebaseio.com/',)
  :const FirebaseOptions(
     googleAppID: '1:637630795977:android:d7fe58512b5d65f2',
     apiKey: 'AIzaSyCv0nAYWFWVwrJcs6fqITnzxv3HpCvLssg',
     databaseURL: 'https://fir-project-3c37a.firebaseio.com/',     ));

  runApp(MaterialApp(
  title: 'new app',
  debugShowCheckedModeBanner: false,
  home: Homescreen(),
));
}
Color firstColor = Colors.amber[200];
Color secondColor = Colors.red[100];
ThemeData appTheme = ThemeData(
  primaryColor: Colors.grey
  );
List<String> locations = List();

class Homescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
              child: Column(
          children: <Widget>[
            HomeScreenTopPart(),
            homeScreenBottomPart,
          ],
        ),
      ),
      
    );
  }
}

const TextStyle dropDownLablelStyle = TextStyle(color: Colors.red, fontWeight: FontWeight.w200, fontSize: 18.0);
const TextStyle dropDownMenuItemStyle = TextStyle(color: Colors.indigo,fontWeight: FontWeight.w200, fontSize: 18.0);
final _searchfieldController = TextEditingController(text: locations[1]);

class HomeScreenTopPart extends StatefulWidget {
  @override
  _HomeScreenTopPartState createState() => _HomeScreenTopPartState();
}
class _HomeScreenTopPartState extends State<HomeScreenTopPart> {
  var selectedLocationIndex = 0;
  var isloacationSelected = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(clipper: CustomShapeClipper(),
        child: Container(height: 270.0, decoration: BoxDecoration(gradient: LinearGradient(colors:[
          firstColor, secondColor
        ],)),
        child: Column(
          children: <Widget>[
            SizedBox(height: 15.0,),
            StreamBuilder(
              stream: 
              Firestore.instance.collection('locations').snapshots(),
              builder: (context, snapshot){
                if (snapshot.hasData)
                addLocations(context, snapshot.data.documents);
                
                return !snapshot.hasData
                ?Container()
                : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.location_on, color:Colors.blueGrey,),
                      SizedBox(width: 10.0),
                      PopupMenuButton(
                        onSelected:(index) {
                          setState(() {
                           selectedLocationIndex = index; 
                          });
                        },
                        child:Row(
                          children: <Widget>[
                            Text(locations[selectedLocationIndex], style: dropDownLablelStyle),
                            Icon(Icons.keyboard_arrow_down, color: Colors.blue)
                          ],
                        ),
                        itemBuilder: (BuildContext context) => _buildPopupMenuItem()
                        ), 

                      Spacer(),
                      Icon(Icons.home, color: Colors.blue,),
                      Spacer(),
                    Icon(Icons.settings, color: Colors.blue,)],),);
              }
            ),

            SizedBox(height:5.0,),
            Text('Where do you \n want   to study ?', 
            style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w200, fontSize: 18.0), textAlign: TextAlign.center,),
            SizedBox(height: 11.0,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 31.0),
              child: Material(
                elevation: 5.9,
                borderRadius: BorderRadius.all(Radius.circular(12.2),),
                child: TextField(
                  controller: _searchfieldController,
                  style: dropDownMenuItemStyle,

                  cursorColor: appTheme.primaryColor,
                  decoration: InputDecoration( 
                    contentPadding: EdgeInsets.symmetric(horizontal: 30.0, vertical:13),
                  suffixIcon: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(80.0),),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Inheritedsearch(
fromLocation:locations[selectedLocationIndex], toLocation: _searchfieldController.text, child: NewList(),
)));},
                      child: Icon(Icons.search),),),

                  border: InputBorder.none),),),),

            SizedBox(height: 16.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(child: ChoiceChip(Icons.location_off, "loaction", isloacationSelected),onTap: (){
                  setState(() {
                    isloacationSelected = true;
                  });
                },),
                SizedBox(width:60.0,),
                InkWell(child: ChoiceChip(Icons.help, "Help",  !isloacationSelected), onTap: (){
                  setState(() {
                   isloacationSelected = false; 
                  });
                },), ],
            ),
            ],
        ),
        ),
        ),
      ],
      );
  }
}
List<PopupMenuItem<int>> _buildPopupMenuItem(){
  List<PopupMenuItem<int>> popupMenuItems = List();
  for (int i=0; 1<locations.length; i++){
    popupMenuItems.add(PopupMenuItem(
      child:Text(locations[1],
      style:dropDownMenuItemStyle,
    ),
    value:1, 
    ));
  }
  return popupMenuItems;
}
addLocations(BuildContext context, List<DocumentSnapshot> snapshots){
  for (int i=0; i<snapshots.length; i++){
    final Location location = Location.fromSnapshot(snapshots[1]);
    locations.add(location.name);
  }
}

class ChoiceChip extends StatefulWidget { 
  final IconData icon;
  final String text;
  final bool isSelected;

  ChoiceChip(this.icon, this.text, this.isSelected);

  @override
  _ChoiceChipState createState() => _ChoiceChipState();
}

class _ChoiceChipState extends State<ChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0,),
      decoration: widget.isSelected ? BoxDecoration(
        color: Colors.white30, 
        borderRadius: BorderRadius.all(Radius.circular(24.0),),):null,
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
        Icon(widget.icon, size: 20.0, color: Colors.indigo,),
        SizedBox(width: 12.0,),
        Text(widget.text, style:TextStyle(
          color:Colors.brown, fontSize:14.0))
          ],
          ),
    );
  }
}
const viewallStyle = TextStyle(color: Colors.red, fontSize: 16.0, );
var homeScreenBottomPart = Column(
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 3.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text("Institutes", style:dropDownMenuItemStyle,),
          Spacer(),
          Text('Viewall(5)', style:viewallStyle,)
        ],
      ),
    ),
    Container(
      height: 250.0,
      child: StreamBuilder(
        stream: Firestore.instance.collection('Institutes').orderBy('date').snapshots(),
        builder: (context, snapshot) {
          print('${snapshot.hasData}');
          return !snapshot.hasData 
          ? Center(child:CircularProgressIndicator())
          :_buldInstitutesList(context ,snapshot.data.documents);
        }),
    )
  ],
);

Widget _buldInstitutesList(BuildContext context,List<DocumentSnapshot>snapshots){
  return ListView.builder(
    itemCount: snapshots.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index){
      return CityCard(city:City.fromSnapshot(snapshots[index]));
    });
}
class Location{
  final String name;
  Location.fromMap(Map<String, dynamic> map)
  :assert(map['name']!=null),
    name = map['name'];
  Location.fromSnapshot(DocumentSnapshot  snapshot): this.fromMap(snapshot.data);}

class City{
  final String adress, est, date, imagepath, discount;
 // final int oldPrice, newPrice;

  City.fromMap(Map<String, dynamic> map)
  : assert(map['adress']!=null),
    assert(map['est']!=null), 
    assert(map['date']!=null), 
    assert(map['imagepath']!=null), 
    assert(map['discount']!=null),
    adress = map['adress'],   
    est = map['est'],
    date = map['date'],
    imagepath = map['imagepath'],
   discount = map['discount'];
  // oldPrice = map['oldPrice'];
  // newPrice = map['newPrice'];

   City.fromSnapshot(DocumentSnapshot  snapshot): this.fromMap(snapshot.data);}

final formatCurrency = NumberFormat.simpleCurrency();

class CityCard extends StatelessWidget {
  final City city;
  CityCard({this.city});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          
          child: Stack(
            children: <Widget>[
              Container(
                height: 200.0,
                width: 160.0,
                child:Image.network(
                  '${city.imagepath}', fit: BoxFit.cover,) ,
                  //child:CachedNetworkImage(
                   // imageurl:'${city.imagepath}', fit: BoxFit.cover,
                   //fadeInDuration:Duration(milliseconds:600,)
                   //fadeInCurve:Curve.easeIn,
                   //placeholder:Center(child:CurcularProgressIndicator())
            
              ),
              Positioned(
                left: 0.0,
                bottom: 0.0,
                width: 160.0,
                height: 70.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black, Colors.black.withOpacity(0.01),
                      ],
                    )
                  ),
                ),
              ),

              Positioned(
                left: 5.0,
                bottom: 10.0,
                right: 18.0,
                child:Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${city.adress}', style: TextStyle(fontSize: 20.0, color: Colors.black),),
                        Text('${city.date}', style: TextStyle(fontSize: 15.0, color: Colors.yellow),),
                      ],
                    ),
                   SizedBox(width: 12.0,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 11.6, vertical: 10.5),
                        decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(16.0),),
                      ),
                      child: Text('${city.discount}%',style: TextStyle(
                        fontSize: 10.0, color: Colors.black),))
                  ],
                ),
              )
            ],
          ),
          
          ),
          Row(mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 5.0,),
           // Text('${city.oldPrice}',style: TextStyle(fontSize: 16.0, color: Colors.black)),
            SizedBox(width: 5.0,),
          //  Text('${city.newPrice}',style: TextStyle(fontSize: 14.0, color: Colors.red)),
          ],
          ),
          ],
      ),
      );
  }
}