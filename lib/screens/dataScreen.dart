import 'package:flutter/material.dart';
import 'package:covid_19/widgets/cardBox.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:covid_19/resources/dataSource.dart';
import 'package:covid_19/widgets/search.dart';
import 'package:covid_19/resources/constant.dart';

Map statesData;
List countryData;
  var colorA = Colors.white;
  var colorB;
  int r=0;
int index = 0;
int indexD = 0;
String state;
bool country = true;

class DropDown extends StatefulWidget {
  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  
  bool asTabs = false;
  String selectedValue = "States";
  String dselectedValue = "Districts";
  List<String> statesItems = [];
  Map districtsItems;
  final List<DropdownMenuItem> items = [];
  List<DropdownMenuItem> itemsD = [];
  
  printStateName() {
      statesItems = getStatesList();
      if(statesItems.isNotEmpty) {
        for(int i=0;i<statesItems.length; i++) {
            items.add(DropdownMenuItem(
              child: Text(statesItems[i]),
              value: statesItems[i],
            ));
        }
      }
      else {
        items.add(DropdownMenuItem(
          child: Text("Not Avilable"),
          value: "Check Internet",
        ));
      }
  }


  Future fetchFromStateData() async {
    await fetchStateData();
    setState(() async { statesData = getStatedata(); });
  }

  Future fetchFromOtherCountryData() async {
      await fetchOtherCountryData();
      setState(() async { countryData = getOtherCountrydata(); });
  }  

  Future fetchSData() async {
      statesData = getStatedata();
      if(statesData == null)
        await fetchFromStateData();
      return statesData;
  }



  Future fetchCountriesData() async {
      countryData = getOtherCountrydata();
      if(countryData == null)
          await fetchFromOtherCountryData();
  }


  @override
  void initState()  {
    printStateName();
     fetchSData();
     fetchCountriesData();
    super.initState();
  }

  Widget buildInidaBox() {
    Map<String, Widget> widgets;
    widgets = {
      "Single dialog": SearchableDropdown.single(
        underline: Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      style: TextStyle(fontSize: 25 ,fontWeight: FontWeight.bold, color: Colors.green ),
        items: items,
        value: selectedValue,
        hint: "States",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValue = value;
            index = statesItems.indexOf(value);
            print(value);
            print(index);
            if(index < 0)
              index = 0;
          });
        },
        isExpanded: true,
      ),
    };
    return Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                              child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                        children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),  
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 3,color: Colors.blueGrey[100],),
                                borderRadius: BorderRadius.all(Radius.circular(20))
                              ),     
                              margin: EdgeInsets.only(left: 12,right: 12), 
                              child: Column(
                                  children: widgets
                                      .map((k, v) {
                                        return (MapEntry(
                                            k,v));
                                      })
                                      .values
                                      .toList(),
                                ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            (statesData.isEmpty) 
                            ? Container(
                                child: Column(
                                  children: <Widget>[
                                    Text("Unable to connent! Check Connection \nThen shift between apps",style: TextStyle(fontFamily: "Poppins", color: kTextLightColor),),
                                    RaisedButton(
                                      child: Text("Try Again"),
                                      onPressed: () {
                                        setState(() async {
                                          try {
                                          statesData = await fetchStateData();
                                          countryData = await fetchOtherCountryData();
                                          }
                                          catch(e) {print("refresh 2");}
                                        });
                                      }
                                    ),    
                              ],),) 
                            :
                            Container(
                              child: Column(
                                children: <Widget>[
                                  StateCardBox(
                                    state: statesData["statewise"][index]['state'].toString(),
                                    confirmed: statesData["statewise"][index]['confirmed'].toString(),
                                    active: statesData["statewise"][index]['active'].toString(),
                                    recovered: statesData["statewise"][index]['recovered'].toString(),
                                    deaths: statesData["statewise"][index]['deaths'].toString(),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                    ),
              ),
              Container(
                height: 120,
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(border: Border.all(width: 1, color: Color(0xff3382CC)) ),
                child: Image(image: AssetImage('assets/images/map.png')),
              ),
            ],
          ),
    );
  }

  

  Widget buildWorldBox() {
    return Expanded(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.blueAccent,
                width: double.infinity,
                child: IconButton(
                  
              icon: Icon(Icons.search, color: Colors.white,),
              onPressed: ()  {
                showSearch(context: context, delegate: Search(countryData));

              },
              ),
              ),
              SizedBox(height: 5),
              Expanded(
                              child: (countryData.isEmpty) 
                            ? Container(
                                child: Column(
                                  children: <Widget>[
                                    Text("Unable to connent! Check Connection \nThen shift between apps",style: TextStyle(fontFamily: "Poppins", color: kBodyTextColor),),
                                    RaisedButton(
                                      child: Text("Try Again"),
                                      onPressed: () {
                                        setState(() async {
                                          try {
                                          countryData = await fetchOtherCountryData();
                                          }
                                          catch(e) {print("country refresh");}
                                        });
                                      }
                                    ),    
                              ],),) 
                            :
                              Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
         itemCount: countryData.length,
         itemBuilder: (context,index1){
         return CardBox(
                country: countryData[index1]['country'].toString(),
                flag: Image(image: NetworkImage(countryData[index1]["countryInfo"]["flag"])) ,
                confirmed: countryData[index1]['cases'].toString(),
                active: countryData[index1]['active'].toString(),
                recovered: countryData[index1]['recovered'].toString(),
                deaths: countryData[index1]['deaths'].toString(),
        );
   },),

              ),),
              SizedBox(height: 5),
            ],
          ),

    );
       
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text("Data"),
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
          
            ),
            body: (countryData == null || statesData == null) ? Center(child: CircularProgressIndicator()) :  Column(
              children: <Widget>[
                Container(
                  color: Colors.blueAccent,
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                          color: colorA,
                          child: Text("INDIA", style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),),
                          onPressed: () {
                            setState(() {
                            if(country == false) {
                              country = true;
                              colorA = Colors.white;
                              colorB = null;
                            }                               
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                          child: RaisedButton(
                          child: Text("GLOBAL", style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold)),
                          color: colorB,
                          onPressed: () {
                            setState(() {
                              if(country == true) {
                                country = false;
                                colorA = null;
                                colorB = Colors.white;
                              }  
                            });                             
                          },
                        ),
                      ),
                    ],
                  ),
                  ),


                country ? buildInidaBox() : 
              buildWorldBox(),
              ],                         
            ),     
    );
  }
}



