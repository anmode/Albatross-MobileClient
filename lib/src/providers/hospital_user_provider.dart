import 'package:flutter/material.dart';
import 'package:Albatross/src/models/hospital.dart';

class HospitalUserProvider extends ChangeNotifier {
  Hospital _hospital=Hospital();

  Hospital get getHospital {
    return _hospital;
  }

  set setHospital(Hospital hospital) {
    _hospital = hospital;
    notifyListeners();
  }
}
