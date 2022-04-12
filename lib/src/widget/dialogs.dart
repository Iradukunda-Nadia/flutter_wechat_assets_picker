import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/cupertino.dart';

class Dialogs {
  Future<void> showLoadingDialog(
      BuildContext cxt, GlobalKey key, PMProgressHandler? _progressHandler) async {
    _progressHandler!.stream.listen((PMProgressState s) {});
    return showDialog<void>(
        context: cxt,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return  WillPopScope(
              onWillPop: () async => false,
              child: CupertinoAlertDialog(
                  key: key,
                  title: const Text('Downloading from iCloud',),
                  content: Center(
                    child: Column(children:  [
                      const SizedBox(height: 10,),
                      const CircularProgressIndicator(
                        strokeWidth: 0.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue
                        ),
                      ),
                      const SizedBox(height: 10,),
                      StreamBuilder<PMProgressState>(
                        stream: _progressHandler.stream,
                        initialData: PMProgressState(0, PMRequestState.prepare),
                        builder: (BuildContext c, AsyncSnapshot<PMProgressState> s) {
                          if (s.hasData) {
                            print(s.data);
                            final double progress = s.data!.progress;
                            final PMRequestState state = s.data!.state;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (state != PMRequestState.success &&
                                    state != PMRequestState.failed)
                                  Text(
                                    '   ${(progress * 100).toInt()}%',
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                              ],
                            );
                          }
                          return  const SizedBox.shrink();
                        },
                      ),
                    ]),
                  ),

                  actions: <Widget>[
                    CupertinoDialogAction(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.of(cxt).pop();
                  },),]
              ));
        });
  }

}
