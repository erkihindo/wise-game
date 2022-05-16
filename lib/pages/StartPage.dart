import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wise_game/pages/GamePage.dart';
import 'package:wise_game/services/MainScopeModel.dart';
import 'package:wise_game/widgets/CustomAnimationConfiguration.dart';
import 'package:wise_game/widgets/GradientButton.dart';
import 'package:wise_game/widgets/HexColor.dart';

class StartPage extends StatefulWidget {
	final MainScopeModel model;

  const StartPage({Key? key, required this.model}) : super(key: key);

	@override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

	@override
  void initState() {
	widget.model.loadResults();
    super.initState();
  }
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
				  children: [SvgPicture.asset(
					  'assets/wise_hero_white_RGB.svg',
					  color: Colors.white,
					  semanticsLabel: 'Wise logo'
				  ),
				  SizedBox(height: 20,),
				  buildQuestionBox(context),
				  SizedBox(height: 20,),
				  GradientButton(
					  margin: 10,
					  customColor1: insertedText.length > 0 ? HexColor("#00b9ff") : HexColor("#D3D5D8"),
					  customColor2: insertedText.length > 0 ? HexColor("#00b9ff") : HexColor("#D3D5D8"),
					  child:
					  Padding(
						  padding: EdgeInsets.symmetric(horizontal: 5),
						  child: Text("Start"),
					  )
					  ,
					  onPressed: () {
						  widget.model.getMoneyAmount();
						  widget.model.getOtherBanksRate();
						  widget.model.getWiseRate();
						  widget.model.getWiseFee();
						  widget.model.getFromToCurrencies();

			            if (insertedText.length > 0) {
			                widget.model.player = insertedText;
				            Navigator.of(context)
					            .pushReplacement(
					            FadeRouteSwitcher(
						            builder: (context) {return GamePage(model: widget.model,);},
					            ));
			            }

					  })
				  ],
			  ),),
		  ),
	  );
  }

	final GlobalKey<FormState> _questionForm = GlobalKey<FormState>();
	final TextEditingController _questionController = new TextEditingController();
	String insertedText = '';

	buildQuestionBox(context) {
		return Form(
			key: _questionForm,
			child:
				Card(
					margin: EdgeInsets.only(left: 50, right: 50),
					child: TextFormField(
						style: TextStyle(color: HexColor("#44EE70")),
						textInputAction: TextInputAction.done,
						inputFormatters: [
							LengthLimitingTextInputFormatter(30),
						],

						textAlign: TextAlign.center,
						controller: _questionController,
						onChanged: (String changed) {
							setState(() {
								this.insertedText = changed;

							});
						},
						decoration: InputDecoration(
							border: InputBorder.none,
							fillColor: Colors.white,
							hintText: 'Enter your email here',
							hintStyle: TextStyle(color: HexColor("#37517e")),
							counterText: "",
							// contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
						),
						validator: (String? value) {
							if (value == null || value.length < 1) {
								return 'Please enter something';
							}
							return null;
						},
					)
					,
				)

		);
	}
}
