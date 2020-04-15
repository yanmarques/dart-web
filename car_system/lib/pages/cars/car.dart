class Car {
  static const String DEFAULT_IMAGE_URL = 'https://image.shutterstock.com/image-vector/unknown-file-icon-vector-graphics-260nw-1658935648.jpg';
  static const String DEFAULT_NAME = 'Sem nome';
  static const String DEFAULT_TYPE = 'Sem tipo';
  static const String DEFAULT_DESCRIPTION = 'Sem descrição';


  final int id;
  final String name;
  final String type;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final String latitude;
  final String longitude;

  Car(
      this.id,
      this.name,
      this.type,
      this.description,
      this.imageUrl,
      this.videoUrl,
      this.latitude,
      this.longitude);

  static Car fromMap(Map<String, dynamic> data) => Car(
      data['id'],
      data['nome'] ?? DEFAULT_NAME,
      data['tipo'] ?? DEFAULT_TYPE,
      data['descricao'] ?? DEFAULT_DESCRIPTION,
      data['urlFoto'] ?? DEFAULT_IMAGE_URL,
      data['urlVideo'],
      data['latitude'],
      data['longitude']
  );
}