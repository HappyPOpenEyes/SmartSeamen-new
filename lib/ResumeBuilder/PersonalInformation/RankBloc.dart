// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'GetRankResponse.dart';

enum RankAction { Post }

class RankBloc {
  final _stateStreamController = StreamController<List<String>>.broadcast();
  List<String> rankname = [];
  List<String> rankid = [];
  List<String> ranktype = [];
  var header;

  StreamSink<List<String>> get _stateRankSink => _stateStreamController.sink;
  Stream<List<String>> get stateRankStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<RankAction>();
  StreamSink<RankAction> get eventRankSink => _eventStreamController.sink;
  Stream<RankAction> get _eventRankStrean => _eventStreamController.stream;

  RankBloc() {
    _eventRankStrean.listen((event) async {
      if (event == RankAction.Post) {
        try {
          var response = await callgetRankapi();
          GetRankResponse getRankResponse = getRankResponseFromJson(response);
          if (rankid.isEmpty) {
            for (int i = 0; i < getRankResponse.data.length; i++) {
              rankname.add(getRankResponse.data[i].rankName);
              rankid.add(getRankResponse.data[i].id);
              ranktype.add(getRankResponse.data[i].rankType.toString());
            }
          }
          _stateRankSink.add(rankname);
        } catch (e) {
          _stateRankSink.addError('Something went wrong');
        }
      }
    });
  }

  Future<String> callgetRankapi() async {
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/getrank'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header
        },
      );

      print(response.statusCode);
      

      return response.body;
    } catch (err) {
      print(err.toString());
      return err.toString();
    }
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
