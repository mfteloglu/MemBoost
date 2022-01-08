import 'package:flutter/material.dart';
import 'package:memboost/Model/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        // title: const Text(
        //   "Profile",
        //   style: TextStyle(color: Colors.black87),
        // ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            //padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(top: 15.0),
            child: Image.network(Provider.of<GoogleSignInProvider>(context, listen: false)
                .user
                .photoUrl!,
                height: 50, fit: BoxFit.fill),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            //margin: const EdgeInsets.only(top: 30.0),
            child: Text(
              Provider.of<GoogleSignInProvider>(context, listen: false)
                  .user
                  .displayName!,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 30.0),
            //margin: const EdgeInsets.only(top: 30.0),
            child: const Text(
              "Heatmap",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            //padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(bottom: 10.0),
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
          Container(
              padding: const EdgeInsets.all(20.0),
              //margin: const EdgeInsets.only(top: 30.0),
              child: OutlinedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                          title: Text('Your current subscription',
                              textAlign: TextAlign.center),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('-Monthly Payment \n -62 days left \n ',
                                  textAlign: TextAlign.center),
                              ElevatedButton(
                                onPressed: () =>
                                    launch('https://www.itu.edu.tr/'),
                                child: Row(
                                  // Replace with a Row for horizontal icon + text
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.link),
                                    Text("  Extend")
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                ),
                              )
                            ],
                          )));
                },
                child: const Text('MANAGE SUBSCRIPTION'),
              )),
        ],
      )),
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
