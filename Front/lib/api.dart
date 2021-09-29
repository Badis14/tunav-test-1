import 'dart:convert';
import 'package:http/http.dart';

class Hotel {
  final String id;
  final String name;
  final int rating;
  final double latitude;
  final double longitude;

  Hotel({this.id, this.name, this.rating, this.latitude, this.longitude});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['_id'] as String,
      name: json['Name'] as String,
      rating: json['Rating'] as int,
      longitude: json['Longitude'] as double,
      latitude: json['Latitude'] as double,
    );
  }
  @override
  String toString() {
    return 'Hotel{id: $id, name: $name, rating : $rating }';
  }
}

class Reservations {
  final String id;
  final String date;
  final int room;
  final String hotelname;

  Reservations({this.id, this.hotelname, this.room, this.date});

  factory Reservations.fromJson(Map<String, dynamic> json) {
    return Reservations(
      id: json['_id'] as String,
      hotelname: json['hn'] as String,
      room: json['room'] as int,
      date: json['date'] as String,
    );
  }

  @override
  String toString() {
    return 'Reservation{id: $id, room: $room, date : $date }';
  }
}

class ApiService {
  final String apiUrl = "http://192.168.43.233:9000";

  Future<List> getHotels() async {
    Response res =
        await get(Uri.parse("http://192.168.43.233:9000/findAll"), headers: {
      'Access-Control-Allow-Methods': 'GET',
      'Access-Control-Allow-Origin': '192.168.43.233:9000'
    });

    if (res.statusCode == 200) {
      print(res.body);
      List<dynamic> hotels = jsonDecode(res.body);
      return hotels;
    } else {
      throw "Failed to load cases list";
    }
  }

  Future<Hotel> getHotelBylocation(double lat, double long) async {
    final response =
        await get(Uri.parse("http://192.168.1.72:9000/find/{$lat}/{$long}"));

    if (response.statusCode == 200) {
      return Hotel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load a case');
    }
  }

  Future<Reservations> createReservation(Reservations reservation) async {
    Map data = {
      'id': reservation.id,
      'hotelname': reservation.hotelname,
      'date': reservation.date,
      'room': reservation.room
    };

    final Response response = await post(
      Uri.parse("http://192.168.1.72:9000/addRes"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return Reservations.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post Reservation');
    }
  }
}
