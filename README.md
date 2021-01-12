[![Pub Package](https://img.shields.io/pub/v/web_node.svg)](https://pub.dartlang.org/packages/web_node)
[![Github Actions CI](https://github.com/dint-dev/web_node/workflows/Dart%20CI/badge.svg)](https://github.com/dint-dev/web_node/actions?query=workflow%3A%22Dart+CI%22)

# Overview
A cross-platform package for displaying DOM trees in Flutter applications.

If you are looking for a web browser widget (with navigation buttons), try our sibling package
[web_browser](https://pub.dev/packages/web_browser).

Licensed under the [Apache License 2.0](LICENSE).

## Links
  * [Github project](https://github.com/dint-dev/web_node)
  * [Issue tracker](https://github.com/dint-dev/web_node/issues)
  * [API Reference](https://pub.dev/documentation/web_node/latest/index.html)

## Behavior
### In browsers
  * Uses real DOM nodes.
  * For details, you can study the source code:
    * [web_node_impl_browser.dart](https://github.com/dint-dev/web_node/blob/master/lib/src/web_node_impl_browser.dart)

### In Android and iOS
  * Serializes the DOM tree to HTML source code. Passes some of the surrounding style (background
    color, font family, etc.) DOM tree.
  * Uses [webview_flutter](https://pub.dev/packages/webview_flutter), a package maintained by
    Google, for showing the serialized DOM tree.
  * For details, you can study the source code:
    * [dom_tree_serializer.dart](https://github.com/dint-dev/web_node/blob/master/lib/src/dom_tree_serializer.dart)
    * [web_node_impl_not_browser.dart](https://github.com/dint-dev/web_node/blob/master/lib/src/web_node_impl_not_browser.dart)

## Known issues
  * Flutter for Web suffers from flickering in browsers ([Flutter issue #51865](https://github.com/flutter/flutter/issues/51865))

# Getting started
## 1.Setup
In _pubspec.yaml_:
```yaml
dependencies:
  universal_html: ^1.2.3
  web_node: ^0.1.0
```

## 2.Display DOM nodes
```dart
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' show html;
import 'package:web_node/web_node.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: WebNode(node: exampleDomTree()),
      ),
    ),
  ));
}


// Constructs:
//     <div>
//       <h1>Dart website</h1>
//       <iframe src="https://dart.dev">
//     </div>
html.Node exampleDomTree() {
  final h1 = html.HeadingElement.h1();
  h1.appendText('Dart website');

  final iframe = html.IFrameElement();
  iframe.src = 'https://dart.dev/';

  final div = html.DivElement()
  ..append(h1);
  ..append(iframe);

  return div;
}
```