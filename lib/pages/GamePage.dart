import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wise_game/pages/ResultsPage.dart';
import 'package:wise_game/services/MainScopeModel.dart';
import 'package:wise_game/widgets/CustomAnimationConfiguration.dart';
import 'package:wise_game/widgets/GradientButton.dart';
import 'package:wise_game/widgets/HexColor.dart';

class GamePage extends StatefulWidget {
  final MainScopeModel model;

  const GamePage({Key? key, required this.model}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

enum Selected { wise, other }

class _GamePageState extends State<GamePage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.
	int secondsPassed = 0;
  @override
  void initState() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopeModel>(builder: (context, child, model) => buildScaffold());
  }

  Selected? _selectedInst = Selected.other;

  buildScaffold() {
    return Scaffold(
	    // bottomNavigationBar: buildLoadingProgress(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Container(
          color: HexColor("#485CC7"),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
	            buildLoadingProgress(),
              StreamBuilder<int>(
                stream: _stopWatchTimer.secondTime,
                initialData: 0,
                builder: (context, snap) {
                  final value = snap.data;
                  return Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  'Your time: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Helvetica',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  value.toString(),
                                  style: TextStyle(fontSize: 25, fontFamily: 'Helvetica', fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'You want to send',
                    textScaleFactor: 1.4,
                    style: TextStyle(color: HexColor("#ffffff")),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.model.amount} ${widget.model.FROM}',
                        textScaleFactor: 1.6,
                        style: TextStyle(color: HexColor("#FFB619"), fontWeight: FontWeight.bold),
                      ),
                      Text(' to ${widget.model.TO}', textScaleFactor: 1.6, style: TextStyle(color: HexColor("#ffffff"), fontWeight: FontWeight.bold)),
                    ],
                  ),
	                Text(
		                'Is Wise better, or is the bank better?',
		                textScaleFactor: 1.2,
		                style: TextStyle(color: HexColor("#ffffff")),
	                ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Card(
                        child:
				              Padding(padding: EdgeInsets.all(15), child: Column(
					              children: [Text("Wise's rate:", textScaleFactor: 1.2,), Text("${widget.model.wiseRate}", textScaleFactor: 1.6, style: TextStyle(fontWeight: FontWeight.bold, color: HexColor("#2ed06e")),)],
				              ),),
                      ),
                    ],
                  ),

	                Column(
		                children: [
			                Card(
				                child:
				                Padding(padding: EdgeInsets.all(15), child: Column(
					                children: [Text("Bank's rate:", textScaleFactor: 1.2,), Text("${widget.model.otherRate}", textScaleFactor: 1.6, style: TextStyle(fontWeight: FontWeight.bold, color: HexColor("#c22e2e")),)],
				                ),),
			                ),
		                ],
	                ),
                ],
              ),
	            Row(
		            crossAxisAlignment: CrossAxisAlignment.center,
		            mainAxisAlignment: MainAxisAlignment.spaceAround,
		            children: [
			            Column(
				            children: [
					            Card(
						            child:
						            Padding(padding: EdgeInsets.all(15), child: Column(
							            children: [Text("Wise's fee:", textScaleFactor: 1.2,), Text("${widget.model.wiseFee} ${widget.model.TO}", textScaleFactor: 1.6, style: TextStyle(fontWeight: FontWeight.bold, color: HexColor("#c22e2e")),)],
						            ),),
					            ),
					            Radio<Selected>(value: Selected.wise, activeColor: HexColor("#44EE70"), groupValue: _selectedInst, onChanged: (Selected? value) {
					            	setState(() {
							            _selectedInst = value;
					            	});
					            })
				            ],
			            ),

			            Column(
				            children: [
					            Card(
						            child:
						            Padding(padding: EdgeInsets.all(15), child: Column(
							            children: [Text("Bank's fee:", textScaleFactor: 1.2,), Text("0 ${widget.model.TO}", textScaleFactor: 1.6, style: TextStyle(fontWeight: FontWeight.bold, color: HexColor("#2ed06e")),)],
						            ),),
					            ),
					            Radio<Selected>(value: Selected.other, activeColor: HexColor("#44EE70"), groupValue: _selectedInst, onChanged: (Selected? value) {
						            setState(() {
							            _selectedInst = value;
						            });
					            })
				            ],
			            ),
		            ],
	            ),
              SizedBox(height: 15,),
              buildQuestionBox(context),
              GradientButton(
                  margin: 10,
                  customColor1: HexColor("#00b9ff"),
                  customColor2: HexColor("#00b9ff"),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text("Submit"),
                  ),
                  onPressed: () {
	                  setState(() {
	                  	checkAnswer();
	                  });
                  })
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _questionForm = GlobalKey<FormState>();
  final TextEditingController _questionController = new TextEditingController();
  String insertedText = '';

  buildQuestionBox(context) {
    return Form(
        key: _questionForm,
        child: Card(
          margin: EdgeInsets.only(left: 50, right: 50),
          child: TextFormField(
	          keyboardType: TextInputType.number,
	          style: TextStyle(color: HexColor("#37517e"), fontSize: 20),
            textInputAction: TextInputAction.done,
            inputFormatters: [
              LengthLimitingTextInputFormatter(30),
            ],
            textAlign: TextAlign.center,
            controller: _questionController,
            onChanged: (String changed) {
              this.insertedText = changed;
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.white,
              hintText: 'Write difference',
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
          ),
        ));
  }

  buildLoadingProgress() {
	  return LinearPercentIndicator(
		  width: MediaQuery.of(context).size.width,
		  padding: EdgeInsets.zero,
		  animation: true,
		  lineHeight: 20.0,
		  animationDuration: 100,
		  percent: widget.model.correctAnswers / 5,
		  center: Text("${widget.model.correctAnswers}/5", style: TextStyle(color: HexColor("#ffffff")),),
		  linearStrokeCap: LinearStrokeCap.butt,
		  backgroundColor: Colors.transparent,
		  progressColor: HexColor("#00b9ff"),
	  );
  }

  void checkAnswer() {
	  if (_selectedInst != Selected.wise) {
	  	clearAnswer();
  		showIncorrectAnswer(widget.model.moneySaved, widget.model.TO);
	    resetMath();

	    return;
    }

  	if (insertedText.trim() != widget.model.moneySaved) {
	    clearAnswer();
	    showIncorrectAnswer(widget.model.moneySaved, widget.model.TO);
	    resetMath();

	    return;

    } else {
	    showCorrectAnswer(context);
	    clearAnswer();
	    setState(() {
	      widget.model.correctAnswers++;
	    });
    }


  	if (widget.model.correctAnswers >= 5) {

  		showCorrectAnswer(context);
  		widget.model.addResult(_stopWatchTimer.secondTime.value);

  		widget.model.correctAnswers = 0;
	    widget.model.justWait(numberOfSeconds: 1).then((value) => Navigator.of(context)
		    .pushReplacement(
		    FadeRouteSwitcher(
			    builder: (context) {return ResultsPage(model: widget.model,);},
		    )));

    } else {
	    resetMath();

    }


  }

  void resetMath() {
    widget.model.getMoneyAmount();
    widget.model.getOtherBanksRate();
    widget.model.getWiseRate();
    widget.model.getWiseFee();
    widget.model.getFromToCurrencies();
  }

  void showCorrectAnswer(context) {
	  BotToast.showCustomLoading(
		  crossPage: true,
		  clickClose: true,
		  duration: Duration(
			  seconds: 2,
		  ),
		  backgroundColor: Colors.greenAccent,
		  align: Alignment.center,
		  toastBuilder: (cancelFunc) {
			  return Column(
				  mainAxisAlignment: MainAxisAlignment.center,
				  children: <Widget>[
					  Icon(MdiIcons.checkboxMarkedCircleOutline, color: Colors.white, size: 150,),
					  Text("Correct!",
						  style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
						  textAlign: TextAlign.center,)

				  ],);
		  });
  }

  void showIncorrectAnswer(String moneySaved, String to) async {
	  BotToast.showCustomLoading(
		  clickClose: true,
		  ignoreContentClick: false,
		  duration: Duration(
			  seconds: 4,
		  ),
		  backgroundColor: Colors.redAccent,
		  align: Alignment.center,
		  toastBuilder: (cancelFunc) {
			  return Column(
				  mainAxisAlignment: MainAxisAlignment.center,
				  children: <Widget>[
					  Icon(MdiIcons.alphaXBoxOutline, color: Colors.white, size: 150,),
					  Text("Incorrect...", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
					  Text("Wise would actually save you: ${moneySaved} ${to}", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),


				  ],);
		  });
  }

  void clearAnswer() {
	  setState(() {
		  insertedText = "";
		  _questionController.clear();
	  });
  }
}
