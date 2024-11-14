
import '../../user/User.dart';
import '../../customer/model/Booking.dart';

class BookingPayment {
  int? id;
  double? amount;
  DateTime? date;
  Booking? booking;
  User? customer;

  BookingPayment({
    this.id,
    this.amount,
    this.date,
    this.booking,
    this.customer,
  });

  factory BookingPayment.fromJson(Map<String, dynamic> json) {
    return BookingPayment(
      id: json['id'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      booking: Booking.fromJson(json['booking']),
      customer: User.fromJson(json['customer']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date?.toIso8601String(),
      'booking': booking?.toJson(),
      'customer': customer?.toJson(),
    };
  }
}
