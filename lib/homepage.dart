import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  final String houseID; // You need to pass the user's houseID after login/signup

  const HomePage({required this.houseID, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseReference _houseRef;

  @override
  void initState() {
    super.initState();
    _houseRef = FirebaseDatabase.instance.ref().child('houses').child(widget.houseID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Home Dashboard'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder(
        stream: _houseRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final houseData = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: houseData.entries.map((roomEntry) {
              final roomName = roomEntry.key;
              final devices = Map<String, dynamic>.from(roomEntry.value);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: ExpansionTile(
                  title: Text(
                    roomName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  children: devices.entries.map((deviceEntry) {
                    final deviceName = deviceEntry.key;
                    final deviceStatus = deviceEntry.value as bool;

                    return SwitchListTile(
                      title: Text(deviceName),
                      value: deviceStatus,
                      onChanged: (bool newValue) {
                        _houseRef.child(roomName).child(deviceName).set(newValue);
                      },
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
