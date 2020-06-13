import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:contactmanagerapp/Hive/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'AddContact.dart';
import 'ProfileContact.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<Widget> tabWidgets = <Widget>[
    ContactList(),
    FavouriteContact(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Contacts'),
      ),
      body: tabWidgets.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        heroTag: 'floatingButton',
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddContact()));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text('All'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Favorites'),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index)),
    );
  }
}

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  Box<Contact> favoriteBox;

  @override
  void initState() {
    super.initState();
    favoriteBox = Hive.box('favoritesBox');
  }

  final contactsBox = Hive.box('contacts');

  void onFavoritePress(int index) {
    if (favoriteBox.containsKey(index)) {
      favoriteBox.delete(index);
      return;
    }
    favoriteBox.put(index, contactsBox.getAt(index));
  }

  Widget favourite(int index) {
    if (favoriteBox.containsKey(index)) {
      return Icon(Icons.favorite, color: Colors.red);
    }
    return Icon(Icons.favorite_border);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
          valueListenable: Hive.box('contacts').listenable(),
          builder: (context, contact, widget) {
            return ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                      height: 10,
                    ),
                itemCount: contact.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final contactBox = contact.getAt(index) as Contact;

                  String telephone = StringUtils.addCharAtPosition(
                      '${contactBox.telephone}', " - ", 3);

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileContact(
                                    index: index,
                                  )));
                    },
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: Ink(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          leading: Hero(
                            tag: 'Picture$index',
                            child: ClipOval(
                              child: Material(
                                color: Colors.redAccent,
                                child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: contactBox.picture == null
                                        ? Icon(
                                            Icons.camera_alt,
                                            size: 30,
                                          )
                                        : Image.memory(
                                            Base64Decoder()
                                                .convert(contactBox.picture),
                                            fit: BoxFit.cover,
                                            gaplessPlayback: true,
                                          )),
                              ),
                            ),
                          ),
                          title: Hero(
                            tag: 'NameText$index',
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '${contactBox.firstName}',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      )),
                                  TextSpan(
                                      text: '  ${contactBox.lastName}',
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          subtitle: Text('$telephone',
                              style: TextStyle(fontSize: 25)),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                onFavoritePress(index);
                              });
                            },
                            icon: favourite(index),
                          ),
                        ),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.redAccent,
                          icon: Icons.delete,
                          onTap: () {
                            contact.deleteAt(index);
                          },
                        ),
                      ],
                    ),
                  );
                });
          },
        ));
  }
}

class FavouriteContact extends StatefulWidget {
  @override
  _FavouriteContactState createState() => _FavouriteContactState();
}

class _FavouriteContactState extends State<FavouriteContact> {
  Box<Contact> favoriteBox;
  final contactsBox = Hive.box('contacts');

  List<Contact> contactList = [];

  void favouriteContactList() {
    contactList.clear();
    for (int i = 0; i < contactsBox.length; i++) {
      if (favoriteBox.containsKey(i)) {
        print(contactsBox.getAt(i).telephone);
        contactList.add(contactsBox.getAt(i));
      }
    }
  }

  @override
  void initState() {
    favoriteBox = Hive.box('favoritesBox');
    favouriteContactList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 10,
        ),
        itemCount: contactList.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          String telephone = StringUtils.addCharAtPosition(
              '${contactList[index].telephone}', " - ", 3);

          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileContact(
                            index: index,
                          ))).then((value) {
                setState(() {
                  favouriteContactList();
                });
              });
            },
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Ink(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  leading: Hero(
                    tag: 'Picture$index',
                    child: ClipOval(
                      child: Material(
                        color: Colors.redAccent,
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: contactList[index].picture == null
                                ? Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                  )
                                : Image.memory(
                                    Base64Decoder()
                                        .convert(contactList[index].picture),
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  )),
                      ),
                    ),
                  ),
                  title: Hero(
                    tag: 'NameText$index',
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: '${contactList[index].firstName}',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                          TextSpan(
                              text: '  ${contactList[index].lastName}',
                              style: TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              )),
                        ],
                      ),
                    ),
                  ),
                  subtitle: Text('$telephone', style: TextStyle(fontSize: 25)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
