import 'package:flutter/material.dart';

import 'constants.dart';

class NoInternet extends StatelessWidget {
  var className;

  NoInternet({this.className});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('images/no_internet.png'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'No Internet connection',
                  style: TextStyle(
                      color: kBluePrimaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Check your internet connection, then refresh the page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () async {
                    if (!await checkConnectivity())
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => className));
                  },
                  color: kgreenPrimaryColor,
                  child: Text(
                    'Refresh',
                    style: TextStyle(color: kbackgroundColor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
