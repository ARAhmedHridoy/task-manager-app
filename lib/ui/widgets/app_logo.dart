import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_management/ui/utils/assets_path.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(AssetsPath.logo, width: 100);
  }
}
