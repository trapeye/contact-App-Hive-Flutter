import 'dart:convert';

import 'package:contactmanagerapp/Hive/contact.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileContact extends StatefulWidget {
  int index;
  ProfileContact({this.index});

  @override
  _ProfileContactState createState() => _ProfileContactState();
}

class _ProfileContactState extends State<ProfileContact> {
  final contact = Hive.box('contacts');

  _launchCaller(telephone) async {
    var url = "tel:$telephone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchMailClient(String email) async {
    var mailUrl = 'mailto:$email?subject=Hai $email';
    try {
      await launch(mailUrl);
    } catch (e) {
      throw 'Could not launch $mailUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactBox = contact.getAt(widget.index) as Contact;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'floatingButton',
        onPressed: () {},
        backgroundColor: Colors.pinkAccent,
        child: Icon(Icons.edit),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'Picture${widget.index}',
              child: ClipOval(
                child: Material(
                  color: Colors.redAccent,
                  child: SizedBox(
                      width: 150,
                      height: 150,
                      child: contactBox.picture == null
                          ? Icon(
                              Icons.camera_alt,
                              size: 90,
                            )
                          : Image.memory(
                              Base64Decoder().convert(contactBox.picture),
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                            )),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Hero(
              tag: 'NameText${widget.index}',
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: '${contactBox.firstName}',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        )),
                    TextSpan(
                        text: ' ${contactBox.lastName}',
                        style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '${contactBox.email}',
              style: TextStyle(fontSize: 17),
            ),
            Divider(
              color: Colors.grey,
              height: 60.0,
              endIndent: 30,
              indent: 30,
            ),
            Text(
              '${contactBox.telephone}',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.phone,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    _launchCaller(contactBox.telephone);
                  },
                ),
                SizedBox(
                  width: 10.0,
                ),
                IconButton(
                  icon: Icon(
                    Icons.email,
                    color: Colors.pink,
                  ),
                  onPressed: () {
                    launchMailClient(contactBox.email);
                  },
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
              height: 60.0,
              endIndent: 30,
              indent: 30,
            ),
          ],
        ),
      ),
    );
  }
}
