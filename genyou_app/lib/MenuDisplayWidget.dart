import 'package:flutter/material.dart';
import 'dart:io';

class MenuDisplayWidget extends StatefulWidget {
  final double width;
  final double height;
  final String name;
  final List<dynamic> stuffs;
  final String imgpath;
  final List<String> mystuffs;

  MenuDisplayWidget({Key key, this.width, this.height, this.name, this.stuffs, this.imgpath, this.mystuffs}) : super(key: key);

  @override
  _MenuDisplayWidget createState() => _MenuDisplayWidget();
}

class _MenuDisplayWidget extends State<MenuDisplayWidget> {

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Container(width: widget.width, height: widget.height,
    decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0),
      borderRadius: BorderRadius.circular(10),),
        child: Column(
            children: <Widget>[
              SizedBox(height: 5,),
              Align(alignment: Alignment.center,
                child: Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ),
              SizedBox(height: 5,),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Container(width: 0.45 * widget.width,
                      child: Image.memory(File(widget.imgpath).readAsBytesSync())),
                    SizedBox(width: 0.1 * widget.width),
                    Container(width: 0.45 * widget.width,
                      child: _foodStuff()
                    ),
                  ]
              )),
            ]
        ),
    );

    Widget _foodStuff() {
      return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            Color c = Colors.red;
            for (int i=0; i<widget.mystuffs.length; ++i) {
              if (widget.mystuffs[i] == widget.stuffs[index])
                c = Colors.black;
            }
            return Text(widget.stuffs[index], style: TextStyle(color: c));
          }, itemCount: widget.stuffs.length);
    }
  }