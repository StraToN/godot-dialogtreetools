# godot-dialogtreetools

Tool for creating dialog trees for Adventure or RPG games in the form of a Graph.
Made using Godot Engine.



##Thanks
LeeZH for the initial project, which was importantly modified since then - https://github.com/leezh/gdscript-dialogue

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

##How to use

This repo basically contains 2 main scenes:
- window.scn, which is the actual tool that allows you to build Dialogue Trees
- DialogTester/test_dialog.scn, which is a test scenemade for testing dialogs.

There are 2 dialog examples in files simple.json and wally.json (in French, sorry!). wally.json is an attempt to re-create the very first dialog of The Curse of Monkey Island between Wally and Guybrush Threepwood. You can load them in the Dialog Tree editor.

### Build a Dialog Tree

Simply load the window.scn scene in Godot, and run.
There, many buttons allow you to add nodes to the current tree. A Dialog Tree begins with a Start node which is created by default. You can now add different nodes to build up the logic of your Dialog.

IMPORTANT NOTE : STARRED NODES* ARE NOT IMPLEMENTED YET IN DIALOG SCRIPT.

####General notes

The (H) button present on some nodes allow the hiding of their sub-parts, in order to save some screen space.

####Start node 

Start node. :)

####Group node*

Defines a group. Mainly used as checkpoints in the dialogs. If the dialog is interrupted and re-started, it will start from the last Group node reached.

####Variable Set* 

Node that sets a variable with a value. This allows logic in the dialogs with Condition nodes.
Boolean operators will work : not/!, and/&&, or/||, ==, !=, + - * /

####Condition*

Considering a logical expression to test a variable, the Dialog will follow in the True or False branch.

####Line (shown as Text/Animation)

Lines of dialog. Also manages animations of speech.
Lines beginning with a % will be spoken by the player character. 
You can type multiple lines in one node using the (+) button, in order to allow the speaker to speak with different speech animations (if there are). Each line in the node will be spoken one after the other.

####Random Line

Similar to Line node, but selects one line between all the lines provided. Allows a character to answer a random line. For example, if the player starts talking to an NPC (Hello!), the NPC could either answer (Hi!) or (Howdy!) or (Greetings!).

####Option* (WIP)

Options are lines to be chosen by the player (by clicking one of them at the bottom part of screen, in most games).
If mutiple Options have the same parent node, they will be displayed all together for the player to make a choice.

>Parent
>>+- Option(What's your name?)  
>>+- Option(Do you like Godot?)  
>>+- Option(Goodbye.)

If an Option follows another Option later in the sub-tree, it replaces the preceding Option when the dialog reaches it. Example:  
>Parent
>>+- Option(What's your name?)---Dialog(My name is gBot.)  
>>+- Option(Do you like Godot?)---Dialog(Sure!)---Option(How much do you like it?)---Dialog(A lot!)  
>>+- Option(Goodbye.)  

2 scenarios :  
1. If the player selects Option 1, the dialog will follow the according branch, then this branch will disappear. Options 2 and 3 are then the only ones left.  
2. If the player selects Option 2, the dialog will follow the according branch ("Sure!"), then Options available will be Option 1(What's your name?), Option 2(How much do you like it?) and Option 3.

Then again, you can switch to a whole new set of options if you add more than 1 option:
>Parent  
>>+- Option(What's your name?)---Dialog(My name is gBot.)  
>>+- Option(Let's talk about Godot.)---Dialog(Sure!)  
>>>+- Option(How much do you like it?)---Dialog(A lot!)  
>>>+- Option(Do you find it useful?)---Dialog(Yeah! It allowed me to create great games!)  

>>+- Option(Goodbye.)

As there are more than 1 Option as children of Dialog(Sure!), all these Options define a new subject and they will be the only ones shown.

####Loop*

The Loop node makes its children to be executed one after the other, every N seconds.

####Jump

Allows the dialog to jump directly to a Group node. The label set must of course be the same as the Group name.

####Choice 

Is to be removed. Not done yet.




###Use in a scene

To be written. 
For now, just start the test_scene.scn and play it.







