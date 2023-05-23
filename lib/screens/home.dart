import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medtime/screens/MedicineDetail.dart';
import 'package:medtime/screens/addMedicine.dart';
import 'package:medtime/screens/report.dart';

final _firebase = FirebaseAuth.instance;

class HomeMedLife extends StatefulWidget {
  const HomeMedLife({super.key});

  @override
  State<HomeMedLife> createState() => _HomeMedLifeState();
}

class _HomeMedLifeState extends State<HomeMedLife> {
  
  bool ActiveConnection = false;
  String T = "";
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  

  @override
  void initState() {
    
    CheckUserConnection();
    super.initState();
  }

  int _selectPageIndex = 0;
  void _selectpage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  void _selectTab(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AddMedicine(),
        ),
      );

      // setState(() {
      //   _selectedFilter = result ?? kInitialValue;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const MedicineDetail();
    var activePagetitle = 'Medicine';

    if (_selectPageIndex == 1) {
      activePage = MedReport();
      activePagetitle = 'Report';
    }
    String name = 'Smith@saini';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Hi, \n${_firebase.currentUser!.email!.substring(0, _firebase.currentUser!.email!.indexOf('@'))}',
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              color: Colors.black,
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectPageIndex,
        onTap: _selectpage,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Report',
            icon: Icon(
              Icons.stacked_line_chart_rounded,
              color: Colors.grey,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddMedicine(),
          ));
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
