import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wise_game/pages/GamePage.dart';
import 'package:wise_game/pages/StartPage.dart';
import 'package:wise_game/services/MainScopeModel.dart';
import 'package:wise_game/widgets/CustomAnimationConfiguration.dart';
import 'package:wise_game/widgets/GradientButton.dart';
import 'package:wise_game/widgets/HexColor.dart';

class ResultsPage extends StatefulWidget {
	final MainScopeModel model;

  const ResultsPage({Key? key, required this.model}) : super(key: key);

	@override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
	@override
	Widget build(BuildContext context) {
		return ScopedModelDescendant<MainScopeModel>(builder: (context, child, model) => buildScaffold());
	}

  buildScaffold() {
	  return Scaffold(
		  resizeToAvoidBottomInset: false,
		  backgroundColor: Colors.blueAccent,
		  body: SafeArea(
			  child: Container(color: HexColor("#37517e"), child:
			  Column(
				  mainAxisAlignment: MainAxisAlignment.center,
				  children: [
				  	GestureDetector(
					    child: Text(
						    'Your place in the ranking:',
						    textScaleFactor: 1.4,
						    style: TextStyle(color: HexColor("#ffffff")),
					    ),
					    onLongPress: () async {
					    	String text = widget.model.results.map((e) => e.name).join(" ; ");
							  ClipboardData data = ClipboardData(text: text);
							  await Clipboard. setData(data);
						  },
				    ),
					  Text(
						  '${widget.model.podiumPlace} out of ${widget.model.results.length}',
						  textScaleFactor: 1.6,
						  style: TextStyle(color: HexColor("#2ed06e")),
					  ),
					  Text(
						  '(TOP ${widget.model.podiumPlace * 100 ~/ widget.model.results.length}%)',
						  textScaleFactor: 0.9,
						  style: TextStyle(color: HexColor("#ffffff")),
					  ),
				    SizedBox(height: 10,),

					  Card(
						  child: QrImage(
							  data: "https://app.greenhouse.io/e/tjcmtw",
							  version: QrVersions.auto,
							  size: 200.0,
						  ),
					  ),
					  Text(
						  'Good job, millions of people fail to do this at all! ',
						  textScaleFactor: 0.9,
						  style: TextStyle(color: HexColor("#ffffff")),
					  ),
				  SizedBox(height: 10,),
				  GradientButton(
					  margin: 10,
					  customColor1:  HexColor("#00b9ff") ,
					  customColor2: HexColor("#00b9ff") ,
					  child:
					  Padding(
						  padding: EdgeInsets.symmetric(horizontal: 5),
						  child: Text("Finish"),
					  )
					  ,
					  onPressed: () {
						    widget.model.getMoneyAmount();
						    widget.model.getOtherBanksRate();
					        widget.model.getWiseRate();
					        widget.model.getWiseFee();
					        widget.model.getFromToCurrencies();
					        widget.model.player = "";
					        widget.model.podiumPlace = 0;

				            Navigator.of(context)
					            .pushReplacement(
					            FadeRouteSwitcher(
						            builder: (context) {return StartPage(model: widget.model,);},
					            ));
			            }
		            )
				  ],
			  ),),
		  ),
	  );
  }

}
