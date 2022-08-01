import 'package:cloud_firestore/cloud_firestore.dart';

class DataPengguna
{
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

class DataPesanan
{
  DataPesanan({
    required this.namaProduk,
    required this.idProduk,
    required this.imageUrl,
    required this.idPemesan,
    required this.jumlahItem,
    required this.nomorTelepon,
    required this.tanggalPemesanan,
    required this.namaPemesan,
    required this.alamatPengiriman,
    required this.statusPesanan,
    required this.totalHarga,
    required this.resiPengiriman,
    required this.tanggalPengiriman,
    required this.idPesanan});

  final String idPesanan, namaProduk, imageUrl, idPemesan, namaPemesan, alamatPengiriman, nomorTelepon, statusPesanan, idProduk;
  final int jumlahItem, totalHarga;
  DateTime tanggalPemesanan;
  DateTime? tanggalPengiriman;
  String? resiPengiriman;

  factory DataPesanan.fromDocument(DocumentSnapshot doc) {
    String namaProduk = '', idProduk = '', imageUrl = '', idPemesan = '', namaPemesan = '', alamatPengiriman = '', nomorTelepon = '', statusPesanan = '';
    int jumlahItem = 0, totalHarga = 0;
    DateTime tanggalPemesanan = DateTime.now();
    DateTime? tanggalPengiriman;
    String? resiPengiriman;

    try
    {
      namaProduk = doc.get('nama_produk');
    }
    catch(e){}
    try
    {
      imageUrl = doc.get('image_url');
    }
    catch(e){}
    try
    {
      idPemesan = doc.get('id_pemesan');
    }
    catch(e){}
    try
    {
      jumlahItem = doc.get('jumlah_item');
    }
    catch(e){}
    try
    {
      namaPemesan = doc.get('nama_pemesan');
    }
    catch(e){}
    try
    {
      alamatPengiriman = doc.get('alamat_pengiriman');
    }
    catch(e){}
    try
    {
      nomorTelepon = doc.get('nomor_telepon');
    }
    catch(e){}
    try
    {
      statusPesanan = doc.get('status_pesanan');
    }
    catch(e){}
    try
    {
      totalHarga = doc.get('total_harga');
    }
    catch(e){}
    try
    {
      tanggalPemesanan = DateTime.parse(doc.get('tanggal_pemesanan'));
    }
    catch(e){}
    try
    {
      resiPengiriman = doc.get('resi_pengiriman');
    }
    catch(e){}
    try
    {
      tanggalPengiriman = DateTime.parse(doc.get('tanggal_pengiriman'));
    }
    catch(e){}
    try
    {
      idProduk = doc.get('id_produk');
    }
    catch(e){}

    return DataPesanan(
        idPesanan: doc.id,
        namaProduk: namaProduk,
        imageUrl: imageUrl,
        idPemesan: idPemesan,
        jumlahItem: jumlahItem,
        nomorTelepon: nomorTelepon,
        tanggalPemesanan: tanggalPemesanan,
        namaPemesan: namaPemesan,
        alamatPengiriman: alamatPengiriman,
        statusPesanan: statusPesanan,
        totalHarga: totalHarga,
        tanggalPengiriman: tanggalPengiriman,
        resiPengiriman: resiPengiriman,
        idProduk: idProduk);
  }
}

class DataLaporan
{
  DataLaporan({
    required this.id,
    required this.totalPesanan,
    required this.namaProduk,
    required this.resiPengiriman,
    required this.namaPemesan,
    required this.totalPembayaran,
    required this.tanggalPemesanan,
    required this.tanggalPembayaran});

  final String id, namaPemesan, resiPengiriman, namaProduk;
  final int totalPembayaran, totalPesanan;
  final DateTime tanggalPemesanan, tanggalPembayaran;

  factory DataLaporan.fromDocument(DocumentSnapshot doc)
  {
    String namaPemesan = '', resiPengiriman = '', namaProduk = '';
    int totalPembayaran = 0, totalPesanan = 0;
    DateTime tanggalPemesanan = DateTime.now(), tanggalPembayaran = DateTime.now();

    try
    {
      namaPemesan = doc.get('nama_pemesan');
    }
    catch(e){}
    try
    {
      namaProduk = doc.get('nama_produk');
    }
    catch(e){}
    try
    {
      totalPembayaran = doc.get('total_pembayaran');
    }
    catch(e){}
    try
    {
      totalPesanan = doc.get('total_pesanan');
    }
    catch(e){}
    try
    {
      tanggalPemesanan = DateTime.parse(doc.get('tanggal_pemesanan'));
    }
    catch(e){}
    try
    {
      tanggalPembayaran = DateTime.parse(doc.get('tanggal_pembayaran'));
    }
    catch(e){}
    try
    {
      resiPengiriman = doc.get('resi_pengiriman');
    }
    catch(e){}

    return DataLaporan(
        id: doc.id,
        totalPesanan: totalPesanan,
        namaProduk: namaProduk,
        namaPemesan: namaPemesan,
        totalPembayaran: totalPembayaran,
        tanggalPemesanan: tanggalPemesanan,
        tanggalPembayaran: tanggalPembayaran,
        resiPengiriman: resiPengiriman);
  }
}