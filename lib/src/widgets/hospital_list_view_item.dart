import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Albatross/src/helpers/dimensions.dart';
import 'package:Albatross/src/models/hospital.dart';
import 'package:Albatross/src/screens/hospital_info_screen.dart';
import 'package:Albatross/src/widgets/slide_page_route.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HospitalListViewItem extends StatelessWidget {
  final Hospital hospital;
  final PanelController panelController;
  final Completer<GoogleMapController> controller;
  static var viewportHeight;
  static var viewportWidth;
  final int inputDistance;

  HospitalListViewItem(
      {this.hospital,
      this.controller,
      this.panelController,
      this.inputDistance});

  @override
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getViewportWidth(context);
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: viewportWidth * 0.05, vertical: viewportHeight * 0.01),
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.blue,
          )),

      clipBehavior: Clip.hardEdge, //color: Color(0xffeefdec),
      child: InkWell(
        splashColor: Colors.blue,
        onTap: () async {
          panelController.close();
          final GoogleMapController controller2 = await controller.future;
          CameraPosition myPosition = CameraPosition(
            bearing: 192,
            target: LatLng(hospital.getLatitude, hospital.getLongitude),
            tilt: 0,
            zoom: 18,
          );
          controller2.animateCamera(CameraUpdate.newCameraPosition(myPosition));
        },
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: <Widget>[
            Text(
              hospital.getName,
              style: TextStyle(
                  fontFamily: "BalooTamma2",
                  fontSize: viewportHeight * 0.03,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.left,
            ),
            RichText(
                text: TextSpan(
                    text: "Availability: ",
                    style: TextStyle(
                        fontSize: viewportHeight * 0.018,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Manrope"),
                    children: <TextSpan>[
                  TextSpan(
                    text: hospital.getAvailability
                        ? "Available"
                        : "Not Available",
                    style: TextStyle(
                        fontSize: viewportHeight * 0.018,
                        color:
                            hospital.getAvailability ? Colors.blue : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins"),
                  ),
                  TextSpan(
                    text: "\nDisplacement from current location: ",
                    style: TextStyle(
                        fontSize: viewportHeight * 0.018,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Manrope"),
                  ),
                  TextSpan(
                    text: hospital.getDistance.toStringAsPrecision(3) + " km",
                    style: TextStyle(
                        fontSize: viewportHeight * 0.018,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins"),
                  )
                ])),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.my_location),
                    iconSize: viewportHeight * 0.035,
                    splashColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () async {
                      panelController.close();
                      final GoogleMapController controller2 =
                          await controller.future;
                      CameraPosition myPosition = CameraPosition(
                        bearing: 192,
                        target:
                            LatLng(hospital.getLatitude, hospital.getLongitude),
                        tilt: 0,
                        zoom: 18,
                      );
                      controller2.animateCamera(
                          CameraUpdate.newCameraPosition(myPosition));
                    }),
                RaisedButton(
                  elevation: 1,
                  onPressed: () async {
                    Navigator.push(
                        context,
                        SlidePageRoute(
                            page: HospitalInfo(
                          hospital: hospital,
                          inputDistance: inputDistance,
                        )));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  splashColor: Colors.white,
                  color: Colors.green,
                  child: Container(
                      width: viewportWidth * 0.2,
                      height: viewportHeight * 0.03,
                      alignment: Alignment.center,
                      child: Text(
                        'More info',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Manrope",
                          fontSize: viewportHeight * 0.020,
                        ),
                      )),
                  textColor: Colors.white,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
