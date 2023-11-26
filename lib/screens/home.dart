import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 390,
          height: 844,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0xFFEDF3F8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(55),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 25,
                top: 42,
                child: Text(
                  'Gas.io',
                  style: TextStyle(
                    color: Color(0xFF46BD84),
                    fontSize: 50,
                    fontFamily: 'Red Rose',
                    fontWeight: FontWeight.w700,
                    height: 0.01,
                    letterSpacing: 0.30,
                  ),
                ),
              ),
              Positioned(
                left: 25,
                top: 105,
                child: Container(
                  width: 333,
                  height: 44,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Opacity(
                          opacity: 0.70,
                          child: Container(
                            width: 333,
                            height: 44,
                            decoration: ShapeDecoration(
                              color: Color(0xCCABCDBD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(43),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Opacity(
                          opacity: 0.80,
                          child: Container(
                            width: 29,
                            height: 29,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://via.placeholder.com/29x29"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 313,
                top: 31,
                child: Container(
                  width: 45,
                  height: 45,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: ShapeDecoration(
                            color: Color(0xFF46BD84),
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Container(
                          width: 29,
                          height: 29,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://via.placeholder.com/29x29"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: -11,
                top: 149,
                child: Container(
                  width: 401,
                  height: 740,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFF9747FF)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 20,
                        top: 20,
                        child: Container(
                          width: 361,
                          height: 124,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 361,
                                  height: 124,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 21,
                                top: 15,
                                child: Text(
                                  '20-10-2023',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'JetBrains Mono',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 172,
                                top: 14,
                                child: Container(
                                  height: 12,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 15,
                                        top: 0,
                                        child: Text(
                                          'Avi Luca, Tressilla (TN) 38043',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 9,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://via.placeholder.com/12x12"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 21,
                                top: 36,
                                child: Container(
                                  width: 138,
                                  height: 73,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 2,
                                        child: Container(
                                          width: 112,
                                          height: 71,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFD9D9D9)),
                                        ),
                                      ),
                                      Positioned(
                                        left: 116,
                                        top: 0,
                                        child: Text(
                                          '€',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 36,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 119,
                                        top: 40,
                                        child: Text(
                                          'L',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 24,
                                        top: 6,
                                        child: Text(
                                          '78,45',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 36,
                                            fontFamily: 'Seven Segment',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 49,
                                        top: 43,
                                        child: Text(
                                          '45,73',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'Seven Segment',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 194,
                                top: 57,
                                child: Container(
                                  width: 121,
                                  height: 33,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 1,
                                        child: Container(
                                          width: 70,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFD9D9D9)),
                                        ),
                                      ),
                                      Positioned(
                                        left: 7,
                                        top: 3,
                                        child: Text(
                                          '1,845',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'Seven Segment',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 76,
                                        top: 0,
                                        child: Text(
                                          '€/L',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 164,
                        child: Container(
                          width: 361,
                          height: 124,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 361,
                                  height: 124,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 21,
                                top: 15,
                                child: Text(
                                  '20-10-2023',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'JetBrains Mono',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 172,
                                top: 14,
                                child: Container(
                                  height: 12,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 15,
                                        top: 0,
                                        child: Text(
                                          'Avi Luca, Tressilla (TN) 38043',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 9,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://via.placeholder.com/12x12"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 21,
                                top: 36,
                                child: Container(
                                  width: 138,
                                  height: 73,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 2,
                                        child: Container(
                                          width: 112,
                                          height: 71,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFD9D9D9)),
                                        ),
                                      ),
                                      Positioned(
                                        left: 116,
                                        top: 0,
                                        child: Text(
                                          '€',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 36,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 119,
                                        top: 40,
                                        child: Text(
                                          'L',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 24,
                                        top: 6,
                                        child: Text(
                                          '78,45',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 36,
                                            fontFamily: 'Seven Segment',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 49,
                                        top: 43,
                                        child: Text(
                                          '45,73',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'Seven Segment',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 194,
                                top: 57,
                                child: Container(
                                  width: 121,
                                  height: 33,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 1,
                                        child: Container(
                                          width: 70,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFD9D9D9)),
                                        ),
                                      ),
                                      Positioned(
                                        left: 7,
                                        top: 3,
                                        child: Text(
                                          '1,845',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'Seven Segment',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 76,
                                        top: 0,
                                        child: Text(
                                          '€/L',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 308,
                        child: Container(
                          width: 361,
                          height: 124,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 361,
                                  height: 124,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 21,
                                top: 15,
                                child: Text(
                                  '20-10-2023',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'JetBrains Mono',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 172,
                                top: 14,
                                child: Container(
                                  height: 12,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 15,
                                        top: 0,
                                        child: Text(
                                          'Avi Luca, Tressilla (TN) 38043',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 9,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://via.placeholder.com/12x12"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 21,
                                top: 36,
                                child: Container(
                                  width: 138,
                                  height: 73,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 2,
                                        child: Container(
                                          width: 112,
                                          height: 71,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFD9D9D9)),
                                        ),
                                      ),
                                      Positioned(
                                        left: 116,
                                        top: 0,
                                        child: Text(
                                          '€',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 36,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 119,
                                        top: 40,
                                        child: Text(
                                          'L',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 24,
                                        top: 6,
                                        child: Text(
                                          '78,45',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 36,
                                            fontFamily: 'Seven Segment',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 49,
                                        top: 43,
                                        child: Text(
                                          '45,73',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'Seven Segment',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 194,
                                top: 57,
                                child: Container(
                                  width: 121,
                                  height: 33,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 1,
                                        child: Container(
                                          width: 70,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFD9D9D9)),
                                        ),
                                      ),
                                      Positioned(
                                        left: 7,
                                        top: 3,
                                        child: Text(
                                          '1,845',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'Seven Segment',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 76,
                                        top: 0,
                                        child: Text(
                                          '€/L',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 452,
                        child: Container(
                          width: 361,
                          height: 124,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 361,
                                  height: 124,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 21,
                                top: 15,
                                child: Text(
                                  '20-10-2023',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'JetBrains Mono',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 172,
                                top: 14,
                                child: Container(
                                  height: 12,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 15,
                                        top: 0,
                                        child: Text(
                                          'Avi Luca, Tressilla (TN) 38043',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 9,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://via.placeholder.com/12x12"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 21,
                                top: 36,
                                child: Container(
                                  width: 138,
                                  height: 73,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 2,
                                        child: Container(
                                          width: 112,
                                          height: 71,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFD9D9D9)),
                                        ),
                                      ),
                                      Positioned(
                                        left: 116,
                                        top: 0,
                                        child: Text(
                                          '€',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 36,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 119,
                                        top: 40,
                                        child: Text(
                                          'L',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 24,
                                        top: 6,
                                        child: Text(
                                          '78,45',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 36,
                                            fontFamily: 'Seven Segment',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 49,
                                        top: 43,
                                        child: Text(
                                          '45,73',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'Seven Segment',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 194,
                                top: 57,
                                child: Container(
                                  width: 121,
                                  height: 33,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 1,
                                        child: Container(
                                          width: 70,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFD9D9D9)),
                                        ),
                                      ),
                                      Positioned(
                                        left: 7,
                                        top: 3,
                                        child: Text(
                                          '1,845',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'Seven Segment',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 76,
                                        top: 0,
                                        child: Text(
                                          '€/L',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 596,
                        child: Container(
                          width: 361,
                          height: 124,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 361,
                                  height: 124,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 21,
                                top: 15,
                                child: Text(
                                  '20-10-2023',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'JetBrains Mono',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 172,
                                top: 14,
                                child: Container(
                                  height: 12,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 15,
                                        top: 0,
                                        child: Text(
                                          'Avi Luca, Tressilla (TN) 38043',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 9,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://via.placeholder.com/12x12"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 21,
                                top: 36,
                                child: Container(
                                  width: 138,
                                  height: 73,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 2,
                                        child: Container(
                                          width: 112,
                                          height: 71,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFD9D9D9)),
                                        ),
                                      ),
                                      Positioned(
                                        left: 116,
                                        top: 0,
                                        child: Text(
                                          '€',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 36,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 119,
                                        top: 40,
                                        child: Text(
                                          'L',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 24,
                                        top: 6,
                                        child: Text(
                                          '78,45',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 36,
                                            fontFamily: 'Seven Segment',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 49,
                                        top: 43,
                                        child: Text(
                                          '45,73',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'Seven Segment',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 194,
                                top: 57,
                                child: Container(
                                  width: 121,
                                  height: 33,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 1,
                                        child: Container(
                                          width: 70,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFD9D9D9)),
                                        ),
                                      ),
                                      Positioned(
                                        left: 7,
                                        top: 3,
                                        child: Text(
                                          '1,845',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'Seven Segment',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 76,
                                        top: 0,
                                        child: Text(
                                          '€/L',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'JetBrains Mono',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: -28,
                top: 759,
                child: Opacity(
                  opacity: 0.90,
                  child: Container(
                    width: 429,
                    height: 86,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 447,
                          height: 86,
                          decoration: BoxDecoration(color: Color(0xFF46BD84)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://via.placeholder.com/24x24"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://via.placeholder.com/24x24"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://via.placeholder.com/24x24"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
