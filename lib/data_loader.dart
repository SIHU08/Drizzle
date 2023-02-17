import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class Toilet {
  String name;
  LatLng latLng;

  Toilet(this.name, this.latLng);
}

Future<List<Toilet>> getToilets() async {
  List<Toilet> res = [];

  final dio = Dio();
  final response = await dio.get(
    'https://openapi.gg.go.kr/Publtolt?KEY=3eba534f243e46e09eae53d092e7cf1c&type=json&pSize=1',
  );
  int listTotalCount =
      jsonDecode(response.data)["Publtolt"][0]["head"][0]["list_total_count"];

  for (int i = 1; i <= (listTotalCount / 1000).ceil(); i++) {
    final response = await dio.get(
      'https://openapi.gg.go.kr/Publtolt?KEY=3eba534f243e46e09eae53d092e7cf1c&type=json&pSize=1000&pIndex=$i',
    );

    final data = jsonDecode(response.data);
    for (final obj in data["Publtolt"][1]["row"]) {
      final latStr = obj["REFINE_WGS84_LAT"], lngStr = obj["REFINE_WGS84_LOGT"];
      if (latStr == null || lngStr == null) continue;
      String name = obj["PBCTLT_PLC_NM"];
      double lat = double.parse(latStr);
      double lng = double.parse(lngStr);
      res.add(Toilet(name, LatLng(lat, lng)));
    }
  }

  return res;
}
