import 'package:flutter/foundation.dart';
import '../model/vote.dart';

class VoteProvider extends ChangeNotifier {
  final List<Vote> _votes = [];

  List<Vote> get votes => _votes;

  void addVote(Vote vote) {
    _votes.add(vote);
    notifyListeners();
  }

  void deleteVote(int index) {
    _votes.removeAt(index);
    notifyListeners();
  }

  void updateVote(Vote newVote, Vote oldVote) {
    final index = _votes.indexWhere((vote) => vote == oldVote);
    print('updateVote called: $index');

    if (index != -1) {
      _votes[index] = newVote;
      print('Vote updated: ${_votes[index]}');
      notifyListeners();
    } else {
      print('Vote not found in the list');
    }
  }

  Vote? getVoteById(String id) {
    return _votes.firstWhere((vote) => vote.id == id);
  }
}
