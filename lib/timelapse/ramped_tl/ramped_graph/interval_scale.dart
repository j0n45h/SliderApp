import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/niceScale.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/interval_range_state.dart';
import 'package:sliderappflutter/utilities/map.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class IntervalScale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final intervalRangeState =
        Provider.of<IntervalRangeState>(context, listen: false);
    var scale = NiceScale(intervalRangeState.intervalRange.start,
        intervalRangeState.intervalRange.end, 5);

    List<Widget> list = [];
    var height = MediaQuery.of(context).size.height;

    for (var i = scale.niceMin; i <= scale.niceMax; i += scale.tickSpacing) {
      var pos = map(i, scale.niceMin, scale.niceMax, height - 25, 40);
      list.add(Positioned(
        top: pos,
        child: Row(
          children: [
            Container(
              width: 4,
              height: 1,
              color: Colors.grey[500],
            ),
            SizedBox(width: 3),
            Text(
              i.floor().toString(),
              style: MyTextStyle.normal(fontSize: 12),
            ),
          ],
        ),
      ));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 5),
          width: 2,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[500],
        ),
        Container(
          height: height,
          width: 24,
          child: Stack(
            alignment: Alignment.topRight,
            children: list,
          ),
        ),
      ],
    );
  }
}
