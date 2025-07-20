enum Materials { qum, sement, shagal, ohak, gisht }

extension MaterialX on Materials {
  String get toPretty {
    switch (this) {
      case Materials.gisht:
        return "G'isht";
      case Materials.qum:
        return "Qum";
      case Materials.sement:
        return "Sement";
      case Materials.shagal:
        return "Shag'al";
      case Materials.ohak:
        return "Ohak";
    }
  }
}
