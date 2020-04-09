import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.0,
      color: const Color(0xff0087a8),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: const Color.fromRGBO(19, 12, 117, 1.0),
        ),
        child: Stack(
          children: <Widget>[
            Text(
              'EUR - USD',
              style: Theme.of(context).textTheme.headline3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Forex',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: const Color(0xff0087a8),
                onPressed: () {},
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
