tamanho(double tamanho, {double minimo = 10, double maximo = 22}) {
  if(tamanho < minimo) {
    return minimo;
  }
  if(tamanho > maximo) {
    return maximo;
  }
  return tamanho;
}

class InMemoryFile {
  final String name;
  final String mimeType;
  final String base64;

  InMemoryFile(this.name, this.mimeType, this.base64);
}