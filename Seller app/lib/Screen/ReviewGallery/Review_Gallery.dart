import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import '../../Widget/appBar.dart';
import '../../Widget/desing.dart';
import '../ReviewPreview/Review_Preview.dart';

class ReviewGallary extends StatefulWidget {
  final List<dynamic>? imageList;

  const ReviewGallary({super.key, this.imageList});

  @override
  State<ReviewGallary> createState() => _ReviewImageState();
}

class _ReviewImageState extends State<ReviewGallary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        'REVIEW_BY_CUST'.translate(context: context),
        context,
      ),
      body: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        padding: const EdgeInsets.all(20),
        children: List.generate(
          widget.imageList!.length,
          (index) {
            return InkWell(
              child: DesignConfiguration.getCacheNotworkImage(
                boxFit: BoxFit.cover,
                context: context,
                heightvalue: null,
                placeHolderSize: double.maxFinite,
                imageurlString: widget.imageList![index],
                widthvalue: null,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ReviewPreview(
                      index: index,
                      imageList: widget.imageList,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
