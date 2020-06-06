import 'dart:convert';

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
  Icon searchIcon = Icon(Icons.search);
  Widget title = Text('Contacts');
  bool searching = false;
  final _cSearch = TextEditingController();

  static List<Widget> tabWidgets = <Widget>[
    ContactList(),
    ContactList(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: <Widget>[
          IconButton(
            icon: searchIcon,
            onPressed: () {
              setState(() {
                if (searchIcon.icon == Icons.search) {
                  searchIcon = Icon(Icons.close);
                  title = TextField(
                    controller: _cSearch,
                    autofocus: true,
                    onChanged: (value) {
                      searching = true;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        hintText: "Search Contact",
                        hintStyle: TextStyle(color: Colors.white)),
                  );
                } else {
                  _cSearch.clear();
                  searching = false;
                  searchIcon = Icon(
                    Icons.search,
                  );
                  title = Text("Contacts");
                }
              });
            },
          )
        ],
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
  Icon favourite = Icon(
    Icons.favorite_border,
  );

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
                          subtitle: Text('${contactBox.telephone}',
                              style: TextStyle(fontSize: 25)),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                favourite = Icon(
                                  Icons.favorite,
                                  color: Colors.redAccent,
                                );
                              });
                            },
                            icon: favourite,
                          ),
                        ),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Edit',
                          color: Colors.blue,
                          icon: Icons.edit,
                          onTap: () {},
                        ),
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
