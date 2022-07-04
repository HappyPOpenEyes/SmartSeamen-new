// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'GetVesselResponse.dart';

enum VesselAction { Post }

class VesselBloc {
  final _stateStreamController = StreamController<List<Categories>>.broadcast();
  List<String> vesselname = [];
  List<String> vesselid = [];
  List<String> itemClass = [];
  List<Categories> itemVessel = [];
  var header;

  StreamSink<List<Categories>> get _stateVesselSink =>
      _stateStreamController.sink;
  Stream<List<Categories>> get stateVesselStrean =>
      _stateStreamController.stream;

  final _eventStreamController = StreamController<VesselAction>();
  StreamSink<VesselAction> get eventVesselSink => _eventStreamController.sink;
  Stream<VesselAction> get _eventVesselStrean => _eventStreamController.stream;

  VesselBloc() {
    _eventVesselStrean.listen((event) async {
      if (event == VesselAction.Post) {
        try {
          var response = await callgetVesselapi();
          GetVesselResponse getVesselResponse =
              getVesselResponseFromJson(response);
          if (vesselid.isEmpty) {
            for (int i = 0; i < getVesselResponse.data.length; i++) {
              if (getVesselResponse.data[i].itemClass !=
                  ItemClass.FIRST_LEVEL) {
                if (getVesselResponse.data[i].id != null) {
                  vesselid.add(getVesselResponse.data[i].id!);
                } else {
                  vesselid.add("");
                }
              } else {
                vesselid.add("");
              }
              vesselname.add(getVesselResponse.data[i].vesselName);
              itemClass.add(getVesselResponse.data[i].itemClass.toString());
              itemVessel.add(Categories(
                  name: getVesselResponse.data[i].vesselName,
                  type: getVesselResponse.data[i].itemClass.toString()));
            }
          }
          _stateVesselSink.add(itemVessel);
        } catch (e) {
          _stateVesselSink.addError('Something went wrong');
        }
      }
    });
  }

  Future<String> callgetVesselapi() async {
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/getvessel'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header
        },
      );

      print(response.statusCode);

      return response.body;
    } catch (err) {
      return err.toString();
    }
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}

class Categories {
  String name;
  String type;

  Categories({required this.name, required this.type});

  @override
  String toString() {
    return name;
  }
}
