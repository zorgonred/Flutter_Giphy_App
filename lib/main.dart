import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'gif_page.dart';


void main() {
  runApp(MaterialApp(
      home: Home(),
    theme: ThemeData(hintColor:(Colors.white)),
  ));
}

