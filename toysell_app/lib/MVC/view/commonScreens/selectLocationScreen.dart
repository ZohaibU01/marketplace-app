import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectLocationScreen extends StatefulWidget {
  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  LatLng selectedLocation = LatLng(37.7749, -122.4194); // Default: San Francisco
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  void _onTap(LatLng latLng) {
    setState(() {
      selectedLocation = latLng;
    });
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=$query&accept-language=en');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      setState(() {
        searchResults = data
            .map((item) => {
          "display_name": item["display_name"],
          "lat": double.parse(item["lat"]),
          "lon": double.parse(item["lon"]),
        })
            .toList();
      });
    }
  }

  void _selectSearchResult(Map<String, dynamic> result) {
    setState(() {
      selectedLocation = LatLng(result["lat"], result["lon"]);
      searchController.text = result["display_name"];
      searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search location...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchLocation(searchController.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (value) => _searchLocation(value),
            ),
          ),
          if (searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchResults[index];
                  // return Text(result["display_name"].toString());
                  return ListTile(
                    title: Text(result["display_name"].toString()),
                    onTap: () => _selectSearchResult(result),
                  );
                },
              ),
            ),
          if (!searchResults.isNotEmpty)
          Expanded(
            flex: searchResults.isEmpty ? 1 : 0,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: selectedLocation,
                // zoom: 13.0,
                onTap: (_, latLng) => _onTap(latLng),
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedLocation,
                      child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, selectedLocation);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
