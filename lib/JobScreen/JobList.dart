// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../DropdownBloc.dart';
import '../RadioButtonBloc.dart';
import '../ShimmerLoader.dart';
import '../SideBar/SideBar.dart';
import '../asynccallprovider.dart';
import '../bottomnavigation.dart';
import '../constants.dart';
import 'FeatureJobProvider.dart';
import 'FilterScreen.dart';
import 'GetAdvancedSearchProvider.dart';
import 'GetJobListProvider.dart';
import 'JobCard.dart';
import 'JobClass.dart';
import 'JobHeader.dart';
import 'JobLoaderProvider.dart';
import 'SelectFiltersProvider.dart';
import 'SortValueProvider.dart';

class JobList extends StatefulWidget {
  const JobList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  var header;
  int length = 0;
  final _dropdownBloc = DropdownBloc();
  String sortByValue = "";

  final _displayCards = RadioButtonBloc();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  List<String> sortByList = [
    "Sort By",
    "Latest jobs",
    "Oldest jobs",
    "Expiring soon",
    "Expiring later"
  ];
  @override
  void initState() {
    // TODO: implement initState
    getdata(false);
    super.initState();
  }

  @override
  void dispose() {
    _dropdownBloc.dispose();
    Provider.of<GetJobListProvider>(context, listen: false).searchKeyword = "";
    Provider.of<FeatureJobListProvider>(context, listen: false).clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: const Color(0xFFF4F5FD),
      bottomNavigationBar: BottomNavigationClass(1),
      drawer: Drawer(
        child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.57,
            child: const Sidebar()),
      ),
      endDrawer: Drawer(
        child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.57,
            child: const FilterScreen()),
      ),
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<AsyncCallProvider>(context).isinasynccall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(
            backgroundColor: kbackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
        child: LazyLoadScrollView(
          onEndOfPage: () => getdata(true),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JobHeader(
                  isJobDetail: false,
                  scaffoldKey: _scaffoldkey,
                  isPayment: false,
                  numOfNotifications: 2,
                  // Provider.of<NotificationsProvider>(context, listen: false)
                  //     .numberOfNotifications,
                  isTransaction: false,
                ),
                _buildSearchTF(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Row(
                    children: [
                      _buildSortByContainer(),
                      const Spacer(),
                      InkWell(
                        onTap: () => _scaffoldkey.currentState!.openEndDrawer(),
                        child: Row(
                          children: [
                            const Text('Filters'),
                            length != 0 ? Text(' ($length)') : const SizedBox(),
                            const Icon(Icons.arrow_right)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                _displayWidgetArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _displayWidgetArea() {
    return StreamBuilder(
      initialData: true,
      stream: _displayCards.stateRadioButtonStrean,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _displayFeaturedJobs(),
            _displayCountArea(),
            _displayJobs(),
            Provider.of<JobLoaderProvider>(context, listen: false).isinJobLoader
                ? const Center(
                    child: CircularProgressIndicator(
                        backgroundColor: kbackgroundColor,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
                  )
                : const SizedBox()
          ],
        );
      },
    );
  }

  _displayFeaturedJobs() {
    if (Provider.of<FeatureJobListProvider>(context, listen: false)
        .companyId
        .isEmpty) {
      return const SizedBox();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Featured Jobs',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  color: kBluePrimaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _displayList(true),
          ),
        ],
      );
    }
  }

  _displayCountArea() {
    bool showArea = false;
    if (Provider.of<GetJobListProvider>(context, listen: false).isSearch) {
      if (Provider.of<GetJobListProvider>(context, listen: false)
          .updateJobClassData
          .isNotEmpty) {
        showArea = true;
      }
    } else {
      if (Provider.of<GetJobListProvider>(context, listen: false)
          .companyId
          .isNotEmpty) {
        showArea = true;
      }
    }
    if (showArea) {
      return Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Provider.of<GetJobListProvider>(context, listen: false)
                      .isSearch
                  ? Provider.of<GetJobListProvider>(context, listen: false)
                          .updateJobClassData
                          .isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.35,
                              top: 32),
                          child: _displayCount(),
                        )
                      : _displayCount()
                  : Provider.of<GetJobListProvider>(context, listen: false)
                          .companyId
                          .isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.35,
                              top: 32),
                          child: _displayCount(),
                        )
                      : _displayCount()),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  _displayJobs() {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Provider.of<GetJobListProvider>(context, listen: false)
                .companyId
                .isEmpty
            ? Provider.of<AsyncCallProvider>(context, listen: false)
                    .isinasynccall
                ? const ShimmerLoader()
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'No jobs found matching your criteria. Please change your filters.',
                      textAlign: TextAlign.justify,
                    ),
                  )
            : _displayList(false));
  }

  getdata(bool isLoadMore, {bool hasOrderChanged = false}) async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const JobList(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');
    _displayCards.radioValue = true;

    if (Provider.of<FeatureJobListProvider>(context, listen: false)
        .companyId
        .isEmpty) {
      AsyncCallProvider asyncProvider =
          Provider.of<AsyncCallProvider>(context, listen: false);
      if (!Provider.of<AsyncCallProvider>(context, listen: false)
          .isinasynccall) {
        asyncProvider.changeAsynccall();
      }

      FeatureJobListProvider featureJobProvider =
          Provider.of<FeatureJobListProvider>(context, listen: false);
      if (!featureJobProvider.hasbeenCalled) {
        if (!await featureJobProvider.callGetJobListapi(
            header,
            "",
            "",
            Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                .companyId,
            Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                .rankList,
            Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                .vesselType,
            Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                .nationalityId,
            Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                .tentativeJoiningDate,
            Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                .tentativeEndDate,
            Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                .expirationStartDate,
            Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                .expirationEndDate)) {
          displaysnackbar('Something went wrong');
        } else {
          featureJobProvider.hasbeenCalled = true;
        }
      }

      asyncProvider.changeAsynccall();
    }

    print('Value of has more data is');
    print(Provider.of<GetJobListProvider>(context, listen: false).hasMoreData);
    if (Provider.of<GetJobListProvider>(context, listen: false).hasMoreData ||
        hasOrderChanged) {
      if (isLoadMore) {
        Provider.of<GetJobListProvider>(context, listen: false).changeOffset();
      }
      callApi(isLoadMore);
    } else {
      if (Provider.of<GetSelectedFiltersProvider>(context, listen: false)
              .companyId
              .isNotEmpty ||
          Provider.of<GetSelectedFiltersProvider>(context, listen: false)
              .rankList
              .isNotEmpty ||
          Provider.of<GetSelectedFiltersProvider>(context, listen: false)
              .vesselType
              .isNotEmpty ||
          Provider.of<GetSelectedFiltersProvider>(context, listen: false)
              .nationalityId
              .isNotEmpty ||
          Provider.of<GetSelectedFiltersProvider>(context, listen: false)
              .tentativeJoiningDate
              .isNotEmpty ||
          Provider.of<GetSelectedFiltersProvider>(context, listen: false)
              .tentativeEndDate
              .isNotEmpty ||
          Provider.of<GetSelectedFiltersProvider>(context, listen: false)
              .expirationStartDate
              .isNotEmpty ||
          Provider.of<GetSelectedFiltersProvider>(context, listen: false)
              .expirationEndDate
              .isNotEmpty) callApi(isLoadMore);
    }

    print('After load');
  }

  callApi(bool isLoadMore) async {
    length = 0;
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    JobLoaderProvider jobLoadProvider =
        Provider.of<JobLoaderProvider>(context, listen: false);
    print(isLoadMore);
    if (isLoadMore) {
      print('Value is true');
      if (Provider.of<GetJobListProvider>(context, listen: false).hasMoreData) {
        jobLoadProvider.changeJobLoader();
        setState(() {});
      }
    } else {
      if (!Provider.of<AsyncCallProvider>(context, listen: false)
          .isinasynccall) {
        asyncProvider.changeAsynccall();
      }
    }
    GetJobListProvider jobListProvider =
        Provider.of<GetJobListProvider>(context, listen: false);
    if (Provider.of<GetJobListProvider>(context, listen: false)
        .searchKeyword
        .isNotEmpty) {
      _searchController.text =
          Provider.of<GetJobListProvider>(context, listen: false).searchKeyword;
    }
    for (int i = 0;
        i <
            Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                .companyId
                .length;
        i++) {
      length++;
    }
    for (int i = 0;
        i <
            Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                .rankList
                .length;
        i++) {
      length++;
    }
    for (int i = 0;
        i <
            Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                .vesselType
                .length;
        i++) {
      length++;
    }
    for (int i = 0;
        i <
            Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                .nationalityId
                .length;
        i++) {
      length++;
    }
    if (Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .tentativeJoiningDate
        .isNotEmpty) length++;
    if (Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .tentativeEndDate
        .isNotEmpty) length++;
    if (Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .expirationStartDate
        .isNotEmpty) length++;
    if (Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .expirationEndDate
        .isNotEmpty) length++;
    String field = "", sortOder = "";
    if (sortByValue.isEmpty) {
      field = "id";
      sortOder = "asc";
    } else {
      if (sortByList.indexOf(
                  Provider.of<GetSortOrderProvider>(context, listen: false)
                      .sortOrder) ==
              1 ||
          sortByList.indexOf(
                  Provider.of<GetSortOrderProvider>(context, listen: false)
                      .sortOrder) ==
              2) {
        field = "updated_at";
        if (sortByList.indexOf(
                Provider.of<GetSortOrderProvider>(context, listen: false)
                    .sortOrder) ==
            1) {
          sortOder = "desc";
        } else {
          sortOder = "asc";
        }
      } else {
        field = "job_expiration_date";
        if (sortByList.indexOf(
                Provider.of<GetSortOrderProvider>(context, listen: false)
                    .sortOrder) ==
            3) {
          sortOder = "asc";
        } else {
          sortOder = "desc";
        }
      }
    }
    if (!await jobListProvider.callGetJobListapi(
        header,
        field,
        sortOder,
        Provider.of<GetSelectedFiltersProvider>(context, listen: false)
            .companyId,
        Provider.of<GetSelectedFiltersProvider>(context, listen: false)
            .rankList,
        Provider.of<GetSelectedFiltersProvider>(context, listen: false)
            .vesselType,
        Provider.of<GetSelectedFiltersProvider>(context, listen: false)
            .nationalityId,
        Provider.of<GetSelectedFiltersProvider>(context, listen: false)
            .tentativeJoiningDate,
        Provider.of<GetSelectedFiltersProvider>(context, listen: false)
            .tentativeEndDate,
        Provider.of<GetSelectedFiltersProvider>(context, listen: false)
            .expirationStartDate,
        Provider.of<GetSelectedFiltersProvider>(context, listen: false)
            .expirationEndDate,
        isLoadMore)) displaysnackbar('Something went wrong');
    print('Value of load more is');
    print(isLoadMore);

    print('Provider of job value is');
    print(Provider.of<JobLoaderProvider>(context, listen: false).isinJobLoader);
    GetAdvancedSearchProvider advancedSearchProvider =
        Provider.of<GetAdvancedSearchProvider>(context, listen: false);
    if (!await advancedSearchProvider.callGetAdvancedSearchapi(header)) {
      displaysnackbar('Something went wrong');
    }

    if (!isLoadMore) {
      asyncProvider.changeAsynccall();
    } else {
      jobLoadProvider.changeJobLoader();
    }

    if (isLoadMore) setState(() {});
  }

  _buildSortByContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: StreamBuilder(
        stream: _dropdownBloc.stateDropdownStrean,
        builder: (context, dropdownsnapshot) {
          print(dropdownsnapshot.data);
          return Padding(
              padding: const EdgeInsets.only(left: 0),
              child: DropdownButton<String>(
                items: sortByList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: dropdownsnapshot.data == null
                    ? sortByList[0]
                    : _dropdownBloc.dropdownvalue,
                underline: Container(),
                hint: const Text('Sort By'),
                onChanged: (value) {
                  print(value);
                  if (value == sortByList[0]) {
                    Provider.of<GetSortOrderProvider>(context, listen: false)
                        .sortOrder = sortByValue = "";
                  } else {
                    Provider.of<GetSortOrderProvider>(context, listen: false)
                        .sortOrder = (sortByValue = value!);
                  }
                  _dropdownBloc.setdropdownvalue(value);
                  _dropdownBloc.eventDropdownSink.add(DropdownAction.Update);
                  //toggleDropdown.toggleDropDownVisibility();
                  getdata(false, hasOrderChanged: true);
                },
              ));
        },
      ),
    );
  }

  _buildSearchTF() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,
          child: TextFormField(
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
            ],
            cursorColor: kgreenPrimaryColor,
            controller: _searchController,
            keyboardType: TextInputType.name,
            style: const TextStyle(
              color: kblackPrimaryColor,
              fontFamily: 'OpenSans',
            ),
            onChanged: (value) {
              print(value);
              onsearchChangd(value);
              Provider.of<GetJobListProvider>(context, listen: false)
                  .searchKeyword = value;
              return;
            },
            validator: (value) {
              return null;
            },
            decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(),
                ),
                hintText: 'Search by company name',
                hintStyle: hintstyle),
          ),
        ),
      ),
    );
  }

  void onsearchChangd(String value) {
    print(value);
    List<JobClass> searchResult =
        Provider.of<GetJobListProvider>(context, listen: false)
                .updateJobClassData =
            Provider.of<GetJobListProvider>(context, listen: false)
                .jobClassData
                .where((m) => (m.companyName
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase())))
                .toList();
    print(searchResult);
    if (searchResult.isNotEmpty) {
      Provider.of<GetJobListProvider>(context, listen: false)
          .changeSearch(true);
    } else {
      Provider.of<GetJobListProvider>(context, listen: false)
          .changeSearch(false);
      clearSearchData();
    }

    _displayCards.eventRadioButtonSink.add(RadioButtonAction.False);
    _displayCards.eventRadioButtonSink.add(RadioButtonAction.True);
  }

  _displayList(bool isFeatured) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: isFeatured
            ? Provider.of<FeatureJobListProvider>(context, listen: false)
                .companyId
                .length
            : Provider.of<GetJobListProvider>(context, listen: false).isSearch
                ? Provider.of<GetJobListProvider>(context, listen: false)
                    .updateJobClassData
                    .length
                : Provider.of<GetJobListProvider>(context, listen: false)
                    .companyId
                    .length,
        itemBuilder: (context, index) => JobCard(
          index: index,
          isFeatured: isFeatured,
        ),
      ),
    );
  }

  void clearSearchData() {
    Provider.of<GetJobListProvider>(context, listen: false)
        .updateJobClassData
        .clear();
  }

  _displayCount() {
    return Row(
      children: [
        Text(Provider.of<GetJobListProvider>(context, listen: false).isSearch
            ? Provider.of<GetJobListProvider>(context, listen: false)
                .updateJobClassData
                .length
                .toString()
            : Provider.of<GetJobListProvider>(context, listen: false)
                .companyId
                .length
                .toString()),
        const Text(' jobs found'),
        const Spacer(),
        Container(
          width: MediaQuery.of(context).size.width * 0.07,
          height: MediaQuery.of(context).size.width * 0.07,
          decoration: const ShapeDecoration(
              shape: CircleBorder(), color: kbackgroundColor),
          child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Center(
                child: Text(
                  'R',
                  style: TextStyle(
                      color: kBluePrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.045),
                ),
              )),
        ),
        const SizedBox(width: 5),
        const Text(' - Refer Jobs')
      ],
    );
  }
}
