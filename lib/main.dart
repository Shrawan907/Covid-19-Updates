import 'package:covid_19/resources/constant.dart';
import 'package:flutter/material.dart';
import 'package:covid_19/screens/home_screen.dart';
import 'package:covid_19/screens/dataScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:covid_19/screens/fastQ.dart';
import 'package:covid_19/resources/dataSource.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            body1: TextStyle(color: kBodyTextColor),
          )),
      home: Page(),
    );
  }
}



Map countryData;
Map globalData;

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  bool search = true;
  PageController pageController;
  int pageIndex = 0;

  Future fetchData() async {
    await fetchThisData();
    setState(() {
      search = false;
    });
  }  

  @override
  void initState() {
    super.initState();
      fetchData();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut
    );
  }

  Widget buildScreen() {
    return search ? Scaffold(body: Column(
      mainAxisAlignment: MainAxisAlignment.center,  
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SpinKitThreeBounce(color: Colors.blueAccent, size: 25,),
        Text("Check all cases at one place",style: TextStyle(color: kBodyTextColor, fontFamily: "Poppins")),
      ],
    )) : Scaffold(
      body: PageView(
        children: <Widget>[
          HomeScreen(),
          DropDown(),
          FAQPage()
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),),
          BottomNavigationBarItem(icon: Icon(Icons.insert_chart),),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer),),
        ],
      )
    );
//    return RaisedButton(
//      child: Text('Logout'),
//      onPressed: logout,
//    );
  }


  @override
  Widget build(BuildContext context) {
    return buildScreen();

  }
}
