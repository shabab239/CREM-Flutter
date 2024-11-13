
import '../../user/User.dart';
import '../../project/model/Unit.dart';
import 'BookingPayment.dart';

class Booking {
  final int? id;
  final DateTime bookingDate;
  final Unit unit;
  final User customer;
  final List<BookingPayment>? bookingPayments;
  final int companyId;

  Booking({
    this.id,
    required this.bookingDate,
    required this.unit,
    required this.customer,
    this.bookingPayments,
    required this.companyId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      bookingDate: DateTime.parse(json['bookingDate']),
      unit: Unit.fromJson(json['unit']),
      customer: User.fromJson(json['customer']),
      bookingPayments: json['bookingPayments'] != null
          ? (json['bookingPayments'] as List)
          .map((e) => BookingPayment.fromJson(e))
          .toList()
          : [],
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingDate': bookingDate.toIso8601String(),
      'unit': unit.toJson(),
      'customer': customer.toJson(),
      'bookingPayments': bookingPayments?.map((e) => e.toJson()).toList(),
      'companyId': companyId,
    };
  }
}
