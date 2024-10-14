// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/model/service_model.dart';
import 'package:oneappcounter/model/tocken_model.dart';
import 'package:oneappcounter/services/call_service.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/utility_services.dart';
import 'package:sizer/sizer.dart';

class RemarksPopup extends StatefulWidget {
  const RemarksPopup({super.key, required this.token});

  final TokenModel? token;

  @override
  State<RemarksPopup> createState() => _RemarksPopupState();
}

class _RemarksPopupState extends State<RemarksPopup> {
  final _remarkTextController = TextEditingController();

  bool isTextChanged = true;
  StateSetter? statusLabel;
  String previous = '';

  @override
  void dispose() {
    _remarkTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ServiceModel service = GeneralDataService.activeServices
        .firstWhere((element) => element.id == widget.token?.serviceId);
    if (service.remarks != null &&
        ((widget.token?.queue != null &&
                widget.token?.queue['remarks'] == null) ||
            (widget.token?.queueppointment != null &&
                widget.token?.queueppointment['remarks'] == null))) {
      _remarkTextController.text = service.remarks ?? '';
      previous = service.remarks ?? '';
    } else if (widget.token?.queue != null &&
        widget.token?.queue['remarks'] != null) {
      _remarkTextController.text = widget.token?.queue['remarks'] ?? '';
      isTextChanged = false;
      previous = widget.token?.queue['remarks'] ?? '';
    } else if (widget.token?.queueppointment != null &&
        widget.token?.queueppointment['remarks'] != null) {
      _remarkTextController.text =
          widget.token?.queueppointment['remarks'] ?? '';
      isTextChanged = false;
      previous = widget.token?.queueppointment['remarks'] ?? '';
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(child: SizedBox()),
            Container(
              height: 42.h,
              width: 100.w,
              decoration: BoxDecoration(
                color: UtilityService.isDarkTheme
                    ? Colors.grey.shade800
                    : Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            translate('Remarks'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        IconButton(
                          alignment: Alignment.centerRight,
                          onPressed: () async {
                            if (isTextChanged == true) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('${translate('Not Saved')}!'),
                                      content: Text(
                                          translate('Not Saved Last Change')),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(translate('Cancel'))),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: Text(translate('OK')))
                                      ],
                                    );
                                  });
                              return;
                            }
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close_outlined),
                        )
                      ],
                    ),
                    TextFormField(
                      controller: _remarkTextController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      onChanged: (text) {
                        if (text.trim() != previous.trim()) {
                          previous = text.trim();
                          isTextChanged = true;
                          statusLabel!(() {});
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: StatefulBuilder(
                            builder: (BuildContext context,
                                StateSetter statusLabelState) {
                              statusLabel = statusLabelState;
                              return Text(
                                isTextChanged
                                    ? translate('Not Saved')
                                    : translate('Saved'),
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: CustomElevatedButton(
                              onPressed: () async {
                                UtilityService.showLoadingAlert(context);
                                if (await CallService.saveQueueRemark(
                                    id: widget.token?.queueId ??
                                        widget.token?.queueppointmentId ??
                                        0,
                                    remarks: _remarkTextController.text,
                                    isAppointment:
                                        widget.token?.queue == null &&
                                                widget.token?.queueppointment !=
                                                    null
                                            ? true
                                            : false)) {
                                  isTextChanged = false;
                                  Navigator.pop(context);
                                  statusLabel!(() {});
                                  UtilityService.toast(
                                      context, translate('Saved'));
                                  return;
                                }
                                Navigator.pop(context);
                                UtilityService.toast(
                                    context, translate('Something went wrong'));
                              },
                              child: Text(
                                translate('Save'),
                              ),
                            )),
                        Expanded(
                          flex: 2,
                          child: (widget.token?.queueId != null &&
                                      service.remarks != null) ||
                                  (widget.token?.queueppointmentId != null &&
                                      widget.token?.token['appointment'] !=
                                          null &&
                                      widget.token?.token['appointment']
                                              ['remarks'] !=
                                          null)
                              ? SizedBox(
                                  height: 40,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        padding: const EdgeInsets.only(
                                            top: 0,
                                            bottom: 0,
                                            right: 0,
                                            left: 0),
                                        minimumSize: const Size(10, 10)),
                                    onPressed: () {
                                      if (widget.token?.queueId != null) {
                                        _remarkTextController.text =
                                            '${_remarkTextController.text}\n${service.remarks}';
                                      } else if (widget
                                              .token?.queueppointmentId !=
                                          null) {
                                        String appRemark = widget.token
                                                    ?.token['appointment'] !=
                                                null
                                            ? widget.token?.token['appointment']
                                                    ['remarks'] ??
                                                ''
                                            : '';
                                        _remarkTextController.text =
                                            '${_remarkTextController.text}\n$appRemark';
                                      }

                                      isTextChanged = true;
                                      statusLabel!(() {});
                                    },
                                    child: Text(
                                      translate('Service Remark'),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 40,
                                ),
                        )
                      ],
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
