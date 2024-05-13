import 'package:frontend/responsive.dart';
import 'package:frontend/ui/shared/colors.dart';
import 'package:frontend/ui/shared/spacing.dart';
import 'package:frontend/ui/shared/text_styles.dart';
import 'package:frontend/views/main/main_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MainHeader extends ViewModelWidget<MainViewModel> {
  const MainHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, viewModel) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: kBlackColor,
            ),
            onPressed: viewModel.controlMenu,
          ),
        horizontalSpaceSmall,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Welcome back,',
              style: kBodyRegularTextStyle,
            ),
            Text(
              'Ayomide Ajibade',
              style: kHeading3TextStyle,
            ),
          ],
        ),
        const Spacer(),
        const Icon(
          Icons.mark_email_unread,
          color: kSecondaryColor4,
        ),
        horizontalSpaceSmall,
        const Icon(
          Icons.notifications_outlined,
          color: kSecondaryColor4,
        ),
        horizontalSpaceSmall,
        const CircleAvatar(
          radius: 15,
          backgroundImage: AssetImage('assets/images/google.png'),
        ),
      ],
    );
  }
}
