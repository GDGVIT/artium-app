import 'package:flutter/material.dart';
import 'package:artium/Pages/about.dart';
import 'package:artium/Pages/account.dart';

import 'package:artium/Pages/daily_theme.dart';
import 'package:artium/Pages/gallery.dart';
import 'package:artium/UIComponents/app_bar.dart';
import 'package:artium/UIComponents/sideBar.dart';
import 'package:artium/Pages/home_content.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const DailyTheme(),
    const About(),
    const Gallery(),
    const Account(),
  ];

  final List<String> _titles = [
    'Art Gallery',
    'Themes',
    'About Us',
    'Gallery',
    'My Account',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: _titles[_selectedIndex],
        isCentered: _selectedIndex != 0,
      ),
      drawer: Sidebar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
