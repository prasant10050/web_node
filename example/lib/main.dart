import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:web_node/web_node.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Example',
      home: Scaffold(
        body: SafeArea(
          child: WebNode(
            node: html.DivElement()
              ..style.textAlign = 'center'
              ..append(
                html.HeadingElement.h1()..appendText('Hello world!'),
              )
              ..append(html.AnchorElement()
                ..href = 'https://dart.dev/'
                ..appendText('A link to dart.dev')),
          ),
        ),
      ),
    ),
  );
}
