import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class CybersourceService {
  final String host = 'apitest.cybersource.com';
  final String merchantId = 'anzbudgetpc';

  final String keyId = 'a15e5604-4ff2-4964-9c6f-3571aa9a012d';
  final String key = 'bHsBVTMoaE8wBZmrXjZN+CEOmrDRb5m78oluwfr2Tms=';
  final requestMethod = 'post';
  final requestEndPoint = '/risk/v1/authentication-setups';

  String date = DateTime.now().toString();

  Future<String> sendRequest() async {
    var response = await http.post(Uri.parse("https://$host$requestEndPoint"),
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
    return response.body;
  }

  String computeSig() {
    final requestTarget = '$requestMethod $requestEndPoint';
    var signatureString =
        'host: $host\ndate: $date\n(request-target): $requestTarget\ndigest: ${generateDigest()}\nv-c-merchant-id: $merchantId';

    var data = utf8.encode(signatureString);
    /* Decoding secret key */
    var decidedKey = base64.decode(key);
    var hmacSha256 = Hmac(sha256, decidedKey);
    var digesttest = hmacSha256.convert(data);
    var base64EncodedSignature = base64.encode(digesttest.bytes);

    return base64EncodedSignature;
  }

  String generateSignatureFromParams(
      {required host,
      required date,
      required requestTarget,
      required digest,
      required merchantId}) {
    final signatureString =
        'host: "$host"\ndate: $date\n(request-target): $requestTarget\ndigest: ${generateDigest()}\nv-c-merchant-id: $merchantId';

    final sigBytes = utf8.encode(signatureString);

    final decodedSecret = base64.decode(key);
    final hmacSha256 = Hmac(sha256, decodedSecret);
    final messageHash = hmacSha256.convert(sigBytes);
    return base64.encode(messageHash.bytes);
  }

  String generateDigest() {
    String bodyText = generateJsonPayload();
    List<int> bodyBytes = utf8.encode(bodyText);
    Uint8List bodyUint8List = Uint8List.fromList(bodyBytes);
    Digest digest = sha256.convert(bodyUint8List);
    String encodedDigest = base64.encode(digest.bytes);
    return "SHA-256=$encodedDigest";
  }

  String generateJsonPayload() {
    Map<String, dynamic> payload = {
      "clientReferenceInformation": {"code": "BPCM1"},
      "paymentInformation": {
        "card": {
          "type": "001",
          "expirationMonth": "12",
          "expirationYear": "2025",
          "number": "4000000000002503",
          "securityCode": "234"
        }
      }
    };

    String jsonString = jsonEncode(payload);
    return jsonString;
  }
}
