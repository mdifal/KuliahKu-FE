import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/collab_plan/calender.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class addSubgroupPage extends StatefulWidget {
  final String? groupId;
  const addSubgroupPage({Key? key, this.groupId}) : super(key: key);

  @override
  State<addSubgroupPage> createState() => _addSubgroupPageState();
}

class _addSubgroupPageState extends State<addSubgroupPage> {
  TextEditingController subgroupController = TextEditingController();

  Future<void> addSubgroup() async {
    String namaSubgroup = subgroupController.text;
    var url = 'http://$ipUrl/groups/${widget.groupId}/subgroups';
    var response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'name': namaSubgroup,
      }),
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    String statusCode = jsonResponse['statusCode'];
    String message = jsonResponse['message'];
    if (statusCode == "200") {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: "SubGroup Berhasil Dibuat!",
          backgroundColor: success,
        ),
      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CalenderCollabPlanPage(calender: 'schedule', groupId: '${widget.groupId}' ))
        );
    } else {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: "Subgroup Gagal Dibuat!",
          backgroundColor: failed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 40.0),
            Column(
              children: <Widget>[
                CustomTextField(
                  label: "Nama Sub group",
                  password: false,
                  placeholder: "Tugas PPL",
                  controller: subgroupController,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  color: Colors.white,
                  child: CustomButton(
                    label: "Simpan",
                    backgroundColor: yellow,
                    textColor: black,
                    onPressed: addSubgroup,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
