// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneappcounter/bloc/branch_domain/bloc/branc_domain_bloc.dart';
import 'package:oneappcounter/bloc/branch_domain/bloc/branc_domain_event.dart';
import 'package:oneappcounter/bloc/branch_domain/bloc/branc_domain_state.dart';
import 'package:oneappcounter/common/widgets/one_app_logo/one_app_logo.dart';
// import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/common/widgets/textfield/custom_text_field.dart';
import 'package:oneappcounter/core/config/constants.dart';
import 'package:oneappcounter/routes.dart';
import 'package:oneappcounter/services/auth_service.dart';
import 'package:oneappcounter/services/networking_service.dart';
import 'package:oneappcounter/services/storage_service.dart';

import 'package:oneappcounter/services/utility_services.dart';

class DomainScreen extends StatefulWidget {
  const DomainScreen({super.key});

  @override
  State<DomainScreen> createState() => _DomainScreenState();
}

class _DomainScreenState extends State<DomainScreen> {
  final _domainUrlTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setDomainValue();
  }

  @override
  void dispose() {
    _domainUrlTextController.dispose();
    super.dispose();
  }

  setDomainValue() {
    if (NetworkingService.domainUrl != null) {
      _domainUrlTextController.text = NetworkingService.domainUrl!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: appBackgrondcolor,
        body: BlocListener<BranchDomainBloc, BranchDomainState>(
          listener: (context, state) {
            if (state is BranchDomainSubmitted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/loginScreen',
                (route) => false,
              );
            } else if (state is BranchDomainError) {
              UtilityService.toast(context, state.message);
            }
          },
          child: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const OneAppLogo(),
                        const SizedBox(height: 10),
                        const Text(
                          'ENTER YOUR BRANCH DOMAIN',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: CustomTextField(
                            hintText: "http://branch-..",
                            labelText: "Branch Domain",
                            keyboardType: TextInputType.url,
                            controller: _domainUrlTextController,
                            prefixIcon: Icons.link_outlined,
                            onChanged: (value) {
                              context
                                  .read<BranchDomainBloc>()
                                  .add(DomainUpdated(value));
                            },
                            onFieldSubmitted: (_) {
                              buttonClicked();
                            },
                          ),
                        ),
                        const SizedBox(height: 7),
                        BlocBuilder<BranchDomainBloc, BranchDomainState>(
                          builder: (context, state) {
                            return CustomElevatedButton(
                                backgroundColor: buttonColor,
                                text: "CONNECT",
                                onPressed: () {
                                  buttonClicked();
                                });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Powered by ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: 'one',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              TextSpan(
                                text: 'app All Rights Reserved',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'V 0.0.01',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void buttonClicked() async {
    UtilityService.showLoadingAlert(context);
    String domainUrl = _domainUrlTextController.text.trim();

    if (domainUrl.isEmpty) {
      Navigator.pop(context);
      UtilityService.toast(context, 'Please enter domain URL');

      return;
    }

    if (domainUrl.substring(0, 8) != 'https://' &&
        domainUrl.substring(0, 7) != 'http://') {
      domainUrl = 'https://$domainUrl';
    }

    if (!Uri.parse(domainUrl).isAbsolute) {
      Navigator.pop(context);
      UtilityService.toast(context, 'Not a valid URL');

      return;
    }

    if (!await AuthService.validateDomain(domainUrl)) {
      Navigator.pop(context);
      UtilityService.toast(
        context,
        'Something went wrong, failed to verify domain address',
      );

      return;
    }

    await StorageService.saveValue(key: 'domain_url', value: domainUrl);
    await StorageService.saveValue(
        key: 'api_domain_url', value: '$domainUrl/api');
    await NetworkingService.setSavedValues();
    await AuthService.clearLoginToken();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.loginScreen,
      (route) => false,
    );
  }
}
