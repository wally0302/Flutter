import 'package:flutter/foundation.dart';
import 'package:create_event2/model/event.dart';
import 'package:create_event2/model/friend.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [];

  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Event> get eventOfSelectedDate => _events;

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  void deleteEvent(Event event) {
    _events.remove(event);
    notifyListeners();
  }

  void editEvent(Event newEvent, Event oldEvent) {
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;
    notifyListeners();
  }

  List<Event> searchEvent(String keyword) {
    return _events
        .where((event) =>
            event.title.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  List<Event> getEvents() {
    return List.from(_events);
  }

  void updateEvents(List<Event> updatedEvents) {
    _events.clear();
    _events.addAll(updatedEvents);
    notifyListeners();
  }

  void addSortedEvent(Event event) {
    _events.add(event);
    _events.sort((a, b) {
      int startComparison = a.from.compareTo(b.from);
      if (startComparison != 0) {
        return startComparison;
      } else {
        int startTimeComparison = a.from.compareTo(b.from);
        if (startTimeComparison != 0) {
          return startTimeComparison;
        } else {
          int endComparison = a.to.compareTo(b.to);
          return endComparison;
        }
      }
    });
    notifyListeners();
  }

  void sortEventList() {
    _events.sort((a, b) {
      int startComparison = a.from.compareTo(b.from);
      if (startComparison != 0) {
        return startComparison;
      } else {
        int startTimeComparison = a.from.compareTo(b.from);
        if (startTimeComparison != 0) {
          return startTimeComparison;
        } else {
          int endComparison = a.to.compareTo(b.to);
          return endComparison;
        }
      }
    });
  }
}
