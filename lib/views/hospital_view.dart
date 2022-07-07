import 'package:care_giver/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HospitalView extends StatefulWidget {
  const HospitalView({Key? key}) : super(key: key);

  @override
  State<HospitalView> createState() => _HospitalViewState();
}

class _HospitalViewState extends State<HospitalView> {
  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(16.757582, 96.522349), zoom: 14);
  Set<Marker> markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(STRINGS.hospital),
      ),
      // body: Column(
      //     children: [

      body: Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 200),
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: markers,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  googleMapController = controller;
                },
              ),
            ),
            const SizedBox(height: 20),
            dataTableView(),
            tableView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosition();

          googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14)));

          markers.clear();

          markers.add(Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(position.latitude, position.longitude)));

          setState(() {});
        },
        label: const Text(STRINGS.current_location),
        icon: const Icon(Icons.location_history),
      ),
    );
  }

  Widget dataTableView() {
    return Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.black12,
        ),
        padding: const EdgeInsets.fromLTRB(15, 10, 5, 10),
        margin: const EdgeInsets.all(10),
        child: Row(
          children: const <Widget>[
            Expanded(
                flex: 1,
                child: Text(
                  STRINGS.no,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Expanded(
              flex: 2,
              child: Text(
                STRINGS.hospital,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                flex: 2,
                child: Text(
                  STRINGS.phone,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Expanded(
                flex: 2,
                child: Text(
                  STRINGS.address,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ],
        ));
  }

  Widget tableView() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Column(
        children: [
          Row(
            children: const <Widget>[
              Expanded(flex: 1, child: Text("1.")),
              Expanded(flex: 2, child: Text("Sakura")),
              Expanded(flex: 2, child: Text("09775342753")),
              Expanded(flex: 2, child: Text("Yangon")),
            ],
          ),
          const Divider(color: Colors.grey),
          Row(
            children: const <Widget>[
              Expanded(flex: 1, child: Text("2.")),
              Expanded(flex: 2, child: Text("Asia Royal")),
              Expanded(flex: 2, child: Text("09773536252")),
              Expanded(flex: 2, child: Text("Yangon")),
            ],
          ),
          const Divider(color: Colors.grey),
          Row(
            children: const <Widget>[
              Expanded(flex: 1, child: Text("3.")),
              Expanded(flex: 2, child: Text("Bahosi")),
              Expanded(flex: 2, child: Text("09786353426")),
              Expanded(flex: 2, child: Text("Yangon")),
            ],
          ),
        ],
      ),
    );
  }
}
