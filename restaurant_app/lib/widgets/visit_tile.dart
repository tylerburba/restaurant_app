import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:restaurant_app/model/shift.dart';

// We use an underscore to indicate that these variables are private.
// See https://www.dartlang.org/guides/language/effective-dart/design#libraries

/// A [CategoryTile] to display a [Category].
class VisitTile extends StatefulWidget {
  final Shift shift;
  final int index;


  @override
  _VisitTileState createState() => _VisitTileState();

  VisitTile({
    Key key,
    @required this.shift,
    @required this.index
  })  : assert(shift != null),
        assert(shift != null),
        super(key: key);
}

class _VisitTileState extends State<VisitTile> {
  String endTime;


  void initState() {
    super.initState();
  }

  void _voidVisit() {
    for(int i = 0 ; i < widget.shift.shiftServers.length ; i++) {
      if(widget.shift.shiftServers[i].name == widget.shift.visits[widget.index].visitServer.name) {
        widget.shift.shiftServers[i].guestThisShift = widget.shift.shiftServers[i].guestThisShift - widget.shift.visits[widget.index].visitGuestCount;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.shift.visits[widget.index].visitEnd != null) {
      endTime = widget.shift.visits[widget.index].visitEnd.toIso8601String().substring(0,16);
    } else {
      endTime = 'Ongoing';
    }

    return Material(
        child: Container(
          child: InkWell(
            onLongPress: _voidVisit,
            child: Row(
              children: [
                Expanded(
                    child: Text(widget.shift.visits[widget.index].visitStart.toIso8601String().substring(0,16))
                ),
                Expanded(
                    child: Text(widget.shift.visits[widget.index].visitServer.name + '-' +
                        widget.shift.visits[widget.index].visitGuestCount.toString())
                ),
                Expanded(
                    child: Text(widget.shift.visits[widget.index].visitTable.name)
                ),
                Expanded(
                    child: Text(endTime)
                ),
              ],
            ),
          ),
        ),

    );
  }
}



