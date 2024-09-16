import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heavenrun/controller/utils/utils.dart';
import 'package:heavenrun/pageManagers/map_page_manager.dart';
import 'package:heavenrun/controller/shared/constants.dart';
import 'package:heavenrun/controller/location/user_positon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.APP_TEXT_TITLE,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: Constants.APP_TEXT_TITLE),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var pageIndex = 0;
  static Future<UserPosition> initialUserposition =
      MapScreen.MANAGER.getUserPosition();
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (pageIndex) {
      case 0:
        page = RunningPage();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $pageIndex');
    }
// PROBLEM IN SWITCHING OPTIONS NAVIGATOR
    return FutureBuilder(
        future: initialUserposition,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError || !snapshot.hasData) {
              return MapScreen.MANAGER.handleRunningRouteError(snapshot);
            } else {
              MapScreen.userposition = snapshot.data!;
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: Text(widget.title),
                ),
                body: Container(
                  color: Colors.white,
                  child: page,
                ),
                bottomNavigationBar: NavigationBar(
                  destinations: [
                    NavigationDestination(
                        icon: Icon(Icons.home), label: Constants.APP_TEXT_HOME),
                    NavigationDestination(
                        icon: Icon(Icons.person),
                        label: Constants.APP_TEXT_PROFILE),
                  ],
                  indicatorColor: Colors.white,
                  selectedIndex: pageIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      pageIndex = index;
                    });
                  },
                ),
              );
            }
          } else {
            return CircularProgressIndicator(); // enhance the design
          }
        });
  }
}

class RunningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapScreen(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.play_arrow, color: Colors.white),
                  label: Text(Constants.APP_TEXT_RUN,
                      style: TextStyle(color: Colors.white)),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            //  to change
                            content: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text("What is your goal today?")]),
                            actions: <Widget>[
                              SizedBox(
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                      labelText: "distance in km :)"),
                                  onSubmitted: (String value) {
                                    if (Util.isDistance(int.tryParse(value))) {
                                      // changing the distance's value to generate a route
                                      MapScreen.targetDistance =
                                          int.parse(value);
                                      MapScreen.MANAGER.updateRouteStream();
                                      Navigator.pop(context);

                                      print("The user wants to run $value km");
                                    } else {
                                      print("The input is not an integer");
                                    }
                                  },
                                  maxLength: 3,
                                ),
                              ),
                            ],
                          )),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// todos for the basis of this project

//
// todo1
// faire une premiére version du backend ou on détermine ending position à partir d'une entrée
// se familiariser avec spring
//

//
// todo3
// faire en sorte que la position s'update quand le user bouge .. = en mode itinairaire
//

//
// todo3 (frontend)
// personaliser le marker du user
// faire en sorte que la direction du marker match celle du telephone
// update l'UI
// ...
//

//
// todo4
// Error handling
// clean code
//

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
  static final MANAGER = MapPageManager();
  static final StreamController<Map<PolylineId, Polyline>>
      STREAM_POLYLINES_CONTROLLER = MapScreen.MANAGER.FillRouteStream();
  static late UserPosition userposition;

  static int targetDistance = 0;

  static Stream<Map<PolylineId, Polyline>> get streamPolylines =>
      STREAM_POLYLINES_CONTROLLER.stream;
  static Sink get updateDistance => STREAM_POLYLINES_CONTROLLER.sink;
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  final LatLng INITIAL_USER_POSITION =
      MapScreen.MANAGER.toLatLng(MapScreen.userposition);

  Map<MarkerId, Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return StreamBuilder(
        stream: MapScreen.streamPolylines,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError || !snapshot.hasData) {
              return MapScreen.MANAGER.handleRunningRouteError(snapshot);
            } else {
              Map<PolylineId, Polyline> polylines =
                  MapScreen.MANAGER.getPolylinesFromSnap(snapshot);

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: INITIAL_USER_POSITION,
                  zoom: 16,
                ),
                myLocationEnabled: true,
                tiltGesturesEnabled: true,
                compassEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                // onMapCreated: _onMapCreated,
                markers: Set<Marker>.of(markers.values),
                polylines: Set<Polyline>.of(polylines.values),
              );
            }
          } else {
            return CircularProgressIndicator(); // enhance the design
          }
        });
  }
}

// void _onMapCreated(GoogleMapController controller) async {
//   mapController = controller;
// }
