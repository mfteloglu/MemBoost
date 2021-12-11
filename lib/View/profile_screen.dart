import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.only(top: 30.0),
            child: const HeatMap(),
          ),
          Container(
            //padding: const EdgeInsets.all(10.0),
            //margin: const EdgeInsets.only(top: 30.0),
            child: const Text(
              "Today",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            //margin: const EdgeInsets.only(top: 30.0),
            child: const Text(
              "Studied x cards\nRetention rate is %x",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            //padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(top: 10.0),
            child: const Text(
              "1 Month",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            //margin: const EdgeInsets.only(top: 30.0),
            child: const Text(
              "Studied x cards\nRetention rate is %x",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            //padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(top: 10.0),
            child: const Text(
              "All time",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            //margin: const EdgeInsets.only(top: 30.0),
            child: const Text(
              "Studied x cards\nRetention rate is %x",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
    );
  }
}

class HeatMap extends StatelessWidget {
  const HeatMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      crossAxisCount: 15,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: [
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
        HeatMapNode(),
      ],
    );
  }
}

class HeatMapNode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      //child: const Text("HeatMapNode"),
      color: Colors.green,
    );
  }
}
