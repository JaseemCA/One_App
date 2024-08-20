import 'package:flutter/material.dart';
import 'package:oneappcounter/extention/string_casing_extention.dart';
import 'package:oneappcounter/model/queue_appointment_model.dart';
import 'package:oneappcounter/model/queue_model.dart';
import 'package:oneappcounter/services/utility_services.dart';
import 'package:sizer/sizer.dart';

class CustomerFlowDetails extends StatelessWidget {
  const CustomerFlowDetails({
    super.key,
    required this.customerFlow,
    required this.tokenNumber,
  });

  final List<dynamic> customerFlow;
  final String tokenNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              child: Container(
            color: Colors.transparent,
          )),
          Container(
            height: 38.h,
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
                          '${('Customer Flow')} ($tokenNumber)',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      IconButton(
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close_outlined),
                      )
                    ],
                  ),
                  const Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text(
                            '#',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                      Expanded(
                        flex: 4,
                        child: Text(
                          ('Service'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          ('Counter'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          ('User'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          ('Status'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                  const Divider(),
                  _getCustomerFlowReport(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCustomerFlowReport() {
    List<Widget> widgetList = [];
    int count = 0;
    for (var item in customerFlow) {
      count++;
      Widget rowItem;
      if (item is QueueModel) {
        rowItem = Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                child: Text(
                  item.service['name'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                child: Text(
                  item.called == true && item.call != null
                      ? item.call['counter']['name']
                      : ('NIL'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                child: Text(
                  item.called == true && item.call != null
                      ? item.call['user']['name']
                      : ('NIL'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                child: Text(
                  item.called == true && item.call != null
                      ? item.call['status'] == null
                          ? 'Serving'
                          : item.call['status'].toString().toTitleCase()
                      : ('Not Called'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            )
          ],
        );
        widgetList.add(rowItem);
      } else if (item is QueueAppointmentModel) {
        rowItem = Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '$count',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                item.service['name'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                item.called == true && item.call != null
                    ? item.call['counter']['name']
                    : ('NIL'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                item.called == true && item.call != null
                    ? item.call['user']['name']
                    : ('NIL'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                item.called == true && item.call != null
                    ? item.call['status'] == null
                        ? 'Serving'
                        : item.call['status'].toString().toTitleCase()
                    : ('Not Called'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            )
          ],
        );
        widgetList.add(rowItem);
      }
    }

    return Expanded(
      child: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            children: widgetList,
          ),
        ),
      ),
    );
  }
}
