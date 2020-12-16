import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> items;
  final TabController controller;
  final double height;
  final Color bgColor;
  final Color indicatorColor;
  final double indicatorWeight;
  final double indicatorWidth;
  final Color labelColor;
  final Color unselectedLabelColor;
  final TextStyle labelStyle;
  final TextStyle unselectedLabelStyle;
  final EdgeInsetsGeometry labelPadding;
  final Function(int) onTap;
  final bool isScrollable;
  final BorderSide bottomBorder;

  CustomTabBar(
      {@required this.items,
      @required this.controller,
      this.height = 40.0,
      this.bgColor = Colors.white,
      this.indicatorColor = Colors.black,
      this.indicatorWidth = 30.0,
      this.indicatorWeight = 2.0,
      this.labelColor = Colors.black,
      this.unselectedLabelColor = Colors.grey,
      this.labelStyle,
      this.unselectedLabelStyle,
      this.labelPadding,
      this.onTap,
      this.isScrollable = false,
      this.bottomBorder =
          const BorderSide(color: Colors.transparent, width: 1)});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: bottomBorder,
        ),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: isScrollable,
        labelPadding: labelPadding,
        labelStyle: labelStyle,
        unselectedLabelColor: unselectedLabelColor,
        unselectedLabelStyle: unselectedLabelStyle,
        labelColor: labelColor,
        indicator: RoundUnderlineTabIndicator(
          width: indicatorWidth,
          borderSide: BorderSide(width: indicatorWeight, color: indicatorColor),
        ),
        tabs: items.map((e) => Text(e)).toList(),
        onTap: onTap,
      ),
    );
  }
}

/// 自定义TabBar Indicator
class RoundUnderlineTabIndicator extends Decoration {
  const RoundUnderlineTabIndicator(
      {this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
      this.insets = EdgeInsets.zero,
      this.width = 20})
      : assert(borderSide != null),
        assert(insets != null);

  final BorderSide borderSide;

  final EdgeInsetsGeometry insets;

  final double width;

  @override
  Decoration lerpFrom(Decoration a, double t) {
    if (a is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration lerpTo(Decoration b, double t) {
    if (b is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _UnderlinePainter createBoxPainter([VoidCallback onChanged]) {
    return _UnderlinePainter(this, onChanged);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);

    ///希望的宽度
    double wantWidth = width;

    ///取中间坐标
    double cw = (indicator.left + indicator.right) / 2;
    return Rect.fromLTWH(cw - wantWidth / 2,
        indicator.bottom - borderSide.width, wantWidth, borderSide.width);
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final RoundUnderlineTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size;
    final TextDirection textDirection = configuration.textDirection;
    final Rect indicator = decoration
        ._indicatorRectFor(rect, textDirection)
        .deflate(decoration.borderSide.width / 2.0);
    // final Paint paint = decoration.borderSide.toPaint()..strokeCap = StrokeCap.square;
    /// 圆角
    final Paint paint = decoration.borderSide.toPaint()
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }
}
