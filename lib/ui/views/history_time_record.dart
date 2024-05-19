import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/card_history.dart';
import 'package:kuliahku/ui/widgets/dropdown.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:kuliahku/ui/widgets/button.dart';

class HistoryRecordPage extends StatefulWidget {
  const HistoryRecordPage({super.key});

  @override
  State<HistoryRecordPage> createState() => _HistoryRecordPageState();
}

class _HistoryRecordPageState extends State<HistoryRecordPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 8),
                Text(
                  'History Time Record',
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  CardHistory(
                    title: 'History 1',
                    mataKuliah: 'Database',
                    time: 120,
                    color : 0xFFFFCC00,
                  ),
                  SizedBox(height: 16),
                  CardHistory(
                    title: 'History 1',
                    mataKuliah: 'Database',
                    time: 7200,
                    color : 0xFFFFCC00,
                  ),
                  SizedBox(height: 16),
                  CardHistory(
                    title: 'History 1',
                    mataKuliah: 'Database',
                    time: 3600,
                    color : 0xFFFFCC00,
                  ),
                  SizedBox(height: 16),
                  CardHistory(
                    title: 'History 1',
                    mataKuliah: 'Database',
                    time: 1900,
                    color : 0xFFFFCC00,
                  ),
                  SizedBox(height: 16),
                  CardHistory(
                    title: 'History 1',
                    mataKuliah: 'Database',
                    time: 120, 
                    color : 0xFFFFCC00,
                  ),
                  SizedBox(height: 16),
                  CardHistory(
                    title: 'History 1',
                    mataKuliah: 'Database',
                    time: 120,
                    color : 0xFFFFCC00,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
