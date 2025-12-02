import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentBottomSheet extends StatefulWidget {
  final double totalAmount;
  final Function(String paymentMethodId) onPaymentSuccess;
  final void Function(CardFieldInputDetails?)? onCardChanged;

  const PaymentBottomSheet(
      {super.key,
        required this.totalAmount,
        required this.onPaymentSuccess,
        required this.onCardChanged});

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  CardFieldInputDetails? cardDetails = CardFieldInputDetails(complete: true);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Payment Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CardField(
            onCardChanged: (details) {
              setState(() {
                widget.onCardChanged?.call(details);
              });
            },
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity, // Full width
            height: 50, // Height of the button
            decoration: BoxDecoration(
              color: const Color(0xFF5E4B8C), // Purple background color
              borderRadius: BorderRadius.circular(15), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Subtle shadow
                  blurRadius: 5, // Soft shadow
                  offset: const Offset(0, 2), // Slight shadow offset
                ),
              ],
            ),
            child: TextButton(
              onPressed: () async {
                if (cardDetails != null && cardDetails!.complete != true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please complete card details')),
                  );
                  return;
                }

                try {
                  final paymentMethod = await Stripe.instance.createPaymentMethod(
                    params: const PaymentMethodParams.card(
                      paymentMethodData: PaymentMethodData(),
                    ),
                  );

                  print(paymentMethod.customerId);
                  widget.onPaymentSuccess(paymentMethod.id);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment failed: $e')),
                  );
                }
              },
              style: TextButton.styleFrom(
                padding:
                EdgeInsets.zero, // Remove default padding from TextButton
              ),
              child: Text(
                'Pay ${widget.totalAmount} \$',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Bold text style
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
