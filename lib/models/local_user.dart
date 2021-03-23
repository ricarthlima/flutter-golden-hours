// {
//     "avatarId": 0,
//     "name": "aaa",
//     "email": "aaaa",
//     "isVerTimerActive": false,
//     "verTimerInSeconds": 10
// }

class LocalUser {
  int avatarId;
  String name;
  String email;
  bool isVerTimerActive;
  int verTimerInSeconds;
  bool firebased;

  LocalUser(
      {this.avatarId,
      this.name,
      this.email,
      this.isVerTimerActive,
      this.verTimerInSeconds,
      this.firebased});

  LocalUser.fromJson(Map<String, dynamic> json) {
    avatarId = json['avatarId'];
    name = json['name'];
    email = json['email'];
    isVerTimerActive = json['isVerTimerActive'];
    verTimerInSeconds = json['verTimerInSeconds'];
    firebased = json['firebased'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatarId'] = this.avatarId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['isVerTimerActive'] = this.isVerTimerActive;
    data['verTimerInSeconds'] = this.verTimerInSeconds;
    data['firebased'] = this.firebased;
    return data;
  }
}
