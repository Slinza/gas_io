import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isEditable = false;
  String userName = 'Username';
  String carBrand = 'Brand';
  String carModel = 'Model';
  String profilePic =
      'https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/10/free-images.jpg';

  void toggleEditable() {
    setState(() {
      isEditable = !isEditable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              isEditable ? Icons.save : Icons.edit,
              color: Colors.white,
            ),
            onPressed: toggleEditable,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(profilePic),
                  ),
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 1.0,
                            blurRadius: 2.0,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          isEditable ? Icons.save : Icons.edit,
                          color: Colors.white,
                          size: 16.0,
                        ),
                        onPressed: toggleEditable,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            // Text(
            //   'Name',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            SizedBox(height: 8.0),
            TextField(
              enabled: isEditable,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: userName,
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  userName = value;
                });
              },
            ),

            SizedBox(height: 24.0),
            Text(
              'Selected Car',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextField(
              enabled: isEditable,
              decoration: InputDecoration(
                hintText: carBrand,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  carModel = value;
                });
              },
            ),
            SizedBox(height: 8.0),
            TextField(
              enabled: isEditable,
              decoration: InputDecoration(
                hintText: carModel,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  carModel = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// class User {
//   String name;
//   String email;
//   String profilePicture;

//   User({required this.name, required this.email, required this.profilePicture});
// }

// class Car {
//   String make;
//   String model;
//   String image;

//   Car({required this.make, required this.model, required this.image});
// }

// class UserScreen extends StatefulWidget {
//   @override
//   _UserScreenState createState() => _UserScreenState();
// }

// class _UserScreenState extends State<UserScreen> {
//   final _userFormKey = GlobalKey<FormState>();
//   final _carFormKey = GlobalKey<FormState>();

//   User _user = User(
//       name: 'John Doe',
//       email: 'john.doe@example.com',
//       profilePicture:
//           'https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/10/free-images.jpg');
//   Car _car = Car(
//       make: 'Toyota',
//       model: 'Camry',
//       image:
//           'https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/10/free-images.jpg');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Center(
//               child: CircleAvatar(
//                 radius: 50.0,
//                 backgroundImage: NetworkImage(_user.profilePicture),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Form(
//               key: _userFormKey,
//               child: Column(
//                 children: [
//                   Text(_user.name)
//                   // TextFormField(
//                   //   initialValue: _user.name,
//                   //   decoration: InputDecoration(labelText: 'Name'),
//                   //   validator: (value) {
//                   //     if (value == null || value.isEmpty) {
//                   //       return 'Please enter your name';
//                   //     }
//                   //     return null;
//                   //   },
//                   //   onSaved: (value) {
//                   //     setState(() {
//                   //       _user = User(
//                   //           name: value!,
//                   //           email: _user.email,
//                   //           profilePicture: _user.profilePicture);
//                   //     });
//                   //   },
//                   // ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 32.0),
//             Image.network(_car.image, height: 200.0),
//             SizedBox(height: 16.0),
//             Form(
//               key: _carFormKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     initialValue: _car.make,
//                     decoration: InputDecoration(labelText: 'Car Make'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the car make';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       setState(() {
//                         _car = Car(
//                             make: value!, model: _car.model, image: _car.image);
//                       });
//                     },
//                   ),
//                   SizedBox(height: 16.0),
//                   TextFormField(
//                     initialValue: _car.model,
//                     decoration: InputDecoration(labelText: 'Car Model'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the car model';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       setState(() {
//                         _car = Car(
//                             make: _car.make, model: value!, image: _car.image);
//                       });
//                     },
//                   ),
//                   SizedBox(height: 16.0),
//                   TextFormField(
//                     initialValue: _car.image,
//                     decoration: InputDecoration(labelText: 'Car Image URL'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a car image URL';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       setState(() {
//                         _car = Car(
//                             make: _car.make, model: _car.model, image: value!);
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 32.0),
//             ElevatedButton(
//               onPressed: () {
//                 if (_userFormKey.currentState!.validate() &&
//                     _carFormKey.currentState!.validate()) {
//                   _userFormKey.currentState!.save();
//                   _carFormKey.currentState!.save();
//                 }
//               },
//               child: Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
