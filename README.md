# Space Rocks

## Overview

Space Rocks is an arcade-style shooter game where the player controls a spaceship, navigating through an asteroid field and battling enemy saucers. The objective is to survive as long as possible, destroy rocks and enemies, and achieve a high score.

## How to Play

### Starting the Game

- Launch the game.
- You will be presented with a "Get Ready!" message.
- The game will begin, or you can press the "Start" button on the HUD if visible.
- Press 'P' to pause/unpause the game. If paused at the start screen, pressing 'P' will also start the game.

### Controls

The player spaceship can be controlled using the keyboard:

- **Thrust:** `W` or `Up Arrow` - Propels the ship forward.
- **Rotate Left:** `A` or `Left Arrow` - Rotates the ship counter-clockwise.
- **Rotate Right:** `D` or `Right Arrow` - Rotates the ship clockwise.
- **Shoot:** `Spacebar` - Fires a laser from the ship's muzzle.

### Gameplay

- **Objective:** Survive by avoiding collisions with rocks and enemy bullets, and destroy them to score points.
- **Lives:** The player starts with 3 lives. Losing all lives results in a "Game Over".
- **Shield:** The player ship has a shield that absorbs damage.
  - The shield regenerates over time.
  - If the shield depletes completely, the player loses a life.
  - The shield bar is displayed on the HUD and changes color (green, yellow, red) based on its strength.
- **Scoring:**
  - Points are awarded for destroying rocks. Larger rocks give more points.
  - Destroying smaller rock fragments that break off from larger ones also awards points.
- **Levels (Waves):**
  - The game progresses in waves or levels.
  - Clearing all rocks on the screen advances the player to the next level.
  - Each new level increases in difficulty, typically by spawning more rocks or enemies.
  - A "Wave X" message is displayed at the start of each new level.
- **Enemies:**
  - Enemy saucers will appear periodically.
  - They move along predefined paths and shoot at the player.
  - Destroying enemy saucers also contributes to the score (details not explicitly found in provided files, but typical for such games).
  - Enemy bullets will damage the player's shield.
- **Rocks:**
  - Rocks of various sizes will appear on the screen.
  - Shooting a large rock will break it into smaller pieces.
  - Colliding with a rock will damage the player's shield significantly (damage is proportional to rock size).
- **Screen Wrap:** The spaceship and other game objects wrap around the screen. If you fly off one edge, you will reappear on the opposite edge.
- **Game Over:**
  - When all lives are lost, the "Game Over" message is displayed.
  - The player can then start a new game.

### HUD (Heads-Up Display)

The HUD displays important game information:

- **Score:** Your current score.
- **Lives:** Represented by small player ship icons. Shows how many lives you have remaining.
- **Shield Bar:** A visual representation of your ship's shield strength.
- **Messages:** Displays game messages like "Get Ready!", "Wave X", "Game Over", and "Paused".
- **Level:** Displays the current level/wave number.
- **High Score:** Displays the highest score achieved (this functionality might be present based on `ui.tscn`).

## Game Mechanics (from code analysis)

- **Player States:** The player ship can be in different states: `INIT` (initializing), `ALIVE`, `INVULNERABLE` (after losing a life, for a short period), and `DEAD`.
- **Invulnerability:** After losing a life and respawning, the player is temporarily invulnerable and cannot be damaged. The ship will appear semi-transparent during this time. Shooting is disabled during invulnerability.
- **Shooting:** There's a cooldown period between shots (fire rate).
- **Enemy Behavior:**
  - Enemies follow predefined paths.
  - They have a gun cooldown and can shoot single bullets or a pulse of multiple bullets.
  - Enemies have health and will flash when hit. They explode when their health reaches zero.
  - Enemies will also explode if they collide with the player or (presumably) large rocks.
- **Rock Spawning:** Rocks spawn at random positions, often along a predefined path on the screen edges.
- **Sound Effects:** The game includes sounds for shooting, explosions, engine thrust, and level-ups.
- **Music:** Background music plays during gameplay.

## Files of Interest (for developers/modders)

- `player.gd`: Contains the logic for the player ship, including movement, shooting, shield, and lives.
- `enemy.gd`: Contains the logic for enemy saucers, including movement, shooting, and health.
- `rock.gd`: Contains the logic for asteroids, including breaking into smaller pieces and explosion.
- `main.gd`: Manages the overall game flow, including starting new games, spawning rocks and enemies, and handling levels.
- `hud.gd`: Manages the Heads-Up Display elements.
- `project.godot`: Godot engine project file, contains input mappings for controls.
- `*.tscn` files: Godot scene files that define the structure and properties of game objects and UI elements.

This README provides a comprehensive guide based on the analyzed game files. Enjoy playing Space Rocks!
