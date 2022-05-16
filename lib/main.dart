import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wise_game/pages/StartPage.dart';
import 'package:wise_game/services/MainScopeModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
	    debugShowCheckedModeBanner: false,
	    title: 'Wise Game',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

	final MainScopeModel model = MainScopeModel();


	@override
	Widget build(BuildContext context) {
		SystemChrome.setPreferredOrientations([
			DeviceOrientation.portraitUp,
			DeviceOrientation.portraitDown,
		]);
		return ScopedModel<MainScopeModel>(
			model: model,
			child: Stack(
				fit: StackFit.passthrough,
				alignment: AlignmentDirectional.bottomCenter,
				textDirection: TextDirection.ltr,
				children: [
					MaterialApp(
						builder: BotToastInit(),
						navigatorObservers: [BotToastNavigatorObserver()],//2.registered route observer
						debugShowCheckedModeBanner: false,
						title: widget.title,
						//Name in the switch tab
						theme: ThemeData(
							brightness: Brightness.light,
							primarySwatch: Colors.blue,
							accentColor: Colors.lightBlue),
						home: StartPage(model: model,)
					),
				])
		);
	}
}
