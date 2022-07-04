// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'FeatureJobProvider.dart';
import 'GetJobListProvider.dart';
import 'JobDetail.dart';

class JobCard extends StatelessWidget {
  int index;
  bool isFeatured;

  JobCard({Key? key, required this.index, required this.isFeatured})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      color:
          isFeatured ? const Color.fromRGBO(213, 233, 237, 1) : Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => JobDetail(
                  companyId: checkCompanyId(context),
                ))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _displayCompanyName(context),
            _displaySubHeading(
                'Ranks',
                isFeatured
                    ? Provider.of<FeatureJobListProvider>(context,
                            listen: false)
                        .rankList[index]
                    : Provider.of<GetJobListProvider>(context, listen: false)
                            .isSearch
                        ? Provider.of<GetJobListProvider>(context,
                                listen: false)
                            .updateJobClassData[index]
                            .rankList
                        : Provider.of<GetJobListProvider>(context,
                                listen: false)
                            .rankList[index],
                context),
            _displaySubHeading(
                'Vessel Types',
                isFeatured
                    ? Provider.of<FeatureJobListProvider>(context,
                            listen: false)
                        .vesselType[index]
                    : Provider.of<GetJobListProvider>(context, listen: false)
                            .isSearch
                        ? Provider.of<GetJobListProvider>(context,
                                listen: false)
                            .updateJobClassData[index]
                            .vesselList
                        : Provider.of<GetJobListProvider>(context,
                                listen: false)
                            .vesselType[index],
                context),
            Container(
              width: 800,
              height: 0.4,
              color: Colors.grey,
            ),
            _displayExpirationContainer(
                isFeatured
                    ? Provider.of<FeatureJobListProvider>(context,
                            listen: false)
                        .jobExpirationDate[index]
                    : Provider.of<GetJobListProvider>(context, listen: false)
                            .isSearch
                        ? Provider.of<GetJobListProvider>(context,
                                listen: false)
                            .updateJobClassData[index]
                            .jobExpiration
                        : Provider.of<GetJobListProvider>(context,
                                listen: false)
                            .jobExpirationDate[index],
                isFeatured
                    ? Provider.of<FeatureJobListProvider>(context,
                            listen: false)
                        .isApplied[index]
                    : Provider.of<GetJobListProvider>(context, listen: false)
                            .isSearch
                        ? Provider.of<GetJobListProvider>(context,
                                listen: false)
                            .updateJobClassData[index]
                            .isApplied
                        : Provider.of<GetJobListProvider>(context,
                                listen: false)
                            .isApplied[index])
          ],
        ),
      ),
    );
  }

  checkCompanyId(BuildContext context) {
    return isFeatured
        ? Provider.of<FeatureJobListProvider>(context, listen: false)
            .companyId[index]
        : Provider.of<GetJobListProvider>(context, listen: false).isSearch
            ? Provider.of<GetJobListProvider>(context, listen: false)
                .updateJobClassData[index]
            : Provider.of<GetJobListProvider>(context, listen: false)
                .companyId[index];
  }

  _displayCompanyName(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.14,
            height: MediaQuery.of(context).size.width * 0.14,
            decoration: const ShapeDecoration(
                shape: CircleBorder(), color: Colors.white),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isFeatured
                    ? showImage(context)
                    : Provider.of<GetJobListProvider>(context, listen: false)
                            .isReferJob[index]
                        ? showReferContainer(context)
                        : showImage(context)),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            isFeatured
                ? Provider.of<FeatureJobListProvider>(context, listen: false)
                    .companyName[index]
                : Provider.of<GetJobListProvider>(context, listen: false)
                        .isSearch
                    ? Provider.of<GetJobListProvider>(context, listen: false)
                        .updateJobClassData[index]
                        .companyName
                    : Provider.of<GetJobListProvider>(context, listen: false)
                        .companyName[index],
            style: TextStyle(
                color: kBluePrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.04),
          ),
        ),
      ],
    );
  }

  showImage(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
          shape: const CircleBorder(),
          image: DecorationImage(fit: BoxFit.cover, image: chooseImage(context))
          // isFeatured
          //     ? Provider.of<FeatureJobListProvider>(context, listen: false)
          //                 .companyLogo[index].isNotEmpty
          //         ? NetworkImage('$imageapiurl/company_logo/${Provider.of<FeatureJobListProvider>(context,
          //                     listen: false)
          //                 .companyLogo[index]}')
          //         : const AssetImage('images/user.jpg')
          //     : Provider.of<GetJobListProvider>(context, listen: false)
          //                 .companyLogo[index].isNotEmpty
          //         ? NetworkImage('$imageapiurl/company_logo/${Provider.of<GetJobListProvider>(context, listen: false)
          //                 .companyLogo[index]}')
          //         : const AssetImage('images/user.jpg')),
          ),
    );
  }

  chooseImage(BuildContext context) {
    return isFeatured
        ? Provider.of<FeatureJobListProvider>(context, listen: false)
                .companyLogo[index]
                .isNotEmpty
            ? NetworkImage(
                '$imageapiurl/company_logo/${Provider.of<FeatureJobListProvider>(context, listen: false).companyLogo[index]}')
            : const AssetImage('images/user.jpg')
        : Provider.of<GetJobListProvider>(context, listen: false)
                .companyLogo[index]
                .isNotEmpty
            ? NetworkImage(
                '$imageapiurl/company_logo/${Provider.of<GetJobListProvider>(context, listen: false).companyLogo[index]}')
            : const AssetImage('images/user.jpg');
  }

  showReferContainer(BuildContext context) {
    return Center(
      child: Text(
        'R',
        style: TextStyle(
            color: kBluePrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.055),
      ),
    );
  }

  _displaySubHeading(String label, String list, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: kblackPrimaryColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _shoDot(),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.79,
                    child: Text(list))
              ],
            ),
          )
        ],
      ),
    );
  }

  _shoDot() {
    return Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: kgreenPrimaryColor,
      ),
    );
  }

  _displayExpirationContainer(String expirydate, bool isApplied) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2, left: 2.3, right: 2.3),
      child: Container(
        color: isFeatured
            ? const Color.fromRGBO(213, 233, 237, 1)
            : Colors.grey[50],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Text('Expiration: $expirydate'),
              const Spacer(),
              // isApplied
              //     ? Container(
              //         decoration: BoxDecoration(
              //             border: Border.all(
              //               color: kgreenPrimaryColor,
              //             ),
              //             color: kgreenPrimaryColor,
              //             borderRadius: BorderRadius.all(Radius.circular(20))),
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 10, vertical: 4),
              //           child: Text(
              //             'Applied',
              //             style: TextStyle(color: kbackgroundColor),
              //           ),
              //         ))
              //     : SizedBox(),
              // SizedBox(
              //   width: 5,
              // ),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: kgreenPrimaryColor,
                      ),
                      color: kgreenPrimaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.double_arrow,
                      color: kbackgroundColor,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
