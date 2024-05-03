import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:kuliahku/ui/shared/style.dart';

class CustomDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> items; // Change the type of items from Map<String, int> to Map<String, dynamic>
  final String? label;
  final String? placeholder;
  final ValueChanged<int>? onChanged;

  const CustomDropdown({
    Key? key,
    this.placeholder,
    this.label,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                bottom: 8.0), // Tambahkan margin bawah pada teks
            child: Text(
              widget.label!,
              style: TextStyle(
                color: black,
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DropdownButtonFormField2<int>(
            value: selectedValue,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            hint: Text(
              widget.placeholder ?? '',
              style: const TextStyle(fontSize: 14),
            ),
            items: widget.items
                .map((item) => DropdownMenuItem<int>(
                      value: item['value'], // Mengambil nilai 'value' dari item
                      child: Text(
                        item['label'], // Mengambil label dari item
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return widget.placeholder;
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value!);
              }
            },
            onSaved: (value) {
              selectedValue = value;
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(right: 8),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          )
        ],
      ),
    );
  }
}
