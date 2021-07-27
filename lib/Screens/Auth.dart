import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raselne/Widget/Auth_Form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading=false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
      BuildContext ctx,
  ) async {
    UserCredential result;
    try {
      if (isLogin) {
        setState(() {
          _isLoading=true;
        });
        result = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        setState(() {
          _isLoading=false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("success login"),
            backgroundColor: Theme.of(context).errorColor,
          ));
        });
      } else {
        setState(() {
          _isLoading=true;
        });
        result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        FirebaseFirestore.instance.collection('users').doc().set({
          'username':username,
          'email':email,
        });
        setState(() {
          _isLoading=false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("success login"),
            backgroundColor: Theme.of(context).errorColor,
          ));
        });
      }
    } on PlatformException catch (err) {
      var message = " an error occured please check your credentials";
      if (err.message != null) {
        message = err.message!.toString();
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }catch (err){
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(" something is wrong, please check your password and email again, or the internet connection"),
        backgroundColor: Colors.black,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm),
    );
  }
}
