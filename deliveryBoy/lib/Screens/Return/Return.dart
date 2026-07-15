import 'package:deliveryboy_multivendor/Cubit/returnOrderCubit.dart';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/controller.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Model/ReturnOrderModel.dart';
import 'package:deliveryboy_multivendor/Screens/Return/Widget/orderCard.dart';
import 'package:deliveryboy_multivendor/Widget/appBar.dart';
import 'package:deliveryboy_multivendor/Widget/errorContainer.dart';
import 'package:deliveryboy_multivendor/Widget/translateVariable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReturnOrder extends StatefulWidget {
  const ReturnOrder({Key? key}) : super(key: key);

  @override
  State<ReturnOrder> createState() => _ReturnOrderState();
}

class _ReturnOrderState extends State<ReturnOrder> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _pageScrollController = ScrollController();
  FetchReturnOrderSuccess? successState;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _fetchOrders();
    });

    _pageScrollController.pageEndListener(() {
      _fetchOrders(isScrollTriggered: true);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageScrollController.dispose();

    super.dispose();
  }

  void _fetchOrders({bool isScrollTriggered = false}) {
    context.read<FetchReturnOrderCubit>().fetchReturnOrders(
          isScrollTriggered: isScrollTriggered,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightWhite,
      key: _scaffoldKey,
      appBar: GradientAppBar(
        RETURN.translate(context: context),
        customback: false,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          _fetchOrders();
          return Future.value();
        },
        child: SizedBox(
          height: double.maxFinite,
          child: SingleChildScrollView(
            controller: _pageScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<FetchReturnOrderCubit, FetchReturnOrderState>(
                  builder: (context, state) {
                    if (state is FetchReturnOrderInProgress) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: CircularProgressIndicator(
                            color: primary,
                          ),
                        ),
                      );
                    }

                    if (state is FetchReturnOrderFail) {
                      return ErrorContainer(
                          onTapRetry: () {},
                          errorMessage: "something Error Please Try again...!"
                              .translate(context: context));
                    }
                    if (state is FetchReturnOrderSuccess) {
                      if (state.result.orders.isEmpty) {
                        return Center(
                          child: Text(
                            'No Data Found'.translate(context: context),
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(12),
                            itemCount: state.result.orders.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 8,
                            ),
                            itemBuilder: (context, index) {
                              ReturnOrderModel order =
                                  state.result.orders[index];
                              return OrderCard(
                                order: order,
                              );
                            },
                          ),
                          if (state.loadingMore) ...[
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: CircularProgressIndicator(
                                  color: primary,
                                ),
                              ),
                            ),
                          ] else if (state.loadingMoreError) ...[
                            Center(
                                child: Text(
                                    "something Error Please Try again...!"
                                        .translate(context: context))),
                          ]
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
