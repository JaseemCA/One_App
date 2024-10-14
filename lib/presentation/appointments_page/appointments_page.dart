// import 'package:flutter/material.dart';
// import 'package:oneappcounter/core/config/color/appcolors.dart';
// import 'package:oneappcounter/common/widgets/tab_bar/custom_tab_bar.dart'; // Import the custom tab bar

// class AppointmentsPage extends StatefulWidget {
//   const AppointmentsPage({super.key});

//   @override
//   State<AppointmentsPage> createState() => _AppointmentsPageState();
// }

// class _AppointmentsPageState extends State<AppointmentsPage> {
//   @override
//   Widget build(BuildContext context) {
//     final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: isDarkMode
//               ? Appcolors.bottomsheetDarkcolor
//               : Appcolors.appBackgrondcolor,
//           title: const Text(
//             "Appointments",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 24,

//             ),
//           ),
//           // Use the CustomTabBar here
//           bottom: const CustomTabBar(
//             alignment: TabAlignment.fill,
//             tabCount: 2, // Number of tabs
//             tabLabels: ["TODAY'S", "CANCELLED"],

// ignore_for_file: use_build_context_synchronously

//             labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             Center(child: Text('No Data!')),
//             Center(child: Text('No Data!')),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:oneappcounter/bloc/appointment_page/bloc/appointment_bloc.dart';
import 'package:oneappcounter/bloc/appointment_page/bloc/appointment_event.dart';
import 'package:oneappcounter/bloc/appointment_page/bloc/appointment_state.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_event.dart';
import 'package:oneappcounter/common/widgets/button/count_down_button.dart';
// import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/core/config/constants.dart';
import 'package:oneappcounter/model/queue_appointment_model.dart';
import 'package:oneappcounter/model/tocken_model.dart';
import 'package:oneappcounter/presentation/popUp/customer_flow_details.dart';
import 'package:oneappcounter/services/call_service.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/socket_services.dart';
import 'package:oneappcounter/services/utility_services.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  Future<void> refreshFunction(BuildContext context) async {
    UtilityService.showLoadingAlert(context);
    await GeneralDataService.reloadData();
    Navigator.pop(context);
    BlocProvider.of<AppointmentPageBloc>(context).add(RebuildAllTabEvent());
  }

  late StreamSubscription rebuildListener;

  @override
  void initState() {
    super.initState();

    rebuildListener = SocketService
        .appointmentPageRebuildRequiredController.stream
        .listen((event) {
      if (event) {
        BlocProvider.of<AppointmentPageBloc>(context).add(RebuildAllTabEvent());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    try {
      rebuildListener.cancel();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      length: _getAppointmentTab().length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:  Text(translate
            ('Appointments'),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          backgroundColor: isDarkMode
              ? bottomsheetDarkcolor
              : appBackgrondcolor,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: const Color.fromARGB(255, 216, 214, 214),
            tabs: _getAppointmentTab(),
            // labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
        body: BlocBuilder<AppointmentPageBloc, AppointmentPageState>(
          buildWhen: (previous, current) {
            if (previous is RebuildAppointPageInitState &&
                current is ReBuildBothTab) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            return TabBarView(
              ///both screens will render from here
              children: _getAppointementsTabContent(context),
            );
          },
        ),
      ),
    );
  }

  List<Tab> _getAppointmentTab() {
    List<Tab> content = [];
    if (CounterSettingService.counterSettings?.hideTodayAppointments != true) {
      content.add(
         Tab(
          child: Text(translate("TODAY'S")),
        ),
      );
    }
    if (CounterSettingService.counterSettings?.hideCancelledAppointments !=
        true) {
      content.add(
         Tab(
          child: Text(translate("CANCELLED")),
        ),
      );
    }
    return content;
  }

  List<Widget> _getAppointementsTabContent(BuildContext context) {
    List<Widget> content = [];
    if (CounterSettingService.counterSettings?.hideTodayAppointments != true) {
      content.add(_buildTodayTabView(context));
    }
    if (CounterSettingService.counterSettings?.hideCancelledAppointments !=
        true) {
      content.add(_buildCancelledTabView(context));
    }

    return content;
  }

  Widget _buildTodayTabView(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        refreshFunction(context);
      },
      child: GeneralDataService.todayAppointments.isEmpty
          ? listViewNoDataFound()
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 15),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: GeneralDataService.todayAppointments.isNotEmpty
                  ? GeneralDataService.todayAppointments.length
                  : 0,
              itemBuilder: (context, index) {
                QueueAppointmentModel queueAppointment =
                    GeneralDataService.todayAppointments[index];
                return ListTile(
                  onTap: () {
                    showQueueDetails(queueAppointment, context);
                  },
                  leading: IconButton(
                    onPressed: GeneralDataService.lastCalledToken != null &&
                            !GeneralDataService.lastCalledToken!.isHold &&
                            GeneralDataService.lastCalledToken!.status ==
                                'serving'
                        ? null
                        : () async {
                            if ((GeneralDataService.lastCalledToken != null &&
                                    !GeneralDataService
                                        .lastCalledToken!.isHold &&
                                    GeneralDataService.lastCalledToken!.status !=
                                        'no-show') &&
                                CounterSettingService.counterSettings?.alertTransfer ==
                                    true &&
                                (((GeneralDataService.lastCalledToken!.queue != null && GeneralDataService.lastCalledToken!.queue['is_transferred'] != true) ||
                                    (GeneralDataService.lastCalledToken!.queueppointment != null &&
                                        GeneralDataService.lastCalledToken!.queueppointment['is_transferred'] !=
                                            true)))) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:  Text(translate
                                          ('Alert (Not transferred!)')),
                                      content: Text(
                                          '${GeneralDataService.lastCalledToken!.tokenNumber} ${('Not transferred, Continue Calling?')}'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child:  Text(translate('Cancel')),
                                        ),
                                        CountDownButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await callToken(
                                                context: context,
                                                id: queueAppointment.id);
                                          },
                                        )
                                      ],
                                    );
                                  });
                            } else if ((GeneralDataService.lastCalledToken != null &&
                                    !GeneralDataService
                                        .lastCalledToken!.isHold &&
                                    GeneralDataService.lastCalledToken!.status !=
                                        'no-show') &&
                                CounterSettingService.counterSettings?.requireTransfer ==
                                    true &&
                                ((GeneralDataService.lastCalledToken!.queue != null && GeneralDataService.lastCalledToken!.queue['is_transferred'] != true) ||
                                    (GeneralDataService.lastCalledToken!.queueppointment != null &&
                                        GeneralDataService.lastCalledToken!.queueppointment['is_transferred'] !=
                                            true))) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:  Text(translate
                                          ('Transfer is required !')),
                                      content: Text(
                                          '${GeneralDataService.lastCalledToken!.tokenNumber} ${('Not transferred')}'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child:  Text(translate('Close')),
                                        ),
                                      ],
                                    );
                                  });
                            } else {
                              callToken(
                                  context: context, id: queueAppointment.id);
                            }
                          },
                    icon: Icon(
                      Icons.call,
                      color: UtilityService.isDarkTheme
                          ? buttonColor
                          : Colors.blueAccent,
                    ),
                  ),
                  title: Text(
                    '${queueAppointment.tokenNumber} (${queueAppointment.formattedTimeSlot})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: (queueAppointment.name != null &&
                              queueAppointment.name != 'gqZaT') ||
                          queueAppointment.phone != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            queueAppointment.phone != null
                                ? Text(queueAppointment.phone ?? '')
                                : Container(),
                            (queueAppointment.name != null &&
                                    queueAppointment.name != 'gqZaT')
                                ? Text(queueAppointment.name ?? '')
                                : Container(),
                          ],
                        )
                      : null,
                  trailing: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child:  Text(translate('Close'))),
                                TextButton(
                                    onPressed: () async {
                                      UtilityService.showLoadingAlert(context);
                                      if (await CallService.cancelAppointment(
                                          queueAppointmentId:
                                              queueAppointment.id)) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);

                                        BlocProvider.of<AppointmentPageBloc>(
                                                context)
                                            .add(RebuildAllTabEvent());

                                        return;
                                      }
                                      Navigator.pop(context);
                                      UtilityService.toast(
                                          context, translate ('Something went wrong'));
                                    },
                                    child: const Text(('Continue')))
                              ],
                              title:  Text(
                                translate  ('Confirm Cancelling Appointment')),
                              content: Text(translate( '${('Do you want to cancel Appointment')} ${queueAppointment.tokenNumber}?')
                                 ),
                            );
                          });
                    },
                    icon: const Icon(Icons.close_outlined),
                  ),
                );
              }),
    );
  }

  Widget _buildCancelledTabView(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        refreshFunction(context);
      },
      child: GeneralDataService.todayCancelledAppointments.isEmpty
          ? listViewNoDataFound()
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 15),
              separatorBuilder: (context, index) => const Divider(),
              itemCount:
                  GeneralDataService.todayCancelledAppointments.isNotEmpty
                      ? GeneralDataService.todayCancelledAppointments.length
                      : 0,
              itemBuilder: (context, index) {
                QueueAppointmentModel queueAppointment =
                    GeneralDataService.todayCancelledAppointments[index];
                return ListTile(
                  onTap: () {
                    showQueueDetails(queueAppointment, context);
                  },
                  title: Text(
                    '${queueAppointment.tokenNumber} (${queueAppointment.formattedTimeSlot})',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: (queueAppointment.name != null &&
                              queueAppointment.name != 'gqZaT') ||
                          queueAppointment.phone != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            queueAppointment.phone != null
                                ? Text(queueAppointment.phone ?? '')
                                : Container(),
                            (queueAppointment.name != null &&
                                    queueAppointment.name != 'gqZaT')
                                ? Text(queueAppointment.name ?? '')
                                : Container(),
                          ],
                        )
                      : null,
                  trailing: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child:  Text(translate('Close'))),
                                  TextButton(
                                      onPressed: () async {
                                        UtilityService.showLoadingAlert(
                                            context);
                                        if (await CallService
                                            .addToAppointmentQueue(
                                                queueAppointmentId:
                                                    queueAppointment.id)) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          BlocProvider.of<AppointmentPageBloc>(
                                                  context)
                                              .add(RebuildAllTabEvent());
                                          return;
                                        }
                                        Navigator.pop(context);
                                        UtilityService.toast(
                                            context, translate('Something went wrong'));
                                      },
                                      child:  Text(translate('Continue')))
                                ],
                                title:
                                     Text(translate('Confirm adding appointment')),
                                content: Text(translate('${('Do you want to add canceled Appointment')} ${queueAppointment.tokenNumber}?')
                                    ),
                              );
                            });
                      },
                      icon: const Icon(Icons.done_sharp)),
                );
              },
            ),
    );
  }

  void showQueueDetails(QueueAppointmentModel queue, BuildContext context) {
    int? id = queue.id;
    UtilityService.showLoadingAlert(context);
    CallService.getCustomerFlow(
      id: id,
      isQueue: true,
    ).then((value) {
      Navigator.pop(context);
      if (value is bool && value == false) {
        UtilityService.toast(
          context,
         translate ("Something went wrong, can't fetch details"),
        );
        return;
      }
      showBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return CustomerFlowDetails(
              customerFlow: value,
              tokenNumber: queue.tokenNumber,
            );
          });
    });
  }

  Future<void> callToken(
      {required BuildContext context, required int id}) async {
    UtilityService.showLoadingAlert(context);
    var response =
        await CallService.callAppointmentToken(queueAppointmentId: id);
    Navigator.pop(context);
    if (response is TokenModel) {
      BlocProvider.of<SettingsBloc>(context).add(SwitchToHomePageEvent());
      return;
    }
    UtilityService.toast(context,translate ('Something went wrong'));
  }

  ListView listViewNoDataFound() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children:  [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(translate
              ('No Data!'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        )
      ],
    );
  }
}
