// ignore_for_file: must_be_immutable, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartseaman/SearchTextProvider.dart';

import 'ResumeBuilder/PersonalInformation/IndosNoBloc.dart';

class SearchController extends StatelessWidget {
  late String hintText;
  late TextEditingController searchController = TextEditingController();
  final List<String> _searchResult = [];
  late List<String> originalList = [];
  late IndosNoBloc showDropDownBloc;
  ValueChanged<String>? update;
  SearchController(
      {Key? key,
      required this.hintText,
      required this.searchController,
      required this.originalList,
      required this.showDropDownBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
      controller: searchController,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          hintText: hintText,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)))),
      onChanged: (value) {
        print(value);
        onSearchTextChanged(value, context);
      },
    );
  }

  onSearchTextChanged(String text, BuildContext context) async {
    List<String> newList =
        originalList.map((email) => email.toLowerCase()).toList();
    _searchResult.clear();

    for (var userDetail in newList) {
      if (userDetail.contains(text.toLowerCase())) {
        userDetail = userDetail[0].toUpperCase() + userDetail.substring(1);
        _searchResult.add(userDetail);
      }
    }

    Provider.of<SearchChangeProvider>(context, listen: false).searchList =
        _searchResult;

    if (text.isNotEmpty && _searchResult.isEmpty) {
      Provider.of<SearchChangeProvider>(context, listen: false).noDataFound =
          true;
    } else if (text.isEmpty) {
      Provider.of<SearchChangeProvider>(context, listen: false).searchList =
          originalList;
      Provider.of<SearchChangeProvider>(context, listen: false).noDataFound =
          false;
    } else {
      Provider.of<SearchChangeProvider>(context, listen: false).noDataFound =
          false;
    }
    print(Provider.of<SearchChangeProvider>(context, listen: false).searchList);
    Provider.of<SearchChangeProvider>(context, listen: false).searchKeyword =
        text;

    showDropDownBloc.eventIndosNoSink.add(IndosNoAction.False);
    showDropDownBloc.eventIndosNoSink.add(IndosNoAction.True);
  }
}
