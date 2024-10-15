import 'package:flutter/material.dart';
import 'package:qenan/features/auth/signup/presentation/screens/personalizationScreen.dart';
import 'package:qenan/features/auth/signup/presentation/screens/profilePictureScreen.dart';
import 'package:qenan/features/auth/signup/presentation/widgets/stepProgress.dart';

class UserInfo extends StatefulWidget {
  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  PageController _controller = PageController(initialPage: 0);
  double _currentPage = 0.5;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: StepProgress(currentStep: _currentPage, steps: 2),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _controller,
              children: [
                ProfilePictureScreen(
                  pageController: _controller,
                ),
                PersonalizationScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
