class City {
  int id;
  String name;
  String code;

  City({this.id, this.name, this.code});

  City.fromMap(Map<String, dynamic> data) {
    this.id = data['id'];
    this.name = data['name'];
    this.code = data['code'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code
    };
  }

  String toString() => 'City[id=$id name=$name code=$code]';
}