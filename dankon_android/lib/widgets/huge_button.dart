import 'package:dankon/constants.dart';
import 'package:flutter/material.dart';

class HugeButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  const HugeButton({Key? key, required this.onPressed, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(

        onPressed: onPressed,

        icon: Icon(Icons.add),

        label: Text(text, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),),

        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: kTextColor,
          onPrimary: Colors.white,
          padding: EdgeInsets.all(20)
        ),


      ),
    );
  }
}