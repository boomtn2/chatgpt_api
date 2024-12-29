import 'package:flutter/widgets.dart';

extension SizedBoxE on num {
  Widget get sw => SizedBox(
        width: toDouble(),
      );
  Widget get sh => SizedBox(
        height: toDouble(),
      );
}
