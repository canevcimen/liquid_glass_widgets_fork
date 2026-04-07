import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../src/renderer/liquid_glass_renderer.dart';

import '../../theme/glass_theme_data.dart';
import '../../types/glass_quality.dart';
import 'inherited_liquid_glass.dart';

class AdaptiveLiquidGlassLayer extends StatelessWidget {
  const AdaptiveLiquidGlassLayer({
    required this.child,
    this.shape = const LiquidRoundedSuperellipse(borderRadius: 0),
    this.settings,
    this.quality,
    this.clipBehavior = Clip.antiAlias,
    this.blendAmount = 10.0,
    this.clipExpansion = EdgeInsets.zero,
    super.key,
  });

  final Widget child;
  final LiquidShape shape;
  final LiquidGlassSettings? settings;
  final GlassQuality? quality;
  final Clip clipBehavior;
  final double blendAmount;
  final EdgeInsets clipExpansion;

  static bool get _canUseImpeller => ui.ImageFilter.isShaderFilterSupported;

  @override
  Widget build(BuildContext context) {
    final themeData = GlassThemeData.of(context);
    final effectiveSettings = settings ??
        themeData.settingsFor(context) ??
        const LiquidGlassSettings();
    final effectiveQuality =
        quality ?? themeData.qualityFor(context) ?? GlassQuality.standard;

    final bool useFullRenderer =
        _canUseImpeller && effectiveQuality == GlassQuality.premium;

    Widget content = child;

    return LiquidGlassLayer(
      settings: effectiveSettings,
      clipExpansion: clipExpansion,
      child: InheritedLiquidGlass(
        settings: effectiveSettings,
        quality: effectiveQuality,
        isBlurProvidedByAncestor: false,
        child: useFullRenderer
            ? LiquidGlassBlendGroup(
                blend: blendAmount,
                child: content,
              )
            : content,
      ),
    );
  }
}
