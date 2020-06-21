import 'package:flutter/material.dart';
import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:covid_19/resources/constant.dart';
import 'package:covid_19/resources/dataSource.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

var now = new DateTime.now();
var newFormat = DateFormat.yMMMMd('en_US');
String date = newFormat.format(now);


bool search = true;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

Map countryData = { 
    'cases':'...',
    'deaths':'...',
    'active':'...',
    'todayCases':'...',
    'todayDeaths':'...',
    'todayRecovered':'...',
    'recovered':'...' 
  };
Map total = { 
    'cases':'...',
    'deaths':'...',
    'active':'...',
    'todayCases':'...',
    'todayDeaths':'...',
    'recovered':'...' 
  };

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  double offset = 0;

  Future<void> _launched;
  String _launchUrl = 'https://www.pmcares.gov.in/en/';

  Future<void> _launchInBrowser(String url) async {
    if(await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false, headers: <String, String> {'header_key':'header_value' });
    }
    else {
      throw 'Could not launch $url';
    }
  }

  Future fetchRealTimeData() async {
      try {
      await fetchOtherCountryData();  // we getting the country data from total countries data only so it is correct
      }
      catch(e) {print("1");}

      Map d = getCountrydata();

      if(total == null) {
      try {
      await fetchTotalData();
      }
      catch(e) {print("2");}

      setState(() {
        countryData = d;
        total = getTotaldata();
      });

    }
  }


  Future fetchData() async {
    Map d = getCountrydata();
    total = getTotaldata();
    if(d == null || total['cases'] == "...")
      await fetchRealTimeData();
    try{
    fetchStateData();
    }
    catch(e) {print("21");}
    setState(() {
      search = false;
      countryData =  d;
    });
  }

  @override
  void initState() {
    super.initState();
    print(search);
    if(search) {
      fetchData();
    }
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          children: <Widget>[
            RefreshIndicator(
              onRefresh: () async {
                setState(() async {
                try{
                await fetchOtherCountryData();
                countryData = getCountrydata();
                total = await fetchTotalData();
                await fetchStateData();
                await fetchOtherCountryData();
                }
                catch(e) {print("refresh1");}
                });
                },
                          child: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: <Widget>[
                  MyHeader(
                    image: "assets/icons/Drcorona.svg",
                    textTop: "All you need",
                    textBottom: "is stay at home.",
                    offset: offset,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    height: 60,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'INDIA',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.blue,
                            fontFamily: "Poppins"
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  (countryData['cases'] == "...") 
                            ? Container(
                                width: double.infinity,
                                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red),),
                                child: Center(child: Text('Unable to connect! Refresh the Screen \nthen shift between tabs',style: TextStyle(color: Colors.blue),),),) 
                            : SizedBox(height: 0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "Case Updates",
                              style: kTitleTextstyle,
                            ),
                            Spacer(),
                            Text(
                              "$date",
                              style: TextStyle(
                                      color: kTextLightColor,
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 30,
                                color: kShadowColor,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Counter(
                                color: kInfectedColor,
                                number: countryData['cases'].toString(),
                                title: "Infected",
                              ),
                              Counter(
                                color: kDeathColor,
                                number: countryData['deaths'].toString(),
                                title: "Deaths",
                              ),
                              Counter(
                                color: kRecovercolor,
                                number: countryData['recovered'].toString(),
                                title: "Recovered",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 30,
                                color: kShadowColor,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Counter(
                                color: kInfectedColor,
                                number: countryData['todayCases'].toString(),
                                title: "Today Cases",
                              ),
                              Counter(
                                color: kDeathColor,
                                number: countryData['todayDeaths'].toString(),
                                title: "Today Deaths",
                              ),
                              Counter(
                                color: Colors.red[200],
                                number: countryData['active'].toString(),
                                title: "Active",
                              ),
                        
                      ],
                    ),
                  ),
                  Card(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10, right: 10),
                                        height: 160,
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 15),
                                      Text("PM CARES", style: TextStyle(fontSize: 20  ,color: Colors.blue[700]),),
                                      Text("Prime Minister's Citizen Assistance and Relief Fund",style: TextStyle(color: Colors.green),),
                                      SizedBox(height: 10),
                                      RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0)
                                        ),
                                        color:Colors.white,
                                        elevation: 4,
                                        child: Text("Donate via PM Cares Website"),
                                        onPressed: () {_launchInBrowser(_launchUrl);},
                                      ),
                                    ],
                                  ),
                                ),
                  ),
                  Card(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10, right: 10),
                                        height: 220,
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 15),
                                      Text("Recommended: Must have Aarogya Setu App to fight COVID-19", style: TextStyle(fontFamily: "Poppins",color: Colors.green)),
                                      Text("Aarogya Setu App", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                      Text("An app to connect health services with the people of India to fight COVID-19 \nGet it from here.", style: TextStyle(fontFamily: "Poppins", color: kTextLightColor)),

                                      GestureDetector(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text("Get it from PlayStore", style: TextStyle(color: Colors.blue),),
                                            Image(image: AssetImage("assets/images/aarogya_setu.jpg"),height: 70,width: 90,),
                                          ],
                                        ),
                                        onTap: () {_launchInBrowser('https://play.google.com/store/apps/details?id=nic.goi.aarogyasetu');},
                                      ),
                                    ],
                                  ),
                                ),
                  ),
                  Card(
                    child: Container(
                      height: 200,
                      padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Global Data", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
                          Row(
                            children: <Widget>[ 
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Cases",style: TextStyle(fontFamily: "Poppins", color: kTextLightColor),),
                                  Text("Active",style: TextStyle(fontFamily: "Poppins", color: kTextLightColor),),
                                  Text("Deaths",style: TextStyle(fontFamily: "Poppins", color: kTextLightColor),),
                                  Text("Recovered",style: TextStyle(fontFamily: "Poppins", color: kTextLightColor),),
                                  Text("Today's Cases",style: TextStyle(fontFamily: "Poppins", color: kTextLightColor),),
                                  Text("Today's Recovered",style: TextStyle(fontFamily: "Poppins", color: kTextLightColor),),
                                  Text("Today's Deaths",style: TextStyle(fontFamily: "Poppins", color: kTextLightColor),),
                                ],
                              ),
                              SizedBox(width: 20,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(": " + total['cases'].toString(),style: TextStyle(fontFamily: "Poppins", color: kTextLightColor),),
                                  Text(": " + total['active'].toString(),style: TextStyle(fontFamily: "Poppins", color: kTextLightColor),),
                                  Text(": " + total['deaths'].toString(),style: TextStyle(fontFamily: "Poppins", color: kTextLightColor),),
                                  Text(": " + total['recovered'].toString(),style: TextStyle(fontFamily: "Poppins", color: kTextLightColor),),
                                  Text(": " + total['todayCases'].toString(),style: TextStyle(fontFamily: "Poppins", color: kTextLightColor),),
                                  Text(": " + total['todayRecovered'].toString(),style: TextStyle(fontFamily: "Poppins", color: kTextLightColor),),
                                  Text(": " + total['todayDeaths'].toString(),style: TextStyle(fontFamily: "Poppins", color: kTextLightColor),),
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.green)),
                      height: 50,
                      width: double.infinity,
                      child: Center(child: Text("Do Star this 🙂", style: TextStyle(fontSize: 18))),
                    ),
                    onTap: () {_launchInBrowser('https://github.com/Shrawan907/Covid-19-Flutter-UI');},
                  ),
                            ],
                          ),
                        ),
                ],
              ),
          ),
            ),
          ],
        ),
      );
  }
}
