import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../data/qr_payload_parser.dart';

typedef QrScannerPreviewBuilder =
    Widget Function(
      BuildContext context,
      ValueChanged<String?> onDetected,
      Widget Function(BuildContext, MobileScannerException) errorBuilder,
    );

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({this.previewBuilder, this.stopCamera, super.key});

  final QrScannerPreviewBuilder? previewBuilder;
  final Future<void> Function()? stopCamera;

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  static const _parser = QrPayloadParser();
  static const _requiredStableDetections = 3;
  static const _maximumDetectionGap = Duration(milliseconds: 700);

  late final MobileScannerController? _controller;
  String? _statusMessage;
  MobileScannerException? _cameraError;
  Timer? _stabilityTimer;
  int _matchingDetections = 0;
  bool _handlingValidScan = false;
  bool _scanRecognized = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.previewBuilder == null
        ? MobileScannerController(
            detectionSpeed: DetectionSpeed.normal,
            detectionTimeoutMs: 250,
            formats: const [BarcodeFormat.qrCode],
          )
        : null;
  }

  @override
  void dispose() {
    _stabilityTimer?.cancel();
    final controller = _controller;
    if (controller != null) {
      unawaited(controller.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previewBuilder = widget.previewBuilder;
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Menu QR')),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                previewBuilder?.call(
                      context,
                      _handlePayload,
                      _cameraErrorBuilder,
                    ) ??
                    MobileScanner(
                      controller: _controller,
                      onDetect: _handleCapture,
                      errorBuilder: _cameraErrorBuilder,
                    ),
                if (_cameraError == null && !_scanRecognized)
                  const IgnorePointer(
                    child: CustomPaint(
                      key: Key('qr-scanning-frame'),
                      painter: _ScannerOverlayPainter(),
                    ),
                  ),
                if (_scanRecognized) _buildSuccessOverlay(),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _scanRecognized
                        ? 'Menu recognized'
                        : _statusMessage ??
                              'Place the QR code inside the frame',
                    key: const Key('qr-scanner-status'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (!_scanRecognized) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Hold the code steady inside the frame.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessOverlay() {
    return ColoredBox(
      color: const Color(0xE6101D36),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Color(0xFFE5CF9D),
                size: 68,
              ),
              const SizedBox(height: 16),
              Text(
                'Menu recognized',
                key: const Key('qr-menu-recognized'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFFFFFDF8),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your local menu is ready.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: const Color(0xFFFFFDF8)),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('continue-to-all-items'),
                onPressed: _continueToAllItems,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _continueToAllItems() {
    if (mounted && _scanRecognized) {
      Navigator.of(context).pop(true);
    }
  }

  void _handleCapture(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      if (barcode.format == BarcodeFormat.qrCode) {
        _handlePayload(barcode.rawValue);
        return;
      }
    }
    _resetStability();
  }

  void _handlePayload(String? payload) {
    if (!mounted || _handlingValidScan) {
      return;
    }

    if (!_parser.isSupported(payload)) {
      _resetStability();
      final message = payload == null || payload.trim().isEmpty
          ? 'No readable QR value. Try another code.'
          : 'This QR code is not supported. Try the prepared menu code.';
      if (_statusMessage != message && mounted) {
        setState(() => _statusMessage = message);
      }
      return;
    }

    _stabilityTimer?.cancel();
    _matchingDetections++;
    if (_matchingDetections < _requiredStableDetections) {
      if (_statusMessage != 'Hold the code steady inside the frame.' &&
          mounted) {
        setState(
          () => _statusMessage = 'Hold the code steady inside the frame.',
        );
      }
      _stabilityTimer = Timer(_maximumDetectionGap, _resetStability);
      return;
    }

    _stabilityTimer?.cancel();
    unawaited(_completeScan());
  }

  void _resetStability() {
    _stabilityTimer?.cancel();
    _matchingDetections = 0;
  }

  Future<void> _completeScan() async {
    if (!mounted || _handlingValidScan) {
      return;
    }
    _handlingValidScan = true;
    final controller = _controller;
    final stopCamera = widget.stopCamera;
    if (stopCamera != null || controller != null) {
      try {
        await (stopCamera?.call() ?? controller!.stop());
      } catch (error, stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'mobile_scanner',
            context: ErrorDescription(
              'while stopping the camera after a valid QR scan',
            ),
          ),
        );
      }
    }

    if (!mounted) {
      return;
    }
    setState(() => _scanRecognized = true);
  }

  Widget _cameraErrorBuilder(
    BuildContext context,
    MobileScannerException exception,
  ) {
    if (mounted && _cameraError == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _cameraError == null) {
          setState(() => _cameraError = exception);
        }
      });
    }

    final message = switch (exception.errorCode) {
      MobileScannerErrorCode.permissionDenied =>
        'Camera permission was denied. You can still browse the local menu.',
      MobileScannerErrorCode.unsupported =>
        'A camera is unavailable on this device. You can still browse the local menu.',
      _ =>
        'The camera could not be started. You can still browse the local menu.',
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.no_photography_outlined, size: 48),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back to menu'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  const _ScannerOverlayPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final frameSide = math.min(
      300.0,
      math.min(size.width - 48, size.height - 48),
    );
    if (frameSide <= 0) {
      return;
    }

    final frame = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: frameSide,
      height: frameSide,
    );
    final overlayPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRect(frame);
    canvas.drawPath(overlayPath, Paint()..color = const Color(0x99000000));

    final bracketLength = frameSide * 0.17;
    final bracketPaint = Paint()
      ..color = const Color(0xFFE5CF9D)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final corners = <List<Offset>>[
      [frame.topLeft, frame.topLeft + Offset(bracketLength, 0)],
      [frame.topLeft, frame.topLeft + Offset(0, bracketLength)],
      [frame.topRight, frame.topRight - Offset(bracketLength, 0)],
      [frame.topRight, frame.topRight + Offset(0, bracketLength)],
      [frame.bottomLeft, frame.bottomLeft + Offset(bracketLength, 0)],
      [frame.bottomLeft, frame.bottomLeft - Offset(0, bracketLength)],
      [frame.bottomRight, frame.bottomRight - Offset(bracketLength, 0)],
      [frame.bottomRight, frame.bottomRight - Offset(0, bracketLength)],
    ];
    for (final corner in corners) {
      canvas.drawLine(corner[0], corner[1], bracketPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) => false;
}
