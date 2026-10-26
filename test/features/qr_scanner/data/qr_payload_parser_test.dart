import 'package:digital_menu_mobile/features/qr_scanner/data/qr_payload_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const parser = QrPayloadParser();

  test('accepts the supported menu payload exactly', () {
    expect(parser.isSupported('digital-menu:sample-01'), isTrue);
  });

  test('rejects incorrect and malformed payloads', () {
    expect(parser.isSupported('digital-menu:sample-02'), isFalse);
    expect(parser.isSupported('digital-menu:sample-01/extra'), isFalse);
    expect(parser.isSupported(' digital-menu:sample-01 '), isFalse);
  });

  test('rejects URL payloads', () {
    expect(parser.isSupported('https://example.com/menu'), isFalse);
  });

  test('rejects empty and whitespace-only payloads', () {
    expect(parser.isSupported(''), isFalse);
    expect(parser.isSupported(' \t\n '), isFalse);
  });

  test('rejects null payloads', () {
    expect(parser.isSupported(null), isFalse);
  });
}
