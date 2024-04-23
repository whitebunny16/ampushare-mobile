import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';

import 'appointment_booking_page.dart';

class KhaltiPage extends StatefulWidget {
  final String pidx;
  const KhaltiPage({super.key, required this.pidx});

  @override
  State<KhaltiPage> createState() => _KhaltiPageState();
}

class _KhaltiPageState extends State<KhaltiPage> {
  late final Future<Khalti> khalti;

  PaymentResult? paymentResult;


  @override
  void initState() {
    super.initState();
    final payConfig = KhaltiPayConfig(
      publicKey: '27fe7b5b34fb4527b90e02eacc802f6e', // Merchant's public key
      pidx: widget.pidx, // This should be generated via a server side POST request.
      returnUrl: Uri.parse('https://khalti.com'),
      environment: Environment.test,
    );

    khalti = Khalti.init(
      enableDebugging: true,
      payConfig: payConfig,
      onPaymentResult: (paymentResult, khalti) {
        log(paymentResult.toString());
        setState(() {
          this.paymentResult = paymentResult;
        });
        khalti.close(context);
      },
      onMessage: (
          khalti, {
            description,
            statusCode,
            event,
            needsPaymentConfirmation,
          }) async {
        log(
          'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
        );
        khalti.close(context);
      },
      onReturn: () => log('Successfully redirected to return_url.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: khalti,
          initialData: null,
          builder: (context, snapshot) {
            final khaltiSnapshot = snapshot.data;
            if (khaltiSnapshot == null) {
              return const CircularProgressIndicator.adaptive();
            }
            else if (paymentResult != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 120),
                  const Text(
                    'Appointment Booked Successfully',
                    style: TextStyle(fontSize: 25),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const AppointmentBookingPage()));
                    },
                    child: const Text('Return Back'),
                  ),
                  const SizedBox(height: 120),
                  const SizedBox(height: 120),
                ],
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 120),
                const Text(
                  'Rs. 20',
                  style: TextStyle(fontSize: 25),
                ),
                const Text('One time Appointment'),
                OutlinedButton(
                  onPressed: () => khaltiSnapshot.open(context),
                  child: const Text('Pay with Khalti'),
                ),
                const SizedBox(height: 120),
                const SizedBox(height: 120),
              ],
            );
          },
        ),
      ),
    );
  }
}