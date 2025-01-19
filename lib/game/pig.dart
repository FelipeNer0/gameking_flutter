import 'package:bonfire/bonfire.dart';
import 'package:flutter/widgets.dart';
import 'package:game_king/main.dart';
import 'package:game_king/utils/pig_spritesheet.dart';

class Pig extends PlatformEnemy with HandleForces, UseLifeBar {
  Pig({
    required super.position,
  }) : super(
          size: Vector2(34,28),
          animation: PigSpritesheet.animations,
          speed: 40,
        ){
          setupLifeBar(
            borderRadius: BorderRadius.circular(50),
            barLifeDrawPosition: BarLifeDrawPosition.bottom,
            offset: Vector2(3, 1)
          );
        }
        
  @override
  void update(double dt) {
    if(!isDead){       
      seeAndMoveToPlayer(
        movementAxis: MovementAxis.horizontal,
        radiusVision: Game.tileSize * 2,
      );
    }
    super.update(dt);
  }

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2.all(14),
        position: Vector2(7, 14),    
      ),
    );
    return super.onLoad();
  }

  @override
  void onReceiveDamage(AttackOriginEnum attacker, double damage, identify) {
    animation?.playOnceOther(
      'hit',
      runToTheEnd: true,
      useCompFlip: true,
    );
    super.onReceiveDamage(attacker, damage, identify);
  }

  @override
  void onDie() {    
    super.onDie();
    stopMove();
    animation?.playOnceOther(
      'dead',
      runToTheEnd: true,
      useCompFlip: true,
      onFinish: removeFromParent,
    );
  }
}