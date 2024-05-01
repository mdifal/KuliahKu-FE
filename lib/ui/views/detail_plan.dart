import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DetailPlanPage extends StatefulWidget {
const DetailPlanPage({
    Key? key,
    required this.agenda,// Inisialisasi properti controller
  }) : super(key: key);

  final String agenda;
  
  @override
  State<DetailPlanPage> createState() => _DetailPlanPageState();
}

class _DetailPlanPageState extends State<DetailPlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(widget.agenda),);
  }
}