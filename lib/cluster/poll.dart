part of lidea.cluster;

/// The implementation of [Poll].
class ClusterPoll {
  late ClusterDocket _docket;
  final List<PollBoard> listOfPoll = [];
  late String tokenId = '';

  ClusterPoll(ClusterDocket docket) {
    _docket = docket;
  }

  Iterable<TokenType> get session => _docket.env.getSession;

  bool get hasSession => session.isNotEmpty;

  // read local
  Future<void> init() async {
    await _openPoll();
    for (var poll in listOfPoll) {
      if (poll.data.files.isEmpty) {
        await poll.readLocal();
      }
    }
  }

  /// Read local
  Future<void> readLocalAll() async {
    for (var poll in listOfPoll) {
      await poll.readLocal();
    }
  }

  /// Read live (Update every polls)
  Future<void> readLiveAll() async {
    for (var poll in listOfPoll) {
      await poll.readLive();
    }
  }

  /// Update token
  Future<void> updateToken() async {
    await _docket.updateToken(force: true);
    await _openPoll();
  }

  Future<void> _openPoll() async {
    for (var gist in session) {
      int index = listOfPoll.indexWhere((e) => e.gist.token.id == gist.id);
      if (index == -1) {
        listOfPoll.add(PollBoard(
          gist: _docket.env.openGistData(gist.id),
        ));
      }
    }
  }

  /// List of available Polls for current user
  List<PollBoard> listOfUserPollBoard(String email) {
    if (email.isEmpty) {
      return [];
    }
    return listOfPoll.where((poll) {
      return poll.member.where((member) => member.email == email).isNotEmpty;
    }).toList();
  }

  PollBoard get pollBoard {
    return listOfPoll.firstWhere((e) => e.gist.token.id == tokenId);
  }
}

class PollBoard {
  final GistData gist;

  /// user selected candidate
  final List<int> selection = [];
  late GistFileListType data = GistFileListType();

  PollBoard({required this.gist});

  String get _fileName => '${gist.token.id}.json';

  int get _indexMember {
    return data.files.indexWhere((e) => e.file.endsWith('-member.csv'));
    // return data.files.where((e) => e.file.endsWith('-member.csv'));
  }

  int get _indexResult {
    return data.files.indexWhere((e) => e.file.endsWith('-result.csv'));
  }

  int get _indexInfo {
    return data.files.indexWhere((e) => e.file.endsWith('-info.json'));
  }

  Future<void> init() async {}

  /// read local json
  Future<void> readLocal() async {
    await UtilDocument.readAsJSON(_fileName).then((value) {
      data = GistFileListType.fromJSON(value);
    }).catchError((e) async {
      debugPrint('poll-10: $e');
      await readLive();
    }).onError((error, stackTrace) {
      debugPrint('poll-11: $error');
    });
  }

  /// read live json
  Future<void> readLive() async {
    await gist.listFile().then((response) async {
      await response.save(_fileName);
      // debugPrint(response.files.map((e) => e.content).toString());
      data = response;
    }).catchError((e) {
      debugPrint('poll-12: $e');
    });
  }

  /// read `*-member.csv`
  List<PollMemberType> get member {
    if (_indexMember >= 0) {
      return data.files.elementAt(_indexMember).parseCSV2JSON().map<PollMemberType>((e) {
        return PollMemberType.fromJSON(e);
      }).toList();
    }
    return [];
  }

  /// read `*-result.csv`
  List<PollResultType> get result {
    if (_indexResult >= 0) {
      return data.files.elementAt(_indexResult).parseCSV2JSON().map<PollResultType>((e) {
        return PollResultType.fromJSON(e);
      }).toList();
    }
    return [];
  }

  /// read `*-info.json`
  PollInfoType get info {
    if (_indexInfo >= 0) {
      final json = data.files.elementAt(_indexInfo).parseContent2JSON<Map<String, dynamic>>();
      return PollInfoType.fromJSON(json);
    }
    return PollInfoType.empty;
  }

  // int userId = 99, List<int> candidateId = const [1, 2, 3, 7, 10, 8, 9]
  Future<void> postVote(int userId) async {
    // get fresh data from live
    await readLive();

    if (_indexResult >= 0) {
      final result = data.files.elementAt(_indexResult);

      final rawAlter = result.parseCSV2JSON().map<PollResultType>((e) {
        return PollResultType.fromJSON(e);
      }).toList();

      for (var row in rawAlter) row.memberId.removeWhere((e) => e == userId);

      rawAlter.removeWhere((e) => e.memberId.isEmpty);

      for (var candidate in selection) {
        final index = rawAlter.indexWhere((e) => e.candidateId == candidate);
        if (index >= 0) {
          final prev = rawAlter[index];
          if (!prev.memberId.contains(userId)) {
            prev.memberId.add(userId);
          }
          rawAlter[index] = PollResultType(
            candidateId: candidate,
            memberId: prev.memberId,
            rank: prev.memberId.length,
          );
        } else {
          rawAlter.add(PollResultType(
            candidateId: candidate,
            memberId: [userId],
            rank: 1,
          ));
        }
      }

      String csv = [rawAlter.first.header, ...rawAlter.map((e) => e.csv)].join('\n');
      await gist.updateFile<Map<String, dynamic>>(file: result.file, content: csv).then(
        (res) async {
          data = gist.gistFileList(res);
          await data.save(_fileName);

          final index = data.files.indexWhere((e) => e.file.endsWith('-result.csv'));
          if (index >= 0) {
            final raw = data.files.elementAt(index);
            final rawUpdate = raw.parseCSV2JSON().map<PollResultType>((e) {
              return PollResultType.fromJSON(e);
            }).toList();
            final verifyLimit = selection.where((id) {
              return rawUpdate.where((e) {
                return e.candidateId == id && e.memberId.contains(userId);
              }).isNotEmpty;
            }).length;
            if (verifyLimit == info.limit) {
              selection.clear();
            }
          }
        },
      ).catchError((e) {
        debugPrint('poll-13: $e');
      });
    }
  }

  List<PollMemberType> listOfCandidate() {
    return member.where((e) => e.isCandidate).toList();
  }

  List<PollResultType> listOfResult() {
    final e = result.toList();
    e.sort((a, b) => b.rank.compareTo(a.rank));
    return e;
  }

  int memberId(String email) {
    int index = member.indexWhere((e) => e.email == email);
    if (index >= 0) {
      return member.elementAt(index).memberId;
    }
    return 0;
  }

  // DateTime.parse(2022-07-06 12:00:00);
  bool get hasExpired => DateTime.now().isAfter(DateTime.parse(info.expire));

  bool get hasReady2Submit {
    if (hasExpired) {
      return false;
    }
    if (selection.length != info.limit) {
      return false;
    }
    return true;
  }

  void toggleSelection(int id) {
    if (hasExpired) {
      return;
    }
    if (selection.contains(id)) {
      selection.removeWhere((e) => e == id);
    } else if (selection.length < info.limit) {
      selection.add(id);
    }
  }
}
