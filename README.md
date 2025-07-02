# Pattern-based Level Generator

This is an **_unfinished project_** for a random level generator based on tile map patterns.

## How it works

Godot Engine 4 has a [TileMapPattern](https://docs.godotengine.org/en/stable/classes/class_tilemappattern.html) class that can store a fragment of a [TileMapLayer](https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html#class-tilemaplayer). A pattern can be saved and inserted into another tile map layer. This functionality is used to create binary files (_multiple patterns are saved into a single file using the_ [PackedDataContainer](https://docs.godotengine.org/en/stable/classes/class_packeddatacontainer.html) _class_) that contain a set of pattern data. All patterns are divided into chunks of equal size. To generate a game level using the saved patterns, the generator loads them from the binary file into an array and randomly selects patterns from it. Each pattern is inserted into a designated chunk (_the pattern size must match the chunk size_).

> [!IMPORTANT]  
> Patterns and the tile map layer of a game level must use the same [TileSet](https://docs.godotengine.org/en/stable/classes/class_tileset.html) to avoid unpredictable behavior.

## Problem

This approach to random level generation was intended for use in compact game levels (_an example can be seen in the demo scene_), where the player must defend against waves of enemies. However, testing revealed that such levels are unplayable and less engaging compared to hand-crafted levels. Moreover, maintaining balanced difficulty across levels is challenging.

A possible solution to this problem is to develop functionality that evaluates how well patterns in neighboring chunks fit together. However, the feasibility of such development for small game levels remains questionable.
