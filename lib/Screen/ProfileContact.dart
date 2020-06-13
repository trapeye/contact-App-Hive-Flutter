import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:contactmanagerapp/Hive/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileContact extends StatefulWidget {
  final int index;
  ProfileContact({this.index});

  @override
  _ProfileContactState createState() => _ProfileContactState();
}

class _ProfileContactState extends State<ProfileContact> {
  final _formKey = GlobalKey<FormState>();

  final contact = Hive.box('contacts');

  String firstName;
  String lastName;
  String phone;
  String email;
  String picture;
  bool _validate = false;

  void transferData() {
    final contactBox = contact.getAt(widget.index) as Contact;

    firstName = contactBox.firstName;
    lastName = contactBox.lastName;
    phone = contactBox.telephone;
    email = contactBox.email;
    picture = contactBox.picture;
  }

  @override
  void initState() {
    super.initState();
    transferData();
  }

  _launchCaller(telephone) async {
    var url = "tel:$telephone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchMailClient(String email) async {
    var mailUrl = 'mailto:$email?subject=Hai $email';
    try {
      await launch(mailUrl);
    } catch (e) {
      throw 'Could not launch $mailUrl';
    }
  }

  bool edit = false;

  void editTrueFalse() {
    if (edit == true) {
      setState(() {
        edit = false;
      });
    } else {
      setState(() {
        edit = true;
      });
    }
  }

  Future<void> getImage() async {
    var image2 = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxHeight: 400,
        maxWidth: 400,
        imageQuality: 50);
    List<int> imageBytes = await image2.readAsBytes();
    setState(() {
      picture = base64Encode(imageBytes);
    });
  }

  void editContact(Contact contact) {
    final contactBox = Hive.box('contacts');
    contactBox.putAt(widget.index, contact);
  }

  String validateMobile(String value) {
    if (value.length != 10)
      return 'Mobile Number must be 10 digit';
    else
      return null;
  }

  String validateName(String value) {
    if (value.length < 1)
      return 'Can\t be empty';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: edit
          ? AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: () {
                  editTrueFalse();
                },
              ),
              centerTitle: true,
              title: Text('Edit'),
            )
          : AppBar(
              centerTitle: true,
              title: Text('Contact Detail'),
            ),
      floatingActionButton: edit
          ? FloatingActionButton(
              heroTag: 'floatingButton',
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  final contact = Contact(
                      firstName: firstName,
                      lastName: lastName,
                      picture: picture,
                      email: email,
                      telephone: phone);
                  editContact(contact);

                  editTrueFalse();
                } else {
                  setState(() {
                    _validate = true;
                  });
                }
              },
              backgroundColor: Colors.pinkAccent,
              child: Icon(Icons.save),
            )
          : FloatingActionButton(
              heroTag: 'floatingButton',
              onPressed: () {
                editTrueFalse();
              },
              backgroundColor: Colors.pinkAccent,
              child: Icon(Icons.edit),
            ),
      body: edit
          ? Form(
              key: _formKey,
              autovalidate: _validate,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipOval(
                        child: InkWell(
                          onTap: getImage,
                          child: Material(
                            color: Colors.redAccent,
                            child: SizedBox(
                                width: 150,
                                height: 150,
                                child: picture == null
                                    ? Icon(
                                        Icons.camera_alt,
                                        size: 90,
                                      )
                                    : Image.memory(
                                        Base64Decoder().convert(picture),
                                        fit: BoxFit.cover,
                                        gaplessPlayback: true,
                                      )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                initialValue: firstName,
                                textAlign: TextAlign.center,
                                validator: validateName,
                                maxLength: 20,
                                onSaved: (value) => firstName = value,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    counterText: '',
                                    labelText: 'First Name',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    hintText: 'Kassim',
                                    errorStyle: TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                  initialValue: lastName,
                                  textAlign: TextAlign.center,
                                  validator: validateName,
                                  maxLength: 20,
                                  onSaved: (value) => lastName = value,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                      counterText: '',
                                      labelText: 'Last Name',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      hintText: 'Hanif',
                                      errorStyle: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextFormField(
                          initialValue: email,
                          textAlign: TextAlign.center,
                          validator: validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          maxLength: 20,
                          onSaved: (value) => email = value,
                          textCapitalization: TextCapitalization.sentences,
                          autocorrect: false,
                          decoration: InputDecoration(
                              counterText: '',
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0)),
                              hintText: 'example@gmail.com',
                              errorStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 60.0,
                        endIndent: 30,
                        indent: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: TextFormField(
                          initialValue: phone,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          validator: validateMobile,
                          maxLength: 10,
                          onSaved: (value) => phone = value,
                          textCapitalization: TextCapitalization.sentences,
                          autocorrect: false,
                          decoration: InputDecoration(
                              counterText: '',
                              labelText: 'Tel No.',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0)),
                              hintText: '018 - 788 1060',
                              errorStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
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
              ),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: '$picture',
                      child: ClipOval(
                        child: Material(
                          color: Colors.redAccent,
                          child: SizedBox(
                              width: 150,
                              height: 150,
                              child: picture == null
                                  ? Icon(
                                      Icons.camera_alt,
                                      size: 90,
                                    )
                                  : Image.memory(
                                      Base64Decoder().convert(picture),
                                      fit: BoxFit.cover,
                                      gaplessPlayback: true,
                                    )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: '$firstName',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              )),
                          TextSpan(
                              text: ' $lastName',
                              style: TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.w600,
                                fontSize: 25,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '$email',
                      style: TextStyle(fontSize: 17),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 60.0,
                      endIndent: 30,
                      indent: 30,
                    ),
                    Text(
                      '${StringUtils.addCharAtPosition('$phone', " - ", 3)}',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                            _launchCaller(phone);
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
                            _launchMailClient(email);
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
            ),
    );
  }
}
