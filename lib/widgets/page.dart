import 'dart:typed_data';

import 'package:drizzle/widgets/markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import '../data_loader.dart';

class ZenlyFilter extends StatelessWidget {
  const ZenlyFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          const Color(0xffe36aa6).withOpacity(0.4),
          const Color(0xfff7ff00).withOpacity(0.4),
        ],
      )),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController mapController = MapController();
  List<Toilet> _toilets = [];

  List<Marker> genToiletMarker() {
    List<Marker> res = [];
    for (var value in _toilets) {
      res.add(ToiletMarker(name: value.name, latLng: value.latLng));
    }
    return res;
  }

  @override
  void initState() {
    getToilets().then((value) {
      setState(() {
        _toilets = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _toilets.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          mapController.moveAndRotate(LatLng(37.3098433, 127.043537), 18, 0);
        },
        child: const Icon(Icons.my_location),
      ),
      body: SafeArea(
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(37.3098433, 127.043537),
            zoom: 18,
            maxZoom: 18,
          ),
          nonRotatedChildren: const [
            // ZenlyFilter(),
            Padding(
              padding: EdgeInsets.only(left: 15, top: 5),
              child: Text(
                "Drizzle!",
                style: TextStyle(
                  fontFamily: "Pretendard",
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          children: [
            // TileLayer(
            //   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            //   userAgentPackageName: 'wtf.iamsihu.drizzle',
            // ),
            TileLayer(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/s1hu/cle6s8lxl001301msrvtxvss5/wmts?access_token=pk.eyJ1IjoiczFodSIsImEiOiJjbGU2czNxd2owODRrM3FwNnoxZ2x5dTE5In0.3Hm0-wvh7fFUaUulR2soNQ",
              additionalOptions: const {
                "access_token":
                    "pk.eyJ1IjoiczFodSIsImEiOiJjbGU2czNxd2owODRrM3FwNnoxZ2x5dTE5In0.3Hm0-wvh7fFUaUulR2soNQ",
              },
              userAgentPackageName: 'wtf.iamsihu.drizzle',
            ),
            MarkerClusterLayerWidget(
              // Toilet
              options: MarkerClusterLayerOptions(
                markers: genToiletMarker(),
                builder: (BuildContext context, List<Marker> markers) {
                  return const Icon(Icons.man);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
