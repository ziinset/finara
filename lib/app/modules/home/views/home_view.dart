import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Added for Cupertino icons

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'home_content_view.dart';
import 'notes_content_view.dart';
import 'chart_content_view.dart';
import 'profile_content_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Primary green color
    const Color primaryGreen = Color(0xFF3A6043);
    const Color unselectedGrey = Colors.grey;

    final List<Widget> pages = [
      const HomeContentView(),
      const NotesContentView(),
      const ChartContentView(),
      const ProfileContentView(),
    ];

    return Scaffold(
      extendBody: true, // Allows body to extend behind the navigation bar
      body: Stack(
        children: [
          // Main Body
          Obx(() => pages[controller.currentIndex.value]),

          // Custom FAB Menu overlay (Circular Icon Buttons)
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              bottom: controller.isFabOpen.value ? 120 : 60, // Lowered slightly
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: controller.isFabOpen.value ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: !controller.isFabOpen.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Catatan button
                      AnimatedScale(
                        scale: controller.isFabOpen.value ? 1.0 : 0.5,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        child: GestureDetector(
                          onTap: () {
                            controller.toggleFab();
                            controller.changePage(1);
                          },
                          child: Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.sticky_note_2_outlined,
                              color: Color(0xFF3A6043),
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      // Wallet button
                      AnimatedScale(
                        scale: controller.isFabOpen.value ? 1.0 : 0.5,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutBack,
                        child: GestureDetector(
                          onTap: () {
                            controller.toggleFab();
                          },
                          child: Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Color(0xFF3A6043),
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(() => GestureDetector(
        onTap: () {
          controller.toggleFab();
        },
        child: Container(
          width: 64, // Exact size for the notch
          height: 64,
          alignment: Alignment.center, // This ensures the + icon is perfectly in the middle
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF7FB68C), // Lighter green for top of gradient
                Color(0xFF3A6043), // Primary green for bottom
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryGreen.withOpacity(0.2), // Reduced shadow opacity
                blurRadius: 6, // Reduced blur
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AnimatedRotation(
            turns: controller.isFabOpen.value ? 0.125 : 0.0, // Rotate + to x when open
            duration: const Duration(milliseconds: 250),
            child: const Icon(Icons.add, color: Colors.white, size: 36),
          ),
        ),
      )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10.0,
            color: Colors.white,
            elevation: 0,
            child: SizedBox(
              height: 72.0, // Increased to fit icon + label
              child: Obx(
                () => Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildNavItem(
                            icon: Icons.home_outlined,
                            activeIcon: Icons.home,
                            label: 'Beranda',
                            index: 0,
                            activeColor: primaryGreen,
                            inactiveColor: unselectedGrey,
                          ),
                          _buildNavItem(
                            icon: Icons.sticky_note_2_outlined,
                            activeIcon: Icons.sticky_note_2,
                            label: 'Catatan',
                            index: 1,
                            activeColor: primaryGreen,
                            inactiveColor: unselectedGrey,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 72), // Fixed space for the central FAB notch
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildNavItem(
                            icon: Icons.bar_chart_outlined,
                            activeIcon: Icons.bar_chart,
                            label: 'Grafik',
                            index: 2,
                            activeColor: primaryGreen,
                            inactiveColor: unselectedGrey,
                          ),
                          _buildNavItem(
                            icon: Icons.person_outline,
                            activeIcon: Icons.person,
                            label: 'Profil',
                            index: 3,
                            activeColor: primaryGreen,
                            inactiveColor: unselectedGrey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    bool isSelected = controller.currentIndex.value == index;
    final color = isSelected ? activeColor : inactiveColor;
    return GestureDetector(
      onTap: () {
        controller.changePage(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey<bool>(isSelected),
                color: color,
                size: 26,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A custom notched shape that shifts the notch by a given horizontal offset.
/// This is necessary because BottomAppBar uses the Scaffold's coordinate system for the FAB,
/// but draws the notch in its own local coordinate system. If the BottomAppBar has a left margin,
/// the notch will be drawn too far to the right by default.
class _CustomNotchedRectangle extends NotchedShape {
  final double shiftX;

  const _CustomNotchedRectangle(this.shiftX);

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest != null) {
      guest = guest.shift(Offset(-shiftX, 0));
    }
    return const CircularNotchedRectangle().getOuterPath(host, guest);
  }
}
