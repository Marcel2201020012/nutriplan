import 'package:hive/hive.dart';

part 'data_historis.g.dart';

@HiveType(typeId: 0)
class DataHistoris extends HiveObject {
  @HiveField(0)
  List<Map<String, dynamic>> daftarMakanan;

  @HiveField(1)
  double totalKalori;

  @HiveField(2)
  double kalori;

  DataHistoris({
    required this.daftarMakanan,
    required this.totalKalori,
    required this.kalori,
  });
}
