import 'package:flutter/material.dart';

import 'slide_indicator.dart';

class CircularWaveSlideIndicator implements SlideIndicator {
  final double itemSpacing;
  final double indicatorRadius;
  final EdgeInsets? padding;
  final AlignmentGeometry alignment;
  final Color currentIndicatorColor;
  final Color indicatorBackgroundColor;
  final double indicatorBorderWidth;
  final Color? indicatorBorderColor;

  CircularWaveSlideIndicator({
    this.itemSpacing = 20,
    this.indicatorRadius = 6,
    this.padding,
    this.alignment = Alignment.bottomCenter,
    this.currentIndicatorColor = const Color(0xFFFFFFFF),
    this.indicatorBackgroundColor = const Color(0x66FFFFFF),
    this.indicatorBorderWidth = 1,
    this.indicatorBorderColor,
  });

  @override
  Widget build(int currentPage, double pageDelta, int itemCount) {
    return Container(
      alignment: alignment,
      padding: padding,
      child: SizedBox(
        width: itemCount * itemSpacing,
        height: indicatorRadius * 2,
        child: CustomPaint(
          painter: CircularWaveIndicatorPainter(
            currentIndicatorColor: currentIndicatorColor,
            indicatorBackgroundColor: indicatorBackgroundColor,
            currentPage: currentPage,
            pageDelta: pageDelta,
            itemCount: itemCount,
            radius: indicatorRadius,
            indicatorBorderColor: indicatorBorderColor,
            borderWidth: indicatorBorderWidth,
          ),
        ),
      ),
    );
  }
}

class CircularWaveIndicatorPainter extends CustomPainter {
  final int? itemCount;
  final int? currentPage;
  final double? pageDelta;
  final double? radius;
  final Paint indicatorPaint = Paint();
  final Paint currentIndicatorPaint = Paint();

  final Paint borderIndicatorPaint = Paint();
  final Color? indicatorBorderColor;

  CircularWaveIndicatorPainter({
    this.itemCount,
    this.currentPage,
    this.pageDelta,
    this.radius,
    required Color currentIndicatorColor,
    required Color indicatorBackgroundColor,
    this.indicatorBorderColor,
    double borderWidth = 2,
  }) {
    indicatorPaint.color = indicatorBackgroundColor;
    indicatorPaint.style = PaintingStyle.fill;
    indicatorPaint.isAntiAlias = true;
    currentIndicatorPaint.color = currentIndicatorColor;
    currentIndicatorPaint.style = PaintingStyle.fill;
    currentIndicatorPaint.isAntiAlias = true;

    if (indicatorBorderColor != null) {
      borderIndicatorPaint.color = indicatorBorderColor!;
      borderIndicatorPaint.style = PaintingStyle.stroke;
      borderIndicatorPaint.strokeWidth = borderWidth;
      borderIndicatorPaint.isAntiAlias = true;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dx = itemCount! < 2
        ? size.width
        : (size.width - 2 * radius!) / (itemCount! - 1);
    final y = size.height / 2;
    var x = radius;
    for (var i = 0; i < itemCount!; i++) {
      canvas.drawCircle(Offset(x!, y), radius!, indicatorPaint);
      x += dx;
    }
    var midX = radius! + dx * currentPage!;
    var midY = size.height / 2;
    var r = radius! * ((1.4 * pageDelta! - 0.7).abs() + 0.3);
    if (currentPage == itemCount! - 1) {
      canvas.save();
      final path = Path();
      path.addOval(
          Rect.fromLTRB(0, midY - radius!, 2 * radius!, midY + radius!));
      path.addOval(Rect.fromLTRB(size.width - 2 * radius!, midY - radius!,
          size.width, midY + radius!));
      canvas.clipPath(path);
      canvas.drawCircle(Offset(2 * radius! * pageDelta! - radius!, midY), r,
          currentIndicatorPaint);
      midX += 2 * radius! * pageDelta!;
    } else {
      midX += dx * pageDelta!;
    }
    canvas.drawCircle(Offset(midX, midY), r, currentIndicatorPaint);
    if (currentPage == itemCount! - 1) {
      canvas.restore();
    }
    if (indicatorBorderColor != null) {
      x = radius;
      for (var i = 0; i < itemCount!; i++) {
        canvas.drawCircle(Offset(x!, y), radius!, borderIndicatorPaint);
        x += dx;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
