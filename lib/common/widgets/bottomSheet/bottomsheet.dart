

import 'package:flutter/material.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key});

  @override
  BottomSheetContentState createState() => BottomSheetContentState();
}

class BottomSheetContentState extends State<BottomSheetContent> {
  final List<String> services = ['Service 1', 'Service 2', 'Service 3'];
  final List<String> counters = ['Counter 1', 'Counter 2', 'Counter 3'];
  List<String> selectedServices = [];
  List<String> selectedCounters = [];
  late TextEditingController _servicesController;
  late TextEditingController _countersController;

  @override
  void initState() {
    super.initState();
    _servicesController =
        TextEditingController(text: selectedServices.join(', '));
    _countersController =
        TextEditingController(text: selectedCounters.join(', '));
  }

  @override
  void dispose() {
    _servicesController.dispose();
    _countersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDarkMode
        ? Appcolors.bottomsheetDarkcolor
        : Appcolors.cardDetailTextColor;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      child: Container(
        height: 400,
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Select Services And Counter',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _showServiceSelection,
              child: AbsorbPointer(
                child: TextField(
                  controller: _servicesController,
                  decoration: const InputDecoration(
                    hintText: 'Services',
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _showCounterSelection,
              child: AbsorbPointer(
                child: TextField(
                  controller: _countersController,
                  decoration: const InputDecoration(
                    hintText: 'Counters',
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              text: "Save",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showServiceSelection() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TextField(
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: services.map((service) {
                            return CheckboxListTile(
                              title: Text(service),
                              value: selectedServices.contains(service),
                              onChanged: (bool? selected) {
                                setState(() {
                                  if (selected == true) {
                                    selectedServices.add(service);
                                  } else {
                                    selectedServices.remove(service);
                                  }

                                  _servicesController.text =
                                      selectedServices.join(', ');
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CustomElevatedButton(
                        text: "OK",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showCounterSelection() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: counters.map((counter) {
                        return ListTile(
                          title: Text(counter),
                          onTap: () {
                            setState(() {
                              selectedCounters.clear();
                              selectedCounters.add(counter);
                              _countersController.text = counter;
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
