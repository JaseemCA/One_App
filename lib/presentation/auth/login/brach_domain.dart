import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneappcounter/bloc/branch_domain/bloc/branc_domain_bloc.dart';
import 'package:oneappcounter/bloc/branch_domain/bloc/branc_domain_event.dart';
import 'package:oneappcounter/bloc/branch_domain/bloc/branc_domain_state.dart';

import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/common/widgets/textfield/custom_text_field.dart';
import 'package:oneappcounter/services/storage_service.dart';

class BranchDomainPage extends StatelessWidget {
  const BranchDomainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BranchDomainBloc(networkingCubit: context.read<NetworkingCubit>()),
      child: const BranchDomainView(),
    );
  }
}

class BranchDomainView extends StatelessWidget {
  const BranchDomainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.appBackgrondcolor,
      body: BlocListener<BranchDomainBloc, BranchDomainState>(
        listener: (context, state) {
          if (state is BranchDomainSubmitted) {
            Navigator.pushNamed(context, '/loginScreen');
          } else if (state is BranchDomainError) {
            // Display error message using a dialog, snackbar, or similar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      "assets/images/logoWhite.svg",
                      height: 50,
                      width: 50,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "ENTER YOUR BRANCH DOMAIN",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
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
    );
  }
}
