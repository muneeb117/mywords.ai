import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/core/di/service_locator.dart' show sl;
import 'package:mywords/modules/paywall/cubit/paywall_cubit/paywall_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:mywords/utils/extensions/size_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cubit/purchase_cubit/purchase_cubit.dart';

enum SelectionType { weekly, monthly }

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurchaseCubit(iapService: sl()),
      child: PopScope(
        canPop: false,
        child: Builder(
          builder: (context) {
            return BlocBuilder<PurchaseCubit, PurchaseState>(
              builder: (context, state) {
                return AbsorbPointer(
                  absorbing: state.status == PurchaseStatus.loading,
                  child: Scaffold(
                    body: BlocConsumer<PaywallCubit, PaywallState>(
                      listener: (context, state) {
                        // TODO: implement listener
                      },
                      builder: (context, state) {
                        var productsList = state.offering.availablePackages;
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: SvgPicture.asset(
                                      'assets/images/svg/ic_rect.svg',
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.close),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.cw,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 50.ch),
                                    Center(
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/png/img_app_icon.png',
                                            height: 45,
                                            width: 45,
                                          ),
                                          SizedBox(height: 6.ch),
                                          Text(
                                            'MyWords.AI',
                                            style: TextStyle(
                                              fontSize: 16.csp,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          Text(
                                            'Unlock the most powerful AI\nstudy assistant',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16.csp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 25.ch),
                                    const FeatureItem(
                                      text: 'Unlimited AI Humanizations',
                                    ),
                                    const FeatureItem(
                                      text: 'Bypass AI Detection',
                                    ),
                                    const FeatureItem(
                                      text: 'Advanced AI Writer',
                                    ),
                                    const FeatureItem(
                                      text: 'Access to New Features',
                                    ),
                                    const SizedBox(height: 15),

                                    Column(
                                      children: List.generate(
                                        productsList.length,
                                        (index) {
                                          final product = productsList[index];
                                          return Container(
                                            margin: EdgeInsets.only(
                                              bottom: 12.ch,
                                            ),
                                            child: GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                setState(() {
                                                  if (product.storeProduct.title
                                                          .toLowerCase() ==
                                                      'weekly') {
                                                    selectedIndex = 0;
                                                  } else {
                                                    selectedIndex = 1;
                                                  }
                                                });
                                              },
                                              child: PlanCard(
                                                title:
                                                    product.storeProduct.title,
                                                price:
                                                    product
                                                        .storeProduct
                                                        .priceString,
                                                isSelected:
                                                    index == selectedIndex,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    SizedBox(height: 20.ch),
                                    BlocConsumer<PurchaseCubit, PurchaseState>(
                                      listener: (context, state) {
                                        if (state.status ==
                                            PurchaseStatus.success) {
                                          if (state.customerInfo != null) {
                                            context
                                                .read<PaywallCubit>()
                                                .updateUserToPremium(
                                                  state
                                                      .customerInfo!
                                                      .entitlements,
                                                );
                                            Navigator.pop(context);
                                          }
                                        } else if (state.status ==
                                            PurchaseStatus.failure) {
                                          context.showSnackBar(
                                            state.errorMessage,
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        return PrimaryButton.gradient(
                                          isLoading:
                                              state.status ==
                                              PurchaseStatus.loading,
                                          onTap: () async {
                                            if (selectedIndex == -1) {
                                              context.showSnackBar(
                                                'Please choose a plan!',
                                              );
                                              return;
                                            }
                                            context
                                                .read<PurchaseCubit>()
                                                .purchasePackage(
                                                  productsList[selectedIndex],
                                                );
                                          },
                                          title: 'Try 3 Day free Trial',
                                          fontWeight: FontWeight.w700,
                                        );
                                      },
                                    ),
                                    SizedBox(height: 12),
                                    Divider(thickness: 0.5, color: Colors.grey),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            final url = Uri.parse(
                                              'https://sites.google.com/view/mywords-ai/home',
                                            );
                                            if (await canLaunchUrl(url))
                                              await launchUrl(url);
                                          },
                                          child: Text(
                                            'Privacy Policy',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          '|',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        const SizedBox(width: 8),
                                        TextButton(
                                          onPressed: () async {
                                            final url = Uri.parse(
                                              'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
                                            );
                                            if (await canLaunchUrl(url))
                                              await launchUrl(url);
                                          },
                                          child: Text(
                                            'Terms of Use',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Subscriptions auto-renew unless canceled at least 24 hours before the end of the current period. '
                                      'Manage your subscription in your App Store settings.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
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
          SvgPicture.asset('assets/images/svg/ic_paywall_tick.svg'),
          const SizedBox(width: 10),
          Text(
            text,
            style: context.textTheme.titleLarge?.copyWith(
              fontSize: 16.csp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final bool isSelected;

  const PlanCard({
    super.key,
    required this.title,
    required this.price,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.primary : Color(0xffEDEDED),
          width: isSelected ? 1.5 : 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 15.csp,
            ),
          ),

          Text(
            price,
            style: TextStyle(
              fontSize: 15.csp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              // color: isSelected ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
