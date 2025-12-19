import 'package:get/get_navigation/src/root/internacionalization.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {'message': 'How are you?', 'name': 'What is your name?'},
    'ur_PK': {'message': 'آپ کیسے ہیں؟', 'name': 'آپ کا نام کیا ہے؟'},
    'hi_IN': {'message': 'आप कैसे हैं?', 'name': 'आपका क्या नाम है?'},
    'es_SP': {'message': '¿Cómo estás?', 'name': '¿Cómo te llamas?'},
  };
}
