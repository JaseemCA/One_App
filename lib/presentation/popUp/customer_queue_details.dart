import 'package:flutter/material.dart';
import 'package:oneappcounter/services/utility_services.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';

class CustomerQueueDetails extends StatelessWidget {
  const CustomerQueueDetails({
    super.key,
    required this.serviceDetails,
    this.phone,
    this.email,
    this.name,
  });

  final List<dynamic> serviceDetails;
  final String? phone;
  final String? name;
  final String? email;

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
            height: serviceDetails.isEmpty ? 30.h : 38.h,
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
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            ('Token Details'),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
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
                  const Divider(),
                  _buildDataWidget(context)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataWidget(BuildContext context) {
    List<Widget> data = [];
    if (phone != null && phone!.isNotEmpty) {
      data.add(Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(('Phone: ')),
          ),
          Expanded(
            flex: 4,
            child: Text('$phone'),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                copyText(context, '$phone', key: ('Phone'));
              },
              icon: const Icon(Icons.content_copy),
            ),
          )
        ],
      ));
    }
    if (name != null && name!.isNotEmpty) {
      data.add(Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(('Name: ')),
          ),
          Expanded(
            flex: 4,
            child: Text('$name'),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                copyText(context, '$name', key: ('Name'));
              },
              icon: const Icon(Icons.content_copy),
            ),
          )
        ],
      ));
    }
    if (email != null && email!.isNotEmpty) {
      data.add(Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(('Email: ')),
          ),
          Expanded(
            flex: 4,
            child: Text('$email'),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                copyText(context, '$email', key: ('Email'));
              },
              icon: const Icon(Icons.content_copy),
            ),
          )
        ],
      ));
    }
    for (var item in serviceDetails) {
      Widget itemWidgetRow;
      if (item['type'] == "checkbox") {
        String itemValString = item['value'] != null
            ? item['value'].toString().replaceAll(RegExp('[^A-Za-z0-9,]'), '')
            : '';
        itemWidgetRow = Row(
          children: [
            Expanded(
              flex: 2,
              child: Text('${item['name']}: '),
            ),
            Expanded(
              flex: 4,
              child: Text(itemValString),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  copyText(context, itemValString, key: item['name']);
                },
                icon: const Icon(Icons.content_copy),
              ),
            )
          ],
        );
      } else {
        itemWidgetRow = Row(
          children: [
            Expanded(
              flex: 2,
              child: Text('${item['name']}: '),
            ),
            Expanded(
              flex: 5,
              child: Text(item['value'] ?? ''),
            ),
            Expanded(
              flex: 1,
              child: item['value'] != null
                  ? IconButton(
                      onPressed: () {
                        copyText(context, item['value'], key: item['name']);
                      },
                      icon: const Icon(Icons.content_copy),
                    )
                  : Container(),
            )
          ],
        );
      }
      data.add(itemWidgetRow);
    }
    return Expanded(
      child: SizedBox(
        child: SingleChildScrollView(
          child: Column(children: data),
        ),
      ),
    );
  }

  copyText(BuildContext context, String text, {required String key}) {
    Clipboard.setData(ClipboardData(text: text))
        .then((value) => UtilityService.toast(context, '$key Copied!'));
  }
}
