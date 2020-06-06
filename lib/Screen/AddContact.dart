import 'dart:convert';

import 'package:contactmanagerapp/Hive/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String firstName;

  String lastName;

  String telephone;

  String email;
  String picture;

  bool _validate = false;

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

  void buttonPressed() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      addContact();

      Navigator.pop(context);
    } else {
      setState(() {
        _validate = true;
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

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  void addContact() {
    final newContact = Contact(
        firstName: firstName,
        lastName: lastName,
        picture: picture,
        email: email,
        telephone: telephone);
    print('hi');
    final contactsBox = Hive.box('contacts');
    contactsBox.add(newContact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.close),
        ),
        title: Text('Add Contacts'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidate: _validate,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.redAccent,
                      child: InkWell(
                        child: SizedBox(
                            width: 120,
                            height: 120,
                            child: picture == null
                                ? Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                  )
                                : Image.memory(
                                    Base64Decoder().convert(picture),
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  )),
                        onTap: getImage,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            validator: validateName,
                            maxLength: 20,
                            onSaved: (value) => firstName = value,
                            textCapitalization: TextCapitalization.sentences,
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
                                hintStyle: TextStyle(color: Colors.grey[400])),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            validator: validateName,
                            maxLength: 20,
                            onSaved: (value) => lastName = value,
                            textCapitalization: TextCapitalization.sentences,
                            autocorrect: false,
                            decoration: InputDecoration(
                                counterText: '',
                                labelText: 'Last Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                hintText: 'Hanif',
                                errorStyle: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                                hintStyle: TextStyle(color: Colors.grey[400])),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    validator: validateMobile,
                    maxLength: 10,
                    onChanged: (value) => telephone = value,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 12.0),
                  child: ButtonTheme(
                    minWidth: 200.0,
                    height: 50,
                    child: RaisedButton(
                      color: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.red)),
                      onPressed: () {
                        buttonPressed();
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
