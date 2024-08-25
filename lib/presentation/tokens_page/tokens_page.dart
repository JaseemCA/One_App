// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_event.dart';
import 'package:oneappcounter/bloc/tocken_page/bloc/tocken_bloc.dart';
import 'package:oneappcounter/bloc/tocken_page/bloc/tocken_event.dart';
import 'package:oneappcounter/bloc/tocken_page/bloc/tocken_state.dart';
import 'package:oneappcounter/common/widgets/button/count_down_button.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/model/queue_model.dart';
import 'package:oneappcounter/model/tocken_model.dart';
import 'package:oneappcounter/presentation/popUp/customer_flow_details.dart';
import 'package:oneappcounter/services/call_service.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/utility_services.dart';

class TokensPage extends StatefulWidget {
  const TokensPage({super.key});

  @override
  State<TokensPage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<TokensPage> {
  late StreamSubscription rebuildListener;

  Future<void> refreshFunction(BuildContext context) async {
    UtilityService.showLoadingAlert(context);
    await GeneralDataService.reloadData();
    Navigator.pop(context);

    emitRebuildEvent();
  }

  void emitRebuildEvent() {
    if (CounterSettingService.counterSettings?.hideNextToCall != true) {
      BlocProvider.of<TokenPageBloc>(context).add(RebuildToCallEvent());
    }

    if (CounterSettingService.counterSettings?.hideCalled != true) {
      BlocProvider.of<TokenPageBloc>(context).add(RebuildCalledEvent());
    }

    if (CounterSettingService.counterSettings?.hideHoldedTokens != true) {
      BlocProvider.of<TokenPageBloc>(context).add(RebuildHoldedTokenEvent());
    }

    if (CounterSettingService.counterSettings?.hideCancelled != true) {
      BlocProvider.of<TokenPageBloc>(context).add(RebuildCancelledEvent());
    }

    if (CounterSettingService.counterSettings?.hideHoldedQueue != true) {
      BlocProvider.of<TokenPageBloc>(context).add(RebuildHoldedQueueEvent());
    }
  }

  // @override
  // void initState() {
  //   super.initState();

  //   // SocketService.registerEvents(isAll: true);

  //   rebuildListener = SocketService.tokensPageRebuildRequiredController.stream
  //       .listen((event) {
  //     if (event is bool && event) {
  //       emitRebuildEvent();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      length: _getTabs().length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: isDarkMode
              ? Appcolors.bottomsheetDarkcolor
              : Appcolors.appBackgrondcolor,
          title: Text(
            '${('Tokens')} (${GeneralDataService.currentServiceCounterTab?.serviceString})',
            maxLines: 1,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),

          bottom: TabBar(
            tabs: _getTabs(),
            labelPadding: const EdgeInsets.symmetric(horizontal: 12),
            isScrollable: true,
          ),

          // bottom: const CustomTabBar(
          //   alignment: TabAlignment.start,
          //   tabCount: 5,
          //   tabLabels: [
          //     "TO CALL",
          //     "CALLED",
          //     "HOLDED TOKEN",
          //     "CANCELLED",
          //     "HOLDED QUEUE"
          //   ],
          //   isScrolable: true,
          // ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            refreshFunction(context);
          },
          child: Stack(
            children: [
              ListView(),
              TabBarView(
                children: _getTabContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Tab> _getTabs() {
    List<Tab> content = [];
    if (CounterSettingService.counterSettings?.hideNextToCall != true) {
      content.add(
        const Tab(
          child: FittedBox(
            child: Text("TO CALL"),
          ),
        ),
      );
    }
    if (CounterSettingService.counterSettings?.hideCalled != true) {
      content.add(
        const Tab(
          child: FittedBox(child: Text(("CALLED"))),
        ),
      );
    }
    if (CounterSettingService.counterSettings?.hideHoldedTokens != true) {
      content.add(
        const Tab(
          child: FittedBox(child: Text(("HOLDED TOKEN"))),
        ),
      );
    }
    if (CounterSettingService.counterSettings?.hideCancelled != true) {
      content.add(
        const Tab(
          child: FittedBox(child: Text(("CANCELLED"))),
        ),
      );
    }
    if (CounterSettingService.counterSettings?.hideHoldedQueue != true) {
      content.add(
        const Tab(
          child: FittedBox(child: Text(("HOLDED QUEUE"))),
        ),
      );
    }
    return content;
  }

  List<Widget> _getTabContent(BuildContext context) {
    List<Widget> content = [];

    if (CounterSettingService.counterSettings?.hideNextToCall != true) {
      content.add(_buildToCallTabView(UtilityService.isDarkTheme));
    }
    // if (CounterSettingService.counterSettings?.hideCalled != true) {
    //   _content.add(
    //     _buildCalledTabView(UtilityService.isDarkTheme),
    //   );
    // }
    // if (CounterSettingService.counterSettings?.hideHoldedTokens != true) {
    //   _content.add(
    //     _buildHoldedTokenTabView(UtilityService.isDarkTheme),
    //   );
    // }
    // if (CounterSettingService.counterSettings?.hideCancelled != true) {
    //   _content.add(
    //     _buildCancelledTabView(UtilityService.isDarkTheme),
    //   );
    // }
    // if (CounterSettingService.counterSettings?.hideHoldedQueue != true) {
    //   _content.add(
    //     _buildHoldedQueueTabView(UtilityService.isDarkTheme),
    //   );
    // }
    return content;
  }

  Widget _buildToCallTabView(bool isDarkTheme) {
    return BlocBuilder<TokenPageBloc, TokenPageState>(
      buildWhen: (previous, current) {
        if (previous is RebuildInitState && current is RebuildToCallTabState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            refreshFunction(context);
          },
          child: GeneralDataService.todaysQueue.isEmpty
              ? listViewNoDataFound()
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  itemCount: GeneralDataService.todaysQueue.isNotEmpty
                      ? GeneralDataService.todaysQueue.length
                      : 0,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    QueueModel queue = GeneralDataService.todaysQueue[index];
                    return ListTile(
                      onTap: () {
                        showQueueDetails(queue, context);
                      },
                      tileColor: queue.priority == 1
                          ? UtilityService.isDarkTheme
                              ? const Color(0xff184D47)
                              : const Color.fromARGB(255, 232, 255, 242)
                          : queue.priority == 3
                              ? UtilityService.isDarkTheme
                                  ? const Color(0xff483042)
                                  : const Color(0xffF3DBCF)
                              : null,
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
                                          title: const Text(
                                              ('Alert (Not transferred!)')),
                                          content: Text(
                                              '${GeneralDataService.lastCalledToken!.tokenNumber} ${('Not transferred, Continue Calling?')}'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(('Cancel')),
                                            ),
                                            CountDownButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                await callToken(
                                                    context: context,
                                                    id: queue.id);
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
                                    CounterSettingService
                                            .counterSettings?.requireTransfer ==
                                        true &&
                                    ((GeneralDataService.lastCalledToken!.queue != null && GeneralDataService.lastCalledToken!.queue['is_transferred'] != true) ||
                                        (GeneralDataService.lastCalledToken!.queueppointment != null &&
                                            GeneralDataService.lastCalledToken!.queueppointment['is_transferred'] != true))) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              ('Transfer is required !')),
                                          content: Text(
                                              '${GeneralDataService.lastCalledToken!.tokenNumber} ${('Not transferred')}'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(('Close')),
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  callToken(context: context, id: queue.id);
                                }
                              },
                        icon: Icon(
                          Icons.call,
                          color: isDarkTheme
                              ? Appcolors.materialIconButtonDark
                              : Colors.blueAccent,
                        ),
                      ),
                      title: Text(
                        queue.tokenNumber,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: (queue.phone != null || queue.name != null)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                queue.phone != null
                                    ? Text(queue.phone ?? '')
                                    : Container(),
                                queue.name != null
                                    ? Text(queue.name ?? '')
                                    : Container(),
                              ],
                            )
                          : null,
                      trailing: SizedBox(
                        width: 30,
                        child: Row(
                          children: [
                            Expanded(
                              child: IconButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                ('Cancel'),
                                              ),
                                            ),
                                            TextButton(
                                                onPressed: () async {
                                                  UtilityService
                                                      .showLoadingAlert(
                                                          context);
                                                  var response =
                                                      await CallService
                                                          .holdQueueItem(
                                                              queueId:
                                                                  queue.id);
                                                  Navigator.pop(context);
                                                  if (response is bool &&
                                                      response) {
                                                    ///rebuild this ..
                                                    ///
                                                    if (CounterSettingService
                                                            .counterSettings
                                                            ?.hideNextToCall !=
                                                        true) {
                                                      BlocProvider.of<
                                                                  TokenPageBloc>(
                                                              context)
                                                          .add(
                                                              RebuildToCallEvent());
                                                    }

                                                    ///rebuild holded queue tab...
                                                    ///
                                                    if (CounterSettingService
                                                            .counterSettings
                                                            ?.hideHoldedQueue !=
                                                        true) {
                                                      BlocProvider.of<
                                                                  TokenPageBloc>(
                                                              context)
                                                          .add(
                                                              RebuildHoldedQueueEvent());
                                                    }
                                                    Navigator.pop(context);
                                                    return;
                                                  }

                                                  UtilityService.toast(context,
                                                      ('Something went wrong'));
                                                },
                                                child: const Text(('Continue')))
                                          ],
                                          title: const Text(('Hold Token')),
                                          content: Text(
                                              "${('Do you want to hold token')} (${queue.tokenNumber})?"),
                                        );
                                      });
                                },
                                icon: const Icon(Icons.pause_outlined),
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                ('Cancel'),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                UtilityService.showLoadingAlert(
                                                    context);
                                                var response = await CallService
                                                    .cancelQueueItem(
                                                        queueId: queue.id);
                                                Navigator.pop(context);
                                                if (response is bool &&
                                                    response) {
                                                  ///rebuild this ..
                                                  ///
                                                  if (CounterSettingService
                                                          .counterSettings
                                                          ?.hideNextToCall !=
                                                      true) {
                                                    BlocProvider.of<
                                                                TokenPageBloc>(
                                                            context)
                                                        .add(
                                                            RebuildToCallEvent());
                                                  }

                                                  ///rebuild holded queue tab...
                                                  ///
                                                  if (CounterSettingService
                                                          .counterSettings
                                                          ?.hideCancelled !=
                                                      true) {
                                                    BlocProvider.of<
                                                                TokenPageBloc>(
                                                            context)
                                                        .add(
                                                            RebuildCancelledEvent());
                                                  }
                                                  Navigator.pop(context);
                                                  return;
                                                }
                                                UtilityService.toast(
                                                  context,
                                                  ("Something went wrong"),
                                                );
                                              },
                                              child: const Text(
                                                ('Continue'),
                                              ),
                                            ),
                                          ],
                                          title: const Text(('Cancel Token?')),
                                          content: Text(
                                              "${('Do you want to cancel token')} (${queue.tokenNumber}) ?"),
                                        );
                                      });
                                },
                                icon: const Icon(Icons.close_outlined),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
        );
      },
    );
  }

  ListView listViewNoDataFound() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Text(
              ('No Data!'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        )
      ],
    );
  }

  void showQueueDetails(QueueModel queue, BuildContext context) {
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
          ("Something went wrong, can't fetch details"),
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
    var response = await CallService.callTokenFromQueue(queueId: id);
    Navigator.pop(context);
    if (response is TokenModel) {
      BlocProvider.of<SettingsBloc>(context).add(SwitchToHomePageEvent());
      return;
    }
    UtilityService.toast(context, ('Something went wrong'));
  }

  Future<void> _recallToken(BuildContext context, int tokenId) async {
    UtilityService.showLoadingAlert(context);
    var res = await CallService.recallToken(id: tokenId);
    Navigator.pop(context);
    if (res is TokenModel) {
      
      
      BlocProvider.of<SettingsBloc>(context).add(SwitchToHomePageEvent());
      return;
    }
    UtilityService.toast(context, ("Something went wrong"));
  }
}
