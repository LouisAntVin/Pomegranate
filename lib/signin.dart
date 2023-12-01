import 'package:flutter/material.dart';

class YourTextButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Container(
        width: double.infinity,
        height: 800, // Set your desired height
        decoration: BoxDecoration(
          color: Color(0xff30303b),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 68,
              top: 457,
              child: Align(
                child: SizedBox(
                  width: 223,
                  height: 56,
                  child: Text(
                    'Pomegranate',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Color(0xfffa4645),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 57,
              top: 251,
              child: Align(
                child: SizedBox(
                  width: 246,
                  height: 255,
                  child: Image.network(
                    'https://png.pngtree.com/png-vector/20220709/ourmid/pngtree-half-of-pomegranate-icon-png-image_5592439.png', // Replace with your image URL
                    fit: BoxFit.cover,
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
