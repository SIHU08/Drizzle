import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WifiMarker extends Marker {
  WifiMarker({required String wifiName})
      : super(
          point: LatLng(37.3098433, 127.043537),
          builder: (context) {
            return PopupMenuButton<String>(
              offset: const Offset(0, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    enabled: false,
                    child: Text(
                      wifiName,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    onTap: () {},
                    child: const Text(
                      "연결하기",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ];
              },
              child: const Icon(Icons.wifi),
            );
          },
        );
}

class ToiletMarker extends Marker {
  ToiletMarker({required String name, required LatLng latLng})
      : super(
          point: latLng,
          builder: (context) {
            return PopupMenuButton<String>(
              offset: const Offset(0, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    enabled: false,
                    child: Text(
                      name,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ];
              },
              child: Image.asset("assets/images/toilet.png"),
            );
          },
        );
}
