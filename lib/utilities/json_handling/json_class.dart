import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliderappflutter/utilities/custom_cache_manager.dart';

class TLData {
  List<LinearTL> linearTL;
  List<RampedTL> rampedTL;
  List<Video> video;

  TLData() {
    linearTL = new List<LinearTL>();
    rampedTL = new List<RampedTL>();
    video    = new List<Video>();
  }

  void fromJson(Map<String, dynamic> json) {
    if (json['LinearTL'] != null) {
      linearTL = new List<LinearTL>();
      json['LinearTL'].forEach((v) {
        linearTL.add(new LinearTL.fromJson(v));
      });
    }
    if (json['RampedTL'] != null) {
      rampedTL = new List<RampedTL>();
      json['RampedTL'].forEach((v) {
        rampedTL.add(new RampedTL.fromJson(v));
      });
    }
    if (json['Video'] != null) {
      video = new List<Video>();
      json['Video'].forEach((v) {
        video.add(new Video.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.linearTL != null) {
      data['LinearTL'] = this.linearTL.map((v) => v.toJson()).toList();
    }
    if (this.rampedTL != null) {
      data['RampedTL'] = this.rampedTL.map((v) => v.toJson()).toList();
    }
    if (this.video != null) {
      data['Video'] = this.video.map((v) => v.toJson()).toList();
    }
    return data;
  }

  void saveToCache() {
    final json = this.toJson();
    CustomCacheManager.storeTLDataAsJson(json);
  }

  Future<void> getFromCache() async {
    final json = await CustomCacheManager.getTLDataAsJson();
    if (json == null) return;
    fromJson(json);
  }

  Future<void> openFromAssets() async {
    final jsonFromAssets = await rootBundle.loadString('assets/slider_example.json');
    final jsonOBJ = json.decode(jsonFromAssets);
    fromJson(jsonOBJ);
  }

}

class LinearTL {
  int index;
  double interval;
  String name;
  int shots;

  LinearTL({this.index, this.interval, this.name, this.shots});

  LinearTL.fromJson(Map<String, dynamic> json) {
    index = json['Index'];
    interval = double.parse(json['Interval'].toString());
    name = json['Name'];
    shots = json['Shots'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Index'] = this.index;
    data['Interval'] = this.interval;
    data['Name'] = this.name;
    data['Shots'] = this.shots;
    return data;
  }
}

class RampedTL {
  int index;
  String name;
  List<Points> points;

  RampedTL({this.index, this.name, this.points});

  RampedTL.fromJson(Map<String, dynamic> json) {
    index = json['Index'];
    name = json['Name'];
    if (json['Points'] != null) {
      points = new List<Points>();
      json['Points'].forEach((v) {
        points.add(new Points.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Index'] = this.index;
    data['Name'] = this.name;
    if (this.points != null) {
      data['Points'] = this.points.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Points {
  int end;
  double interval;
  int start;

  Points({this.end, this.interval, this.start});

  Points.fromJson(Map<String, dynamic> json) {
    end = json['End'];
    interval = double.parse(json['Interval'].toString());
    start = json['Start'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['End'] = this.end;
    data['Interval'] = this.interval;
    data['Start'] = this.start;
    return data;
  }
}

class Video {
  int index;
  String name;
  int acceleration;
  int deceleration;
  bool infinite;
  int speed;

  Video(
      {this.index,
        this.name,
        this.acceleration,
        this.deceleration,
        this.infinite,
        this.speed});

  Video.fromJson(Map<String, dynamic> json) {
    index = json['Index'];
    name = json['Name'];
    acceleration = json['Acceleration'];
    deceleration = json['Deceleration'];
    infinite = json['Infinite'];
    speed = json['Speed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Index'] = this.index;
    data['Name'] = this.name;
    data['Acceleration'] = this.acceleration;
    data['Deceleration'] = this.deceleration;
    data['Infinite'] = this.infinite;
    data['Speed'] = this.speed;
    return data;
  }
}
