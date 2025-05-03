import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart' show CustomAppBar;
import 'package:mywords/common/components/loading_indicator.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/modules/paywall/cubit/paywall_cubit/paywall_cubit.dart';
import 'package:mywords/modules/paywall/cubit/purchase_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum SelectionType { weekly, monthly }

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurchaseCubit(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Subscription Plan',
          showLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close),
            ),
          ],
        ),
        body: BlocConsumer<PaywallCubit, PaywallState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state.paywallStatus == PaywallStatus.loading) {
              return LoadingIndicator();
            }

            var productsList = state.offering.availablePackages;
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pro Plan Features',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text('Update Your Packages to Pro', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  const FeatureItem(text: 'Unlimited AI Humanizations'),
                  const FeatureItem(text: 'AI Detection Bypass'),
                  const FeatureItem(text: 'Advanced AI Writer'),
                  const SizedBox(height: 15),

                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: GestureDetector(
                  //         behavior: HitTestBehavior.opaque,
                  //         onTap: () {
                  //           setState(() {
                  //             selectionType = SelectionType.weekly;
                  //           });
                  //         },
                  //         child: PlanCard(
                  //           title: 'Weekly',
                  //           price: productsList,
                  //           isSelected: selectionType == SelectionType.weekly,
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(width: 12),
                  //     Expanded(
                  //       child: GestureDetector(
                  //         behavior: HitTestBehavior.opaque,
                  //         onTap: () {
                  //           setState(() {
                  //             selectionType = SelectionType.monthly;
                  //           });
                  //         },
                  //         child: PlanCard(
                  //           title: 'Monthly',
                  //           price: 'Rs 5618.00',
                  //           isSelected: selectionType == SelectionType.monthly,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: List.generate(productsList.length, (index) {
                      final product = productsList[index];
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: index != productsList.length - 1 ? 12.0 : 0,
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() {
                                if (product.storeProduct.title.toLowerCase() == 'weekly') {
                                  selectedIndex = 0;
                                } else {
                                  selectedIndex = 1;
                                }
                              });
                            },
                            child: PlanCard(
                              title: product.storeProduct.title,
                              price: product.storeProduct.priceString,
                              isSelected: index == selectedIndex,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 25),
                  PrimaryButton.gradient(
                    onTap: () async {
                      if (selectedIndex == -1) {
                        context.showSnackBar('Please choose a plan!');
                        return;
                      }
                     context.read<PurchaseCubit>().purchasePackage();
                      // context.read<SubjectBloc>()
                      // Offerings offerings = await Purchases.getOfferings();
                      //
                      // print('all offerings are :: $offerings');
                      //
                      // Offering? current = offerings.current;
                      //
                      // if (current == null || current.availablePackages.isEmpty) {
                      //   print('no offerings or packages');
                      //   // Show error or "no products available"
                      //   return;
                      // }
                      //
                      // // IapService.getOfferings();
                      // // TODO: handle subscription
                    },
                    title: 'Upgrade To Pro',
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'To cancel anytime please visit your App Store settings. Subscription automatically renews unless auto-renew is cancelled at least 24 hours before the last date.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String text;

  const FeatureItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.green),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final bool isSelected;

  const PlanCard({super.key, required this.title, required this.price, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.grey,
          width: isSelected ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(price, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
