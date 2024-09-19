import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspection_poc/poc_controller.dart';

class DynamicForm extends StatelessWidget {
  final PocController controller = Get.find<PocController>();
  final RxMap<String, dynamic> formValues =
      <String, dynamic>{}.obs; // To store the form values

  DynamicForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final data = controller.currentPage.value!;
        final String formTitle = data["title"];
        final List<dynamic> formData = data["form"];

        return Scaffold(
          appBar: AppBar(
            title: Text(
              formTitle,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.orange,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            color: Colors.grey.shade200,
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: formData.length,
                    itemBuilder: (context, index) {
                      final field = formData[index];
                      return _buildFormField(field);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 15,
                      );
                    },
                  ).paddingSymmetric(horizontal: 16, vertical: 8),
                ),
                bottomBar(formTitle),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget bottomBar(String formTitle) {
    return Container(
      color: Colors.black12,
      child: Row(
        children: [
          Obx(
            () {
              if (controller.showPreviousButton.isTrue) {
                return button(
                    title: "Previous",
                    onClick: () {
                      controller.savePage(formTitle, formValues);
                      controller.previousPage();
                    });
              }
              return Container();
            },
          ),
          const Spacer(),
          Obx(
            () {
              if (controller.showNextButton.isTrue) {
                return button(
                    title: "Next",
                    onClick: () {
                      if(controller.validateFormFields(formValues)){
                        controller.savePage(formTitle, formValues);
                        controller.nextPage();
                      } else {
                        controller.showValidationError();
                      }
                    });
              }
              return Container();
            },
          ),
        ],
      ).paddingSymmetric(horizontal: 10),
    );
  }

  Widget _buildFormField(Map<String, dynamic> field) {
    switch (field['type']) {
      case 'checkbox':
        return _buildCheckboxField(field);
      case 'radio':
        return _buildRadioField(field);
      case 'date':
        return _buildDatePickerField(field);
      default:
        return const SizedBox.shrink(); // If the type is not supported
    }
  }

  Widget _buildCheckboxField(Map<String, dynamic> field) {
    final String title = field['title'];
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          Column(
            children: (field['options'] as List<dynamic>).map((option) {
              return Obx(
                () {
                  return CheckboxListTile(
                    title: Text(option['val']),
                    value: formValues[field['key']]?[option['key']] ?? false,
                    onChanged: (value) {
                      bool allowMultiCheck = true; // from api
                      if (allowMultiCheck) {
                        final map = formValues[title] ?? {};
                        map[option['key']] = value;
                        formValues[field['key']] = map;
                      } else {
                        formValues[title] = {option['key']: value};
                      }
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioField(Map<String, dynamic> field) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field['title'],
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black54)),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          field['rule'].toString().toLowerCase() == 'horizontal'
              ? Wrap(
                  children: (field['options'] as List<dynamic>).map((option) {
                    return Obx(
                      () {
                        return GestureDetector(
                          onTap: () {
                            formValues[field['key']] = option['key'];
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio(
                                value: option['key'],
                                groupValue: formValues[field['key']],
                                onChanged: (value) {
                                  formValues[field['key']] = value;
                                },
                              ),
                              Text(
                                option['val'],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              : Column(
                  children: (field['options'] as List<dynamic>).map((option) {
                    return Obx(
                      () {
                        return RadioListTile(
                          title: Text(option['val']),
                          value: option['key'],
                          groupValue: formValues[field['key']],
                          onChanged: (value) {
                            formValues[field['key']] = value;
                          },
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildDatePickerField(Map<String, dynamic> field) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field['title'],
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          Obx(
            () {
              return TextButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: Get.context!,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    formValues[field['key']] = selectedDate;
                  }
                },
                child: Text(
                  formValues[field['key']] == null
                      ? "Pick a Date"
                      : formValues[field['key']].toString(),
                  style: const TextStyle(color: Colors.black),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget button({required String title, required VoidCallback onClick}) {
    return TextButton(onPressed: onClick, child: Text(title));
  }
}
