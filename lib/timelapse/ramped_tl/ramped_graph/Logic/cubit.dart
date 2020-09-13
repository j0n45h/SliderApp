import 'package:cubit/cubit.dart';
import 'package:replay_cubit/replay_cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';

class RampCurveCubit extends ReplayCubit<List<CubitRampingPoint>> {
  RampCurveCubit(state) : super(state);

  @override
  void onTransition(Transition<List<CubitRampingPoint>> transition) {
    print("Transition: $transition");
    super.onTransition(transition);
  }

  void onDragInterval(int index, double delta) {
    state[index].intervalValue += delta;
  }

  void onDragStartTime(int index, double delta) {
    state[index].startValue += delta;
  }

  void onDragEndTime(int index, double delta) {
    state[index].endValue += delta;
  }

  void onTouchedDown(int index) {
    state[index].touched = true;
  }
  void onTouchedUp(int index) {
    state[index].touched = false;
  }
}