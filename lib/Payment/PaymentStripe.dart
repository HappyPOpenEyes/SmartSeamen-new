// ignore_for_file: use_build_context_synchronously

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

class PaymentStripe extends ChangeNotifier {
  bool initiatePayment = false;
  var headers, clientSecret;
  late PaymentIntent paymentIntent;
  late int planIndex;
  // ignore: prefer_typing_uninitialized_variables

  void makePayment(BuildContext context, int index, header) async {
    planIndex = index;
    headers = header;
    Provider.of<AsyncCallProvider>(context, listen: false).changeAsynccall();
    callClientSecretApi(context);
  }

  callClientSecretApi(BuildContext context) async {
    if (await Provider.of<CreatePayment>(context, listen: false)
        .makeCreatePayment(
            Provider.of<GetPlanListProvider>(context, listen: false)
                .planId[planIndex],
            Provider.of<GetPlanListProvider>(context, listen: false)
                .planAmount[planIndex],
            headers)) {
      clientSecret =
          Provider.of<CreatePayment>(context, listen: false).clientSecret;
      callPaymentConfirmIntent(context);
    } else {
      displaysnackbar('Something went wrong');
    }
  }

  void callPaymentConfirmIntent(BuildContext context) async {
    if (clientSecret.isNotEmpty) {
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: clientSecret,
              applePay: false,
              googlePay: false,
              style: ThemeMode.dark,
              merchantCountryCode: 'INR',
              merchantDisplayName: 'Test Payment Service'));

      try {
        await Stripe.instance.presentPaymentSheet();
        String status = "";
        
        paymentIntent =
            await Stripe.instance.retrievePaymentIntent(clientSecret);
        switch(paymentIntent.status){
          case PaymentIntentsStatus.Succeeded:
          status = "Succeeded";
          break;
          case PaymentIntentsStatus.RequiresPaymentMethod:
            // TODO: Handle this case.
            break;
          case PaymentIntentsStatus.RequiresConfirmation:
            // TODO: Handle this case.
            break;
          case PaymentIntentsStatus.Canceled:
            // TODO: Handle this case.
            status = "Canceled";
            break;
          case PaymentIntentsStatus.Processing:
            // TODO: Handle this case.
            break;
          case PaymentIntentsStatus.RequiresAction:
            // TODO: Handle this case.
            break;
          case PaymentIntentsStatus.RequiresCapture:
            // TODO: Handle this case.
            break;
          case PaymentIntentsStatus.Unknown:
            // TODO: Handle this case.
            status = "Unknown";
            break;
        }
        callCreatePaymentAPI(context, status);
      } catch (err) {
        print(err);
      }
    }
  }

  callCreatePaymentAPI(BuildContext context, String status) async {
    if (await Provider.of<CreatePaymentEntry>(context, listen: false)
        .makeCreatePaymentEntry(
            paymentIntent.amount,
            Provider.of<GetPlanListProvider>(context, listen: false)
                .planStripePrice[planIndex],
            Provider.of<GetPlanListProvider>(context, listen: false)
                .planId[planIndex],
            Provider.of<GetPlanListProvider>(context, listen: false)
                .planName[planIndex],
            Provider.of<GetPlanListProvider>(context, listen: false)
                .planDuration[planIndex],
            paymentIntent.id,
            paymentIntent.paymentMethodId,
            Provider.of<GetPlanCalculationProvider>(context, listen: false)
                .startDate,
            Provider.of<GetPlanCalculationProvider>(context, listen: false)
                .endDate,
            Provider.of<GetPlanCalculationProvider>(context, listen: false)
                .calculatedPlanAmount,
            clientSecret,
            status,
            headers)) {
      Provider.of<AsyncCallProvider>(context, listen: false).changeAsynccall();
      callUserDataApi(context,headers);
    }
  }

  callUserDataApi(BuildContext context,header) async {
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
