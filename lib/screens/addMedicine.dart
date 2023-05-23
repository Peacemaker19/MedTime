// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, prefer_final_fields, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medtime/screens/home.dart';

class AddMedicine extends StatefulWidget {
  const AddMedicine({super.key});

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  late DatabaseReference dbref;
  var saveColor;
  final medName = TextEditingController();
  var selectCompartment, selectedColor, selectedtype;
  var Quantity = TextEditingController();
  double totalcount = 0;
  String _selectedFreq = '';
  var search = TextEditingController();
  var value = 0;
  DateTime? _today;
  DateTime? _enddate;

  List<String> freqList = <String>[
    'EveryDay',
    'Alternate',
    'Once a Week',
    'Monthly',
  ];

  @override
  void initState() {
    dbref = FirebaseDatabase.instance.ref().child('MedCustomer');
    super.initState();
  }

  void insertData() async {
    String? name = '';
    if (medName.text.isEmpty ||
        selectCompartment == null ||
        selectedColor == null ||
        selectedtype == null ||
        Quantity.text.isEmpty ||
        totalcount == null ||
        _today == null ||
        _enddate == null ||
        _selectedFreq == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fill All the Details First.')));
    } else {
      name = FirebaseAuth.instance.currentUser!.displayName;
      name ??= FirebaseAuth.instance.currentUser!.email!
          .substring(0, FirebaseAuth.instance.currentUser!.email!.indexOf('@'));
      Map<String, String> medData = {
        'name': name,
        'medicine': medName.text.toString(),
        'compartment': selectCompartment.toString(),
        'colors': saveColor.toString(),
        'type': selectedtype.toString(),
        'quantity': Quantity.text.toString(),
        'total_count': totalcount.toString(),
        'start_date': _today.toString(),
        'end_date': _enddate.toString(),
        'frequency': _selectedFreq.toString(),
      };
      await dbref.push().set(medData);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeMedLife(),
      ));
    }
  }

  Widget textLabel(String text) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  void _pickupDate(DateTime selectedDate) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickDate) {
      if (pickDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickDate;
      });
    });
  }

  void dropdowncallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _selectedFreq = selectedValue;
      });
    }
  }

  getTab(int index) {
    switch (index) {
      case 0:
        return Column(
          children: const [Icon(Icons.local_dining), Text('Capsule')],
        );
      case 1:
        return Column(
          children: const [Icon(Icons.circle), Text('Tablet')],
        );
      case 2:
        return Column(
          children: const [Icon(Icons.thumb_up_rounded), Text('Cream')],
        );
      default:
        return Column(
          children: const [Icon(Icons.visibility_off), Text('Unknown')],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine.'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: search,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    label: Text('Search'),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),
              textLabel('Medicine Name'),
              TextField(
                  textAlign: TextAlign.start,
                  onSubmitted: (value) => medName.text = value,
                  controller: medName,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10))))),
              const SizedBox(
                height: 10,
              ),
              textLabel('Compartment'),
              Container(
                width: double.infinity,
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectCompartment = index;
                        });
                      },
                      child: Card(
                        color: selectCompartment == index
                            ? Colors.blue
                            : Colors.white,
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            index.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              textLabel('Colors'),
              Container(
                width: double.infinity,
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => setState(() {
                        selectedColor = index;
                        saveColor = Colors.primaries[index];
                      }),
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: selectedColor == index
                                  ? Colors.black
                                  : Colors.white),
                          color: Colors.primaries[index],
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              textLabel('Type'),
              Container(
                width: double.infinity,
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => setState(() {
                        selectedtype = index;
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: selectedtype == index
                                  ? Colors.black
                                  : Colors.white),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        margin: const EdgeInsets.all(15.0),
                        height: 80,
                        width: 80,
                        child: getTab(index),
                      ),
                    );
                  },
                ),
              ),
              textLabel('Quantity'),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  textAlign: TextAlign.start,
                  onSubmitted: (value) => Quantity.text = value,
                  keyboardType: TextInputType.number,
                  controller: Quantity,
                  decoration: const InputDecoration(
                    label: Text('Quantity'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
              ),
              textLabel('Total Count'),
              Center(
                child: Slider(
                  divisions: 100,
                  label: '$totalcount - 100',
                  min: 0,
                  max: 100,
                  value: totalcount,
                  onChanged: (double value) {
                    setState(() {
                      totalcount = value;
                    });
                  },
                ),
              ),
              textLabel('Set Date'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => _pickupDate(_today!),
                          child: const Text('Today'),
                        ),
                        const SizedBox(width: 1),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => _pickupDate(_enddate!),
                          child: const Text('End Date'),
                        ),
                        const SizedBox(width: 1),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ],
              ),
              textLabel('Frequency of Days'),
              Container(
                width: double.infinity,
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: freqList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => setState(() {
                        _selectedFreq = freqList[index];
                      }),
                      child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: _selectedFreq == freqList[index]
                                    ? Colors.black
                                    : Colors.white),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                          ),
                          child: Text(
                            freqList[index],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    );
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                    style: const ButtonStyle(alignment: Alignment.center),
                    onPressed: insertData,
                    child: const Text(
                      'Add Medicine',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
