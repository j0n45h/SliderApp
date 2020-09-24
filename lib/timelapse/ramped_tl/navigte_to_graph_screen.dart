import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/ramped_graph_screen.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/time_state.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class NavigateToGraphScreen {
  final BuildContext context;
  NavigateToGraphScreen(this.context);

  void navigate() {
    final timeState = Provider.of<TimeState>(context, listen: false);
    if (timeState.endingTime == null) {
      _showTimeNotSetSnakeBar();
      return;
    }

    if (!context.cubit<RampCurveCubit>().isCreated || !context.cubit<RampCurveCubit>().wasOpened)
      context.cubit<RampCurveCubit>().recreatePoints(context);

    context.cubit<RampCurveCubit>().wasOpened = true;

    Navigator.of(context).pushNamed(RampedGraphScreen.routeName);
  }

  void _showTimeNotSetSnakeBar() {
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.redAccent,
      elevation: 40,
      behavior: SnackBarBehavior.fixed,
      content: Text(
        'End-Time is not set!',
        style: MyTextStyle.fetStdSize(),
      ),
    ));
  }
}