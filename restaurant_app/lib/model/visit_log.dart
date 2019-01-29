import 'package:meta/meta.dart';
import 'package:restaurant_app/model/physcial_table.dart';
import 'package:restaurant_app/model/floor_plan.dart';
import 'package:restaurant_app/model/server_object.dart';

class VisitLog {
  DateTime visitStart, visitEnd;
  ServerObject visitServer;
  PhysicalTable visitTable;
  int visitGuestCount;

  VisitLog({
    @required this.visitStart,
    @required this.visitServer,
    @required this.visitTable,
    @required this.visitGuestCount,
  })  : assert(visitStart != null),
        assert(visitServer != null),
        assert(visitGuestCount != null),
        assert(visitTable != null);
}