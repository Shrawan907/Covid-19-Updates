import 'package:covid_19/resources/constant.dart';
import 'package:flutter/material.dart';

class CardBox extends StatelessWidget {
  final String country;
  final Image flag;
  final String confirmed;
  final String active;
  final String recovered;
  final String deaths;
  const CardBox({
    Key key,
    this.country,
    this.flag,
    this.confirmed,
    this.active,
    this.recovered,
    this.deaths
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.blue[50],  // lightGreenAccent
       child: Container(
         height: 120,
         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
         child: Row(
           children: <Widget>[
             Container(
               width: 200,
               margin: EdgeInsets.symmetric(horizontal: 10),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Text(
                     '$country',
                     style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins",fontSize: 18),
                   ),
                 Image(
                   image: flag.image,
                   height: 50,width: 60,
                 ),   
                 ],
               ),
             ),
             Expanded(
                 child: Container(
                   child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                     children: <Widget>[
                       Text(
                         'CONFIRMED: $confirmed',
                         style: TextStyle(
                             fontWeight: FontWeight.bold,
                             color: Colors.red),
                       ),
                       Text(
                         'ACTIVE: $active',
                         style: TextStyle(
                             fontWeight: FontWeight.bold,
                             color: Colors.blue),
                       ),
                       Text(
                          'RECOVERED: $recovered',
                         style: TextStyle(
                             fontWeight: FontWeight.bold,
                             color: Colors.green),
                       ),
                       Text(
                         'DEATHS: $deaths',
                         style: TextStyle(
                             fontWeight: FontWeight.bold,
                             color:  Theme.of(context).brightness==Brightness.dark?Colors.grey[100]:Colors.grey[900]),
                       )
                     ],
                   ),
                 ),)
           ],
         ),
       ),
     );
  }
}

class StateCardBox extends StatelessWidget {
  final String state;
  final String confirmed;
  final String active;
  final String recovered;
  final String deaths;
  const StateCardBox({
    Key key,
    this.state,
    this.confirmed,
    this.active,
    this.recovered,
    this.deaths
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.blue[50], // lightGreenAccent
       child: Container(
         height: 120,
         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
         child: Row(
           children: <Widget>[
             Container(
               width: 200,
               margin: EdgeInsets.symmetric(horizontal: 10),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Text(
                     '$state',
                     style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins",fontSize: 18),
                   ),
                 ],
               ),
             ),
             Expanded(
                 child: Container(
                   child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                     children: <Widget>[
                       Text(
                         'CONFIRMED: $confirmed',
                         style: TextStyle(
                             fontWeight: FontWeight.bold,
                             color: Colors.red),
                       ),
                       Text(
                         'ACTIVE: $active',
                         style: TextStyle(
                             fontWeight: FontWeight.bold,
                             color: Colors.blue),
                       ),
                       Text(
                          'RECOVERED: $recovered',
                         style: TextStyle(
                             fontWeight: FontWeight.bold,
                             color: Colors.green),
                       ),
                       Text(
                         'DEATHS: $deaths',
                         style: TextStyle(
                             fontWeight: FontWeight.bold,
                             color:  Theme.of(context).brightness==Brightness.dark?Colors.grey[100]:Colors.grey[900]),
                       )
                     ],
                   ),
                 ),)
           ],
         ),
       ),
     );
  }
}


