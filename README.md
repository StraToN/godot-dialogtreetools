# godot-dialogtreetools

![Preview](https://github.com/StraToN/godot-dialogtreetools/blob/master/addons/tree-tools/docs/dialogtreetools.png)

Tool for creating dialog trees for Adventure or RPG games in the form of a Graph.
Made using Godot Engine.

## Documentation

[How to use](https://github.com/StraToN/godot-dialogtreetools/wiki/How-to-use)

## Objectives

This project aims at providing a tool helping the creation of advanced trees defining the behaviour of NPC in adventure games (Point'n'click style) or RPGs.

GraphNodes provided by this tool may or may not respond to every use case. You are then required to modify existing nodes, or add new ones.

Basic usage: add the provided [TreeNode custom node](https://github.com/StraToN/godot-dialogtreetools/wiki/TreeNode-node) as a child of your target node: after creating a Resource (attach TreeNodeResource.gd file), selecting this specific node opens a GraphEditor allowing tree building. 

You have then 2 solutions for parsing:
- Either call this TreeNode's functions using get_node() in your target node's script.
- Or Export the tree to a JSON file and use this file that you can parse yourself and manage the way you like.

## Features

This tool was developed after observing old LucasArts dialog systems in-game, and aims at reproducing it. Thus, it features:
- NPC sayings (one NPC or more in one Dialog Tree)
- Character sayings, choices and options.
- Variables settings
- Simple tests
- Animations during and between sayings
- Looping/Recurring sayings
- Replacement sayings (example : https://www.youtube.com/watch?v=v8eNzUtCVlY&t=1116s at 18:36: all choices lead to the same line being actually said)

## Future

This plugin can also be used to create scenarios, objects logic, or even as a basis for interactive fictions games (such as [Lifeline](http://www.bigfishgames.com/daily/3mingames/lifeline/) for example).

## Thanks
LeeZH for the initial project, which was importantly modified since then - https://github.com/leezh/gdscript-dialogue

