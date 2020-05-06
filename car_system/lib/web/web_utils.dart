import 'dart:async';

import 'dart:html';

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
  String name;
  String mimeType;
  String base64;

  InMemoryFile(this.name, this.mimeType, this.base64);

  InMemoryFile.fromReaderResult(String name, Object result) {
    String text = result;
    this.name = name;
    this.base64 = text.substring(text.indexOf(',') + 1);
    this.mimeType = text.substring(text.indexOf(':') + 1, text.indexOf(';'));
  }
}

class FileState {
  InMemoryFile file;
}

class StreamedFileChooser {
  final StreamController<FileState> _controller = StreamController<FileState>();

  FileState _state = FileState();
  Function(FileState) _listener;

  StreamedFileChooser(Function(FileState) listener) {
    _listener = listener;
    _controller.stream.listen(listener);
  }

  void choose() {
    InputElement input = FileUploadInputElement();
    input.click();

    input.onChange.listen((event) {
      List<File> files = input.files;
      if (files.length > 0) {
        File fileToUpload = files.first;
        print('file to upload: $fileToUpload');
        // we started to read the file from filesystem
        _update();

        final reader = new FileReader();
        reader.onLoad.listen((event) {
          _state.file = InMemoryFile.fromReaderResult(fileToUpload.name, reader.result);

          // now we have the file in memory
          _update();

          // regenerate state
          _state = FileState();
        });

        reader.readAsDataUrl(fileToUpload);
      }
    });
  }

  _update() {
    _controller.add(_state);
  }
}