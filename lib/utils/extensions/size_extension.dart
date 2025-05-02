import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizingExtension on num {
  double get csp => this * 0.94.sp;
  double get ch => this * 0.95.h;
  double get cw => this * 0.95.w;
  double get cr => this * 0.95.r;
}
