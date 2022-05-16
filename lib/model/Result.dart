
class Result {

	String name;
	int seconds;
	DateTime timestamp;


	Result(this.name, this.seconds, this.timestamp);

	static Result fromBody(jsonBody) {
		Result result = new Result(jsonBody['name'], jsonBody['seconds'], DateTime.parse(jsonBody['timestamp']));
		return result;
	}

	Map<String, dynamic> toMap() {
		return {
			'name': name,
			'seconds': seconds,
			'timestamp': timestamp.toIso8601String()
		};
	}
}