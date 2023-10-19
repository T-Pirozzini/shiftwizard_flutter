import 'package:flame/cache.dart';
import 'package:flame/components.dart';

Future<List<Sprite>> loadSprites(
    Images images, String imagePath, List<Vector2> positions, Vector2 srcSize) async {
  final image = await images.load(imagePath);
  return positions
      .map((position) => Sprite(image, srcPosition: position, srcSize: srcSize))
      .toList();
}
