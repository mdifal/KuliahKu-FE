import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../shared/style.dart';

class InputNilaiItem extends StatefulWidget {
  final String matkul;
  final String jamBelajar;
  final Color color;
  final Function(String) onGradeSelected;

  const InputNilaiItem({
    required this.matkul,
    required this.jamBelajar,
    required this.color,
    required this.onGradeSelected,
  });

  @override
  _InputNilaiItemState createState() => _InputNilaiItemState();
}

class _InputNilaiItemState extends State<InputNilaiItem> {
  String? selectedGrade;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: widget.color,
                      border: Border.all(
                        color: blackSoft,
                        width: 1,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.matkul,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: black,
                        ),
                      ),
                      Text(
                        widget.jamBelajar,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: darkBlue,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedGrade,
                    isExpanded: true,
                    items: <String>['A', 'AB', 'B', 'BC', 'C', 'CD', 'D', 'DE', 'E']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(child: Text(value, style: TextStyle(fontSize: 15))),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGrade = newValue;
                      });
                      widget.onGradeSelected(newValue!);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
