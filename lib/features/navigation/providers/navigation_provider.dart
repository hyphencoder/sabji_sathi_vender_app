import 'package:flutter_riverpod/legacy.dart';

final navigationProvider = StateNotifierProvider<NavigationNotifier, int>(
  (ref) => NavigationNotifier(),
);

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void changeIndex(int index) {
    if (state != index) {
      state = index;
    }
  }
}
