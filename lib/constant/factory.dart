import 'package:cloud_firestore/cloud_firestore.dart';

class DataPengguna {
  DataPengguna({
    required this.idAkun,
    required this.namaLengkap,
    required this.namaPengguna,
    required this.tipeAkun,
    required this.alamatLengkap});
  String idAkun, namaLengkap, namaPengguna, tipeAkun, alamatLengkap;

  factory DataPengguna.fromDocument(DocumentSnapshot doc) {
    String namaLengkap = '', namaPengguna = '', tipeAkun = '', alamatLengkap = '';
    try {
      namaLengkap = doc.get('namaLengkap');
    } catch (e) {}
    try {
      namaPengguna = doc.get('namaPengguna');
    } catch (e) {}
    try {
      alamatLengkap = doc.get('alamatLengkap');
    } catch (e) {}
    try {
      tipeAkun = doc.get('tipeAkun');
    } catch (e) {}
    return DataPengguna(
        idAkun: doc.id,
        namaLengkap: namaLengkap,
        namaPengguna: namaPengguna,
        tipeAkun: tipeAkun,
        alamatLengkap: alamatLengkap);
  }
}