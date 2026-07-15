import 'package:deliveryboy_multivendor/Helper/assetsConstant.dart';
import 'package:deliveryboy_multivendor/Screens/Home/Widget/getOrderIteam.dart';
import 'package:flutter/material.dart';
import '../../../Widget/parameterString.dart';

class DetailHeader extends StatelessWidget {
  final Function update;
  DetailHeader({
    Key? key,
    required this.update,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
        left: 10,
        right: 15,
      ),
      child: SizedBox(
        width: deviceWidth,
        height: 80,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            CommanDesingWidget(
              index: 0,
              title: 'ORDERS',
              update: update,
              imagetitle: Assets.orders,
            ),
            CommanDesingWidget(
              index: 3,
              title: 'assigned',
              update: update,
              imagetitle: Assets.assigned,
            ),
            CommanDesingWidget(
              index: 4,
              title: 'shipped',
              update: update,
              imagetitle: Assets.shipped,
            ),
            CommanDesingWidget(
              index: 5,
              title: 'delivered',
              update: update,
              imagetitle: Assets.delivered,
            ),
          ],
        ),
      ),
    );
  }
}
