import 'package:codereader/widgets/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:codereader/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Card Single Test", () {
    testWidgets("Card Single Test", (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      var cameraCards = find.byKey(new Key("camera_card"));
      expect(cameraCards,findsOneWidget);

      var galleryCards = find.byKey(new Key("gallery_card"));
      expect(galleryCards, findsOneWidget);
      
      Finder getButton(Finder finder){
        return find.descendant(of: finder, matching: find.text("開く"));
      }
      expect(getButton(cameraCards), findsOneWidget);
      expect(getButton(galleryCards), findsOneWidget);
      
      
    });
  });
}
