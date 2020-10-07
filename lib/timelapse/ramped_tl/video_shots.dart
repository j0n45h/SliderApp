import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/video_shots_state.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class VideoShots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final videoShotsState = Provider.of<VideoShotsState>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Row(
              children: [
                Text(
                  'VIDEO',
                  style: MyTextStyle.normal(fontSize: 12),
                ),
                const SizedBox(width: 10),
                FramedTextField(
                  width: 80,
                  height: 30,
                  textField: CubitBuilder<RampCurveCubit, List<CubitRampingPoint>>(
                    builder: (context, state) {
                      final videoShotsState = Provider.of<VideoShotsState>(context, listen: false);
                      final videoTime = context.cubit<RampCurveCubit>().getShots() / videoShotsState.fps;
                      return Text(
                        videoTime?.round()?.toString() ?? '-- ' + 's',
                        style: MyTextStyle.normal(fontSize: 12),
                      );
                    },
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(90, 0, 0, 44),
              child: InkWell(
                onTap: () {
                  videoShotsState.toggleFPS();
                },
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  alignment: Alignment.center,
                  width: 40,
                  height: 25,
                  child: Consumer<VideoShotsState>(
                    builder: (context, videoShotsState, child) => Text(
                      videoShotsState.fps.toString() + ' fps',
                      style: MyTextStyle.normal(fontSize: 10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'SHOTS',
              style: MyTextStyle.normal(fontSize: 12),
            ),
            const SizedBox(width: 10),
            FramedTextField(
              width: 80,
              height: 30,
              textField: CubitBuilder<RampCurveCubit, List<CubitRampingPoint>>(
                builder: (context, state) {
                  final shots = context.cubit<RampCurveCubit>().getShots();
                  final shotsStr = shots.toString();
                  return Text(
                    shotsStr,
                    style: MyTextStyle.normal(fontSize: 12),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
