import 'dart:math';

import 'package:expense_tracker/pages/income_piechart_page.dart';
import 'package:expense_tracker/provider/add_income_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Incomepage extends StatefulWidget {
  const Incomepage({super.key});

  @override
  State<Incomepage> createState() => _IncomepageState();
}

class _IncomepageState extends State<Incomepage> {
  final formKey = GlobalKey<FormState>();
  final random = Random();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Color randomColor() {
    return Color(0xFF000000 + random.nextInt(0x00FFFFFF));
  }

  @override
  Widget build(BuildContext context) {
    final incomeChartprovider = Provider.of<IncomePiechart>(context);
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              height: 380,
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
                      decoration: InputDecoration(hint: Text('Enter Amount')),
                    ),

                    SizedBox(height: 20),
                    TextFormField(
                      controller: purposeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Purpose';
                        }
                        return null;
                      },
                      decoration: InputDecoration(hint: Text('Enter Purpose')),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: descriptionController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter Purpose';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        hint: Text('Enter Description(Optation)'),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          incomeChartprovider.addIncome(
                            purpose: purposeController.text.trim(),
                            amount: double.parse(amountController.text.trim()),
                            color: randomColor(),
                          );
                          amountController.clear();
                          purposeController.clear();
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
            Piecgartpage(),
          ],
        ),
      ),
    );
  }
}
