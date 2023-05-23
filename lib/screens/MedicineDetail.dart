// ignore_for_file: unrelated_type_equality_checks
import 'package:flutter/material.dart';

class MedicineDetail extends StatefulWidget {
  const MedicineDetail({super.key});

  @override
  State<MedicineDetail> createState() => _MedicineDetailState();
}

class _MedicineDetailState extends State<MedicineDetail> {
  bool isLoading = false;
  ListView createList(int count) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              children: [
                const Card(
                  elevation: 10,
                  child: Icon(Icons.android, color: Colors.blue),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Paracetamol 500mg Tablet',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Before Breakfast',
                              style: TextStyle(
                                  fontSize: 12, fontStyle: FontStyle.italic),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: const Text(
                              '      Day 27',
                              style: TextStyle(
                                  fontSize: 12, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Card(
                    elevation: 10,
                    child: Icon(
                      Icons.notifications_active,
                      color: Colors.red,
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (!isLoading) {
      content = Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Morning 8:00am',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 250, child: createList(3)),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Afternoon 02:00am',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 250, child: createList(3)),
            const Text(
              'Night 09:00pm',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 250, child: createList(3)),
          ],
        ),
      );
    } else {
      content = Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset('assets/images/blank_box.png'),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Nothing\'s here. Please Add Medicine')
          ],
        ),
      );
    }
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        ElevatedButton(
            style: const ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                padding: MaterialStatePropertyAll(
                    EdgeInsetsDirectional.symmetric(
                        vertical: 15, horizontal: 100))),
            onPressed: () {
              setState(() {
                isLoading = !isLoading;
              });
            },
            child: !isLoading ? const Text('Reset') : const Text('Get Data')),
        content
      ],
    )));
  }
}
