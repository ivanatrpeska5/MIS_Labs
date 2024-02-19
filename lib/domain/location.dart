class Location {
  final String name;
  final double latitude;
  final double longitude;

  Location(
      {required this.name, required this.latitude, required this.longitude});

  static List<Location> getLocations() {
    return [
      Location(name: "Факултет за информатички науки и компјутерско инженерство", latitude: 42.004486, longitude: 21.4072295),
      Location(name: "Факултет за електротехника и информациски технологии", latitude: 42.0049858, longitude: 21.4034476),
      Location(name: "Технолошко-металуршки факултет", latitude: 42.0046209, longitude: 21.4073652),
      Location(name: "Машински факултет", latitude: 42.0045699, longitude: 21.4055415)
    ];
  }

  static Location finki = Location.getLocations()[0];
  static Location feit = Location.getLocations()[1];
  static Location tmf = Location.getLocations()[2];
  static Location mf = Location.getLocations()[3];
}