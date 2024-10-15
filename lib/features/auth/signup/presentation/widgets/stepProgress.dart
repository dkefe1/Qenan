import 'package:flutter/material.dart';
import 'package:qenan/core/constants.dart';

class StepProgress extends StatefulWidget {
  final double currentStep;
  final double steps;
  const StepProgress({
    Key? key,
    required this.currentStep,
    required this.steps,
  }) : super(key: key);

  @override
  State<StepProgress> createState() => _StepProgressState();
}

class _StepProgressState extends State<StepProgress> {
  double widthProgress = 0;

  @override
  void initState() {
    super.initState();
    _onSizeWidget();
  }

  void _onSizeWidget() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Size size = context.size!;
      setState(() {
        widthProgress = size.width / (widget.steps - 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double animationWidth = widget.currentStep * widthProgress;

    return Column(
      children: [
        Container(
          height: 4,
          width: width,
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Stack(
            children: [
              Container(
                width: width,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              AnimatedContainer(
                width: widget.currentStep == 0
                    ? widthProgress / 2
                    : animationWidth,
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
