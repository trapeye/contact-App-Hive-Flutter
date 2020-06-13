# Contact App Using Hive

I make a simple contact app for practice using Hive that have CRUD(CREATE, READ, UPDATE, DELETE).

Here simple code to add,read,write and delete, for more information read docs [Hive](https://docs.hivedb.dev/)

`final box = Hive.box('myBox');`

To add
`box.add(value);`

To read
`box.getAt(index);`

To update
`box.putAt('index', 'value');`

To delete
`box.deleteAt('index')`

Feature that this app have:
- Favourite
- [URL_Launcher](https://pub.dev/packages/url_launcher) telephone and email

[Hive](https://docs.hivedb.dev/) is a lightweight and blazing fast key-value database written in pure Dart.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
