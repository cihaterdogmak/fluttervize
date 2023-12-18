import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService{

  //Kitaplari geitiren stream
  static final kitaplar = FirebaseFirestore.instance.collection('kitaplar');
  static final listede_yayinlanacak_kitaplar = kitaplar.where('listede_yayinla', isEqualTo: true);

  Future<void> kitapEkle(String ad, String yayin_evi,String yazarlarim, String kategori, int sayfa_sayisi, int basim_yili, bool listede_yayinla) async {
    return await kitaplar
        .add({
          'ad': ad,
          'publisher': yayin_evi,
          'yazarlar':yazarlarim,
          'category': kategori,
          'pages': sayfa_sayisi,
          'basim_yili': basim_yili,
          'listede_yayinla': listede_yayinla,
          'id': FieldValue.increment(1) // Her kitap için ID'yi 1 artır
        })
        .then((value) => print("Kitap Eklendi"))
        .catchError((error) => print("Kitap Eklenemedi: $error"));
  }

  Future<void> kitapGuncelle(String id, String ad, String yayin_evi, String yazarlarim, String kategori, int sayfa_sayisi, int basim_yili, bool listede_yayinla) async {
    if (id == ""){
      print("id boş");
      return null;
    }
    return await kitaplar
        .doc(id)
        .update({
          'ad': ad,
          'publisher': yayin_evi,
          'yazarlar':yazarlarim,
          'category ': kategori,
          'pages': sayfa_sayisi,
          'basim_yili': basim_yili,
          'listede_yayinla': listede_yayinla,
        })
        .then((value) => print("Kitap Güncellendi"))
        .catchError((error) => print("Kitap Güncellenemedi: $error"));
  }
  Future<void> kitapSil(String id) async {
    return await kitaplar
        .doc(id)
        .delete()
        .then((value) => print("Kitap Silindi"))
        .catchError((error) => print("Kitap Silinemedi: $error"));
  }
}