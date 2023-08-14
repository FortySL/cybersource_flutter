// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_plus/webview_flutter_plus.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late WebViewPlusController controller;

//   void loadLocalHtml() async {
//     final html = await rootBundle.loadString('assets/index.html');

//     final url = Uri.dataFromString(html,
//             mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
//         .toString();
//     controller.loadUrl(url);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // WebViewController controller = WebViewController();
//     // controller.loadRequest(Uri.parse('http://info.cern.ch'));
//     // controller.setJavaScriptMode(JavaScriptMode.unrestricted);
//     // controller.

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cybersource Test'),
//       ),
//       body: WebViewPlus(
//         javascriptMode: JavascriptMode.unrestricted,
//         initialUrl: 'assets/index.html',
//         onWebViewCreated: (controller) {
//           this.controller = controller;
//         },
//         javascriptChannels: {
//           JavascriptChannel(
//               name: 'JavascriptChannel',
//               onMessageReceived: (message) async {
//                 print('Javascript:${message.message}');
//                 await showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                           content: Text(message.message),
//                           actions: [
//                             TextButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: const Text('ok'))
//                           ],
//                         ));
//                 controller.webViewController.runJavascript('ok()');
//               }),
//         },
//       ),
//     );
//   }
// }
