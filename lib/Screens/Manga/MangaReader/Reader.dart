import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartotsu/Preferences/IsarDataClasses/DefaultReaderSettings/DafaultReaderSettings.dart';
import 'package:dartotsu/Widgets/ScrollConfig.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../DataClass/Chapter.dart';
import '../../../DataClass/Media.dart';
import '../../../Api/Sources/Eval/dart/model/page.dart';
import '../../../Api/Sources/Model/Source.dart';
import 'ReaderController.dart';

class MediaReader extends StatefulWidget {
  final Media media;
  final Chapter currentChapter;
  final List<PageUrl> pages;
  final Source source;
  final bool isOffline;

  const MediaReader({
    super.key,
    required this.media,
    required this.currentChapter,
    required this.pages,
    required this.source,
    this.isOffline = false,
  });

  @override
  State<MediaReader> createState() => MediaReaderState();
}

class MediaReaderState extends State<MediaReader> {
  late final FocusNode focusNode = FocusNode();
  late final ItemScrollController itemScrollController = ItemScrollController();
  late final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  late final PageController pageController = PageController();
  late ReaderSettings readerSettings;
  final showControls = true.obs;
  final currentPage = 1.obs;
  final transformationController = TransformationController();
  double currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    readerSettings = widget.media.settings.readerSettings;
    focusNode.requestFocus();
    itemPositionsListener.itemPositions.addListener(_updateCurrentPage);
    pageController.addListener(_onPageChanged);
    if (Platform.isAndroid || Platform.isIOS) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    itemPositionsListener.itemPositions.removeListener(_updateCurrentPage);
    pageController.removeListener(_onPageChanged);
    if (Platform.isAndroid || Platform.isIOS) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildReader(),
    );
  }

  Widget _buildReader() {
    return KeyboardListener(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: () => showControls.value = !showControls.value,
        child: Listener(
          onPointerSignal: (event) {
            if (event is PointerScrollEvent &&
                HardwareKeyboard.instance.isControlPressed) {
              _zoomOnScroll(event.scrollDelta.dy, event.localPosition);
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onDoubleTapDown: _toggleZoom,
                child: InteractiveViewer(
                  transformationController: transformationController,
                  minScale: 0.5,
                  maxScale: 4,
                  panEnabled: true,
                  scaleEnabled: Platform.isAndroid || Platform.isIOS,
                  child: readerSettings.layoutType == LayoutType.Continuous
                      ? _buildContinuousMode()
                      : _buildPagedMode(),
                ),
              ),
              _buildOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinuousMode() {
    var direction = readerSettings.direction == Direction.UTD ||
            readerSettings.direction == Direction.DTU
        ? Axis.vertical
        : Axis.horizontal;
    var reverse = readerSettings.direction == Direction.DTU ||
        readerSettings.direction == Direction.RTL;

    return ScrollConfig(
      context,
      child: ScrollablePositionedList.builder(
        scrollDirection: direction,
        itemCount: widget.pages.length,
        reverse: reverse,
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        itemBuilder: (context, index) {
          return _buildPageImage(widget.pages[index]);
        },
      ),
    );
  }

  Widget _buildPagedMode() {
    var direction = readerSettings.direction == Direction.UTD ||
            readerSettings.direction == Direction.DTU
        ? Axis.vertical
        : Axis.horizontal;
    var reverse = readerSettings.direction == Direction.DTU ||
        readerSettings.direction == Direction.RTL;

    return ScrollConfig(
      context,
      child: PageView.builder(
        controller: pageController,
        scrollDirection: direction,
        reverse: reverse,
        itemCount: widget.pages.length,
        itemBuilder: (context, index) {
          return _buildPageImage(widget.pages[index]);
        },
      ),
    );
  }

  Widget _buildPageImage(PageUrl page) {
    var isHorizontal = readerSettings.direction == Direction.LTR ||
        readerSettings.direction == Direction.RTL;
    return Padding(
      padding: readerSettings.spacedPages
          ? isHorizontal
              ? EdgeInsets.symmetric(horizontal: 16)
              : EdgeInsets.symmetric(vertical: 16)
          : EdgeInsets.zero,

      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: CachedNetworkImage(
            imageUrl: page.url,
            fit: BoxFit.fitWidth,
            errorWidget: (context, url, error) => Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Failed to load image',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onPageChanged() {
    final page = (pageController.page?.round() ?? 0) + 1;
    if (page != currentPage.value) {
      currentPage.value = page;
    }
  }

  void _updateCurrentPage() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    currentPage.value = positions
            .reduce((a, b) => (a.itemLeadingEdge < b.itemLeadingEdge &&
                    a.itemTrailingEdge < b.itemTrailingEdge)
                ? a
                : b)
            .index +
        1;
  }

  void _toggleZoom(TapDownDetails details) {
    final tapPosition = details.localPosition;
    final targetScale = (currentScale < 2.0) ? 2.0 : 1.0;
    _zoomAtPoint(tapPosition, targetScale);
  }

  void _zoomOnScroll(double scrollDelta, Offset pointerPosition) {
    final zoomFactor = (scrollDelta < 0) ? 1.1 : 0.9;
    final newScale = (currentScale * zoomFactor).clamp(1.0, 4.0);
    _zoomAtPoint(pointerPosition, newScale);
  }

  void _zoomAtPoint(Offset focalPoint, double targetScale) {
    final matrix = transformationController.value;
    currentScale = targetScale;
    final focalPointInScene = _transformPoint(matrix, focalPoint);
    transformationController.value = Matrix4.identity()
      ..translate(focalPointInScene.dx, focalPointInScene.dy)
      ..scale(currentScale)
      ..translate(-focalPointInScene.dx, -focalPointInScene.dy);
  }

  Offset _transformPoint(Matrix4 matrix, Offset point) {
    final invertedMatrix = Matrix4.inverted(matrix);
    final x = (invertedMatrix[0] * point.dx) + (invertedMatrix[12]);
    final y = (invertedMatrix[5] * point.dy) + (invertedMatrix[13]);
    return Offset(x, y);
  }

  Widget _buildOverlay() {
    return Obx(() {
      return Positioned.fill(
        child: AnimatedOpacity(
          opacity: showControls.value ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: !showControls.value,
            child: ReaderController(reader: this),
          ),
        ),
      );
    });
  }
}
