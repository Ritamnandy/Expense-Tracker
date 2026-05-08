import 'dart:math';

import 'package:currency_picker/currency_picker.dart';
import 'package:expense_tracker/pages/expense/expense_piechart_page.dart';
import 'package:expense_tracker/provider/add_expense_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Expensepage extends StatefulWidget {
  const Expensepage({super.key});

  @override
  State<Expensepage> createState() => _ExpensepageState();
}

class _ExpensepageState extends State<Expensepage> {
  final formKey = GlobalKey<FormState>();
  final random = Random();
  Currency selectedCurrency = Currency(
    code: "INR",
    name: "Indian Rupee",
    symbol: "₹",
    number: 356,
    flag: '',
    decimalDigits: 0,
    namePlural: '',
    symbolOnLeft: true,
    decimalSeparator: '',
    thousandsSeparator: '',
    spaceBetweenAmountAndSymbol: true,
  );
  final TextEditingController amountController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();

  Color randomColor() {
    return Color(0xFF000000 + random.nextInt(0x00FFFFFF));
  }

  @override
  Widget build(BuildContext context) {
    final expenseChartprovider = Provider.of<ExpensePiechart>(context);
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              height: 340,
              width: double.infinity,
              // color: Colors.red,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: amountController,
                      autovalidateMode:
                          AutovalidateMode.onUserInteractionIfError,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        return null;
                      },

                      decoration: InputDecoration(
                        errorStyle: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Enter Amount",
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),

                        prefixIcon: InkWell(
                          onTap: () {
                            showCurrencyPicker(
                              context: context,
                              theme: CurrencyPickerThemeData(
                                flagSize: 30,
                                backgroundColor: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                bottomSheetHeight: 400,
                                titleTextStyle: Theme.of(
                                  context,
                                ).textTheme.bodyMedium,
                                subtitleTextStyle: Theme.of(
                                  context,
                                ).textTheme.bodyMedium,
                              ),
                              showFlag: true,
                              showCurrencyCode: true,
                              showCurrencyName: true,

                              favorite: ['INR', 'USD'],

                              onSelect: (Currency currency) {
                                setState(() {
                                  selectedCurrency = currency;
                                });
                              },
                            );
                          },

                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),

                            margin: const EdgeInsets.only(right: 10),

                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey),
                              ),
                            ),

                            child: Row(
                              mainAxisSize: MainAxisSize.min,

                              children: [
                                Text(
                                  selectedCurrency.flag.toString(),
                                  style: const TextStyle(fontSize: 18),
                                ),

                                const SizedBox(width: 6),

                                Text(
                                  "${selectedCurrency.symbol} ",

                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    TextFormField(
                      controller: purposeController,
                      autovalidateMode:
                          AutovalidateMode.onUserInteractionIfError,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Purpose';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hint: Text(
                          'Enter Purpose',
                          style: TextStyle(fontSize: 18.5),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          expenseChartprovider.addIncome(
                            purpose: purposeController.text.trim(),
                            amount: double.parse(amountController.text.trim()),
                            color: randomColor(),
                            currencySymbol: selectedCurrency.symbol,
                          );
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
            // const SizedBox(height: 10),
            SizedBox(height: 650, child: ExpensePiechartPage()),
          ],
        ),
      ),
    );
  }
}
