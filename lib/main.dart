import 'dart:async';
import 'dart:ffi';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('1--------');
    return MaterialApp(
      title: 'Flutter Google Maps ',
      home: MapSample(),
    );
  }
}



class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(22.696625, 75.830434),
    zoom: 15,
  );

  List <Marker> Allmarkers = [];
  List<Contact> _contacts = [];
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    print('2---------');
    _fetchContacts();

  }

  Future _fetchContacts() async {
    //List<Marker> Allmarkers=[];
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      print('permission denied');
    } else {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      print(contacts.length);
      int i = 0;
      for (var contact in contacts) {
        print(contact.addresses.toString());
        if (contact.addresses.isNotEmpty) {
          print('In if condition :: contacts${contact}');
          // Position position =;
          List<Location> locations = await locationFromAddress(contact.addresses[0].address);
          double lati=0,longi=0;
          if(locations.isNotEmpty)
            {
              lati=locations[0].latitude;
              longi=locations[0].longitude;
            }
          print(locations);
          Allmarkers.add(
            Marker(
              markerId: MarkerId(i.toString()),
              draggable: false,
              onTap: () {
                print('tapped');
              },
              position: LatLng(lati,longi),
            ),
          );

          // Allmarkers.add(
          //   Marker(
          //     markerId: MarkerId(i.toString()),
          //     draggable: false,
          //     onTap: () {
          //       print('tapped');
          //     },
          //     position: LatLng(22.696625, 75.830434),
          //   ),
          // );
          print('i: ${i}');
          i++;
        }
      }

    }
    print(" AllMarker Anish Count $Allmarkers");

    setState(() {} );
  }

  Widget build(BuildContext context) {
    return  Scaffold(
        body: GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          markers: Set.from(Allmarkers),
    )
    );
  }

// Future<void> _goToTheLake() async {
//   final GoogleMapController controller = await _controller.future;
//   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
// }
}
