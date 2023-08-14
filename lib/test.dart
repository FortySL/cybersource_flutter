// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

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
              onPressed: () async {
                print(generateJsonPayload());
              },
              child: const Text("Payload"),
            ),
            ElevatedButton(
              onPressed: () async {
                print(generateDigest());
              },
              child: const Text("Digest"),
            ),
            ElevatedButton(
              onPressed: () async {
                print(computeSig());
              },
              child: const Text("Sig"),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     print(generateSignatureFromParams());
            //   },
            //   child: const Text("Sig2"),
            // ),
            ElevatedButton(
              onPressed: () async {
                await sendRequest();
              },
              child: const Text("Request"),
            ),
          ],
        ),
      ),
    );
  }
}

const String host = 'apitest.cybersource.com';
const String merchantId = 'anzbudgetpc';

const String keyId = 'a15e5604-4ff2-4964-9c6f-3571aa9a012d';
const String key = 'bHsBVTMoaE8wBZmrXjZN+CEOmrDRb5m78oluwfr2Tms=';
const requestTarget = 'post /risk/v1/authentication-setups';

String date = DateTime.now().toString();

String generateSignatureFromParams() {
  final signatureString =
      'host: "$host"\ndate: $date\n(request-target): $requestTarget\ndigest: ${generateDigest()}\nv-c-merchant-id: $merchantId';

  // final sigBytes = utf8.encode(
  //     'host: "apitest.cybersource.com"\ndate: "Tue, 01 Aug 2023 00:45:06 GMT"\n(request-target): "post /risk/v1/authentications"\ndigest: "SHA-256=9NouK1FykueQhjuSls7CbvHzJ3EnKWapehhiG/v/ITM="\nv-c-merchant-id: "testrest"');
  final sigBytes = utf8.encode(signatureString);

  final decodedSecret = base64.decode(key);
  final hmacSha256 = Hmac(sha256, decodedSecret);
  final messageHash = hmacSha256.convert(sigBytes);
  return base64.encode(messageHash.bytes);
}

Future<void> sendRequest() async {
  print(computeSig());
  var response = await http.post(
      Uri.parse(
          "https://apitest.cybersource.com/risk/v1/authentication-setups"),
      // headers: {
      //   'host': host,
      //   'signature':
      //       'keyid="08c94330-f618-42a3-b09d-e1e43be5efda", algorithm="HmacSHA256", headers="host (request-target) digest v-c-merchant-id", signature="${computeSig()}"',
      //   'digest': generateDigest(),
      //   'v-c-merchant-id': testMetchantId,
      //   'v-c-date': date,
      //   'Content-Type': 'application/json'
      // },
      headers: {
        'v-c-merchant-id': merchantId,
        'Date': date,
        'Host': host,
        'Digest': generateDigest(),
        'Signature':
            'keyid="$keyId", algorithm="HmacSHA256", headers="host date (request-target) digest v-c-merchant-id", signature="${computeSig()}"',
        'Content-Type': 'application/json'
      },
      body: generateJsonPayload());

  print(response.body);
}

String computeSig() {
  var signatureString =
      'host: $host\ndate: $date\n(request-target): $requestTarget\ndigest: ${generateDigest()}\nv-c-merchant-id: $merchantId';

  print(signatureString);

  var data = utf8.encode(signatureString);
  /* Decoding secret key */
  var decidedKey = base64.decode(key);
  var hmacSha256 = Hmac(sha256, decidedKey);
  var digesttest = hmacSha256.convert(data);
  var base64EncodedSignature = base64.encode(digesttest.bytes);

  // print(signatureString);

  return base64EncodedSignature;

  //return hash.bytes;
}

// String generateSignatureFromParams(String signatureParams, String secretKey) {
//   Uint8List sigBytes = utf8.encode(signatureParams);
//   Uint8List decodedSecret = base64.decode(secretKey);
//   Hmac hmacSha256 = Hmac(sha256, decodedSecret);
//   Uint8List messageHash = hmacSha256.convert(sigBytes).bytes;
//   return base64.encode(messageHash);
// }

String generateDigest() {
  String bodyText = generateJsonPayload();
  List<int> bodyBytes = utf8.encode(bodyText);
  Uint8List bodyUint8List = Uint8List.fromList(bodyBytes);
  Digest digest = sha256.convert(bodyUint8List);
  String encodedDigest = base64.encode(digest.bytes);
  return "SHA-256=$encodedDigest";
}

String generateJsonPayload() {
  // Map<String, dynamic> payload = {
  //   "clientReferenceInformation": {"code": "test_payment"},
  //   "processingInformation": {"commerceIndicator": "internet"},
  //   "orderInformation": {
  //     "billTo": {
  //       "firstName": "John",
  //       "lastName": "Doe",
  //       "address1": "1 Market St",
  //       "postalCode": "94105",
  //       "locality": "san francisco",
  //       "administrativeArea": "CA",
  //       "country": "US",
  //       "phoneNumber": "4158880000",
  //       "company": "Visa",
  //       "email": "test@cybs.com"
  //     },
  //     "amountDetails": {"totalAmount": "102.21", "currency": "USD"}
  //   },
  //   "paymentInformation": {
  //     "card": {
  //       "expirationYear": "2031",
  //       "number": "4111111111111111",
  //       "securityCode": "123",
  //       "expirationMonth": "12"
  //     }
  //   }
  // };

  // Map<String, dynamic> payload = {
  //   "clientReferenceInformation": {"code": "cybs_test"},
  //   "orderInformation": {
  //     "billTo": {
  //       "firstName": "John",
  //       "lastName": "Doe",
  //       "address2": "Address 2",
  //       "address1": "1 Market St",
  //       "postalCode": "94105",
  //       "locality": "san francisco",
  //       "administrativeArea": "CA",
  //       "country": "US",
  //       "phoneNumber": "4158880000",
  //       "company": "Visa",
  //       "email": "test@cybs.com"
  //     },
  //     "amountDetails": {"totalAmount": "10.99", "currency": "USD"}
  //   },
  //   "buyerInformation": {"mobilePhone": "1245789632"},
  //   "paymentInformation": {
  //     "card": {
  //       "expirationMonth": "12",
  //       "expirationYear": "2025",
  //       "number": "4000000000000101"
  //     }
  //   },
  //   "consumerAuthenticationInformation": {"transactionMode": "MOTO"}
  // };

  Map<String, dynamic> payload = {
    "clientReferenceInformation": {"code": "BPC0002"},
    "paymentInformation": {
      "card": {
        "type": "001",
        "expirationMonth": "12",
        "expirationYear": "2025",
        "number": "4000000000002701"
      }
    }
  };

  String jsonString = jsonEncode(payload);
  return jsonString;
}

