import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String id;
  late String fullName;
  late String userName;
  late int age;
  late String mobileNumber;
  late GeoPoint currentLocation;
  late Timestamp createdAt;
  late Timestamp updatedAt;
  late List donationIds;
  late List pickupIds;
  late int donationsDone;
  late String email;

  User(
    String id,
    String fullName,
    String userName,
    int age,
    String mobileNumber,
    GeoPoint currentLocation,
    Timestamp createdAt,
    Timestamp updatedAt,
    List donationIds,
    List pickupIds,
    int donationsDone,
    String email,
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
  }

  User.fromJson(Map json)
      : id = json['id'],
        fullName = json['fullName'].toString(),
        userName = json['userName'].toString(),
        age = json['age'],
        mobileNumber = json['mobileNumber'].toString(),
        currentLocation = json['currentLocation'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        donationIds = json['donationIds'],
        pickupIds = json['pickupIds'],
        donationsDone = json['donationsDone'],
        email = json['email'].toString();

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
    };
  }
}
