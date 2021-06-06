import 'package:flutter/material.dart';
import 'dart:io';

class MyDialogs {

  static confirmDialog(BuildContext context, String title, String message, List lists) async {
    var result = await showDialog<int>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
          title: Text(title),
          content: Text(message),
          actions: <Widget> [
            for (int i = 0; i < lists.length; i++)
              FlatButton(child: Text(lists[i]), onPressed: () => Navigator.pop(context, i),),
          ],
        );
      },
    );
    return result;
  }

  static confirmDialogWithImage(BuildContext context, String message, String img, List lists) async {
    var result = await showDialog<int>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Container(height: 150,
          child: Column( children: <Widget> [Text(message), Image.file(File(img), width: 120, height: 120)])),
          actions: <Widget> [
            for (int i = 0; i < lists.length; i++)
              FlatButton(child: Text(lists[i]), onPressed: () => Navigator.pop(context, i),),
          ],
        );
      },
    );
    return result;
  }

  static selectDialog(BuildContext context, String title, List lists) async {
    var result = await showDialog<int>(
      context: context,
      builder: (_) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
          title: Text(title, textAlign: TextAlign.center),
          children: <Widget>[
            for (int i = 0; i < lists.length; i++)
              SimpleDialogOption(child: Text(lists[i], textAlign: TextAlign.center), onPressed: (){Navigator.pop(context, i);},),
          ],
        );
      },
    );
    return result;
  }

  static chkboxDialog(BuildContext context, String title, List<String> list, List<bool> check) async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(title),
              content:  Container(height: 300, width: double.maxFinite,
                child: ListView.builder(
                    itemBuilder: (BuildContext context, int i) {
                      return Row(children: <Widget>[
                        Container(height: 35, child: Row(children: <Widget>[
                          Checkbox(value: check[i], onChanged: (bool value) {setState(() {check[i] = value;});},),
                          Text(list[i]),],), )]);
                    },
                    itemCount: list.length),),
              actions: <Widget>[FlatButton(child: Text("OK"), onPressed: () {Navigator.pop(context, check);}),],
            );
          },
        );
      },
    );
  }
}
