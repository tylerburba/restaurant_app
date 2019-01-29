import 'package:meta/meta.dart';
import 'package:restaurant_app/model/physcial_table.dart';
import 'package:restaurant_app/model/floor_plan.dart';

class ServerObject {
  String name;
  int guestThisShift = 0;
  bool isActive = true;
  int guestHandicap = 0;

  ServerObject({
    @required this.name,
  })  : assert(name != null);
}
