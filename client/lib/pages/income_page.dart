import 'package:currency_picker/currency_picker.dart';
import 'package:expense_tracker/provider/add_expense_chart.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Incomepage extends StatefulWidget {
  const Incomepage({super.key});

  @override
  State<Incomepage> createState() => _IncomepageState();
}

class _IncomepageState extends State<Incomepage> {
  final formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    final Chartprovider = Provider.of<ExpenseAndIncomeChart>(context);
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 18),
            TextFormField(
              controller: amountController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter amount';
                }
                return null;
              },

              decoration: InputDecoration(
                hintText: "Enter Amount",
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
                        titleTextStyle: Theme.of(context).textTheme.bodyMedium,
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
                      border: Border(right: BorderSide(color: Colors.grey)),
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
                          "${selectedCurrency.symbol} ${selectedCurrency.code}",

                          style: const TextStyle(fontWeight: FontWeight.w600),
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Purpose';
                }
                return null;
              },
              decoration: InputDecoration(
                hint: Text('Enter Purpose', style: TextStyle(fontSize: 18.5)),
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
              ),
            ),
            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Chartprovider.addIncome(
                    purpose: purposeController.text,
                    amount: double.parse(amountController.text),
                    isExpense: false,
                    currencySymbol: selectedCurrency.symbol,
                  );
                  purposeController.clear();
                  amountController.clear();
                  FocusScope.of(context).unfocus();
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
    );
  }
}
