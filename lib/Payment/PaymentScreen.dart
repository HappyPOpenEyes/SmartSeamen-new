// ignore_for_file: use_build_context_synchronously, unused_element, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import '../LoginScreen/UserDataProvider.dart';
import '../Profile/Profile.dart';
import '../asynccallprovider.dart';
import '../constants.dart';
import 'CalculatePlanProvider.dart';
import 'CreatePaymentEntryProvider.dart';
import 'CreatePaymentProvider.dart';
import 'PlanProvider.dart';

class PaymentScreen extends StatefulWidget {
  int index;
  var header;
  PaymentScreen({Key? key, required this.index, this.header}) : super(key: key);

  @override
  State<PaymentScreen> createState() =>
      _PaymentScreenState(header: header, index: index);
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String clientSecret = "";
  int index;
  var header;

  late PaymentMethod paymentMethod;
  late PaymentIntent paymentIntent;

  _PaymentScreenState({required this.index, this.header});

  @override
  void initState() {
    Stripe.publishableKey =
        "pk_test_51KjNHHSHRxIGre3WZpXwlbtiWhVbOWHyMbV7prZZ3EmA5F7uEHnwCT5DlzTUcQ2fqAHgZdCjOyiWBZtX2r1FbUH600GkkW5ZmH";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Column(
        children: [
          CardField(
            onCardChanged: (card) {},
          ),
          TextButton(
            onPressed: () async {
              paymentMethod = await Stripe.instance.createPaymentMethod(
                  const PaymentMethodParams.card(
                      paymentMethodData: PaymentMethodData()));
              print(paymentMethod);
              Provider.of<AsyncCallProvider>(context, listen: false)
                  .changeAsynccall();
              callClientSecretApi();
            },
            child: const Text('Pay'),
          )
        ],
      ),
    );
  }

  callClientSecretApi() async {
    if (await Provider.of<CreatePayment>(context, listen: false)
        .makeCreatePayment(
            Provider.of<GetPlanListProvider>(context, listen: false)
                .planId[index],
            Provider.of<GetPlanListProvider>(context, listen: false)
                .planAmount[index],
            header)) {
      clientSecret =
          Provider.of<CreatePayment>(context, listen: false).clientSecret;
      callPaymentConfirmIntent();
    } else {
      displaysnackbar('Something went wrong');
    }
  }

  void callPaymentConfirmIntent() async {
    if (clientSecret.isNotEmpty) {
      // await Stripe.instance.initPaymentSheet(
      //     paymentSheetParameters: SetupPaymentSheetParameters(
      //         paymentIntentClientSecret: clientSecret,
      //         applePay: false,
      //         googlePay: false,
      //         style: ThemeMode.dark,
      //         merchantCountryCode: 'INR',
      //         merchantDisplayName: 'Test Payment Service'));
      try {
        //await Stripe.instance.presentPaymentSheet();
        paymentIntent = await Stripe.instance.confirmPayment(
            clientSecret,
            const PaymentMethodParams.card(
                paymentMethodData: PaymentMethodData()));
        print(paymentIntent);
        if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
          //callCreatePaymentAPI();
        }
      } on StripeException catch (err) {
        print('Stripe erroe');
        print(err.toString());
      } catch (err) {
        print(err);
      }
    }
  }

  callCreatePaymentAPI() async {
    if (await Provider.of<CreatePaymentEntry>(context, listen: false)
        .makeCreatePaymentEntry(
            Provider.of<GetPlanListProvider>(context, listen: false)
                .planAmount[index],
            Provider.of<GetPlanListProvider>(context, listen: false)
                .planStripePrice[index],
            Provider.of<GetPlanListProvider>(context, listen: false)
                .planId[index],
            Provider.of<GetPlanListProvider>(context, listen: false)
                .planName[index],
            Provider.of<GetPlanListProvider>(context, listen: false)
                .planDuration[index],
            paymentIntent.id,
            "",
            Provider.of<GetPlanCalculationProvider>(context, listen: false)
                .startDate,
            Provider.of<GetPlanCalculationProvider>(context, listen: false)
                .endDate,
            Provider.of<GetPlanCalculationProvider>(context, listen: false)
                .calculatedPlanAmount,
            clientSecret,
            "status",
            header)) {
      callUserDataApi();
    }
  }

  callUserDataApi() async {
    UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    if (await userDataProvider.callUserDataapi(header)) {
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ));
    } else {
      displaysnackbar('Something went wrong');
    }
  }
}
