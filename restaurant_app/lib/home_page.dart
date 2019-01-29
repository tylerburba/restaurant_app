import 'package:flutter/material.dart';

import 'package:restaurant_app/model/physcial_table.dart';
import 'package:restaurant_app/model/floor_plan.dart';
import 'package:restaurant_app/model/restaurant_object.dart';
import 'package:restaurant_app/model/server_object.dart';
import 'package:restaurant_app/model/visit_log.dart';
import 'package:restaurant_app/model/shift.dart';

import 'package:restaurant_app/forms/guests_entry.dart';
import 'package:restaurant_app/forms/shift_summary.dart';

import 'package:restaurant_app/delegates/floor_plan_delegate.dart';

import 'package:restaurant_app/widgets/server_tile.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.restaurant}) : super(key: key);

  final String title;
  final RestaurantObject restaurant;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<FloorPlan> floorPlans;
  int floorPlanIndex = 0;
  int floorPlanMaxIndex = 0;

  List<ServerObject> servers;
  int serverIndex = 0;
  Shift shift;

  @override
  void initState() {
    super.initState();
    floorPlans = widget.restaurant.floorPlans;
    floorPlanMaxIndex = widget.restaurant.floorPlanMaxIndex;
    servers = widget.restaurant.servers;
    shift = new Shift(start: DateTime.now(), shiftServers: new List.from(servers.getRange(0, 3)));
  }



  List<Widget> _getFloorPlanWidgets() {
    List<Widget> widgets = new List(floorPlans[floorPlanIndex].tables.length);

    for(int i = 0 ; i < floorPlans[floorPlanIndex].tables.length ; i++) {
      widgets[i] =
      new LayoutId(
          id: floorPlans[floorPlanIndex].tables[i].id,
          child: getTableWidget(i)
      );
    }
    return widgets;
  }

  String _tableGetLabel(String server, String tableNumber) {
    if(server != '') {
      return server;
    } else {
      return tableNumber;
    }
  }

  BoxShape _tableGetShape(String shape) {
    if(shape == "square"){
      return BoxShape.rectangle;
    } else {
      return BoxShape.circle;
    }
  }

  Color _tableGetColor(String server) {
    if(server != '') {
      return Colors.green;
    } else {
      return Colors.blueGrey;
    }
  }

  _tableAssign(int index) async {
    if(floorPlans[floorPlanIndex].tables[index].server == '') {
      int newGuests = await Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new GuestEntry())
      );
      if(newGuests > 0) {
        int _lowestGuestIndex = 0;
        for (_lowestGuestIndex = 0;
          _lowestGuestIndex < shift.shiftServers.length;
          _lowestGuestIndex++) {
            if (shift.shiftServers[_lowestGuestIndex].isActive == true) break;
        }
        for (int i = 0; i < shift.shiftServers.length; i++) {
          if (shift.shiftServers[i].isActive == true) {
            if ((shift.shiftServers[i].guestThisShift + shift.shiftServers[i].guestHandicap )<
                (shift.shiftServers[_lowestGuestIndex].guestThisShift + shift.shiftServers[_lowestGuestIndex].guestHandicap))
            {
              _lowestGuestIndex = i;
            }
          } else {
            shift.shiftServers[i].guestHandicap += newGuests;
          }
        }
        int tempGuestCount = shift.shiftServers[_lowestGuestIndex]
            .guestThisShift + newGuests;
        String tempServer = shift.shiftServers[_lowestGuestIndex].name;
        setState(() {
          floorPlans[floorPlanIndex].tables[index].server = tempServer;
          shift.shiftServers[_lowestGuestIndex].guestThisShift = tempGuestCount;
          shift.visits.add(new VisitLog(
              visitStart: DateTime.now(),
              visitServer: shift.shiftServers[_lowestGuestIndex],
              visitTable: floorPlans[floorPlanIndex].tables[index],
              visitGuestCount: newGuests)
          );
        });
      } //if newGuest > 0
    } else {
      int visitIndex = 0;
      for(int i = shift.visits.length-1; i>0 ; i--) {
        if(floorPlans[floorPlanIndex].tables[index].name == shift.visits[i].visitTable.name) {
         visitIndex = i;
        }
      }
      setState(() {
        floorPlans[floorPlanIndex].tables[index].server = '';
        shift.visits[visitIndex].visitEnd = DateTime.now();
      });
    }
  }

  Widget getTableWidget(int index) {
    if(floorPlans[floorPlanIndex].tables[index].server == null){
      setState((){
        floorPlans[floorPlanIndex].tables[index].server = '';
      });

    }

    return Material(
        child: Container(
            width: 100,
            height: 100,
            child: Padding(
                padding: EdgeInsets.all(5),
                child:InkWell(
                    onTap: () => _tableAssign(index),
                    child: Container(
                        decoration: BoxDecoration(
                          shape: _tableGetShape(floorPlans[floorPlanIndex].tables[index].shape),
                          color: _tableGetColor(floorPlans[floorPlanIndex].tables[index].server),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Center(
                          child: Text(
                              _tableGetLabel(
                                  floorPlans[floorPlanIndex].tables[index].server,
                                  floorPlans[floorPlanIndex].tables[index].name),
                              style: new TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )
                          ),
                        )
                    )
                )
            )
        )
    );
  }



  List<Widget> _buildServerTiles() {
    List<Widget> widgets = new List(shift.shiftServers.length);

    for(int i = 0 ; i < shift.shiftServers.length ; i++) {
      widgets[i] = new ServerTile(server: shift.shiftServers[i]);
    }

    return widgets;
  }

  void _decrementFloorPlan() {
    int _tempIndex = floorPlanIndex;
    if(_tempIndex == 0) {
      _tempIndex = floorPlanMaxIndex;
    } else {
      _tempIndex--;
    }
    setState(() {
      floorPlanIndex = _tempIndex;
    });
  }

  void _incrementFloorPlan() {
    int _tempIndex = floorPlanIndex;
    _tempIndex++;
    if(_tempIndex > floorPlanMaxIndex) {
      _tempIndex = 0;
    }
    setState(() {
      floorPlanIndex = _tempIndex;
    });
  }

  _navigateToShiftSummary () async {
    Shift _shift = await Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new ShiftSummary(shift: shift,))
    );
    if(_shift != null){
      setState(() {
        shift = _shift;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 300,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                      color: Colors.black,
                      width:2,
                      style: BorderStyle.solid
                    )
                ),
            ),
            child: Column(
              children: <Widget>[
                Container(height:23, decoration: BoxDecoration(color: Colors.black),),
                Container(
                  height: 40,
                  decoration: BoxDecoration(color: Colors.lightBlueAccent),
                  child:
                    ButtonTheme(
                      height: 40,
                      minWidth: 300,
                      child: FlatButton(
                        child: Text('Shift Summary', style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        )),
                        onPressed: _navigateToShiftSummary,
                        color: Colors.lightBlueAccent,

                      )
                    )
                ),
                Container(
                  height: MediaQuery.of(context).size.height-63,
                  child: ListView (
                    children:
                    _buildServerTiles()
                  )
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(height:23, decoration: BoxDecoration(color: Colors.black),),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.lightBlueAccent
                  ),
                  child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_left),
                          onPressed: _decrementFloorPlan,
                          color: Colors.white,
                        ),
                        Text(floorPlans[floorPlanIndex].roomName,
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_right),
                          onPressed: _incrementFloorPlan,
                          color: Colors.white,
                        ),
                      ]
                  ),
                ),
                Expanded(
                  child: CustomMultiChildLayout(
                    delegate: FloorPlanDelegate(),
                    children: _getFloorPlanWidgets(),
                  )
                )
              ],
            ),
          ),
        ], // <Widget>[]
      ),
    );
  }
}
