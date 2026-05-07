import 'package:flutter/material.dart';

class Incomepage extends StatelessWidget {
  const Incomepage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    // final TextEditingController amountController = TextEditingController();
    // final TextEditingController descriptionController = TextEditingController();
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            height: 200,
            width: double.infinity,
            color: Colors.red,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
