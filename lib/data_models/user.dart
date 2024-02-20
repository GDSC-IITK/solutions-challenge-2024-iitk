import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String id;
  late String fullName;
  late String userName;
  late String age;
  late String mobileNumber;
  late GeoPoint currentLocation;
  late Timestamp createdAt;
  late Timestamp updatedAt;
  late List donationIds;
  late List pickupIds;
  late int donationsDone;
  late String email;
  late String profileImageLink;
  late int dropsDone;
  late int pickupsDone;
  late List dropIds;
  late List spotIds;
  late int spotsDone;

  User(
    String id,
    String fullName,
    String userName,
    String age,
    String mobileNumber,
    GeoPoint currentLocation,
    Timestamp createdAt,
    Timestamp updatedAt,
    List donationIds,
    List pickupIds,
    int donationsDone,
    String email,
    String profileImageLink,
    int dropsDone,
    int pickupsDone,
    List dropIds,
    List spotIds,
    int spotsDone,
  ) {
    this.id = id;
    this.fullName = fullName;
    this.userName = userName;
    this.age = age;
    this.mobileNumber = mobileNumber;
    this.currentLocation = currentLocation;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
    this.donationIds = donationIds;
    this.pickupIds = pickupIds;
    this.donationsDone = donationsDone;
    this.email = email;
    this.profileImageLink = profileImageLink;
    this.pickupIds = pickupIds;
    this.dropsDone = dropsDone;
    this.dropIds = dropIds;
    this.spotIds = spotIds;
    this.spotsDone =spotsDone;
  }

  User.fromJson(Map json)
      : id = json['id'] ?? "",
        fullName = json['fullName'].toString(),
        userName = json['userName'].toString(),
        age = json['age'].toString(),
        mobileNumber = json['mobileNumber'].toString(),
        currentLocation = json['currentLocation'],
        createdAt = json['createdAt'] ?? Timestamp.now(),
        updatedAt = json['updatedAt'] ?? Timestamp.now(),
        donationIds = json['donationIds'] ?? [],
        pickupIds = json['pickupIds'] ?? [],
        dropIds = json['dropIds'] ?? [],
        donationsDone = json['donationsDone'] ?? 0,
        email = json['email'].toString(),
        profileImageLink = json['profileImageLink'].toString(),
        spotIds = json['spotIds'] ?? [],
        spotsDone = json['spotsDone'] ?? 0;

  Map toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'userName': userName,
      'age': age,
      'mobileNumber': mobileNumber,
      'currentLocation': currentLocation,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'donationIds': donationIds,
      'pickupIds': pickupIds,
      'donationsDone': donationsDone,
      'email': email,
      'profileImageLink': profileImageLink,
      'dropIds': dropIds,
      'spotIds': spotIds,
      'spotsDone': spotsDone,
    };
  }
}
