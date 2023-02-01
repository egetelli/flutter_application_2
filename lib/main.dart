import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.red,
      accentColor: Colors.cyan,
    ),
    home: MyApp(),
  ));
}

class Urunler {
  late String ad1, id1, kategori1;
  late double fiyat1;
  Urunler(
      {required this.ad1,
      required this.id1,
      required this.kategori1,
      required this.fiyat1});

  Map<String, dynamic> getUrunler() {
    return {
      "ad1": ad1,
      "id1": id1,
      "kategori1": kategori1,
      "fiyat1": fiyat1,
    };
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String ad, id, kategori;
  late double fiyat;

  CollectionReference _refUrun =
      FirebaseFirestore.instance.collection('UrunlerFlutter');

  urunAdiAl(urunAdi) {
    this.ad = urunAdi;
  }

  urunIdsiAl(urunIdsi) {
    this.id = urunIdsi;
  }

  urunKategorisiAl(urunKategorisi) {
    this.kategori = urunKategorisi;
  }

  urunFiyatiAl(urunFiyati) {
    this.fiyat = double.parse(urunFiyati);
  }

  Future veriEkle(
      {required String ad,
      required String id,
      required String kategori,
      required double fiyat}) async {
    Random random = Random();
    int _randomNumber = random.nextInt(100000);
    final ekleme =
        FirebaseFirestore.instance.collection('UrunlerFlutter').doc('$id');

    final json = {
      'ad': ad,
      'id': id,
      'kategori': kategori,
      'fiyat': fiyat,
    };
    await ekleme.set(json);

    print("Eklendi");
  }

  veriOku() async {
    _refUrun.get();
    _refUrun.snapshots();
    print("Okundu");
  }

  veriGuncelle(
      {required String ad,
      required String id,
      required String kategori,
      required double fiyat}) {
    final json = {
      'ad': ad,
      'id': id,
      'kategori': kategori,
      'fiyat': fiyat,
    };

    FirebaseFirestore.instance
        .collection('UrunlerFlutter')
        .doc('$id')
        .update(json);
    print("Güncellendi");
  }

  Future veriSil({required String id}) async {
    var collection = FirebaseFirestore.instance.collection('UrunlerFlutter');
    await collection.doc(id).delete();
    print("Silindi");
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> dataStream =
        FirebaseFirestore.instance.collection('UrunlerFlutter').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ürün Envanteri",
          style: TextStyle(color: Color.fromARGB(255, 53, 29, 117)),
        ),
        backgroundColor: Colors.amber[600],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Ürün Adı",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 53, 29, 117),
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (String urunAdi) {
                    urunAdiAl(urunAdi);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Ürün Id",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 53, 29, 117),
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (String urunIdsi) {
                    urunIdsiAl(urunIdsi);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Ürün Kategorisi",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 53, 29, 117),
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (String urunKategorisi) {
                    urunKategorisiAl(urunKategorisi);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Ürün Fiyatı",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 53, 29, 117),
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (String urunFiyati) {
                    urunFiyatiAl(urunFiyati);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        veriEkle(
                            ad: ad, id: id, kategori: kategori, fiyat: fiyat);
                      },
                      child: Text("  Ekle  "),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan[600],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        veriOku();
                      },
                      child: Text("   Oku   "),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        veriGuncelle(
                            ad: ad, id: id, kategori: kategori, fiyat: fiyat);
                      },
                      child: Text("Güncelle"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        veriSil(id: id);
                      },
                      child: Text("   Sil   "),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 48, 8, 226),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                    )
                  ],
                ),
              ),
              // FirestoreAnimatedGrid(
              //     query: query, itemBuilder: itemBuilder, crossAxisCount: 2)
              Container(
                  height: 250,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: dataStream,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong.');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading');
                      }
                      final data = snapshot.requireData;

                      return ListView.builder(
                        itemCount: data.size,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              height: 50,
                              color: Colors.amber[600],
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      style: const TextStyle(
                                          fontFamily: "Lato",
                                          fontSize: 13,
                                          color:
                                              Color.fromARGB(255, 53, 29, 117)),
                                      'Ürün Adı: ${data.docs[index]['ad']} , Ürün Idsi: ${data.docs[index]['id']}, Ürün Kategorisi: ${data.docs[index]['kategori']}, Ürün Fiyatı: ${data.docs[index]['fiyat']}'),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
