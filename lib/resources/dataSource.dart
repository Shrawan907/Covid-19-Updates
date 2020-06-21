import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

Map data = { 
    'cases':'...',
    'deaths':'...',
    'active':'...',
    'todayCases':'...',
    'todayDeaths':'...',
    'recovered':'...' 
  };

Map total = { 
    'cases':'...',
    'deaths':'...',
    'active':'...',
    'todayCases':'...',
    'todayDeaths':'...',
    'todayRecovered':'...',
    'recovered':'...' 
  };
Map statesData;
// Map districtsData;
List otherCountryData;
List<String> stateNames = [];
// Map districtsNames;

// Future<Map> fetchcountryData() async {
//   print("fetchcountryData");
//   http.Response response = await http.get('https://disease.sh/v2/countries/india');
//     if(response.statusCode == 200) {
//       data =  json.decode(response.body);
//     }
//     print(response.statusCode);
//     return data;
// }

Future<Map> fetchStateData() async {
    try {
    statesData = {};
    http.Response response =
      await http.get('https://api.covid19india.org/data.json');
    if(response.statusCode == 200) {
      statesData =  json.decode(response.body);
    }
    print("fetchStateData");
    }
    catch(e) {print("hello2");}

    return statesData;
}

// Future<Map> fetchDestrictsData() async {
//     districtsData = {};
//     http.Response response =
//       await http.get('https://api.covid19india.org/state_district_wise.json');
//     if(response.statusCode == 200) {
//       districtsData =  json.decode(response.body);
//     }
//     print("fetchDestrictsData");
//     return districtsData;
// }

Future<List> fetchOtherCountryData() async {
  try {
    otherCountryData = [];
    http.Response response =
      await http.get('https://corona.lmao.ninja/v2/countries');
    if(response.statusCode == 200) {
      otherCountryData =  json.decode(response.body);
    }
    print("fetchOtherCountryData");
  }
  catch(e) { print("hello"); }
  return otherCountryData;
}

Future<Map> fetchTotalData() async {
    try {
    http.Response response =
      await http.get('https://corona.lmao.ninja/v2/all');
    if(response.statusCode == 200) {
      total =  json.decode(response.body);
    }
    print("fetchTotalData");
    }
    catch(e) {print("hello1");}
    return total;
}

Map getTotaldata() {
  print("getTotaldata");
  print(total['cases']);
  return total;
}

Future fetchThisData() async {
  // await fetchcountryData();
  try {
   await fetchTotalData();
   await fetchOtherCountryData();
  }
  catch(e) {
    print("this data");
  }
  // await fetchDestrictsData();
}

Map getCountrydata() {
  if(otherCountryData.length >= 93)
    data = otherCountryData[93];
  print("getCountrydata");
  return data;
}

Map getStatedata()  {
  print("getStatedata");
  return statesData;
}

// Map getDistrictsdata()  {
//   print("getDistrictsdata");
//   return districtsData;
// }

List getOtherCountrydata()  {
  print("getOtherCountrydata");
  return otherCountryData;
}


List getStatesList() {
  print("getStatesList");
  if(statesData.isNotEmpty) {
    stateNames = [];
    statesData.forEach((key, value) {
      if(key == "statewise") {
          List list = statesData[key];
          for(int i=0;i<list.length;i++)
            stateNames.add(list[i]["state"]);
      }
    });
  }
  return stateNames;
}
// List temp;
// Map getDistrictsList() {
//   print("getDistrictsList");
//   if(districtsData.isNotEmpty) {
//       districtsData.forEach((key, value) {
//         temp = [];
//         if(key != "State Unassigned" && key != "Andaman and Nicobar Islands")
//         districtsData[key]["districtData"].forEach((k,v) {
//             temp.add(k);
//             districtsNames[key] = temp;
//         });
//         print(temp);
//     });
//     }
//   return {'asdf': 26};
// }

//     for(int i=0;i<districtsData.length;i++) {
//       List li = districtsData
//       for(int j=0;j<districtsData[i]["districtData"].length;j++)
//         districtsNames.add(districtsData[i]["districtData"][]);

// districtsNames

// districtsData[state]["districtData"][district]['deceased']