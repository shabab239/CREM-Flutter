
import '../../user/User.dart';
import 'Booking.dart';

class BookingPayment {
  final int? id;
  final double amount;
  final DateTime date;
  final Booking booking;
  final User customer;
  final int companyId;

  BookingPayment({
    this.id,
    required this.amount,
    required this.date,
    required this.booking,
    required this.customer,
    required this.companyId,
  });

  factory BookingPayment.fromJson(Map<String, dynamic> json) {
    return BookingPayment(
      id: json['id'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      booking: Booking.fromJson(json['booking']),
      customer: User.fromJson(json['customer']),
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'booking': booking.toJson(),
      'customer': customer.toJson(),
      'companyId': companyId,
    };
  }
}
