import 'package:flutter/material.dart';

class CustomAuthButton extends StatelessWidget {
  const CustomAuthButton({
    super.key,
    required this.onPressed,
    required this.color,
    required this.buttonName,
  });

  final VoidCallback onPressed;
  final Color color;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: color,
          elevation: 5,
        ),
        child: SizedBox(
          height: 55,
          width: double.infinity,
          child: Center(
            child: Text(
              buttonName,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
