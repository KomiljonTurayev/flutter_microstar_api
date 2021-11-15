import 'package:flutter/material.dart';
import 'package:flutter_microstar_api/network/models/trainer_response.dart';
import 'package:flutter_microstar_api/stream/trainer_stream.dart';

class MyListItem extends StatelessWidget {
  TrainerResponse trainer;

  MyListItem(this.trainer);
  TextEditingController trainerNameController = TextEditingController();
  TextEditingController trainerSurnameController = TextEditingController();
  TextEditingController trainerSalaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text(trainer.trainerName ?? ""),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text(trainer.trainerSurname ?? ""),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8.0, left: 8.0),
                child: GestureDetector(
                  onTap: () {
                    showEditDialog(context, trainer);
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.green,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0, left: 8.0),
                child: GestureDetector(
                  onTap: () {
                    showDeleteDialog(context, trainer.id);
                  },
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showEditDialog(BuildContext context, TrainerResponse response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure ?'),
                TextField(
                  controller: trainerNameController
                    ..text = response.trainerName,
                  decoration: InputDecoration(
                    hintText: 'Enter your name ',
//                    errorText: trainerNameController.text.isEmpty
//                        ? 'Please enter name'
//                        : null,
                  ),
                ),
                TextField(
                  controller: trainerSurnameController
                    ..text = response.trainerSurname,
                  decoration: InputDecoration(
                    hintText: 'Enter your surname ',
//                    errorText: trainerSurnameController.text.isEmpty
//                        ? 'Please enter surname'
//                        : null,
                  ),
                ),
                TextField(
                  controller: trainerSalaryController
                    ..text = "${response.trainerSalary}",
                  decoration: InputDecoration(
                    hintText: 'Enter your salary ',
//                    errorText: trainerSalaryController.text.isEmpty
//                        ? 'Please enter salary'
//                        : null,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                trainerStream.trainerRepository
                    .updateTrainer(TrainerResponse(
                        id: response.id,
                        trainerName: trainerNameController.text.toString(),
                        trainerSurname:
                            trainerSurnameController.text.toString(),
                        trainerSalary: double.parse(
                            trainerSalaryController.text.toString())))
                    .then((value) {
                  trainerStream.trainerRepository.getTrainersList().then(
                      (trainerList) =>
                          trainerStream.trainerSink.add(trainerList));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure ?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                trainerStream.trainerRepository.deleteTrainer(id).then((value) {
                  trainerStream.trainerRepository.getTrainersList().then(
                      (trainerList) =>
                          trainerStream.trainerSink.add(trainerList));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
