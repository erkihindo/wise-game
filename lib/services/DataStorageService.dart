
import 'package:scoped_model/scoped_model.dart';
import 'package:wise_game/model/Result.dart';

mixin DataStorageService on Model {

	bool isLoading = false;

	int correctAnswers = 0;

	String FROM = "EUR";
	String TO = "USD";
	int amount = 200;

	double wiseRate = 0.7;
	double otherRate = 0.7;

	int wiseFee = 2;

	String moneySaved = "";
	double moneySavedDouble = 0;

	String player = "";

	List<Result> results = [];
	int podiumPlace = 0;

}