import 'package:meta/meta.dart';
import 'package:restaurant_app/model/physcial_table.dart';
import 'package:restaurant_app/model/floor_plan.dart';
import 'package:restaurant_app/model/server_object.dart';
import 'package:restaurant_app/model/visit_log.dart';

class Shift {
  DateTime start;
  DateTime end;
  List<ServerObject> shiftServers = [];
  List<VisitLog> visits = [];

  Shift({
    @required this.start,
    @required this.shiftServers,
  })  : assert(start != null),
        assert(shiftServers != null);
}