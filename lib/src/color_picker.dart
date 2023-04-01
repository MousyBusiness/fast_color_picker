import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spring_button/spring_button.dart';

import 'constants.dart';

final Map<int, double> _correctSizes = {};
final PageController pageController = PageController(keepPage: true);

class FastColorPicker extends StatefulWidget {
  final Color selectedColor;
  final List<List<Color>> colors;
  final IconData? icon;
  final Function(Color) onColorSelected;

  FastColorPicker({
    Key? key,
    this.icon,
    this.selectedColor = Colors.white,
    List<Color>? colors1,
    List<Color>? colors2,
    List<Color>? colors3,
    required this.onColorSelected,
  })  : colors = [
          colors1 ?? Constants.colors1,
          colors2 ?? Constants.colors2,
          colors3 ?? Constants.colors3,
        ],
        super(key: key);

  @override
  State<FastColorPicker> createState() => _FastColorPickerState();
}

class _FastColorPickerState extends State<FastColorPicker> {
  int index = 0;

  Widget _buildColorRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      key: ValueKey(index),
      children: createColors(context, widget.colors[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
          ),
          child: SelectedColor(
            icon: widget.icon,
            selectedColor: widget.selectedColor,
          ),
        ),
        SizedBox(height: 24),
        GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              setState(() {
                index = index + 1;
                if (index > widget.colors.length - 1) {
                  index = 0;
                }
              });
            } else if (details.primaryVelocity! < 0) {
              setState(() {
                index = index - 1;
                if (index < 0) {
                  index = widget.colors.length - 1;
                }
              });
            }
          },
          child: Center(
            child: SizedBox(
              height: 52,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: _buildColorRow(context),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  List<Widget> createColors(BuildContext context, List<Color> colors) {
    double size = _correctSizes[colors.length] ??
        correctButtonSize(
          colors.length,
          MediaQuery.of(context).size.width,
        );
    return [
      for (var c in colors)
        SpringButton(
          SpringButtonType.OnlyScale,
          Padding(
            padding: EdgeInsets.all(size * 0.1),
            child: AnimatedContainer(
              width: size,
              height: size,
              duration: Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: c,
                shape: BoxShape.circle,
                border: Border.all(
                  width: c == widget.selectedColor ? 4 : 2,
                  color: Colors.white,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: size * 0.1,
                    color: Colors.black12,
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            widget.onColorSelected.call(c);
          },
          useCache: false,
          scaleCoefficient: 0.9,
          duration: 1000,
        ),
    ];
  }

  double correctButtonSize(int itemSize, double screenWidth) {
    double firstSize = 52;
    double maxWidth = screenWidth - firstSize;
    bool isSizeOkay = false;
    double finalSize = 48;
    do {
      finalSize -= 2;
      double eachSize = finalSize * 1.2;
      double buttonsArea = itemSize * eachSize;
      isSizeOkay = maxWidth > buttonsArea;
    } while (!isSizeOkay);
    _correctSizes[itemSize] = finalSize;
    return finalSize;
  }
}

class SelectedColor extends StatelessWidget {
  final Color selectedColor;
  final IconData? icon;

  const SelectedColor({Key? key, required this.selectedColor, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      child: icon != null
          ? Icon(
              icon,
              color: selectedColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              size: 22,
            )
          : null,
      decoration: BoxDecoration(
        color: selectedColor,
        shape: BoxShape.circle,
        border: Border.all(
          width: 2,
          color: Colors.white,
        ),
        boxShadow: [
          const BoxShadow(
            blurRadius: 6,
            color: Colors.black38,
          ),
        ],
      ),
    );
  }
}
