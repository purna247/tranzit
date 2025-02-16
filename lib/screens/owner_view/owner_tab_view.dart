import 'package:flutter/material.dart';
import 'package:ttranzit_app/screens/owner_view/tabs/add_vehicle.dart';
import 'package:ttranzit_app/screens/owner_view/tabs/job_details.dart';

import 'package:ttranzit_app/screens/owner_view/tabs/owner_home_tab.dart';
import 'package:ttranzit_app/screens/owner_view/tabs/trip_details.dart';
import 'package:ttranzit_app/screens/shipper_view/tabs/add_job_tab.dart';
import 'package:ttranzit_app/screens/shipper_view/tabs/profile_tab.dart';
import 'package:ttranzit_app/screens/shipper_view/tabs/trip_tab.dart';

class OwnerTabView extends StatefulWidget {
  final int givenIndex;
  const OwnerTabView({super.key, required this.givenIndex});

  @override
  State<OwnerTabView> createState() => _OwnerTabViewState();
}

class _OwnerTabViewState extends State<OwnerTabView> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.givenIndex;
  }

  final List _widgetOptions = [
    OwnerHomeTab(),
    OwnerTripTab(),
    AddVehicleScreen(),
    ProfileTab(),
  ];

  get isSelected => true;

  void _onItemTapped(int widgetOptions) {
    setState(() {
      _selectedIndex = widgetOptions;
    });
  }

  bool onSelected = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: Container(
          height: height * 0.10,
          child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.black,
              selectedItemColor: const Color(0xffFF8B2C),
              showUnselectedLabels: true,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: [
                BottomNavigationBarItem(
                    icon: _selectedIndex == 0
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Image.asset(
                              'assets/icons/home_coloured.png',
                              height: height * 0.047,
                              width: height * 0.047,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: SizedBox(
                              height: height * 0.04,
                              width: height * 0.042,
                              child: const ImageIcon(
                                  AssetImage("assets/icons/Home.png")),
                            ),
                          ),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: _selectedIndex == 1
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Image.asset(
                              'assets/icons/trip_car_coloured.png',
                              height: height * 0.04,
                              width: height * 0.04,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: SizedBox(
                              height: height * 0.04,
                              width: height * 0.04,
                              child: const ImageIcon(
                                  AssetImage("assets/icons/trip_car.png")),
                            ),
                          ),
                    label: 'Job'),
                BottomNavigationBarItem(
                    icon: _selectedIndex == 2
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Image.asset(
                              'assets/icons/add_vehicle_coloured.png',
                              height: height * 0.04,
                              width: height * 0.04,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: SizedBox(
                              height: height * 0.04,
                              width: height * 0.04,
                              child: const ImageIcon(
                                  AssetImage("assets/icons/add_vehicle.png")),
                            ),
                          ),
                    label: 'Trip'),
                BottomNavigationBarItem(
                    icon: _selectedIndex == 3
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Image.asset(
                              'assets/icons/profile_coloured.png',
                              height: height * 0.04,
                              width: height * 0.04,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: SizedBox(
                              height: height * 0.04,
                              width: height * 0.04,
                              child: const ImageIcon(
                                  AssetImage("assets/icons/profile.png")),
                            ),
                          ),
                    label: 'Profile'),
              ]),
        ));
  }
}
