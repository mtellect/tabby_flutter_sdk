part of 'package:tabby_flutter_sdk/tabby_flutter_sdk.dart';


pushSheet(context, item,
    {result,
    onDismissed,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true}) {
  showModalBottomSheet(
    isScrollControlled: isScrollControlled,
    // backgroundColor: headerColor.withOpacity(.5),
    backgroundColor: Colors.transparent,

    isDismissible: isDismissible,
    enableDrag: enableDrag,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0.0))),
    // elevation: 5,
    builder: (context) {
      return Stack(
        children: [
          BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                color: Colors.black.withOpacity(0),
              )),
          GestureDetector(
            onTap: () {
              if (!isDismissible) return;
              Navigator.pop(context);
            },
          ),
          item
        ],
      );
    },
  ).then((_) {
    if (_ != null) {
      if (result != null) result(_);
    } else {
      if (onDismissed != null) onDismissed();
    }
  });
}

Future pushSheetRawResponse(context, item,
    {result,
      onDismissed,
      bool isScrollControlled = true,
      bool isDismissible = true,
      bool enableDrag = true}) async{
 final response=await showModalBottomSheet(
    isScrollControlled: isScrollControlled,
    // backgroundColor: headerColor.withOpacity(.5),
    backgroundColor: Colors.transparent,

    isDismissible: isDismissible,
    enableDrag: enableDrag,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0.0))),
    // elevation: 5,
    builder: (context) {
      return Stack(
        children: [
          BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                color: Colors.black.withOpacity(0),
              )),
          GestureDetector(
            onTap: () {
              if (!isDismissible) return;
              Navigator.pop(context);
            },
          ),
          item
        ],
      );
    },
  );

 return response;

}

pushAndResult(context, item,
    {result,
    opaque = false,
    bool dialog = false,
    bool replace = false,
    bool clear = false,
    bool fade = false,
    transitionBuilder,
    transitionDuration}) {
  if (dialog) {
    showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      // routeSettings: routeSettings,
      builder: (BuildContext context) {
        return item;
      },
    ).then((_) {
      if (_ == null) return;
      if (result != null) result(_);
    });
    return;
  }

  if (fade) transitionBuilder = fadeTransition;

  transitionDuration = const Duration(milliseconds: 800);

  if (clear) {
    Navigator.of(context)
        .pushAndRemoveUntil(
            PageRouteBuilder(
                transitionsBuilder: transitionBuilder ?? slideTransition,
                transitionDuration:
                    transitionDuration ?? const Duration(milliseconds: 30),
                opaque: opaque,
                pageBuilder: (BuildContext context, _, __) {
                  return item;
                }),
            (Route<dynamic> route) => false)
        .then((_) {
      if (_ != null) {
        if (result != null) result(_);
      }
    });
    return;
  }

  if (replace) {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            transitionsBuilder: transitionBuilder ?? slideTransition,
            transitionDuration:
                transitionDuration ?? const Duration(milliseconds: 30),
            opaque: opaque,
            pageBuilder: (context, _, __) {
              return item;
            })).then((_) {
      if (_ != null) {
        if (result != null) result(_);
      }
    });
    return;
  }
  Navigator.push(
      context,
      PageRouteBuilder(
          transitionsBuilder: transitionBuilder ?? slideTransition,
          transitionDuration:
              transitionDuration ?? const Duration(milliseconds: 300),
          opaque: opaque,
          pageBuilder: (context, _, __) {
            return item;
          })).then((_) {
    if (_ != null) {
      if (result != null) result(_);
    }
  });
}

Widget fadeTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

Widget slideTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  var begin = const Offset(1.0, 0.0);
  var end = Offset.zero;
  var tween = Tween(begin: begin, end: end);
  var offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

// void showProgress(BuildContext context, bool show,
//     {String msg = "", bool cancellable = true}) {
//   if (!show) {
//     progressDialogShowing = false;
//     progressController.add(false);
//     return;
//   }
//
//   progressDialogShowing = true;
//   pushAndResult(
//       context,
//       ProgressDialog(
//         message: msg,
//         cancelable: cancellable,
//       ),
//       fade: true,
//       transitionDuration: Duration(milliseconds: 800));
// }

showToast(context, String err,
    {Color backgroundColor = Colors.red, bool success = false}) {
  EdgeAlert.show(context,
      title: "",
      description: err,
      gravity: EdgeAlert.TOP,
      backgroundColor: success ? Colors.green : backgroundColor,
      icon: Icons.info_outline,
      duration: EdgeAlert.LENGTH_SHORT);
}

/*showMessageDialog(BuildContext context,
    {required String title,
    required String description,
    required String okTitle,
    String cancelText = "Cancel",
    required VoidCallback onOkClick,
    VoidCallback? onClickCancel,
    bool cancellable = false,
    int millSeconds = 500}) {
  Future.delayed(Duration(milliseconds: millSeconds), () {
    pushSheet(
        context,
        SuccessDialog(
          title: title,
          description: description,
          okText: okTitle,
          cancelText: cancelText,
          onOkClick: onOkClick,
          onClickCancel: onClickCancel,
        ),
        enableDrag: cancellable,
        isDismissible: cancellable);
  });
}*/

/*showListDialog(BuildContext context,
    {String title = "",
    required List items,
    required onItemSelected,
    bool cancellable = true,
    bool returnIndex = true,
    int millSeconds = 500}) {
  Future.delayed(Duration(milliseconds: millSeconds), () {
    pushSheet(
        context,
        ListDialog(
          title: title,
          items: items,
          returnIndex: returnIndex,
        ),
        isScrollControlled: true,
        enableDrag: cancellable,
        isDismissible: cancellable, result: (_) {
      onItemSelected(_);
    });
  });
}*/
