import 'package:flutter/material.dart';

class Infodrive extends StatefulWidget {
const Infodrive({super.key});

@override
State<Infodrive> createState() => _InfodriveState();
}

class _InfodriveState extends State<Infodrive> {
@override
Widget build(BuildContext context) {
return Scaffold(
body: SafeArea(
child: Container(
child: Padding(
padding: const EdgeInsets.all(18.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(

mainAxisAlignment: MainAxisAlignment.end,
children: [
CircleAvatar(
radius: 20,
backgroundColor:Color(0xFFBE1B7D) ,
child: IconButton(onPressed: (){

  Navigator.pop(context);
}, icon:   Icon(Icons.close,color: Colors.white,)))
],),
Text("Votre chauffeur:",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),),
Padding(
padding: const EdgeInsets.all(18.0),
child: Container(
width: 350,
height: 150,
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),
boxShadow: [
BoxShadow(color: Colors.black,offset: Offset(0.2, 0.2)),

])
,
child: Column(
children: [
Row(children: [

SizedBox(width: 10,),
CircleAvatar(radius: 20,),
SizedBox(width: 10,),
Text("Houda",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
],),
SizedBox(height: 15,),
Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,

children: [
SizedBox(width: 20,),

Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [

Text("nom"),
Text("Houda",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
],),
SizedBox(width: 20,),
Column(
children: [
Text("Prenom"),
Text("Belarbi",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
],),
SizedBox(width: 20,),

Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [

Text("Age"),
Text("33",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
],),
],),
],
),),
),
Text("Destination sélectionnée",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20)),
SizedBox(height: 20,),
Container(
  width: 400,
  height: 50,
  
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    
    color: Colors.white,boxShadow: [
  BoxShadow(color: Colors.black,offset: Offset(0.1,0.1),)
]),

   padding: const EdgeInsets.all(2.0),
  child: Row(
    children: [
      Padding(padding: EdgeInsets.all(10)),
    Text("Bab daya"),
  ],),),
SizedBox(height: 20,),
Container(
  width: 400,
  height: 50,
  
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    
    color: Colors.white,boxShadow: [
  BoxShadow(color: Colors.black,offset: Offset(0.1,0.1),),
  
]),
child: Padding(
  padding: const EdgeInsets.all(2.0),
  child: Row(
    children: [
      Padding(padding: EdgeInsets.all(10)),
    Text("La macta"),
  ],),
),
),
SizedBox(height: 20,),
Text("Détails du voyage",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
SizedBox(height: 10,),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
  Container(height: 40,width: 100,decoration: BoxDecoration(color: Color(0xFFBE1B7D),borderRadius: BorderRadius.circular(20)),child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(children: [
      Icon(Icons.social_distance,color: Colors.white,),
      SizedBox(width: 10,),
      Text("5.8 KM", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
    ],),
  ),),
    Container(height: 40,width: 100,decoration: BoxDecoration(color: Color(0xFFBE1B7D),borderRadius: BorderRadius.circular(20)),child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(children: [
      Icon(Icons.timelapse_outlined,color: Colors.white,),
      SizedBox(width: 10,),
      Text("14 Min", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
    ],),
  ),),
    Container(height: 40,width: 100,decoration: BoxDecoration(color: Color(0xFFBE1B7D),borderRadius: BorderRadius.circular(20)),child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(children: [
      Icon(Icons.attach_money,color: Colors.white,),
      SizedBox(width: 10,),
      Text("160 DA", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
    ],),
  ),)
],),
SizedBox(height: 40,),
Center(
  child: Container(
  child: Row(
    children: [
      SizedBox(width: 10,),
      Icon(Icons.phone,color: Colors.white,),
      SizedBox(width: 10,),
      Text("Appel",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
    ],
  ),
  width: 250,height: 60,decoration: BoxDecoration(color: Color(0xFF200E32),borderRadius: BorderRadius.circular(20)),))
],
),

),),
),
);
}
}