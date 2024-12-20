import 'package:flutter/material.dart';
import 'package:flutter_sprinchat_app/ui/pages/myhome/my_home.dart';
import 'package:flutter_sprinchat_app/ui/pages/presenchatpage/presenchatpage.dart';
import 'package:flutter_sprinchat_app/ui/pages/running/running_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 홈-PresentPage-러닝 페이지 하단에 비치한 bottomNavigationbar
class CustomNavigationBar extends ConsumerWidget {
  final String currentPage;

  const CustomNavigationBar({
    super.key,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: Icons.home_filled,
              label: 'Home',
              isSelected: currentPage == 'home',
              onTap: () {
                if (currentPage != 'home') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHome()),
                  );
                }
              },
            ),
            _buildNavItem(
              context: context,
              icon: Icons.chat_bubble,
              label: 'Chat',
              isSelected: currentPage == 'chat',
              onTap: () {
                if (currentPage != 'chat') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Presenchatpage(),
                    ),
                  );
                }
              },
            ),
            _buildNavItem(
              context: context,
              icon: Icons.directions_run,
              label: 'Running',
              isSelected: currentPage == 'running',
              onTap: () {
                if (currentPage != 'running') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RunningPage(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // 네비게이션 바 아이템 빌드(빈 공간을 터치해도 작동)
  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: isSelected
              ? BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 24,
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
