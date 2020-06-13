# Contact App Using Hive

I make a simple contact app for practice using Hive that has CRUD(CREATE, READ, UPDATE, DELETE).

Here simple code to add,read,write and delete, for more information read docs [Hive](https://docs.hivedb.dev/)

```javascript
final box = Hive.box('myBox');
```

To add

```dart
box.add(value);
```

To read
```dart
box.getAt(index);
```

To update
```dart
box.putAt(index, value);
```

To delete
```dart
box.deleteAt(index);
```

The feature that this app have:
- [Image Picker](https://pub.dev/packages/image_picker)
- CRUD contact
- Favourite
- [URL_Launcher](https://pub.dev/packages/url_launcher) telephone and email

![addContact](https://github.com/trapeye/contact-App-Hive-Flutter/blob/master/screesnshot/addContact.png)![ContactDetail](https://github.com/trapeye/contact-App-Hive-Flutter/blob/master/screesnshot/contactDetail.png)![contactHomePage](https://github.com/trapeye/contact-App-Hive-Flutter/blob/master/screesnshot/contactHomePage.png)![editContact](https://github.com/trapeye/contact-App-Hive-Flutter/blob/master/screesnshot/editContact.png)![FavouriteContact](https://github.com/trapeye/contact-App-Hive-Flutter/blob/master/screesnshot/favouriteContact.png)

[Hive](https://docs.hivedb.dev/) is a lightweight and blazing fast key-value database written in pure Dart.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
