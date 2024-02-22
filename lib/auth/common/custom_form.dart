import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAuthField extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSecret;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;
  final TextEditingController controller;

  const CustomAuthField({
    super.key, 
    required this.icon, 
    required this.label, 
    this.isSecret = false,
    this.inputFormatters,
    this.initialValue,
    this.readOnly = false,
    required this.controller,
    });

  @override
  State<CustomAuthField> createState() => _CustomAuthFieldState();
}

class _CustomAuthFieldState extends State<CustomAuthField> {

  bool isObscure = false;

  @override
  void initState() {
    super.initState();

    isObscure = widget.isSecret;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: widget.controller,
        readOnly: widget.readOnly,
        initialValue: widget.initialValue,
        inputFormatters: widget.inputFormatters,
        obscureText: isObscure,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.isSecret ? IconButton(
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });           
            },
             icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off), 
             ) : null,
          labelText: widget.label,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
