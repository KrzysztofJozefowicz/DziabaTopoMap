import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/appState.dart';
import 'RockDetails.dart';

class RockWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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

  }
}