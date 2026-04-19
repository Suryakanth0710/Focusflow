import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/calendar_provider.dart';
import '../providers/premium_provider.dart';
import '../providers/task_provider.dart';
import 'calendar_screen.dart';
import 'profile_screen.dart';
import 'tasks_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uid = context.read<AuthProvider>().user?.uid;
    if (uid != null) {
      context.read<CalendarProvider>().subscribe(uid);
      context.read<TaskProvider>().subscribe(uid);
      context.read<PremiumProvider>().subscribe(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    const pages = [CalendarScreen(), TasksScreen(), ProfileScreen()];
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.calendar_month_rounded), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.checklist_rounded), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
