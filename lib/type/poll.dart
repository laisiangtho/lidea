part of 'main.dart';

/// NOTE: only type, PollBoard child
class PollMemberType {
  final int memberId;
  final String name;
  final String email;
  final int candidate;
  final int committee;

  PollMemberType({
    this.memberId = 0,
    this.name = '',
    this.email = '',
    this.candidate = 0,
    this.committee = 0,
  });

  factory PollMemberType.fromJSON(Map<String, dynamic> o) {
    return PollMemberType(
      memberId: int.parse(o['memberId'].isEmpty ? '0' : o['memberId'] ?? '0'),
      name: o['name'],
      email: o['email'],
      candidate: int.parse(o['candidate'].isEmpty ? '0' : o['candidate'] ?? '0'),
      committee: int.parse(o['committee'].isEmpty ? '0' : o['committee'] ?? '0'),
    );
  }

  bool get isCandidate => candidate > 0;
  bool get isCommittee => committee > 0;
}

/// NOTE: only type, PollBoard child
class PollResultType {
  final int candidateId;
  final List<int> memberId;
  final int rank;

  PollResultType({
    required this.candidateId,
    required this.memberId,
    required this.rank,
  });

  factory PollResultType.fromJSON(Map<String, dynamic> o) {
    return PollResultType(
      candidateId: int.parse(o['candidateId'].isEmpty ? '0' : o['candidateId'] ?? '0'),
      // _TypeError (type 'MappedListIterable<String, dynamic>' is not a subtype of type 'Iterable<int>')
      memberId: o['memberId'].split(' ').map<int>((e) {
        return int.parse(e.isEmpty ? '0' : e ?? '0');
      }).toList(),
      rank: int.parse(o['rank'].isEmpty ? '0' : o['rank'] ?? '0'),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'candidateId': candidateId,
      'memberId': memberId,
      'rank': memberId.length,
    };
  }

  String get csv {
    return [candidateId, memberId.join(' '), memberId.length].join(',');
  }

  String get header {
    return 'candidateId,memberId,rank';
  }
}

/// NOTE: only type, PollBoard child
class PollInfoType {
  final String id;
  final String shortname;
  final String title;
  final String description;
  final String note;
  final String start;
  final String expire;
  final int limit;
  final String expireMessage;
  final String limitMessage;
  final String candidate;
  final String outcome;

  static PollInfoType empty = PollInfoType();

  PollInfoType({
    this.id = '',
    this.shortname = '',
    this.title = '',
    this.description = '',
    this.note = '',
    this.start = '',
    this.expire = '',
    this.limit = 0,
    this.expireMessage = '',
    this.limitMessage = '',
    this.candidate = '',
    this.outcome = '',
  });

  // candidate, outcome

  factory PollInfoType.fromJSON(Map<String, dynamic> o) {
    return PollInfoType(
      id: o['id'],
      shortname: o['shortname'],
      note: o['note'],
      title: o['title'],
      description: o['description'],
      start: o['start'],
      expire: o['expire'],
      limit: o['limit'],
      expireMessage: o['expire-message'],
      limitMessage: o['limit-message'],
      candidate: o['candidate'],
      outcome: o['outcome'],
    );
  }

  String get expireDatetime {
    return DateFormat('yyyy-MM-dd, HH:mm').format(
      DateTime.parse(expire),
    );
  }
}
