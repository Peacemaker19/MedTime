import 'package:flutter/material.dart';

class MedReport extends StatefulWidget {
  const MedReport({super.key});

  @override
  State<MedReport> createState() => _MedReportState();
}

class _MedReportState extends State<MedReport> {
  bool isLoading = false;

  ListView createList(int count) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(0),
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
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Report',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Card(
                elevation: 20,
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Today\'s Report',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                '5',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              Text('Total')
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                '3',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              Text('Taken')
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                '2',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              Text('Missed')
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                '1',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              Text('Snoozed')
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Card(
              elevation: 20,
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(15.0),
                    child: const Text(
                      'Check DashBoard',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Check DashBoard daily to keep track.',
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/blank_box.png',
                          height: 50,
                          width: 50,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: const [
                        Text(
                          'Check History',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.all(10),
                      height: 100,
                      width: 200,
                      child: const Text('History')),
                ],
              ),
            ),
            Container(
              width: double.infinity,
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
            )
          ],
        ),
      ),
    );
  }
}
