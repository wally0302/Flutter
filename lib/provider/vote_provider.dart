import 'package:flutter/foundation.dart';
import '../model/vote.dart';

class VoteProvider extends ChangeNotifier {
  final List<Vote> _votes = [];
  final List<VoteOption> _options = [];
  final List<VoteResult> _result = [];

  List<Vote> get votes => _votes;
  List<VoteOption> get voteoptions => _options;
  List<VoteResult> get voteresult => _result;

  void addVote(Vote vote) {
    _votes.add(vote);
    notifyListeners();
  }

  void addVoteOptions(VoteOption voteOption) {
    _options.add(voteOption);
    notifyListeners();
  }

  void addVoteResult(VoteResult voteResult) {
    _result.add(voteResult);
    notifyListeners();
  }

  void deleteVote(int index) {
    _votes.removeAt(index);
    notifyListeners();
  }

  void deleteVoteOptions(int index) {
    _votes.removeAt(index);
    notifyListeners();
  }

  // void updateResult(VoteResult voteResult){
  //   _result.update(voteResult);
  //   notifyListeners();
  // }

  void updateVote(
    VoteResult newVoteResult,
    VoteResult oldVoteResult,
  ) {
    final index = _result.indexWhere((result) => result == oldVoteResult);
    print('updateVote called: $index');

    if (index != -1) {
      _result[index] = newVoteResult;
      print('Vote updated: ${_result[index]}');
      notifyListeners();
    } else {
      print('Vote not found in the list');
    }
  }

  // Vote? getVoteById(String id) {
  //   return _votes.firstWhere((vote) => vote.vID == id);
  // }
}
