import 'package:frontend/ui/shared/edge_insect.dart';
import 'package:frontend/ui/shared/spacing.dart';
import 'package:frontend/ui/widgets/all_expenses_card.dart';
import 'package:frontend/ui/widgets/quick_transfer_card.dart';
import 'package:flutter/material.dart';

class ExpensesDetails extends StatelessWidget {
  const ExpensesDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kEdgeInsetsHorizontalTiny,
      child: Column(
        children: const [
          verticalSpaceRegular,
          Expanded(
            flex: 2,
            child: AllExpensesCard(),
          ),
          verticalSpaceSmall,
          Expanded(child: QuickTransferCard()),
        ],
      ),
    );
  }
}
