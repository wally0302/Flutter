// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:create_event2/provider/journey_provider.dart';
import 'package:create_event2/provider/event_provider.dart';

// import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:create_event2/model/journey.dart';
import 'package:create_event2/model/event.dart';
import 'package:create_event2/utils.dart';
import 'package:create_event2/page/journey_viewing_page.dart';

import 'event_viewing_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textController = TextEditingController();
  List<Journey> searchJourneyResults = [];
  List<Event> searchEventResults = [];
  String searchJourneyString = '';
  String searchEventString = '';

  @override
  void initState() {
    super.initState();
    textController.text = '';
    searchJourneyResults.clear();
    searchEventResults.clear();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void updateSearchResults(String keyword) {
      setState(() {
        final journeyProvider =
            Provider.of<JourneyProvider>(context, listen: false);
        final eventProvider =
            Provider.of<EventProvider>(context, listen: false);

        if (keyword.isNotEmpty) {
          final filteredJourneys = journeyProvider.searchJourneys(keyword);
          searchJourneyResults = filteredJourneys;
        } else {
          searchJourneyResults.clear();
        }

        if (keyword.isNotEmpty) {
          final filteredActivities = eventProvider.searchEvent(keyword);
          searchEventResults = filteredActivities;
        } else {
          searchEventResults.clear();
        }
      });
    }

    return Consumer<JourneyProvider>(
      builder: (context, journeyProvider, _) {
        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false, // 隱藏返回鍵

              title: const Text(
                '搜尋',
                style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.w600,
                    color: Colors.black), // 修改标题颜色
              ),
              centerTitle: true,
              // leading: CloseButton(
              //   onPressed: () {
              //     Navigator.pushNamedAndRemoveUntil(
              //       context,
              //       '/MyBottomBar2',
              //       ModalRoute.withName('/'),
              //     );
              //   },
              // ),
              backgroundColor: Color(0xFF4A7DAB), // 修改 AppBar 的背景颜色
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/back.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: textController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                            onPressed: () {
                              textController.clear();
                              setState(() {
                                searchJourneyResults.clear();
                                searchEventResults.clear();
                              });
                            },
                            icon: const Icon(Icons.close)),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        hintText: '關鍵字',
                      ),
                      onChanged: (value) {
                        searchJourneyString = value;
                        searchEventString = value;
                        final cursorPosition = textController.selection;
                        textController.text = value;
                        textController.selection = cursorPosition;
                        updateSearchResults(value);
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: searchJourneyResults.length +
                              searchEventResults.length,
                          itemBuilder: (context, index) {
                            if (index < searchJourneyResults.length) {
                              final journey = searchJourneyResults[index];
                              return buildJourneyTile(journey);
                            } else {
                              final event = searchEventResults[
                                  index - searchJourneyResults.length];
                              return buildEventTile(event);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  ListTile buildJourneyTile(Journey journey) {
    return ListTile(
      title: Text(
        journey.title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(
            '起始時間：${Utils.toDateTime(journey.from)}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            '結束時間：${Utils.toDateTime(journey.to)}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => JourneyViewingPage(journey: journey),
          ),
        );
        setState(() {
          final providerNew =
              Provider.of<JourneyProvider>(context, listen: false);
          final filteredJourneys2 =
              providerNew.searchJourneys(searchJourneyString);
          searchJourneyResults = filteredJourneys2;
        });
      },
    );
  }

  ListTile buildEventTile(Event event) {
    return ListTile(
      title: Text(
        event.title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(
            '起始時間：${Utils.toDateTime(event.from)}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            '結束時間：${Utils.toDateTime(event.to)}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventViewingPage(event: event),
          ),
        );
      },
    );
  }
}
