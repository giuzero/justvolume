import 'package:flutter/material.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';

void main() {
  runApp(const JustVolume());
}

class JustVolume extends StatelessWidget {
  const JustVolume({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'justvolume',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const JustVolumeHomePage(title: 'justvolume'),
    );
  }
}

class JustVolumeHomePage extends StatefulWidget {
  const JustVolumeHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<JustVolumeHomePage> createState() => _JustVolumeHomePage();
}

class _JustVolumeHomePage extends State<JustVolumeHomePage> {
  //on init vol value
  double volumeValue = 0.2;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      volumeValue = await PerfectVolumeControl.getVolume();
      setState(() {});
    });

    PerfectVolumeControl.stream.listen((volume) {
      setState(() {
        volumeValue = volume;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${(volumeValue * 100).toInt()}',
                style: Theme.of(context).textTheme.headline4),
            RotatedBox(
                quarterTurns: 3,
                child: Slider(
                  value: volumeValue,
                  onChanged: (newvol) {
                    volumeValue = newvol;
                    PerfectVolumeControl.setVolume(newvol); //set new volume
                    setState(() {});
                  },
                  min: 0, //
                  max: 1,
                  divisions: 20,
                ))
          ],
        ),
      ),
    );
  }
}
