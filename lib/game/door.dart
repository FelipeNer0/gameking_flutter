import 'package:bonfire/bonfire.dart';
import 'package:game_king/game/king.dart';
import 'package:game_king/utils/door_spritesheet.dart';


class Door extends GameDecoration with Sensor {
  final String targetMap;
  final Vector2 targetposition;
  Door(
      {required super.position,
      required this.targetMap,
      required this.targetposition}) 
      : super.withSprite(
          sprite: DoorSpritesheet.idle,
          size: Vector2(46, 56),   
       );

  @override
  void onContact(GameComponent component) {
    if(component is King){
      component.doorInContacting = this;
    }
    super.onContact(component);
  }

  @override
  void onContactExit(GameComponent component) {
    if(component is King){
      component.doorInContacting = null;
    }
    super.onContactExit(component);
  }

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2(16, 30),
        position: Vector2(15, 56-23),
      ),
    );
    return super.onLoad();
  }

 

  @override
  int get priority => LayerPriority.MAP;

  void playOpening() async {
    sprite = await DoorSpritesheet.idle;
    playSpriteAnimationOnce(
      DoorSpritesheet.opening,
    );
  }
}