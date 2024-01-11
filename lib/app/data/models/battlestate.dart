class BattleState {
  const BattleState(this.id, this.name);

  final String name;
  final int id;
}

List<BattleState> battleStates = <BattleState>[
  const BattleState(0, "Pending"),
  const BattleState(1, "In progress"),
  const BattleState(2, "Won"),
  const BattleState(3, "Lost"),
  const BattleState(4, "Cancelled")
];
