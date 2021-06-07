class OurUser {
  String uid;
  String fullName;
  String phoneNumber;
  String profilePhoto;
  OurUser({
    this.uid,
    this.fullName,
    this.phoneNumber,
    this.profilePhoto,
  });
  Map toMap(OurUser user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['fullName'] = user.fullName;
    data['phoneNumber'] = user.phoneNumber;

    data['profilePhoto'] = user.profilePhoto;

    return data;
  }

  OurUser.fromMap(Map<String, dynamic> map) {
    this.uid = map['uid'];
    this.fullName = map['fullName'];
    this.phoneNumber = map['phoneNumber'];
    this.profilePhoto = map['profilePhoto'];
  }
}