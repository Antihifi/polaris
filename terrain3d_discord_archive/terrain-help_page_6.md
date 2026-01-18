# terrain-help page 6

*Terrain3D Discord Archive - 1000 messages*

---

**kamil2009** - 2025-04-25 19:32

of the square

---

**tokisangames** - 2025-04-25 19:32

Can you reproduce this in our demo?

---

**kamil2009** - 2025-04-25 19:33

sory but i don't understand you the french traduction of your sentence is bad with google translate sory

---

**tokisangames** - 2025-04-25 19:34

enregistrer une vidéo

---

**kamil2009** - 2025-04-25 19:34

I can't see the square when i don't lunch the game

---

**reidhannaford** - 2025-04-25 19:37

Is it possible to derive texture info based on location on the terrain?

For example if I wanted to:
- set the color of foliage assets to match the terrain texture color automatically
- play different footstep sounds depending on what terrain texture the player is moving on top of

---

**kamil2009** - 2025-04-25 19:38

What do you want me to do in the video?

---

**tokisangames** - 2025-04-25 19:38

Data.Get_texture_id

---

**tokisangames** - 2025-04-25 19:38

Demonstrate the problem, and what the tools do or do not do.

---

**kamil2009** - 2025-04-25 19:39

what can i demonstrate? it's just wen i play the game

---

**reidhannaford** - 2025-04-25 19:39

amazing thank you

---

**tokisangames** - 2025-04-25 19:40

Your text explanation is not clear. If you can't describe the problem clearly, and can't show the problem on video, I can't help.

---

**kamil2009** - 2025-04-25 19:42

I'm really sorry but I can't make a video but my problem is that when I launch my game I have black squares in mini links and which are a little everywhere as if they were making a grid. Without launching the game I can't see them

---

**tokisangames** - 2025-04-25 19:43

OBS is free software that records videos

---

**tokisangames** - 2025-04-25 19:43

Do you have the problem when you run our demo?

---

**kamil2009** - 2025-04-25 19:44

i can't record video because i don't have so much time. I am not an adult

---

**kamil2009** - 2025-04-25 19:44

no

---

**tokisangames** - 2025-04-25 19:46

Great. Now you have a working project and a non working project to compare. That will help you determine what you did in your project to create this.

---

**tokisangames** - 2025-04-25 19:46

Start with a new scene, new terrain, inside your project.

---

**tokisangames** - 2025-04-25 19:47

Then continue to divide and conquer until you narrow it down.

---

**tokisangames** - 2025-04-25 19:47

You now know the issue isn't with your hardware, Godot, or Terrain3D. It's something specific to your project.

---

**kamil2009** - 2025-04-25 19:47

I have only one project, why one that works and one that doesn't? I only have one that works but with a problem in my settings of something I think.

---

**tokisangames** - 2025-04-25 19:48

I've never seen this out of thousands of users, so it's unique to you.

---

**tokisangames** - 2025-04-25 19:48

That is the question that you need to figure out.

---

**tokisangames** - 2025-04-25 19:50

It could be your settings or your code. Since you won't share anything about it, you'll need to track it down on your own. I gave you a starting point: new scene, new terrain. Then add in your region directory. Then your assets. Then your material. Test each one.

---

**kamil2009** - 2025-04-25 19:50

It's good with the brush of hight it's good because when I try again in a new scene I see them without launching my game it's good and thank you for your help

---

**ne_ergo** - 2025-04-26 08:41

whats a good way to make a massive island

---

**ne_ergo** - 2025-04-26 08:41

my PC cant really handle 2000% strenght and 2000 meters of raise area in real time

---

**ne_ergo** - 2025-04-26 08:41

as a brush

---

**ne_ergo** - 2025-04-26 08:42

and using a smaller brush gives me many smaller hills that then I somehow have to smooth over and doesnt quite work for me

---

**ne_ergo** - 2025-04-26 08:42

I need like a long chunk looking like <===> to be raised

---

**ne_ergo** - 2025-04-26 10:48

<@408128009988603914> my brother in Christ do you know how to do this?

---

**rds1983** - 2025-04-26 10:49

no, sorry

---

**ne_ergo** - 2025-04-26 10:49

ok, thank you, sorry for mentioning you, the others are in Do Not Disturb mode haha

---

**rds1983** - 2025-04-26 10:50

No worries. Happy Easter! Christ is Risen!

---

**tokisangames** - 2025-04-26 11:06

Don't ping random individuals, who may not be active on any of the several projects we have. Be more courteous. Just ask and someone will answer on their own schedule.

---

**ne_ergo** - 2025-04-26 11:07

I pinged him because his role is Terrain3dDev and the ball was green, but ok

---

**tokisangames** - 2025-04-26 11:08

The whole channel is for terrain help. Just because someone is a dev doesn't mean they're active on the project, or that they're sitting on their PC waiting for you to ping them.

---

**tokisangames** - 2025-04-26 11:09

Import a heightmap
Or generate one from script
No PC can handle 2000m. It currently edits data on the CPU and won't be able to smoothly edit large areas until a GPU workflow is implemented

---

**tokisangames** - 2025-04-26 11:09

The slope brush can handle long stretches point to point

---

**ne_ergo** - 2025-04-26 11:11

Thank you, I'll try with the slope and if problematic I'll research how to make a height map

---

**tokisangames** - 2025-04-26 11:12

There's an entire page in the documentation on it

---

**tokisangames** - 2025-04-26 11:12

And an example in CodeGenerated.gd. Only one more line needed to save the image to disk.

---

**moooshroom0** - 2025-04-26 12:56

ive been trying to figure out where but i don't know. i tried my best to use the demo, but it isnt working out. from my understanding the control map should be where i assign the texture, but i cant find the right texture or something along those lines.

---

**tokisangames** - 2025-04-26 13:30

Download a nightly build rather than 1.0. It's already setup in the demo. Not that the was any setup anyway.

---

**ne_ergo** - 2025-04-26 13:58

Thanks, I'll use HTerrain to make a height map then import it following the docs

---

**diesel1.3** - 2025-04-26 14:09

Hey all, I need some help with godot crashing. I have one region where a single action just closes the app, with no log files, no nothing. However, every other region on the level works. After launching from CMD, and using rise terrain on the buggy region i got this. Any help would be apprieceated 😊

📎 Attachment: message.txt

---

**tokisangames** - 2025-04-26 14:12

What is the single action? Or any action?
You have one problem region in particular? Save that file as is and upload it here so I can look at it please.

---

**tokisangames** - 2025-04-26 14:12

Also open up that region file and show its contents in the inspector.

---

**tokisangames** - 2025-04-26 14:13

The Steam build of Godot may be a problem. Historically it has been

---

**tokisangames** - 2025-04-26 14:14

Put that one problem region file into our demo, which is also 1024 sized, and see if you have a problem with it there.

---

**tokisangames** - 2025-04-26 14:19

It looks like it's crashing when updating the position of whatever mesh instances you have at P: (3.68518, x,  -32.37637) which should be global. What is there?

---

**hzpilo** - 2025-04-26 19:38

Hi guys, I am new to Godot. Does anyone has the same issue as mine whenever I tried to modify the grass texture from demo scene

📎 Attachment: image.png

---

**hzpilo** - 2025-04-26 19:41

Ah I found the error msg

📎 Attachment: image.png

---

**hzpilo** - 2025-04-26 19:45

for the settings of the texture I made

📎 Attachment: image.png

---

**hzpilo** - 2025-04-26 19:47

Is there anythings I missed here

📎 Attachment: image.png

---

**tokisangames** - 2025-04-26 19:48

Just use the built in channel packer.
Review the documentation. It has settings for gimp and channel packer.

---

**tokisangames** - 2025-04-26 19:48

Also your terminal is cutting off the edge of messages. Reconfigure it to wrap lines.

---

**tokisangames** - 2025-04-26 20:06

For the demo textures they are png marked as high quality, as the docs say, and shown in Godot. You have to match it if you want to use the existing.

---

**hzpilo** - 2025-04-26 20:11

Hi <@455610038350774273> thanks ! I tried to use the Texture Packer tools in Terrain3D and it's worked !

📎 Attachment: image.png

---

**hzpilo** - 2025-04-26 20:19

For texture packing in GIMP, I don't think I missed some certain settings. Could you have a look on this video <@455610038350774273> 
https://vimeo.com/1079003233?share=copy#t=0

---

**reidhannaford** - 2025-04-26 20:26

would you mind linking me to your PR? I'm super curious what functionality you're working on that will improve texturing. What does it do?

---

**tokisangames** - 2025-04-26 21:58

As I said, and written in the docs, the existing textures are PNG marked HQ. The texture you made is fine, but it is DDS containing DXT5. Those are obviously different. Either clear all textures and use DXT5. Or if you want to use the existing textures, make the new ones in the same format.

---

**tokisangames** - 2025-04-26 22:07

There's only 4 open on github
https://github.com/TokisanGames/Terrain3D/pull/679

---

**reidhannaford** - 2025-04-26 22:31

Oh gotcha. So it allows the line between two textures to be in between vertices in a cleaner way?

---

**reidhannaford** - 2025-04-27 17:43

A terrain foliage scattering feature I find super useful that’s in both unreal engine and unity is the ability to select multiple foliage assets at once, and when painting foliage it will randomly alternate between them. Super handy for when you want to scatter a number of different kinds of plants.

Is this possible with terrain3D? Or if not, a feature the team would consider?

---

**tokisangames** - 2025-04-27 17:53

You can track issue 43 for plans for the instancer

---

**xorist** - 2025-04-27 19:57

Is there a way to paint textures on a smaller scale than 1 meter at a time?

---

**rakadeja** - 2025-04-27 19:59

My project might be experiencing this problem since it was upgraded from 4.1? I think? a while ago, to 4.4.1. I'm using the Mono version - even if I'm not using C# for anything lol.

I'm using Terrain3D 1.0.0 from the Asset Library. I'm pretty sure I had the exact same problem with the master branch.

When I'd tried to install the addon, restart the editor, and enable it - I get this error:
```  ERROR: res://addons/terrain_3d/src/editor_plugin.gd:54 - Invalid call function 'initialize' in base 'PanelContainer (asset_dock.gd)': Attempt to call a method on a placeholder instance. Check if the script is in tool mode.
```

Disabling it? I get this error:
```  ERROR: res://addons/terrain_3d/src/editor_plugin.gd:58 - Invalid call function 'remove_dock' in base 'PanelContainer (asset_dock.gd)': Attempt to call a method on a placeholder instance. Check if the script is in tool mode.
```

I'm not sure if there are cached things in the .godot folder?

I *could* add a bunch of verbosity through each of these lines, but I'm honestly confused. I've opened the asset_dock.tscn, hoping somehow that was related to it. Same stuff.

📎 Attachment: image.png

---

**tranquilmarmot** - 2025-04-27 20:05

Try setting up a new scene with different terrain data and see if the error persists

---

**rakadeja** - 2025-04-27 20:12

Committing, then deleting my .godot folder. I have a feeling that might fix it - after going through all of the addon scripts I don't see a single reason why this error would occur otherwise.

---

**image_not_found** - 2025-04-27 20:30

Oh this, I have it too

---

**image_not_found** - 2025-04-27 20:30

Narrowed it down to having VSCode open when launching the editor

---

**rakadeja** - 2025-04-27 20:30

:0

---

**image_not_found** - 2025-04-27 20:30

Doesn't occur if I open Godot before it

---

**image_not_found** - 2025-04-27 20:30

Added in 4.4

---

**rakadeja** - 2025-04-27 20:30

i launch vscode specifically from the editor 😂

---

**rakadeja** - 2025-04-27 20:30

i mean Godot

---

**rakadeja** - 2025-04-27 20:30

bro my brain, let me try that!

---

**image_not_found** - 2025-04-27 20:31

Idk why it happens, I tried to debug it myself but it makes no sense

---

**image_not_found** - 2025-04-27 20:31

There's a node in the plugin's UI that doesn't have its script loaded even though it's right there in the scene

---

**rakadeja** - 2025-04-27 20:32

it worked?!?!?!?! 😭

---

**image_not_found** - 2025-04-27 20:32

Took me a while to figure it out, at first I thought it was random

---

**image_not_found** - 2025-04-27 20:32

Turns out, it wasn't

---

**image_not_found** - 2025-04-27 20:33

Idk if it's the VSCode Godot extension, the engine or what

---

**image_not_found** - 2025-04-27 20:33

I have never worked on a Godot addon so I have no idea about how this would even happen, but it does

---

**rakadeja** - 2025-04-27 20:35

i've never messed with making a .gdextension. that's wild - it's an engine bug that i don't even... know? i don't know how or where it could be.. initializing core modules or something.. ?? !?? maybe at a weird time?

---

**rakadeja** - 2025-04-27 20:41

Okay, real question. Now that this actually works, I have a similar question to the one I'd yapped in <#1323720812179488850> .

I need a very small, very simple terrain for a section that will be stared at on the title screen. What settings should I consider looking into? I can **also** just run to the documentation for a while since I haven't had time to actually use the addon/test stuff with it.

---

**tokisangames** - 2025-04-27 21:25

You can paint on vertices as discussed in the intro. If you want vertices closer than 1m apart, reduce vertex_spacing. However most people shouldn't do this unless the ramifications are well understood. Most likely you can achieve what you want through improving technique or another means.

---

**xorist** - 2025-04-27 21:27

Changing the vertex spacing is what I ended up doing. I needed finer details than what the standard spacing could afford me, even with trying a variety of textures and techniques. It's looking good now, though

---

**tokisangames** - 2025-04-27 21:30

<@572604045777436672> <@1091423680980078682> <@694581469565419661> All three of you have these errors with the asset dock? I cannot reproduce it on Mono or standard. Neither can my team. I can't imagine it's a bug in the Terrain3D code or it would affect everyone. 
What is the same about each of your setups? OS? Upgrade path? All three using vscode? 
And does the solution of closing vscode before Godot, and launching it from the editor resolve it for each of you?

---

**tokisangames** - 2025-04-27 21:32

https://github.com/TokisanGames/Terrain3D/issues/681

---

**tranquilmarmot** - 2025-04-27 21:32

I'm also using VSCode w/ the addon, so that could definitely be the issue. I'm not having it currently after a few restarts of everything 🤔

---

**tranquilmarmot** - 2025-04-27 21:32

Some sort of race condition?

---

**image_not_found** - 2025-04-27 22:03

I can consistently recreate it as follows:
- have the `godot-tools` extension enabled within VSCode (none else necessary)
- launch VSCode, have it load
- at this point, the extension will try to connect to Godot; launch the Godot project before the VSCode extension times out (by default, 20ish seconds; you can see in the bottom right of VSCode a retry attempt counter counting up to 10 before giving up)
  - if the extension times out, Terrain3D starts correctly
- wait for Godot to load; if the extension has established a connection (check within VSCode) there'll be errors in the console, and the Terrain3D panel to select textures/meshes won't load


At this point, closing the Godot editor and then reopening it without closing VSCode will make the VSCode extension disconnect without attempting to reconnect again to Godot, so Terrain3D will load normally on the next Godot startup

📎 Attachment: immagine.png

---

**image_not_found** - 2025-04-27 22:04

So essentially this only occurs when launching VSCode and Godot at once, otherwise the timeout timing doesn't line up

---

**image_not_found** - 2025-04-27 22:13

OS: Windows 10
Godot: 4.4.1 w/ C# support (though it began happening since updating from 4.3 to 4.4, with no changes in the Terrain3D installation)
VSCode: 1.67.2 (it's a prehistoric several years old version, but I doubt it's the cause of the issue)

---

**image_not_found** - 2025-04-27 22:13

`godot-tools` v1.3.1

---

**.chaonic** - 2025-04-27 22:32

This may be a stupid question, but is there a way to change the position of the Terrain3D node?
Let's say someone put out an amazing water simulation, and it just happens to be at the same height as the terrain at its default.
Both the water and the terrain refuse to be repositioned.

---

**.chaonic** - 2025-04-27 22:36

Sorry, this is the second time in a couple of days where I ask before REALLY digging into the problem.
I just have to find the script that relocates the water when the camera moves and give it the exact height I need.

---

**tokisangames** - 2025-04-27 22:39

Great, thanks for the report and troubleshooting. It was bugging me that a few users had the same error messages and no one else did.
You could stick this in issue #681 for reference. 
So you're using godot-tools, not godot-vscode-plugin? You guys might also want to report the issue on the repo of whichever plugin you're using.

---

**tokisangames** - 2025-04-27 22:40

No, transforms are disabled for reasons.
Change material/worldbackground to none. Sculpt your desired height

---

**.chaonic** - 2025-04-27 22:44

I see, thank you. Then I really gotta figure out how to displace the water.

---

**tokisangames** - 2025-04-27 22:44

I just gave you a solution for that

---

**.chaonic** - 2025-04-27 23:37

Oh. Sorry, my problem wasn't as much that I wasn't able to sculpt, it was that the water being at the same height as the lowest point of the terrain is a bit awkward. 🙂
The tips of the ocean waves poke out of the terrain. So either the terrain needs to be lower, or the water needs to be higher.
I was able to make the two coexist by changing the height of the water! 🙂
Now I can sculpt some islands! 🏝️

---

**tokisangames** - 2025-04-27 23:49

> it was that the water being at the same height as the lowest point of the terrain is a bit awkward

The terrain can go down to -3.4E+38, so sculpt it to whatever height you want lower than the water. We assume sea level is zero. You don't need to change the water shader or have water be higher than sea level. That might be awkward when interpretting height values. Better to use real heights.

---

**m.estee** - 2025-04-28 04:32

Hi folks, new here! Apologies if I'm asking this question in the wrong channel. I've started using Terrain3D for my project and I am wondering if there are strategies for managing placed objects?

Terrain3D looks like it does a great job loading in sections as the world grows, but it's less clear to me how I might hook into that machinery to load and unload placed objects within the different tile segments as they come and go.

If there are writeups on this, I would love to read them.

---

**image_not_found** - 2025-04-28 08:16

Seems to me like `godot-tools` and `godot-vscode-plugin` are the same thing though, the link in the repo https://github.com/godotengine/godot-vscode-plugin?tab=readme-ov-file#download sends over to `godot-tools` in the VSCode marketplace

---

**image_not_found** - 2025-04-28 08:20

Also I just realized that the extension's latest release is 2.5.1, but I have 1.3.1 which came out in 2022 (probably VSCode 1.67.2 doesn't support latest version)

---

**image_not_found** - 2025-04-28 08:22

Actually, seems like Godot 4.x support was added in 2.0, I'm surprised 1.3.1 even worked at all for me https://github.com/godotengine/godot-vscode-plugin/releases/tag/2.0.0

---

**tokisangames** - 2025-04-28 09:01

Which version does the asset library default to? <@572604045777436672> which version do you have?

---

**tokisangames** - 2025-04-28 09:11

We don't have tile segments. Read the introduction doc.
There is no infrastructure to signal you to do anything with your MeshInstance3D assets yet. That will come once region streaming is finished. There's a draft PR you can follow. You can currently make a simple loader based on camera position. Objects in our instancer are automatic.

---

**m.estee** - 2025-04-28 13:16

ah, make sense that this would be dependent on streaming. i'll look for the PR.

---

**tranquilmarmot** - 2025-04-28 17:14

I'm on VSCode version `1.98.2`
The VSCode plugin I have installed is `2.5.1` (latest version of it) which comes from the VSCode marketplace and not from the Godot asset library (https://marketplace.visualstudio.com/items?itemName=geequlim.godot-tools)

---

**kamazs** - 2025-04-28 17:54

ah, yes, I also noticed that Terrain3D missing textures issue was related to the VSCode addon

---

**a5_1to40** - 2025-04-28 21:46

help
why does my terrain dissapear in runtime

📎 Attachment: RpWxPoH.mp4

---

**a5_1to40** - 2025-04-28 21:46

i looked at me remote tree and the node of terrain 3d is never instantiated

---

**vhsotter** - 2025-04-28 21:54

I'm seeing what looks like errors occurring in the Debugger tab. What's showing there when it runs? Also, run the editor using the CLI option and check for errors there since some errors appear there that won't in the editor.

---

**a5_1to40** - 2025-04-28 21:57

here,let me check the cli

📎 Attachment: h4Ey9WL.png

---

**vhsotter** - 2025-04-28 21:59

Where is your Terrain3D node? I don't see it in your scene tree.

---

**a5_1to40** - 2025-04-28 22:00

*(no text content)*

📎 Attachment: LFbUzEU.png

---

**a5_1to40** - 2025-04-28 22:03

when i reparented the terrain 3d node to be a direct child of the Node3D,the game displays nothing,then immideatly closes

---

**tokisangames** - 2025-04-28 22:04

That's not the CLI. Run Godot in a terminal and post the full output.
Can you reproduce this in our demo?

---

**a5_1to40** - 2025-04-28 22:08

apparently yes because i get an error saying
``Parser Error: Could not find type "Terrain3D" in the current scope.``
when running the demo
Also do you mean run the godot cli command or is that something different?

---

**tokisangames** - 2025-04-28 22:10

We need the errors in your terminal. They only are shown there.

---

**vhsotter** - 2025-04-28 22:11

Since you're on Linux, that means running the editor from a terminal window.

---

**tokisangames** - 2025-04-28 22:11

CLI is command line interface. That is in a terminal window. No other panel or window is a CLI.

---

**a5_1to40** - 2025-04-28 22:11

got it

---

**a5_1to40** - 2025-04-28 22:12

https://pastebin.com/w4685AmU

---

**a5_1to40** - 2025-04-28 22:12

using nixos btw

---

**tokisangames** - 2025-04-28 22:13

You're not loading the library

---

**vhsotter** - 2025-04-28 22:13

Your distro is missing `libstdc++.so.6`

---

**tokisangames** - 2025-04-28 22:13

However it seems you are in editor mode, so you have some troubleshooting to do

---

**tokisangames** - 2025-04-28 22:14

Test only with our demo. Get it working in editor and in game first.

---

**tokisangames** - 2025-04-28 22:16

Does this file exist?
 /home/seto/godot-projs/terrain/addons/terrain_3d/bin/libterrain.linux.debug.x86_64.so

---

**tokisangames** - 2025-04-28 22:16

If so, run `ldd  /home/seto/godot-projs/terrain/addons/terrain_3d/bin/libterrain.linux.debug.x86_64.so`

---

**a5_1to40** - 2025-04-28 22:17

```        linux-vdso.so.1 (0x00007f6c1168b000)
        libstdc++.so.6 => not found
        libm.so.6 => /nix/store/rmy663w9p7xb202rcln4jjzmvivznmz8-glibc-2.40-66/lib/libm.so.6 (0x00007f6c11117000)
        libc.so.6 => /nix/store/rmy663w9p7xb202rcln4jjzmvivznmz8-glibc-2.40-66/lib/libc.so.6 (0x00007f6c10e00000)
        /nix/store/rmy663w9p7xb202rcln4jjzmvivznmz8-glibc-2.40-66/lib64/ld-linux-x86-64.so.2 (0x00007f6c1168d000)```
that explains it

---

**a5_1to40** - 2025-04-28 22:58

huh
libstdc++.so.6 IS installed on my system

---

**tokisangames** - 2025-04-28 23:39

Then your system library search path isn't properly configured

---

**tokisangames** - 2025-04-29 07:28

> Has anyone had any issues with the the godot player crashing when you try to run it with terrain3d terrain and fsr 2.2 enabled?
<@246536086996779008> FSR2 isn't supported, waiting on Godot 4.5. There's an issue you can follow. It's also unstable on some systems.

---

**misty.dev** - 2025-04-29 18:15

Seems like for whatever reasons, collisions aren't being applied on terrain and any 3D object falls through the terrain

---

**misty.dev** - 2025-04-29 18:15

Is there a way to fix this?

---

**xorist** - 2025-04-29 18:27

did you add regions? Also, did you add colliders to your objects?

---

**misty.dev** - 2025-04-29 18:28

How do you add regions? I was under the assumption it was automatic by default

---

**misty.dev** - 2025-04-29 18:28

Also yes my objects have colliders

---

**xorist** - 2025-04-29 18:29

click on the terrain in your project hierarchy, if the add on is enabled you'll see a tool set appear on the left side of the 3D view, then you can find the regions tool at the top

---

**xorist** - 2025-04-29 18:29

regions are also automatically added when you use the terrain editing tools

---

**misty.dev** - 2025-04-29 18:30

I see, using add region flattens my existing terrain out though

---

**misty.dev** - 2025-04-29 18:30

and I seemingly can't undo it either

---

**misty.dev** - 2025-04-29 18:30

so now I have a flat space in my terrain

---

**xorist** - 2025-04-29 18:30

yeah that happened to me, too

---

**misty.dev** - 2025-04-29 18:31

Then what is the point of using the noise feature for world background

---

**misty.dev** - 2025-04-29 18:31

<:Thonk:356771720863940608>

---

**xorist** - 2025-04-29 18:31

never used it, got no idea

---

**xorist** - 2025-04-29 18:31

probably just for the world background

---

**xorist** - 2025-04-29 18:31

not for your actual playable region

---

**xorist** - 2025-04-29 18:31

but idk

---

**misty.dev** - 2025-04-29 18:31

Interesting

---

**xorist** - 2025-04-29 18:33

https://terrain3d.readthedocs.io/en/latest/docs/collision.html#physics-based-collision-raycasting:~:text=Out%20in%20the%20WorldNoise%20background%2C%20there%20is%20no%20terrain%20data%2C%20so%20no%20collision.

---

**vhsotter** - 2025-04-29 18:35

Noise for world background is just for decoration. There's no collision or anything for it and you can't edit it directly.

---

**misty.dev** - 2025-04-29 18:47

👍

---

**misty.dev** - 2025-04-29 18:47

Thanks a lot guys

---

**tokisangames** - 2025-04-29 19:26

You should read the introduction and all of the documentation.

---

**misty.dev** - 2025-04-29 19:27

I missed that part of the documentation :p

---

**misty.dev** - 2025-04-29 19:27

My fault

---

**biome** - 2025-04-30 23:49

Terrain is subtly different in editor vs in game? The obvious one is the grass clipping into the road, but you can see the hills in the back are textured incorrectly in the game. 16 bit saving is off

📎 Attachment: image.png

---

**biome** - 2025-05-01 00:07

LOD issue, use `set_camera` on terrain

---

**biome** - 2025-05-01 00:07

🙂

---

**mrfreeze2698** - 2025-05-01 01:54

i cant seem to find the Terrain3D in the search bar of the asset library

---

**m.estee** - 2025-05-01 05:25

hi. i'm running into  some kind of rendering problem. it showed up recently, but I'm not sure what i changed. does anyone recognize it?

📎 Attachment: Screen_Recording_2025-04-30_222428.mp4

---

**maker26** - 2025-05-01 05:27

looks like lod fighting

---

**maker26** - 2025-05-01 05:27

thats my guess

---

**m.estee** - 2025-05-01 05:29

after staring at this for hours i remembered that I turned on "Physics Interpolation" right after posting my question  and that turned out to be the problem.

so uh, "Physics Interpolation" seems to be the issue. I have no idea why.

---

**m.estee** - 2025-05-01 05:29

Phantom Camera really wants interpolation. Anyway, sorry for the channel noise.

---

**tokisangames** - 2025-05-01 09:59

What version of Godot?

---

**tokisangames** - 2025-05-01 10:05

Physics interpolation is supported in the latest builds with 4.4. Might have to use a nightly, but I thought the release supports it.

---

**mrfreeze2698** - 2025-05-01 11:37

4.4.1

---

**tokisangames** - 2025-05-01 11:42

Problem with the asset library. Can't find a lot of things. I reported it on their dev chat.

---

**tokisangames** - 2025-05-01 11:46

Download from github releases for now. It's the same file.

---

**tokisangames** - 2025-05-01 12:10

Did you search in the project manager or within a project?

---

**tokisangames** - 2025-05-01 12:17

Create a new project, then search in the asset library. The PM asset lib is limited to demos and templates.

---

**m.estee** - 2025-05-01 13:31

4.5dev3

---

**tokisangames** - 2025-05-01 13:50

That question wasn't for you. I already answered your question. If the latest Terrain3D release doesn't have the PI fix use a nightly build.

---

**tokisangames** - 2025-05-01 13:55

Also 4.5 may work, but is not supported until the rcs

---

**snrdrakosha** - 2025-05-01 14:16

Good day. I didn't find a pinned post about frequently asked questions, so I apologize in advance for my question: how do I add my own texture to paint the landscape? When I try, I get this

📎 Attachment: rn_image_picker_lib_temp_0ac21929-d191-433a-8172-ba0055a3dd14.jpg

---

**tokisangames** - 2025-05-01 14:18

Troubleshooting talks about white terrain when you add a texture. Also your console, output panel, and scene tree probably tell you the new texture you added is the wrong size or format.

---

**snrdrakosha** - 2025-05-01 14:21

okay, thank you very much

---

**tranquilmarmot** - 2025-05-01 14:24

V1.0 definitely supports physics interpolation, I'm using it in Godot 4.4 right now and it's fine

---

**tranquilmarmot** - 2025-05-01 14:24

Are you using anything to generate these roads or are they just a single mesh that you created? They look great!

---

**m.estee** - 2025-05-01 14:24

ah. apologies.

---

**biome** - 2025-05-01 14:35

csgpolygon with a nice texture on it!

---

**m.estee** - 2025-05-01 14:53

i grabbed a more recent build and the problem is no longer there so that appears to have been the problem. thx

---

**mayumi9867** - 2025-05-01 19:21

hello,

i donß´t know what i do make wrong 😦

📎 Attachment: image.png

---

**mayumi9867** - 2025-05-01 19:22

if i net 1 texture its worken if i will add 2nd texture its failed

---

**tokisangames** - 2025-05-01 19:36

https://terrain3d.readthedocs.io/en/latest/docs/troubleshooting.html#added-a-texture-now-the-terrain-is-white

---

**mayumi9867** - 2025-05-01 20:02

its possebil in the next day if cou can help me with that i dont understand my error

---

**tokisangames** - 2025-05-01 20:07

Read the link. All textures must be the same size and format. Yours are different. I can't fix it for you. You need to setup your textures properly. This is required by your GPU.

---

**tokisangames** - 2025-05-01 20:09

Ensure all textures are the same size and all have alpha. Use our channel packer. Ensure all have the same settings. Doubleclick the files to open them in Godot and ensure they are the same size and format.

---

**mrfreeze2698** - 2025-05-01 20:49

a yes i found it thx so much and sorry for the late response

---

**kamazs** - 2025-05-03 11:00

🤔 No errors, nothing, just there was a bit of foliage missing (image 2) in game versus in editor (image 1). The cutoff looks very suspiciously rectangular. After restarting of Godot, it synced and foliage was missing in editor, too. Then I re-painted the area and it persists.

_Godot 4.4, T3D 1.0.0_

📎 Attachment: image.png

---

**wowtrafalgar** - 2025-05-03 13:20

can godot support 16k heightmaps since you separated the storage into regions?

---

**tokisangames** - 2025-05-03 14:34

Extend your last lod range for that asset?

---

**tokisangames** - 2025-05-03 14:35

Godot supports 16k (maybe 32k) images and textures depending on your hardware.
Terrain3D supports a landscape up to 65.5k. You can import multiple smaller images.

---

**wowtrafalgar** - 2025-05-03 14:37

I remember the engine had a limitation with saving large files, but now that its not one big res file that shouldn't matter

---

**tokisangames** - 2025-05-03 14:38

The engine crashes if you attempt to save upwards of 800mb-1gb in a res file. That's independent of the above.

---

**warbotz** - 2025-05-03 15:13

Most of the times you need reload your resource files... That's a issue in Godot for live editing... Specially in meshes... I have the same issue when I paint my biomes... Or running the game ... Some times this doesn't update well... But you can reload your project... Or reapplying file and reload... That solve some times but still buggy...

---

**tokisangames** - 2025-05-03 15:20

I've never had an issue with that. We have some 50-60 mesh types. The only time I've seen instance cells hide is by design when they're out of range, or the lod mesh is broken in the scene file.

---

**rjcbp** - 2025-05-03 15:40

ey i had a question, i'm trying to create a VERY large heightmap terrain, i have 16 heightmap files that are all 4096x4096 pixels and make up a larger terrain. is there any way to import all of them into the same terrain? it only seems like it lets you offset the position in the importer by -8192

---

**tokisangames** - 2025-05-03 16:00

We support 65.5k at region size 2048. Though you may not have the vram to support that. You can import at +/-16* region_size. Read through the docs like the intro and importing pages. Probably heigtmaps as well, especially on terrain resolution.

---

**adamsleepy** - 2025-05-03 20:28

can someone remind me how to get my cliff textures to automatically paint onto my sculpted cliff sides? It was working in an old terrain scene I had but it's not working in a new terrain I set up. I have both textures setup in the new terrain and set the the ID of one to 0 and the other to 1, just like in my last scene. What am I missing?>

📎 Attachment: image.png

---

**tokisangames** - 2025-05-03 21:49

Reset the material to default, enable the autoshader.
Autoshader paints by slope
Projection de-stretches textures on cliff faces

---

**rjcbp** - 2025-05-03 22:37

do you know how much vram it would use?

---

**tokisangames** - 2025-05-03 23:07

You can calculate it. All maps take 24 bytes per pixel/vertex. Then add in your ground textures and foliage. But Godot will tell you exactly what is used when running the project, via code, or the performance monitors, and will list all textures consuming vram under the debug panel.

---

**adamsleepy** - 2025-05-04 02:04

By "enable the autoshader" do you mean clicking the "autoshader" icon in the toolbar in the left of the viewport? I click this and when I switch to another tool it toggles off again. When I click it and try painting, nothing happens. I'm trying to follow the docs but I don't see anything in the material setting for enabling the autoshader; I'm not sure how to enable the base and overlay IDs (I thought that was just making them 0 and 1?); and finally painting with the autoshader tool isn't doing anything

📎 Attachment: image.png

---

**xorist** - 2025-05-04 02:38

If I textured and painted with a vertex spacing of 0.25, and then I scaled it up to 1.0 and scaled it back down to 0.25 without making any changes during the time it was 1.0, would that be lossy?

---

**tranquilmarmot** - 2025-05-04 02:49

It's an option on the material that you attach to the `Terrain3D` node

📎 Attachment: Screenshot_2025-05-03_at_7.49.00_PM.png

---

**tokisangames** - 2025-05-04 03:37

The autoshader tool definitely does something, if the autoshader is enabled in the material. All of the tools do something. You should watch the second tutorial.

---

**tokisangames** - 2025-05-04 03:37

Vertex_spacing does not change the maps

---

**glossydon** - 2025-05-04 13:01

I'm running into some strange crashes for Terrain3D, and my only guess as to why is anything to do with MMIs *and* navigation? Has anyone else encountered this issue?

---

**glossydon** - 2025-05-04 13:07

Ah, nevermind, looks like my trees are too tree-like to be useful as a multi mesh.

---

**noun787898** - 2025-05-04 13:33

Hello. I have a problem of Rigidbody 3D type objects with thin collider falling through Terrain 3D. With the floor made by CSGBox3D object this problem does not occur. As it seems to me at the moment, the problem is the thickness of the Terrain 3D floor. Also, I don't exclude the possibility that I don't know something on a basic level, because I started working in Godot quite recently. I would be grateful if someone tells me what can be done about it.

---

**noun787898** - 2025-05-04 13:37

Also, when Rigidbody 3D objects lie on the floor made by Terrain 3D, they shake strangely

---

**tokisangames** - 2025-05-04 14:06

Thin or small or fast moving colliders are always a problem with all physics systems. We don't calculate physics. We create a heightmapshape and Godot handles physics. You need to learn more about how Godot calculates physics and don't give it things it can't properly process. Options are use jolt, reconfigure your collision shapes, reconfigure your physics bodies, reconfigure your physics server, all so Godot or jolt physics can more effectively and accurately calculate. 

There may be bugs with heightmap shape or the physics server in Godot or jolt, but with tens of thousands of users, it's more likely a configuration or expectation issue as laid out above.

---

**adamsleepy** - 2025-05-05 00:14

I'm having an issue with the "spray overlay texture" tool. It works how I expect it to on one part of my terrain (i.e. paints according to the strength I set it to/has gradient edges/etc.) but then on other parts of that same terrain it paints as if I'm just painting a base texture at full strength (ignores the strength I set it to; always paints at full strength unless set to 1% which then doesn't paint at all and never has gradient edges). Am I missing a setting I need to tick somewhere? There seems to be no rhyme or reason as to where it works and where it doesn't on my terrain.

---

**infinite_log** - 2025-05-05 02:06

Do you have autoshader enabled. If it is then it probably remove autoshader in that area when u use spray. Try to paint that particular spot with paint tool and then use spray on it. I think it is mentioned in tutorial video of terrain3d on YT that spray remove autoshader when  u paint or use spray.

---

**adamsleepy** - 2025-05-05 03:18

Yep, that was it. Thanks. Guess I just missed that in the docs/tutorials. (also thought I had auto shader painted over the whole terrain but I guess I didn't in those spots where the spray was working properly)

---

**snowflowergames** - 2025-05-05 11:58

hello! i was iporting some very basic trees  into the terrain editor tool and noticed that  the leaves would flicker in and out of  existence on the trees that i painted with the tools. in the video, the  big tree in focus is  one i manually placed.

📎 Attachment: 2025-05-05_20-57-31.mp4

---

**snowflowergames** - 2025-05-05 12:01

are alpha textures not supported? if so, is it a better approach to  model some basic leaves? thanks in advance

---

**image_not_found** - 2025-05-05 12:03

It's probably a LOD thing, are the trees made with multiple nodes? Because Terrain3D uses multiple nodes to define the various lods of the meshes, so maybe that's what you're stumbling into?
See https://terrain3d.readthedocs.io/en/latest/docs/instancer.html#artist-created-lods

---

**image_not_found** - 2025-05-05 12:04

Would explain how they appear/disappear in groups

---

**snowflowergames** - 2025-05-05 12:05

like so?

📎 Attachment: 915BF0C8-CD34-41A4-90DF-E0B2A7E0964E.png

---

**snowflowergames** - 2025-05-05 12:05

i just exported a gltf tree from blender

---

**image_not_found** - 2025-05-05 12:05

Try merging them into a single blender object before exporting

---

**image_not_found** - 2025-05-05 12:06

If you don't want to do it destructively, duplicate the objects before exporting them, merge the clones, and suffix `-noimp` to the names of the objects you don't want Godot to import

---

**snowflowergames** - 2025-05-05 12:07

wow, that fixed it. thanks!

---

**tokisangames** - 2025-05-05 12:10

The docs already explained the fix for multiple objects. Always refer to them for the latest info and all limitations.
https://terrain3d.readthedocs.io/en/latest/docs/instancer.html#simple-objects

---

**snowflowergames** - 2025-05-05 12:10

is just modelling leaves also viable? since i assume the LOD system would decimate the geometry if it's too far away? i'm currently just using a plane

---

**tokisangames** - 2025-05-05 12:16

I don't understand the first question.
Most LOD systems, including ours, are LOD switching systems. We don't change your LODS, you create them. 
Godot has two separate systems: LOD generation and LOD switching, but the latter and somewhat the former are independent of Terrain3D. This is also discussed on that doc page

---

**snowflowergames** - 2025-05-05 12:19

thank you, i'll give that a read.

---

**glossydon** - 2025-05-05 14:56

Is it normal for a Terrain3D node to not return any of Terrain3DAssets' arrays?

I have six textures, have acquired the textures' IDs from Terrain3DData, and when I get the `texture_list` from Terrain3D's `assets`, it returns an empty array.

In the remote inspector I see the `texture_list` has six indices, but each time I fetch the array in script, it is empty.

---

**tokisangames** - 2025-05-05 15:00

Uncheck free_editor_textures mentioned in the release notes

---

**glossydon** - 2025-05-05 15:04

I really appreciate you coming to my rescue. I just started using Terrain3D a few days ago, and have only just now started messing around with it in GDScript.

Thank you!!!

---

**aryamon** - 2025-05-05 19:11

trying to learn how exactly i delete the land masses i am not using ? i tried using ctrl then remove terrain tool dont that that removes

📎 Attachment: image.png

---

**aryamon** - 2025-05-05 19:16

or i cant hmm

---

**aryamon** - 2025-05-05 19:17

seems they dont hv collison , they are just there

---

**image_not_found** - 2025-05-05 19:18

You can remove regions by using the add region tool (it's the square with the plus) while holding ctrl to invert the tool's function

---

**aryamon** - 2025-05-05 19:18

that dont work hmm  i still see those green lands ,

---

**image_not_found** - 2025-05-05 19:18

As for the terrain around what you paint, that is world background and to remove it you do that from the terrain's settings

---

**aryamon** - 2025-05-05 19:19

ahh how

---

**image_not_found** - 2025-05-05 19:20

Select terrain, search for "world background" property in the settings, set it to none (you currently have it set to "flat")

---

**aryamon** - 2025-05-05 19:20

ty ty

---

**aryamon** - 2025-05-05 19:21

anoter doubt , does the plane lands auatomated created nav region or only the areas painted

---

**aryamon** - 2025-05-05 19:21

pretty sure in this demo , the whole map hv nav

📎 Attachment: image.png

---

**aryamon** - 2025-05-05 19:22

but only paintied part are the ones top

---

**aryamon** - 2025-05-05 19:22

how this is done

---

**image_not_found** - 2025-05-05 19:22

https://terrain3d.readthedocs.io/en/latest/docs/navigation.html#navigation

---

**aryamon** - 2025-05-05 19:27

ahh seen and read ust was confused why its not visile in the demo map

---

**aryamon** - 2025-05-05 19:29

actully my bad

---

**aryamon** - 2025-05-05 19:29

sorry

---

**moooshroom0** - 2025-05-05 21:35

Update: i cannot at all figure out how to set up the grass particle shader, I have tried using the demo as an example but the demo keeps failing to set up for whatever reason. im trying to read up to figure this out but my lack of understanding makes this slightly complicated.

---

**tokisangames** - 2025-05-05 21:53

The nightly build (see docs) already have the grass shader enabled. All you need to do is open the demo. If it's not working on your machine we can help you troubleshoot it.

---

**moooshroom0** - 2025-05-05 21:54

the only thing im really struggling with is the control map, i tried to get the demo working but godot gives me errors when i import it, which could be something ive done wrong but i keep comming back to it too randomly to remember at the moment.

---

**moooshroom0** - 2025-05-05 21:54

i have the grass imported successfully

📎 Attachment: image.png

---

**moooshroom0** - 2025-05-05 21:55

i just cant do anything to control it.

---

**moooshroom0** - 2025-05-05 21:56

i went through and searched several of the control map explanations that were written etc, but none of them really applied or solved it.

---

**tokisangames** - 2025-05-05 21:57

What are the errors?
Looks like it's working. 
What do you mean control it? It's a particle shader that generates automatically. If you want control, use the instancer instead.

---

**moooshroom0** - 2025-05-05 21:59

well the idea was to generate it according to the same map as one of the textures. Its typically more ideal performance wise if im not mistaken. But of course my knowledge in these specific things is rather lacking due to my current situation.

---

**moooshroom0** - 2025-05-05 21:59

i think ive seen the process done in a few games but im not certain.

---

**moooshroom0** - 2025-05-05 22:01

the grass would be generated in the areas where it didn't require a signature look but wouldn't leave the areas, my thoughts were you could assign it in a similer way by either attaching it to a texture or something similar, which ideally creates generated grass but not outside the painted area its assigned to.

---

**moooshroom0** - 2025-05-05 22:03

if its just better to use the instancer i could just do that i suppose. this was just something ive been curious about.

---

**tokisangames** - 2025-05-05 22:11

What specifically do you think is more performant?
The demo particle shader is already setup to only show where the grass texture shows, but maybe done with slope, I haven't looked closely.

---

**tokisangames** - 2025-05-05 22:12

Your picture already shows it's showing only in certain areas, as it's supposed to.

---

**tokisangames** - 2025-05-05 22:12

I didn't see any errors

---

**moooshroom0** - 2025-05-05 22:13

that is a good point, i dont know if it actually works or not i think it does though from what i was told before. By performant i ment: theres a controlled level of grass thats spread out appropriatly and it wont overload too much in a small area, the idea is also by generating grass positions arent stored(shouldnt actually be an issue in most cases though.)

---

**moooshroom0** - 2025-05-05 22:14

im not getting any errors on it in my project either.

---

**moooshroom0** - 2025-05-05 22:14

ive been trying to figure out what that is, seems to be a noise texture but i cant find one that does this.

---

**moooshroom0** - 2025-05-05 22:15

could be this one but i think this is for wind.

📎 Attachment: image.png

---

**moooshroom0** - 2025-05-05 22:16

(in the options section under particles.gd shader)

---

**moooshroom0** - 2025-05-05 22:31

yeah thats just that noise.

---

**moooshroom0** - 2025-05-05 22:32

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-05-05 22:48

Rather than making assumptions, I think you just need more experience with both the instancer and particle shader, looking at how they work, the code, what they can do, and how they perform so you can know when it's best to use one or the other.

---

**veganprep** - 2025-05-05 22:59

Hey everyone, i'm not sure if this has been answered before, but is there any kind of syncing that needs to occur for Terrain3D and multiplayer? I am working on a multiplayer game where players connect via P2P using Steam (also have Enet for testing). When clients connect, Terrain3D is desynced and the heightmap is off for clients. The collisions are okay, but the heightmap is off and is typically jagged whereas the host has no desync with Terrain3D

---

**veganprep** - 2025-05-05 22:59

Host view:

📎 Attachment: host.JPG

---

**veganprep** - 2025-05-05 22:59

client view:

📎 Attachment: client.png

---

**veganprep** - 2025-05-05 23:00

I tried making a fresh level as well but see this desync occur - I made sure to save everything as .res instead of .tres as well

---

**tokisangames** - 2025-05-05 23:11

It's a clipmap terrain, read the introduction. The terrain centers lods on the active camera you set.
I don't know how "multiplayer" is implemented. In general networked software, each client would render its own cameras.

---

**veganprep** - 2025-05-05 23:21

Ahhh I see, thanks for the quick response! Currently each client renders the level independently from the host. Also, each player starts in different locations of the level. The camera is assigned to the player per their unique authority ID

---

**veganprep** - 2025-05-05 23:22

I see I will probably need to implement `Terrain3D.set_camera()` in the same place that the player camera is being set

---

**veganprep** - 2025-05-05 23:36

got it fixed! thanks for pointing me in the right direction 👍

---

**miomancer** - 2025-05-06 01:31

are there any resources on how you would go about modifying the terrain at runtime as you would in the editor with the raise tool for example? i couldn't find info on that in the docs

---

**tokisangames** - 2025-05-06 01:35

There are several pages of API docs written, and it's all built into the Godot help. Start with Terrain3DData

---

**miomancer** - 2025-05-06 01:35

thanks! i didn't notice that section

---

**aryamon** - 2025-05-06 08:46

this noise hmm always makes mountains or can i give it a island feel

📎 Attachment: image.png

---

**tokisangames** - 2025-05-06 08:49

Change world background to none or flat, right on your screen

---

**aryamon** - 2025-05-06 08:59

hmm i see

---

**tokisangames** - 2025-05-06 09:35

Look at the island demo on the games list

---

**aryamon** - 2025-05-06 09:36

games list ?

---

**aryamon** - 2025-05-06 09:36

what's that

---

**tokisangames** - 2025-05-06 09:36

List of games. In the docs

---

**aryamon** - 2025-05-06 09:38

Okey let me check

---

**deathmetalthanatos_42378** - 2025-05-06 10:12

is there a Possibility to create libterrain.linux.release.arm64 or arm32 ?

---

**tokisangames** - 2025-05-06 11:17

Read building from source in the docs

---

**image_not_found** - 2025-05-06 11:18

I suppose if you move the noise below height 0 and put a water plane at height 0, you get islands

---

**aryamon** - 2025-05-06 11:19

I think I tried that and it can't go below 0 but I will try once I am home again in like 2 hrs

---

**deathmetalthanatos_42378** - 2025-05-06 11:32

so its technically possible to run it on Raspberry

---

**tokisangames** - 2025-05-06 12:44

Should run on anything Godot can run on, as long as the device has a GPU stack that supports texture arrays

---

**deathmetalthanatos_42378** - 2025-05-06 17:55

nice, sounds good

---

**jamonholmgren** - 2025-05-06 18:21

**Question about `get_intersection` max range.**

In my game, which is a helicopter game, ranges to targets are often > 4000 meters (up to 10k in some cases).

The `get_intersection` method caps out at 4000 meters (gpu_mode: false). I want to use it to determine if there are hills between me and the target, thus obscuring radar and visual sightlines for targeting purposes.

Is there a way to extend the maximum range above 4000?

---

**snowminx** - 2025-05-06 18:33

This is janky but could you create a node at the max range, and have that node perform the look up? Keep chaining it until you reach the max range

---

**xtarsia** - 2025-05-06 18:47

You could probably use GPU mode, and update each target in a queue that gets processed 1 entry per frame.

eg, you have targets A B C.

Frame 1 > get_intersection for A, await RenderingServer.FramePostDraw
Frame 2 > get_intersection for A, update A range, get_intersection B, await RenderingServer.FramePostDraw
Frame 3 > get_intersection for B, update B range, get_intersection C, await RenderingServer.FramePostDraw
Frame 4 > get_intersection for C, update C range,

etc

might take some jiggling to get the queue working nice, and it would require ensuring that nothing else calls the function after.

You could also duplicate how get_intersection works specifically just for targeting (tho you'd need a queue still - or setup multiple targeting viewports)

---

**xtarsia** - 2025-05-06 18:50

infact, doing a custom method, would let you include buildings and other objects in that check too

---

**jamonholmgren** - 2025-05-06 18:52

Generally I want a really fast check for terrain first, and if the terrain isn’t blocking, then I do a further check for trees and buildings and smoke and stuff.

---

**jamonholmgren** - 2025-05-06 18:52

Since terrain is the fastest check and most objects will be obscured by terrain

---

**jamonholmgren** - 2025-05-06 18:53

(aside: I’d like an occlusion culling feature that only looks at terrain, because that would help my game the most!)

---

**tranquilmarmot** - 2025-05-06 18:54

https://terrain3d.readthedocs.io/en/latest/docs/occlusion_culling.html#occlusion-culling

---

**biome** - 2025-05-06 19:01

is there any planned features to be able to switch out different autoshader materials per region instead of entire Terrain3D nodes?

---

**jamonholmgren** - 2025-05-06 19:04

I’m already using this but it’s collision based, not heightmap based

---

**glossydon** - 2025-05-06 19:51

Godot has been consistently closing itself whenever I try to manipulate the terrain. I don't know what could be going wrong, and the console doesn't really give me much to go off of at a first glance. I also don't see any relevant log files that illustrate the problem area.

📎 Attachment: image.png

---

**glossydon** - 2025-05-06 19:52

Is there maybe some way that adding textures to the terrain is causing this hitch? I only just recently started to encounter this problem when adding textures.

---

**glossydon** - 2025-05-06 20:02

I'm curious if maybe the resource for the region is maybe corrupt or something? It's just not behaving like it should. I can manipulate the triangles *around this patch*, but too close to the patch causes a crash.

📎 Attachment: weird_crash.mp4

---

**titnian** - 2025-05-06 20:43

reloading current scene is removing my terrain3D textures, can anyone help

---

**xtarsia** - 2025-05-06 20:48

click Terrain3D node > inspector > rendering > untick "free editor textures"

---

**waytoomellow** - 2025-05-07 01:25

hey there! Super noob question, just started out using the plugin, I cant seem to get the auto slope texture to work, from what I can tell my settings match the working example but cant get them to auto gen

📎 Attachment: image.png

---

**glossydon** - 2025-05-07 02:38

I think what's happening, now that I've looked deeper into things, is the region I'm editing has MMI data in it, but no mesh assets correspond to that MMI data. Because there's MMI data that corresponded to something, whenever I edit the heightmap, it seems like it wants to update the MMIs as well, but does it in a funky way that goes out-of-bounds because of memory shenanigans, then crashes.

Is there a way to remove MMI data from the resources externally? I've looked at the resources from the file system widget, but cannot just remove the data from there - everything's greyed out.

---

**adamz5k** - 2025-05-07 03:37

Hi there. I'm loving the tool, but I'm having a bit of an issue with lods, specifically custom lods. I can't tell if I'm just an idiot or if something's wrong, but I feel like I've been through the docs several times and I can't seem to figure this one out. For some reason a chunk's foliage seems to disappear when right in the middle of LODs. Normally, I overlap my lods with a dithering effect, but can't seem to get that working in Terrain3D. I also seem to only see one setting for each lod's range, though "range" seems to suggest that I should be seeing 2 settings (low and high)? I feel like I'm missing something obvious. Any help would be much appreciated.

📎 Attachment: LOD_Woes.png

---

**tokisangames** - 2025-05-07 03:50

No, but the shader is there as a base for you to customize to your own needs. Also you can manually paint via slope, so you don't need the autoshader at all in regions.

---

**tokisangames** - 2025-05-07 03:57

There are no chunks.
What versions? 
How wide is the area where LODs disappear?
Does it do the same with LODexample.tscn?
LODs are overlapped. Fading between them is broken on MMIs until it's fixed in the engine.

---

**tokisangames** - 2025-05-07 04:00

The material must be setup with the correct autoshader settings, and the ground must be painted with the autoshader tool. The autoshader debug view shows you where it is or is not.

---

**tokisangames** - 2025-05-07 04:05

What versions? How did you get your MMI data out of sync with your mesh assets? If that causes a crash I'd like to fix it, but I need specific data that causes a crash. Upload a problem region file.

---

**tokisangames** - 2025-05-07 04:05

Open up each region and look at instances. That has the instancer data. Just set it to an empty dictionary in a tool script and save it.

---

**tokisangames** - 2025-05-07 04:11

You don't want to go above 4000 iterations, multiple times per frame. Use GPU_mode or your own GPU camera(s) as Xtarsia mentioned. That is fastest, and is visual occlusion that only looks at terrain or anything on that rendering layer.

---

**adamz5k** - 2025-05-07 05:18

Sorry, don't know what I'm thinking: I'm on version 1.0.0 in Godot 4.4.1 - tried it on two separate win 11 computers (i913900/4090/128ddr5 & i512500/3090ti/32ddr5).
I meant the region (at least I think it's the region - it's the chunk of foliage being transitioned between lods) - in the  photo (taken from the demo project) you can see how it's a large square area - not sure how large. I was able to replicate it in the demo project with LODexample.tscn and I think I've found that it has to do with using a quadmesh billboard. Doesn't seem to be affecting any of the other mesh types (haven't tried imported GLB, but I'm assuming that would probably work).
 I definitely can see the overalapping most of the time, especially between meshes - but for some reason I'm consistently getting these blank spots when quadmeshes are involved.
Thanks for the info on fading, at least I know I'm not doing something wrong there.

📎 Attachment: lod_issue2.png

---

**tokisangames** - 2025-05-07 05:28

Turn on the region and instancer grids which will tell you right away whether the section in question is a region or instancer cell.

---

**tokisangames** - 2025-05-07 05:29

Lodexample doesn't have a quad mesh billboard. And the default quad mesh type doesn't have lods. So does it affect both of only the latter? I don't understand what you wrote on your observation or conclusion

---

**tokisangames** - 2025-05-07 05:59

You only have an issue in that one section? The same meshes work fine in other sections?

---

**jamonholmgren** - 2025-05-07 06:04

Yeah I might try the GPU method. I’m not running it every frame, actually every ~60-90 frames

---

**tokisangames** - 2025-05-07 06:11

One single call to get_intersection and await next frame, no code. Obvious choice.

---

**jamonholmgren** - 2025-05-07 06:12

This will work for up to 10k range?

---

**tokisangames** - 2025-05-07 06:14

It works as far as a camera can see

---

**jamonholmgren** - 2025-05-07 06:14

I also need to run it for every target; but I can offset the calls to only do one per 2 frames if need be.

---

**tokisangames** - 2025-05-07 06:14

One call per frame (maybe 2 to get the results next frame), per GPU camera setup. Make as many as you need.

---

**jamonholmgren** - 2025-05-07 06:15

Hm, that won’t work then. My view distance is adjustable by the user for performance reasons, but the 10k range is necessary for radar

---

**tokisangames** - 2025-05-07 06:15

What?

---

**tokisangames** - 2025-05-07 06:16

The player camera has nothing to do with this

---

**jamonholmgren** - 2025-05-07 06:16

What do you mean by “as far as a camera can see” then?

---

**tokisangames** - 2025-05-07 06:16

Camera3D.far_clip

---

**tokisangames** - 2025-05-07 06:16

A GPU camera can see as far as you set it to see.

---

**tokisangames** - 2025-05-07 06:17

The get_intersection() camera is set to 100,000.f, but that's arbitrary. We could be convinced to up that, but few people are even using double precision builds at the moment.

---

**jamonholmgren** - 2025-05-07 06:18

I’ll have to test, but I’m a little worried about adding more to the GPU which is already a bottleneck. I assume that it’ll render the scene to at least some degree. Seems like it would add a bunch to the GPU load? Could be wrong.

---

**tokisangames** - 2025-05-07 06:19

Again, What?
You're not concerned about upping the 4000 iterations up to 10,000 which will be slow, 10s of thousands of cycles, but are concerned about giving the GPU maybe 10 cycles of work?

---

**tokisangames** - 2025-05-07 06:21

Xtarsia and I both told you to use the GPU camera. Take our word for it. Why would you question that? Xtarsia is a low key shader genius.

---

**jamonholmgren** - 2025-05-07 06:21

Okay don’t be rude man

---

**tokisangames** - 2025-05-07 06:21

Not intending being rude or offend. Just honest advice.

---

**jamonholmgren** - 2025-05-07 06:22

First of all, I am not questioning Xtarsia or your abilities. You guys are great coders

---

**jamonholmgren** - 2025-05-07 06:23

I actually wrote my own raycast system in GDScript and achieved better than the built in raycast performance (on average), using just the heightmap

---

**jamonholmgren** - 2025-05-07 06:23

I thought your system might work similarly — so I wanted to switch to it.

---

**jamonholmgren** - 2025-05-07 06:24

(I’m not doing steps of 1, btw, since I don’t need that granular of raycast)

---

**tokisangames** - 2025-05-07 06:24

You should look at the get_intersection code. There's an obvious difference in design and operation speed between GPU mode and non. The latter is incredibly slow, in terms of cycles.

---

**jamonholmgren** - 2025-05-07 06:25

I will, for sure.

---

**tokisangames** - 2025-05-07 06:26

You also need to look at _setup_mouse_picking() and _destroy_mouse_picking()

---

**jamonholmgren** - 2025-05-07 06:27

The thing I dont quite understand (and you guys are definitely better at) is how the GPU rendering works, when it’s a separate camera like that.

For example, I have a FLIR camera that renders to a Sprite3D, and it definitely impacts GPU performance.

Wouldn’t this camera do the same? Or am I missing something?

Not trying to question your skills, just trying to learn.

---

**jamonholmgren** - 2025-05-07 06:28

And it’s fair to tell me to go look at the code. You don’t owe me any explanations. Just if you felt like it.

---

**jamonholmgren** - 2025-05-07 06:28

Believe me, I appreciate what you and Xtarsia and anyone else has done, you’ve helped make my game a lot better just by offering this terrain system!

---

**jamonholmgren** - 2025-05-07 06:31

As context, I’ve been coding for 32 years, but it’s mostly been back end server, web, and iOS / Android — very little game dev since I was a teenager in the 90s

---

**tokisangames** - 2025-05-07 06:35

Your FLIR camera probably renders to a viewport texture, which you have attached to a Sprite3D. Why is it a Sprite3D instead of a Control node on your hud? What's the viewport resolution? It shouldn't impact performance unless rendered at high resolution.
Our mouse camera is a 4 pixel viewport. Idk why not 1 pixel, 2x2 is probably the smallest I could make.

---

**jamonholmgren** - 2025-05-07 06:36

It is rendered on the Apache’s dashboard.

---

**jamonholmgren** - 2025-05-07 06:36

256x256 iirc, not at my computer right now.

---

**jamonholmgren** - 2025-05-07 06:37

4 pixel viewport makes sense. So, it is a very low cost! I wasn’t considering that you’d use a tiny pixel count.

---

**jamonholmgren** - 2025-05-07 06:39

(I might allow rendering to a control node for players that want to have the FLIR but have too slow of machines to render it on the dashboard effectively)

---

**jamonholmgren** - 2025-05-07 06:40

In this video you can see it in action. For example at 11 minutes in. https://youtu.be/hgONz2xwjpg?si=2XnSh1pMvxZtRCkK

---

**tokisangames** - 2025-05-07 06:40

Right, a few cycles on the GPU vs 10s of thousands when looping over 10,000 data lookups.

---

**tokisangames** - 2025-05-07 06:40

Sprite3D rendered in the 3D window makes sense.

---

**tokisangames** - 2025-05-07 06:42

But unless that's a 4k game, that's not 256x256 on screen. Could probably get away with 128 or 64. Maybe scaling up only if the user changes to 4k+.

---

**tokisangames** - 2025-05-07 06:42

You're not on our games list in the docs, but you should be.

---

**tokisangames** - 2025-05-07 06:44

Looks like a fun game. I loved the original comanche game.

---

**jamonholmgren** - 2025-05-07 06:45

FYI it would probably only be up to 100 iteration loops. I go in 100m increments in my custom raycast. If it doesn’t detect any terrain it does a second more costly raycast that checks for trees and buildings (AND terrain). The reason is I don’t want to do the expensive raycast if it’s just behind a hill anyway — no sense in checking for trees and buildings if there’s a massive mountain in the way 😂

---

**jamonholmgren** - 2025-05-07 06:46

I appreciate that a lot! And yeah, Comanche was a big inspiration, along with Gunship 2000, Battlefield Vietnam, and others

---

**jamonholmgren** - 2025-05-07 06:47

I’ll submit something soon, for sure. Wanted to get further along before I did but it’s getting there.

---

**tokisangames** - 2025-05-07 06:47

You have pointy landscape and floating trees. Did you set your camera in the terrain? Do you get errors that terrain3D Can't find the camera? Or maybe you need to up your mesh size and/or lod count.

---

**jamonholmgren** - 2025-05-07 06:48

Yeah you helped me with this before (thanks) but I fixed it after the video was shot

---

**tokisangames** - 2025-05-07 06:48

12:03, 12:16

📎 Attachment: 995EF5DB-020C-4B8D-8D52-A67819069029.png

---

**jamonholmgren** - 2025-05-07 06:51

The terrain LOD / mesh size is going to be adjustable by the player to allow for much older computers to play, one thing I am really trying to achieve is making it so people without gaming computers can play it. It’s multiplayer so for example I might want to play with my buddies who don’t have gaming rigs but have some average laptops. So far, so good — can run at 60fps+ on some fairly average hardware.

---

**jamonholmgren** - 2025-05-07 06:51

And then it can be adjusted for high fidelity for gaming rigs

---

**jamonholmgren** - 2025-05-07 06:52

Excited to try the GPU method tomorrow and see how it goes! Thanks <@455610038350774273> !

---

**jamonholmgren** - 2025-05-07 06:52

Oh btw — I’m deving on a 5k display actually lol

---

**ne_ergo** - 2025-05-07 08:52

Is there a way to paint all height zero a certain color

---

**ne_ergo** - 2025-05-07 09:42

Kinda like the autoshader but painting everything height 0 or below some texture, and the not paint everything above that

---

**image_not_found** - 2025-05-07 09:44

Using a custom shader would work, though idk if there's a better way to go about it

---

**image_not_found** - 2025-05-07 09:44

By default, if the custom shader field is empty and you enable shader override, Terrain3D creates one with the shader it's actually using

---

**image_not_found** - 2025-05-07 09:44

So you can use that as a starting point and edit it

---

**ne_ergo** - 2025-05-07 09:50

Thanks, I did that, however I dont understand the code enough to be able to edit it to do what I want, I'll keep learning

---

**bokehblaze** - 2025-05-07 13:26

The terrain3d tab isnt appearing at the bottom anymore

📎 Attachment: image.png

---

**tokisangames** - 2025-05-07 13:40

Enable the plugin

---

**bokehblaze** - 2025-05-07 13:40

It is enabled

---

**tokisangames** - 2025-05-07 13:47

Which versions of Godot, Terrain3D?
What does your console report from the beginning?

---

**xtarsia** - 2025-05-07 13:49

possible it got moved to a different pannel?

---

**tokisangames** - 2025-05-07 13:49

Oh yeah, you can move it to any sidebar.

---

**tokisangames** - 2025-05-07 13:50

Show a full screen snapshot

---

**bokehblaze** - 2025-05-07 13:55

Running on Godot 4.4 with Terrain3D 1.0

📎 Attachment: image.png

---

**tokisangames** - 2025-05-07 13:56

Top left corner

---

**bokehblaze** - 2025-05-07 13:58

i need the tab where you can change textures and meshes, i cant do it from the inspector as they seem uneditable here

📎 Attachment: image.png

---

**tokisangames** - 2025-05-07 13:58

That is the right side. Top left is the other side.

---

**bokehblaze** - 2025-05-07 13:59

It isnt showing here

📎 Attachment: image.png

---

**tokisangames** - 2025-05-07 14:00

That's the middle. Top LEFT

---

**bokehblaze** - 2025-05-07 14:00

Ohh i see it now XD

---

**bokehblaze** - 2025-05-07 14:00

sorry im blind

---

**bokehblaze** - 2025-05-07 14:00

Thank you❤️ 🫶

---

**adamz5k** - 2025-05-07 14:09

It's definitely the instancer grid. 
Yes, the quadmesh doesn't have LODs, but it does have visibility range. The intent is to use the quadmesh as the furthest lod distance, displaying a low-res billboard image of the object. Normally, I'd manually hide the object mesh at something like 500, while showing the quadmesh billboard at the same time, using the visibility range feature. When I attempt to do this with Terrain3D's automatic LOD tool, that's where I'm getting this disappearing instancer grid issue.
I know that lodexample doesn't have a quad mesh billboard - I put one in there to see if that was the issue: When I was testing the demo project against my own project, I noticed that my custom lod contained a quad mesh billboard while lodexample didn't. Lodexample worked flawlessly in its default form. So, I swapped the orange box in Meshinstance3D2 with a quadmesh billboard. When I tested lodexample in the modified form (with the meshinstance3D2 quadmesh), the problem was now present in the demo project as well.

---

**tokisangames** - 2025-05-07 14:12

Is it only an issue with the cell you marked in red, or all cells?

---

**tokisangames** - 2025-05-07 14:14

It's an issue when you make a Godot QuadMesh in any lod lower than 0?
Can you reproduce it with the default Quad Mesh made by Terrain3D in lod0?
Can you reproduce it with your own QuadMesh in lod0?

---

**tokisangames** - 2025-05-07 14:17

To recap, the issue is that the QuadMesh disappears when exactly? At the beginning or ending edge of lod ranges for only a few cm, or through the entire lod range until the next lod, or when?

---

**adamz5k** - 2025-05-07 14:28

It affects multiple cells, but it's somewhat hard to pin down, so I can't say for 100% certainty that all cells are/can-be affected. You need to get right in between 2 lods (a few cm), and it doesn't seem to affect all instancer grid cells every time (but it is happening with enough frequency that I can reproduce it within 1 minute).
It's an issue with Quadmesh at any lod level.
Yes, reproduced with the default quad mesh (with no billboard/texture) made by terrain3d in lod0
Yes, reproduced with my own quadmesh (with billboard/texture) in lod0.
Disappears right in the center of two lod ranges, for a few cm.

---

**tokisangames** - 2025-05-07 14:43

> Yes, reproduced with the default quad mesh (with no billboard/texture) made by terrain3d in lod0
How did you do that, since the built in one has only one lod?

---

**tokisangames** - 2025-05-07 14:43

What if you import a plane made in blender, so Godot treats it like an ArrayMesh?

---

**tokisangames** - 2025-05-07 14:44

What about a very thin BoxMesh?

---

**tokisangames** - 2025-05-07 14:45

> You need to get right in between 2 lods (a few cm)
If the Quadmesh is LOD1, and other meshes on LOD0 and LOD2, can it be reproduced on the border between both LOD0 and 2 or just one?

---

**tokisangames** - 2025-05-07 14:48

> Disappears right in the center of two lod ranges, for a few cm.
You mean the edge, right? If the lod ranges are 50m, 100m, 150m, it disappears when the camera is 50m, 100m, or 150m from the instance on the border between the QuadMesh and any other type of mesh. NOT at a distance of 75m or 125m?

---

**catgamedev** - 2025-05-07 15:36

Hiya, testing out Terrain3D today and I've bumped into a few noobie confusions:

1) Where is the `grab_camera: Cannot find the active camera` thing mentioned in the documentation? I guess we need to give Terrain3D a camera reference, but I seem to have overlooked that 

2) (edit: actually, this may just be broken behavior due to the missing camera error) When unloading/reloading a level with Terrain3D, the material is not restored-- it's just an empty checkered material. Does this sound like a familiar problem?

---

**glossydon** - 2025-05-07 15:42

Hope you don't mind the ping.

This region in particular has a lot of instances, none of which I can see or manipulate from within the editor.

📎 Attachment: terrain3d-02-03.res

---

**xtarsia** - 2025-05-07 15:44

1. if the terrain node is loaded before any camera, then the camera will need setting manually with set_camera(camera)

2. under rendering in the terrain3d node inspector, un-tick "free editor textures"

---

**catgamedev** - 2025-05-07 15:46

I see, thank you!

---

**tokisangames** - 2025-05-07 16:01

I can look at the file, but it won't reveal any bug without answers to my questions.

---

**veganprep** - 2025-05-07 16:15

Good morning all! I remember hearing in a Terrain3D video (can't remember which one) that using Noise as a World Background is not recommended due to the performance cost. Am I remembering that correctly and I shouldn't use Noise for a World Background? Would it cost less performance wise to create new regions that cannot be navigated by players that have mountains instead of generating Noise?

---

**glossydon** - 2025-05-07 16:16

Right, I'm not entirely certain I remember exactly how, but I did iterate a few times on grass. I didn't know you could erase by holding control, so I would just delete the Mesh asset to remove the instances.
I'm on Godot 4.4.1 Standard, Terrain3D 1.0.

---

**xtarsia** - 2025-05-07 16:23

its a fair bit cheaper now than it used to be. Test by switching between  BG modes and decide what suits your needs, adding a ton of regions will come with VRAM costs. The other suggestion (as per the docs) is to use actual mountain meshes, and set bg mode to none.

---

**glossydon** - 2025-05-07 16:55

In the event that someone else runs into the same issue I did, phantom MMIs can be taken care of with a script like this:
```swift
@tool
extends Terrain3D
func _ready():
    var regions := self.data.get_regions_active()
    for region in regions:
        region.instances = {}
        region.modified = true
```
Attach this to the Terrain3D node that has problematic regions, and this will wipe all of the MMIs from all regions. **Don't attach this unless you *really* wanna get rid of asset-less MMI data!**

---

**adamz5k** - 2025-05-07 17:09

> How did you do that, since the built in one has only one lod? 
I feel like we're not on the same page with this one. I'm not talking about lod0 on a quad mesh. I'm talking about a terrain2d foliage scene where a quad mesh is placed in the lod0 slot.
> What if you import a plane made in blender, so Godot treats it like an ArrayMesh? 
This seems to also have the same issue
> If the Quadmesh is LOD1, and other meshes on LOD0 and LOD2, can it be reproduced on the border between both LOD0 and 2 or just one?
Both
> You mean the edge, right? If the lod ranges are 50m, 100m, 150m, it disappears when the camera is 50m, 100m, or 150m
Correct

I did a few more tests, and here's what I found:
-Any arraymesh imported from blender, via GLB, seems to also have this issue (I made sure to disable all LOD generation when importing). Though, and this is the weird part, I can only seem to replicate the issue if the mesh with more polygons is in a closer lod slot. 
    -Like if it goes: LOD0 (100tris) LOD1(50tris) LOD2(25 tris) then I still see the problem. 
    -But, if I rearrange it like this then the problem goes away: LOD0(25tris) LOD1(50tris) LOD2(100tris). (Obviously this is reverse to how you'd want a lod to work.)
-If I replaced the default quadmesh with a default planemesh, then the problem is still persistent, though a little more understated (smaller cm area of effect).
-The default godot shapes seem to not be affected.

---

**tokisangames** - 2025-05-07 18:26

> -The default godot shapes seem to not be affected. 
BoxMesh and the 3D shapes are unaffected, QuadMesh and PlaneMesh are affected. Is this true even for a really thin box mesh, like 0.1 or 0.01?
> I can only seem to replicate the issue if the mesh with more polygons is in a closer lod slot. 
This is likely a red herring. They are individual MMIs with independent data and no relation to each other.

---

**tokisangames** - 2025-05-07 18:27

You may have discovered a bug in Godot MMIs. Presumably that the visibility ranges are narrower than normal with flat shapes. Perhaps they are affected by the lack of AABBs. The next things to test are:
1. Connect to one of the MMIs in the running tree that you can visually identify and manually adjust the lod ranges of the quad mesh lod to a larger range than normal.
2. Add a custom AABB to the QuadMesh mesh instance that is > 0 on all sides.

---

**tokisangames** - 2025-05-07 18:58

There's nothing wrong with this file. The height loads fine and there are 9064 instances in it tied to mesh id 1, which I can add to or remove. Yours are shown in this pic. I don't have any crashes.

📎 Attachment: EBB06348-00A8-40E6-BCD5-B1937A42A22D.png

---

**tokisangames** - 2025-05-07 18:59

Unless you can make an MRP, a reproducable action or identify what you did, I can't do anything with this. There may be a crash bug in 1.0, that was already fixed in 1.1-dev.

---

**glossydon** - 2025-05-07 19:02

I see, apologies for not being of much help. Either way, it looks like if you don't have any issues, and if you're on a later version, things might be fixed there?

---

**catgamedev** - 2025-05-07 19:47

How are people currently handling grass for terrain? 

I see that it's something that might be added to terrain3d itself, but not yet?

Are tools like Scatter and SimpleGrassTextured still the way to go?

---

**tokisangames** - 2025-05-07 20:02

Either use the grass particle shader in nightly builds, or paint it with the instancer. Scatter would be the worst option. No need for another tool.

---

**adamz5k** - 2025-05-07 20:03

> Is this true even for a really thin box mesh, like 0.1 or 0.01?
It is! When I squish a box mesh down it seems to start to affect it when it's around 0.3 and below.
> manually adjust the lod ranges of the quad mesh lod to a larger range than normal.
When I modify the "visibility range begin" setting in the remote scene tree, it seems to completely fix the issue if I decrease visibility range begin to about 0.3
> Add a custom AABB to the QuadMesh mesh instance that is > 0 on all sides.
This seemed to have no effect, other than making the quadmesh visible at all times.

---

**tokisangames** - 2025-05-07 20:10

> When I modify the "visibility range begin" setting in the remote scene tree, it seems to completely fix the issue if I decrease visibility range begin to about 0.3
I don't understand this. If we're talking say LOD0 50m range, LOD1 100m, LOD2 150m, and the QuadMesh is in LOD1, LOD0 would actually be configured for 0-50.025. LOD1 is set to 50-100.05, LOD2 is set for 100-150.075. What did you do with 0.3?

---

**adamz5k** - 2025-05-07 22:18

Here's a screenshot of what I'm seeing by default, as well as the modification inside the inspector. I am also confused by this, because you can clearly see that LOD0 VRE is at 128.06 and LOD1 VRB is at 128.0, so there must be some overlap. But this just isn't what I'm visually seeing with very flat things (or some lower-res imports, for some reason).
The modification of LOD1 VRB to 127.7 seems to fix the problem, as does changing LOD0 VRE to 128.36.

📎 Attachment: lod_screenshot.png

---

**tokisangames** - 2025-05-07 23:59

Great thanks for testing. The bug is in the MMIs not handling planes probably due to AABB as noted. It's probably safe to assume only the last lod may be a billboard, so we can extend the second to last lod a little farther.

---

**tokisangames** - 2025-05-08 00:07

If you want to take a crack at fixing it, it won't be hard.
https://github.com/TokisanGames/Terrain3D/issues/691

---

**adamz5k** - 2025-05-08 00:09

I'll take a look. Thanks for your time.

---

**jacc_00657** - 2025-05-08 14:23

Hi, the visibility range option does not show up in the inspector of a scene mesh, it has been removed or moved to another node?

📎 Attachment: image.png

---

**tokisangames** - 2025-05-08 14:31

expand lods

---

**catgamedev** - 2025-05-08 15:40

Would it be common for a project to include SimpleGrassTextured as well as the grass option in Terrain3D? For example, we may want to paint grass on a mesh object.

Is the nightly build stable/recommended for use yet? Any idea for how long until grass is merged into a stable release?

---

**adamz5k** - 2025-05-08 15:40

Hey, I did a little more testing this morning and I found that if I added a custom AABB to BOTH interacting LODs that the visibility gap goes away. I feel a little foolish that I only tested a custom AABB on just the quadmesh. I put custom AABBs on every custom LOD level in my test scenes and now I'm experience 0 issues.

---

**tokisangames** - 2025-05-08 16:18

Nightly builds are the main dev tree. Never recommended for production. Fine for self supporting devs. Stable builds are released in 4-6 months cycles.

---

**tokisangames** - 2025-05-08 16:18

Use any plugin you like. But having three systems for foliage is a waste of resources. Better to just add a PR to let our instancer add on any mesh, which is on the feature list waiting for someone to implement.

---

**tokisangames** - 2025-05-08 16:20

Odd. 3D meshes should already have AABBs. Check a 3D mesh AABB before and after adding the custom AABB, and setting the custom to the same as the regular. See if there's a difference with the MMI.

---

**catgamedev** - 2025-05-08 16:21

That sounds like a nice feature request. I'm testing out the latest nightly build now, seems to work fine!

---

**adamz5k** - 2025-05-08 18:17

I'm not sure if I can't find it, but there doesn't seem to be a way to verify the current AABB without just trusting that the custom AABB is being applied (I'm assuming it is, because I'm seeing a change), as get_aabb() always returns the default value. That said, as expected, the depth of flat objects is 0. 

However, the width and depth of meshes appear to be smaller than mesh's actual size, depending on the mesh in question. For example: a default sphere's default aabb is reported as about 0.11% smaller than the actual size. Some of my more complex meshes (imported in glb format) appear to be ~0.25% smaller than the actual size. I do kind-of recall (and this is currently confirmed with testing) that I had way fewer problems when one of the transition meshes was just a cube, so perhaps this sizing disparity is what was causing the issue, since it all seems to go away when I force all LODs to have the exact same AABB.

---

**tokisangames** - 2025-05-08 19:01

Get_aabb is not affected by custom_aabb.  https://docs.godotengine.org/en/stable/classes/class_mesh.html#class-mesh-method-get-aabb

---

**adamz5k** - 2025-05-08 19:13

Yeah, I know. I just couldn't find a way to return the current active aabb, rather than just one or the other.

---

**catgamedev** - 2025-05-08 20:18

Is there a way to prevent grass beneath a given threshold?

📎 Attachment: image.png

---

**xtarsia** - 2025-05-08 20:43

is that the particle grass?

---

**catgamedev** - 2025-05-08 20:46

yea

---

**xtarsia** - 2025-05-08 20:52

```glsl
    float max_height = 100.;
    float dither_distance = 100.0; // +- 50m
    if (pos.y > max_height + (r.y - 0.5) * dither_distance) {
        pos.y = 0. / 0.;
        pos.xz = vec2(100000.0);
    }
```

add to the particles.gdshader before //Apply Scale

---

**xtarsia** - 2025-05-08 20:52

or rather, min_height and < operator lol

---

**catgamedev** - 2025-05-08 21:03

simple fix there isn't it, thank you

📎 Attachment: image.png

---

**catgamedev** - 2025-05-08 21:03

intentional division by zero.. this is why no one likes graphics programming

---

**vhsotter** - 2025-05-08 21:08

A zero divided by zero, too. So that makes it extra fun.

---

**catgamedev** - 2025-05-08 21:08

pure madness

---

**catgamedev** - 2025-05-08 21:12

This seems to work really well, I think I'll try to add this to my main project now 🧐...

📎 Attachment: image.png

---

**fload1337** - 2025-05-09 02:31

Is there a way to import a terrain mesh I created in blender? Currently attempted to create a height map with shader in blender and it 90% worked but just didn't know if I missed something easier like directly importing the mesh? Sorry new to godot

---

**adamz5k** - 2025-05-09 02:41

What didn't work? It took some fiddling to get mine to work, but my heightmap exr works quite well.

---

**fload1337** - 2025-05-09 02:42

Well it's a bit jagged but I think I can clean it up with just using the smooth tool but I also need to play with scale and just thought maybe there's a better way that preserves the scale

---

**catgamedev** - 2025-05-09 03:14

https://discord.com/channels/691957978680786944/858020926096146484/1353833056313806940

---

**iolechka** - 2025-05-09 06:51

Hey
I'm currently playing with the plugin, and how do I see wetness? Grass is overlay and dirt is painted texture. Both have roughness set to 0.0 in texture settings. Screenshot 1 is how it looks, and screenshot 2 is roughness map view. 

I only managed to deduce that for some reason wetness gets visible on texture only if I have roughness at less than 0.0 in that texture settings.

📎 Attachment: image.png

---

**titnian** - 2025-05-09 07:21

how do you make the terrain more chunky or blocky? is it possible?

---

**tokisangames** - 2025-05-09 07:28

No, but as a gamedev you can easily create a heightmap with a simple script running raycast on a 1m grid in Godot and either making an Image or using our data.set_height()

---

**tokisangames** - 2025-05-09 07:30

Read Tips on lowpoly

---

**tokisangames** - 2025-05-09 09:36

The Roughness toolbar setting is a modifier for the roughness built into your textures. 0 means use your textures as they are. The default for the wetness brush is -60%. To see wetness modify your roughness textures to significantly below 0, disable unshaded, and have a reflected light. If you skipped roughness textures, I don't know what will happen, but you probably won't get the expected results.

📎 Attachment: 099FE8D0-011B-49D9-9A20-6D72F5CD2173.png

---

**iolechka** - 2025-05-09 11:13

This is what happens without roughness texture (on left is Wetness with roughness -100%, and on right it's +100%) with a directional sunlight
Though I can't see where to put a dedicated roughness texture, there is just no Property in inspector to put it into?

📎 Attachment: image.png

---

**xtarsia** - 2025-05-09 11:14

The roughness texture should be packed (by you) into the normal texture alpha channel.

You can use the channel packer tool to it.

---

**iolechka** - 2025-05-09 11:17

Oh okay! It works now, though I'll have to play with it a bit more to understand how it works
Thank you everyone

---

**tokisangames** - 2025-05-09 12:07

You should also read the docs and watch the tutorial videos.

---

**iolechka** - 2025-05-09 12:53

That's true, but I just like messing around before using new tools 😄

---

**aryamon** - 2025-05-09 15:33

hmm when i paint tree scenes using the instance meshes

---

**aryamon** - 2025-05-09 15:33

is there a way to keep

---

**aryamon** - 2025-05-09 15:33

collisions

---

**aryamon** - 2025-05-09 15:39

actully ignroe my qn

---

**aryamon** - 2025-05-09 15:39

just read about multi meshes

---

**catgamedev** - 2025-05-09 16:26

Similar to this question-- I'm wondering how people are thinking about the Autoshader.

Is it meant to be a fairly simple tool?

Or are more features for it planned?

For example, it would be nice to have:

1) Base texture: Dirt
2) Underwater texture: Sand
3) Sloped texture: Cliff

---

**catgamedev** - 2025-05-09 16:27

.. but this train of thought could lead to endless feature creep. The other terrain tool I'm familiar with is Gaia, which implements rules for texture and mesh placement. It's a great tool, but something that large should probably be a separate plugin

---

**xtarsia** - 2025-05-09 16:42

I have a rough mockup of gpu painting, and its fast enough to process entire 2k regions with as complicated rule setups as one might possibly need, based on the existing data (height, surface angle, current control map, color map)  in less than 1ms per map.

when i get back to it (after fixing the current blending) I actually thought a bit about removing the current auto shader from the main shader entirely, and make it part of the sculpting process, where it will just update the control map data directly as you you paint / sculpt

the auto shader would then only exist on the control map, and potentially could be expanded to allow multiple "magic materials" which would be configured by customising a base template shader include that would be used when updating areas.

or something like that...

---

**xtarsia** - 2025-05-09 16:48

the downside would be when painting auto shader like that, it would overwrite the existing texture ids and blend value, but thats sort of what the undo system is for anyways..

---

**catgamedev** - 2025-05-09 16:49

so there are lots of features planned 👀

---

**xtarsia** - 2025-05-09 16:52

then following on from that... somethings might get moved to a data map, which the auto shader bit could actually be on if its not needed in the main shader any more.

from there, it could be expanded to multiple "magic materials" configured as shaderinclude (from a default templates) for the gpu-painting process.. etc

ofc getting from idea to actual polished usable feature is the hard part..

---

**catgamedev** - 2025-05-09 16:56

Well, from my perspective, I'm amazed at the number of features already working. Keep it simple if you can would be what I'd say, there's already a lot here to make use of!

---

**catgamedev** - 2025-05-09 16:57

this thing even shows us contour lines, that's so cool 😆

---

**Deleted User** - 2025-05-09 17:58

hello, is the occlusion feature working? i was noticing, that godot instantly crashes when enabling it after baking the occlusion map. for testing i created a new clean project and just raised some small hills, enabling occlusion and baking crashes godot every single time.

---

**kamazs** - 2025-05-09 18:46

it seems to work for me

---

**tokisangames** - 2025-05-09 18:51

Yes works fine. We can troubleshoot your crashing issue separately, starting with information about your setup and versions.

---

**Deleted User** - 2025-05-09 18:54

no problem. I'm using Godot 4.4.1 on Arch Linux. Graphic card is Nvidia 4090 with the 570.144 driver. I just loaded the newest Terrain3d Plugin from the asset library

---

**Deleted User** - 2025-05-09 18:54

CPU: Ryzen 9 7950X3D

---

**Deleted User** - 2025-05-09 18:57

you can the the violet lines in the background, seems to be the occlusion mesh. after activating occlusion in the project settings, godot just crashes. same with the clean new godot file with a simple terrain

📎 Attachment: image.png

---

**tokisangames** - 2025-05-09 19:14

So Terrain3D is working fine. We don't handle occlusion, we just provide the mesh to the occlusion baker, which you can see is already done. Troubleshoot Godot for why it's crashing. e.g. 
* Remove Terrain3D from your scene, keep the occluder and test that. 
* Make a simple scene w/ meshes and bake occluders to test.
* Build a debug version of godot and debug where its crashing.
* Search bug reports, or file a new one with an MRP.

---

**catgamedev** - 2025-05-09 19:16

I seem to have found a way to tank my FPS. 

I've watched the texture painting tutorial video again and you mention to be careful about painting overlay onto a base texture to avoid artifacts, but performance isn't mentioned?

Does it look like I've done something wrong here? I was pretty careless about spraying overlay textures here, but visually I don't mind.

📎 Attachment: image.png

---

**catgamedev** - 2025-05-09 19:17

without the debug view, I have 8 textures here

📎 Attachment: image.png

---

**Deleted User** - 2025-05-09 19:17

alright, thank you!

---

**xtarsia** - 2025-05-09 19:23

The shader has some branching that will skip texture reads when the blend value would mean that it isn't possible for it to be visible.

Having lots of transitions will increase lookups.

It shouldn't "tank" tho..

---

**xtarsia** - 2025-05-09 19:24

What numbers are you seeing?

---

**catgamedev** - 2025-05-09 19:26

hmm, stable 60

---

**catgamedev** - 2025-05-09 19:27

I restarted Godot and it's fine now, confusing!

---

**catgamedev** - 2025-05-09 19:27

I may have overflowed my gpu's memory, I only have 6gb and I have a ton of stuff open

---

**catgamedev** - 2025-05-09 19:27

sorry :p

---

**xtarsia** - 2025-05-09 19:28

All good, it's easy to blow past ram/vram limits when doing game dev

---

**biome** - 2025-05-09 19:31

`  ERROR: core/variant/variant_utility.cpp:1098 - Terrain3DData#2747:import_images: (1408, 2048) image will not fit at (0.0, 0.0, 0.0). Try (0, 0) to center`

I'm trying to export a terrain that uses 0.7 vertex spacing and trying to import it to use 1.0 import scale, but this error shows up every timei try. I suspect that 0, 0, 0 is actually pretty close to 0, 0

---

**biome** - 2025-05-09 19:53

is there a way to reconcile terrain3dassets? I want to unify them between two terrain3d in two different scenes, but the textures are in a different order

---

**biome** - 2025-05-09 19:53

changing the terrain3dasset obviously changes which texture is on the terrain itself, but i dont think i can change the id without it flipping on the other terrain itself?

---

**xtarsia** - 2025-05-09 19:56

you'd need a toolscript to modify one of the 2 sets of regions control maps to translate the texture IDs to match the final asset ids

---

**xtarsia** - 2025-05-09 19:56

100% back things up.

---

**catgamedev** - 2025-05-09 20:13

Sorry for all the questions today, finally have a moment to learn how to use this:

I've set up the particle grass in a sandbox project and it works fine.

However, when I set up particle grass in another project, I get the behavior as is shown in attachment. As far as I can tell, everything is set up identical, so I'm quite confused. I must have missed something.

Does this look familiar?

(edit: In case anyone searches and finds this, make sure to disable Physics Interpolation in project settings, or account for it accordingly in your scripts.

📎 Attachment: 2025-05-09_16-12-18.mp4

---

**xtarsia** - 2025-05-09 20:14

is the main node is attached to the camera?

---

**catgamedev** - 2025-05-09 20:15

Hmm, what do you mean by main node?

My main (only) Camera3D node is child to an Autoload. My player spawns in with a PhantomCamera node on a spring arm, and is given highest priority.

---

**tokisangames** - 2025-05-09 20:21

What settings are you using to import?

---

**tokisangames** - 2025-05-09 20:21

Save the asset list to a file. All of those assets are resources for a reason.

---

**tokisangames** - 2025-05-09 20:22

To change the ID on the terrain repaint it or use the API

---

**tokisangames** - 2025-05-09 20:22

terrain.set_camera()

---

**biome** - 2025-05-09 20:22

0.7 spacing export, no other settings changed, using an .exr as a heightmap, then 1.0 spacing import (also no other settings changed) using that terrain heightmap

---

**tokisangames** - 2025-05-09 20:24

Vertex spacing doesn't matter for import, export or memory

---

**tokisangames** - 2025-05-09 20:24

What parameters did you put into the importer inspector?

---

**tokisangames** - 2025-05-09 20:24

What is your region size?

---

**tokisangames** - 2025-05-09 20:26

The exr is 1408x2048?

---

**biome** - 2025-05-09 20:28

I might be encountering the XY problem here. I'm trying to increase the vertex spacing from 0.7 to 1.0 while keeping the terrain height in the same "relative" place. I misunderstood the last line of the vertex_spacing documentation about scaling heights, which is not what i want to do.

---

**tokisangames** - 2025-05-09 20:30

Vertex spacing laterally scales how the data is rendered. It doesn't change the data, so has zero impact on the function of import or export.

---

**tokisangames** - 2025-05-09 20:30

There is no Y parameter for the importer location, only X and Z.

---

**tokisangames** - 2025-05-09 20:31

Anyway, do you have it working now?

---

**biome** - 2025-05-09 20:33

Yes I understand that now, is there any way to do what I'm describing?

---

**biome** - 2025-05-09 20:33

no longer needed with import/export

---

**tokisangames** - 2025-05-09 20:53

I don't understand where you're at since you haven't answered my questions.
Changing import (vertical) scale via export/import in order to account for the change in vertex_spacing is correct.

---

**reidhannaford** - 2025-05-09 21:31

Hey all – I'm experiencing an issue where if the player is loaded into the scene using a script (rather than being placed into the scene manually) there are no collisions on the terrain on load.

I assume this is because the camera is a child of the player, and I'm getting the error that Terrain3D cannot find the active camera. When I run the scene.

I'm attempting to use `Terrain3D.set_camera()` in my player spawner script to manually set the camera on the terrain after the player spawns, as is suggested by the error message, but it doesn't seem to be working to re-enable the collisions.

Any idea whats going on?

---

**reidhannaford** - 2025-05-09 21:42

Update: ok turns out its because the camera isn't initialized yet in the spawner script. I can move the `Terrain3D.set_camera()` function to the player script and it works, but since the player now needs a dynamic reference to the terrain, I'm using a `get_tree().get_first_node_in_group("terrain")` which feels a bit messy to me.

Is there a better way to grab a reference to the terrain?

---

**tokisangames** - 2025-05-09 22:31

Lots and lots of ways to do this in Godot. We have an autoload class with globals for both the player and terrain, each sets its own reference on load.

---

**eng_scott** - 2025-05-10 02:15

Since im on the struggle bus. is there a way to make the brushes create a move blocky plane. like disable smoothing? and do hard angles? trying to see if i can make this work for a retro art style.

---

**rasho.711** - 2025-05-10 09:27

hi i have this sandy texture rn in but if i want to use another one this happens:

how can i use the 2nd one?

📎 Attachment: image.png

---

**tokisangames** - 2025-05-10 10:37

A pending PR will make that easier to do

---

**tokisangames** - 2025-05-10 10:39

Add in a normal/roughness map, and make sure all sizes and formats match as the docs say

---

**rasho.711** - 2025-05-10 10:40

just did dont work

---

**tokisangames** - 2025-05-10 10:41

It works for thousands of people. We can help you if you get specific on the error messages in your console and the formats and construction of your textures

---

**tokisangames** - 2025-05-10 10:43

Double click your texture files and report their size and format in the inspector

---

**rasho.711** - 2025-05-10 10:44

i first used 1k texture as 2nd

---

**rasho.711** - 2025-05-10 10:44

lemme try 2k

---

**rasho.711** - 2025-05-10 10:53

nvm  dont work

---

**rasho.711** - 2025-05-10 10:53

ill just use a csgmesh

---

**tokisangames** - 2025-05-10 10:57

Tell us the size and format of your textures as reported by your inspector

---

**rasho.711** - 2025-05-10 10:58

you mean this?

📎 Attachment: image.png

---

**rasho.711** - 2025-05-10 11:00

i used the 2 in the bottom

---

**tokisangames** - 2025-05-10 11:09

For all four texture files you are adding to Terrain3D, double click them and report what your inspector shows.

---

**rasho.711** - 2025-05-10 11:10

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-05-10 11:12

??

---

**tokisangames** - 2025-05-10 11:13

Double click the 4 files you're using here in this panel

---

**rasho.711** - 2025-05-10 11:14

*(no text content)*

📎 Attachment: image.png

---

**rasho.711** - 2025-05-10 11:14

*(no text content)*

📎 Attachment: image.png

---

**rasho.711** - 2025-05-10 11:14

sry ig this is it

---

**tokisangames** - 2025-05-10 11:15

You can see the last two don't match the first two.

---

**tokisangames** - 2025-05-10 11:16

Your GPU requires them to match as the docs and I have been telling you

---

**rasho.711** - 2025-05-10 11:16

ye one is dxt5 and one is bptc

---

**tokisangames** - 2025-05-10 11:16

If they are png files, the latter are imported with HQ

---

**rasho.711** - 2025-05-10 11:18

i seeeee

---

**rasho.711** - 2025-05-10 11:18

now its working

---

**rasho.711** - 2025-05-10 11:18

thanks

---

**eng_scott** - 2025-05-10 12:37

Which pr number?

---

**tokisangames** - 2025-05-10 12:37

There's only 4, the one from Xtarsia

---

**eng_scott** - 2025-05-10 13:01

Thanks sorry was on phone couldn't look easily ill keep my eyes out!

---

**gadforgedstudios** - 2025-05-10 17:59

Hey everyone, I am pretty new to using godot and this plugin. I am trying to use terrain3d to import a world map I generated using a program I wrote to run outside of godot.

While I can load in the heightmap and colormap just fine as shown on the image above. I am having trouble with the control map.

I have my texture id's and other details mapped into the control map format from the documentation but I can't seem to get that packed into an exr file that the tools will interpret.

Can someone please explain how I can generate that control_map exr file?

📎 Attachment: image.png

---

**tokisangames** - 2025-05-10 21:56

Paint a map in the demo and export it so you have a working example. The format is an integer bitfield stored in a 32-bit float. Load the float, interpret the memory as an int, and extract the bits to read, or the opposite to write. You already saw the format in the docs, as well as conversion utilities in Terrain3DUtil. If needed, look at the C++ to see how it works.

---

**inkrobert** - 2025-05-11 09:03

Hi, sorry if my question is silly or has already been asked here, but I need some help:
I want to make the player's footstep sounds depend on the texture they’re currently walking on.
I have a raycast that can detect what's under the player, but I don't know how to determine which specific texture in the terrain is currently beneath them

---

**xtarsia** - 2025-05-11 09:48

Terrain.data.get_texture_id(global position) iirc

---

**reidhannaford** - 2025-05-11 13:01

Hi all - having some trouble with render layers.

I have a spot light here that I do not want to affect the terrain. I have the light set to cull layer 1, and as you can see this is working fine with the grass and the cube mesh that are on layer 1 - no light on those objects.

For some reason though, the light is still affecting the terrain, despite that also being on layer 1. Am I doing something wrong here?

📎 Attachment: image.png

---

**tokisangames** - 2025-05-11 13:15

Your spot light is on layer 32. Unset it by code.
https://terrain3d.readthedocs.io/en/latest/api/class_terrain3d.html#class-terrain3d-property-render-layers
https://terrain3d.readthedocs.io/en/latest/api/class_terrain3d.html#class-terrain3d-property-mouse-layer

---

**reidhannaford** - 2025-05-11 13:41

the terrain is on 32? or the light?

---

**tokisangames** - 2025-05-11 13:46

Both

---

**reidhannaford** - 2025-05-11 13:50

got it working by setting `terrain.set_render_layers(1)` - is there any reason why I would want to keep it on 32?

---

**tokisangames** - 2025-05-11 14:02

The terrain is on 1 and 32, exactly as the docs I sent you say. This is a poor solution. Remove 32 from your light as I said.

---

**tokisangames** - 2025-05-11 14:03

32 is on the terrain for the mouse

---

**reidhannaford** - 2025-05-11 14:05

gotcha - sorry I just didn't understand what you were suggesting. Is it layer 6 (value 32)? or literally layer 32 and thus the only way to access it is by code like you said?

---

**reidhannaford** - 2025-05-11 14:06

must be layer 32 right because unticking layer 6 (value 32) doesn't change anything

---

**reidhannaford** - 2025-05-11 14:07

nvm I see the tooltip explanation

---

**tokisangames** - 2025-05-11 14:07

Exactly as I wrote. Bit 31, layer 32

---

**reidhannaford** - 2025-05-11 14:10

Cory it's not that I'm not reading what you're sending - just trying to understand. Anyway thanks for the help

---

**tokisangames** - 2025-05-11 14:19

Sure, thanks. You can add a tool script to your lights to remove the bit so they work as you want in the editor.

---

**reidhannaford** - 2025-05-11 14:20

it seems the built in method to set the cull mask only works for 1-20 - when I put in 32 as a parameter it doesn't do anything. Is there a different method I should be using?

📎 Attachment: image.png

---

**tokisangames** - 2025-05-11 14:21

Assign the variable

---

**tokisangames** - 2025-05-11 14:33

https://github.com/TokisanGames/Terrain3D/issues/355

---

**reidhannaford** - 2025-05-11 14:37

Hmm. Curiously this still isn't working for me. I put your second script directly on the light but it's still lighting the terrain (both in the editor and in game)

---

**reidhannaford** - 2025-05-11 14:40

the script is doing something because in the editor it's not lighting the grass (on layer 1, as the light is set to cull layer 1 in the inspector), and then in game it IS lighting the grass, since your code is resetting the light cull mask to be 2 and 32, but the terrain is still lit

📎 Attachment: image.png

---

**reidhannaford** - 2025-05-11 14:41

Using this script from the linked github issue:

```
@tool
extends Light3D

func _enter_tree() -> void:
    light_cull_mask = ~( 1<<31 | 1<<1 )   # Not 32 or 2
```

---

**reidhannaford** - 2025-05-11 14:42

rebooted Godot and now the tool functionality is working properly - the grass is now lit in the editor as well. But the terrain is still lit

---

**reidhannaford** - 2025-05-11 14:44

running Godot 4.4.1 in case that matters

---

**tokisangames** - 2025-05-11 14:55

No need to reboot, just trigger enter tree again by changing or reloading the scene. 
What Op wanted is different from what you want. You need to adapt the code to what you want. 
Print and compare the light mask and the terrain layers to see what you're missing.

---

**tokisangames** - 2025-05-11 15:14

> since your code is resetting the light cull mask to be 2 and 32,
That's not what is happening. It will be a good exercise for you to understand what it is doing.
Use a calculator to convert variable values to binary so you can see the bits.

---

**reidhannaford** - 2025-05-11 16:47

Had to step away but will dig into this asap. Thank you for your guidance I really appreciate it

---

**jonaburg** - 2025-05-11 18:36

heya guy, i notice that sometimes that some meshes are planted in really odd ways (don't really deform to the terrain) while others do. they require quite a bit of micromanaging to get the height offset/rotations/scale just right, and sometimes the scale affects the basis and transform of a mesh. not sure whats happening there. is there some kind of import setting maybe on the meshes that have kind of screwed this up for me you reckon?

📎 Attachment: image.png

---

**tokisangames** - 2025-05-11 21:28

Meshes are planted exactly at their origin point. If they are planted in strange places, fix your meshes in blender.

---

**eng_scott** - 2025-05-12 01:53

i have a code example here if you need it: https://terriblesoftware.dev/en/posts/detecting-texture-under-character-terrian-3d/

---

**groldi** - 2025-05-12 07:19

Is it possible to use the *lowpoly_colormap* shader from within the extra directory, while still being able to paint onto the terrain where needed?

---

**xtarsia** - 2025-05-12 08:03

flat normals, with painted textures like this?

📎 Attachment: image.png

---

**groldi** - 2025-05-12 08:07

I've copied the already included low poly shader and would also like to paint on certain parts. When it comes to shaders I am a newbie...

However when using this shader I can no longer paint the color, because the shader overrides it (see picture)

📎 Attachment: image.png

---

**xtarsia** - 2025-05-12 08:15

painting doesnt work for the color tool? can you check the console?

---

**groldi** - 2025-05-12 08:16

*(no text content)*

📎 Attachment: Screencast_20250512_101604.mp4

---

**groldi** - 2025-05-12 08:17

pardon the bad quality

---

**groldi** - 2025-05-12 08:17

Painting  works, when not using the lowpoly_colormap shader

---

**groldi** - 2025-05-12 08:17

and when I disable the shader override, the painted areas were painted

---

**xtarsia** - 2025-05-12 08:20

ah yeah, all the texturing code is not present there, its normals + color map only.

you can create a full shader by enabling override whilst its empty, and then edit the normals in that one.

---

**xtarsia** - 2025-05-12 08:22

i found an error with the flat normals too whilst checking them just now, the correct code should be:

```glsl
        NORMAL = normalize(cross(dFdyCoarse(VERTEX),dFdxCoarse(VERTEX)));
        TANGENT = normalize(cross(NORMAL, VIEW_MATRIX[2].xyz));
        BINORMAL = normalize(cross(NORMAL, TANGENT));
```

This might as well be added as a builtin feature, since so many ask for it, and a simple bool toggle would work fine.

---

**groldi** - 2025-05-12 08:27

I see, now that I've placed it inside the fragment function it looks good. Thanks

---

**throw40** - 2025-05-12 08:44

suprisingly pretty

---

**darkalardev** - 2025-05-12 10:54

Hello!
I created three different biomes in Gaea, and I understand I can import the heightmap into this plugin. My question is, is there a way to combine them to generate biomes in a single terrain?

Since the idea is to be able to move from the plains to the steppe or savannah on foot?

📎 Attachment: image.png

---

**tokisangames** - 2025-05-12 11:09

Once you setup your textures, you can manually paint them however you like. Or you can write a script using our API to import a texture map depending on the output specs of your program.

---

**jonaburg** - 2025-05-12 13:35

thanks! from your tip i noticed my origin had some kind of bias towards where the mesh actually was 🙂

---

**jonaburg** - 2025-05-12 13:35

also i do notice some quite odd behavior that when i look down (towards the terrain) my fps starts to drop. it doesn't appear to be related to complexity of anything being rendered though. i even have the LOD set to 2 jsut to test this but i wonder what i'm doing wrong. i have about 110fps when looking horizontally (with other objects rendering), and about 85fps when looking down

---

**jonaburg** - 2025-05-12 13:53

ah yknow, it might be the scale of the UV for the texture painted perhaps.. i notice on some regions where the UV scale is lower and the textures seem more blown up that performance is much better - is there a way i can control uniformly what scale UV gets applied?

---

**jonaburg** - 2025-05-12 13:55

i get some pretty bad hitching when there is alpha blending, is spraying a texture over another texture also performant heavy?

---

**jonaburg** - 2025-05-12 14:42

alright, maybe not related.. not sure what this can be about (lookign straight down 1 & 3) and looking straight up (middle)

📎 Attachment: image.png

---

**jonaburg** - 2025-05-12 14:42

*(no text content)*

📎 Attachment: image.png

---

**jonaburg** - 2025-05-12 14:42

why might my process time be spiking so much when looking down?

---

**tokisangames** - 2025-05-12 14:47

What is hitching?
Why are you using alpha blending instead of height blending while using realistic looking textures?

---

**tokisangames** - 2025-05-12 14:47

I won't comment on anecdotal testing with other random objects in your scene, foliage, or lack of info about setup, textures, specs, and resource consumption. Make a clean benchmark environment to test in. Provide proper scales on your charts for accurate representation of your data. Compare against a demo benchmark w/o foliage. You can read about performance in Tips, and there's a shader design doc or even the shader code if you want specifics on how it works. You can also use occlusion culling. Texture UV shouldn't matter unless you have an old/mobile card.

---

**jonaburg** - 2025-05-12 14:49

sorry it was a red herring - the alpha blending is not related i just wondering if the height blending worked in a similar way (not knowledgable about it). i do use occlusion culling already, the issue is specifically when looking directly down 😦

---

**tokisangames** - 2025-05-12 14:50

We don't use process time. The terrain is handled by the GPU. Collision and meshes are moved in the physics frame.

---

**tokisangames** - 2025-05-12 14:50

You need a clean testing environment.

---

**jonaburg** - 2025-05-12 14:55

i have nothing in my scene except for terrain3d and the actor at the moment, i'm not sure what else i can change :(.  i don't have any foliage instanced in atm either

---

**jonaburg** - 2025-05-12 14:55

im quite new in gamdev, but i have about 130 draw calls when looking straight down as opposed to about 90 when at about a 60 degree angle. is that a lot?

---

**jonaburg** - 2025-05-12 14:58

sorry for all the newbie questions - i appreicate your time answering them! is the region size relevant for performance too? like a smaller region vs a larger? i'm not sure what hte tradeoffs would be

---

**image_not_found** - 2025-05-12 14:58

Check the directional shadowmap

---

**image_not_found** - 2025-05-12 14:59

When you look down, areas behind the camera don't get culled

---

**image_not_found** - 2025-05-12 14:59

Idk, maybe it lines up with the increased process time

---

**tokisangames** - 2025-05-12 14:59

You said "with other objects rendering". 
We still need all of the other things I noted. Scales, specs, resource consumption, comparison with the demo. 
You should compare GPU time. I don't know if there's a monitor for it, but it's visible in the viewport menu.

---

**tokisangames** - 2025-05-12 14:59

> Check the directional shadowmap
Or better, disable shadows for testing.

---

**jonaburg** - 2025-05-12 15:00

oh yes, sorry, i meant with other objects, other meshes of terrain3d, like a large hill. ah interesting about the things behind the camera not being culled too. i'll disable shadows and add in a gpu timer ingame to check

---

**tokisangames** - 2025-05-12 15:07

You can see the GPU time and FPS in the editor. Compare with those.

---

**wowtrafalgar** - 2025-05-12 15:20

I have modified the importer to be able to use splat maps, which works for the texture assignment but for some reason my particle foliage is not recognizing any of the materials except material 0, any idea why this might be?

```
func convert_splat(control_file_name: String):
    var image_file = load(control_file_name)
    var splat = image_file.get_image()
    var height = splat.get_height()
    var width = splat.get_width()
    var code_img: Image = Image.create(width,height,false, Image.FORMAT_RF)
    for y in height:
        for x in width:
            var pba: PackedByteArray
            pba.resize(4)
            var i : int = 0
            var mat_0 = splat.get_pixel(x,y).r
            var mat_1 = splat.get_pixel(x,y).g
            var mat_2 = splat.get_pixel(x,y).b
            var mat_3 = splat.get_pixel(x,y).a
            var set_int = max(mat_0,mat_1 ,mat_2 ,mat_3)
            var mat_id
            #(x & 0x1F) <<27
            if set_int == mat_0:
                i = red_material
            elif set_int == mat_1:
                i = green_material
            elif set_int == mat_2:
                i = blue_material
            elif set_int == mat_3:
                i = alpha_material
            pba.encode_u32(0, ((i & 0x1F) << 27))
            var r : float
            r = pba.decode_float(0)
            code_img.set_pixel(x,y, Color(r,0.,0., 1.0))
    return code_img
```

Particle foliage code

```
    if (material_id != -1){
        if (!auto && (base != material_id || over != material_id)) {
            pos.y = 0. / 0.;
            pos.xz = vec2(100000.0);
        }
    }
```

---

**wowtrafalgar** - 2025-05-12 15:27

im sure its something wrong with the encode/decode, I found in the Terrain3DUtil enc_base(int) but am having trouble figuring out how to use it here

---

**xtarsia** - 2025-05-12 15:32

i should probably have include blend like this:

```glsl
    uint control = floatBitsToUint(texelFetch(_control_maps, index[3], 0).r);
    bool auto = bool(control & 0x1u);
    int base = int(control >>27u & 0x1Fu);
    int over = int(control >> 22u & 0x1Fu);
    float blend = float(control >> 14u & 0xFFu) * 0.003921568627450; // 1. / 255.

    // Hardcoded example, hand painted texture id 0 is filtered out.
    if (!auto && ((base == 0 && blend < 0.7) || (over == 0 && blend >= 0.3))) {
        pos.y = 0. / 0.;
        pos.xz = vec2(100000.0);
    }
```

---

**wowtrafalgar** - 2025-05-12 15:33

so is the issue that my splat importer isn't setting the blend

---

**wowtrafalgar** - 2025-05-12 15:33

so its not a pure base texture?

---

**xtarsia** - 2025-05-12 15:35

i would instantiate a Terrain3DUtil and make use of that directly on the image pixel red channel

---

**wowtrafalgar** - 2025-05-12 16:16

heres the updated splat code got it working thanks for the help!
```
func convert_splat(control_file_name: String):
    var image_file = load(control_file_name)
    var splat = image_file.get_image()
    var height = splat.get_height()
    var width = splat.get_width()
    var code_img: Image = Image.create(width,height,false, Image.FORMAT_RF)
    for y in height:
        for x in width:
            var pba: PackedByteArray
            pba.resize(4)
            var i : int = 0
            var mat_0 = splat.get_pixel(x,y).r
            var mat_1 = splat.get_pixel(x,y).g
            var mat_2 = splat.get_pixel(x,y).b
            var mat_3 = splat.get_pixel(x,y).a
            var set_int = max(mat_0,mat_1 ,mat_2 ,mat_3)
            var mat_id
            #(x & 0x1F) <<27
            if set_int == mat_0:
                i = red_material
            elif set_int == mat_1:
                i = green_material
            elif set_int == mat_2:
                i = blue_material
            elif set_int == mat_3:
                i = alpha_material
            #pba.encode_u32(0, ((i & 0x1F) << 27))
            var util = Terrain3DUtil
            var bits = util.enc_base(i)
            var color: Color = Color(util.as_float(bits), 0., 0., 1.)
            code_img.set_pixel(x,y, color)
    return code_img
```

---

**jonaburg** - 2025-05-12 17:46

difference int he editor is quite minimal, but it translates to about a 20 FPS drop. also my GPU is not being used here much. specs is a m1 macbook pro. i actually do see this as well in the demo scene (pic 3  and 4). it is about the same frame drop so i guess this is just default behavior of rendering terrain on my CPU. sorry i cant be more helpful to figure this out 😦

📎 Attachment: image.png

---

**tokisangames** - 2025-05-12 18:32

You're comparing a shot of the camera looking 100% at terrain, with maybe 50% terrain 50% sky? It costs GPU cycles to render the terrain on screen. The more the screen coverage, the more expensive it is. Compare looking at a cliff with looking straight down where the screen is 100% covered in both cases.
100000fps tells you that you're looking at invalid data.

---

**tokisangames** - 2025-05-12 18:33

Please make a PR so others can use it.

---

**wowtrafalgar** - 2025-05-12 18:36

is there a guide you have handy for making PRs? I am a solo dev and would love to contribute but my github skills are lacking. I only have 1 main branch on my project that I commit all changes to

---

**tokisangames** - 2025-05-12 18:38

Look at our contributing document, as well as the linked Godot contributing document.

---

**rakadeja** - 2025-05-12 19:13

so, i'm not sure what i did (those errors aren't related to this i don't think) but the alpha on any of the brushes i use is kind of.. idk. gone? no falloff? idk how to explain it

📎 Attachment: Godot_v4.4.1-stable_mono_win64_qVMawGwFxg.mp4

---

**wowtrafalgar** - 2025-05-12 20:12

I think that is expected behavior, outside of the overlay textures are 1:1 not blended

---

**dailyshadow.** - 2025-05-12 20:13

I have a beginner question about terrain.  

I have several blocks or chuncks of locations in my game.  I want to make these as stand alone scenes and then have a worldmap that enstantiates them.  How would that work with the terrain 3d addon?

Like I have a school for example.  SO I would model the parking lot, the ground where the building would go, and the fields where they have sports etc.   And that would be its own scene, then how do I add that terrain 3d to a world map that loads all the locations in?

---

**wowtrafalgar** - 2025-05-12 20:17

do you want it to be one continuous world map or would there be level transitions?

---

**dailyshadow.** - 2025-05-12 20:17

continuous map

---

**wowtrafalgar** - 2025-05-12 20:18

I would make one big terrain and based off distance to your chunks have them instantiate / free

---

**wowtrafalgar** - 2025-05-12 20:18

then  you can either obstruct view to this happening with doors/mountain ranges or put a low poly version in place before the higher fidelity one loads

---

**tokisangames** - 2025-05-12 21:22

Read the painting doc and watch the 2nd video. Paint has no alpha. Only spray does when using in an area with the autoshader disabled.

---

**ckappaa** - 2025-05-12 21:44

hi i'm new here, i've basically never done a video game on godot so i don't know how to do everything. When i try to use terrain 3d this alert appears, could someone explain to me how i can fix it, pls (sorry for my english but it isn't my first language)

📎 Attachment: image.png

---

**shadowdragon_86** - 2025-05-12 22:02

You need to specify a directory for Terrain3D to save its data in.

Select the Terrain3D node then look in the inspector panel and find the option to specify the directory.

---

**shadowdragon_86** - 2025-05-12 22:02

And watch the tutorials if you didn't already

---

**ckappaa** - 2025-05-12 22:09

ok thanks

---

**dailyshadow.** - 2025-05-13 02:05

I can't seem to find it in the documentation.  Does anyone know how I can set a custom heightmap for the world background?  I can only choose "none, flat, or noise" and i can't seem to find where/if I can set a custom texture for the noise for the world background.

---

**infinite_log** - 2025-05-13 02:10

You have to manually set it in the shader code by enabling the shader overide. This is no setting to set custom world height, I think.

---

**dailyshadow.** - 2025-05-13 02:16

Okay thank you I will look into that.

---

**tokisangames** - 2025-05-13 02:23

Even if you customize the shader to add a noise map using Godot's noise, it will be 8-bit and the terrain will look like crap. You could do it correctly by 1) creating a 16/32-bit noise map via code (see CodeGenerated), or via a 3rd party tool, or 2) a noise algorithm written in shader code, as is currently there.

---

**groldi** - 2025-05-13 09:54

How can I instead of a texture make my terrain single colored?

Edit: I've done it by adding this line inside the shader:
```glsl
// Apply color to base
albedo_ht.rgb = base_color; // <-
albedo_ht.rgb *= _texture_color_array[out_mat.base].rgb;
```

---

**groldi** - 2025-05-13 10:14

Because there are no textures inside the game it enables the checkered debug view, how can I fix this? 😅

---

**xtarsia** - 2025-05-13 10:15

You can skip texture reads in the shader entirely. But at that point, may as well use the color map only?

---

**groldi** - 2025-05-13 10:16

At some point I still want to use some textures and paint all over the base color

📎 Attachment: image.png

---

**groldi** - 2025-05-13 10:18

How can I make sure it does not enables the checkered debug view when there are no textures? Cause it works inside the editor. But starting the game enables the debug view

---

**groldi** - 2025-05-13 10:42

In game*

📎 Attachment: image.png

---

**xtarsia** - 2025-05-13 12:01

Make a full white texture to use in slot 0, then paint the color map, and paint textures where you want them.

---

**groldi** - 2025-05-13 12:05

Thanks. It kindof works. Can I suppress these two?

📎 Attachment: image.png

---

**deltt** - 2025-05-13 13:24

I'm encountering an issue where some meshes from the instancer can't be deleted / keep popping up again, is this a known issue?

---

**deltt** - 2025-05-13 13:24

*(no text content)*

📎 Attachment: 111.gif

---

**deltt** - 2025-05-13 13:24

the meshes appear in-game, or after re-opening the project also in the editor

---

**deltt** - 2025-05-13 13:25

(after reopen)

📎 Attachment: image.png

---

**reidhannaford** - 2025-05-13 13:26

Incidentally I was able to get this working just by switching the Terrain render layer from 1 to 2 - which in retrospect is obvious! Now my light is culling layers 2 and 32, and is not affecting the terrain. Thanks again for your help I really appreciate it!

---

**tokisangames** - 2025-05-13 14:38

Create 1px files on disk and attach them.

---

**tokisangames** - 2025-05-13 14:44

Open the region in the inspector by double clicking it, look at the instances dict. See what ID those instances are. Add enough meshes to hit that ID, then delete. Or just erase the instances dict in a tool script.
How did you get your assets out of sync with your data? Did you edit your assets when the terrain wasn't loaded?

---

**deltt** - 2025-05-13 14:51

I switched out a material on the mesh asset

---

**tokisangames** - 2025-05-13 15:00

If you can create a reproducible process we can track down any bug.

---

**almictm** - 2025-05-14 02:00

Hello, I was having a problem with the noise terrain and shadows. Basically, beyond a certain height of the noise (relative, not absolute), shadows abruptly stop. I tested this with a new 3D scene, default settings other than noise terrain, directional light near the horizon to make the effect more obvious. Changing tho noise height does not fix it, but makes it look all the more suspicious that it may be a terrain shader problem. I looked through the shader and dont see anything that looks like a hard limit on noise height receiving shadows, though. This is with a shadow length of 400. the terrain isnt very high or far from the camera, shadow is just disabled above a certain height it seems. I looked and couldnt find anything like this on the github or in discord search. Let me know if you want me to make an issue on github. im still not sure if this is user error or a real bug. Second image has noise height of 3, and the default capsule mesh for reference. It also shows this is a self-shadow problem. Only work around I can think of is to just not use noise terrain and manually sculpt the terrain edges which then self-shadow correctly.
Edit: and I have set "Rendering > Cast Shadows" to "double sided"

📎 Attachment: 20250513_19h54m45s_grim.png

---

**image_not_found** - 2025-05-14 09:39

Have you tried increasing the directional light's shadow pancake option?

---

**moooshroom0** - 2025-05-14 11:05

Is this why my project crashes when i sculpt in certain areas?

📎 Attachment: image.png

---

**almictm** - 2025-05-14 12:56

i moved every slider i could on the light to see if anything made a difference, there's always a height on the noise that acts fully bright. one thing that makes me think this could be correct shadowing is that changing angular distance softens the edge (plus the fact my own screenshot shows the capsule receives light), though I expected a point light at the logical horizon to cast a non-flat terrain in complete shadow.

---

**xtarsia** - 2025-05-14 13:00

isnt this just the limits of shadow distance? with 8192 max distance things work as expected for me even with quite high world noise height scale.

📎 Attachment: image.png

---

**almictm** - 2025-05-14 13:04

i noticed it was relative as when i dropped the noise scale, the line moved with in. and this is right next to the camera. i think it looks incorrect but it could be correct in the sense that no terrain ahead of it blocks the light, though I expected this configuration with the light on the horizon to leave no direct illumination on any terrain.

---

**almictm** - 2025-05-14 13:07

to be more clear about my use, i have a day/ night cycle that moves slowly, and distant noise wasnt falling out of light like i expected, and after messing around i couldn't find any clear reasons why. i can reproduce the effect quickly as i did for the screenshots. just not sure if there's a bug, or if the error is my own.

---

**almictm** - 2025-05-14 13:08

a terrain with noise and a directional light is all it takes to see

---

**tokisangames** - 2025-05-14 13:56

Please provide exact settings and positions to demonstrate it in a new scene or our demo.

---

**tokisangames** - 2025-05-14 13:58

Probably. Either add the missing assets, clear your instances dict, or use a nightly build.

---

**almictm** - 2025-05-14 14:29

New 3D scene, for terrain: enable noise (i assume the default gives everyone the same noise and seed of 0), set noise height to 20, set noise offset to -4x, 0y, 0z (not necessary, just brings a spot to the origin for low distance), and set Cast Shadows under Rendering to "Double-Sided". You will need to zoom out all the way to see the terrain now.
For the directional light: add one to the scene, by default it should have no transform and be horizontal, enable shadows, set shadow mode to "orthogonal" (doesn't matter, just faster to render) and play with max distance to see sharp edges appear (700 - 1600 on the mountain at the origin). All the way up and you can see islands of light across the terrain.
--
I expected to see no direct illumination anywhere as in theory the distant horizon should fully occlude all light even if technically no real mesh exists there to block it. The more I've looked at this the more it looks like a mesh thing, increases to Mesh LODs and Mesh Size helps but there seem to be upper limits. Increasing angular diameter of the light makes it less strange looking at a high cost. I think the only remedy might be a custom light function in the shader to handle lights at the horizon more appropriately than relying on its own mesh self-shadowing, such as reducing direct light contribution on terrain from directional lights as they approach the horizon, but i dont have any experience beyond reading godot docs for spatial shaders. I will try something soon to see if it helps remove this strange look.

---

**almictm** - 2025-05-14 15:17

I've produced a result in the direction of reality, adding this to the end of the default terrain shader demonstrates more accurately what should happen to shadows on the terrain:
```glsl
void light()
{
    if (LIGHT_IS_DIRECTIONAL)
    {
        float y_power = (mat3(INV_VIEW_MATRIX) * LIGHT).y;
        DIFFUSE_LIGHT = vec3(max(0.0, y_power)) * ATTENUATION;
    }
}
```

---

**almictm** - 2025-05-14 15:18

but of course this isn't 100% accurate as it removes a lot of the PBR shading now

---

**almictm** - 2025-05-14 15:21

and `y_power` would also include some value of the disk diameter so it only takes effect very close to the horizon

---

**xtarsia** - 2025-05-14 15:43

ive repeated this, and im not seeing anything that stands out as wrong?

📎 Attachment: image.png

---

**almictm** - 2025-05-14 15:45

if we assume an infinite horizon with a point source, you should see no direct lighting at all, it would be obscured. try my light example and i think you'll see what i mean.

---

**xtarsia** - 2025-05-14 15:45

setting fade start to 1.0 (no fade) shows a clear transition from shadows, to no shadows (distance is farther than max)

📎 Attachment: image.png

---

**xtarsia** - 2025-05-14 15:46

Directional light doesnt work like that, and is considered to be infinitley far away

---

**tokisangames** - 2025-05-14 15:46

DLs are [infinite parallel rays covering the entire scene](https://docs.godotengine.org/en/stable/classes/class_directionallight3d.html), and those rays are cast on only the mesh and distant lods that exist, not a theoretical horizon or mesh that doesn't exist. This isn't a ray traced environment with point lights, it's a vulkan rendered environment.

---

**almictm** - 2025-05-14 15:47

i'm going to continue on my own with this starting point on the light function, and might make a PR in the future. this result is technically correct but not physically accurate enough for me

---

**almictm** - 2025-05-14 15:49

and a mesh that extends to the horizon would block a point source directional light

---

**tokisangames** - 2025-05-14 15:51

Yes, but we don't have those.
Physically accurate shadows without an expensive long directional shadow without would be great. A PR would be welcome. See https://github.com/TokisanGames/Terrain3D/discussions/133

---

**wowtrafalgar** - 2025-05-14 16:00

I am trying to make a nav mesh on a 4k sized terrain, I am new to navigation regions and am having trouble determining what the cell size/cell height should be when baking. Any tips on this? I read through the documentation and didnt get specific pointers other than this error message when trying to bake.

  ERROR: Baking interrupted.
  ERROR: NavigationMesh baking process would likely crash the engine.
  ERROR: Source geometry is suspiciously big for the current Cell Size and Cell Height in the NavMesh Resource bake settings.
  ERROR: If baking does not crash the engine or fail, the resulting NavigationMesh will create serious pathfinding performance issues.
  ERROR: It is advised to increase Cell Size and/or Cell Height in the NavMesh Resource bake settings or reduce the size / scale of the source geometry.
  ERROR: If you would like to try baking anyway, disable the 'navigation/baking/use_crash_prevention_checks' project setting.

I increased the cell height and size and 1.0 and tried baking and didnt get the error message, but the nav mesh sems disjointed any idea what is causing this?

---

**wowtrafalgar** - 2025-05-14 16:00

*(no text content)*

📎 Attachment: image.png

---

**wowtrafalgar** - 2025-05-14 16:03

keeping the height at .25 and increasing the cell size to 1.0 yielded better results but still have some gaps in areas

📎 Attachment: image.png

---

**almictm** - 2025-05-14 16:04

i've only had success changing the nav code in terrain3d directly, changing cell size/ height away from the defaults always breaks the mesh and i never figured out why...

---

**almictm** - 2025-05-14 16:05

i had an issue with the mesh going under the terrain, i changed rounding from `floor` to `ceil` and it stayed above the terrain in my case

---

**almictm** - 2025-05-14 16:06

(that could be what is happening to you)

---

**wowtrafalgar** - 2025-05-14 16:07

where do I set rounding?

---

**almictm** - 2025-05-14 16:08

for my version (should be latest) i had to change line 258 in this file: `addons/terrain_3d/menu/baker.gd`

---

**almictm** - 2025-05-14 16:10

i changed .floor() to .ceil() and my mesh stopped clipping into the terrain, but clipping can still happen on steep slopes. for me it was very tiny slopes that had the mesh clip below.

---

**wowtrafalgar** - 2025-05-14 16:10

ok disabling the use_crash_prevention_checks and running it at .25 worked decently better, but still didnt seem to capture any of this hill, are steep slope just out of the question for nav meshes? (terrain)

📎 Attachment: image.png

---

**wowtrafalgar** - 2025-05-14 16:11

guessing ill just need to use meshes for ramps instead of the terrain

---

**almictm** - 2025-05-14 16:12

there should be a max slope setting in the nav mesh that might go up that now, but too steep (maybe 45 degrees) could start clipping again

---

**almictm** - 2025-05-14 16:12

but that does look very steep

---

**wowtrafalgar** - 2025-05-14 16:13

I see the max slope let me try that

---

**wowtrafalgar** - 2025-05-14 16:13

hopefully I dont start a fire baking it

---

**wowtrafalgar** - 2025-05-14 16:15

it helped a bit but I think its too steep, ill use static objects for steep ramps and do more gradual slopes for terrain, here is the final bake

📎 Attachment: image.png

---

**wowtrafalgar** - 2025-05-14 16:15

thanks for the help!

---

**wowtrafalgar** - 2025-05-14 17:31

if I wanted to set the base texture and nav on a single pixel with set pixel how would I do that? can I set the pixel twice? or would I need to add the color to that pixel?

---

**wowtrafalgar** - 2025-05-14 17:31

```
            var util = Terrain3DUtil
            var bits = util.enc_base(i)
            var color: Color = Color(util.as_float(bits), 0., 0., 1.)
            code_img.set_pixel(x,y, color)
            var bits = util.enc_nav(i)
            var color: Color = Color(util.as_float(bits), 0., 0., 1.)
            code_img.set_pixel(x,y, color)
```

---

**xtarsia** - 2025-05-14 17:39

something like
bits = (bits & ~(0x1 << 1)) | enc_nav(true))

---

**wowtrafalgar** - 2025-05-14 17:59

got it working, thanks!

---

**maker26** - 2025-05-14 18:12

we got a hacked account

---

**rakadeja** - 2025-05-14 19:12

oh my goodness, i didn't even notice i was in paint mode 😂
Thank you for speedy responses, love this addon!

---

**moooshroom0** - 2025-05-14 20:45

Thank you!!!

---

**cepodi2** - 2025-05-14 21:37

why does terrain 3D instances meshes features removes all the foliage of the object i wanna place it? in that case, a tree

---

**cepodi2** - 2025-05-14 21:37

*(no text content)*

📎 Attachment: Captura_de_tela_2025-05-14_183146.png

---

**cepodi2** - 2025-05-14 21:39

not only that but in some cases, objects increase in size tremenduosly and also get upside down

---

**tokisangames** - 2025-05-14 21:40

Read the instancer docs. Combine your separate meshes into one object. If they're upside down, or scaled weird, then your mesh isn't setup right, placed at the origin, transforms applied, facing upright.

---

**cepodi2** - 2025-05-14 21:41

alright

---

**tokisangames** - 2025-05-14 21:41

The default options shown on your screen vary the scale a minor amount, but assume you have properly setup your mesh in blender with unit transforms.

---

**lyim** - 2025-05-15 04:32

I don't plan on using any normal maps. Is there any way to dismiss these warnings?

📎 Attachment: image.png

---

**lyim** - 2025-05-15 04:33

Also, are those errors at the bottom related to the addon or is that Godot.

---

**xtarsia** - 2025-05-15 05:26

Make a 2x2 flat normal map png, and put that in every textures normal slot. It'll save vram and disk space.

Currently, it's saving each one as text inside the resource file.

---

**lyim** - 2025-05-15 05:27

Ty!

---

**lyim** - 2025-05-15 06:23

Do you know anything about the errors occuring? Is that related to this addon?

---

**xtarsia** - 2025-05-15 06:26

All t3d errors should say they were from t3d. However, set_data could be from collision heightmap shape. Need more info.

---

**lyim** - 2025-05-15 16:41

What kind of info would you need?

---

**xtarsia** - 2025-05-15 16:51

It means, you have to do abit more investigation to find out wqhats causing the error. either disabling the terrain, or changing settings and see if it goes away etc, maybe its an engine bug, or some environmental setting not related to terrain 3d at all.

---

**tokisangames** - 2025-05-15 16:56

Also look at your console/terminal, not this error screen, nor the output panel.

---

**lyim** - 2025-05-15 21:14

Not sure what I did but it's gone. May have just been an engine bug.

---

**lyim** - 2025-05-15 21:15

Very handy addon! Appreciate the help.

---

**vortex5431** - 2025-05-15 21:47

This may be a dumb question as I am very new to Terrain3D. I am making a map that uses a 32x32 grid border in a Circle. I am trying to paint in texture height but it creates new grids. Is there a way to lock grids without changing region size? Also, Is there a way to disable "create new grids" ?

---

**tokisangames** - 2025-05-15 23:22

> 32x32 grid border in a Circle
I don't know what this means.
> I am trying to paint in texture height but it creates new grids.
You mean regions? Select the Paint tool, not the Region tool. Disable auto add regions in the advanced menu.
Read the Introduction doc so you have the right terminology and the UI docs.

---

**dogmakegame** - 2025-05-16 03:59

what would be the best way to place / scatter objects such as trees with collision?

---

**mustachioed_cat** - 2025-05-16 05:11

Looks like the beginning of The Rising by Brian Keene :3

---

**shadowdragon_86** - 2025-05-16 08:09

If you want to place objects manually you can instantiate the scene as a child of Terrain3DObjects.

You can find other suggestions here under 3rd party tools: https://terrain3d.readthedocs.io/en/stable/docs/tips.html

---

**coelhucas** - 2025-05-16 11:50

Is there a way I can grab the mesh for a specific region and apply a shader on it? I wanted to use regions as tiles for my A* and add an outline as a hover selection effect

---

**coelhucas** - 2025-05-16 11:51

Similar to that

📎 Attachment: IMG_3162.png

---

**tokisangames** - 2025-05-16 12:22

Regions are not individual mesh components, they are only data.
> Similar to that
So you want to draw a white square on the terrain? Turn on the region grid overlay. If that's what you want, look at the shader code for it in debug_views.glsl and add a modified version of it to a customized shader driven by your own uniform.

---

**coelhucas** - 2025-05-16 12:26

Thanks, it’s exactly what I want (but for a specific selected region at a time), will mess with the glsl

---

**bucketsofquarters** - 2025-05-16 19:19

I have a question about something I saw in the <#1065519581013229578>  channel. I'd love to have nice clean curvy lines between the textures I paint. How can I achieve this look here on the right? I'm not sure what "blend" was being referenced at the time. https://discord.com/channels/691957978680786944/1065519581013229578/1362790651028312086

📎 Attachment: image.png

---

**xtarsia** - 2025-05-16 19:21

I have an open PR that will make the smoother blending default.

---

**bucketsofquarters** - 2025-05-16 19:24

Thanks! I'll have to check that out!

---

**groldi** - 2025-05-16 20:19

Uhm.. so my navmesh is non existent after baking.

I've added these areas and after baking it creates a navigationregion3d. However it seems to be completly empty

📎 Attachment: Screenshot_20250516_221705.png

---

**vhsotter** - 2025-05-16 20:37

If you're wanting to scatter a small amount of trees with collision then Proton Scatter is an option. If you want to do that for a larger number of GPU instances (aka MMIs placed by Terrain3D instancer) then you'll have to dig into the Terrain3D API and come up with your own solution and management system. I'm working on an open world with over 100K trees that need collision, but instantiating collisions for all of them at once eats up a ton of memory. So what I'm working on is a script to dynamically instantiate and destroy collisions for MMI chunks in a radius around the player. It's pretty hacky though and I do wonder if there's a better way.

---

**bucketsofquarters** - 2025-05-16 21:44

Thanks again! I was able to go from this to this using the spray tool. We're going for a very toony look with sharp edges, any tips to get this even sharper?

📎 Attachment: image.png

---

**tokisangames** - 2025-05-17 04:48

Read our navigation doc and the godot docs, and look at the messages in your console / terminal. We don't create navigation, we pass the data to Godot and it bakes. You need to know how it works, configuration and limitations.  Start with a smaller area.

---

**groldi** - 2025-05-17 08:23

I actually followed the docs and saw your video. 
I found this inside the docs:

```
Common Issues
Navigation won’t generate where foliage instances have been placed.

Change NavigationMesh.parsed_geometry_type from Mesh Instance (visual) to Static Colliders.
```

It did not work. But after I deleted the foliage, the mesh is generated

---

**catgamedev** - 2025-05-17 17:11

I'm having  some weird behavior with the undo stack that I can't well describe. 

After a while of painting, I'll notice my undo no longer undoes my last operation. 

Then when I close and reopen the level, work is lost.

But not always the last bit of work that I've done, and typically only vertex painting is lost and specifically only on a particular square of terrain.

Does this behavior sound familiar to anyone?

---

**catgamedev** - 2025-05-17 17:11

I have a huge project so something else could be interfering, also I could just be using something wrong

---

**tokisangames** - 2025-05-17 17:56

> Then when I close and reopen the level, work is lost.
Did you save? The console reports all of the files that are written to upon save for you to confirm.
> After a while of painting, I'll notice my undo no longer undoes my last operation. 
Are you getting new entries in your history?

---

**catgamedev** - 2025-05-17 23:54

I believe I saved yes, pretty sure. This has only happened ~2 times so far, and we're talking after hours of painting so it's hard to figure out when it "starts."

If I close/reopen Godot (or maybe even just the scene), I can catch the behavior sooner and try to add more information to a proper bug report-- if it is one. I might have some other code interfering with something, or just user error.

I was just hoping this already sounded familiar to someone.

---

**tokisangames** - 2025-05-18 00:15

I've not experienced nor heard of data loss on our stable versions from thousands of users in a long time. Crashes excluded. There were issues before with multiple scenes open that I think were resolved, but not with one scene.
Since your environment is suspect, over the next many work sessions record some logs. 

Towards the end of work sessions, save and review your console for confirmation that your modified regions were saved, confirm the files were modified on disk. 

If your undo stops working, set debug level to debug, perform a change, verify it was added to your undo history, attempt to undo it, save your files, confirm the appropriate regions and the files are modified, and save all of those debug entries in your console (not output) to a file for reference.

---

**vhsotter** - 2025-05-18 20:39

So I've been having some oddball problem with Godot not saving files properly at seemingly random times, and I have narrowed it down to something happening with Terrain3D I'm not entirely sure how to resolve.

I ran a debug build of Godot 4.3 and installed the version of Terrain3D that works with 4.3. Created a new terrain, set the data directory. Very consistently if I click on the "Meshes" button and then reload the project, Godot crashes with the following backtrace:

```
================================================================
CrashHandlerException: Program crashed
Engine version: Godot Engine v4.3.stable.custom_build (77dcf97d82cbfe4e4615475fa52ca03da645dbd8)
Dumping the backtrace. Please include this when reporting the bug to the project developer.
[0] <couldn't map PC to fn name>
[1] <couldn't map PC to fn name>
[2] <couldn't map PC to fn name>
[3] <couldn't map PC to fn name>
[4] <couldn't map PC to fn name>
[5] <couldn't map PC to fn name>
[6] <couldn't map PC to fn name>
[7] <couldn't map PC to fn name>
[8] <couldn't map PC to fn name>
[9] <couldn't map PC to fn name>
[10] <couldn't map PC to fn name>
[11] <couldn't map PC to fn name>
[12] <couldn't map PC to fn name>
[13] <couldn't map PC to fn name>
[14] <couldn't map PC to fn name>
-- END OF BACKTRACE --
================================================================```

I've tried clicking everything else when selecting the Terrain node and reloading. I only start having editor behavioral problems when I click Meshes or I click the "Instance Meshes" button which causes the tool panel to switch to the meshes to select from. If I attempt to reload the project or quit the editor it crashes with the same backtrace.

---

**vhsotter** - 2025-05-18 21:00

Okay, just tested this on a completely different machine. The above is on Windows 11. This time I tried my MacBook and Godot 4.4. Everything works just fine at first. If I click the Meshes button it's fine the first time. I can paint instances. But if I click something else and then click it again, it instantly crashes with this backtrace (and does so every time I open the project and click the button again):
```
================================================================
handle_crash: Program crashed with signal 11
Engine version: Godot Engine v4.4.stable.official (4c311cbee68c0b66ff8ebb8b0defdd9979dd2a41)
Dumping the backtrace. Please include this when reporting the bug to the project developer.
[1] 1   libsystem_platform.dylib            0x0000000195283624 _sigtramp + 56
[2] 2   libc++abi.dylib                     0x00000001951fff5c __dynamic_cast + 56
[3] CallQueue::_call_function(Callable const&, Variant const*, int, bool) (in Godot) + 324
[4] CallQueue::flush() (in Godot) + 352
[5] SceneTree::physics_process(double) (in Godot) + 244
[6] Main::iteration() (in Godot) + 596
[7] OS_MacOS::run() (in Godot) + 168
[8] main (in Godot) + 388
[9] 9   dyld                                0x0000000194eaab4c start + 6000
-- END OF BACKTRACE --
================================================================
[1]    71828 abort      ./Godot --debug --editor ~/terrain3d-crash-test/project.godot```

---

**vhsotter** - 2025-05-18 21:22

And just tested it on two different Linux machines and it does NOT have the problem there.

---

**vhsotter** - 2025-05-18 21:33

Tried this in Windows Sandbox (effectively a brand new Windows install in a VM) and it experiences the same crash when exiting or reloading the project (brand new from-scratch project in a perfectly clean install of Godot).

---

**vhsotter** - 2025-05-18 22:54

I've narrowed down a possible cause. If I follow these steps:
1. Click any other node other than Terrain3D.
2. Open the Terrain3D panel at the bottom if it's not visible, then click Meshes. The thumbnails are not generated (confirmed via debug info in the console).
3. Reload the project, no crash.
4. Repeat steps 1 and 2, but this time mouse over any of the buttons, be it the default mesh or the + Add Mesh button. The console spits out information that it's generated a thumbnail.
5. Attempt to reload, and it crashes as it does above.

If I click the Terrain3D node and then click Meshes, thumbnails are immediately generated, which then leads to a crash.

I tried switching to Compatibility mode and it does NOT crash there.

So it seems that something about Forward+ and generating those mesh thumbnails results in a crash when quitting or reloading the project.

---

**vhsotter** - 2025-05-18 23:26

I found that if I click the drop-down for Terrain3D's Assets and click Make Unique before reloading the project there is no crash, but only as long as I don't switch away from the Meshes panel and switch back or mouse over any of the thumbnails including the Add Mesh button.

---

**tokisangames** - 2025-05-19 01:17

* I don't see any Terrain3D in that stack. So it's likely a bug in Godot that we are triggering through our thumbnail generation.
* Why don't you edit asset_dock.gd and comment out all 3 of these lines, then see if you can reproduce a crash:
`plugin.terrain.assets.create_mesh_thumbnails()`

---

**tokisangames** - 2025-05-19 01:19

So you can produce this crash with these steps on windows and macos but not linux?

---

**tokisangames** - 2025-05-19 01:26

> 5. Attempt to reload, and it crashes as it does above.
Reload the scene or the whole project?

Godot crashes when closing and Terrain3D has debug logging. This is because Godot doesn't like printing messages past a certain point in the shutdown process and crashes when it is attempted. This crash is unrelated to the thumbnails.

---

**tokisangames** - 2025-05-19 01:26

> If I click the Terrain3D node and then click Meshes, thumbnails are immediately generated, which then leads to a crash.
This doesn't have a number. It seems like the real issue. What point in the process produces this? I'd like to target crashes that occur during editor or game runtime, not during closing.

---

**tokisangames** - 2025-05-19 01:28

You started off discussing that files are not being saved, but then didn't finish that thread. If the editor is running and you save, does it not write the files to disk and report a message on the console? Crashing on close, or crashing any time after that point should not affect files that are saved to disk and closed.

---

**vhsotter** - 2025-05-19 01:31

Correct.

---

**vhsotter** - 2025-05-19 01:35

Testing this now.

---

**vhsotter** - 2025-05-19 01:46

To answer a previous question, the crash only occurs in Windows if I reload the entire project, or exit. For MacOS it's instant as soon as the Meshes panel loads. As for the results of commenting out the relevant lines, no crash occurs when reloading the project or quitting.

---

**vhsotter** - 2025-05-19 01:57

I will need to do some more testing with this. I got sidetracked trying to pinpoint the other stuff. I'm unable to consistently invoke this behavior and I may have misinterpreted causes and effects in the course of my troubleshooting. This may be a separate issue.

---

**tokisangames** - 2025-05-19 02:01

As noted on github, if you don't save until you close the scene then click yes to save on it's prompt, and it crashes, I expect it won't save any data. If you save before closing, it should report every saved file to the console, write to disk, and you should not lose anything. If you do that's a separate issue.
cc: <@444627772728541194>

---

**catgamedev** - 2025-05-19 02:04

I haven't had any crashes at all, it's just some weirdness with the undo stack for me

---

**catgamedev** - 2025-05-19 02:04

no errors either, and the verbose debug output all looks fine

---

**catgamedev** - 2025-05-19 02:05

now that I think of that, I do have a few editor tools that interact with the undo stack. I can remove these and see if the behavior persists

---

**tokisangames** - 2025-05-19 02:06

You mentioned lost data. I'm still waiting further details from you on the circumstances leading up to, and details of the situation, before I can act on anything.

---

**catgamedev** - 2025-05-19 02:08

if I can figure out how to make an MRP, I'll do so.. probably best to assume it's my environment at the moment

---

**vhsotter** - 2025-05-19 03:05

I think I found a new issue. If I have painted a bunch of instances, then I click the X to delete it and all the instances from the scene, they disappear as expected. If I save and then reload the scene, I get warnings that the MeshAsset is null. If I put something in that mesh slot, all the instances I thought would have been deleted reappear with the new mesh. If I delete it again, then add another, then paint one or more instances in each region, then save and reload the scene then instances stay gone except for what I just painted anew for that slot.

---

**tokisangames** - 2025-05-19 04:11

> I get warnings that the MeshAsset is null
This means the region loaded with the mesh ids found in the instances dict. Like it wasn't properly cleared from the dict, or the file wasn't saved properly, or a cached res file was reloaded. You can open any res file in the inspector and look at the instances dict as it was saved, not live. A tool script can print the live data, as can the dump_data/mmi() functions. This can go in another Issue for tracking.

---

**vhsotter** - 2025-05-19 04:12

I'll test this more extensively and write up a new issue as necessary.

---

**tranquilmarmot** - 2025-05-19 06:35

Reading through the "collision" docs (https://terrain3d.readthedocs.io/en/latest/docs/collision.html#query-height-at-any-position)

With collision mode set to "Dynamic / Game", is it implied that all `RigidBody3D` nodes need to do a terrain height check with `terrain.data.get_height(global_position)` if the camera is far enough away from them? Otherwise they fall through the terrain.

I guess the height check only needs to be done if they're moving (`linear_velocity` or `angular_velocity` > 0)  . Once the camera is far enough away, they can just stop processing entirely as mentioned in the "Enemy Collision" section.

How far away from the camera should the manual height checking start? I also wonder how this would work for larger nodes, like a car. Maybe multiple checks (i.e. at corners) and take the highest one?

---

**tokisangames** - 2025-05-19 12:00

Rigid body is a physics thing and is irrelevant to using get_height. Anything can use that function.
The distance is based on what you set for the collision shape distance. Visualize it if needed.
Experiment with one or multiple checks depending on what you're doing. The less processing the better.

---

**tranquilmarmot** - 2025-05-19 15:03

I only mention rigid bodies because they're the only nodes (that I know of) that will, by default and without extra scripting, just fall through the terrain when collision is set to dynamic. Same question applies to anything falling manually like character body. It took me a while to realize why all of my boxes were disappearing when I went into a building and then came back out 😅

---

**madman4290** - 2025-05-19 20:26

greetings, just got my hands on the plugin, and got it up and runnining, but do wish to ask here, as the error code  "Unrecognized UID: "uid://b5je1vq60wg12"." have begun to be shown 50+ times when the project is loaded in, i do not know what a uid is, and cant seam to find a file named anything akin to the path code that it is giving me, so i do sadly not even know where to start in regard to fix this error

---

**vhsotter** - 2025-05-19 20:34

UIDs are a newer thing in Godot.

https://godotengine.org/article/uid-changes-coming-to-godot-4-4/

---

**tranquilmarmot** - 2025-05-19 20:34

Is it in a specific scene? The error message might show one in the log line. Sometimes you have to open a scene and then re-save it to fix the UIDs.

---

**madman4290** - 2025-05-19 20:36

just tried to save the screen and reload and went come 64, to 229 errors, with some new erros codes mixed in

---

**madman4290** - 2025-05-19 20:38

removed all texture, place a blank texture in, and save the screen reloaded the project, and now there is no error codes, must have messed something up somewhere

---

**madman4290** - 2025-05-19 22:00

question: will it be/is it, a good idea to change the the default texture, to a texture
is thinking of it like painting, and have it like a primer, or is that a bad idea cause of the clear demand that there will be imposed

---

**tokisangames** - 2025-05-20 00:42

Digital paint is unlike physical paint. The recommended process is described in tutorial 2 and the texturing docs.

---

**deltt** - 2025-05-20 12:16

I haven't found a way to reliably reproduce it yet, but I very regularly encounter this issue now

---

**deltt** - 2025-05-20 12:16

the Meshes placed with Terrain3D seem to "detach" often, making me unable to remove them

---

**deltt** - 2025-05-20 12:18

bounding box indicates that there are placed meshes, and there are
but I don't seem to be able to remove it

📎 Attachment: bug.gif

---

**deltt** - 2025-05-20 12:22

deleting the entire mesh type from the menu below fixed it (sometimes), but its really annoying having to do this if just a couple of meshes get stuck

---

**deltt** - 2025-05-20 12:43

if I re-add the mesh back to terrain3D, the placed non-deleteable instance of it pops up again

---

**tokisangames** - 2025-05-20 13:58

Is the slope where that mesh is > 25? Press Alt if you don't want to change the slope.

---

**mooging** - 2025-05-20 19:30

anyone here messed around with creating terrains in Godot and then exporting them as a mesh and using them in Unity?

---

**mooging** - 2025-05-20 19:30

the fact that godot terrain is capable of the apparently incredibly complex task of making a symmetrical shape is a big appeal

---

**catgamedev** - 2025-05-20 20:23

is there a way to brush over and clear all instanced objects, or only the selected one?

---

**catgamedev** - 2025-05-20 20:26

I was also wondering how easy it would be to let the particle grass only apply to a given layer instead of slope <:hmm:1033283820897710090>

---

**shadowdragon_86** - 2025-05-20 20:39

I think its ctrl + click to remove instances of the currently selected object, ctrl + shift + click to remove any instances.

---

**shadowdragon_86** - 2025-05-20 20:44

https://terrain3d.readthedocs.io/en/stable/docs/user_interface.html

---

**shadowdragon_86** - 2025-05-20 20:45

Unsure on particle controls

---

**tokisangames** - 2025-05-20 21:53

The example is there for you to modify as you need. Per texture (not layer) is not difficult.

---

**tokisangames** - 2025-05-20 21:53

Ctrl+shift as the docs say

---

**catgamedev** - 2025-05-20 21:56

thank you!

---

**otterspaceyo** - 2025-05-21 02:05

Hello, first terrain3d is amazing so thank you. Absolutely incredible work!
Second, I'm trying to determine if I can sculpt from the bottom? And lift the whole terrain? Basically could I use terrain3d to sculpt asteroids or am I "landlocked"? I didn't see this as an option in the documentation or videos. Hoping it's possible?

---

**vhsotter** - 2025-05-21 02:33

The position of the terrain is generally locked in place so that can't be moved. You'd have to basically sculpt up to the height you want and then flip the faces. You can achieve a "floating island" effect by having two terrains, one to act as the top and one to act as the bottom and sculpting them both in a way so their borders line up. Someone did such a thing here: https://discord.com/channels/691957978680786944/1185492572127383654/1272733866750120097

---

**bottroy_91014** - 2025-05-21 02:46

Hey folks, am I hallucinating or before Godot 4.4 (0.9.3 version of terrain3d) had less pixely texture painting and was more smooth? my vertex spacing is set 1 which is 1m and i have all models scaled proportinally. I'm not if just haven't noticed it before. On the picture I attached i tried to draw a circle and looks more like squire because verticies aren't dense enough. Is it expected? Cobble stone path looks smooth in 2nd tutorial video. is it just because vertices are more dense in that video? 

https://www.youtube.com/watch?v=YtiAI2F6Xkk&t=179s&ab_channel=TokisanGames

📎 Attachment: circle.png

---

**otterspaceyo** - 2025-05-21 02:49

Thank you! So I guess no sideways mountains for now, but I see how he made the floating island effect. Thanks again, and good name.

---

**vhsotter** - 2025-05-21 03:47

Yeah if you want something like sideways mountains and such for things like asteroids you'll want to look into voxel-based terrain systems

---

**tokisangames** - 2025-05-21 03:53

Voxel terrain by Zylann

---

**tokisangames** - 2025-05-21 03:55

The Spray tool will allow you to blend. This version is slightly blockier and there is a PR that improves that.

---

**waytoomellow** - 2025-05-21 05:53

I think similar to the one above, I'm using the spray tool but just seem to be unable to not get the squares to blend out (just makes more squares switching back and forth the textures) is it a resolution setting or anything I'm missing?

📎 Attachment: image.png

---

**tokisangames** - 2025-05-21 08:00

In order to blend properly you need textures with heights, low strength on Spray, have Painted or removed the autoshader in that area, and the default material settings. This looks like you have no heights, possibly the autoshader mixed in, and have messed with your material.

---

**waytoomellow** - 2025-05-21 08:05

awesome thank you for the reply! I have setup the heights based on the documentation packing the height into the alpha etc, but I will try again incase I messed up on the first pass, I swear it had it working before quite organically but doesnt want to play nicely now

---

**tokisangames** - 2025-05-21 08:16

Compare with the demo. The textures are setup properly, and blending with Spray works fine, after Painting to remove the autoshader.

---

**waytoomellow** - 2025-05-21 08:17

ok great thank you, so flow should be, setup base texture with autoshader to handle slopes etc, then paint to remove the auto shader in areas you want manual control to spray layers over the top?

---

**catgamedev** - 2025-05-21 08:41

confirming that it was indeed my environment.. still haven't figured out the exact problem, but it's something in my editor tools

---

**tokisangames** - 2025-05-21 10:20

Setup textures per the docs with heights. Then follow the technique. Watch video 2 for a demo of this technique and also blending into the autoshader.
https://terrain3d.readthedocs.io/en/stable/docs/texture_painting.html#manual-painting-technique

---

**uniphix** - 2025-05-22 01:53

Hello I have few questions about Terrain3D and hopefully this is the right place to ask if not I apologize in advance.

**How can Terrain3D support biome-based map creation with seamless loading and unloading, especially in a networked multiplayer context?**

> I'm looking to use Terrain3D to build a biome-based open world where different regions (e.g., grasslands, forests, snowy zones) are stitched together seamlessly. My goal is to manage performance by dynamically loading biomes as the player approaches and unloading them as they move away. However, I plan to control this with my own logic to prevent unnecessary loading/unloading.
> 
> I’d like to implement something similar to how infinite heightmaps work—generating or rendering terrain based on the player's location. The end goal is to support multiplayer, and the architecture for multiplayer will heavily influence how terrain streaming and world loading are handled.

**Will Terrain3D present limitations when blending or meshing biome boundaries?**

> I'm particularly concerned about visual or technical issues when stitching different biomes together—like a forest smoothly transitioning into a snowy mountain area or desert. Initially, the world will be relatively small, but the long-term plan is for a large open world. For travel across regions (such as sailing between islands or continents), I plan to use an "infinite ocean" concept and load landmasses only as the player nears them.

**Can Terrain3D support environmental systems like seasons and weather per biome?**

> I want to implement seasonal and weather-based transitions in biomes. For instance, a grassland biome might gradually become snow-covered during winter or a storm, and this snow should accumulate only if the temperature stays low enough. These environmental transitions should dynamically affect terrain textures, material properties, and possibly even gameplay.
> 
> I'm aiming for a visual and gameplay style similar to V Rising, where the world is static but environmental dynamics play a big role in immersion and strategy.

---

**1sudo** - 2025-05-22 01:55

I'm playing around with using SimpleGrassTextured to put grass on the terrain. Their instructions say to have a StaticBody3D in order to drop grass on the terrain. So I dropped a collision shape onto the StaticBody3D - the problem is the collision shape isn't the same shape as the terrain. I know this isn't specifically a Terrain3D question but is there a simple way to have a dynamically shaped collsion shape on the terrain so this grass will be placed accurately?

---

**tokisangames** - 2025-05-22 01:58

SGT is redundant. Read the collision doc and change use full collision mode to place grass.

---

**1sudo** - 2025-05-22 01:59

Ah, I remember reading about that and forgot. Worked like a charm, thank you.

---

**tokisangames** - 2025-05-22 02:13

* Networking just means you to sync your data to every client. It has nothing to do with us, as we run locally.
* We provide a terrain and an instancer, and an example particle shader. How you build your terrain, or create procedural tools on top of the infrastructure is up to you.
* Region streaming with instances is only half done. Particle shaders are less fixed, but not quite streamed.
> Will Terrain3D present limitations when blending or meshing biome boundaries?
There is no finished biome implementation. The limitations will depends on your implementation. 
> like a forest smoothly transitioning into a snowy mountain area or desert
Our environmental artists are handling this just fine with manual texturing and placement. If you think you'll do as well with automatic placement based on programming, I doubt it, and not likely faster.
> Can Terrain3D support environmental systems like seasons and weather per biome?
Terrain3D is only a terrain and instancer. Sky3D is a daynight cycle, lighting, environment, and time manager. Weather and biomes are not implemented. You're going to have to do some work, and preferably contribute it. Snow is commonly applied with texturing, screen space shaders, footstep mesh, and material overlays.

---

**bottroy_91014** - 2025-05-22 03:12

Hi Cory, I just compared 0.9.2 and 1.0.0. the latest version is definitely different. I used textures from your demo project. I hope this PR will fix this https://github.com/TokisanGames/Terrain3D/pull/679 because i love terrain3d. though, i indeed didn't pick heigh texture. Visually 0.9.2 and 1.0.0 look different

---

**bottroy_91014** - 2025-05-22 06:54

<@455610038350774273> this is how blending works in 1.0.0. It is still blocky. demo scenes have same problem. Autoshader blends well. I can't make blocky in 0.9.2. There must be an issue with 1.0.0 😦

📎 Attachment: blending2.png

---

**catgamedev** - 2025-05-22 06:58

For what it's worth, this is my experience in 1.0.0-dev. No spray overlay here, just base painted texture. Textures by Blink

Why is yours so square <:hmm:1033283820897710090>

📎 Attachment: image.png

---

**berilli** - 2025-05-22 07:47

Hello! Is there any news about displacement? Hope to use it for vehicle trails with tire tread pattern. With dynamic collision I think it would let make something simular to Snowrunner

---

**xtarsia** - 2025-05-22 07:56

I'll pick it back up after blend-gate is over 🙂

---

**tokisangames** - 2025-05-22 11:37

It is _a little_ blockier than before. That is being fixed in the next PR. However it blends just fine if textures have heights and the [correct technique](https://terrain3d.readthedocs.io/en/stable/docs/texture_painting.html#manual-painting-technique) is used.

📎 Attachment: 342DE871-6671-49B7-A896-C24B2D2FE667.png

---

**tokisangames** - 2025-05-22 11:40

My post on twitter is the latest news. However displacement is the wrong tool for tire tracks and snow footsteps. Search this discord for discussions on how people did snow tracks or footsteps.

---

**darkmessiah22** - 2025-05-22 14:34

Hello! Is there any way to load/unload regions without freezing? I've tried `add_region_blank` but it causes a freeze.

---

**tokisangames** - 2025-05-22 15:30

Not a freeze, but a stutter for a few frames? You can edit an individual region on the fly, with  collision updates, but when you change the number of regions it must rebuild the whole array, combining all three maps for all regions. Your system might be able to handle that only on a tiny terrain. 
This will be more feasible when we have region streaming working and optimized, but that may require streaming capabilities in the engine.

---

**grawarr** - 2025-05-22 17:15

Hello everyone! First time user here. I have decent experience with Gaea and some terrain knowledge from working with frostbite engine modding. I want to create a terrain (Ideally with a workflow that consists of me exporting my heightfield and some masks for tileable textures from gaea). I have trouble with the overall scaling of my terrain. I exported it from gaea as 10km² but it looks as if It is smaller in Godot. What am I doing wrong? Also how can I use mask textures exported from gaea to determine the tileable distribution instead of the autotexture thing?

📎 Attachment: image.png

---

**tokisangames** - 2025-05-22 18:34

Read the heightmap doc. Adjust your lateral scale before export, in photoshop, or in Terrain3D (vertex_spacing). Or adjust your vertical scale.
For textures, you need to determine how Gaea can export, and use that documentation with our API to apply texturing. Eg it may be a splat map. It's an easy programming task, and a few people have extended the importer for splatmaps, but so far no one has contributed their work.

---

**wowtrafalgar** - 2025-05-22 18:56

have you guys had luck generating occluders or for large terrains is the juice not worth the squeeze? (4k)

---

**tokisangames** - 2025-05-22 19:12

What do you mean luck? We used it on OOTA without issue. I just baked an occluder for 50 regions at 1024, 3x the size of your terrain. Just save the data in an external file.

---

**grawarr** - 2025-05-22 19:33

I will look into that thank you. Also for replying so fast<3

---

**catgamedev** - 2025-05-22 22:06

Okay I finally figured this out and the culprit was this guy in project settings

📎 Attachment: image.png

---

**catgamedev** - 2025-05-22 22:15

I don't exactly see why that is causing a problem with the particle grass

---

**catgamedev** - 2025-05-22 22:15

but it is

---

**tokisangames** - 2025-05-23 01:16

Ah, I think we knew particle grass isn't setup for PI yet, but forgot about it. The terrain had to make changes to support it. It should be a easy fix. If you want to help out you can make an issue on github that the particle grass doesn't support physics interpolation.

---

**catgamedev** - 2025-05-23 01:41

I made an issue! .. I don't think I see how to fix that myself

---

**catgamedev** - 2025-05-23 01:42

definitely something I'd call low priority, I can't even tell a difference with PI checked on my 144Hz monitor

---

**tokisangames** - 2025-05-23 02:20

I believe PI is relevant for sub 30fps.

---

**bottroy_91014** - 2025-05-23 05:05

Hi Cory, thank you for responding. that PR definitely improves blending. I will try to understand what I'm doing wrong with 1.0.0. Your picture doesn't look blocky. Thank you for helping!

📎 Attachment: not-blocky.png

---

**ghurir** - 2025-05-24 22:22

Yo, I am trying to get your plugin to work as an in-game editor. The only way I can think of is to re-implement the features. But there are many advanced features that do not have an API.

I don't know a lot about how plugins work, so I wanted to ask about how viable it would be to rewrite it to work in-game, and maybe some resources you could point me to.

Or maybe you have a better idea.

Thank you for taking the time to read my message

---

**mkgiga** - 2025-05-25 00:53

Anyone know how to turn off the grid visible in the screenshot?

📎 Attachment: image.png

---

**mkgiga** - 2025-05-25 00:54

nvm, this is just me making shit too big after setting region size to 64

---

**tokisangames** - 2025-05-25 01:31

Perspective / View Gizmos

---

**tokisangames** - 2025-05-25 01:59

A specific quality of EditorPlugins is that they aren't loaded in game. Further, there are some editor features we use that are only available in editor. Your suggestion would require writing a class that provides the missing infrastructure of EditorPlugin, EditorInterface, and some of the Godot Editor UI,  then initializes our UI, which would also need to be modified to not assume it's running in editor. It's possible. I could do it with a bit of work. You'd have to understand those classes and editor_plugin.gd to start off, but all our GDScript code would need to be reviewed.

I'm not opposed to it. Being able to pull up an in game editor would be cool. But it's a nice to have feature, and my efforts are needed on other tasks. It would be a big undertaking for a new contributor. I wouldn't recommend that unless you were interested in being a long time Terrain3D contributor. If you just want an editor for your game, just copy whatever code and adapt it. It's much easier to make something specific to your game than to make something generic and useful to all.

---

**grimdynasty** - 2025-05-25 08:11

Hi all, just installed from the asset Library. I was trying to start playing around with the extension but I am currently struggling to access related objects from c#. I did try regenerate the csproj file

📎 Attachment: image.png

---

**tokisangames** - 2025-05-25 09:18

Read the programming languages doc. There is an early PR for C# bindings.

---

**grawarr** - 2025-05-25 18:13

Using Mask Textures (exported from gaea) to determine where on a terrain a tileable material is placed is not a feature of Terrain3D yet right? I might make that part of my Thesis. Would be great for prototyping games.

---

**grawarr** - 2025-05-25 18:14

could be scaled up to also link a set of objects for scattering on those masked areas too. Would be nice for biome creation

---

**tokisangames** - 2025-05-25 20:59

We do not import texture layout data from any other tool yet. It's a very easy thing to make, all you need is the specification from their documentation and a script to translate that into our specification and using our API.
Scattering objects we already have an instancer and particle shader.
My thoughts on [Biome creation](https://github.com/TokisanGames/Terrain3D/discussions/656#discussioncomment-12598843).

---

**grawarr** - 2025-05-25 21:34

Thanks for the thorough reply! If my prof approves I‘ll spend considerable time on it

---

**totsamui.** - 2025-05-25 23:38

hi guys. yesterday i updated to the latest version of the addon and i got a strange bug when i reload the scene or load it a second time all textures stop displaying.
although the grass works as it should.
i already saved everything i could as separate files
tried to manually set materials when loading the scene
but nothing helps.

I installed it as it was written in the recommendations, removed the old one and installed the new one
as far as I understood, no other manipulations were required

📎 Attachment: image.png

---

**totsamui.** - 2025-05-25 23:38

help pls

---

**tokisangames** - 2025-05-25 23:42

Uncheck renderer / free_editor_textures, as mentioned in the release notes.

---

**totsamui.** - 2025-05-25 23:52

oh thank you very much. I'm so glad that everything works now because it looked very scary for me)
can I know where it was written about the need to uncheck free_editor_textures? I searched on github and wiki but did not find it. I would like to know for the future what I missed.
thank you again for your help and for the addon itself ❤️

---

**tokisangames** - 2025-05-26 00:11

Release notes like I said. The notes where you downloaded the file, in github. Even the asset library links to it.

---

**jubilant_dragon_81368** - 2025-05-26 10:24

Haha, I also encountered this problem and was just about to ask

---

**tokisangames** - 2025-05-26 11:02

With [PR 700](https://github.com/TokisanGames/Terrain3D/pull/700) merged, available in nightly builds, `free_editor_textures` now reloads textures then frees them again. So if you're loading scenes via code, it now handles textures automatically. 
<@349449190671384576> <@223577781068365845> <@572604045777436672> <@1201339717925482658> <@124678615618027524>

---

**tranquilmarmot** - 2025-05-26 18:56

Anybody ever seen an issue where the game crashes and this gets printed to the error console ~100 times:
```
E 0:00:16:214   reserve: reserve() called with a capacity smaller than the current size. This is likely a mistake.
  <C++ Error>   Condition "p_size < size()" is true.
  <C++ Source>  ./core/templates/local_vector.h:150 @ reserve()
```

Followed by:
```
W 0:00:16:434   push_warning: Terrain3D#5663:_notification: NOTIFICATION_CRASH
  <C++ Source>  core/variant/variant_utility.cpp:1119 @ push_warning()
```

I can't get consistent repro, but this is in a scene where ~100 rigid bodies go flying and hit the terrain.

I'm using Godot `v4.5.dev4`, so that may be causing problems since I never ran into this on v4.4 and haven't changed much. Going to try Terrain3D nightly and see if that helps (on `v1.0.0-stable` right now)

---

**tranquilmarmot** - 2025-05-26 19:09

Nope, happens on `v4.4.1` with nightly Terrain3D as well, but in Godot `v4.4.1` it doesn't print _anything_ out to the console 🤔

---

**tokisangames** - 2025-05-26 19:47

> this is in a scene where ~100 rigid bodies go flying and hit the terrain. 
Does it happen only after this? Never before? Can you reproduce it running Jolt?

---

**madman4290** - 2025-05-26 20:24

do sit here and is trying to work with viewports, but for some reason the terrain, is trying to grab/set camara, and this apparently messes with the entire system
Error code: 0:00:22:927   push_error: Terrain3D#0768:_grab_camera: Cannot find the active camera. Set it manually with Terrain3D.set_camera(). Stopping _physics_process()  <C++ Source>  core/variant/variant_utility.cpp:1098 @ push_error()
i do not know where to begin with understanding this, and hopes that some can point me in direction of some clearance

📎 Attachment: image.png

---

**shadowdragon_86** - 2025-05-26 20:39

Try putting this script on your Terrain3D node, reload the scene and assign your camera:

```
@tool
extends Terrain3D

@export var camera: Camera3D:
    set(value):
        camera = value
        set_camera(camera)
```

📎 Attachment: image.png

---

**madman4290** - 2025-05-26 20:43

exact script, or will camara3d, be the path, to any camara

---

**shadowdragon_86** - 2025-05-26 20:44

Exact script. The @export means you can set the value using the editor.

---

**shadowdragon_86** - 2025-05-26 20:44

Drag and drop your camera on to the Assign button.

---

**shadowdragon_86** - 2025-05-26 20:44

Or press the button and select from the list

---

**madman4290** - 2025-05-26 20:45

thanks just wanted to be sure, that i read it right, you never know where others might use, place words

---

**madman4290** - 2025-05-26 20:47

ohm, the screen that contains the terrain does not hold the camara as a default, that is only when the game is played, but i will look into pathing it out

---

**tokisangames** - 2025-05-26 20:51

> > Set it manually with Terrain3D.set_camera().
> i do not know where to begin with understanding this
You don't understand this? Don't you have code in your game? You can set this anywhere. Typically a camera is attached to your player, and your player's _ready() would tell the terrain where the camera is.

---

**madman4290** - 2025-05-26 20:54

yes, but it seams that sins i have moved the viewport form the root node, to a child of the root, and a parent of the player, and out of the hiarcy of the terrian, it kind of bugs out, as it have no active view port to connect to

my meaning with "understand" is, what can i do to avoid this bugging out, or to limit the error code to a area that i am more in control off

---

**tokisangames** - 2025-05-26 21:01

You are in control of your whole game and the tree. You moved your terrain and subscenes somewhere either in the scenes or via code. It doesn't matter where in the tree your terrain and camera are, just tell the terrain where you put the camera. Do you have code in your game? Use [get_node()](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-get-node) or [find_child()](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-find-child) from the root node of your game if you don't know where you put it.

---

**madman4290** - 2025-05-26 21:03

oh okay, if there is nothing more to it, then i will surely do that, thanks for the quick respondses, i just want to be sure that i do not begin to dig into codes, and notes that will ruin the terrain system, and leave me with further problems

---

**madman4290** - 2025-05-26 21:52

i am sorry to say and bother people once again but i seam unable to figure out how to connect/set the camara, to the terrain, with the player getting added into the screen after the fact, and is there for first a part of the screen.
with the before given example and information of the solution

---

**madman4290** - 2025-05-26 21:52

```@tool
extends Terrain3D

@export var camera: Camera3D:
    set(value):
        camera = value
        set_camera(camera)```

---

**tranquilmarmot** - 2025-05-26 22:11

I am using Jolt. After a ton of trial and error, I narrowed it down to something completely unrelated to Terrain3D, so never mind me 😅

---

**madman4290** - 2025-05-26 22:13

i also figured this out, apparently terrain gets place into the screen far quicker then the camara, so all the times it have looked for it, and it was not there, was because it was not place into the system yet, i do think a simple await command will fix this

---

**wowtrafalgar** - 2025-05-26 22:42

any tips on how to get the normals for a billboard texture. For my low level of detail grass it is a rendered image of the grass that I use a y billboard on. I am simply making the  NORMAL = vec3(0.0, 1.0, 0.0); in fragment, but wondering if there is an easy way to get the normal of the terrain

---

**madman4290** - 2025-05-26 22:52

i retact this statment, as i seam unable to find any node with pathing, and the camera seams unable to be found (for some bloddy reason)

---

**tranquilmarmot** - 2025-05-26 23:03

Not sure it it'll help, but I use this add-on:
https://phantom-camera.dev/

With Phantom Camera, you only ever have on `Camera3D` but you have multiple `PhantomCamera3D` nodes that have priorities to switch between them. The add-on takes control of the `Camera3D` and moves it around for you. _Very_ useful if you have multiple cameras, and it works great with Terrain3D since you only ever have one `Camera3D` so you don't have to figure out updating which camera the terrain is using.

---

**madman4290** - 2025-05-26 23:05

i currently only have one camera, but i intent for there to be a maximum of 5 cameras active

---

**tranquilmarmot** - 2025-05-26 23:05

5 at the same time?

---

**madman4290** - 2025-05-26 23:06

correct, but not connected to the same player

---

**tokisangames** - 2025-05-26 23:36

You get the normal by sampling the height in 3 perpendicular points, then rise over run to get the slope, then convert the two slopes into a vector3. Our shader and C++ both have the normal calc algorithm.

---

**tokisangames** - 2025-05-26 23:44

Knowing where your cameras are in the tree, when they're loading, and how to call a function are part of learning how to program in GDScript. This is a very easy task. The remote scene viewer, which you screenshotted, shows you exactly where they are. Get_node which I linked for you shows you how to specify paths anywhere in the tree. You only need one line of code to call set_camera(). We can't write your game for you or teach you how to program. You need to spend more time with programming tutorials to learn how to navigate nodes in the tree. In the meantime, if you post small snippets of the code that instantiates your player and terrain scenes, perhaps we can discuss your code. We can't do anything without specific details.

---

**madman4290** - 2025-05-26 23:50

I know what to do, how to do it.

I am not asking you to make the game for me, I am asking for help, cause even when running the system with the set.camera function, and trying all kind of paths, and getting the entire tree printed, to find the correct path, the system still tells me that it can't find the bloody camera, even with a await function, cause I noticed in trying to print the tree, that I did not, indicating, that the camera came in way to late, for the terrains ready function to get it 

 I have around 3-4 hours a day to work on this, so I do be sorry if I sound angry, but it is a rather large problem for me to only get the same error code, regardless of what path I use to find the node

---

**tokisangames** - 2025-05-27 00:02

We're all busy. I offered to look at your code. We can't help you without details of your setup.
Setting the camera does work, and has worked for thousands of users.

---

**madman4290** - 2025-05-27 00:17

I get that it works, I am not complianning about that, I am just generally, complaining that nothing seams to work, and that regardless of how I seemingly does things, there is no effect or change in the outcome. that is what is iretating me, no clear progression regardless of the attempt of advancing or slowing the problem

---

**wowtrafalgar** - 2025-05-27 01:14

what a difference in visibility and the blending with the 3d meshes! I thought my alpha scissoring was off but it was all lighting!

📎 Attachment: image.png

---

**wowtrafalgar** - 2025-05-27 01:15

*(no text content)*

📎 Attachment: image.png

---

**wowtrafalgar** - 2025-05-27 02:36

how can I turn the grid off? I checked the debug views and couldn't find a toggle

📎 Attachment: image.png

---

**tokisangames** - 2025-05-27 03:23

Perspective / View gizmos

---

**miameow7859** - 2025-05-27 20:10

Hi! I am reimplementing an old game and have reversed their terrain format and extracted the heightmap and converted to the correct format (I think). 

https://snaps.screensnapr.io/73b9e56e795883393112ad5294949a

This game supported "infinite" terrains, with it's own "region" concept. So top left 512x512 region is sector 1, top right is sector 3 etc

https://snaps.screensnapr.io/10e59aba2ca4c0d5031fcd8508748b

The game then just repeats these regions, they never change and can't be rotated. It then places each of the 512x512 regions in a specific way based on a "grid" like this

```
polytrn_sectors            1    3    1    3    1    3    1    3 ; width here must match above
polytrn_sectors            2    4    2    4    2    4    2    4
polytrn_sectors            1    3    1    3    1    3    1    3
polytrn_sectors            2    4    2    4    2    4    2    4 ; width here must match above
polytrn_sectors            1    3    1    3    1    3    1    3
polytrn_sectors            2    4    2    4    2    4    2    4
polytrn_sectors            1    3    1    3    1    3    1    3 ; width here must match above
polytrn_sectors            2    4    2    4    2    4    2    4
```

Where the numbers correspond to the region/sector in the second screenshot. 

So, my question is, is there a simple way to basically "instance" each region so I can create an 8x8 grid of 512x512 regions so 4096x4096 total. I can generate the region files manually and name them correctly and it works but it seems silly since it's all duplicate data. In other words my "region 1,0" will be placed everywhere there is a `1` in the above grid. "region 1,1" will be placed everywhere there is a `3` in the grid, etc. 

Hopefully this is clear, any input is much appreciated!

---

**tokisangames** - 2025-05-27 21:11

Edit the shader and you can repeat visually. You'll have to modify the code and rebuild to support collision infinitely.

---

**miameow7859** - 2025-05-27 21:24

Thanks! Infinite was probably the wrong word, it's really just the  same four 512x512 "regions" placed in the grid to make a total terrain size of 4096x4096. Since I think 4096x4096 is probably fairly small (?) I may just generate the region files manually (or rather import the heightmap once, then copy and rename the 4 files it outputs 16 times) unless this is a bad idea, I hesitated originally since it's so much duplicate data, but maybe it doesn't matter much and plus then I could edit the regions which would end up generating those files anyway

---

**tokisangames** - 2025-05-27 21:36

We support up to 65,535m per side, so 4096m is fine. You can import your files in a simple for loop, or do it manually.

---

**madman4290** - 2025-05-27 21:54

okay i have made some progress on my problem with the camera, and it seams that when i send it
sting
and node path, it will then respond with
```Invalid type in function 'set_camera' in base 'Terrain3D (terrain_3d.gd)'. Cannot convert argument 1 from NodePath to Object.```
```Invalid type in function 'set_camera' in base 'Terrain3D (terrain_3d.gd)'. Cannot convert argument 1 from String to Object. ```
and then when i give it a object id, it will keep on responding with
```E 0:00:25:546   push_error: Terrain3D#0657:_grab_camera: Cannot find the active camera. Set it manually with Terrain3D.set_camera(). Stopping _physics_process()
  <C++ Source>  core/variant/variant_utility.cpp:1098 @ push_error()```
so now i am more or less bewildered, and wish to ask, what am i to give it if not a object id

examples of the things i give it

object id: $"SubViewport/CharacterBody3D/visable_head/Camera3D" = Object ID: xxxxxxxxxxx
sting: "SubViewport/CharacterBody3D/visable_head/Camera3D" = "SubViewport/CharacterBody3D/visable_head/Camera3D"
node path: NodePath("SubViewport/CharacterBody3D/visable_head/Camera3D") = SubViewport/CharacterBody3D/visable_head/Camera3D

---

**tokisangames** - 2025-05-28 02:07

The docs online and built in to Godot specify set_camera() wants a Camera3D. https://terrain3d.readthedocs.io/en/latest/api/class_terrain3d.html#class-terrain3d-method-set-camera
The first error message said it wants an Object, not a NodePath, which is basically a string.
The NodePath doc specifies it is to be used with get_node().
https://docs.godotengine.org/en/stable/classes/class_nodepath.html
Get_node() specifies it returns a Node, which is an Object, and if the path is right, also a Camera3D, by inheritance.
https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-get-node

---

**tokisangames** - 2025-05-28 02:09

An object ID is an int.
Also you wrote everything but your code that calls set_camera().

---

**madman4290** - 2025-05-28 08:27

the reason that the call function was left out is because it is clearly clalling/getting the things that it is calling, so that is realy not the problem at hand, form my perspective. bug if it intrests you, it is a simble variable refrance call

sends the information:  get_tree().get_root().get_node("Node3D").player_1_camera = $"SubViewport/CharacterBody3D/visable_head/Camera3D"

takes the information: set_camera(get_tree().get_root().get_node("Node3D").player_1_camera)

the later part of the "sends the information, is what is changed with, "examples of the things i give"
but with what you are saying in regard to node_path, that i am to use get_node, i do not get as i do no see that in the doc
but as you say regarding get:node, that it returns objects, witch is what i have shown above, is the only thing that it is not reacting to, and yes it is a camera object that it is getting

see image for the clear path that is to get to the camera, and that matches the get_node/$ path that is made to get the object id, of the camera3d

📎 Attachment: image.png

---

**tokisangames** - 2025-05-28 09:17

```
extends Terrain3D
func _ready() -> void: 
  var camera: Camera3D = get_tree().get_root().get_node("Node3D").player_1_camera
  print(camera)
  set_camera(camera)
```
If this outputs null, then you are not setting up the variable correctly. If it prints Camera3D#12345, Terrain3D should accept it fine.

In the script shown in the picture, print the camera, immediately after setting it. If it's null, it's not the right path.
`print(get_tree().get_root().get_node("Node3D").player_1_camera)`

---

**tokisangames** - 2025-05-28 09:19

This is an awkward way to structure your code. You'd do better if you created an autoload class and put your global variables in there. Ours is called Game, and anywhere I can access `Game.player`, `Game.terrain`, `Game.player.camera` from anywhere instead of all of these long chained commands. Each is set properly by its owner on creation.

---

**rizlahunter** - 2025-05-28 09:28

Hi I was wondering if you could help me, I have been calling the Terrain3D C++ methods from another C++ GD Extension, where I generate the geometry. To get this to work I had to compile the Terrain3D classes into my DLL, and also remove the Terrain 3d plugin from the plugins folder (so I cannot use Terrain3d in the editor), otherwise the engine calls the plugin Terrain3d and my code calls my compiled Terrain3d. I originally wanted to use the Terrain 3D plugin DLL and link to it, however the DLL does not seem to export the  C++ class methods that are needed to  use it in this way. Is there a way to build Terrain3D from source that will allow me to use the plugin DLL in my GD Extension? I'm using Godot 4.4.1 with C++17 and Terrain3d on the v1.0.0-stable tag and windows. Sorry if this has been discussed before but I could not find anything.

---

**tokisangames** - 2025-05-28 10:31

How experienced are you with C++?

---

**tokisangames** - 2025-05-28 10:32

> I had to compile the Terrain3D classes into my DLL
You definitely should not do this.

---

**tokisangames** - 2025-05-28 10:35

You can either call Terrain3D through the exposed GDscript interface, see Programming Languages doc. Or you can use only the header files and link to the library.
> however the DLL does not seem to export the  C++ class methods that are needed to  use it in this way
How did you determine this?

---

**tokisangames** - 2025-05-28 10:47

We haven't had anyone link to the C++ directly that we know of, but it should work fine like any library. We share the Godot namespace, which isn't ideal for a pure C++ library, but we're only a godot dependent library. I think the bigger issue you'll have is if you want to pass Terrain3D objects and data back and forth through the gdexention interface between Godot/gdscript/your extension. Should be doable but may be tricky.

---

**rizlahunter** - 2025-05-28 10:56

My first approach was to use the header files, and link to the plugin library files. When I did this I got a lot of linker errors, such as:
`19:39:16:839    C:\dev\repos\godot-shooter\terrain_builder.windows.template_debug.x86_64.obj : error LNK2019: unresolved external symbol "public: void __cdecl Terrain3D::set_data_directory(class godot::String)" (?set_data_directory@Terrain3D@@QEAAXVString@godot@@@Z) referenced in function "public: virtual void __cdecl shooter::TerrainBuilder::_ready(void)" (?_ready@TerrainBuilder@shooter@@UEAAXXZ)`.
 I will undo my current configuration and get it building using the header files and DLL so I can debug properly. I don't think the namespace is an issue, I have my own namespace for my code and haven't had any issues. I have included the lib with scons:
```
19:39:08:513      LIBS     : [<SCons.Node.FS.File object at 0x00000217B17F5000>, 'libterrain.windows.debug.x86_64']
```

---

**tokisangames** - 2025-05-28 11:08

Are you using the same godot-cpp version as Terrain3D uses in your version?
> I have included the lib with scons
Is it actually being included into the linker command?

---

**tokisangames** - 2025-05-28 11:15

Is your _ready() virtual? Why? Anyway you [shouldn't use](https://github.com/godotengine/godot-cpp/issues/1022) _ready() in gdextension.

---

**rizlahunter** - 2025-05-28 11:48

My ready method isn't virtual, it was being called ok when built, however I will check this I'm not sure why its virtual in the log. I'm recompiling everything from scratch, making sure its all using the same godot-cpp version. Its helpful to know that you think this should work, thanks for the help.

---

**sal2340132** - 2025-05-28 14:24

hi, I want to generate terrains from noise, that has caves and overhangs but without using voxels. someone did suggest me to find a data structure that could hold this type of mesh but I'm sort of lost as to how I can get something like this working. I will also need to generate the terrain in C++ , so either through GDextension or modules.
Terrain3D seems to have some similar functionalities but from what I can see it doesn't look like I could use it like I mentioned. Can I use it that way and if not would you have any other suggestions or resources for realizing the type of terrain I've described?

---

**tokisangames** - 2025-05-28 14:36

Terrains come in only three forms:
* Voxels for true 3D. Caves and overhangs are possible.
* Heightmaps for simulated 3D. Caves and overhangs are not possible.
* Meshes sculpted and textured in blender. Caves and overhangs are possible.
You can do a mixture of 2 & 3, as shown in our demo.
How do you intend to make caves and overhangs, from (3D) noise, via code, without voxels?

---

**tokisangames** - 2025-05-28 14:37

A voxel terrain is the only way I know how to do all of this.

---

**sal2340132** - 2025-05-28 14:40

I was thinking of first generating a heightmap, for overhangs I thought slightly morphing the vertices horizontally based on some noise would work and as for caves someone said I could distribute them using "spline SDFs". But I'm not sure of any of this and just trying to learn if there is a way to do it

---

**sal2340132** - 2025-05-28 14:41

other people I asked were more positive about it. for instance someone said I can use marching cubes without voxels to get a static mesh

---

**tokisangames** - 2025-05-28 14:45

Heightmap terrains have only one vertex per height. You can morph them to any one height. To do two heights you need two vertices, which means you don't have a heightmap terrain. You could make your own new terrain type that supports multiple vertices per height, but why not just use a voxel terrain? It does exactly what you want. Marching cubes is a voxel meshing algorithm. I suppose you could bake it into a static mesh, but for what benefit?

---

**sal2340132** - 2025-05-28 14:50

this could be why I got suggested to find a suitable data structure, so that I can more freely play with vertices maybe. to my understanding a mesh is supposed to be more morphable am I wrong, I was thinking to treat the mesh as a height-map initially then procedurally sort of sculpt it afterwards. as to why I don't want to use voxels, my terrains are not going to be editable so I was told this type of generation would be way faster as compared to voxels. what I meant by marching cubes without voxels wasn't baking after generation but not using voxel values at all. at least I was told that was possible

---

**tokisangames** - 2025-05-28 15:03

Heightmap terrains are faster than voxel terrains. But you want features of voxels that heightmaps cannot do.

Marching cubes is voxels, unless baked as a static mesh (eg remeshing in blender). There is no marching cubes without voxels otherwise.

We morph our terrain mesh up to every frame. But you can't create new vertices as easily as you can morph. A data structure isn't going to help you with that. You need to design a new terrain type that is a heightmap with layers so that you have enough vertices to provide enough density for your cave walls. Are you going to support only one cave plus the terrain on top? Or are you going to support top side terrain, and 1, 2, 3 or more caves below? If you want full flexibility, you'll need to create some sort of 3D height map terrain, a special variant of the 2D terrain type that allows you to have as many vertical levels as needed. You'll create essentially a 3D grid of fixed points, with sufficient vertices to handle all of the heights you want. AKA a voxel terrain.

---

**sal2340132** - 2025-05-28 15:07

cave systems should pretty much be true 3D not heightmap like. actually just like voxels but without using any voxels, I just need a static mesh. can't I apply noise to 2 or 3 casual meshes then combine them or subtract one from the other etc? like what I have seen about CSG meshes but noise applied to them and not just basic shapes

---

**sal2340132** - 2025-05-28 15:09

or can I use an existing data structure like ArrayMesh or something similar and load it with 3D vertices and not only heightmap?

---

**tokisangames** - 2025-05-28 15:24

CSG usually uses primitives, which have simple formulas for SDFs rather than 3D noise, but perhaps you could do it. ArrayMesh just stores vertices for static meshes. The data structure is neither the problem nor the solution. Marching cubes to bake 3D noise into a static mesh is going to be easier than trying to do CSG. Coming up with your own meshing algorithm to turn 3D noise into a mesh without using a voxel algorithm is going to be very challenging, since that's exactly what they are and why they exist.

Anyway, Terrain3D can't do what you want and I've told you my recommended solutions. Zylann's Voxel Terrain is good. Look at my godot voxel playlist: https://www.youtube.com/playlist?list=PLOVQ_NzPZeBZo0Z_5De3yBKp7IxnQd3bw

---

**sal2340132** - 2025-05-28 15:28

yes I know the voxel tools, I'm coming from there actually. if I can't find any other simpler and cheaper way I would choose baking the marching cubes result into a static mesh I guess. thank you for the explanations

---

**nucky.rsps** - 2025-05-28 17:29

Is there any way to blend the tiles better? the auto shader is blending the cliff good but when I pain overlays on top they are very blocky

📎 Attachment: Godot_v4.4.1-stable_mono_win64_iJ7oaOtlcZ.jpg

---

**nucky.rsps** - 2025-05-28 17:29

*(no text content)*

📎 Attachment: Godot_v4.4.1-stable_mono_win64_fLCeMl66ei.jpg

---

**tokisangames** - 2025-05-28 17:31

https://discord.com/channels/691957978680786944/1130291534802202735/1375075013820153937

---

**nucky.rsps** - 2025-05-28 17:42

Is there a way to make the control blend look more like the autoshader?

📎 Attachment: Godot_v4.4.1-stable_mono_win64_TjI8HLYZKY.mp4

---

**tokisangames** - 2025-05-28 17:44

Use the Spray tool. That's part of the documented technique I linked

---

**tokisangames** - 2025-05-28 17:44

And use heights in your textures

---

**tokisangames** - 2025-05-28 17:45

The picture I posted there was done in the demo, which has height textures, and used the spray tool to add the blend value

---

**tokisangames** - 2025-05-28 17:46

Spray with the blend debug view enabled. Make the brush large enough and low enough strength until you see it gradually accumulating

---

**nucky.rsps** - 2025-05-28 17:52

I guess i'm asking if it's possible to blend a path if the size of the brush is 1

---

**nucky.rsps** - 2025-05-28 17:53

cuz if I increase the brush size I can make it blend

📎 Attachment: Godot_v4.4.1-stable_mono_win64_drwAbvPl3K.jpg

---

**nucky.rsps** - 2025-05-28 17:53

*(no text content)*

📎 Attachment: Godot_v4.4.1-stable_mono_win64_IhRuIZeCaX.png

---

**tokisangames** - 2025-05-28 18:03

Since you're having difficulty, you'll likely have to wait until we merge Xtarsia's pending PR. It's nearly done. But you can test it now

---

**rizlahunter** - 2025-05-28 19:16

Hi <@455610038350774273> , I have rebuilt and checked that everything is installed, both my extension and Terrain3d are built using the godot-4.4.1-stable tag. When I dump the DLL it only includes the terrain_3d_init function:
```
File Type: DLL
  Section contains the following exports for libterrain.windows.debug.x86_64.dll
    00000000 characteristics
    FFFFFFFF time date stamp
        0.00 version
           1 ordinal base
           1 number of functions
           1 number of names
    ordinal hint RVA      name
          1    0 0001616C terrain_3d_init = @ILT+86375(terrain_3d_init)
```
And I still get the linker errors:
```C:\dev\repos\godot-shooter\terrain_builder.windows.template_debug.x86_64.obj : error LNK2019: unresolved external symbol "public: void __cdecl Terrain3DCollision::update(bool)" (?update@Terrain3DCollision@@QEAAX_N@Z) referenced in function "private: void __cdecl shooter::TerrainBuilder::_on_terrain_ready(void)" (?_on_terrain_ready@TerrainBuilder@shooter@@AEAAXXZ)```
I could add a micro such as  `#define TERRAIN3D_API __declspec(dllexport)`  to the Terrain3d classes, or do you think there is another way to fix it?

---

**madman4290** - 2025-05-28 20:02

i have been excited all day to see if this works
and sadly, it does not

even with the code 
```
extends Terrain3D

func _ready() -> void: 
    await get_tree().create_timer(0.1).timeout (in place so that player_1_camera can get its object id, in time)
    var camera: Camera3D = get_tree().get_root().get_node("Node3D").player_1_camera
    print(camera)
    set_camera(camera)```

i do still get the error code that i always have gotten sins this al started ```E 0:00:22:849   push_error: Terrain3D#0657:_grab_camera: Cannot find the active camera. Set it manually with Terrain3D.set_camera(). Stopping _physics_process()
  <C++ Source>  core/variant/variant_utility.cpp:1098 @ push_error() ```

and that is regardless of the the printed outcome being: Camera3D:<Camera3D#55784245186>

so at this point, i am just about to remove the plugin, cause sure it works great, if and when it works

---

**shadowdragon_86** - 2025-05-28 20:06

While you are waiting for 0.1 second, the plugin doesn;t have a camera so will push that error

---

**shadowdragon_86** - 2025-05-28 20:06

Does it actually work?

---

**xtarsia** - 2025-05-28 20:06

The error is reported before.

---

**xtarsia** - 2025-05-28 20:08

You can call set_camera on the terrain after it's instantiated, but before you add it as a child, to avoid the error.

---

**madman4290** - 2025-05-28 20:08

the wait time is there because the camera and its parrent node, that placeses in the information, is not there at the very first instance, and needs to be placed in, with out the await function, the print, will show null

---

**shadowdragon_86** - 2025-05-28 20:08

So does the game work? Despite the error?

---

**madman4290** - 2025-05-28 20:09

it does, but that is only visiable if i begin to use godoes camara deatatchment (or what ever the free flow camera is named)

---

**madman4290** - 2025-05-28 20:50

the terrain, is not added in any way, and is there on the screen when the game is firstly placed into/activated for the game to start

---

**eriotic** - 2025-05-28 21:01

Has anyone had any issues using the texturing painting feature? Right now I'm just using two different textures for the ground but it will only display the "base" texture. I did the all of the texture packing etc and made sure the textures are the same size. It just doesn't seem to do anything when I try to paint the 2nd texture layer onto of the 1st

---

**madman4290** - 2025-05-28 21:04

do try and see if you you have something in debig views, active

📎 Attachment: image.png

---

**eriotic** - 2025-05-28 21:06

where do I pull that menu up?  Is that the "Debugger" at the bottom of the screen?

📎 Attachment: image.png

---

**madman4290** - 2025-05-28 21:07

it is under the inspectore/material, and then down past a lot of slides

---

**madman4290** - 2025-05-28 21:07

*(no text content)*

📎 Attachment: image.png

---

**eriotic** - 2025-05-28 21:09

Okay thanks found it! This is what I see by default

📎 Attachment: image.png

---

**madman4290** - 2025-05-28 21:10

okay, there is a debug view, beyond the material

---

**tokisangames** - 2025-05-28 21:11

Can you paint both textures in our demo?

---

**madman4290** - 2025-05-28 21:11

but sadly i do not know much beyond checking that

---

**eriotic** - 2025-05-28 21:12

ah let me try the demo scene, Im trying in my own scene at the moment

---

**eriotic** - 2025-05-28 21:13

yes the demo scene does work

---

**tokisangames** - 2025-05-28 21:15

Make a new scene, with the terrain and a camera. No viewports. Just to confirm the terrain is working properly. If so, the issue is related to your VP setup.

---

**tokisangames** - 2025-05-28 21:16

Did you create a region?

---

**eriotic** - 2025-05-28 21:18

Dont believe I did, I just installed the plugin for my project, restarted, then added the terrain3d node. Then i added some textures but didn't do anything specific under the "Region" tab

---

**eriotic** - 2025-05-28 21:19

are you referring to here?

📎 Attachment: image.png

---

**madman4290** - 2025-05-28 21:20

with the subview, removed, it all works fine, no major problems there

---

**tokisangames** - 2025-05-28 21:21

If indeed it only has that one function, then the library won't work at all in the editor, and it wasn't built properly. If it does work in the editor, it has much more than the one function, and this test is faulty.
What Godot-cpp branch and commit date for both extensions? 
The linker error is different this time. Why? Did it get farther than before?
What would the macro do? Does it work?

---

**tokisangames** - 2025-05-28 21:21

Read the intro and user interface docs. No regions, no editing. Region tool is on the left tool bar

---

**tokisangames** - 2025-05-28 21:22

So the terrain is working fine. This is a Godot vp configuration problem. Perhaps render layers, perhaps environment, etc. We don't know how you have it setup.

---

**tokisangames** - 2025-05-28 21:23

You're now have the correct position via the camera node, so it's just a matter of the correct vp config.

---

**vhsotter** - 2025-05-28 21:24

First things first, you'll want to set a data directory so your changes are saved. So create a folder to save terrain data and set that in the node. Then when you select the Terrain3D node, there's a column of tool icons that should be on the left. One is a `[+]` icon at the very top that is usually selected by default. Make sure it is, then put your mouse somewhere in the viewport. You should see a big square region highlight. Click and that'll add a region. Then try to paint the textures you want.

Failing that, like Cory said, read through the intro and follow everything exactly step-by-step.

---

**madman4290** - 2025-05-28 21:24

i sadly do not know what you are talking about

---

**eriotic** - 2025-05-28 21:26

Thank you, I missed the [+] step and now it's working

---

**tokisangames** - 2025-05-28 21:27

Vp is viewport. Without your vp, you see the terrain works fine. With your vp, you can't see the terrain. You could uninstall the plugin and use another terrain and you'll have the same problem. Your camera, vp, and environment aren't configured properly.

---

**madman4290** - 2025-05-28 21:28

arr okay, now i get what you are talking about, when you said godot vp configuration, and environment, i was under the idea that it was something in regard to the settings of godot

---

**madman4290** - 2025-05-28 21:35

do you guys have any document, in regard to the setting up/configuration of view ports, or cameras.
cause sadly all i am able to find is some collision document, and rendering

---

**tokisangames** - 2025-05-28 21:40

Here we just make terrain, not VPs. In my project, I used the Godot docs, and experimentation.

---

**madman4290** - 2025-05-28 21:44

(deep exhale)

---

**biome** - 2025-05-28 23:42

How do I remove painted meshes?

---

**tokisangames** - 2025-05-29 02:07

Ctrl removes for all tools, ctrl+shift for all mesh types. Read UI doc.

---

**biome** - 2025-05-29 02:11

Thanks

---

**ryan_wastaken** - 2025-05-29 06:38

Can Terrain3D for iOS be cross-compiled from Linux, or do I need a Mac to compile it for iOS?

---

**tokisangames** - 2025-05-29 07:12

Mac is BSD, but you need to build it with xcode and the sdk. I used to build Godot export templates for ios and mac in a linux docker, so yes it can be done. Start [here](https://docs.godotengine.org/en/stable/contributing/development/compiling/compiling_for_macos.html)

---

**raouflamri** - 2025-05-29 08:24

Hey, I added the plugin to my own project but it's not showing in the preview. Which folder should I choose in the "Data Directory"?

📎 Attachment: whattodo.JPG

---

**raouflamri** - 2025-05-29 08:25

I'm a complete noob btw, so bear with me here lol

---

**raouflamri** - 2025-05-29 08:43

Oop, I was able to add texture to the ground. Is there a way to add everything with the mountains, just like shown in the demo?

---

**vhsotter** - 2025-05-29 08:47

The Data Directory can be anything you want. Preferably an empty folder because that's where Terrain3D will save that data.

---

**vhsotter** - 2025-05-29 08:49

You will want to watch the tutorial videos and read the documentation. They explain everything you need to know to get started and how to paint textures and modify the terrain.

---

**raouflamri** - 2025-05-29 08:51

Ah I see, got it. Is there a way to add the pre-built terrain directly?

---

**raouflamri** - 2025-05-29 08:51

I understand how to modify

---

**tokisangames** - 2025-05-29 09:10

Not at this time. You can import heightmaps made elsewhere or generated via code.

---

**raouflamri** - 2025-05-29 09:11

Bet

---

**vhsotter** - 2025-05-30 20:48

A while back the initial release of the instancer LOD system had this issue where LODs would vanish at a certain extremely slim margin before the next LOD level would appear. I remember talk about this and the introduction of some sort of overlap to prevent this. Did that correction make it in? I ask because I'm still seeing the issue occurring as of the current version.

---

**xtarsia** - 2025-05-30 20:51

Yes, though it's a very small overlap still.

---

