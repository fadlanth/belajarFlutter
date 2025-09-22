import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final biodata = <String, String>{};

  MainApp({super.key});{
    biodata['name'] = 'Jumbo (Don)';
    biodata['email'] = 'don@gmail.com';
    biodata['phone'] = '089123456789';
    biodata['image'] = 'Jumbo-Don.jpg';
    biodata['hobby'] = 'Nyanyi dan Bermain';
    biodata['addr'] = 'Jln. Merdeka di ujung jalan';
    biodata['desc'] = '''Ia sering diejek teman-temannya dan dijuluki "Jumbo". Ia mencari pelarian dan kekuatan dalam buku dongeng peninggalan orang tuanya, yang membuatnya merasa sangat terhubung dengan dunia cerita tersebut.  '''
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aplikasi Biodata",
      home: Scaffold(
        appBar: AppBar(title: const Text("Aplikasi Biodata)),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(mainaAxisAlignment: MainAxisAligment.start, children: [
           Container(
           padding: EdgeInsets.all(10),
           alignment: Alignment.center,
           width: double.infinity,
           decoration: BoxDecoration(color: Color.black),
           child: Text(biodata['nama']!),
           )
          ]),
        ),
      ),
    );
  }
}
