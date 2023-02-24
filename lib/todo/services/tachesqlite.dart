class TacheSqlite {
  final int id;
  final String titre;
  final String description;

  TacheSqlite({
    this.id=0,
    this.titre = '',
   required this.description,
  });



  
  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
    };
  }

  factory TacheSqlite.fromMap(Map<String, dynamic> map) {
    return TacheSqlite(
      id:map['id'] ?? 0,
      titre: map['titre'] ?? '',
      description: map['description'] ?? '',
    );
  }
}