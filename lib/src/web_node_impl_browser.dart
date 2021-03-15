// Copyright 2020 Gohilla Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:universal_html/html.dart' as html;
import 'package:web_node/web_node.dart';

class WebNodeState extends State<WebNode> {
  /// Static counter for allocating view factory IDs.
  static int _registeredViewFactoryCounter = 0;

  /// The latest node received from a widget.
  html.Element? _latestNode;

  /// HtmlElementView constructed only once.
  Widget? _htmlElementView;

  @override
  Widget build(BuildContext context) {
    var htmlElementView = _htmlElementView;
    if (htmlElementView == null) {
      final htmlViewId = 'WebNode-$_registeredViewFactoryCounter';
      _registeredViewFactoryCounter++;
      ui.platformViewRegistry.registerViewFactory(htmlViewId, (int viewId) {
        // Always returns the latest node.
        return _latestNode!;
      });
      htmlElementView = HtmlElementView(
        viewType: htmlViewId,
      );
      _htmlElementView = _htmlElementView;
    }
    return htmlElementView;
  }

  @override
  void didUpdateWidget(WebNode oldWidget) {
    _latestNode = widget.node;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _latestNode = widget.node;
    super.initState();
  }
}

class WebResourceError {}