import 'dart:developer';

import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/premium_feature_controller.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SubscriptionButton extends StatelessWidget {
  final PremiumFeatureController premC;

  const SubscriptionButton({required this.premC});

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<InAppPurchaseController>(context, listen: false);
    // final premC = Provider.of<PremiumFeatureController>(context);
    final mq = MediaQuery.of(context).size;

    return provider.productDetailsList.isEmpty
        ? SizedBox()
        : InkWell(
            onTap: () async {
              if (provider.productDetailsList.isNotEmpty) {
                if (premC.selectedPlan.isNotEmpty) {
                  if (premC.selectedPlan == "aidictionary_monthly" &&
                      !provider.isMonthlyPurchased) {
                    await provider.buy(premC.selectedPlan);
                  } else if (premC.selectedPlan == "aidictionary_yearly" &&
                      !provider.isYearlyPurchased) {
                    await provider.buy(premC.selectedPlan);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text("You have already subscribed to this plan"),
                      ),
                    );
                  }
                } else {
                  // Safely access the first item in the list
                  final selectedProduct = provider.monthlyProduct != null
                      ? provider.monthlyProduct
                      : null;

                  if (selectedProduct != null) {
                    premC.changeSelectedPlan(selectedProduct.id);

                    log('Selected Plan: ${premC.selectedPlan}');

                    if (premC.selectedPlan == "aidictionary_monthly" &&
                        !provider.isMonthlyPurchased) {
                      await provider.buy(premC.selectedPlan);
                    } else if (premC.selectedPlan == "aidictionary_yearly" &&
                        !provider.isYearlyPurchased) {
                      await provider.buy(premC.selectedPlan);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("You have already subscribed to this plan"),
                        ),
                      );
                    }
                  }
                }
              }
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: darkbluee, // Replace `mainClr` with your color
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: darkbluee),
              ),
              child: Center(
                child: Text(
                  premC.selectedPlan == "aidictionary_monthly" &&
                          provider.isMonthlyPurchased
                      ? "Subscribed"
                      : premC.selectedPlan == "aidictionary_yearly" &&
                              provider.isYearlyPurchased
                          ? "Subscribed"
                          : provider.isMonthlyFreeTrial
                              ? "Start Free Trial"
                              : provider.isYearlyFreeTrial
                                  ? "Start Free Trial"
                                  : "Subscribe",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: mq.height * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
  }
}
