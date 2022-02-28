part of 'package:tabby_flutter_sdk/tabby_flutter_sdk.dart';




class EdgeAlert {
  static const int LENGTH_SHORT = 1; //1 seconds
  static const int LENGTH_LONG = 2; // 2 seconds
  static const int LENGTH_VERY_LONG = 3; // 3 seconds

  static const int TOP = 1;
  static const int BOTTOM = 2;

  static void show(
    BuildContext context, {
    IconData? icon,
    required Color backgroundColor,
    required String title,
    required String description,
    required int duration,
    required int gravity,
  }) {
    OverlayView.createView(context,
        title: title,
        description: description,
        duration: duration,
        gravity: gravity,
        backgroundColor: backgroundColor,
        icon: icon);
  }
}

class OverlayView {
  static final OverlayView _singleton = OverlayView._internal();

  factory OverlayView() {
    return _singleton;
  }

  OverlayView._internal();

  static late OverlayState _overlayState;
  static late OverlayEntry _overlayEntry;
  static bool _isVisible = false;

  static void createView(BuildContext context,
      {required String title,
      String description = "",
      int? duration,
      int? gravity,
      Color? backgroundColor,
      IconData? icon}) {
    _overlayState = Navigator.of(context).overlay!;

    if (!_isVisible) {
      _isVisible = true;

      _overlayEntry = OverlayEntry(builder: (context) {
        return Container(
          color: Colors.black.withOpacity(.1),
          alignment: Alignment.topCenter,
          child: EdgeOverlay(
            title: title,
            description: description,
            overlayDuration: duration ?? EdgeAlert.LENGTH_SHORT,
            gravity: gravity ?? EdgeAlert.TOP,
            backgroundColor: backgroundColor ?? Colors.grey,
            icon: icon ?? Icons.notifications,
          ),
        );
      });

      _overlayState.insert(_overlayEntry);
    }
  }

  static dismiss() async {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    _overlayEntry.remove();
  }
}

class EdgeOverlay extends StatefulWidget {
  final String title;
  final String description;
  final int overlayDuration;
  final int gravity;
  final Color backgroundColor;
  final IconData icon;

  const EdgeOverlay({
    Key? key,
    required this.title,
    required this.description,
    required this.overlayDuration,
    required this.gravity,
    required this.backgroundColor,
    required this.icon,
  }) : super(key: key);

  @override
  _EdgeOverlayState createState() => _EdgeOverlayState();
}

class _EdgeOverlayState extends State<EdgeOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Tween<Offset> _positionTween;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));

    if (widget.gravity == 1) {
      _positionTween =
          Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero);
    } else {
      _positionTween = Tween<Offset>(
          begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0));
    }

    _positionAnimation = _positionTween.animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _controller.forward();

    listenToAnimation();
  }

  listenToAnimation() async {
    _controller.addStatusListener((listener) async {
      if (listener == AnimationStatus.completed) {
        await Future.delayed(Duration(seconds: widget.overlayDuration));
        _controller.reverse();
        await Future.delayed(const Duration(milliseconds: 700));
        OverlayView.dismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final double statusBarHeight = MediaQuery.of(context).padding.top;
    // final double bottomHeight = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [
        Positioned(
          top: widget.gravity == 1 ? 50 : null,
          bottom: widget.gravity == 2 ? 0 : null,
          right: 20,
          left: 20,
          child: SlideTransition(
            position: _positionAnimation,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                // padding: EdgeInsets.all(10),
                padding: const EdgeInsets.fromLTRB(0.2, 0.2, 0.2, 5),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  border: Border.all(
                    color: widget.backgroundColor,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: OverlayWidget(
                    title: widget.title,
                    description: widget.description,
                    iconData: widget.icon,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OverlayWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData iconData;

  const OverlayWidget(
      {Key? key,
      this.title = "",
      this.description = "",
      required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      elevation: 5,
      child: Row(
        children: <Widget>[
          AnimatedIcon(
            iconData: iconData,
          ),
          const Padding(padding: const EdgeInsets.only(right: 15)),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              title.isEmpty
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        title,
                        style:
                            const TextStyle(color: primaryColor, fontSize: 22),
                      ),
                    ),
              description.isEmpty
                  ? Container()
                  : Text(
                      description,
                      style: const TextStyle(color: primaryColor, fontSize: 14),
                    )
            ],
          )),
        ],
      ),
    );
  }
}

class AnimatedIcon extends StatefulWidget {
  final IconData iconData;

  AnimatedIcon({required this.iconData});

  @override
  _AnimatedIconState createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<AnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        lowerBound: 0.8,
        upperBound: 1.1,
        duration: const Duration(milliseconds: 600));

    _controller.forward();
    listenToAnimation();
  }

  listenToAnimation() async {
    _controller.addStatusListener((listener) async {
      if (listener == AnimationStatus.completed) {
        _controller.reverse();
      }
      if (listener == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedBuilder(
        animation: _controller,
        child: Icon(
          widget.iconData,
          size: 30,
          color: textColor300,
        ),
        builder: (context, widget) =>
            Transform.scale(scale: _controller.value, child: widget),
      ),
    );
  }
}
