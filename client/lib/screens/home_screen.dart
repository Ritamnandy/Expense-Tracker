import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final now = DateTime.now();
  String time = '';

  @override
  void initState() {
    time = DateFormat('dd MMM yyyy').format(now);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: FaIcon(
                FontAwesomeIcons.bars,
                color: Theme.of(context).colorScheme.primary,
                size: 27.sp,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.00),
              child: IconButton(
                onPressed: () {},
                icon: FaIcon(
                  FontAwesomeIcons.solidBell,
                  color: Theme.of(context).colorScheme.primary,
                  size: 27.sp,
                ),
              ),
            ),
          ],
          title: InkWell(
            onTap: () => _selectTime(context),
            child: Text(
              time,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(
                child: Text(
                  'Income',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Expense',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                DrawerHeader(
                  child: Image.asset(
                    "assets/images/images.png",
                    fit: BoxFit.cover,
                  ),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.solidBell),
                  title: Text('Notifications'),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.solidCircleQuestion),
                  title: Text('Help & Support'),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.uber),
                  title: Text('Settings'),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(top: false, child: Column(children: [
              
            ],
          )),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    DateTime? datetime = await showDatePicker(
      barrierColor: Colors.black45,
      context: context,
      firstDate: DateTime(1980),
      lastDate: DateTime(2200),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(
                context,
              ).colorScheme.primary, // header + selected date
              onPrimary: Colors.white, // text on header
              surface: Theme.of(context).colorScheme.primaryFixed, // background
              onSurface: Colors.black, // default text
            ),
          ),
          child: child!,
        );
      },
    );
    if (datetime != null) {
      setState(() {
        time = DateFormat('dd MMM yyyy').format(datetime);
      });
    }
  }
}
