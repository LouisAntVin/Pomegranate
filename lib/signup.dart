import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fem = 1.0; // Adjust the value of fem as needed.
    double ffem = 1.0; // Adjust the value of ffem as needed.

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: 800 * fem,
        decoration: BoxDecoration(
          color: Color(0xff30303b),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 16 * fem,
              top: 268 * fem,
              child: Align(
                child: SizedBox(
                  width: 93 * fem,
                  height: 36 * fem,
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 30 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.1725 * ffem / fem,
                      color: Color(0xfff44336),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16 * fem,
              top: 311 * fem,
              child: Align(
                child: SizedBox(
                  width: 193 * fem,
                  height: 17 * fem,
                  child: Text(
                    'Hi there! Nice to see you again.',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.1725 * ffem / fem,
                      color: Color(0xff9e95a2),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 55 * fem,
              top: 681 * fem,
              child: Container(
                width: 249 * fem,
                height: 17 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 8 * fem, 0 * fem),
                      child: Text(
                        'Don’t have an account?',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.1725 * ffem / fem,
                          color: Color(0xff9e95a2),
                        ),
                      ),
                    ),
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14 * ffem,
                        fontWeight: FontWeight.w500,
                        height: 1.1725 * ffem / fem,
                        color: Color(0xfffa4645),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 127 * fem,
              top: 531 * fem,
              child: Align(
                child: SizedBox(
                  width: 106 * fem,
                  height: 17 * fem,
                  child: Text(
                    'Forgot Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.1725 * ffem / fem,
                      color: Color(0xff9e95a2),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16 * fem,
              top: 391 * fem,
              child: Align(
                child: SizedBox(
                  width: 160 * fem,
                  height: 17 * fem,
                  child: Text(
                    'u2109037@rajagiri.edu.in',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.1725 * ffem / fem,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16 * fem,
              top: 359 * fem,
              child: Align(
                child: SizedBox(
                  width: 64 * fem,
                  height: 17 * fem,
                  child: Text(
                    'Username',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.1725 * ffem / fem,
                      color: Color(0xfff44336),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16 * fem,
              top: 415 * fem,
              child: Align(
                child: SizedBox(
                  width: 327 * fem,
                  height: 1 * fem,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffd6d1d5),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16 * fem,
              top: 439 * fem,
              child: Container(
                padding: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 11 * fem),
                width: 327 * fem,
                height: 57 * fem,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 9 * fem),
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.1725 * ffem / fem,
                          color: Color(0xfff44336),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 10 * fem),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 8 * fem, 0 * fem),
                            width: 8 * fem,
                            height: 8 * fem,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4 * fem),
                              color: Color(0xffd9d9d9),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 8 * fem, 0 * fem),
                            width: 8 * fem,
                            height: 8 * fem,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4 * fem),
                              color: Color(0xffd9d9d9),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 8 * fem, 0 * fem),
                            width: 8 * fem,
                            height: 8 * fem,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4 * fem),
                              color: Color(0xffd9d9d9),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 8 * fem, 0 * fem),
                            width: 10 * fem,
                            height: 8 * fem,
                            child: Image.network(
                              '[Image URL]',
                              width: 10 * fem,
                              height: 8 * fem,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 8 * fem, 0 * fem),
                            width: 8 * fem,
                            height: 8 * fem,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4 * fem),
                              color: Color(0xffc5c1c1),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 8 * fem, 0 * fem),
                            width: 8 * fem,
                            height: 8 * fem,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4 * fem),
                              color: Color(0xffc5c1c1),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 8 * fem, 0 * fem),
                            width: 8 * fem,
                            height: 8 * fem,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4 * fem),
                              color: Color(0xffc5c1c1),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 185 * fem, 0 * fem),
                            width: 8 * fem,
                            height: 8 * fem,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4 * fem),
                              color: Color(0xffc5c1c1),
                            ),
                          ),
                          Container(
                            width: 20 * fem,
                            height: 20 * fem,
                            child: Image.network(
                              '[Image URL]',
                              width: 20 * fem,
                              height: 20 * fem,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16 * fem,
              top: 583 * fem,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Container(
                  width: 327 * fem,
                  height: 50 * fem,
                  decoration: BoxDecoration(
                    color: Color(0xfffa4645),
                    borderRadius: BorderRadius.circular(10 * fem),
                  ),
                  child: Center(
                    child: Text(
                      'Sign In',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18 * ffem,
                        fontWeight: FontWeight.w500,
                        height: 1.1725 * ffem / fem,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0 * fem,
              top: 47 * fem,
              child: Align(
                child: SizedBox(
                  width: 139 * fem,
                  height: 100 * fem,
                  child: Image.network(
                    '[Image URL]',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12.5 * fem,
              top: 157 * fem,
              child: Align(
                child: SizedBox(
                  width: 342 * fem,
                  height: 87 * fem,
                  child: Text(
                    'Pomegranate',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Handjet',
                      fontSize: 77 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.1175 * ffem / fem,
                      color: Color(0xfffa4645),
                    ),
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