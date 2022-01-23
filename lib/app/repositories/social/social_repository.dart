import 'package:cuidaper_mobile/app/models/social_network_model.dart';

abstract class SocialRepository {
  Future<SocialNetworkModel> googleLogin();
}
