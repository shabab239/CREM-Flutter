import 'dart:io';
import 'package:crem_flutter/customer/PaymentService.dart';
import 'package:flutter/material.dart';
import 'package:crem_flutter/util/AlertUtil.dart';
import 'package:crem_flutter/util/ApiResponse.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import 'BookingService.dart';
import 'model/Booking.dart';
import 'model/BookingPayment.dart';

class BookingView extends StatefulWidget {
  final int unitId;

  BookingView({required this.unitId});

  @override
  _BookingViewState createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  late Booking booking;
  List<BookingPayment> bookingPayments = [];
  double totalPaid = 0.0;
  double totalAmount = 0.0;
  bool isLoading = true;

  final BookingService _bookingService = BookingService();
  final PaymentService _paymentService = PaymentService();

  @override
  void initState() {
    super.initState();
    loadBooking();
  }

  Future<void> loadBooking() async {
    try {
      ApiResponse response = await _bookingService.getBookingByUnitId(widget.unitId);
      if (response.successful) {
        setState(() {
          booking = Booking.fromJson(response.data['booking']);
          bookingPayments = List<BookingPayment>.from(
              response.data['bookingPayments'].map((x) => BookingPayment.fromJson(x))
          );
          totalAmount = booking.unit?.price ?? 0.0;
          totalPaid = bookingPayments.fold(0.0, (sum, payment) => sum + (payment.amount ?? 0.0));
          isLoading = false;
        });
      } else {
        AlertUtil.error(context, response);
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      AlertUtil.exception(context, error);
      setState(() {
        isLoading = false;
      });
    }
  }

  double getRemainingBalance() {
    return totalAmount - totalPaid;
  }

  Future<void> _downloadPDF() async {
    if (totalAmount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No booking or payment details available.")),
      );
      return;
    }

    final pdf = pw.Document();
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Booking Details - $formattedDate',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Booking ID: ${booking.id ?? "N/A"}'),
              pw.Text('Customer: ${booking.customer?.name ?? "N/A"}'),
              pw.Text('Unit: ${booking.unit?.name ?? "N/A"}'),
              pw.Text('Booking Date: ${booking.bookingDate?.toLocal()}'),
              pw.SizedBox(height: 20),
              pw.Text('Payment Details: ',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                context: context,
                headers: ['Payment Date', 'Amount'],
                data: bookingPayments
                    .map((payment) => [
                  payment.date != null
                      ? DateFormat('yyyy-MM-dd').format(payment.date!)
                      : 'N/A',
                  '\$${payment.amount ?? 0.0}',
                ])
                    .toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Total Amount: \$${totalAmount.toString()}'),
              pw.Text('Total Paid: \$${totalPaid.toString()}'),
              pw.Text('Remaining Balance: \$${getRemainingBalance().toString()}'),
            ],
          );
        },
      ),
    );

    final output = await getExternalStorageDirectory();
    final filePath =
        '${output!.path}/booking_report_${booking.id}.pdf';
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Report saved to $filePath")),
    );
  }

  Future<void> _showPaymentDialog() async {
    final amountController = TextEditingController();
    final dateController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Payment Details"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Amount"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: "Payment Date",
                    hintText: DateFormat('yyyy-MM-dd').format(selectedDate),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                        dateController.text =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (amountController.text.isEmpty || dateController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill all the fields")),
                  );
                  return;
                }

                double amount = double.parse(amountController.text);
                DateTime paymentDate = selectedDate;

                BookingPayment payment = BookingPayment(
                  amount: amount,
                  date: paymentDate,
                  booking: booking,
                  customer: booking.customer,
                );

                ApiResponse response = await _paymentService.savePayment(payment);

                if (response.successful) {
                  setState(() {
                    bookingPayments.add(payment);
                    totalPaid += amount;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Payment saved successfully")),
                  );
                  loadBooking();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to save payment")),
                  );
                }
              },
              child: Text("Save Payment"),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Details Card
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking ID: ${booking.id}',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Customer: ${booking.customer?.name ?? "N/A"}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Unit: ${booking.unit?.name ?? "N/A"}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Booking Date: ${booking.bookingDate != null ? DateFormat('yyyy-MM-dd').format(booking.bookingDate!) : "N/A"}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Payment Details Card
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Details:',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        if (bookingPayments.isNotEmpty)
                          Column(
                            children: bookingPayments.map((payment) =>
                                ListTile(
                                  title: Text('Payment: \$${payment.amount}'),
                                  subtitle: Text('Date: ${payment.date}'),
                                )).toList(),
                          )
                        else
                          Text('No payments made yet.',
                              style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
              // Summary Card
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Summary:',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Total Amount: \$${totalAmount.toString()}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Total Paid: \$${totalPaid.toString()}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Remaining Balance: \$${getRemainingBalance().toString()}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (getRemainingBalance() > 0)
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      _showPaymentDialog();
                    },
                    child: Text('Make Payment'),
                  ),
                ),

              // Download PDF Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  onPressed: _downloadPDF,
                  child: Text('Download PDF'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
