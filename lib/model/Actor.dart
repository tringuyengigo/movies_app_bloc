
import 'package:movies_app_bloc/util/Utils.dart';

class Actor {
  String character;
  String name;
  String profilePicture;
  int id;

  get profilePictureUrl =>
      getMediumPictureUrl((profilePicture != null ? profilePicture : ""));

  Actor.fromJson(Map jsonMap)
      : character = jsonMap['character'],
        name = jsonMap['name'],
        profilePicture = jsonMap['profile_path'],
        id = jsonMap['id'];
}
