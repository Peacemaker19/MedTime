// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:medtime/services/AuthService.dart';
import 'package:medtime/widgets/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class MedLogin extends StatefulWidget {
  const MedLogin({super.key});

  @override
  State<MedLogin> createState() => _MedLoginState();
}

class _MedLoginState extends State<MedLogin> {
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

  final _formKey = GlobalKey<FormState>();
  var _isShowing = false;
  var _isLogin = true;
  var _isAuthenticating = false;
  File? _selectedImage;
  var _enteredUsername = '';
  var _enteredPass = '';
  var _enteredEmail = '';

  

  void _submit() async {
    var isValid = _formKey.currentState!.validate();

    if (!isValid || !_isLogin && _selectedImage == null) {
      return;
    }

    _formKey.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userAccount = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPass);

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful.'),
          ),
        );
        
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPass);
        final storageref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');
        await storageref.putFile(_selectedImage!);
        final userImage = await storageref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'email': _enteredEmail,
          'imageUrl': userImage,
          'username': _enteredUsername
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // To handle error
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication Failed..'),
        ),
      );
    }
    setState(() {
      _isAuthenticating = false;
    });
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else {
      return false;
    }
  }

  Widget alertBox() {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      backgroundColor: Colors.white.withOpacity(0.3),
      alignment: Alignment.center,
      title: const Text('Please check your internet connection.'),
      actions: [
        ElevatedButton(
            onPressed: () {
              CheckUserConnection();
            },
            child: const Center(child: Text('Ok')))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ActiveConnection
        ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/images/Medtime.png',
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _isLogin ? 'Sign-in' : 'Sign-up',
                    style: const TextStyle(
                        fontSize: 25,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                if (!_isLogin)
                  Center(
                    child: UserImagePicker(
                      onPickedImage: (pickedImage) =>
                          _selectedImage = pickedImage,
                    ),
                  ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Email'),
                              suffixIcon: Icon(Icons.account_circle),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.trim().length < 5) {
                                return 'Please enter valid Email';
                              }
                              return null;
                            },
                            onSaved: (newValue) => _enteredEmail = newValue!,
                          ),
                        ),
                        if (!_isLogin)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                label: Text('UserName'),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    value.trim().length < 5) {
                                  return 'Please enter valid Username';
                                }
                                return null;
                              },
                              onSaved: (newValue) =>
                                  _enteredUsername = newValue!,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              label: const Text('Password'),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isShowing = !_isShowing;
                                    });
                                  },
                                  icon: _isShowing
                                      ? const Icon(Icons.remove_red_eye)
                                      : const Icon(Icons.visibility_off)),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.trim().length < 6) {
                                return 'Please enter valid password';
                              }
                              return null;
                            },
                            onSaved: (newValue) => _enteredPass = newValue!,
                            obscureText: _isShowing ? false : true,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        if (_isAuthenticating)
                          const CircularProgressIndicator(),
                        if (!_isAuthenticating)
                          ElevatedButton(
                            onPressed: () {
                              CheckUserConnection();
                              _submit();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 50),
                              child: Text(
                                _isLogin ? 'Sign-in' : 'Signup',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Divider(
                              height: 50,
                              thickness: 1,
                              color: Colors.black,
                            ),
                            Text(
                              'OR',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            Divider(
                              height: 50,
                              thickness: 1,
                              color: Colors.grey,
                            )
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            CheckUserConnection();
                            AuthService().signInWithGoogle();
                          },
                          icon: Image.asset(
                            'assets/images/google.png',
                            height: 25,
                            width: 25,
                          ),
                          label: const Text(
                            'Continue with Google',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 249, 246, 246)),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                              padding: MaterialStatePropertyAll(
                                  EdgeInsetsDirectional.symmetric(
                                      vertical: 15, horizontal: 30))),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        if (!_isAuthenticating)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? 'Create an account.'
                                  : 'I already have an account.',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          )
                      ],
                    ))
              ],
            ),
          )
        : alertBox();

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'MedLife',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: content);
  }
}
