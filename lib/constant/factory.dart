import 'package:cloud_firestore/cloud_firestore.dart';

class DataPengguna {
  DataPengguna({
    required this.idAkun,
    required this.namaLengkap,
    required this.namaPengguna,
    required this.tipeAkun,
    required this.nomorTelepon,
    required this.alamatLengkap,
    required this.alamatEmail,
    required this.fotoProfil});
  String idAkun, namaLengkap, namaPengguna, tipeAkun, alamatLengkap, nomorTelepon, alamatEmail, fotoProfil;

  factory DataPengguna.fromDocument(DocumentSnapshot doc) {
    String namaLengkap = '', namaPengguna = '', tipeAkun = '', alamatLengkap = '', nomorTelepon = '', alamatEmail = '', fotoProfil = '';
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
    try {
      nomorTelepon = doc.get('nomorTelepon');
    } catch (e) {}
    try {
      alamatEmail = doc.get('alamatEmail');
    } catch (e) {}
    try {
      fotoProfil = doc.get('fotoProfil');
    } catch (e) {}
    return DataPengguna(
        idAkun: doc.id,
        namaLengkap: namaLengkap,
        namaPengguna: namaPengguna,
        tipeAkun: tipeAkun,
        alamatLengkap: alamatLengkap,
        nomorTelepon: nomorTelepon,
        fotoProfil: fotoProfil,
        alamatEmail: alamatEmail);
  }
}