import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospitality/src/dialogs/loading_dialog.dart';
import 'package:hospitality/src/helpers/current_location.dart';
import 'package:hospitality/src/helpers/dimensions.dart';
import 'package:hospitality/src/models/hospital.dart';
import 'package:hospitality/src/models/user.dart';
import 'package:hospitality/src/providers/hospital_list_provider.dart';
import 'package:hospitality/src/providers/user_profile_provider.dart';
import 'package:hospitality/src/resources/network/network_repository.dart';
import 'package:hospitality/src/helpers/fetch_user_data.dart';
import 'package:hospitality/src/widgets/scale_page_route.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'map_screen.dart';

class SearchHospitalScreen extends StatefulWidget {
  final ScrollController controller;
  final GlobalKey<FormState> formKey;

  SearchHospitalScreen({
    @required this.formKey,
    @required this.controller,
  });

  @override
  State<StatefulWidget> createState() {
    return _SearchHospitalScreenState(
      formKey: formKey,
      controller: controller,
    );
  }
}

class _SearchHospitalScreenState extends State<SearchHospitalScreen> {
  double viewportHeight;
  double viewportWidth;
  HospitalListProvider hospitalListProvider;
  bool isButtonEnabled = false;
  ScrollController controller;
  GlobalKey<FormState> formKey;
  double distance = 0;
  UserProfileProvider userProfileProvider;
  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);

  _SearchHospitalScreenState({
    @required this.formKey,
    @required this.controller,
  });

  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getViewportWidth(context);
    userProfileProvider = Provider.of<UserProfileProvider>(context);
    hospitalListProvider = Provider.of<HospitalListProvider>(context);

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          controller.animateTo(
            0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        },
        child: SingleChildScrollView(
          controller: controller,
          child: Container(
            height: viewportHeight,
            width: viewportWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue.shade100, Colors.blue.shade300]),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: viewportHeight * 0.05),
                  height: viewportHeight * 0.25,
                  width: viewportWidth * 0.8,
                  child: Image.asset('assets/img/hosp_doc.png'),
                ),
                SizedBox(
                  height: viewportHeight * 0.1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    SizedBox(width: viewportWidth * 0.03),
                    Text(
                      'Input distance for nearby hospital',
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: viewportWidth * 0.04,
                          color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(
                  height: viewportHeight * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        onTap: () {
                          controller.animateTo(
                            viewportHeight * 0.2,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                        cursorColor: Theme.of(context).primaryColor,
                        style: dropdownMenuItem,
                        decoration: InputDecoration(
                          hintText: "Search by distance in km",
                          hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: viewportWidth * 0.045),
                          prefixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                _submitForm(context);
                                formKey.currentState.reset();
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: viewportWidth * 0.05,
                              vertical: viewportHeight * 0.02),
                        ),
                        keyboardType: TextInputType.phone,
                        onChanged: (String value) {
                          if (value.length == 0) {
                            setState(() {
                              isButtonEnabled = false;
                            });
                          } else {
                            setState(() {
                              isButtonEnabled = true;
                            });
                          }
                          distance = double.parse(value);
                        },
                        onFieldSubmitted: (String value) {
                          controller.animateTo(
                            0,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                        onSaved: (String value) {
                          if (value.length == 0) {
                            setState(() {
                              isButtonEnabled = false;
                            });
                          } else {
                            setState(() {
                              isButtonEnabled = true;
                            });
                          }
                          distance = double.parse(value);
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: viewportHeight * 0.06),
                RaisedButton(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(color: Colors.blue, width: 1)),
                  splashColor: isButtonEnabled ? Colors.blue : null,
                  color: isButtonEnabled ? Colors.white : Colors.grey.shade400,
                  child: Container(
                    width: viewportWidth * 0.35,
                    height: viewportHeight * 0.06,
                    alignment: Alignment.center,
                    child: Text(
                      'Search',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isButtonEnabled
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                        fontFamily: "Manrope",
                        fontSize: viewportHeight * 0.025,
                      ),
                    ),
                  ),
                  textColor: Colors.white,
                  onPressed: () {
                    if (isButtonEnabled) {
                      _submitForm(context);
                      formKey.currentState.reset();
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () async {
      await fetchPatientUserData(
          context: context, userProfileProvider: userProfileProvider);
    });
  }

 void _submitForm(BuildContext context) async {
    User user;
    LocationData locationData;
    controller.animateTo(
      0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
    formKey.currentState.save();
    setState(() {
      isButtonEnabled = false;
    });
    showLoadingDialog(context: context);
    getLocation().then((value) async {
      if (value != null) {
        user = userProfileProvider.getUser;
        user.setLatitude = value.latitude;
        user.setLongitude = value.longitude;
        locationData = value;
        await getNetworkRepository
            .updateLocation(
          latitude: value.latitude,
          longitude: value.longitude,
        )
            .then((value) async {
          if (value.statusCode == 200) {
            userProfileProvider.setUser = user;
            await getNetworkRepository
                .sendCurrentLocationAndGetHospitalLists(
                    latitude: user.getLatitude,
                    longitude: user.getLongitude,
                    range: distance)
                .then((value) async {
              if (value.statusCode == 200) {
                List<dynamic> response = json.decode(value.body);
                List<Hospital> hospitals = new List<Hospital>();
                hospitalListProvider.setHospitalLists = hospitals;
                for (int i = 0; i < response.length; i++) {
                  Map<String, dynamic> data =
                      response[i].cast<String, dynamic>();
                  Hospital h = Hospital.fromJSON(data);
                  hospitals.add(h);
                }
                if (hospitals.length == 0) {
                  Fluttertoast.showToast(
                      msg:
                          "No nearby hospitals found! Try again or change the distance limit!",
                      toastLength: Toast.LENGTH_SHORT);
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                } else {
                  hospitalListProvider.setHospitalLists = hospitals;
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  Navigator.push(
                      context,
                      ScalePageRoute(
                          page: MapView(
                        inputDistance: distance.toInt(),
                        locationData: locationData,
                      )));
                }
              } else if (value.statusCode == 404) {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Fluttertoast.showToast(
                    msg:
                        "No nearby hospitals found! Try again or change the distance limit!",
                    toastLength: Toast.LENGTH_SHORT);
                print("Get Hospitals List: " + value.statusCode.toString());
              } else {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Fluttertoast.showToast(
                    msg: "Error fetching hospitals! Try again!",
                    toastLength: Toast.LENGTH_SHORT);
                print("Get Hospitals List: " + value.statusCode.toString());
              }
            }).catchError((error) {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              Fluttertoast.showToast(
                  msg: "Error fetching hospitals! Try again!",
                  toastLength: Toast.LENGTH_SHORT);
              print("Get Hospitals List: " + error.toString());
            });
          } else {
            Fluttertoast.showToast(
              msg: "Error in updating location",
            );
            print(
                "Update Location: ${value.statusCode.toString() + value.body.toString()}");
            Navigator.of(context, rootNavigator: true).pop('dialog');
          }
        }).catchError((error) {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          Fluttertoast.showToast(
            msg: "Error in updating location",
          );
        });
      } else {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Fluttertoast.showToast(
            msg: "Error in getting location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
      }
    }).catchError((error) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Fluttertoast.showToast(
          msg: "Error in getting location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
      print("Get Hospitals List: " + error.toString());
    });
  }
}