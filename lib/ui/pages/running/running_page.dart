import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sprinchat_app/core/viewmodel/user_viewmodel/user_viewmodel.dart';
import 'package:flutter_sprinchat_app/ui/pages/result/result_page.dart';
import 'package:flutter_sprinchat_app/ui/pages/running/running_view_model.dart';
import 'package:flutter_sprinchat_app/ui/pages/running/widgets/running_analysis.dart';
import 'package:flutter_sprinchat_app/ui/pages/running/widgets/button_view_model.dart';
import 'package:flutter_sprinchat_app/ui/pages/running/widgets/running_button.dart';
import 'package:flutter_sprinchat_app/ui/pages/running/widgets/unavailable_navigationbar.dart';
import 'package:flutter_sprinchat_app/ui/widgets/navigation_bar.dart';
import 'package:lottie/lottie.dart';

class RunningPage extends ConsumerStatefulWidget {
  RunningPage({super.key, required this.currentLocation});

  bool isRunning = false;
  String currentLocation;

  @override
  RunningPageState createState() => RunningPageState();
}

class RunningPageState extends ConsumerState<RunningPage> {
  bool isRunning = false;

  late final userId;
  late final runningButton;
  late final running;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    userId = ref.read(userViewModelProvider);
    runningButton = ref.read(buttonViewModel.notifier); // 러닝 버튼 UI 관리용 뷰모델
    running = ref.read(runningViewModel.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer(
            builder: (context, ref, child) {
              // 카카오맵 트랙킹 뷰모델
              return Column(
                children: [
                  // 상단 '러닝' 문구
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '러닝',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  // 지도 및 러닝 시작 버튼
                  SizedBox(
                    height: 320,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        SizedBox(
                          height: 200,
                          child: Lottie.asset('assets/json/lottie.json'),
                        ),
                        // 러닝 시작 버튼
                        Positioned(
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              // 러닝 시작
                              if (!isRunning) {
                                isRunning = true;
                                runningButton.startRunning();
                                running.setLocation(); // 시작 위치 설정
                                running.startRunning(
                                    DateTime.now()); // 현재 시간으로 시작 시간 설정해서 러닝 시작
                              } else {
                                isRunning = false;
                                runningButton.stopRunning();
                                RunningState result = running.endRunning();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResultPage(
                                        analysis: result, userId: userId),
                                  ),
                                );
                              }
                            },
                            // 버튼 디자인
                            child: RunningButton(
                                ref.watch(buttonViewModel).isRunning),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  // 러닝 분석 정보 표시
                  RunningAnalysis(),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: !ref.watch(buttonViewModel).isRunning
          ? CustomNavigationBar(currentPage: 'running')
          : UnavailableNavigationbar(currentPage: 'running'),
    );
  }
}
