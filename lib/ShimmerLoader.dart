import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.white10,
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  );
                }),
          ),
        ));
  }
}
