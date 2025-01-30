import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CrudTextFormField extends StatelessWidget{
  final TextEditingController controller;
  final String hintText;
  final Function(String) onTextChanged;
  final TextInputType? type;
  final TextInputFormatter? formatter;


  const CrudTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onTextChanged,
    this.type,
    this.formatter
  });

  @override
  Widget build(BuildContext context){
    return TextFormField(
        keyboardType: type ?? TextInputType.text,
        inputFormatters: formatter == null ? []: [FilteringTextInputFormatter.digitsOnly],
        controller: controller,
        decoration: InputDecoration(
            labelText: hintText,
            fillColor: Theme.of(context).colorScheme.tertiary,
            labelStyle: TextStyle(color: Colors.grey[500]),
            focusedBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: Colors.grey.shade400, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
            )
        ),
        onChanged: onTextChanged
    );
  }
}