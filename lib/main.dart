// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';

import 'package:cybersource_flutter/cybersource_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cybersource Test'),
        ),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
              child: const Text('Place Order1'),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const PaymentSheet(),
                      );
                    });
              },
            ),
            ElevatedButton(
              child: const Text('Place Order2'),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const PaymentSheet2(),
                      );
                    });
              },
            ),
          ],
        )));
  }
}

class PaymentSheet extends StatefulWidget {
  const PaymentSheet({super.key});

  @override
  State<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<PaymentSheet> {
  final controller = WebViewController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Color.fromARGB(0, 0, 0, 0))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          debugPrint('WebView is loading (progress : $progress%)');
        },
        onPageStarted: (String url) async {
          var a = await CybersourceService().sendRequest();
          print(a);
          debugPrint('Page started loading: $url');
        },
        onPageFinished: (String url) async {
          debugPrint('Page finished loading: $url');
          setState(() {
            isLoading = false;
          });
        },
      ))
      ..addJavaScriptChannel("JSChannel", onMessageReceived: (message) {
        print(message.message);
      })
      ..addJavaScriptChannel("JSChannel2", onMessageReceived: (message) {
        print(message.message);
        Navigator.pop(context);
      })
      ..loadHtmlString(getDeviceDataCollectionHtml(
          jwtValue:
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI4MDBkNDJlYy1hZjQzLTRiMTQtODYwYy0xMDc5OTAyOGM5ODUiLCJpYXQiOjE2OTE4MDMxNzUsImlzcyI6IjVkZDgzYmYwMGU0MjNkMTQ5OGRjYmFjYSIsImV4cCI6MTY5MTgwNjc3NSwiT3JnVW5pdElkIjoiNWI5YzRiYjNmZjYyNmIxMzQ0ODEwYTAxIiwiUmVmZXJlbmNlSWQiOiI1ZWZmYzNlMi1hZTU3LTQ1YWYtYjlhYy04ZTA3Mzc2MTJjNjcifQ.ouFcE6bN8XKzZ5UOn9YmLqxUVIOcKpKZ4aB1bSeJMwE"));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : WebViewWidget(controller: controller);
  }
}

class PaymentSheet2 extends StatefulWidget {
  const PaymentSheet2({super.key});

  @override
  State<PaymentSheet2> createState() => _PaymentSheet2State();
}

class _PaymentSheet2State extends State<PaymentSheet2> {
  final controller = WebViewController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Color.fromARGB(0, 0, 0, 0))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          debugPrint('WebView is loading (progress : $progress%)');
        },
        onPageStarted: (String url) {
          debugPrint('Page started loading: $url');
        },
        onPageFinished: (String url) {
          debugPrint('Page finished loading: $url');
          setState(() {
            isLoading = false;
          });
        },
      ))
      ..addJavaScriptChannel("JSChannel", onMessageReceived: (message) {
        print(message.message);
      })
      ..addJavaScriptChannel("JSChannel2", onMessageReceived: (message) {
        print(message.message);
//vlad
//

        Navigator.pop(context);
      })
      ..loadHtmlString(getDeviceDataCollectionHtml2());
  }

  @override
  Widget build(BuildContext context) {
    final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
      Factory(() => EagerGestureRecognizer())
    };

    // UniqueKey _key = UniqueKey();
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : WebViewWidget(
            controller: controller,
            gestureRecognizers: gestureRecognizers,
          );
  }
}

String getDeviceDataCollectionHtml({required jwtValue}) {
  String html = '''
<!DOCTYPE html>
<html>

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Navigation Delegate Example</title>
</head>

<body>
    <p>
        The navigation delegate is set to block navigation to the youtube website.
    </p>
    <iframe id="cardinal_collection_iframe" name="collectionIframe" height="10" width="10"
        style="display: none;"></iframe>
    <form id="cardinal_collection_form" method="POST" target="collectionIframe"
        action=https://centinelapistag.cardinalcommerce.com/V1/Cruise/Collect>
        <input id="cardinal_collection_form_input" type="hidden" name="JWT"
            value="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI0YTIwMTdiNC1hMDk5LTQyMjAtYTJhNi0yNTEyNWFjMzNhNjMiLCJpYXQiOjE2OTE4MTU1ODUsImlzcyI6IjVkZDgzYmYwMGU0MjNkMTQ5OGRjYmFjYSIsImV4cCI6MTY5MTgxOTE4NSwiT3JnVW5pdElkIjoiNjMyODIyMjA2YjY5Yjg0YWE2ZTRjMTdlIiwiUmVmZXJlbmNlSWQiOiJkZjVmYmU2Ni1jZWVmLTQxNWItYTBiYi05ZTEyNDAyMWU0NDcifQ.fMuY0Qp-jWlQQSbOExaG1U0k6ZPv9CisJgzwh-_Fv9U">
    </form>
</body>

</html>

<script>
    window.onload = function () {
        var cardinalCollectionForm = document.querySelector('#cardinal_collection_form');
        if (cardinalCollectionForm) {
            cardinalCollectionForm.submit();
            JSChannel.postMessage("JSChannel: sent");
        } // form exists 
    };

    window.addEventListener("message", function (event) {
        if (event.origin === "https://centinelapistag.cardinalcommerce.com") {
            JSChannel.postMessage("JSChannel: received");
            JSChannel2.postMessage(event.data);
        }
    }, false);
</script>
''';

  return html;
}

String getDeviceDataCollectionHtml2() {
  String html = '''
<!DOCTYPE html>
<html>

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Navigation Delegate Example</title>
</head>

<body>
    <iframe name="step-up-iframe" height="400" width="390"></iframe>
    <form id="step-up-form" target="step-up-iframe" method="post"
        action="https://centinelapistag.cardinalcommerce.com/V2/Cruise/StepUp"> <input type="hidden" name="JWT"
            value="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjZTZmM2U3MS02ZDA3LTQ0NzEtOWQyYS03NDJkYmM4ZWQ2MjkiLCJpYXQiOjE2OTE4MTU2ODYsImlzcyI6IjVkZDgzYmYwMGU0MjNkMTQ5OGRjYmFjYSIsImV4cCI6MTY5MTgxOTI4NiwiT3JnVW5pdElkIjoiNjMyODIyMjA2YjY5Yjg0YWE2ZTRjMTdlIiwiUGF5bG9hZCI6eyJBQ1NVcmwiOiJodHRwczovLzBtZXJjaGFudGFjc3N0YWcuY2FyZGluYWxjb21tZXJjZS5jb20vTWVyY2hhbnRBQ1NXZWIvY3JlcS5qc3AiLCJQYXlsb2FkIjoiZXlKdFpYTnpZV2RsVkhsd1pTSTZJa05TWlhFaUxDSnRaWE56WVdkbFZtVnljMmx2YmlJNklqSXVNaTR3SWl3aWRHaHlaV1ZFVTFObGNuWmxjbFJ5WVc1elNVUWlPaUl4TTJRM01qWTVZaTB5T1dReUxUUmpPVGN0T0dFMk1pMDNZMkprWVRNNU1EQXpaVEFpTENKaFkzTlVjbUZ1YzBsRUlqb2lObU13TURGbE1USXRNR0l3TlMwME1qUmpMV0poWmpjdE5UUmpaVEJqWVRsbE9HVXlJaXdpWTJoaGJHeGxibWRsVjJsdVpHOTNVMmw2WlNJNklqQXlJbjAiLCJUcmFuc2FjdGlvbklkIjoiSmVmQXJKSHE3cmVRbU5idUZEZjAifSwiT2JqZWN0aWZ5UGF5bG9hZCI6dHJ1ZSwiUmV0dXJuVXJsIjoiaHR0cHM6Ly9hdXN0cmFsaWEtc291dGhlYXN0MS1mbHV0dGVyLWFwcC02ZGU4YS5jbG91ZGZ1bmN0aW9ucy5uZXQvY3liZXJzb3VyY2VTdGVwNCJ9.zthC-WPVsgjm0HemN0hgJYo6GMJW1Zx27rLilX66pNc" />
        <input type="hidden" name="MD" value="BPCM1" />
    </form>
</body>

<script>

    window.onload = function () {
        var stepUpForm = document.querySelector('#step-up-form');
        console.log("run");
        if (stepUpForm) {
            stepUpForm.submit();
        }// Step-Up form exists
    }
</script>

</html>
''';

  return html;
}
