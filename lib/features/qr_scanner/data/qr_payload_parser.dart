class QrPayloadParser {
  const QrPayloadParser();

  static const supportedPayload = 'digital-menu:sample-01';

  bool isSupported(String? payload) => payload == supportedPayload;
}
