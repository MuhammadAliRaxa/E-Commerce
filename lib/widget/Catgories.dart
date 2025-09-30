import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Catgories extends StatefulWidget {
  final String name;
  bool? selected;
  Catgories({
    super.key,
    required this.name,
    this.selected,
  });

  @override
  State<Catgories> createState() => _CatgoriesState();
}

class _CatgoriesState extends State<Catgories> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.all(3),
      child: Container(
      
        decoration: BoxDecoration(
          color:  widget.selected!?Colors.black:Colors.white,
          border: Border.all(width: 1,color: CupertinoColors.black),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: EdgeInsets.all(3),
          child: Center(
            child: Text(widget.name,style: TextStyle(
              color: widget.selected!?Colors.white:Colors.black,
              fontSize: 16,
              fontStyle: FontStyle.italic
            ),),
          ),
        ),
      ),
    );
  }
}
