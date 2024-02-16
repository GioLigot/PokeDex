class Pokemon{
  int? id;
  String name;
  String type;
  String description;

  Pokemon(
        {
          this.id,
          required this.name,
          required this.type,
          required this.description,

        }

      );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
    };

}
}
