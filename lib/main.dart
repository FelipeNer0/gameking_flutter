import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:game_king/game/king.dart';
import 'package:game_king/game/pig.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Game(),
    );
  }
}

class Game extends StatelessWidget {

  static const tileSize = 32.0;
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BonfireWidget(
        map: WorldMapByTiled
          (WorldMapReader.fromAsset('map/map.tmj'),
          objectsBuilder: {
            'pig': (properties) => Pig(
              position: properties.position,
            ),
          },
        ),
        playerControllers: [
          Keyboard(),
          Joystick(
            directional: JoystickDirectional(),
            actions: [
              JoystickAction(
                actionId: 1                
              ),
              JoystickAction(
                actionId: 2,
                margin: const EdgeInsets.only(bottom: 50, right: 120),
                color: Colors.red,
              )
            ],            
          ),
        ],
        //showCollisionArea: true,
        player: King(
          position: Vector2(tileSize * 3,5 * tileSize),
          ),
        cameraConfig: CameraConfig(
          zoom: getZoomFromMaxVisibleTile(context, tileSize, 15)
        ),
        backgroundColor: const Color(0xFF3f3851),
        globalForces: [
          GravityForce2D(),          
        ],
        //showCollisionArea: true,       
      ),
    );
  }
}
