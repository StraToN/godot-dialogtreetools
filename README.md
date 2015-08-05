# godot-dialogtreetools

!!! CURRENTLY, NO SAVING !!!

Tool for creating dialog trees for Adventure or RPG games in the form of a Graph.
Made using Godot Engine.


##Objectives

This project aims at providing a tool helping the creation of scripts defining the behaviour of NPC in adventure games (Point'n'click style) or RPGs. A dialog tree produced by this tool will be ouput a Resource file (JSON). Then a given script will have to be attached to every NPC node in Godot Engine, and take as parameter the corresponding Resource file. This way, the user only has to create his Dialog Tree, attach it, and watch.

##Features

This tool was developed after observing old LucasArts dialog systems in-game, and aims at reproducing it. Thus, it features:
- NPC sayings (one NPC or more in one Dialog Tree)
- Character sayings, choices and options.
- Variables settings
- Simple tests
- Animations during and between sayings
- Looping/Recurring sayings
- Replacement sayings (example : https://www.youtube.com/watch?v=v8eNzUtCVlY&t=1116s at 18:36)

##Future

The same style of Tree creation will be used to create scenario, use of objects with others, etc.
