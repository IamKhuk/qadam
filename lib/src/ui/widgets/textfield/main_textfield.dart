import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/app_theme.dart';

class MainTextField extends StatefulWidget {
  const MainTextField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.pass = false,
    this.phone = false,
    this.inputFormatters = const [],
  });

  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool pass;
  final bool phone;
  final List<TextInputFormatter> inputFormatters;

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  bool obscure = false;

  @override
  void initState() {
    if (widget.pass == true) {
      obscure = widget.pass;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset:
            const Offset(0, 4),
            blurRadius: 100,
            spreadRadius: 0,
            color: AppTheme.black
                .withOpacity(0.05),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: AppTheme.purple,
        enableInteractiveSelection: true,
        obscureText: obscure,
        style: const TextStyle(
          fontFamily: AppTheme.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
          color: AppTheme.black,
        ),
        keyboardType: widget.phone == true
            ? TextInputType.phone
            : TextInputType.text,
        autofocus: false,
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          border:
          const OutlineInputBorder(),
          enabledBorder:
          OutlineInputBorder(
            borderRadius:
            BorderRadius
                .circular(16),
            borderSide:
            const BorderSide(
                color: AppTheme
                    .border),
          ),
          focusedBorder:
          OutlineInputBorder(
            borderRadius:
            BorderRadius
                .circular(16),
            borderSide:
            const BorderSide(
              color:
              AppTheme.purple,
            ),
          ),
          contentPadding:
          const EdgeInsets
              .symmetric(
            vertical: 20,
            horizontal: 16,
          ),
          // hintText: widget.hintText,
          // hintStyle: TextStyle(
          //   fontFamily: AppTheme.fontFamily,
          //   fontSize: 14,
          //   fontWeight: FontWeight.normal,
          //   height: 1.5,
          //   color: AppTheme.dark.withOpacity(0.6),
          // ),
          labelText: widget.hintText,
          labelStyle: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppTheme.dark.withOpacity(0.6),
          ),
          prefixIcon: Icon(widget.icon),
          prefixIconColor: MaterialStateColor.resolveWith(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused)) {
                return AppTheme.black;
              }
              return AppTheme.dark;
            },
          ),
          suffixIcon: widget.pass == true? GestureDetector(
            onTap: () {
              setState(() {
                obscure = !obscure;
              });
            },
            child: Icon(obscure == false
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined),
          ): const SizedBox(),
          suffixIconColor: WidgetStateColor.resolveWith(
                (Set<WidgetState> states) {
              if (states.contains(MaterialState.focused)) {
                return AppTheme.black;
              }
              return AppTheme.dark;
            },
          ),
        ),
      ),
    );
  }
}
