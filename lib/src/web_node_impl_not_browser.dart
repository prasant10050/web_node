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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_node/web_node.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io' show Platform;

class WebNodeState extends State<WebNode> {
  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    final htmlSource = DomTreeSerializer(isIOS: Platform.isIOS).serialize(
      context: context,
      node: node,
      backgroundColor: widget.backgroundColor,
    );
    return WebView(
      initialUrl: Uri.dataFromString(
        htmlSource,
        mimeType: 'text/html',
      ).toString(),
    );
  }
}
