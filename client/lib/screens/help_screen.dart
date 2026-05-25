import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Helpandsupport extends StatelessWidget {
  final AdvancedDrawerController advancedDrawerController;
  const Helpandsupport({super.key, required this.advancedDrawerController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            advancedDrawerController.showDrawer();
          },
          icon: ValueListenableBuilder<AdvancedDrawerValue>(
            valueListenable: advancedDrawerController,
            builder: (_, value, _) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
                child: Semantics(
                  label: 'Menu',
                  onTapHint: 'expand drawer',
                  child: FaIcon(
                    key: ValueKey<bool>(value.visible),
                    value.visible
                        ? FontAwesomeIcons.xmark
                        : FontAwesomeIcons.bars,
                    color: Theme.of(context).colorScheme.primary,
                    size: 27.sp,
                  ),
                ),
              );
            },
          ),
        ),

        title: Text("Help & Support"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How can we help?",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),

            _HelpTile(
              icon: Icons.add_circle_outline,
              title: "Add income or expense",
              subtitle:
                  "Go to Home, choose Income or Expense, enter details, then submit.",
            ),
            _HelpTile(
              icon: Icons.receipt_long,
              title: "View transactions",
              subtitle:
                  "Tap See All from Recent Transactions to view your full history.",
            ),
            _HelpTile(
              icon: Icons.calendar_month,
              title: "Filter by date",
              subtitle: "Tap the date in the Home app bar and select a date.",
            ),
            _HelpTile(
              icon: Icons.dark_mode_outlined,
              title: "Change theme",
              subtitle:
                  "Open Settings and select Light, Dark, or System Default.",
            ),

            SizedBox(height: 20.h),
            Text(
              "FAQs",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),

            _FaqTile(
              question: "Why are my transactions not showing?",
              answer:
                  "Pull down on the Home screen to refresh. Also check that you selected the correct month or date.",
            ),
            _FaqTile(
              question: "How do I delete a transaction?",
              answer:
                  "Swipe a transaction from right to left, then confirm delete.",
            ),
            _FaqTile(
              question: "How do I update my profile photo?",
              answer:
                  "Open the drawer and tap the camera icon near your profile image.",
            ),

            SizedBox(height: 20.h),
            const _SupportContactCard(email: "ritamsouma.dev@gmail.com"),
          ],
        ),
      ),
    );
  }
}

class _SupportContactCard extends StatelessWidget {
  final String email;

  const _SupportContactCard({required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => _copyEmail(context),
        leading: Icon(
          Icons.support_agent,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text("Need more support?"),
        subtitle: Text("Contact: $email"),
        trailing: IconButton(
          tooltip: "Copy email",
          onPressed: () => _copyEmail(context),
          icon: const Icon(Icons.copy),
        ),
      ),
    );
  }

  Future<void> _copyEmail(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: email));

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Copied $email")));
  }
}

class _HelpTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _HelpTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Align(alignment: Alignment.centerLeft, child: Text(answer)),
          ),
        ],
      ),
    );
  }
}
