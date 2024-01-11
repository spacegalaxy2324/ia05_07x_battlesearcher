import 'package:flutter/material.dart';

class BattleStatusStyle {
  final Color backgroundColorStart;
  final Color backgroundColorEnd;
  final Icon statusIcon;

  const BattleStatusStyle({
    required this.backgroundColorStart,
    required this.backgroundColorEnd,
    required this.statusIcon,
  });
}

BattleStatusStyle getBSS(int statusValue) {
  switch (statusValue) {
    case 0:
      //pending
      return const BattleStatusStyle(
          backgroundColorStart: Color(0xFF006a6a),
          backgroundColorEnd: Color(0xFFcaf2b2),
          statusIcon: Icon(Icons.pending_actions));
    case 1:
      //in progress
      return const BattleStatusStyle(
          backgroundColorStart: Color(0xFF00476A),
          backgroundColorEnd: Color(0xFFB2E2F2),
          statusIcon: Icon(Icons.watch_later_outlined));
    case 2:
      //won local
      return const BattleStatusStyle(
          backgroundColorStart: Color(0xFF006A0E),
          backgroundColorEnd: Color(0xFFE0F2B2),
          statusIcon: Icon(Icons.check_circle));
    case 3:
      //won visitant
      return const BattleStatusStyle(
          backgroundColorStart: Color(0xFF6A0700),
          backgroundColorEnd: Color(0xFFF2CEB2),
          statusIcon: Icon(Icons.cancel));
    case 4:
      //cancelled
      return const BattleStatusStyle(
          backgroundColorStart: Color(0xFF383838),
          backgroundColorEnd: Color(0xFFA6A6A6),
          statusIcon: Icon(Icons.undo));
    default:
      return const BattleStatusStyle(
          backgroundColorStart: Color.fromARGB(255, 255, 0, 0),
          backgroundColorEnd: Color.fromARGB(255, 255, 0, 0),
          statusIcon: Icon(Icons.pending_actions));
  }
}
