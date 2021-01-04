import 'package:flutter/material.dart';

class InfoDailouge extends StatelessWidget {
  final String name, info;
  InfoDailouge(this.name, this.info);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        height: MediaQuery.of(context).size.longestSide * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Opensans',
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(info,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Opensans',
                    fontWeight: FontWeight.bold,
                  )),
            ),
            FlatButton(
              padding: EdgeInsets.all(0),
              color: Theme.of(context).buttonColor,
              onPressed: () => Navigator.of(context).pop(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                child: Text(
                  "CLOSE",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Opensans',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.button.color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
