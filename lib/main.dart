import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WidgetDrag(),
    );
  }
}



class WidgetDrag extends StatefulWidget {
  @override
  _WidgetDragState createState() => _WidgetDragState();
}

class _WidgetDragState extends State<WidgetDrag> {
  List<Widget> movableItems;
  var tag = TextEditingController();
  var price = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      movableItems = [];
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: movableItems,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_comment),
        onPressed: () {
          setState(() {
            addTag();
            print(movableItems);
          });
        },
      ),
    );
  }

  Widget addTag() {
    showDialog(barrierDismissible: false,context: context,builder: (context){
      return SimpleDialog(
        title: Text("Tag new Product"),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ) ,
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: tag,
                decoration: InputDecoration(
                    hintText: "Tag:" ,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))
                ),
              ),

            ),
          ),
          Form(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: price,
                decoration: InputDecoration(
                    hintText: "Price:" ,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))
                ),
              ),

            ),
          ),

          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(onPressed: (){
                setState(() {
                  print(tag.text);
                  if (tag.text.isNotEmpty){
                    movableItems.add(DragableWidget(tag.text,price.text));
                  }
                  print(movableItems);
                });
                Navigator.pop(context);
              },
                child: Icon(Icons.add, color: Colors.green),
              ),
              RaisedButton(onPressed: (){
                Navigator.pop(context);
              },
                child: Icon(Icons.cancel_outlined,color: Colors.red,),
              ),

            ],
          ),

        ],
      );
    });
  }
}

class DragableWidget extends StatefulWidget {
  String tagName;
  String price;

  DragableWidget(this.tagName,this.price);

  @override
  _DragableWidgetState createState() => _DragableWidgetState();
}

class _DragableWidgetState extends State<DragableWidget> {
  var containerKey = GlobalKey();
  double xPosition = 10;
  double yPosition = 10;
  Color color;

  @override
  void initState() {
    color = RandomColor().randomColor();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return  Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          setState(() {
            xPosition += tapInfo.delta.dx;
            yPosition += tapInfo.delta.dy;
            print("object x: "+xPosition.toString()+ " object y:" +yPosition.toString());
          });
        },
        onPanEnd: (value){
          var containerHeight= containerKey.currentContext.size.height;
          var containerWidth= containerKey.currentContext.size.width;
          var screenWidth = MediaQuery.of(context).size.width;
          var screenHeight = MediaQuery.of(context).size.height;

          setState(() {
            xPosition<0? xPosition=10: xPosition>screenWidth-containerWidth?xPosition=screenWidth -containerWidth -10:xPosition;
            yPosition<0? yPosition=20:yPosition>screenHeight - containerHeight? yPosition = screenHeight - containerHeight -10 : yPosition;
          });
        },

        child: Container(
          key: containerKey,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          width: 180,
          height: 50,

          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(widget.tagName),
                Text(widget.price)
              ],
            ),
          ),
        ),
      ),
    );
  }


}


