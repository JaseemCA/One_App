import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneappcounter/bloc/branch_domain/bloc/branc_domain_bloc.dart';
import 'package:oneappcounter/bloc/branch_domain/bloc/branc_domain_event.dart';
import 'package:oneappcounter/bloc/branch_domain/bloc/branc_domain_state.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/common/widgets/textfield/custom_text_field.dart';

import 'package:oneappcounter/services/utility_services.dart';

class DomainScreen extends StatefulWidget {
  const DomainScreen({super.key});

  @override
  State<DomainScreen> createState() => _DomainScreenState();
}

class _DomainScreenState extends State<DomainScreen> {
  // final _domainUrlTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const DomainView();
  }
}

class DomainView extends StatelessWidget {
  const DomainView({super.key});

  // setDomainValue() {
  //   if (NetworkingService.domainUrl != null) {
  //     _domainUrlTextController.text = NetworkingService.domainUrl!;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Appcolors.appBackgrondcolor,
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
                        SvgPicture.asset(
                          "assets/images/logoWhite.svg",
                          height: 50,
                          width: 50,
                        ),
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
                            prefixIcon: Icons.link,
                            onChanged: (value) {
                              context
                                  .read<BranchDomainBloc>()
                                  .add(DomainUpdated(value));
                            },
                          ),
                        ),
                        const SizedBox(height: 7),
                        BlocBuilder<BranchDomainBloc, BranchDomainState>(
                          builder: (context, state) {
                            return CustomElevatedButton(
                              backgroundColor: Appcolors.buttonColor,
                              text: "CONNECT",
                              onPressed: state is BranchDomainValid
                                  ? () {
                                      context
                                          .read<BranchDomainBloc>()
                                          .add(SubmitDomain(state.domain));
                                    }
                                  : null,
                            );
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
}
