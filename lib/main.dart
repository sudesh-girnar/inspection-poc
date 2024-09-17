import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspection_poc/dynamic_form.dart';
import 'package:inspection_poc/poc_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: POCWidget(),
    );
  }
}

class POCWidget extends StatelessWidget {
  final PocController controller = PocController();

  POCWidget({super.key}) {
    Get.put(controller);
    controller.loadJsonAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Inspection POC"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.black12,
            child: InkWell(
              onTap: () {
                controller.startImageCapture();
              },
              child: const Text(
                "Vehicle Images",
                style: TextStyle(fontSize: 18),
              ),
            ).paddingAll(10),
          ),
          const SizedBox(height: 10,),
          Container(
            color: Colors.black12,
            child: InkWell(
              onTap: () {
                Get.to(DynamicForm());
              },
              child: const Text(
                "Vehicle Details",
                style: TextStyle(fontSize: 18),
              ),
            ).paddingAll(10),
          )
        ],
      ),
    );
  }

  Widget button({required String title, required VoidCallback onClick}) {
    return TextButton(onPressed: onClick, child: Text(title));
  }
}
