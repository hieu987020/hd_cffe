import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String _text;
  HeaderText(this._text);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Text(
        _text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      padding: EdgeInsets.only(top: 10, left: 5, right: 10),
    );
  }
}

class AppBarText extends StatelessWidget {
  final String _text;
  AppBarText(this._text);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Text(
        _text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ManagerText extends StatelessWidget {
  final String _text;
  ManagerText(this._text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5),
      child: new Text(
        _text,
        style: TextStyle(
          color: Color.fromRGBO(69, 75, 102, 1),
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class StoreText extends StatelessWidget {
  final String _text;
  StoreText(this._text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5),
      child: new Text(
        _text,
        style: TextStyle(
          color: Color.fromRGBO(24, 34, 76, 1),
          fontSize: 15,
          //fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class StatusText extends StatelessWidget {
  final String _text;
  StatusText(this._text);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      color: Color.fromRGBO(235, 255, 241, 1),
      child: new Center(
        child: Text(
          _text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromRGBO(17, 156, 43, 1),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CardText extends StatelessWidget {
  final String _managerText;
  final String _storeText;
  CardText(this._managerText, this._storeText);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ManagerText(_managerText),
        StoreText(_storeText),
      ],
    );
  }
}
