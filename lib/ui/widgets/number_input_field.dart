import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';

class CustomNumberInput extends StatefulWidget {
  final String? label;
  final Function(int)? onChanged;

  const CustomNumberInput({
    Key? key,
    this.label,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomNumberInputState createState() => _CustomNumberInputState();
}

class _CustomNumberInputState extends State<CustomNumberInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '0');
    _controller.addListener(_updateValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateValue() {
    final newValue = int.tryParse(_controller.text) ?? 0;
    setState(() {
      widget.onChanged?.call(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label ?? 'Input Number',
          style: TextStyle(
            color: black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 40,
          child: TextFormField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 10),
              isDense: true,
              suffixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _incrementValue,
                    child: Icon(Icons.keyboard_arrow_up),
                  ),
                  GestureDetector(
                    onTap: _decrementValue,
                    child: Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _incrementValue() {
    final newValue = int.parse(_controller.text) + 1;
    _controller.text = newValue.toString();
    _updateValue();
  }

  void _decrementValue() {
    final newValue = int.parse(_controller.text) - 1;
    if (newValue >= 0) {
      _controller.text = newValue.toString();
      _updateValue();
    }
  }
}
