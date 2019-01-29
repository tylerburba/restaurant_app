import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:restaurant_app/model/server_object.dart';

// We use an underscore to indicate that these variables are private.
// See https://www.dartlang.org/guides/language/effective-dart/design#libraries

/// A [CategoryTile] to display a [Category].
class ServerTile extends StatefulWidget {
  final ServerObject server;

  @override
  _ServerTileState createState() => _ServerTileState();

  ServerTile({
    Key key,
    @required this.server,
  })  : assert(server != null),
        super(key: key);
}

class _ServerTileState extends State<ServerTile> {

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 60,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                  widget.server.name,
                  style: new TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
              ),
            ),
            Expanded(
                child: Text(
                widget.server.guestThisShift.toString(),
                style: new TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              )
            ),
            Switch(
              value: widget.server.isActive,
              onChanged: (bool value) {
                setState(() {
                  widget.server.isActive = value;
                });
              },
            )
          ],
        )
      )

    );
  }
}