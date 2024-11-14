import '../../unit/model/Unit.dart';
import '../../user/User.dart';

class Booking {
  int? id;
  DateTime? bookingDate;
  Unit? unit;
  User? customer;

  Booking({
    this.id,
    this.bookingDate,
    this.unit,
    this.customer,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      bookingDate: DateTime.parse(json['bookingDate']),
      unit: Unit.fromJson(json['unit']),
      customer: User.fromJson(json['customer']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingDate': bookingDate?.toIso8601String(),
      'unit': unit?.toJson(),
      'customer': customer?.toJson(),
    };
  }
}
