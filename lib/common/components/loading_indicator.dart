import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key, this.bgColor}) : super(key: key);
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        color: bgColor ?? Colors.white,
        radius: 12,
      ),
    );
  }
}

// class LoadingIndicator extends StatelessWidget {
//   const LoadingIndicator({Key? key, this.bgColor}) : super(key: key);
//   final Color? bgColor;
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: Platform.isAndroid
//             ? CupertinoActivityIndicator(
//           color: Colors.white,
//           radius: 12,
//         )
//             : SizedBox(
//           height: 30,
//           width: 30,
//           child: CircularProgressIndicator(
//             backgroundColor: bgColor ?? AppColors.grey,
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//           ),
//         ));
//   }
// }
