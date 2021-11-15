import 'dart:async';

import 'package:flutter_microstar_api/network/models/trainer_response.dart';
import 'package:flutter_microstar_api/repository/trainer_repository.dart';

class TrainerStream {
  var trainerRepository = TrainerRepository();

  final _stateStreamController = StreamController<List<TrainerResponse>>();
  StreamSink<List<TrainerResponse>> get trainerSink =>
      _stateStreamController.sink;

  Stream<List<TrainerResponse>> get trainerStream =>
      _stateStreamController.stream;
}

var trainerStream = TrainerStream();
