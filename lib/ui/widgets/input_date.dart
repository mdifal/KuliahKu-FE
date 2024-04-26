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

class _CustomDateInputState extends State<CustomDateInput>
{
  String _selectedDay = '01';
  String _selectedMonth = '01';
  String _selectedYear = '2022'; // Nilai default untuk tahun

  List<String> _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
    'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align label ke kiri
        children: [
          Text(
            widget.label ?? 'Input Tanggal',
            style: TextStyle(
              color: black,
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Align row ke tengah
            children: [
              // Dropdown untuk tanggal
              DropdownButton<String>(
                value: _selectedDay,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDay = newValue!;
                    _notifyParent();
                  });
                },
                items: List.generate(31, (index) {
                  return DropdownMenuItem<String>(
                    value: (index + 1).toString().padLeft(2, '0'),
                    child: SizedBox(
                      width: 60, // Lebar item dropdown
                      child: Text(
                        (index + 1).toString().padLeft(2, '0'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(width: 8),
              // Dropdown untuk bulan
              DropdownButton<String>(
                value: _selectedMonth,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMonth = newValue!;
                    _notifyParent();
                  });
                },
                items: _months.map((String month) {
                  return DropdownMenuItem<String>(
                    value: (_months.indexOf(month) + 1).toString().padLeft(2, '0'),
                    child: SizedBox(
                      width: 80, // Lebar item dropdown
                      child: Text(
                        month,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(width: 8),
              // Dropdown untuk tahun
              DropdownButton<String>(
                value: _selectedYear,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedYear = newValue!;
                    _notifyParent();
                  });
                },
                borderRadius: BorderRadius.circular(5), // Menambahkan border radius
                items: List.generate(10, (index) {
                  // Menggunakan range tahun dari 2022 hingga 2031
                  return DropdownMenuItem<String>(
                    value: (2022 + index).toString(),
                    child: SizedBox(
                      width: 60, // Lebar item dropdown
                      child: Text(
                        (2022 + index).toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method untuk memberitahu parent widget tentang perubahan tanggal
  void _notifyParent() {
    final selectedDate = DateTime(
      int.parse(_selectedYear),
      int.parse(_selectedMonth),
      int.parse(_selectedDay),
    );
    widget.onChanged?.call(selectedDate);
  }
}
