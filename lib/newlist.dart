import 'package:flutter/material.dart';
import 'package:subject/CustomShapeClipper.dart';
import 'package:subject/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Color abcBackgroundColor = Colors.grey;
final Color abdBackgroundColor = Colors.white10;
final Color abxBackgroundColor = Colors.purple;

class Inheritedsearch extends InheritedWidget{
   final String toLocation, fromLocation;
  Inheritedsearch({this.fromLocation, this.toLocation, Widget child}) : super(child:child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
  static Inheritedsearch of(BuildContext context) =>
  context.inheritFromWidgetOfExactType(Inheritedsearch);}

class NewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Resluts"),
        centerTitle: true,
        leading: InkWell(
          child: Icon(Icons.arrow_back),
          onTap: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
              child: Column(
          children: <Widget>[
          SearchtopPart(),
          SizedBox(height: 29.0,),
          InstituteListPart(),
          ],
        ),
      ),
    );
  }
}
class InstituteListPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left:12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text("Most Popular Instute at Gongabu", style:dropDownLablelStyle),
          ),
        SizedBox(height: 17.0,),
        StreamBuilder(
          stream:Firestore.instance.collection('ginstitute').snapshots(),
          builder: (context, snapshot){
          return !snapshot.hasData 
          ? Center(child:CircularProgressIndicator())
          :_buildGinstituteList(context, snapshot.data.documents);
          },
        )
      /* ListView(
         shrinkWrap: true,
         physics: ClampingScrollPhysics(),
         scrollDirection: Axis.vertical,
         children: <Widget>[
           Institutelist(),
        Institutelist(),
        ],
       ),*/
        
        ],
      ),
      );
  }
}
Widget _buildGinstituteList(BuildContext contex, List<DocumentSnapshot> snapshots){
  return ListView.builder(
    shrinkWrap: true,
    itemCount: snapshots.length,
         physics: ClampingScrollPhysics(),
         scrollDirection: Axis.vertical,
         itemBuilder: (context, index){
           return Institutelist(institutelistDetails:InstitutelistDetails.fromSnapshot(snapshots[index]),);
         });
}

class InstitutelistDetails{
  final String name, est, date, rating, discount;

  InstitutelistDetails.fromMap(Map<String, dynamic> map)
  : assert(map['name']!=null),
    assert(map['est']!=null), 
    assert(map['date']!=null), 
    assert(map['rating']!=null), 
    assert(map['discount']!=null),
    name = map['name'],   
    est = map['est'],
    date = map['date'],
    rating = map['rating'],
   discount = map['discount'];
   InstitutelistDetails.fromSnapshot(DocumentSnapshot  snapshot)
: this.fromMap(snapshot.data);}
 
class Institutelist extends StatelessWidget {
  final InstitutelistDetails institutelistDetails;
  Institutelist ({this.institutelistDetails});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(color: abcBackgroundColor)
          ),
          height: 95,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('${institutelistDetails.name}', style: TextStyle(fontSize: 18.0, color: Colors.black),),
                    SizedBox(width: 17.0),
                     Text('${institutelistDetails.est}', style: TextStyle(fontSize: 15.0, color: Colors.blue),),
                  ],
                ),
                SizedBox(height: 8.0,),
                Wrap(
                  
                  runSpacing: -8.0,
                  spacing: 9.9,
                  children: <Widget>[
                    InstituteDetailChip(Icons.calendar_today, '${institutelistDetails.date}'),
                    InstituteDetailChip(Icons.stars, '${institutelistDetails.rating}'),
                    ],
                )
              ],
            ),
          ),
        ),
      Positioned(
        top:15.0,
        right: 0.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: Text('${institutelistDetails.discount}%',style: TextStyle(fontSize: 17.0, color: Colors.black), ),
          decoration:  BoxDecoration(color:abxBackgroundColor,borderRadius: BorderRadius.all(Radius.circular(8.0)))
        ),
      )
        ],
      ),
    );
  }
}

class InstituteDetailChip extends StatelessWidget {
  final IconData iconData;
  final String label;
  InstituteDetailChip(this.iconData, this.label);
  @override
  Widget build(BuildContext context) {
    return RawChip(
        
      label: Text(label),
      labelStyle: TextStyle(color: Colors.purple, fontSize: 12.0),
      backgroundColor: abdBackgroundColor,
      avatar: Icon(iconData),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0))
      ),
    );
  }
}
class SearchtopPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient:LinearGradient (
                colors:[ secondColor, firstColor]),),
            height:190,
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(height: 19.9,),
            Card(
            elevation: 10.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
            margin: EdgeInsets.symmetric(horizontal: 15.0,),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${Inheritedsearch.of(context).fromLocation}', style: TextStyle(fontSize: 18.0, color:Colors.purple),),
                        Divider(color: Colors.red, height: 18.0,),
                        Text('${Inheritedsearch.of(context).toLocation}',style: TextStyle(fontSize: 18.0, color:Colors.purple, fontStyle: FontStyle.italic),),
                        
                      ],
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex:1,
                    child: Icon(Icons.import_export,size: 30.0,))
                ],
              ),
            ),),
          ],
        )
      ],
      
    );
  }
}