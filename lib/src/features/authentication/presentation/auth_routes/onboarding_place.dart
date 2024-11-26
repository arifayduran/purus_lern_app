import 'package:flutter/material.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/log_onboarding_done_or_skiped.dart';
import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/onboarding_status_sharedpref.dart';
import 'package:purus_lern_app/src/features/authentication/data/login_conditions.dart';
import 'package:purus_lern_app/src/features/authentication/domain/onboarding_place_model.dart';

class OnboardingPlace extends StatefulWidget {
  const OnboardingPlace(
      {super.key, required this.transitionToRoute, required this.pages});

  final void Function(String route) transitionToRoute;
  final List<OnboardingPlaceModel> pages;

  @override
  State<OnboardingPlace> createState() => _OnboardingPlaceState();
}

class _OnboardingPlaceState extends State<OnboardingPlace> {
  int _currentPage = 0;

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      color: widget.pages[_currentPage].bgColor,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.pages.length,
              onPageChanged: (idx) {
                setState(() {
                  _currentPage = idx;
                });
              },
              itemBuilder: (context, idx) {
                final item = widget.pages[idx];
                return Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: item.content,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 280),
                            padding: const EdgeInsets.symmetric(vertical: 13.0),
                            child: Text(
                              item.description,
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.pages
                .map((item) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width:
                          _currentPage == widget.pages.indexOf(item) ? 30 : 7,
                      height: 7,
                      margin: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                    ))
                .toList(),
          ),
          SizedBox(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () async {
                        await OnboardingStatusSharedpref()
                            .setOnboardingStatusSharedpref(false);
                        debugPrint("-------------");
                        debugPrint("isOnboardingNotComplete: false");
                        debugPrint("-------------");
                        await logOnboardingSkipped();
                        if (isBiometricsConfigured) {
                          widget.transitionToRoute("Biometric");
                        } else {
                          widget.transitionToRoute('Login');
                        }
                      },
                      child: const Text(
                        "Überspringen",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )),
                  TextButton(
                    onPressed: () async {
                      if (_currentPage == widget.pages.length - 1) {
                        await OnboardingStatusSharedpref()
                            .setOnboardingStatusSharedpref(false);
                        debugPrint("-------------");
                        debugPrint("isOnboardingNotComplete: false");
                        debugPrint("-------------");
                        await logOnboardingDone();
                        if (isBiometricsConfigured) {
                          widget.transitionToRoute("Biometric");
                        } else {
                          widget.transitionToRoute('Login');
                        }
                      } else {
                        _pageController.animateToPage(_currentPage + 1,
                            curve: Curves.easeInOutCubic,
                            duration: const Duration(milliseconds: 250));
                      }
                    },
                    child: Text(
                      _currentPage == widget.pages.length - 1
                          ? "Zur Anmeldung"
                          : "Weiter",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
