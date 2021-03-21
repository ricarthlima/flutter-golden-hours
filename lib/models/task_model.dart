class Task {
  String id;
  String name;
  Duration lastTotal;
  DateTime lastStart;
  bool active;
  double taskValue;
  List<Duration> durationHistory;

  Task({
    this.id,
    this.name,
    this.lastTotal,
    this.lastStart,
    this.active,
    this.taskValue,
    this.durationHistory,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastTotal = Duration(seconds: json['lastTotal']);
    lastStart = DateTime.parse(json['lastStart']);
    active = json['active'];
    taskValue = json['taskValue'];

    //Histórico de Tempos
    if (json['durationHistory'] != null) {
      List<dynamic> tempList = json['durationHistory'];
      durationHistory = [];
      tempList.forEach((element) {
        durationHistory.add(Duration(seconds: element));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lastTotal'] = this.lastTotal.inSeconds;
    data['lastStart'] = this.lastStart.toString();
    data['active'] = this.active;
    data['taskValue'] = this.taskValue;

    //Histórico de Tempos
    if (durationHistory != null) {
      List<int> tempList = <int>[];
      durationHistory.forEach((element) {
        tempList.add(element.inSeconds);
      });
      data['durationHistory'] = tempList;
    }
    return data;
  }

  void reset() {
    if (this.durationHistory == null) {
      this.durationHistory = <Duration>[];
    }
    this.durationHistory.add(
          this.lastTotal + lastStart.difference(DateTime.now()).abs(),
        );
    this.lastTotal = Duration(microseconds: 0);
    this.lastStart = DateTime.now();
  }

  int getTotalHistoric() {
    int total = 0;
    this.durationHistory.forEach((element) {
      total += element.inSeconds;
    });
    return total;
  }
}
