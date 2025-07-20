enum Stage { initial, selectedLocation, third, fourth, fifth,sixth }

extension StageX on Stage {
  bool get isInitial => this == Stage.initial;

  bool get isSelectedLocation => this == Stage.selectedLocation;

  bool get isThird => this == Stage.third;

  bool get isFourth => this == Stage.fourth;

  bool get isFifth => this == Stage.fifth;

  bool get isSixth => this == Stage.fifth;

  bool operator >(Stage other) {
    final curIndex = Stage.values.indexOf(this);
    final otherIndex = Stage.values.indexOf(other);
    return curIndex > otherIndex;
  }

  bool operator <(Stage other) {
    final curIndex = Stage.values.indexOf(this);
    final otherIndex = Stage.values.indexOf(other);
    return curIndex < otherIndex;
  }

  bool operator <=(Stage other) {
    final curIndex = Stage.values.indexOf(this);
    final otherIndex = Stage.values.indexOf(other);
    return curIndex <= otherIndex;
  }

  bool operator >=(Stage other) {
    final curIndex = Stage.values.indexOf(this);
    final otherIndex = Stage.values.indexOf(other);

    return curIndex >= otherIndex;
  }
}
