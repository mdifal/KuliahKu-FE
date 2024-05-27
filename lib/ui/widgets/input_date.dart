import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';

class CustomDateInput extends StatefulWidget {
  final String? label;
  final Function(DateTime)? onChanged;

  const CustomDateInput({
    Key? key,
    this.label,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomDateInputState createState() => _CustomDateInputState();
}

class _CustomDateInputState extends State<CustomDateInput> {
  String _selectedDay = '01';
  String _selectedMonth = '01';
  String _selectedYear = DateTime.now().year.toString();

  List<String> _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
    'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Align label to the center
        children: [
          Text(
            widget.label ?? 'Input Tanggal',
            textAlign: TextAlign.center, // Center the label text
            style: TextStyle(
              color: black,
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8), // Add spacing between the label and dropdowns
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Dropdown for day
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedDay,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDay = newValue!;
                      _notifyParent();
                    });
                  },
                  items: List.generate(31, (index) {
                    return DropdownMenuItem<String>(
                      value: (index + 1).toString().padLeft(2, '0'),
                      child: Center(
                        child: Text(
                          (index + 1).toString().padLeft(2, '0'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(width: 8),
              // Dropdown for month
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedMonth,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMonth = newValue!;
                      _notifyParent();
                    });
                  },
                  items: _months.map((String month) {
                    return DropdownMenuItem<String>(
                      value: (_months.indexOf(month) + 1).toString().padLeft(2, '0'),
                      child: Center(
                        child: Text(
                          month,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: 8),
              // Dropdown for year
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedYear,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedYear = newValue!;
                      _notifyParent();
                    });
                  },
                  borderRadius: BorderRadius.circular(5),
                  items: List.generate(10, (index) {
                    return DropdownMenuItem<String>(
                      value: (DateTime.now().year + index).toString(),
                      child: Center(
                        child: Text(
                          (DateTime.now().year + index).toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _notifyParent() {
    final selectedDate = DateTime(
      int.parse(_selectedYear),
      int.parse(_selectedMonth),
      int.parse(_selectedDay),
    );
    widget.onChanged?.call(selectedDate);
  }
}
