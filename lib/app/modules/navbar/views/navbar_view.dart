import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../catatan/views/catatan_view.dart';
import '../../statistik/views/statistik_view.dart';
import '../../profile/views/profile_view.dart';
import '../../home/views/home_dashboard_view.dart';

class NavbarView extends GetView<HomeController> {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeDashboardView(),
      const CatatanView(),
      const StatistikView(),
      const ProfileView(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF161616),
      body: Stack(
        children: [
          // Pages
          Obx(() => pages[controller.currentIndex.value]),

          // Floating Navbar at bottom
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Obx(() => _buildFloatingNavBar(controller.currentIndex.value)),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavBar(int currentIdx) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Navbar body
        Container(
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFF424242), // Lighter background
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                index: 0,
                currentIndex: currentIdx,
                onTap: () => controller.changePage(0),
              ),
              _NavItem(
                icon: Icons.sticky_note_2_outlined,
                activeIcon: Icons.sticky_note_2_rounded,
                label: 'Catatan',
                index: 1,
                currentIndex: currentIdx,
                onTap: () => controller.changePage(1),
              ),
              // Center spacer for FAB
              const SizedBox(width: 72),
              _NavItem(
                icon: Icons.bar_chart_outlined,
                activeIcon: Icons.bar_chart_rounded,
                label: 'Grafik',
                index: 2,
                currentIndex: currentIdx,
                onTap: () => controller.changePage(2),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profil',
                index: 3,
                currentIndex: currentIdx,
                onTap: () => controller.changePage(3),
              ),
            ],
          ),
        ),

        // Semi-circle notch behind FAB
        Positioned(
          top: -22,
          child: Container(
            width: 84,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF424242), // Lighter background
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(42),
                topRight: Radius.circular(42),
              ),
            ),
          ),
        ),

        // Green FAB button
        Positioned(
          top: -9, // Lowered to sit inside the notch
          child: GestureDetector(
            onTap: () => controller.toggleFab(),
            child: Obx(() => Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF5CBF7A), Color(0xFF2D6641)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3A6043).withOpacity(0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AnimatedRotation(
                turns: controller.isFabOpen.value ? 0.125 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            )),
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    const activeColor = Color(0xFF4CAF72);
    const inactiveColor = Color(0xFFB0B0B0); // Pastel grey
    final color = isSelected ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        height: 70,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    key: ValueKey<bool>(isSelected),
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: -4, // attached exactly to the bottom edge
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 4.0, // made slightly thicker
                width: isSelected ? 24 : 0,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
