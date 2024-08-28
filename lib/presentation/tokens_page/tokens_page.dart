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
import 'package:oneappcounter/extention/string_casing_extention.dart';
import 'package:oneappcounter/model/queue_model.dart';
import 'package:oneappcounter/model/tocken_model.dart';
import 'package:oneappcounter/presentation/popUp/customer_flow_details.dart';
import 'package:oneappcounter/services/call_service.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/socket_services.dart';
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

  @override
  void initState() {
    super.initState();
    rebuildListener = SocketService.tokensPageRebuildRequiredController.stream
        .listen((event) {
      if (event is bool && event) {
        emitRebuildEvent();
      }
    });
  }

  @override
  void dispose() {
    try {
      rebuildListener.cancel();
    } catch (_) {}
    super.dispose();
  }

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
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
                color: Colors.white),
          ),
          bottom: TabBar(
            tabAlignment: TabAlignment.start,
            tabs: _getTabs(),
            labelColor: Colors.white,
            unselectedLabelColor: const Color.fromARGB(255, 216, 214, 214),
            labelPadding: const EdgeInsets.symmetric(horizontal: 12),
            isScrollable: true,
          ),
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
            child: Text(
              "TO CALL",
            ),
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
    if (CounterSettingService.counterSettings?.hideCalled != true) {
      content.add(
        _buildCalledTabView(UtilityService.isDarkTheme),
      );
    }
    if (CounterSettingService.counterSettings?.hideHoldedTokens != true) {
      content.add(
        _buildHoldedTokenTabView(UtilityService.isDarkTheme),
      );
    }
    if (CounterSettingService.counterSettings?.hideCancelled != true) {
      content.add(
        _buildCancelledTabView(UtilityService.isDarkTheme),
      );
    }
    if (CounterSettingService.counterSettings?.hideHoldedQueue != true) {
      content.add(
        _buildHoldedQueueTabView(UtilityService.isDarkTheme),
      );
    }
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
                              child: SizedBox(
                                height: 50,
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
                                                          .cancelQueueItem(
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
                                            title:
                                                const Text(('Cancel Token?')),
                                            content: Text(
                                                "${('Do you want to cancel token')} (${queue.tokenNumber}) ?"),
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.close_outlined),
                                ),
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

  Widget _buildCalledTabView(bool isDarkTheme) {
    return BlocBuilder<TokenPageBloc, TokenPageState>(
      buildWhen: (previous, current) {
        if (previous is RebuildInitState && current is RebuildCalledTabState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            refreshFunction(context);
          },
          child: GeneralDataService.todayCalledTokens.isEmpty
              ? listViewNoDataFound()
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  itemCount: GeneralDataService.todayCalledTokens.isNotEmpty
                      ? GeneralDataService.todayCalledTokens.length
                      : 0,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    TokenModel token =
                        GeneralDataService.todayCalledTokens[index];

                    return ListTile(
                      onTap: () {
                        showTokenDetails(token, context);
                      },
                      tileColor: ((token.queueId != null &&
                                  token.queue['priority'] == 1) ||
                              (token.queueppointmentId != null &&
                                  token.queueppointment['priority'] == 1))
                          ? UtilityService.isDarkTheme
                              ? const Color(0xff184D47)
                              : const Color(0xffA5F0C5)
                          : ((token.queueId != null &&
                                      token.queue['priority'] == 3) ||
                                  (token.queueppointmentId != null &&
                                      token.queueppointment['priority'] == 3))
                              ? UtilityService.isDarkTheme
                                  ? const Color(0xff483042)
                                  : const Color(0xffF3DBCF)
                              : null,
                      leading: IconButton(
                        onPressed: token.status == "no-show"
                            ? () async {
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
                                                _recallToken(context, token.id);
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
                                  _recallToken(context, token.id);
                                }
                              }
                            : null,
                        icon: Icon(
                          Icons.replay,
                          color: token.status == "no-show"
                              ? isDarkTheme
                                  ? Appcolors.materialIconButtonDark
                                  : Colors.blueAccent
                              : null,
                        ),
                      ),
                      title: Text(
                        token.tokenNumber,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: token.queueId != null &&
                              token.queue['customer'] != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                token.queue['customer']['phone'] != null
                                    ? Text(
                                        '+${token.queue['calling_code']} ${token.queue['customer']['phone']}')
                                    : Container(),
                                token.queue['customer']['name'] != null &&
                                        token.queue['customer']['name'] !=
                                            'gqZaT'
                                    ? Text(
                                        token.queue['customer']['name'] ?? '')
                                    : Container(),
                              ],
                            )
                          : token.queueppointmentId != null &&
                                  token.queueppointment['customer'] != null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    token.queueppointment['customer']
                                                ['phone'] !=
                                            null
                                        ? Text(
                                            '+${token.queueppointment['calling_code']} ${token.queueppointment['customer']['phone']}')
                                        : Container(),
                                    token.queueppointment['customer']['name'] !=
                                                null &&
                                            token.queueppointment['customer']
                                                    ['name'] !=
                                                'gqZaT'
                                        ? Text(token.queueppointment['customer']
                                                ['name'] ??
                                            '')
                                        : Container(),
                                  ],
                                )
                              : null,
                      trailing: SizedBox(
                        width: 30,
                        child: token.queueId != null &&
                                token.queue['is_transferred'] == true
                            ? Tooltip(
                                message: token.queue['transfer_to'] != null
                                    ? token.queue['transfer_to']['service']
                                        ['name']
                                    : '',
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    makeReportWidgetFn(token, context),
                                    SizedBox(
                                      width: token.reportReady != null &&
                                              token.reportReady == true
                                          ? 25
                                          : 0,
                                    ),
                                    Text(
                                      'T',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: UtilityService.isDarkTheme
                                            ? const Color(0xff177ddc)
                                            : const Color(0xff1890ff),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 18,
                                    ),
                                    Text(
                                      token.status.toTitleCase()[0],
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: token.statusColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : token.queueppointmentId != null &&
                                    token.queueppointment['is_transferred'] ==
                                        true
                                ? Tooltip(
                                    message:
                                        token.queueppointment['transfer_to']
                                            ['service']['name'],
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        makeReportWidgetFn(token, context),
                                        SizedBox(
                                          width: token.reportReady != null &&
                                                  token.reportReady == true
                                              ? 25
                                              : 0,
                                        ),
                                        Text(
                                          'T',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: UtilityService.isDarkTheme
                                                ? const Color(0xff177ddc)
                                                : const Color(0xff1890ff),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 18,
                                        ),
                                        Text(
                                          token.status.toTitleCase()[0],
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: token.statusColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      makeReportWidgetFn(token, context),
                                      SizedBox(
                                        width: token.reportReady != null &&
                                                token.reportReady == true
                                            ? 25
                                            : 0,
                                      ),
                                      Text(
                                        token.status.toTitleCase()[0],
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: token.statusColor,
                                          fontWeight: FontWeight.bold,
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

  Widget _buildHoldedTokenTabView(bool isDarkTheme) {
    return BlocBuilder<TokenPageBloc, TokenPageState>(
      buildWhen: (previous, current) {
        if (previous is RebuildInitState &&
            current is RebuildHoldedTokenState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            refreshFunction(context);
          },
          child: GeneralDataService.todayCalledHolded.isEmpty
              ? listViewNoDataFound()
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  itemCount: GeneralDataService.todayCalledHolded.isNotEmpty
                      ? GeneralDataService.todayCalledHolded.length
                      : 0,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    TokenModel token =
                        GeneralDataService.todayCalledHolded[index];
                    return ListTile(
                      onTap: () {
                        showTokenDetails(token, context);
                      },
                      tileColor: ((token.queueId != null &&
                                  token.queue['priority'] == 1) ||
                              (token.queueppointmentId != null &&
                                  token.queueppointment['priority'] == 1))
                          ? UtilityService.isDarkTheme
                              ? const Color(0xff184D47)
                              : const Color(0xffA5F0C5)
                          : ((token.queueId != null &&
                                      token.queue['priority'] == 3) ||
                                  (token.queueppointmentId != null &&
                                      token.queueppointment['priority'] == 3))
                              ? UtilityService.isDarkTheme
                                  ? const Color(0xff483042)
                                  : const Color(0xffF3DBCF)
                              : null,
                      leading: IconButton(
                        onPressed: () {
                          if ((GeneralDataService.lastCalledToken != null &&
                                  !GeneralDataService.lastCalledToken!.isHold &&
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
                                          (context, token);
                                        },
                                      )
                                    ],
                                  );
                                });
                          } else if ((GeneralDataService.lastCalledToken != null &&
                                  !GeneralDataService.lastCalledToken!.isHold &&
                                  GeneralDataService.lastCalledToken!.status !=
                                      'no-show') &&
                              CounterSettingService.counterSettings?.requireTransfer ==
                                  true &&
                              ((GeneralDataService.lastCalledToken!.queue != null &&
                                      GeneralDataService.lastCalledToken!
                                              .queue['is_transferred'] !=
                                          true) ||
                                  (GeneralDataService.lastCalledToken!.queueppointment != null &&
                                      GeneralDataService.lastCalledToken!.queueppointment['is_transferred'] != true))) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title:
                                        const Text(('Transfer is required !')),
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
                            _callUnholdToken(context, token);
                          }
                        },
                        icon: Icon(
                          Icons.play_circle,
                          color: isDarkTheme
                              ? Appcolors.materialIconButtonDark
                              : Colors.blueAccent,
                        ),
                      ),
                      title: Text(
                        token.tokenNumber,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: token.queueId != null &&
                              token.queue['customer'] != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                token.queue['customer']['phone'] != null
                                    ? Text(
                                        '+${token.queue['calling_code']} ${token.queue['customer']['phone']}')
                                    : Container(),
                                token.queue['customer']['name'] != null
                                    ? Text(
                                        token.queue['customer']['name'] ?? '')
                                    : Container(),
                              ],
                            )
                          : token.queueppointmentId != null &&
                                  token.queueppointment['customer'] != null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    token.queueppointment['customer']
                                                ['phone'] !=
                                            null
                                        ? Text(
                                            "+${token.queueppointment['calling_code']} ${token.queueppointment['customer']['phone']}")
                                        : Container(),
                                    token.queueppointment['customer']['name'] !=
                                            null
                                        ? Text(token.queueppointment['customer']
                                                ['name'] ??
                                            '')
                                        : Container(),
                                  ],
                                )
                              : null,
                    );
                  }),
        );
      },
    );
  }

  Widget _buildCancelledTabView(bool isDarkTheme) {
    return BlocBuilder<TokenPageBloc, TokenPageState>(
      buildWhen: (previous, current) {
        if (previous is RebuildInitState && current is RebuildCancelledState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            refreshFunction(context);
          },
          child: GeneralDataService.todaysQueueCancelled.isEmpty
              ? listViewNoDataFound()
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  itemCount: GeneralDataService.todaysQueueCancelled.isNotEmpty
                      ? GeneralDataService.todaysQueueCancelled.length
                      : 0,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    QueueModel queue =
                        GeneralDataService.todaysQueueCancelled[index];
                    return ListTile(
                      onTap: () {
                        showQueueDetails(queue, context);
                      },
                      tileColor: queue.priority == 1
                          ? UtilityService.isDarkTheme
                              ? const Color(0xff184D47)
                              : const Color(0xffA5F0C5)
                          : queue.priority == 3
                              ? UtilityService.isDarkTheme
                                  ? const Color(0xff483042)
                                  : const Color(0xffF3DBCF)
                              : null,
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
                                          child: const Text(('Cancel')),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            UtilityService.showLoadingAlert(
                                                context);
                                            var res = await CallService
                                                .addCancelledTokenToQueue(
                                                    queueId: queue.id);
                                            Navigator.pop(context);
                                            if (res is bool && res) {
                                              Navigator.pop(context);

                                              ///rebuid this..
                                              ///

                                              if (CounterSettingService
                                                      .counterSettings
                                                      ?.hideCancelled !=
                                                  true) {
                                                BlocProvider.of<TokenPageBloc>(
                                                        context)
                                                    .add(
                                                        RebuildCancelledEvent());
                                              }

                                              ///rebuild to call
                                              ///
                                              if (CounterSettingService
                                                      .counterSettings
                                                      ?.hideNextToCall !=
                                                  true) {
                                                BlocProvider.of<TokenPageBloc>(
                                                        context)
                                                    .add(RebuildToCallEvent());
                                              }
                                              return;
                                            }
                                            UtilityService.toast(context,
                                                ('Something went wrong'));
                                          },
                                          child: const Text(('Continue')),
                                        )
                                      ],
                                      title: const Text(
                                          ('Adding Cancelled Token To Queue')),
                                      content: Text(
                                          '${('Do you want to add canceled token')} ${queue.tokenNumber}?'),
                                    );
                                  });
                            },
                            icon: const Icon(Icons.done)),
                      ),
                    );
                  }),
        );
      },
    );
  }

  Widget _buildHoldedQueueTabView(bool isDarkTheme) {
    return BlocBuilder<TokenPageBloc, TokenPageState>(
      buildWhen: (previous, current) {
        if (previous is RebuildInitState &&
            current is RebuildHoldedQueueState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            refreshFunction(context);
          },
          child: GeneralDataService.holdedQueue.isEmpty
              ? listViewNoDataFound()
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  itemCount: GeneralDataService.holdedQueue.isNotEmpty
                      ? GeneralDataService.holdedQueue.length
                      : 0,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    QueueModel queue = GeneralDataService.holdedQueue[index];
                    return ListTile(
                      onTap: () {
                        showQueueDetails(queue, context);
                      },
                      tileColor: queue.priority == 1
                          ? UtilityService.isDarkTheme
                              ? const Color(0xff184D47)
                              : const Color(0xffA5F0C5)
                          : queue.priority == 3
                              ? UtilityService.isDarkTheme
                                  ? const Color(0xff483042)
                                  : const Color(0xffF3DBCF)
                              : null,
                      leading: IconButton(
                        onPressed: () async {
                          UtilityService.showLoadingAlert(context);
                          var response = await CallService.callTokenFromQueue(
                              queueId: queue.id);
                          Navigator.pop(context);
                          if (response is TokenModel) {
                            BlocProvider.of<SettingsBloc>(context)
                                .add(SwitchToHomePageEvent());
                            return;
                          }
                          UtilityService.toast(
                              context, ('Something went wrong'));
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
                                                  child:
                                                      const Text(('Cancel'))),
                                              TextButton(
                                                  onPressed: () async {
                                                    UtilityService
                                                        .showLoadingAlert(
                                                            context);
                                                    var response =
                                                        await CallService
                                                            .unholdQueueToken(
                                                                queueId:
                                                                    queue.id);
                                                    Navigator.pop(context);
                                                    if (response is bool &&
                                                        response) {
                                                      Navigator.pop(context);

                                                      ///rebuild this
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

                                                      ///rebuild to call
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
                                                      return;
                                                    }
                                                  },
                                                  child:
                                                      const Text(('Continue'))),
                                            ],
                                            title:
                                                const Text(('Unholding Token')),
                                            content: Text(
                                                '${('Do you want to unhold token')} ${queue.tokenNumber}?'),
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.play_arrow)),
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
                                                  UtilityService
                                                      .showLoadingAlert(
                                                          context);
                                                  var response =
                                                      await CallService
                                                          .cancelQueueItem(
                                                              queueId:
                                                                  queue.id);
                                                  Navigator.pop(context);
                                                  if (response is bool &&
                                                      response) {
                                                    ///rebuild this ..
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
                                                  UtilityService.toast(context,
                                                      ("Something went wrong"));
                                                },
                                                child: const Text(('Continue')))
                                          ],
                                          title: const Text(('Cancel Token?')),
                                          content: Text(
                                              "${('Do you want to cancel token')}(${queue.tokenNumber})?"),
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

  void showTokenDetails(TokenModel token, BuildContext context) {
    int? id = token.queueId ?? token.queueppointmentId;
    UtilityService.showLoadingAlert(context);
    CallService.getCustomerFlow(
      id: id ?? 0,
      isQueue: token.queueId != null ? true : false,
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
              tokenNumber: token.tokenNumber,
            );
          });
    });
  }

  void _callUnholdToken(BuildContext context, TokenModel token) {
    UtilityService.showLoadingAlert(context);
    CallService.unholdToken(id: token.id).then((value) {
      Navigator.pop(context);
      if (value is! TokenModel) {
        UtilityService.toast(context, ('Something went wrong'));
        return;
      }
      BlocProvider.of<SettingsBloc>(context).add(SwitchToHomePageEvent());
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

  Future<void> markReportReadyFn(BuildContext context, TokenModel token) async {
    bool showonDisplay = false;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                child: const Text(
                  ('Close'),
                ),
              ),
              TextButton(
                onPressed: () async {
                  UtilityService.showLoadingAlert(context);
                  if (await CallService.markReportReady(
                      callId: token.id, showOnDisplay: showonDisplay)) {
                    Navigator.pop(context);

                    Navigator.pop(context);

                    UtilityService.toast(
                      context,
                      ('Updated'),
                    );
                    emitRebuildEvent();
                    return;
                  }
                  Navigator.pop(context);
                  UtilityService.toast(
                    context,
                    ('Something went wrong'),
                  );
                },
                child: const Text(('Yes')),
              )
            ],
            content: SizedBox(
              height: 15,
              child: Column(
                children: [
                  Text(
                    '${('Mark Report Ready on')} ${token.tokenNumber}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(('Show on Display')),
                      StatefulBuilder(builder:
                          (BuildContext context, StateSetter checkBoxSetState) {
                        return Checkbox(
                          value: showonDisplay,
                          onChanged: (value) {
                            checkBoxSetState(() {
                              showonDisplay = value ?? false;
                            });
                          },
                        );
                      }),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void showQueueDetails(QueueModel queue, BuildContext context) {
    int? id = queue.id;
    UtilityService.showLoadingAlert(context);
    CallService.getCustomerFlow(
      id: id,
      isQueue: true,
    ).then((value) {
      Navigator.pop(context); // Close the loading dialog
      if (value is bool && value == false) {
        UtilityService.toast(
          context,
          "Something went wrong, can't fetch details",
        );
        return;
      }
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.75, // 75% of the screen height
            child: CustomerFlowDetails(
              customerFlow: value,
              tokenNumber: queue.tokenNumber,
            ),
          );
        },
      );
    }).catchError((e) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      UtilityService.toast(context, "An error occurred: $e");
    });
  }

  // void showQueueDetails(QueueModel queue, BuildContext context) {
  //   int? id = queue.id;
  //   UtilityService.showLoadingAlert(context);
  //   CallService.getCustomerFlow(
  //     id: id,
  //     isQueue: true,
  //   ).then((value) {
  //     Navigator.pop(context);
  //     if (value is bool && value == false) {
  //       UtilityService.toast(
  //         context,
  //         ("Something went wrong, can't fetch details"),
  //       );
  //       return;
  //     }
  //     showBottomSheet(
  //         backgroundColor: Colors.transparent,
  //         context: context,
  //         builder: (context) {
  //           return CustomerFlowDetails(
  //             customerFlow: value,
  //             tokenNumber: queue.tokenNumber,
  //           );
  //         });
  //   });
  // }

  Widget makeReportWidgetFn(TokenModel token, BuildContext context) {
    return token.reportReady != null
        ? token.reportReady != true
            ? TextButton(
                onPressed: () async {
                  await markReportReadyFn(context, token);
                },
                child: const Text(
                  'R',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : const Text(
                'R',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
        : Container();
  }
}
