import 'package:flutter/material.dart';
import 'package:flutter_packages/sqflite/database_helper.dart';
import 'package:flutter_packages/sqflite/user_model.dart';

/*
var data = await rootBundle.load(join('assets','para.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
 */

class SqflitePage extends StatefulWidget {
  const SqflitePage({Key? key}) : super(key: key);

  @override
  _SqflitePageState createState() => _SqflitePageState();
}

class _SqflitePageState extends State<SqflitePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sqflite'),
        actions: [
          IconButton(
              onPressed: () async {
                await DatabaseHelper.instance.addUser().then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(Icons.add_circle_outline_outlined))
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
          future: DatabaseHelper.instance.getUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('Veriler Hala geliyor'),
              );
            } else {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Veriler Boş'),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => ListTile(
                    trailing: IconButton(
                        onPressed: () async {
                          await DatabaseHelper.instance
                              .deleteUser(snapshot.data![index].id);
                          setState(() {});
                        },
                        icon: const Icon(Icons.delete)),
                    leading: IconButton(
                        onPressed: () async {
                          await DatabaseHelper.instance
                              .updateUser(snapshot.data![index].id);
                          setState(() {});
                        },
                        icon: const Icon(Icons.edit)),
                    title: Text(snapshot.data![index].name),
                  ),
                );
              }
            }
          }),
    );
  }
}
