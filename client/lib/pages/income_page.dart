import 'package:flutter/material.dart';

class Incomepage extends StatelessWidget {
  const Incomepage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    return GestureDetector(
      onTap: () {
        // FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: CarouselScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                height: 280,
                width: double.infinity,
                // color: Colors.red,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: amountController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text('Enter Amount'),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: descriptionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text('Enter Purpose'),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            amountController.clear();
                            descriptionController.clear();
                          }
                        },
                        child: Text(
                          "Submit",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
