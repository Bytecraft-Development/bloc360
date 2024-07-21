import 'package:flutter/material.dart';
import '../../../constants/layout_constants.dart';
import '../../../constants/responsive.dart';
import '../../../models/big_decimal.dart';
import 'analytic_cards.dart';
import 'custom_appbar.dart';
import 'discussions.dart';
import 'top_referals.dart';
import 'users.dart';
import 'users_by_device.dart';
import 'viewers.dart';

class DashboardContent extends StatelessWidget {
  final BigDecimal? totalPaymentAmount;
  final int? numberOfHouseholds;

  const DashboardContent({Key? key, this.totalPaymentAmount, this.numberOfHouseholds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(appPadding),
        child: Column(
          children: [
            CustomAppbar(),
            SizedBox(
              height: appPadding,
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          AnalyticCards(),
                          SizedBox(
                            height: appPadding,
                          ),
                          Users(),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) Discussions(),
                            Text('Total Payment Amount: $totalPaymentAmount'),
                            Text('Number of Households: $numberOfHouseholds'),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(
                        width: appPadding,
                      ),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: Discussions(),
                      ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          SizedBox(
                            height: appPadding,
                          ),
                          Row(
                            children: [
                              if (!Responsive.isMobile(context))
                                Expanded(
                                  child: TopReferals(),
                                  flex: 2,
                                ),
                              if (!Responsive.isMobile(context))
                                SizedBox(width: appPadding),
                              Expanded(
                                flex: 3,
                                child: Viewers(),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          SizedBox(
                            height: appPadding,
                          ),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) TopReferals(),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) UsersByDevice(),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(
                        width: appPadding,
                      ),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: UsersByDevice(),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}