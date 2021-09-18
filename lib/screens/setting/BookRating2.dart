import 'package:flutter/material.dart';

class BookRating2 extends StatelessWidget {
  final String score;

  const BookRating2({
    Key key,
    this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: Offset(3, 7),
            blurRadius: 20,
            color: Color(0xFD3D3D3).withOpacity(.2),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.star,
            color: Color(0xff2055AD),
            size: 24,
          ),
          SizedBox(height: 5),
          Text(
            score == null ? "0" : "$score",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
