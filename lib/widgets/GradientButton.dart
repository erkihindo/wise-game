import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
	final Widget child;
	final double width;
	final double height;
	final Function onPressed;
	final bool disabled;
	final Color customColor1;
	final Color customColor2;
	final double margin;

	const GradientButton({
		required this.child,
		this.width = double.infinity,
		this.height = 50.0,
		required this.onPressed,
		this.disabled = false,
		required this.customColor1,
		required this.customColor2,
		this.margin = 0
	});

	@override
	Widget build(BuildContext context) {
		return Container(
			margin: EdgeInsets.all(margin),
			width: width,
			height: height,
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(25.0),
				gradient: LinearGradient(
					colors: getColors(),
				)),
			child: Material(
				color: Colors.transparent,
				child: InkWell(
					onTap: () {disabled ? print("disabled") : onPressed();},
					child: Center(
						child: child,
					)),
			),
		);
	}

	List<Color> getColors() {
		return disabled
			? <Color>[Colors.grey, Colors.grey]
			: (this.customColor1 == null
			? <Color>[
			Color.fromRGBO(160, 92, 147, 1.0),
			Color.fromRGBO(115, 82, 135, 1.0)
		]
			: <Color>[this.customColor1, this.customColor2]);
	}
}
