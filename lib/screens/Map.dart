import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:smackit/screens/Home.dart';

import '../Styles.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position position = Position(latitude: null, longitude: null);
  final _mapController = MapController();

  void getUserLocation() async {
    try {
      Position userPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // final coordinates =
      // new Coordinates(userPosition.latitude, userPosition.longitude);
      // var addresses =
      //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
      // var first = addresses.first;
      setState(() {
        position = userPosition;
        // mapSearchValue = first.addressLine;
        // isSelected = true;
        // locationTextController.text = mapSearchValue;
        _mapController.onReady.then((value) => _mapController.move(
            LatLng(userPosition.latitude, userPosition.longitude), 13));
      });
      // print("${first.featureName} : ${first.addressLine}");
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: getUserLocation,
        child: Icon(Icons.gps_fixed),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('stores').snapshots(),
        builder: (context, snapshot) {
          return Stack(
            fit: StackFit.expand,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: LatLng(position.latitude ?? 19.0760,
                          position.longitude ?? 72.8777),
                      zoom: 13.0,
                      minZoom: 10,
                    ),
                    layers: [
                      TileLayerOptions(
                          urlTemplate:
                              "https://api.mapbox.com/styles/v1/imhusain/ckc0snjhp00n41iqpd6o2sxt3/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaW1odXNhaW4iLCJhIjoiY2thcjJ0NDRwMGVrazJybnZ1YnJrd2tjdyJ9.D2Yc3GwUOXiWqDK016WWng",
                          additionalOptions: {
                            'accessToken':
                                'pk.eyJ1IjoiaW1odXNhaW4iLCJhIjoiY2theHZyNDQyMDM2bDJ5bDcxdDN0Z3F4OCJ9.dLWkkOWX8HSvoDTnRFrDIw',
                            'id': 'mapbox.mapbox-streets-v8'
                          }),
                      if (snapshot.hasData)
                        MarkerLayerOptions(
                          markers: [
                            ...storeMarkers(snapshot.data.documents),
                            if (position.latitude != null &&
                                position.longitude != null)
                              Marker(
                                width: 80.0,
                                height: 80.0,
                                point: LatLng(
                                    position.latitude, position.longitude),
                                builder: (ctx) => new Container(
                                  child: Icon(
                                    EvilIcons.location,
                                    color: MyColors.secondary,
                                    size: 45.0,
                                  ),
                                ),
                              )
                          ],
                        )
                    ]),
              ),
              // if (snapshot.hasData)
              //   Positioned(
              //       bottom: 10,
              //       child: StoreList(stores: snapshot.data.documents))
            ],
          );
        },
      ),
    );
  }

  List<Marker> storeMarkers(List<DocumentSnapshot> stores) {
    return List<Marker>.generate(stores.length, (index) {
      var store = stores[index];
      GeoPoint position = store.data()['coordinates'];
      return Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(position.latitude, position.longitude),
        builder: (ctx) => new Container(
          child: IconButton(
            onPressed: () => showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (_) => Container(
                    child: StoreCard(store: store, showDetails: true))),
            icon: Icon(
              Icons.location_on,
              color: MyColors.secondary,
              size: 45.0,
            ),
          ),
        ),
      );
    });
  }
}

// class StoreList extends StatelessWidget {
//   final List<DocumentSnapshot> stores;
//   StoreList({@required this.stores});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         width: MediaQuery.of(context).size.width,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: List<Widget>.generate(
//                 stores.length, (index) => StoreCard(store: stores[index])),
//           ),
//         ));
//   }
// }

// class StoreBriefCard extends StatelessWidget {
//   final DocumentSnapshot store;
//   StoreBriefCard({Key key, this.store}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         elevation: 10,
//         shadowColor: Colors.black,
//         margin: const EdgeInsets.all(5),
//         color: Colors.yellow[600],
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Container(
//                 width: MediaQuery.of(context).size.width * 0.6,
//                 height: 150,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       topRight: Radius.circular(10)),
//                   image: DecorationImage(
//                       image: NetworkImage(store.data['images'][0]),
//                       fit: BoxFit.cover),
//                 )),
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.6,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Flexible(
//                     child: Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: Text(
//                         store.data['name'],
//                         style: MyTextStyles.label,
//                         textAlign: TextAlign.center,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ));
//   }
// }
