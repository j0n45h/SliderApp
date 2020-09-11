import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/niceScale.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/interval_range_state.dart';
import 'package:sliderappflutter/utilities/map.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class IntervalScale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final intervalRangeState =
        Provider.of<IntervalRangeState>(context, listen: false);
        final scale = NiceScale(intervalRangeState.intervalRange.start,
            intervalRangeState.intervalRange.end, 5);

        List<Widget> list = [];
        final height = constraints.maxHeight;

        for (var i = scale.niceMin; i <= scale.niceMax; i += scale.tickSpacing) {
          final pos = map(i, scale.niceMin, scale.niceMax, height - 50, 50);
          final scaleNumber = i.floor().toString();
          list.add(Positioned(
            top: pos - 26/2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 4,
                  height: 1,
                  color: Colors.grey[500],
                ),
                SizedBox(width: 3),
                Container(
                  height: 26,
                  alignment: Alignment.center,
                  child: Text(
                    scaleNumber,
                    style: MyTextStyle.normal(fontSize: 12),
                  ),
                ),
              ],
            ),
          ));
        }
        return Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5),
              width: 2,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey[500],
            ),
            Container(
              width: 24,
              child: Stack(
                alignment: Alignment.topLeft,
                children: list,
              ),
            ),
          ],
        );
      },
    );
  }
}
