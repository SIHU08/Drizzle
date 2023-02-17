import 'package:badges/badges.dart' as badges;
import 'package:drizzle/widgets/markers.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
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

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  late MapController mapController = MapController();
  late Animation<double> _animation;
  late AnimationController _animationController;

  List<Toilet> _toilets = [];
  bool _loadingToilets = true;
  bool _layerToiletEnabled = false;

  List<Marker> genToiletMarker() {
    List<Marker> res = [];
    for (var value in _toilets) {
      res.add(ToiletMarker(name: value.name, latLng: value.latLng));
    }
    return res;
  }

  List<Widget> genLayers() {
    return [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'wtf.iamsihu.drizzle',
      ),
      if (_layerToiletEnabled)
        MarkerClusterLayerWidget(
          // Toilet
          options: MarkerClusterLayerOptions(
            markers: genToiletMarker(),
            builder: (BuildContext context, List<Marker> markers) {
              return badges.Badge(
                badgeContent: Text(markers.length.toString()),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.green,
                ),
                child: Image.asset("assets/images/toilet.png"),
              );
            },
          ),
        ),
    ];
  }

  void showAccountConfig() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "🚧",
                  style: TextStyle(fontSize: 100),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    getToilets().then((value) {
      setState(() {
        _toilets = value;
        _loadingToilets = false;
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.ease, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionBubble(
        items: [
          Bubble(
            title: "Toilet",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: _layerToiletEnabled
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              setState(() {
                _layerToiletEnabled = !_layerToiletEnabled;
              });
            },
          ),
        ],
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
        iconColor:
            Theme.of(context).floatingActionButtonTheme.foregroundColor ??
                Theme.of(context).colorScheme.onPrimaryContainer,
        backGroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor ??
                Theme.of(context).colorScheme.primaryContainer,
        animation: _animationController,
        iconData: Icons.layers,
      ),
      body: SafeArea(
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(37.3098433, 127.043537),
            zoom: 18,
            maxZoom: 18,
          ),
          nonRotatedChildren: [
            // ZenlyFilter(),
            const Padding(
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
            if (_loadingToilets)
              const Padding(
                padding: EdgeInsets.only(left: 15, top: 60),
                child: Text(
                  "지도 로딩중...",
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(17),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      showAccountConfig();
                    },
                    child: const Icon(Icons.account_circle),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton(
                      onPressed: () {
                        mapController.moveAndRotate(
                            LatLng(37.3098433, 127.043537), 18, 0);
                      },
                      child: const Icon(Icons.my_location),
                    ),
                  ),
                ],
              ),
            ),
          ],
          children: genLayers(),
        ),
      ),
    );
  }
}
