import 'package:encrypt/encrypt.dart';
import 'package:scuffed_wordle/data/constants.dart';

class EncryptingService {
  final Encrypter _encrypter = Encrypter(AES(Constants.key32));

  EncryptingService();

  String encrypt(String plainText) {
    return _encrypter.encrypt(plainText, iv: Constants.iv).base64;
  }

  String decrypt(String base64) {
    return _encrypter.decrypt64(base64, iv: Constants.iv);
  }
}
