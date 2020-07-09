import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/AppState.dart';
import '../dataProvider/DataLoader.dart';
import 'RockDetails.dart';

class RockWidget extends StatelessWidget {
/*
  final Item rock;

  RockWidget({
    @required this.rock
  });*/


  @override
  Widget build(BuildContext context) {
    return Consumer<appState>(
        builder: (context, rockItem, _) {
          var myState = Provider.of<appState>(context, listen: true);
          if (myState.rockItem != null) {

            return  Flexible(
              //height: 200,
                child:
                RockDetails(rockData: myState.rockItem)
            );
            //);
          }
          return Text('Top on markers to get rock info');

        });

  }
}