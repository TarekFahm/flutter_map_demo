import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:geocoder/geocoder.dart';
import 'package:latlong/latlong.dart';


import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'user_location.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    UserLocation userLocation = Provider.of<UserLocation>(context);
    getAddress() async {
      final coordinates = Coordinates(userLocation.latitude, userLocation.longitude);
      // final coordinates = Coordinates(30.0074, 31.4913);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      Address first = addresses.first;

      print("addressLine : ${first.addressLine}}");
      print("featureName : ${first.featureName}}");
      print("adminArea : ${first.adminArea}}");
      print("locality : ${first.locality}}");
      print("subAdminArea : ${first.subAdminArea}}");
      print("subLocality : ${first.subLocality}}");
      print("thoroughfare : ${first.thoroughfare}}");
      print("subThoroughfare : ${first.subThoroughfare}}");

      return first;
    }

    List<String> availableLocations = [
      // "Giza Governorate",
      "South Investors Area",
      // "Tagamoa Governorate",
    ];

    return FutureBuilder<Address>(
      future: getAddress(),
      builder: (BuildContext context, AsyncSnapshot<Address> address) {
        return Scaffold(
          appBar: AppBar(
            title: Text(address.hasData ? address.data.adminArea : "Loading..."),
          ),
          body: userLocation == null
              ? Center(
            child: CircularProgressIndicator(),
          )
              : address.hasData
              ? SlidingUpPanel(
            panel: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
                    child: Text(
                      "${address.data.addressLine}",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ),
                  Text(
                    availableLocations.contains(address.data.featureName)
                        ? "Covered Location"
                        : "Not Covered Location",
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ],
              ),
            ),
            collapsed: Container(
              decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: radius),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
                      child: Text(
                        "${address.data.adminArea}, ${address.data.subAdminArea == null ? address.data.featureName : address.data.subAdminArea}",
                        style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      availableLocations.contains(address.data.featureName)
                          ? "Covered Location"
                          : "Not Covered Location",
                      style:
                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            borderRadius: radius,
            body: FlutterMap(
              options: MapOptions(
                center: LatLng(userLocation.latitude, userLocation.longitude),
                zoom: 13.0,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 100,
                      height: 100,
                      point: LatLng(userLocation.latitude, userLocation.longitude),
                      builder: (ctx) => Container(
                        child: Icon(
                          Icons.pin_drop,
                          size: 50,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                // CircleLayerOptions(circles: [
                //   CircleMarker(
                //       //radius marker
                //       point: LatLng(userLocation.latitude, userLocation.longitude),
                //       color: Colors.blue.withOpacity(0.3),
                //       borderStrokeWidth: 3.0,
                //       borderColor: Colors.blue,
                //       radius: 100 //radius
                //       )
                // ]),
              ],
            ),
          )
              : Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}