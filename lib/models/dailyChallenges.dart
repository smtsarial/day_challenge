class DailyChallenge {
  late String id;
  late List daily_tasks;
  late int day_number;
  late List completed_users;

  DailyChallenge(
      this.id, this.daily_tasks, this.day_number, this.completed_users);

  DailyChallenge.fromMap(dynamic obj) {
    daily_tasks = obj['daily_tasks'] ?? [];
    day_number = obj['day_number'] ?? 999;
    completed_users = obj['completed_users'] ?? [];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['daily_tasks'] = this.daily_tasks;
      map['day_number'] = this.day_number;
      map['completed_users'] = this.completed_users;
    }
    return map;
  }
}
