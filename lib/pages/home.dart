import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'configs/settings_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  //final dbQuestion = QuestionDao.instance;
  //List<Map<String, dynamic>> questionsList = [];
  TextStyle styloRasc = TextStyle(fontSize: 18,fontWeight: FontWeight.bold);

  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const SizedBox(child: Center(child: Text('Será q ficara melhor sem o Gnav ?, quando Google irá atualizar a nova BottomBar',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),),
    const SizedBox(child: Center(child: Text('Olá',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),),
    const SizedBox(child: Center(child: Text('Higher, Faster than anyone!!',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),),
  ];


  @override
  Widget build(BuildContext context) {

    TextStyle styleFontNavBar =
    TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: Theme.of(context).accentColor);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo Fschmatz',
        ),
        actions: [IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: Theme.of(context)
                  .textTheme
                  .headline6!
                  .color!
                  .withOpacity(0.8),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SettingsPage(),
                    fullscreenDialog: true,
                  ));
            }),],
      ),

      body: _tabs[_currentIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: GNav(
              rippleColor: Theme.of(context).accentColor.withOpacity(0.4),
              hoverColor: Theme.of(context).accentColor.withOpacity(0.4),
              color:
              Theme.of(context).textTheme.headline6!.color!.withOpacity(0.8),
              gap: 8,
              activeColor: Theme.of(context).accentColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              duration: const Duration(milliseconds: 500),
              tabBackgroundColor:
              Theme.of(context).cardTheme.color!,
              backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
              tabs: [
                GButton(
                  icon: Icons.list_outlined,
                  text: 'Todo',
                  textStyle: styleFontNavBar,
                ),
                GButton(
                  icon: Icons.build_outlined,
                  text: 'Doing',
                  textStyle: styleFontNavBar,
                ),
                GButton(
                  icon: Icons.checklist_outlined,
                  text: 'Done',
                  textStyle: styleFontNavBar,
                ),
              ],
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
