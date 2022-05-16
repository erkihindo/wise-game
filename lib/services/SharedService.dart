import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wise_game/model/Result.dart';
import 'DataStorageService.dart';

mixin SharedService on DataStorageService {

	List<int> moneys = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000];
	List<double> rates = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];

	List<String> currencies = ["EUR", "USD", "JPY", "GBP", "CAD", "AUD", "CHF"];

	int getMoneyAmount() {
		final _random = new Random();
		var element = moneys[_random.nextInt(moneys.length)];
		this.amount = element;
		return element;
	}

	double getOtherBanksRate() {
		final _random = new Random();

		// generate a random index based on the list length
		// and use it to retrieve the element
		var element = rates[_random.nextInt(rates.length - 1)];
		this.otherRate = element;
		return element;
	}

	double getWiseRate() {
		final _random = new Random();

		var indexOfOtherBanksRate = rates.indexOf(otherRate);
		var ratesLeftOnTheRight = 9 - indexOfOtherBanksRate;

		// generate a random index based on the list length
		// and use it to retrieve the element
		var newWiseIndex = indexOfOtherBanksRate + _random.nextInt(ratesLeftOnTheRight);
		var element = rates[newWiseIndex == indexOfOtherBanksRate ? newWiseIndex+1 : newWiseIndex];
		this.wiseRate = element;
		return element;
	}

	String getFromToCurrencies() {
		final _random = new Random();

		var from = currencies[_random.nextInt(currencies.length - 1)];
		this.FROM = from;

		var indexOfFromRate = currencies.indexOf(from);
		var currenciesOnTheRight = 6 - indexOfFromRate;

		// generate a random index based on the list length
		// and use it to retrieve the element
		var toIndex = indexOfFromRate + _random.nextInt(currenciesOnTheRight);
		var element = currencies[indexOfFromRate == toIndex ? toIndex+1 : toIndex];
		this.TO = element;
		return element;
	}

	int getWiseFee() {
		final _random = new Random();

		int moneySavedWithoutFee = (amount * wiseRate - amount * otherRate).round();

		int maximumFee = min(moneySavedWithoutFee - 5, 98);
		int minimumFee = 1;


		var fee = minimumFee + _random.nextInt(maximumFee);

		int moneySavedEvenWithFee = (amount * wiseRate - amount * otherRate).round() - fee;

		this.wiseFee = fee;
		this.moneySaved = moneySavedEvenWithFee.toString();
		this.moneySavedDouble = amount * wiseRate - amount * otherRate;

		print("Wise would save you $moneySavedEvenWithFee");

		return fee;
	}


	void stopSpinner() {
		this.isLoading = false;
		notifyListeners();
	}

	void startSpinner() {
		this.isLoading = true;
		notifyListeners();
	}

	void addResult(int seconds) {

		addNewResultToTheList(seconds);
		storeResultsInCache("results", this.results.map((e) => e.toMap()).toList());

	}

	loadResults() async {
		final SharedPreferences prefs = await SharedPreferences.getInstance();
		String? resultsInCache = prefs.getString("results");
		if (resultsInCache != null) {
			this.results = List<Result>.from(jsonDecode(resultsInCache)
				.map((e) => Result.fromBody(e))
				.toList());
		}
	}

	storeResultsInCache(String key, List<Map<String, dynamic>> values) async {
		final SharedPreferences prefs = await SharedPreferences.getInstance();
		prefs.setString(key, jsonEncode(values));
	}

	Future justWait({required int numberOfSeconds}) async {
		await Future.delayed(Duration(seconds: numberOfSeconds));
	}

  void addNewResultToTheList(int seconds) {
	  var oldResults = List.from(results);
	  var newResult = new Result(this.player, seconds, DateTime.now());
	  if (results.isEmpty) {
		  this.results.add(newResult);
		  this.podiumPlace = 1;
		  return;
	  }
	  if (newResult.seconds > results.last.seconds) {
		  this.results.add(newResult);
		  this.podiumPlace = results.length;
		  return;
	  } else {
		  for (Result oldResult in oldResults) {
			  if (newResult.seconds < oldResult.seconds) {
				  this.podiumPlace = results.indexOf(oldResult) + 1;
				  this.results.insert(results.indexOf(oldResult), newResult);
				  return;
			  }
		  }
	  }
  }

}