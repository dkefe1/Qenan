import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Future<File> urlToFile(String imageUrl) async {
  // Download image
  final response = await http.get(Uri.parse(imageUrl));

  // Get the temporary directory of the device
  final documentDirectory = await getApplicationDocumentsDirectory();

  // Create a file instance in the temp directory with a unique name
  final file = File(join(
      documentDirectory.path, '${DateTime.now().millisecondsSinceEpoch}.png'));

  // Write the data from the response to the file
  file.writeAsBytesSync(response.bodyBytes);

  return file;
}
