enum Units { m3, m2, kg, dona }

extension UnitsX on Units {
  String get toPretty {
    switch (this) {
      case Units.m3:
        return 'm\u00B3';
      case Units.m2:
        return 'm\u00B2';

      case Units.kg:
        return 'kg';
      case Units.dona:
        return 'dona';
    }
  }
}