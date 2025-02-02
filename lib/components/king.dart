import 'package:bonfire/bonfire.dart';
import 'package:bonfire_bloc/bonfire_bloc.dart';
import 'package:flutter/services.dart';
import 'package:game_king/controllers/map_controller_cubit.dart';
import 'package:game_king/utils/king_spritesheet.dart';

import '../utils/dust_particle_builder.dart';
import '../utils/sound_manager.dart';
import 'door.dart';

final SoundManager _soundManager = SoundManager();


class King extends PlatformPlayer
    with HandleForces, BonfireBlocReader<MapControllerCubit> {
  bool moveEnabled = true;
  Door? doorInContacting;
  final bool animatedDoorOut;
  King({
    required super.position,
    this.animatedDoorOut = false,
    double currentLife = 3,
  }) : super(
          size: Vector2(78, 58),
          animation: KingSpritesheet.animations,
          life: 3,
        ) {
    updateLife(currentLife);
    mass = 2;
    opacity = animatedDoorOut ? 0 : 1;
    handleForcesEnabled = false;
    moveEnabled = false;
  }

  @override
  void onJoystickAction(JoystickActionEvent event) {
    if (moveEnabled) {
      if (event.event == ActionEvent.DOWN &&
          (event.id == 1 || event.id == LogicalKeyboardKey.space)) {
        jump(jumpSpeed: 210);
        _soundManager.setVolume(0.2);
        _soundManager.playSound('jump.mp3');
      }

      if (event.event == ActionEvent.DOWN &&
          (event.id == 2 || event.id == LogicalKeyboardKey.keyZ)) {
        _execAttack();
      }
    }
    super.onJoystickAction(event);
  }

  @override
  void onJoystickChangeDirectional(JoystickDirectionalEvent event) {
    if (moveEnabled) {
      if (event.directional == JoystickMoveDirectional.MOVE_UP &&
          doorInContacting != null) {
        _enterDoor(doorInContacting!);
      }

      super.onJoystickChangeDirectional(event);
    }
  }

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2.all(15),
        position: Vector2(31, 29),
      ),
    );
    return super.onLoad();
  }

  @override
  void onMove(
    double speed,
    Vector2 displacement,
    Direction direction,
    double angle,
  ) {
    if (direction.isHorizontal) {
      if (checkInterval('smoke_animation', 300, dtUpdate)) {
        if (direction.isRightSide) {
          showSmoke(SmokeDirection.left);
        } else {
          showSmoke(SmokeDirection.right);
        }
      }
    }
    super.onMove(speed, displacement, direction, angle);
  }

  @override
  void onJump(JumpingStateEnum state) {
    if (state == JumpingStateEnum.idle) {
      animation?.playOnceOther(
        'ground',
        runToTheEnd: true,
        useCompFlip: true,
      );     
      showSmoke(SmokeDirection.center);
      
    }
    super.onJump(state);
  }

  void _execAttack() {
    animation?.playOnceOther(
      'attack',
      runToTheEnd: true,
      useCompFlip: true,
    );
    simpleAttackMelee(
      damage: 20,
      direction: lastDirectionHorizontal,
      marginFromCenter: 15,
      size: Vector2.all(32),
    );
       _soundManager.setVolume(0.6);
     _soundManager.playSound('attack.mp3'); // Tocar som ao atacar
  }

  void showSmoke(SmokeDirection direction) {
    final x = rectCollision.center.dx;
    final y = rectCollision.bottom;
    gameRef.add(
      DustParticleBuilder().build(
        priority: priority,
        position: Vector2(x, y),
        direction: direction,
      ),
    );
  }

  @override
  void onReceiveDamage(AttackOriginEnum attacker, double damage, identify) {
    animation?.playOnceOther(
      'hit',
      runToTheEnd: true,
      useCompFlip: true,
    );
    super.onReceiveDamage(attacker, damage, identify);
     _soundManager.setVolume(0.5);
    _soundManager.playSound('ui.mp3');
  }

  @override
  void onDie() {
    moveEnabled = false;
    stopMove();
    animation?.playOnceOther(
      'dead',
      runToTheEnd: true,
      useCompFlip: true,
      onFinish: removeFromParent,
    );
    super.onDie();
  }

  void _enterDoor(Door doorInContacting) {
    moveEnabled = false;
    doorInContacting.playEnter(
      () async {
        await animation?.playOnceOther(
          'doorIn',
          onStart: () {
            _soundManager.setVolume(0.8);
            _soundManager.playSound('open-door.mp3');
          },
          onFinish: () {
            opacity = 0.0;
          },
        );
      },
    );
  }

  @override
  void onMount() {
    super.onMount();
    if (animatedDoorOut) {
      _playDoorOut();
    } else {
      _enabledForces();
    }
  }

  void _playDoorOut() async {
    await Future.delayed(const Duration(milliseconds: 100));
    doorInContacting?.playExit(
      () async {
        await animation?.playOnceOther(
          'doorOut',
          runToTheEnd: true,
          useCompFlip: true,
          onStart: () {
            _soundManager.setVolume(0.8);
            _soundManager.playSound('close-door.mp3');
            opacity = 1;
          },
          onFinish: () {
            moveEnabled = true;
            handleForcesEnabled = true;
          },
        );
      },
    );
  }

  void _enabledForces() async {
    await Future.delayed(const Duration(milliseconds: 100));
    handleForcesEnabled = true;
    moveEnabled = true;
  }

  @override
  void removeLife(double life) {
    super.removeLife(life);
    bloc.updatePlayerLife(this.life);
  }
}
