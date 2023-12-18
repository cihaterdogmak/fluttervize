import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'kitap_ekleme_sayfasi.dart';
import '../firebasefirestore.dart';


class KitapListesiSayfasi extends StatefulWidget {
  @override
  _KitapListesiSayfasiState createState() => _KitapListesiSayfasiState();
}

class _KitapListesiSayfasiState extends State<KitapListesiSayfasi> {

  final _fireStoreService = FireStoreService();
  Stream<QuerySnapshot> stream = FireStoreService.listede_yayinlanacak_kitaplar.snapshots(); 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cihat Erdoğmak Kütüphane"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(  
            children: snapshot.data!.docs.map((doc) {
              return Card(
                child: ListTile(
                  title: Text(doc['ad']),
                   subtitle: Text('yazar: ${doc['yazarlar']} - Sayfa:${doc['pages']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [ 
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          //Firebase update
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KitapEkleSayfasi(
                                bookName: doc['ad'],
                                publisher: doc['publisher'],
                                writer: doc['yazarlar'],
                                pages: doc['pages'],
                                category: doc['category'],
                                basim_yili: doc['basim_yili'],
                                isChecked: doc['listede_yayinla'],
                                isUpdating: true,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          //Firebase delete
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Kitabı silmek istediğinize emin misiniz?"),
                                actions: [
                                  TextButton(
                                    child: Text("İptal"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Sil"),
                                    onPressed: () {
                                      print(doc.id);
                                      _fireStoreService.kitapSil(
                                        doc.id
                                        );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //Firebase add
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KitapEkleSayfasi(
                bookName: "",
                publisher: "",
                writer: "",
                pages: 0,
                category: "Roman",
                basim_yili: 0,
                isChecked: true,
                isUpdating: false,
              ),
            ),
          );
        },
      ),
    );
  }
}
