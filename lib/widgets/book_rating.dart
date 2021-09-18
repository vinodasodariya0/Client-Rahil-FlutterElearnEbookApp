import 'package:flutter/material.dart';

class BookRating extends StatelessWidget {
  final String score;

  const BookRating({
    Key key,
    this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
      ),
    );
  }
}
