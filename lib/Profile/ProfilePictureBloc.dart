import 'dart:async';

import 'package:image_cropper/image_cropper.dart';

enum ProfilePictureAction { True, False }

class ProfilePictureBloc {
  bool _profilePicturevalue = false;
  CroppedFile? image;
  final _stateStreamController = StreamController<bool>.broadcast();

  StreamSink<bool> get _stateProfilePictureSink => _stateStreamController.sink;
  Stream<bool> get stateProfilePictureStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<ProfilePictureAction>();
  StreamSink<ProfilePictureAction> get eventProfilePictureSink =>
      _eventStreamController.sink;
  Stream<ProfilePictureAction> get _eventProfilePictureStrean =>
      _eventStreamController.stream;

  profilePictureBloc() {
    _eventProfilePictureStrean.listen((event) async {
      if (event == ProfilePictureAction.True) {
        _profilePicturevalue = true;
      } else if (event == ProfilePictureAction.False) {
        _profilePicturevalue = false;
      }
      _stateProfilePictureSink.add(_profilePicturevalue);
    });
  }

  void dispose() {
    _profilePicturevalue = false;
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
