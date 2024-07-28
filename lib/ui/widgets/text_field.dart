import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final bool password;
  final TextEditingController? controller;
  final bool? disable;

  const CustomTextField({
    Key? key,
    this.placeholder,
    this.label,
    this.password = false,
    this.controller,
    this.disable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
            ),
            child: Text(
              label!,
              style: TextStyle(
                color: black,
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (password)
            PasswordField(
              controller: controller,
              passwordDecoration: PasswordDecoration(
                inputPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: secondaryColor.withOpacity(1),
              passwordConstraint: r'.*[@$#.*].*',
              hintText: placeholder,
              border: PasswordBorder(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: secondaryColor,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(width: 2, color: Colors.red.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: mainColor,
                    width: 1,
                  ),
                ),
              ),
              errorMessage: 'must contain special character either . * @ # \$',
            )
          else
            TextField(
              controller: controller,
              style: TextStyle(
                fontSize: 12,
                color: black,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: disable! ? greySoft : secondaryColor,
                hintText: placeholder,
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: black,
                  fontWeight: FontWeight.w600,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: secondaryColor,
                    width: 1,
                  ),
                ),
                enabled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: mainColor,
                    width: 1,
                  ),
                ),
              ),
              enabled: !disable!,
              inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@#$%^&*()_+!\- =[\]{};"|,:.<>/?]*')),
              ],
            )
        ],
      ),
    );
  }
}


class CustomTextFieldNoLabel extends StatelessWidget {
  final String? placeholder;
  final bool password;
  final TextEditingController? controller;
  final void Function(String)? onSubmitted;

  const CustomTextFieldNoLabel({
    Key? key,
    this.placeholder,
    this.password = false,
    this.controller,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (password)
            PasswordField(
              controller: controller, // Gunakan controller untuk PasswordField
              passwordDecoration: PasswordDecoration(
                inputPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: secondaryColor.withOpacity(1),
              passwordConstraint: r'.*[@$#.*].*',
              hintText: placeholder,
              border: PasswordBorder(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: secondaryColor,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(width: 2, color: Colors.red.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: mainColor,
                    width: 1,
                  ),
                ),
              ),
              errorMessage: 'must contain special character either . * @ # \$',
            )
          else
            TextField(
              controller: controller, // Gunakan controller untuk TextField
              style: TextStyle(
                fontSize: 16,
                  color: grey,
                  fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: grey,
                  fontWeight: FontWeight.w600,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: secondaryColor,
                width: 1.0,
              ),
            ),
                enabled: true,
              ),
              onSubmitted: onSubmitted,
            )
        ],
      ),
    );
  }
}
