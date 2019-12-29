import 'dart:async';

import 'package:disease_app/ui/models/news.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsViewer extends StatefulWidget {
  const NewsViewer({
    Key key,
    @required this.siteList,
    @required this.query,
  }) : super(key: key);

  final String query;
  final List<NewsQuery> siteList;

  @override
  State<StatefulWidget> createState() => NewsViewerState();
}

class NewsViewerState extends State<NewsViewer> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  int _currentArticle = 0;
  int _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.query + " News"),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          NavigationControls(_controller.future),
        ],
      ),
      bottomNavigationBar: bottomBar(),
      body: IndexedStack(
        index: _stackToView,
        children: <Widget>[
          WebView(
            initialUrl: widget.siteList[0].url,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: _handleLoad,
          ),
          Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomBar() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder:
            (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
          final bool webViewReady =
              snapshot.connectionState == ConnectionState.done;
          final WebViewController controller = snapshot.data;
          return BottomAppBar(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: CupertinoButton(
                    child: Text(
                      "PREVIOUS ARTICLE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    onPressed: !webViewReady
                        ? null
                        : () {
                            if (_currentArticle == 0) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text("No previous article")),
                              );
                              return;
                            }
                            _currentArticle--;
                            setState(() {
                              _stackToView = 1;
                            });
                            controller
                                .loadUrl(widget.siteList[_currentArticle].url);
                          },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: CupertinoButton(
                    child: Text(
                      "NEXT ARTICLE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    onPressed: !webViewReady
                        ? null
                        : () {
                            if (_currentArticle == widget.siteList.length) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text("No next article")),
                              );
                              return;
                            }
                            _currentArticle++;
                            setState(() {
                              _stackToView = 1;
                            });
                            controller
                                .loadUrl(widget.siteList[_currentArticle].url);
                          },
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () => navigate(context, controller, goBack: true),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () => navigate(context, controller, goBack: false),
            ),
          ],
        );
      },
    );
  }

  navigate(BuildContext context, WebViewController controller,
      {bool goBack: false}) async {
    bool canNavigate =
        goBack ? await controller.canGoBack() : await controller.canGoForward();
    if (canNavigate) {
      goBack ? controller.goBack() : controller.goForward();
    } else {
      //Display to the user that there is no more history in that arrow direction
      Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Text("No ${goBack ? 'back' : 'forward'} history item")),
      );
    }
  }
}