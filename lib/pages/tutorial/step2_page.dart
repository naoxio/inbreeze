import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'page_layout.dart';

class Step2Page extends StatefulWidget {
  @override
  State<Step2Page> createState() => _Step2PageState();
}

class _Step2PageState extends State<Step2Page> {
  List<bool> breathSpeed = [false, true, false];
  List<bool> breathAudio = [false, true];
  @override
  Widget build(BuildContext context) {
    return  PageLayout(
      buttonText: 'Continue',
      nextRoute: '/guide/step3',
      onPressed: () {
        context.go('/guide/step3');
      },
      column: Column(
        children: [
          Text(
            'Step 2: Exhale and hold',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Exhale normally and hold',
            style: TextStyle(
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Tempo',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ToggleButtons(
            isSelected: breathSpeed,
            onPressed: (int index) {
              breathSpeed[index] = !breathSpeed[index];
            },
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  'Slow',
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  'Normal',
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  'Custom',
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 180),
          Text(
            'Audio',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ToggleButtons(
            isSelected: breathAudio,
            onPressed: (int index) {
              breathAudio[index] = !breathAudio[index];
            },
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  'None',
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  'Breath',
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}