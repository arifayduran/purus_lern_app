import 'package:flutter/material.dart';

ValueNotifier<bool> loadingValueNotifierBlur = ValueNotifier<bool>(false);
ValueNotifier<double> loadingValueNotifierBlurOpacity =
    ValueNotifier<double>(0.3);
ValueNotifier<bool> loadingValueNotifierAnimation = ValueNotifier<bool>(false);
ValueNotifier<String> loadingValueNotifierText = ValueNotifier<String>("");
