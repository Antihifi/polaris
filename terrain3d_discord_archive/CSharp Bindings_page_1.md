# CSharp Bindings page 1

*Terrain3D Discord Archive - 43 messages*

---

**sythelux** - 2025-05-02 17:05

CSharp Bindings

---

**sythelux** - 2025-05-02 17:05

<@455610038350774273> do you want the bindings as part of the addon or should I make an extra addon that is named "terrain_3d_bindings", which will be on the AssetLib

---

**tokisangames** - 2025-05-02 17:06

Likely a PR. What files does it produce and what is the general process for creating them?

---

**sythelux** - 2025-05-02 17:07

I have to see how I can automate the generator. So I can't tell you a lot about the process.

It gives a Folder called GDExtensionWrappers with C# Files. For each Cpp class there is one cs file

📎 Attachment: image.png

---

**sythelux** - 2025-05-02 17:08

the folder could be placed inside the addons/terrain3d folder or not. it seems not not matter for the project

---

**tokisangames** - 2025-05-02 17:08

It must be built in Godot?

---

**sythelux** - 2025-05-02 17:09

yes as far as I know the binding generator is a Godot addon itself

---

**sythelux** - 2025-05-02 17:10

the dude who made the debug3ddrawer wrote their own generator that can be called as part of teh build-pipeline I can take a look how complex that is

---

**sythelux** - 2025-05-02 17:11

like in theory I can make it, when you do a release, but I know I'm not very reliable in my availability so I would also want to work on a solution that works without my intervention

---

**tokisangames** - 2025-05-02 17:12

Right, I need a process that I can run and commit.

---

**sythelux** - 2025-05-02 17:15

would you be ok if it is a plugin inside of the example project that has one button with generate bindings?

📎 Attachment: image.png

---

**sythelux** - 2025-05-02 17:16

I know that is not optimal, but I try to find a place where to put things

---

**tokisangames** - 2025-05-02 17:18

I don't understand this `a plugin inside of the example project`
Since you can't tell me about the generation process, I can't answer anything about it. Why don't you work through the process until you can talk about it, then we can figure out the best place to put it in the repo.

---

**sythelux** - 2025-05-02 17:22

hmm you are right.

well the current generation process is:

1. I build/get the GDExtension of Terrain3d
2. I clone CSharp Wrapper generator: https://github.com/Delsin-Yu/CSharp-Wrapper-Generator-for-GDExtension 
3. I place the GDExtension addons/terrain_3d
4. I open the "CSharp-Wrapper-Generator-for-GDExtension " in Godot. build c# and Click "Generate" in an extra editorui
it will create a folder called GDExtensionWrappers with the C# files above.

I can copy those into a project that has Terrain 3D as addon and can start using it in C#

---

**sythelux** - 2025-05-02 17:22

nothing can be really automated about it as I currently now it

---

**sythelux** - 2025-05-02 17:23

the best Solution I have at this point is, that I have a repository called Terrain3DCSharpBindings, which I release as soon as possible after your releases and it contains only the bindings and we only mention it in the docs, but are not making it an official part.

---

**tokisangames** - 2025-05-02 17:25

> I can copy those into a project that has Terrain 3D as addon and can start using it in C#

Can they be anywhere? How do you enable them for use?

---

**tokisangames** - 2025-05-02 17:26

If they were in `addons/terrain_3d/csharp` can you build them and add them to your search path?

---

**sythelux** - 2025-05-02 17:26

they can be anywhere. even on the root of the directory. Godot handles everything inside the project folder as one C# Solution atm it does NOT create a csproj file per addon currently

---

**sythelux** - 2025-05-02 17:26

yes that would work

---

**tokisangames** - 2025-05-02 17:27

Then the only thing that needs to be in the repo are:
* these instructions for building the bindings for devs in the docs
* instructions for using the bindings for users
* the generated bindings in the folder above.
After I change the API I can regenerate the bindings, just as I do the docs.

---

**sythelux** - 2025-05-02 17:29

oh ok if that would be enough. then yes I can do that

---

**sythelux** - 2025-05-02 17:29

do you have a place in the docs for devs?

---

**tokisangames** - 2025-05-02 17:30

All of the docs are under doc/docs

---

**sythelux** - 2025-05-02 17:32

ah I would put it into "Development -> Building from source -> Generating C# Bindings" next to Troubleshooting and Other Build Options

---

**tokisangames** - 2025-05-02 17:32

On another page

---

**tokisangames** - 2025-05-02 17:33

index.rst has the table of contents

---

**sythelux** - 2025-05-02 17:34

aye ok I think I found a place

---

**sythelux** - 2025-05-02 17:35

I make a draft PR

---

**tokisangames** - 2025-05-02 17:36

You can also update `Programming Languages` with either all of the user docs for using C#, or a link to that page if it's significant, and updating the C# examples and text to refer to the bound method.

---

**tokisangames** - 2025-05-02 17:37

Some of the info about using the classdb, or calling objects may not be relevant for C# anymore, but they might be applicable to rust or other languages without bindings.

---

**sythelux** - 2025-05-02 17:39

ok then one last thing I would add a Manual search and Replace to change `namespace GDExtension.Wrappers` (the generator spits that out) to `namespace TokisanGames.Terrain3DWrapper`

---

**tokisangames** - 2025-05-02 17:40

What is the namespace used for? All of the C++ works in the Godot namespace and does not conflict.
Can the generator operate on the command line?

---

**sythelux** - 2025-05-02 17:42

the Namespace is for that it doesn't conflict with other addons, because they are all in the same csproj. I could remove the namespace, but then it would be always available this is bad practice in C#. I also can't join the Godot namespace.

---

**tokisangames** - 2025-05-02 17:42

Alright. Does it need to include Wrapper?

---

**sythelux** - 2025-05-02 17:43

if there is a way to call functions in Godot like in unity then yes that could work

---

**sythelux** - 2025-05-02 17:43

it does not, but then the Main class would be TokisanGames.Terrain3D.Terrain3D which I need to try

---

**tokisangames** - 2025-05-02 17:44

That's worse.

---

**sythelux** - 2025-05-02 17:44

yes XD

---

**sythelux** - 2025-05-02 17:45

I can make it only namespace TokisanGames

---

**sythelux** - 2025-05-02 17:45

I just tried to remove the namespace altogether and it has an ambiguous call exception for some of the functions so we can't do that either

---

**sythelux** - 2025-05-02 17:49

I think this looks clean

📎 Attachment: image.png

---

**tokisangames** - 2025-05-02 17:50

Yes, that looks fine

---

