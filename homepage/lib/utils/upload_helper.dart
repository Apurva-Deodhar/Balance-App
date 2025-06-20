import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class UploadHelper {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // ✅ Helper to add optional metadata (new)
  static SettableMetadata _getMetadata({required String contentType}) {
    return SettableMetadata(contentType: contentType);
  }

  // Upload image
  static Future<String?> uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);

      // ✅ Optional: Check file size (e.g., limit to 5MB)
      final int fileSize = await imageFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        print("Image file is too large (limit 5MB)");
        return null;
      }

      final String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';

      try {
        final UploadTask uploadTask = _storage
            .ref(fileName)
            .putFile(imageFile, _getMetadata(contentType: 'image/jpeg'));

        final TaskSnapshot snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      } catch (e) {
        print("Error uploading image: $e");
        return null;
      }
    }
    return null;
  }

  // Upload audio
  static Future<String?> uploadAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      final File audioFile = File(result.files.single.path!);

      // ✅ Optional: Check file size (e.g., limit to 10MB)
      final int fileSize = await audioFile.length();
      if (fileSize > 10 * 1024 * 1024) {
        print("Audio file is too large (limit 10MB)");
        return null;
      }

      final String fileName = 'audio/${DateTime.now().millisecondsSinceEpoch}.mp3';

      try {
        final UploadTask uploadTask = _storage
            .ref(fileName)
            .putFile(audioFile, _getMetadata(contentType: 'audio/mpeg'));

        final TaskSnapshot snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      } catch (e) {
        print("Error uploading audio: $e");
        return null;
      }
    }
    return null;
  }
}
