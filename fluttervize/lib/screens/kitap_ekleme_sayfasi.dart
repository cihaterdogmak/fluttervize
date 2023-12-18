import 'package:flutter/material.dart';

import '../firebasefirestore.dart';

class KitapEkleSayfasi extends StatefulWidget {
  final String bookName;
  final String writer;
  final String publisher;
  final int pages;
  final int basim_yili;
  final String category;
  final bool isChecked;
  final bool isUpdating;

  KitapEkleSayfasi({
    required this.bookName,
    required this.writer,
    required this.publisher,
    required this.pages,
    required this.category,
    required this.basim_yili,
    required this.isChecked,
    required this.isUpdating,
  });

  @override
  // ignore: no_logic_in_create_state
  _KitapEkleSayfasiState createState() => _KitapEkleSayfasiState(
    bookName_text: bookName,
    writer_text: writer,
    publisher_text: publisher,
    pages_text: pages,
    category_text: category,
    basim_yili_text: basim_yili,
    isUpdating: isUpdating,
  );
}


class _KitapEkleSayfasiState extends State<KitapEkleSayfasi> {
  final bookName = TextEditingController();
  final publisher = TextEditingController();
  final writer = TextEditingController();
  final category = TextEditingController();
  final pages = TextEditingController();
  final basim_yili = TextEditingController();
  
  final String bookName_text;
  final String writer_text;
  final String publisher_text;
  final int pages_text;
  final int basim_yili_text;
  final String category_text;
  final bool isUpdating;
  bool isChecked=false;

  _KitapEkleSayfasiState({
    required this.bookName_text,
    required this.writer_text,
    required this.publisher_text,
    required this.pages_text,
    required this.category_text,
    required this.basim_yili_text,
    required this.isUpdating,
  });
  String? idString;
  @override
  void initState() {
    super.initState();

    // controller'ı başlatın
    bookName.text = bookName_text;
    publisher.text = publisher_text;
    writer.text = writer_text;
    category.text = category_text;
    pages.text = pages_text.toString();
    basim_yili.text = basim_yili_text.toString();
    if (isUpdating){
      idString = idBul().toString();
      print(idString);
    }
    else{
      idString="";
    }
  }

  //async id bulma metodu
  Future<String> idBul() async{
    final Future<String> idFuture = FireStoreService.kitaplar
          .where('ad', isEqualTo: bookName_text)
          .where('publisher', isEqualTo: publisher_text)
          .where('yazarlar', isEqualTo: writer_text)
          .where('category', isEqualTo: category_text)
          .where('pages', isEqualTo: int.parse(pages_text.toString()))
          .where('basim_yili', isEqualTo: int.parse(basim_yili_text.toString()))
          .get()
          .then((value) => value.docs[0].id); 

        idFuture.then((value) => idString = value);
        
        return idString ?? "";
  }
  
  final _fireStoreService = FireStoreService();

  void clearText(){
    bookName.clear();
      publisher.clear();
      writer.clear();
      category.clear();
      pages.clear();
      basim_yili.clear();
      isChecked = false;
  }
  
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Kitap Ekle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: "Kitap Adı",
              ),
              controller: bookName,
              
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Yayınevi",
              ),
              controller: publisher,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "yazarlar",
              ),
              controller: writer,
            ),
            DropdownButtonFormField(
              onChanged: (value) {
                category.text = value.toString();
              },
              items: [
                DropdownMenuItem(
                  child: Text("Roman"),
                  value: "Roman",
                ),
                DropdownMenuItem(
                  child: Text("Tarih"),
                  value: "Tarih",
                ),
                DropdownMenuItem(
                  child: Text("Edebiyat"),
                  value: "Edebiyat",
                ),
                DropdownMenuItem(
                  child: Text("Şiir"),
                  value: "Şiir",
                ),
                DropdownMenuItem(
                  child: Text("Ansiklopedi"),
                  value: "Ansiklopedi",
                ),
                DropdownMenuItem(
                  child: Text("Biyografi"),
                  value: "Biyografi",
                ),
                DropdownMenuItem(
                  child: Text("Sözlük"),
                  value: "Sözlük",
                ),
              ],
              value: "Roman",
              decoration: InputDecoration(
                labelText: "Kategori",
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Sayfa Sayısı",
              ),
              keyboardType: TextInputType.number,
              controller: pages,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Basım Yılı",
              ),
              keyboardType: TextInputType.number,
              controller: basim_yili,
            ),
            CheckboxListTile(
              title: Text("Listede Yayınlanacak mı?"),
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value ?? false;
                });
              },
            ),
            ElevatedButton(
              child: Text("Kaydet"),
              onPressed: () {
                //Kaydet
                if(isUpdating){
                  _fireStoreService.kitapGuncelle(
                    idString ?? "",
                    bookName.text ?? "",
                    publisher.text ?? "",
                    writer.text ?? "",
                    category.text ?? "",
                    int.tryParse(pages.text) ?? 0,
                    int.tryParse(basim_yili.text) ?? 0,
                    isChecked ?? false
                    );
                }
                else{
                  _fireStoreService.kitapEkle(
                    bookName.text ?? "", 
                    publisher.text ?? "",
                    writer.text ?? "",
                    category.text ?? "",
                    int.tryParse(pages.text) ?? 0,
                    int.tryParse(basim_yili.text) ?? 0,
                    isChecked ?? false
                    );
                }
                if(isUpdating){
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Kitap Güncellendi"),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Tamam"),
                        ),
                      ],
                    )
                  );
                }
                else{
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Kitap Kütüphanenize Eklendi"),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Tamam"),
                        ),
                      ],
                    )
                  );
                }
                //Tum alanlari temizle
                clearText();
              },
            ),
          ],
        ),
      ),
    );
  }
}
