import 'dart:convert';

class Weather {
  double latitude;
  double longitude;
  double generationtimeMs;
  int utcOffsetSeconds;
  String timezone;
  String timezoneAbbreviation;
  int elevation;
  CurrentUnits currentUnits;
  Current current;
  HourlyUnits hourlyUnits;
  Hourly hourly;

  Weather({
    required this.latitude,
    required this.longitude,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.currentUnits,
    required this.current,
    required this.hourlyUnits,
    required this.hourly,
  });

  factory Weather.fromRawJson(String str) => Weather.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    generationtimeMs: json["generationtime_ms"]?.toDouble(),
    utcOffsetSeconds: json["utc_offset_seconds"],
    timezone: json["timezone"],
    timezoneAbbreviation: json["timezone_abbreviation"],
    elevation: json["elevation"]?.toInt(),
    currentUnits: CurrentUnits.fromJson(json["current_units"]),
    current: Current.fromJson(json["current"]),
    hourlyUnits: HourlyUnits.fromJson(json["hourly_units"]),
    hourly: Hourly.fromJson(json["hourly"]),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "generationtime_ms": generationtimeMs,
    "utc_offset_seconds": utcOffsetSeconds,
    "timezone": timezone,
    "timezone_abbreviation": timezoneAbbreviation,
    "elevation": elevation,
    "current_units": currentUnits.toJson(),
    "current": current.toJson(),
    "hourly_units": hourlyUnits.toJson(),
    "hourly": hourly.toJson(),
  };
}

class Current {
  String time;
  int interval;
  double temperature2M;
  int relativeHumidity2M;
  int weatherCode;
  double surfacePressure;
  double windSpeed10M;

  Current({
    required this.time,
    required this.interval,
    required this.temperature2M,
    required this.relativeHumidity2M,
    required this.weatherCode,
    required this.surfacePressure,
    required this.windSpeed10M,
  });

  factory Current.fromRawJson(String str) => Current.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Current.fromJson(Map<String, dynamic> json) => Current(
    time: json["time"],
    interval: json["interval"],
    temperature2M: json["temperature_2m"]?.toDouble(),
    relativeHumidity2M: json["relative_humidity_2m"],
    weatherCode: json["weather_code"],
    surfacePressure: json["surface_pressure"]?.toDouble(),
    windSpeed10M: json["wind_speed_10m"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "interval": interval,
    "temperature_2m": temperature2M,
    "relative_humidity_2m": relativeHumidity2M,
    "weather_code": weatherCode,
    "surface_pressure": surfacePressure,
    "wind_speed_10m": windSpeed10M,
  };
}

class CurrentUnits {
  String time;
  String interval;
  String temperature2M;
  String relativeHumidity2M;
  String weatherCode;
  String surfacePressure;
  String windSpeed10M;

  CurrentUnits({
    required this.time,
    required this.interval,
    required this.temperature2M,
    required this.relativeHumidity2M,
    required this.weatherCode,
    required this.surfacePressure,
    required this.windSpeed10M,
  });

  factory CurrentUnits.fromRawJson(String str) => CurrentUnits.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrentUnits.fromJson(Map<String, dynamic> json) => CurrentUnits(
    time: json["time"],
    interval: json["interval"],
    temperature2M: json["temperature_2m"],
    relativeHumidity2M: json["relative_humidity_2m"],
    weatherCode: json["weather_code"],
    surfacePressure: json["surface_pressure"],
    windSpeed10M: json["wind_speed_10m"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "interval": interval,
    "temperature_2m": temperature2M,
    "relative_humidity_2m": relativeHumidity2M,
    "weather_code": weatherCode,
    "surface_pressure": surfacePressure,
    "wind_speed_10m": windSpeed10M,
  };
}

class Hourly {
  List<String> time;
  List<double> temperature2M;
  List<int> weatherCode;

  Hourly({
    required this.time,
    required this.temperature2M,
    required this.weatherCode,
  });

  factory Hourly.fromRawJson(String str) => Hourly.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
    time: List<String>.from(json["time"].map((x) => x)),
    temperature2M: List<double>.from(json["temperature_2m"].map((x) => x?.toDouble())),
    weatherCode: List<int>.from(json["weather_code"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "time": List<dynamic>.from(time.map((x) => x)),
    "temperature_2m": List<dynamic>.from(temperature2M.map((x) => x)),
    "weather_code": List<dynamic>.from(weatherCode.map((x) => x)),
  };
}

class HourlyUnits {
  String time;
  String temperature2M;
  String weatherCode;

  HourlyUnits({
    required this.time,
    required this.temperature2M,
    required this.weatherCode,
  });

  factory HourlyUnits.fromRawJson(String str) => HourlyUnits.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HourlyUnits.fromJson(Map<String, dynamic> json) => HourlyUnits(
    time: json["time"],
    temperature2M: json["temperature_2m"],
    weatherCode: json["weather_code"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "temperature_2m": temperature2M,
    "weather_code": weatherCode,
  };
}
