import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliderappflutter/utilities/state/running_tl_state.dart';

void main() {
  test('LoggingTest', () {
    BuildContext context;
    final runningTlState = new RunningTlState(null);
    runningTlState.rawLogAdd = '''
    overallSteps: 113600
    TLDependencies->StepsPerShot: 140
    TLDependencies->drivingTime: 309
    Point 0: interval: 2.40 start: 0 end: 296
    Point 1: interval: 4.60 start: 507 end: 661
    Point 2: interval: 12.60 start: 751 end: 808
    Point 3: interval: 0.00 start: 0 end: 0
    Point 4: interval: 0.00 start: 0 end: 0
    TLDependencies->shots: 808
    TLDependencies->drivingTime: 309
    TLDependencies->stepFactor: 4
    TLDependencies->StepsPerShot: 140
    TLDependencies->TL_time: 3591
    TLDependencies->startingTime: 0
    ----------------------------------------------
    TLDependencies->shotsTaken: 1
    TLDependencies->currentInterval: 2.40
    TLDependencies->drivingTime: 809''';

    runningTlState.updateValues();

    expect(runningTlState.shotsTaken, 1);
    expect(runningTlState.currentInterval, Duration(seconds: 2, milliseconds: 400));
    expect(runningTlState.maxExposure, Duration(seconds: 1, milliseconds: 591));
  });
}