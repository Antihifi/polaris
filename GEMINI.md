# GEMINI.md

This document provides a comprehensive overview of the Polaris project, intended to be used as a primary source of context for development.

## Project Overview

**Polaris** is an arctic survival RTS/colony-sim game built with the **Godot Engine (v4.5)**. Inspired by historical events like the Franklin and Scott expeditions, the game challenges players to manage a group of 30-45 icebound survivors for a year until rescue arrives.

The core gameplay revolves around:
*   **Desperate Survival:** Managing scarce resources (food, fuel), and the deteriorating physical and mental states of the survivors.
*   **Human Drama:** Dealing with interpersonal conflicts, mental breakdowns, and the potential for cannibalism.
*   **Impossible Choices:** Making difficult decisions that will determine the fate of the crew.

The game is set on a procedurally generated arctic island, featuring a full day/night cycle, seasonal changes, and harsh weather conditions.

### Key Technologies & Architecture

*   **Engine:** Godot 4.5
*   **Primary Language:** GDScript, with some C# components.
*   **Terrain:** `Terrain3D` addon for procedural generation of the arctic landscape.
*   **AI:** `LimboAI` for creating behavior trees for the non-player-controlled "Men".
*   **Core Systems:** A collection of autoloaded GDScript singletons manage game state, time, selection, sound, and more.
*   **UI:** The UI is built using Godot's built-in UI system.
*   **Version Control:** Git

## Building and Running

As a Godot project, there is no traditional "build" step required for development. To run the project:

1.  **Open the project in the Godot Editor:**
    *   Ensure you have Godot 4.5 or a compatible version.
    *   Open the Godot Project Manager.
    *   Click "Import" and select the `project.godot` file in the root of this repository.

2.  **Run the game:**
    *   Once the project is open in the editor, you can run the main scene by:
        *   Pressing the **F5** key.
        *   Clicking the "Play" button in the top-right corner of the editor.

The main scene is `main.tscn`.

### Testing & Debugging

The project includes several in-game debug keybindings for testing purposes:

*   **F4:** Spawn one officer at the camera's focus point.
*   **F5:** Spawn 10 more survivors.
*   **F6:** Spawn 30 more survivors.
*   **F7:** Print a summary of all survivors to the console.
*   **F8:** Despawn all survivors.

Godot logs can be found at: `/mnt/c/Users/antih/AppData/Roaming/Godot/app_userdata/Polaris/logs/godot.log`

## Development Conventions

The project follows a set of conventions to maintain code quality and consistency.

### Code Style

*   **Static Typing:** All GDScript code should use static typing (e.g., `var my_variable: int = 10`).
*   **Composition over Inheritance:** Prefer using child node components to add behavior rather than creating complex inheritance chains.
*   **Signal-Based Communication:** Use signals to communicate between different parts of the game, avoiding direct node references where possible.
*   **Descriptive Naming:** Use clear and descriptive names for variables, functions, and nodes.

### Project Structure

The project is organized into the following key directories:

*   `src/`: Contains the core game logic, organized into subdirectories for different systems (camera, characters, control, etc.).
*   `ai/`: Contains the LimboAI behavior trees and related scripts.
*   `scenes/`: Contains the game's main scenes and test scenes.
*   `ui/`: Contains the UI scenes and scripts.
*   `addons/`: Contains third-party plugins and tools.
*   `docs/`: Contains design documents and other documentation.

### Version Control

*   **Testing Before Committing:** Never commit changes without first testing them to ensure they don't break the game.
*   **CLAUDE.md:** This file, and others like it in subdirectories, contains important context and guidance. Refer to them when working on different parts of the project.
