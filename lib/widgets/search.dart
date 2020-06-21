import 'package:flutter/material.dart';
import 'package:covid_19/widgets/cardBox.dart';


class Search extends SearchDelegate{
  List data;
  Map india;
  final List countryList;

  Search(this.countryList);

  @override
  List<Widget> buildActions(BuildContext context) {
   return [
     IconButton(icon: Icon(Icons.clear), onPressed: (){
       query='';

     })
   ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: (){
      Navigator.pop(context);
    },);
  }

  @override
  Widget buildResults(BuildContext context) {
return Column(
  children: <Widget>[
    CardBox(
                       country: data[0]['country'].toString(),
                       flag: Image(image: NetworkImage(data[0]["countryInfo"]["flag"])), 
                       confirmed: data[0]['cases'].toString(),
                       active: data[0]['active'].toString(),
                       recovered: data[0]['recovered'].toString(),
                       deaths: data[0]['deaths'].toString(),
                     ),
                     
  ],
);
  }

  @override
  Widget buildSuggestions(BuildContext context)
  {
    final suggestionList
         =
           query.isEmpty?
           countryList:
           countryList.where((element) => element['country'].toString().toLowerCase().startsWith(query)).toList();
    data = suggestionList;
   return ListView.builder(
       itemCount: suggestionList.length,
       itemBuilder: (context,index){
         if(suggestionList[index]['country'].toLowerCase() == "india") {
           india = suggestionList[index];
         }
     return CardBox(
              country: suggestionList[index]['country'].toString(),
              flag: Image(image: NetworkImage(suggestionList[index]["countryInfo"]["flag"])), 
              confirmed: suggestionList[index]['cases'].toString(),
              active: suggestionList[index]['active'].toString(),
              recovered: suggestionList[index]['recovered'].toString(),
              deaths: suggestionList[index]['deaths'].toString(),
            );
   });
  }

}
//  flag: Image.network(suggestionList[index]['countryInfo']['flag']),

                  