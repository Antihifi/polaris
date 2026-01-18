# terrain-help page 20

*Terrain3D Discord Archive - 544 messages*

---

**stormeaglee** - 2023-07-17 15:59

greetings, excited to try out this plugin. although, must be just my luck but I can't seem to get it installed. While following the installation instructions, I can't seem to enable plugin, I get this error. 

Unable to load addon script from path: 'res://addons/terrain_3d/editor/editor.gd'. This might be due to a code error in that script.
Disabling the addon at 'res://addons/terrain_3d/editor/plugin.cfg' to prevent further errors.

I'm running Godot v4.1-stable_mono_win64 and downloaded the plugin for that version.

---

**tokisangames** - 2023-07-17 16:03

Is this after restarting Godot? 
Is this with the release binary? 
Can you try with the non mono version first? I haven't tried the mono builds yet.

---

**tokisangames** - 2023-07-17 16:05

There must be other errors in your console, such as what it found in editor.Gd that it didn't like. Can you share them?

---

**saul2025** - 2023-07-17 16:13

Maybe it possible that you included the addons folder that the plugin had when you  installed it  initially, and that gave you the error. Happened to me sometime ago.

---

**stormeaglee** - 2023-07-17 16:25

Thanks for the quick responses.
- Error does occur after restarting Godot
- Just tried it with the non-mono version

---

**stormeaglee** - 2023-07-17 16:25

Ok, turns out it was my anti-virus

---

**tokisangames** - 2023-07-17 16:27

Does it work with the mono version?

---

**stormeaglee** - 2023-07-17 16:30

i'll check

---

**stormeaglee** - 2023-07-17 16:34

seems to work fine now

---

**tokisangames** - 2023-07-17 16:34

Thanks for testing it so I don't have to.

---

**stormeaglee** - 2023-07-17 16:34

no problem, thanks for the plugin

---

**stormeaglee** - 2023-07-17 16:35

just for reference, the problematic file for the anti-virus was the libterrain.windows.debug.x86_64.dll

---

**tokisangames** - 2023-07-17 16:35

ok

---

**saul2025** - 2023-07-17 17:45

Does anyone have issues when exporting to png it still says rgb8 even after instructions?

---

**tokisangames** - 2023-07-17 17:56

Which map are you exporting?

---

**saul2025** - 2023-07-17 18:00

it a texture, it says it is rgb8 dxt 1

---

**tokisangames** - 2023-07-17 18:04

Please elaborate on what you are doing and the software. Are you creating textures in a third party app, or using the "export" function in Terrain3D?

---

**saul2025** - 2023-07-17 18:05

in a third party  app, it krita., what happens is that when importing the texture to godot and applying the recommended sething, to use it for terrain texture paint, it does not work

---

**tokisangames** - 2023-07-17 18:10

I recommended Gimp as the best tool to channel pack alpha properly. TBH I don't know how to properly pack the alpha channel in using photoshop or krita. Gimp will produce properly packed PNGs or DDSs.
The PNG is not dxt1. Godot converts png and other files to a DDS using DXT1 in this case. That's why it's recommended that you convert to DDS yourself so you get the exact right format rather than their buggy auto conversion.

---

**saul2025** - 2023-07-17 18:12

alright, will try it.

---

**_zylann** - 2023-07-17 18:16

I should probably make an updated version of my channel packing plugin

---

**tokisangames** - 2023-07-17 18:17

We need to incorporate it in our tool anyway, as well as expand the importer/exporter

---

**_zylann** - 2023-07-17 18:17

I wish Godot's import system was sophisticated enough to do it, but I for now I dont want to get near it anymore lol wasted too much time making custom texture importers

---

**jcostello2517** - 2023-07-17 18:22

trying to build the plugin I get this
```
src/terrain_3d_storage.cpp: In member function 'godot::TypedArray<godot::Image> Terrain3DStorage::get_maps(Terrain3DStorage::MapType) const':                                       src/terrain_3d_storage.cpp:841:24: error: could not convert 'godot::Ref<godot::Image>()' from 'godot::Ref<godot::Image>' to 'godot::TypedArray<godot::Image>'
  841 |                 return Ref<Image>();                                                                                                                                              |                        ^~~~~~~~~~~~                                                                                                                                         
      |                        |                                                                                                                                                          |                        godot::Ref<godot::Image>                                                                                                                             
src/terrain_3d_storage.cpp:856:16: error: could not convert 'godot::Ref<godot::Image>()' from 'godot::Ref<godot::Image>' to 'godot::TypedArray<godot::Image>'                         856 |         return Ref<Image>();                                                                                                                                                
      |                ^~~~~~~~~~~~                                                                                                                                                       |                |                                                                                                                                                            
      |                godot::Ref<godot::Image>
```

---

**jcostello2517** - 2023-07-17 18:22

Linux

---

**tokisangames** - 2023-07-17 18:27

Ah, duh. That's because the code is wrong.

---

**tokisangames** - 2023-07-17 18:27

In terrain_3d_storage on lines 841/856 try replacing `return Ref<Image>();` with `return TypedArray<Image>();`

---

**tokisangames** - 2023-07-17 18:41

<@113223592988217344> <@549363464708292608> I pushed an update that fixes the errors you sent me. I was able to build w/ gcc on WSL linux, though haven't run it.

---

**jcostello2517** - 2023-07-17 18:44

After that fix, it built sucessfully

---

**jcostello2517** - 2023-07-17 18:45

sees to work fine on linux

---

**jcostello2517** - 2023-07-17 18:45

No errors, working smoth. Im trying texture painting now

---

**tokisangames** - 2023-07-17 18:45

Thanks for testing

---

**jcostello2517** - 2023-07-17 18:45

performance is really good

---

**ee0pdt** - 2023-07-17 18:45

builds on Mac with the fix above plus the additional switch

---

**tokisangames** - 2023-07-17 18:46

Great

---

**ee0pdt** - 2023-07-17 18:48

It lives! (on Mac)

📎 Attachment: image.png

---

**jcostello2517** - 2023-07-17 18:50

```
WARNING: Terrain3D::_texture_is_valid: Invalid format. Expected DXT5 RGBA8.
```

---

**jcostello2517** - 2023-07-17 18:50

with a jpg and png texture

---

**jcostello2517** - 2023-07-17 18:50

downloaded from polyheaven

---

**tokisangames** - 2023-07-17 18:52

channel packed properly? The message suggests not. Read the wiki/Textures

---

**ee0pdt** - 2023-07-17 18:52

~90fps on M2 Pro

---

**tokisangames** - 2023-07-17 18:53

What video card? Is that good? I get 400-450 in the demo on a laptop 3070

---

**jcostello2517** - 2023-07-17 18:54

<@455610038350774273> right, I didnt realize I have to pack the channels

---

**ee0pdt** - 2023-07-17 18:55

It's Apple's integrated GPU cores. I'm not sure how optimised Godot is for Apple Silicon to be honest. This is the base model M2 Pro

---

**ee0pdt** - 2023-07-17 18:55

Not sure if it was pushing all 3024 × 1964 pixels

---

**ee0pdt** - 2023-07-17 18:55

lemme check

---

**tokisangames** - 2023-07-17 18:56

Oh also that was 400+ at 1080p. 90 at 4k on an integrated gpu sounds on par with Saul's igpu.

---

**saul2025** - 2023-07-17 18:59

Not sure about that  M2 is way more powerful than my igpu,

---

**ee0pdt** - 2023-07-17 19:00

230fps if I disable HiDPI

---

**saul2025** - 2023-07-17 19:02

ye, i think it would be good to have a youtube tutorial to do that in gimp, about making the textures compatible with the terrain.

---

**saul2025** - 2023-07-17 19:09

aside from that on my issues installed gimp, exported as DDS on BC3, but can't import to godot. BtW sorry if i sound dumb at this stuff.

---

**jcostello2517** - 2023-07-17 19:10

UV rotation with normals mekes the texture look weird

📎 Attachment: image.png

---

**jcostello2517** - 2023-07-17 19:10

no rotation

📎 Attachment: image.png

---

**tokisangames** - 2023-07-17 19:11

Make an issue please.

---

**tokisangames** - 2023-07-17 19:15

decompose rgb, add a layer called alpha with your greyscale height or roughness, and compose rgba
https://www.youtube.com/watch?v=pG8OHpVUHdI

---

**tokisangames** - 2023-07-17 19:17

I can't help with `can't import`. Why? What does it say? If it isn't RGBA BC3/DXT5 it won't import.

---

**jcostello2517** - 2023-07-17 19:18

Is not posible to allow each texture file to be placed?

---

**jcostello2517** - 2023-07-17 19:18

it would be so much user friendly

---

**tokisangames** - 2023-07-17 19:20

Yes later. There was just too many other things to do for an alpha release. Like not crashing when you click the viewport or load the engine.

---

**jcostello2517** - 2023-07-17 19:20

Got it 💪

---

**saul2025** - 2023-07-18 03:59

what do you mean by that?

---

**kashlavor** - 2023-07-18 05:07

anyone else getting `res://addons/TerrainPlugin/Shader/VisualShaderNodeNoisePerlin2D.gd:63 - Parse Error: The function signature doesn't match the parent. Parent signature is "_get_global_code(Shader.Mode) -> String"`

---

**tokisangames** - 2023-07-18 05:48

That file doesn't exist in our plugin. And our add-ons directory is called terrain_3d. Rebuild / redownload and reinstall according to the docs.

---

**kashlavor** - 2023-07-18 05:50

Thank you for that, so the issue was user error by having too many github pages open at once lol

---

**kashlavor** - 2023-07-18 06:00

now that I'm not mixing up 3D Terrain Plugin with Terrain3D looks like its working great, looking forward to trying it out

---

**saul2025** - 2023-07-18 07:20

exported as png with these sething and it finally works.  posting it so, other´s can avoid this issues with textures.

📎 Attachment: important_png.png

---

**tokisangames** - 2023-07-18 07:31

Great thanks for finding these PNG settings. Save transparent pixel color values is not necessary? Also 16-bit RGBA is probably unnecessary. 8-bit RGBA should do. Here's the english version. I'll put this in the docs.

📎 Attachment: image.png

---

**diealp** - 2023-07-18 07:39

Hi all, can someone build the plugin for mac and Gotod 4.1 and release it? I'm not able to do it...

---

**saul2025** - 2023-07-18 07:41

ye, but i didn´t find 8 bit i only found 16 bpc in the export. about the transparent pixels, i am not sure, didn´t tried it, but the map worked.

---

**tokisangames** - 2023-07-18 07:46

<@113223592988217344> built it fine. If you can zip/tar up your files, I'll put it on github. Grab everything inside of the project folder, except .godot

---

**diealp** - 2023-07-18 07:51

I don't understand what I have to do? the project I'm working on is needed to build the plugin? sorry but I'm a plugin newbie 🙂

---

**tokisangames** - 2023-07-18 08:06

That message was for Pete. 
For you, without a binary, you need to follow the step by step directions in the wiki. 
https://github.com/outobugi/Terrain3D/wiki/Building-From-Source

---

**diealp** - 2023-07-18 08:07

ok, so there's no plan to release a macos binary like you already do for windows?

---

**tokisangames** - 2023-07-18 08:08

Please read the message I just sent to Pete. I'll post community builds. I do not plan to buy a mac for building releases on it and setting up the OSX cross compiling build chain for godot is a huge amount of work. Much simpler for you to just install the build tools

---

**diealp** - 2023-07-18 08:10

Ok, I understand, so I'll wait for community builds, sorry for the stupid questions 🙂

---

**tokisangames** - 2023-07-18 08:24

I just posted a linux binary for 4.1 that I built using WSL linux. If someone can test it that would be great. If you're already setup, you can just drop in the libterrain.linux.debug.x86_64.so and see if it works.
https://github.com/outobugi/Terrain3D/releases/tag/v0.8-alpha_gd4.1

---

**ee0pdt** - 2023-07-18 09:05

Mac build

📎 Attachment: project.zip

---

**ee0pdt** - 2023-07-18 09:05

<@439709423276130307> this was built for ARM (M1 and M2 processors)

---

**ee0pdt** - 2023-07-18 09:05

if you need Intel support I would have to build again

---

**diealp** - 2023-07-18 09:10

thanks, I'll try in the next hours! 🙂

---

**tokisangames** - 2023-07-18 09:11

Thanks. I added it to the repo releases. If you're setup for intel, I can upload that as well.

---

**nickdev_** - 2023-07-18 13:55

Just did a quick test of this linux binary... works perfectly. 👍

---

**tokisangames** - 2023-07-18 13:56

Thanks

---

**nickdev_** - 2023-07-18 14:05

Exporting to a debug build works well, but not a full release build. I might be missing something/doing something wrong though.

📎 Attachment: image.png

---

**tokisangames** - 2023-07-18 14:12

Great for debug. There is no release file only a debug file. Must be recompiled for release mode

---

**nickdev_** - 2023-07-18 14:13

Ah, there we go then.

---

**tokisangames** - 2023-07-18 15:40

I wrote up instructions for how to set up channel packed textures with gimp using either DDS or PNG files. Thanks <@726112813801537676> for finding the right png settings. Though Photoshop and krita can work with such files, we haven't found the ideal workflow yet. Better to just download gimp until we build channel packing into Terrain3D.
https://github.com/outobugi/Terrain3D/wiki/Setting-Up-Textures#how-to-channel-pack-images-with-gimp

---

**nickdev_** - 2023-07-18 15:51

In terms of bringing tiled terrain over from world machine etc... is the current workflow to use the importer tool and manually import and position each tile?

---

**nickdev_** - 2023-07-18 15:52

Also, not sure how the control texture comes into play from these tools

---

**tokisangames** - 2023-07-18 15:52

I haven't used worldmachine. If it can give you one large or many small heightmaps as EXR or R16, you can manually import and position them in the importer tool.

---

**tokisangames** - 2023-07-18 15:53

Control is our proprietary format for texturing. You won't be able to import painted texture from another tool. You'll have to repaint.

---

**nickdev_** - 2023-07-18 15:54

Lovely. Yes it can create either one image or multiple tiles. Also exports to r16. Going to experiment with worldmachine and this.

---

**nickdev_** - 2023-07-18 15:54

Is there any future plans to import/convert splatmaps into the control texture?

---

**tokisangames** - 2023-07-18 15:56

Hadn't thought about it until now. We'll have to understand and write code for the proprietary formats of every other tool: WM, Unity, UE, hterrain etc. If we do it will be way down the priority list

---

**tokisangames** - 2023-07-18 15:56

We haven't even finalized our own format as we have a lot of work still to do on texturing.

---

**nickdev_** - 2023-07-18 16:02

Cool. Good to know.

---

**tokisangames** - 2023-07-18 16:02

https://github.com/outobugi/Terrain3D/issues/135

---

**saul2025** - 2023-07-18 16:12

Cool, great job.

---

**chevifier** - 2023-07-18 18:16

You need to make a release build of libterrain.(platform).release.so file

---

**chevifier** - 2023-07-18 18:26

Iirc in terminal "scons target=release" i believe its debug by default

---

**chevifier** - 2023-07-18 22:24

the actual comand is 
```
scons target=template_release
```

---

**chevifier** - 2023-07-18 22:24

finally got to my PC😅

---

**tokisangames** - 2023-07-19 06:34

Both debug and release build work fine just by adding what <@271097940779597824> added. I don't notice any difference in speed between debug/release mode. Updated docs. 
Also I opened up a new channel for git updates

---

**carbon3169** - 2023-07-19 23:09

*(no text content)*

📎 Attachment: image.png

---

**outobugi** - 2023-07-19 23:53

ugh <@455610038350774273> the terrain is doing the thing again 😭

---

**outobugi** - 2023-07-19 23:55

or is it? At first glance that looked liked wrong normals but it seems to be incorrect height on one region...

---

**outobugi** - 2023-07-19 23:56

pls enable debug collision and see if the collision shape aligns with that edge

---

**outobugi** - 2023-07-19 23:58

also is this imported hmap or sculpted in editor?

---

**tokisangames** - 2023-07-20 02:48

Built off latest commit with the smoothing fix? Looks like not.
https://github.com/outobugi/Terrain3D/issues/112

---

**tokisangames** - 2023-07-20 15:02

<@326282043799633924> Really basic settings, just the defaults, plus 100 units and setting the terrain node. gd4.1.1. Shape is a box 25^3

📎 Attachment: image.png

---

**alzioo** - 2023-07-20 15:07

I can't figure out why it's not working here with godot 4.1

📎 Attachment: image.png

---

**tokisangames** - 2023-07-20 15:08

Get rid of `project on colliders` and use `project on terrain3d`. You're not even using the script.

---

**tokisangames** - 2023-07-20 15:08

There are no terrain3d colliders in the editor (unless you turn on show debug collision)

---

**alzioo** - 2023-07-20 15:09

Omg Thanks I understand what the script is doing right now I did not know I had to select it

---

**alzioo** - 2023-07-20 15:09

Thanks a lot

---

**alzioo** - 2023-07-20 15:10

So last thing, we can't combine the scatter to work on CSG and terrain for example ?

---

**alzioo** - 2023-07-20 15:11

It's not really a problem for me but just to know

---

**tokisangames** - 2023-07-20 15:13

Out of scope for me. You'll have to ask hungry or figure it out yourself, such as trying it with both. Project on colliders will ignore terrain3d in the editor. Don't know aboutin game.
You shouldn't be using CSG in a game anyway. It's only for greyboxing and prototypes.

---

**alzioo** - 2023-07-20 15:16

It's not really a problem I guess since I can have a scatter with coliders enabled and one with terrain3D colliders working too
I was talking also for static body with a meshInstance but you respond and i'm good with it thx!

---

**jcostello2517** - 2023-07-20 16:50

is there a way to bake the scatter spread?

---

**jcostello2517** - 2023-07-20 16:50

so when loading the game loads intantly instead of reacalculating again?

---

**tokisangames** - 2023-07-20 17:02

Scatter isn't my plugin to support. However Hungry added a way recently. You can add a scattercache node. Make sure to save the file as a .res

---

**jcostello2517** - 2023-07-20 17:22

Nice

---

**drewied** - 2023-07-20 21:19

Just curious  - has anyone successfully built  Terrain3D for Godot 4.x on Mac Intel? I am having issues with the build on Mojave and I now know it is an issue with godot-cpp as per the issue I raised. Please share some  insights on which godot-cpp tag/steps to use. Thanks

---

**tokisangames** - 2023-07-21 03:51

Have you asked on Godot discord, and rocket chat servers, and searched issues on godot-cpp github?
Have you tried to build the example project using other tags like 4.0.3-stable?

---

**99p008889u5** - 2023-07-21 16:33

Hello, I need help with mask layers, I want to export my terrain from l3dt, but there are two different image options rgba or grayscale, and I don't know how to insert multiple images for texture layers

---

**tokisangames** - 2023-07-21 19:15

What do you mean by Mask layer?
Are you exporting a heightmap? Our wiki has a lot of documentation on importing data, recommended formats. You want a format with 16-bit data like raw/r16/exr. Rgba typically means 8-bit per channel. Greyscale means one channel, but didn't specify if that channel is 8/16/32bit. Really you should just try them all and experiment to see what works, and read the docs. You can import in multiple maps in multiple locations.

---

**99p008889u5** - 2023-07-21 19:17

Thanks, but I've already figured it out, I meant masks that determine which texture the plugin will apply to a certain area of the terrain

---

**99p008889u5** - 2023-07-21 19:17

that control file stuff

---

**tokisangames** - 2023-07-21 19:18

I would experiment with g16, r16 and tga. Read the docs of both tools.
http://www.bundysoft.com/docs/doku.php?id=l3dt:formats:support

---

**tokisangames** - 2023-07-21 19:18

Control files are for texturing. They and we have a proprietary format that cannot work across tools at this time.

---

**tokisangames** - 2023-07-21 19:19

You'll have to repaint

---

**tokisangames** - 2023-07-21 19:20

Or you could do it programmatically. You'll have to look up their and our format and write a script to convert them

---

**tokisangames** - 2023-07-21 19:20

Our API gives access to the control map images.

---

**99p008889u5** - 2023-07-21 19:21

ok so i can try parse my textures masks by script and import them

---

**99p008889u5** - 2023-07-21 19:21

sorry for asking

---

**tokisangames** - 2023-07-21 19:23

I mean a script that does a per pixel conversion of one format to the other. E. G. Their control map blends materials 3, 9, and 6 at this pixel. That translates to a base of 3,and an overlay of 9 and a blend value of 50% and you drop 6 as the lowest weighting. Only suitable if you're a programmer

---

**slimeyseal** - 2023-07-23 15:31

Hello there, forgive my ignorance if this is a noob problem, but I am running into a problem with enabling the plugin in Godot 4.0. The editor.gd script complains about undeclared identifiers. I'm guessing there is a problem with reading/loading the dll file in the bin directory, but I'm not too sure. Has anyone run into this before? Any guidance or advice would be greatly appreciated!

📎 Attachment: image.png

---

**tokisangames** - 2023-07-23 17:02

What platform? Which file did you download? Which version of Godot? Did you follow the instructions in the Readme? We need information to help.

---

**slimeyseal** - 2023-07-23 17:17

Apologies, I using windows. I downloaded the 
terrain3d_0.8.1-alpha_gd4.1.1_win64.zip file from the latest release and copied the addons/terrain_3d to my project addons/terrain_3d. I made it to step 4 of the installation & setup instructions, it keeps just complaining about unable to load editor.gd whenever I try to enable the plugin... I'm using Godot 4.0 😅.

---

**tokisangames** - 2023-07-23 17:41

You said you're using Godot 4.0, but you downloaded the file for 4.1.1? Which version of Godot are you using?
Do you have dlls in addons/terrain_3d/bin?
Are you installing it in a project or just running the demo? 
Hmm, the instructions are unclear in regards to the demo, and I neglected to include the project file in the download, so they demo won't work. I'll rework it. Your project should still work though, or opening up the demo. It just won't play properly.

---

**tokisangames** - 2023-07-23 17:47

Run godot with the console.exe, and copy the errors messages from the beginning of your console. Not screenshots from the output panel.

---

**tokisangames** - 2023-07-23 17:51

I started a new project from that zip file with godot 4.1.1. and it works fine. The project file is needed to run the demo, but not to open it up and see the demo terrain.

---

**tokisangames** - 2023-07-23 17:52

Binary files updated with the project file included.

---

**slimeyseal** - 2023-07-23 17:55

Ok, yeah lol.... it was because I was using the godot 4.1 version while I was using 4.0, I just downloaded godot 4.1 and opened my project in that and it works now.... that's embarrassing 😅 Thanks for your time and help though!

📎 Attachment: image.png

---

**tokisangames** - 2023-07-23 17:56

There you go. At least you helped me find some problems with the documentation and release.

---

**andres_mpr** - 2023-07-24 14:04

Hi !!

---

**andres_mpr** - 2023-07-24 14:06

I'm quite new with this plugin, and just have one question. Why is limited to only DXT5 texture? Is there a problem or something if I make changes in the src to allow DXT1, because I have a lot of textures that are in jpg and does not have alpha channel

---

**andres_mpr** - 2023-07-24 14:14

PD: The code is beautifully written ❤️

---

**tokisangames** - 2023-07-24 14:16

Thanks.
The wiki documents what the channels are used for. If you don't want height blending, add a 1.0 or 0.5 alpha channel.  If you don't want roughness add a 1.0 or .7 roughness. But it's much better to create the missing textures with a utility like materialize.

---

**andres_mpr** - 2023-07-24 14:17

Ummm yeah, right...

---

**tokisangames** - 2023-07-24 14:18

It's FOSS so you can make a fork and change it, but you'll get 10x better results creating the PBR maps and using them.

---

**fishtaod** - 2023-07-24 16:32

Hi there,

Thank you so much for sharing such an amazing tool!! Really appreciate it!

I am having issues with it atm, and can't find any reference to these issues on github:
I am using a mac. the 4.1.1. version is unavailable, and the 4.1 doesn't allow me to load textures for new surfaces. Nothing happens when I drag and drop or click-load the albedo and normal texture.

Is this a known issue? Is there something I'm missing?

---

**tokisangames** - 2023-07-24 16:37

Look at the console. It probably says your textures are the wrong format. Look at the wiki to learn how to set them up properly.

---

**fishtaod** - 2023-07-24 16:38

Super, thanks a lot!

---

**carbon3169** - 2023-07-24 19:13

After exporting the project all textures disappeared

📎 Attachment: image.png

---

**carbon3169** - 2023-07-24 19:18

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2023-07-24 19:26

Export debug and run it with the console and review the logs. In your game code set the terrain debug level to debug so you get more logs.
Also test exporting the demo. That exports just fine

---

**skyrbunny** - 2023-07-26 05:49

how do you import heightmaps from hterrain? height.png from hterrain isn't a straight heightmap.

---

**tokisangames** - 2023-07-26 06:24

Hterrain stores height data in a .Res. You can directly import that file. There is no height.png as Godot doesn't support 16-bit pngs

---

**skyrbunny** - 2023-07-26 06:43

there's a .hterrain and a .tres, and importing neither works

---

**tokisangames** - 2023-07-26 06:45

When you set up hterrain, you must have specified a data directory that has all of your files, the ones I mentioned, and color.png, detail1.png, etc. Where is your data? Read the hterrain docs and look at the inspector.

---

**skyrbunny** - 2023-07-26 06:45

I'm looking at it!

📎 Attachment: image.png

---

**tokisangames** - 2023-07-26 06:49

He must have renamed it. What is data.hterrain? Large and binary?

---

**tokisangames** - 2023-07-26 06:53

Zylann's demo project has height.res, and data.hterrain is text 
https://github.com/Zylann/godot_hterrain_demo/tree/master/addons/zylann.hterrain_demo/terrain_data

---

**skyrbunny** - 2023-07-26 06:54

both .hterrain and .tres are hterrain_data.gd

---

**skyrbunny** - 2023-07-26 06:54

hmm.

---

**skyrbunny** - 2023-07-26 06:54

did I mess up?...

---

**skyrbunny** - 2023-07-26 06:54

this is the 4.0 branch, if that matters.

---

**skyrbunny** - 2023-07-26 06:55

here's what the console says when I try to import.

📎 Attachment: image.png

---

**tokisangames** - 2023-07-26 06:57

Data.hterrain is text. Look at it. You need to find where your height data is. Or just export it to exr using the export tool

---

**skyrbunny** - 2023-07-26 06:58

I'm looking at the hterrain and.... it's empty? how odd, the 4.0 branch is buggy.

---

**skyrbunny** - 2023-07-26 07:01

which export tool?

---

**tokisangames** - 2023-07-26 07:01

V4 still stores it's data in a file called "height.res"
https://github.com/Zylann/godot_heightmap_plugin/blob/master/addons/zylann.hterrain/hterrain_data.gd

---

**skyrbunny** - 2023-07-26 07:05

how.... odd.

---

**tokisangames** - 2023-07-26 07:05

The one built in to Zylann's tool. Did you look in the terrain menu?

---

**skyrbunny** - 2023-07-26 07:06

If you're talking about the panel with the brushes, that broke in 4.1

---

**skyrbunny** - 2023-07-26 07:06

wwhy... doesn't mine have that?...

---

**tokisangames** - 2023-07-26 07:07

From the documentation

📎 Attachment: image0.png

---

**tokisangames** - 2023-07-26 07:07

Export heightmap

---

**skyrbunny** - 2023-07-26 07:08

Damn, yeah, that broke. I wonder if I can fiddle with it

---

**tokisangames** - 2023-07-26 07:10

Or just find your height.res, which even in the current version source code is a format_rf 32-bit float image, which we can import directly.

---

**skyrbunny** - 2023-07-26 07:11

There is none, which is the problem. Also looks like hterrain updated to 4.1, so let's see if that works if I update

---

**tokisangames** - 2023-07-26 07:11

Maybe don't look at your files in Godot. Use your operating system file manager

---

**skyrbunny** - 2023-07-26 07:11

sorry to be bothersome haha

---

**skyrbunny** - 2023-07-26 07:11

already looked at that

---

**skyrbunny** - 2023-07-26 07:11

no dice.

---

**skyrbunny** - 2023-07-26 07:15

ok updating got me to the menu.

---

**skyrbunny** - 2023-07-26 07:17

alright thanks for pointing me in the right direction

---

**tokisangames** - 2023-07-26 15:28

Thanks for the note, I can confirm this is a bug as of 4.1.1. It will be more helpful if you file issues with details of what you tested like this:
https://github.com/outobugi/Terrain3D/issues/164

---

**carbon3169** - 2023-07-26 15:28

I deleted the .godot files and it worked 🙂

---

**tokisangames** - 2023-07-26 15:29

Oh really. Ok I'll try that too. Good to know.

---

**elmathi_as** - 2023-07-27 02:11

Hello,  I need help with something, how do u work with adding things like trees to the terrain? I tried using proton scatter addon something I use most of the times but the trees doesnt snap to the mesh of the terrain the just go to any height, same with gridmaps.

---

**elmathi_as** - 2023-07-27 02:12

Im not that experienced with godot maybe 2-3 months of use

---

**skellysoft** - 2023-07-27 03:11

Hey. Been trying to use the Terrain3D plugin, but when the collision is enabled it slows down a LOT, like to 2 - 5 fps... has anyone else had this?

---

**skellysoft** - 2023-07-27 03:20

Strangely, it happens even while rotating the camera around and not even colliding with the terrain...

---

**elmathi_as** - 2023-07-27 03:53

My problem was fixed by changing the level of the mesh to any number then returning the default value, seems like the mesh is just not updating on modifications, the collision is though so Im not really sure what's wrong

---

**skyrbunny** - 2023-07-27 05:08

Does the texture painter work? I can't seem to figure it out.

---

**saul2025** - 2023-07-27 05:28

It does, what problems do you have?

---

**saul2025** - 2023-07-27 05:29

it recommended to use the spray texture option aa works better and blends terrain. Also if you mean on texture they have to be dxt 5 check the wiki. https://github.com/outobugi/Terrain3D/wiki/Setting-Up-Textures#how-to-channel-pack-images-with-gimp

---

**tokisangames** - 2023-07-27 06:19

How does the demo work on your system? I get 400-500fps on a 3070. How large of a world are you doing? Very large, say 8k+ is likely not practical right now

---

**tokisangames** - 2023-07-27 06:20

We can't really support scatter here. We included a script as discussed in the wiki, front page. Install the modifier into scatter and objects will snap.

---

**tokisangames** - 2023-07-27 06:20

Try painting in the demo, which is already set up. Use spray paint only for now as Saul mentioned.

---

**skyrbunny** - 2023-07-27 06:34

wow i'm blind and didnt even see the surface panel. nevermind.

---

**skellysoft** - 2023-07-27 13:30

The demo works fine, 450 fps. I have no idea what could be causing the slowdown in my own code esp as if I just replace the terrain3d with a flat cube, this doesnt happen o_o

---

**skellysoft** - 2023-07-27 13:40

The only thing that seems to help is disabling gravity. And the world is 2x2 tiles large, so its pretty small

---

**tokisangames** - 2023-07-27 14:39

Good, you have a working scene and a non-working scene. Divide and conquer to figure out what is causing it.
Also Enable debug logging in Terrain3D and read what is in your console, but in the working and non-working.
An experienced dev would do the same action in both, dump the logs and run a diff on them.

---

**skellysoft** - 2023-07-27 14:40

Alright, will try it! Thanks.

---

**skellysoft** - 2023-07-27 18:43

Alright, so uh. I wouldn't ask for any further help here? But I'm pretty sure its not my code. I managed to strip everything in my project down to this:

```func _process(delta: float):
move_and_slide()
SpringArmPath.position = position+Vector3(0, ExtraCamHeight, 0)
SpringArmPath.rotation.y = rotation.y+deg_to_rad(180)


func _input(event) -> void:
if event is InputEventMouseMotion && event.relative.x != 0:
rotate_object_local(Vector3(0, 1, 0), -(event.relative.x/GlobalVariables.CONTROLS_MouseSensitivity)*GlobalVariables.CONTROLS_Invert_Val)
```

---

**skellysoft** - 2023-07-27 18:44

So its a SUPER basic 3p camera and player rotating, and uh. Even this still slows down a lot. Like, from 60 fps to 15-20, in exactly the same place as my more complicated script did.

---

**skellysoft** - 2023-07-27 18:45

Its when I look across the map at the far corner of the terrain3D. I have no idea why it could be doing this, but again, it doesn't do this if the collision is disabled for the Terrain3D plugin.

---

**skellysoft** - 2023-07-27 18:58

Oh - actually I didnt enable debug logging, I'll try that and see if I can get more info

---

**skellysoft** - 2023-07-27 19:48

Well I tried setting the  debug_level to info, and got this - 

Terrain3D::_notification: NOTIFICATION_ENTER_WORLD
Terrain3D::_notification: NOTIFICATION_ENTER_TREE
Terrain3D::build: Building the terrain
Terrain3D::_build_collision: Building collision with physics server
Terrain3D::_notification: NOTIFICATION_READY

---

**skellysoft** - 2023-07-27 19:50

But, still doesn't like running with collisions. I even copy pasted in the rotating code from the Terrain3D demo player but again, still slows down a lot when looking towards the map corner

---

**tokisangames** - 2023-07-27 20:01

Is this with the same terrain data and nodes as the demo?

---

**tokisangames** - 2023-07-27 20:02

Divide and conquer means scene tree as well

---

**skellysoft** - 2023-07-27 20:02

No, but I know from the profiler it is specifically the _process from my post up ^^^ there. Nothing else in the profiler is even coming close

---

**skellysoft** - 2023-07-27 20:03

So just move_and_slide, SpringArmPath.position = position+Vector3(0, ExtraCamHeight, 0) and 
SpringArmPath.rotation.y = rotation.y+deg_to_rad(180). 

I *can* however give it a whirl with the same terrain data as the demo

---

**tokisangames** - 2023-07-27 20:03

The demo runs at 450fps but your scene runs from 60 to 15-20? What is in your scene taking up 390fps?

---

**tokisangames** - 2023-07-27 20:05

How much frame time is _process taking?

---

**skellysoft** - 2023-07-27 20:05

Lemme check...

---

**skellysoft** - 2023-07-27 20:05

16.73 ms

---

**skellysoft** - 2023-07-27 20:06

of a total of 32.32ms on that frame when looking at the corner of the map

---

**tokisangames** - 2023-07-27 20:06

It's `move_and_slide()`, which means physics and your characterbody settings. What is in your scene?

---

**skellysoft** - 2023-07-27 20:08

Two charecterbodys but one self terminates as soon as it hits ready(), because ive got a line to make it queue_free if its set to invisible, which it is

---

**skellysoft** - 2023-07-27 20:08

thats a generic explorer node

---

**skellysoft** - 2023-07-27 20:09

a seperate camera for overhead exploration  but again, not currently used or set to current

---

**skellysoft** - 2023-07-27 20:09

a directionallight3d and a worldenvironment

---

**tokisangames** - 2023-07-27 20:11

How does the demo run with your terrain storage file?

---

**tokisangames** - 2023-07-27 20:12

What version of Godot and Terrain3D?

---

**skellysoft** - 2023-07-27 20:13

Godot V4.1.1 Stable Official

---

**skellysoft** - 2023-07-27 20:13

And 0.8.1 alpha of Terrain3D

---

**skellysoft** - 2023-07-27 20:14

I'll go test the terrain file with the demo. Its only a 3 by 3 flat grid lol

---

**tokisangames** - 2023-07-27 20:24

Then your scene with the demo terrain storage.res. 
This is part of divide and conquer. Slide it every way, including removing that extra character body and camera in a copied scene. and removing everything until you find the section of code or the nodes that cause the issue when present and resolve the issue when absent.

---

**skellysoft** - 2023-07-27 21:18

Okay, Ive reduced it down to literally just the player, an onscreen fps label and the terrain, and a directionallight. I figured if I reduced it down to its barest bones then i could work upwards from there? But its still giving the same issues when I look in the same direction. Theres nothing 3D on the map but the player and the terrain. There's only 4 active lines of code now, and disabling any of them results in not being able to rotate the camera to look at the part of the terrain that slows things down - *or* the player just drops through the floor.

---

**skellysoft** - 2023-07-27 21:21

The FPS doesn't drop *as* low but it is still distinctly half the FPS of it is for looking in any other direction.

---

**skellysoft** - 2023-07-27 21:28

Could it be the *scale* Im working at?

---

**skellysoft** - 2023-07-27 21:42

Okay I *think* I might of solved it - I *think* it's the scale. Terrain3D does not seem to like things at a large scale.

---

**tokisangames** - 2023-07-27 22:51

What do you mean scale? I don't think you can change the scale of Terrain3D. Where are you using scale and what amount?

---

**skyrbunny** - 2023-07-28 02:16

So, the yet untested navigation region baking does not seem to work. Is there anything I could do to make it work?

---

**skellysoft** - 2023-07-28 04:37

I mean the scale of my models etc and the height of the current camera. It was the only remaining difference between my program and the demo program, so I painstakingly scaled everything down and... no more slowdown! A real pain in the ass but yeah, it works now. Worth it for the amazing speed and performance boost. 🙂

---

**tokisangames** - 2023-07-28 05:17

What was your scale before? Scale can mess up a lot of things a game.

---

**skyrbunny** - 2023-07-28 07:42

Showing colliders helps with proton scatter, but not with navigation.

---

**saul2025** - 2023-07-28 08:01

For me on terrain helps placing models, so it reduces the  angle you can see the terrain and hides more polygon, though that works, because i strictly try to make the asset as optimized as possible while not trying to go low poly route.

---

**skellysoft** - 2023-07-28 11:03

Quite large, I'm now working at a teeny tiny scale. My player model was originally scaled by 50. :p

---

**tokisangames** - 2023-07-28 11:05

Generally physics bodies shouldn't be scaled, only meshes or collision shapes underneath. If collision is complex, it will kill performance as it needs to check many faces. You probably ran into that by scaling up the physics body and it compared many more collision faces than it needed to.

---

**tokisangames** - 2023-07-28 11:06

Had nothing to do with Terrain3D, only the poor quality physics engine.

---

**skellysoft** - 2023-07-28 11:10

oooft, yeah I guess that makes sense. Well, its sorted now. Oh - also, I meant just the player 3d model was scaled - I can't  remember the dimentions of the capsule collider before I changed it up

---

**tokisangames** - 2023-07-28 11:11

CharacterBody3D had a scale of 1?

---

**skellysoft** - 2023-07-28 11:11

I essentially decided to go through and make things to a similar scale as the demo collider

---

**skellysoft** - 2023-07-28 11:11

Yeah I don't scale colliders unless I can help it

---

**skellysoft** - 2023-07-28 11:11

I know its bad to do so so i try to avoid it

---

**skellysoft** - 2023-07-28 17:22

Hello again! My apologies to have to ask another question again so soon, but is there a way to *reliably* import textures to Godot as DXT5?

---

**skellysoft** - 2023-07-28 17:22

I've tried VRAM Uncompressed and VRAM Compressed but seemingly nothing works reliably on every texture.

---

**tokisangames** - 2023-07-28 17:42

Please read all the documentation in the wiki. The best process is already written out.

---

**skellysoft** - 2023-07-28 17:43

Alright, I'll take a second look. My bad!

---

**skellysoft** - 2023-07-28 18:04

Ah - yep, just found there's even specific importing tools. My bad, a bunch of - but not all - of my textures had somehow imported in DXT5 and I thought there was just something I was missing within Godot itself. Ta!

---

**saul2025** - 2023-07-28 19:42

Lucky, i had to reimport my textures from gimp and pack alb/heigh and normal/rough and then export as png, gladly it now easier becuase of improved documents, and because of downloading gimp.

---

**skellysoft** - 2023-07-28 22:54

Works just fine, I'm using the NVIDEA Exporter and can get it working just fine. My apologies for not reading the wiki more thoroughly!

---

**diestockente** - 2023-07-30 12:30

Hi, I am trying to import a .raw file to Terrain3D, which I exported from Zylann/godot_heightmap_plugin. But it doesn't work.
I export the heightmap from HTerrain as `32-bit Raw-float`. Then I try to import it into the Importer.tscn of Terrain3D.
I get following errors:
```
- No loader found for resource: res://terrain/hterrain/hterrain.raw.
  ./core/variant/variant_utility.cpp:905 - Terrain3D::load_image: Fileres://terrain/hterrain/hterrain.raw could not be loaded.
  ./core/variant/variant_utility.cpp:905 - Terrain3D::get_min_max: Provided image is not valid. Nothing to analyze
  ./core/variant/variant_utility.cpp:905 - Terrain3D::import_images: All images are empty. Nothing to import
```
The raw file is 16MB big and I attached here an image to show that the terrian works in HTerrain without problems. My question is: How can import the map from HTerrain to Terrain3D correctly?

📎 Attachment: image.png

---

**tokisangames** - 2023-07-30 13:11

We can read the .res file from hterrain directly. No need to export it. Just import it on our side.

---

**tokisangames** - 2023-07-30 13:12

The wiki article says rename raw files to r16. Raw/r16 is an integer format, and you must know the dimensions, scale as they aren't stored.

---

**tokisangames** - 2023-07-30 13:12

If you want to transfer with floats use exr, which both tools use

---

**diestockente** - 2023-07-30 13:32

Ah, forgot to rename it from .raw to r16. I read the wiki and tried it some days ago, without success. Today I tried it again and forgot about the article. When I come home again, I'll also try to import the hterrain directly. Thanks for your help!

---

**diestockente** - 2023-07-30 22:14

I tried it now with the .res file and it worked. 👍

---

**tokisangames** - 2023-07-30 22:52

<@199046815847415818> 👆

---

**skyrbunny** - 2023-07-30 22:54

thanks. I got it to export a few days ago, but I'll keep this in mind if the need arises in the future.

---

**tokisangames** - 2023-07-31 10:58

You are right. Rotation is currently broken. I want to remove it.
https://github.com/outobugi/Terrain3D/issues/169

---

**jcostello2517** - 2023-07-31 14:36

<@455610038350774273> Nice you fixed the normal calculations. There should be a way to rotate the normals too to look decent

---

**skyrbunny** - 2023-08-02 00:21

how would I get a region's bounding box?

---

**tokisangames** - 2023-08-02 05:00

A region isn't a discrete mesh. You can calculate it by getting the region height map and running get_min_max on it to get the height values. You already know the xz coordinates. If you just have a region id, you can get its region offset and multiply by region_size to get it's center coordinate.

---

**skyrbunny** - 2023-08-02 05:19

How do I get the xz?

---

**tokisangames** - 2023-08-02 05:20

Center coordinates +/- 0.5*region_size

---

**skyrbunny** - 2023-08-02 06:59

There doesn't appear to be anything to get the center coordinates of a specific region. Am I missing something?

---

**tokisangames** - 2023-08-02 07:02

How are you defining "a specific region"? Are you going through the list of region ids? 
BTW, I see a bug in the gdscript API...

---

**skyrbunny** - 2023-08-02 07:04

Ah yes, there is an unnamed arg in `get_region_offset`. What I mean is I'm looping through each one of these large squares, and I need to get the bounds of each one.

📎 Attachment: image.png

---

**tokisangames** - 2023-08-02 07:05

How exactly does your code know of "each one of these large squares"? Global coordinates, region offsets array, what?

---

**skyrbunny** - 2023-08-02 07:06

The problem is, it doesn't, and I am trying to figure out how to get each of them. 
Maybe I wasn't clear- there are the large 1024x squares added when you click `add region` in the terrain toolbar.

---

**skyrbunny** - 2023-08-02 07:06

there wasn't much of a size cue.

---

**skyrbunny** - 2023-08-02 07:06

That's why I'm calling them regions.

---

**tokisangames** - 2023-08-02 07:06

Yes those 1024 sized squares are regions

---

**tokisangames** - 2023-08-02 07:07

You said you are iterating through the regions. How are you doing it? Show me your code.

---

**skyrbunny** - 2023-08-02 07:10

I'm working on it, but the idea was basically 
```for region_index in range(terrain_data.get_index_count - 1):
  # Access the x and z coordinates of the two corners of the region here by getting the data by index.
```
The trouble is, I cannot figure out how to get the coordinates for the region.

---

**skyrbunny** - 2023-08-02 07:10

which is why I asked the question.

---

**tokisangames** - 2023-08-02 07:12

Use get_region_offsets instead which give you the region position in uv coords. Something like this
```
for region_uv in get_region_offsets():
  vec2 region_center = region_uv*region_size
  var region_index = get_region_index(region_center)
  var xz:rect = rect(region_center.x - region_size*.5, region_center.y - region_size*.5, region_size.x, region_size.y)
  var heights: vec2 = get_min_max( get_map_region( TYPE_HEIGHT, region_index ))

```

---

**skyrbunny** - 2023-08-02 07:13

For context, I suppose, I will state my goal: I am currently building a tool to build navmeshes for the terrain by baking it in chunks. For each region (since the regions added may not create a square) it would march along row by row column my column in chunks until it completed the region, then move to the next.

---

**skyrbunny** - 2023-08-02 07:14

`get_region_offset`, according to the code, it gets the position inside a region relative to the region for a set of coordinates?

---

**skyrbunny** - 2023-08-02 07:14

wait. plural. Is this a new version?

---

**tokisangames** - 2023-08-02 07:14

`get_region_offsets()` returns an array of all region positions in uv coords (ie within 16x16)

---

**tokisangames** - 2023-08-02 07:15

`get_region_offset(global_position)` returns the region uv for a given position

---

**skyrbunny** - 2023-08-02 07:17

when was this added? I'm using the build from two weeks ago.

---

**skyrbunny** - 2023-08-02 07:17

I don't see it in the docs.

---

**tokisangames** - 2023-08-02 07:18

You can use git blame or the blame option on the code page in github to see, but I think it's been there for a while.... two months ago
The 0.8.1 release build is ancient at this point, but should have that function.

---

**tokisangames** - 2023-08-02 07:20

Are you looking at the online help for _terrain3dstorage_?

---

**tokisangames** - 2023-08-02 07:21

It's not in the methods group, it's a `getter` for the properties, specifically `data_region_offsets`

---

**skyrbunny** - 2023-08-02 07:21

Terrain3DStorage in the godot docs menu.

---

**tokisangames** - 2023-08-02 07:21

It is in there

---

**skyrbunny** - 2023-08-02 07:21

oooh a getter

---

**skyrbunny** - 2023-08-02 07:21

i see

---

**skyrbunny** - 2023-08-02 07:21

data region offsets. I see it now

---

**tokisangames** - 2023-08-02 07:21

It's a clunky help "optimization"

---

**skyrbunny** - 2023-08-02 07:22

What coordinate space is this in? Is each unit a region, or a meter?

---

**tokisangames** - 2023-08-02 07:22

Instead I recommend looking at the gdscript api exposed in the code
https://github.com/outobugi/Terrain3D/blob/56429bf0230a5359c9b705e874c971e751697419/src/terrain_3d_storage.cpp#L1471

---

**tokisangames** - 2023-08-02 07:22

I mentioned it above. 16x16 region space

---

**skyrbunny** - 2023-08-02 07:23

I see, so the former. Alright let me see what I can do here

---

**tokisangames** - 2023-08-02 07:23

All the code I gave you should get you close to what you need

---

**skyrbunny** - 2023-08-02 09:16

Alright, I got it to work. ...Unfortunately, my approach seems to overload godot and cause it to crash, so I'll have to rethink my strategy.

---

**tokisangames** - 2023-08-02 09:20

Does it work for one region at a time?
Perhaps your work figuring out integration with the Nav server can find its way into Terrain3D

---

**skyrbunny** - 2023-08-02 09:26

nah, it crashes immediately, but only if I ask it to bake static colliders, so I think loading the terrain into the mesher or something like that is causing something to burst. Curiously, the same technique works when baking normally, just for one chunk... hm.

---

**skyrbunny** - 2023-08-02 09:33

hmm now it's crashing no mater what i do to it. This may be unrelated.

---

**skellysoft** - 2023-08-02 09:38

This *may* be unrelated? But when using Godot 3.5 and HTerrain (Zylanns terrain plugin), to bake navmeshes without crashing Godot (and this is on a fairly powerful PC, mind!) - I had to scale the terrain down to one tenth of the size to generate the navmesh, then scale it up afterwards. Maybe something similar will help here? 🤔

---

**skyrbunny** - 2023-08-02 09:42

i mean yeah that is the problem i'm trying to solve, but what i mean is my program was working (kinda) before, but then it broke and I can't for sure blame it on the terrain

---

**skyrbunny** - 2023-08-02 09:46

okay, yeah i got it to function again, I think I broke the resource I was using.

---

**skyrbunny** - 2023-08-02 09:46

My approach unfortunately is super inefficient, it basically just calls the built in bake function many, many times which I imagine has a setup and teardown cost

---

**skyrbunny** - 2023-08-02 09:48

and, yeah, attempting to bake with the terrain collider tuned on broke it. So yeah that's the fault I imagine

---

**skyrbunny** - 2023-08-02 10:08

Here's what I have *so* far. I literally wrote this today so if anything is unclear just ask me. https://github.com/SlashScreen/terrain3d_nav_bake

---

**skellysoft** - 2023-08-02 10:27

I mean, worst comes to worst, as long as you put up a "Baking..." loading bar or something to show users it hasnt frozen then I'm sure a lot of users will be fine with it tbh

---

**tokisangames** - 2023-08-02 10:28

I just started this page to help tool developers
https://github.com/outobugi/Terrain3D/wiki/Integrating-With-Terrain3D

---

**tokisangames** - 2023-08-02 10:39

I will check it out but in a few days. I have some higher priorities to address before navigation is on my radar. Maybe some other devs will take a look. I can answer questions though.

---

**stormeaglee** - 2023-08-02 15:48

probably a dumb question, but is there a way to change the filtering on the textures added in .dds format?

---

**tokisangames** - 2023-08-02 16:16

Enable the shader override and you can change filtering.

---

**tokisangames** - 2023-08-02 16:19

<@456226577798135808> exr and r16 are two different things. Please read the import page in the wiki. Most of your questions are answered. Your exr is likely normalized. Scale it up 300 or so.

---

**Deleted User** - 2023-08-02 16:56

thank you

---

**skyrbunny** - 2023-08-02 18:01

It closes as soon as I hit go

---

**skellysoft** - 2023-08-02 18:09

Huh, thats... weird. Can you enable error logging/the debug console to see what happens in the moments before it closes?

---

**skyrbunny** - 2023-08-02 20:42

hmm. ```ERROR: Can't get method on CallableCustom "<anonymous lambda>(lambda)".
   at: (core/variant/callable.cpp:386)```
Vague as always.  Is this something I did or something the terrain does?

---

**tokisangames** - 2023-08-02 22:10

We don't use anonymous lambdas. You have them all over your code. Vagueness is a side effect of anonymous lambdas. You have no separate function that can run validation checks or print messages.

---

**tokisangames** - 2023-08-02 23:32

However it's unlikely your gdscript is causing a crash. Most likely it is a bug in C++, which could be from us or in the nav baker. If you've already created the terrain and generated collision, we are done. The terrain is now sitting there within Godot. If it crashes during baking there's little we can do as we're already done. If the nav baker can't handle 1024^2 meshes then it has bugs that need to be reported and fixed. Perhaps we can work around it. But first what needs to happen is to isolate the exact circumstances that cause the crash and create a demonstrable minimal case.

---

**skyrbunny** - 2023-08-03 00:49

false alarm, i screwed up some signals in my haste to create this. However, unfortunately, I must confront the truth that this thing is slow as dirt

---

**skyrbunny** - 2023-08-03 00:51

The reason the godot navmesh can't handle it is that apart from just needing a lot of resources for the voxel thing, it quickly trips an assert in the code that limits the number of vertices that the navmesh can be

---

**skellysoft** - 2023-08-03 01:26

^^^^

---

**skyrbunny** - 2023-08-03 02:55

i've gotton it to bake but it's still a long and glitchy process

📎 Attachment: image.png

---

**tokisangames** - 2023-08-03 04:55

OK, good job. What is that maximum number? Are there any exclude shapes to ignore areas you don't want to bake? Do the docs say anything about handling very large areas?

---

**skyrbunny** - 2023-08-03 07:29

I've gotten the chunks to glue together, creating, in essence, one large navmesh.

📎 Attachment: image.png

---

**skyrbunny** - 2023-08-03 07:30

I'm going to stop doing this for today since it's taken up my entire day, but I've learned that I *may* be able to multithread this using a worker pool, which would obviously cut the time down significantly.

---

**skyrbunny** - 2023-08-03 07:31

Currently, it takes roughly 30 minutes for a single region, which is, needless to say, bad. With any luck I could utilize all the cores of the machine.

---

**skyrbunny** - 2023-08-03 07:40

- If memory serves, it trips this assert. This was done while baking the cell size to be 1m. The default crashes godot. https://github.com/godotengine/godot/blob/237bd0a615df8a0e57bc3d299894abece7b43a0c/modules/navigation/navigation_mesh_generator.cpp#L721
- There are navigation obstacles, which I believe accomplish the same thing. You could also have objects not beneath the navigation baker node.
- Not that I can see, but I am prone to missing bits of documentation. Just to be save, I gave it a once-over and found nothing. Don't do twitter, kids, it will ruin your attention span and reading comprehension.

---

**skyrbunny** - 2023-08-03 07:43

I may be able to bake using [this function](https://docs.godotengine.org/en/stable/classes/class_navigationmeshgenerator.html#class-navigationmeshgenerator-method-bake) so that the baker is not tied to any specific node, which means I could theoretically run in parallel (because the baking algorithm reads everything below a certain node, and nodes can only have 1 child.) Combine with the [Worker Group](https://docs.godotengine.org/en/stable/classes/class_workerthreadpool.html) System and I could pull it off.

---

**skyrbunny** - 2023-08-03 07:44

oh, cool, the markdown link thing works here.

---

**tokisangames** - 2023-08-03 08:29

If you really want to take this on and make it work, I would recommend reaching out to smix8. According to git, he's been working on the nav server for months. He might be in the godot discord chat, but surely he's in rocket chat. The question to ask him is how he envisions handling navigation on large terrains up to 16k and beyond. You could ask him to join us here and work on it with you. But before doing that I would read through all of the documentation again so you don't ask for trivial things that have already been answered.
Or you can keep exploring yourself or wait until Roope or I are ready to focus on it.
30 minutes to bake is unusable. You also need to look at memory consumption, and is that complex mesh usable in game? Currently collision uses too much memory and full baking isn't practical in game for anything larger than 2-4k. We need to chunk it and generate it on the fly. We might need to do the samething with the navigation mesh.
Any gdscript you create can be included with Terrain3D as an additional tool, or ported to C++ and compiled in.

---

**skyrbunny** - 2023-08-03 09:23

I'll reach out to them in rocket chat, thanks. I think large navmeshes are usable, but I have yet to test. I do agree, it's unusable. I'll have to look at memory. Again, this is a really hackneyed approach. 
The trouble is, I need a navmesh and I need it now, so until there's a better one, I'll go with this one I've duct taped together. 
Perhaps my fears are unfounded since I'm not super familiar with the internals of Terrain3D, but I'm a little worried about how you guys would bake after the collision chunk is created, while also taking into account other static meshes, like buildings that the user may place on the terrain.

---

**skyrbunny** - 2023-08-03 09:28

As for your collision woes: I'm sure you guys have a solution in mind, but in my head, I'm wondering how far out the collision *actually* needs to be. Does anyone actually care about a ball rolling 2 kilometers away? Most designers of large games disable physics at a certain distance anyway. Perhaps this can be a project setting.

---

**skyrbunny** - 2023-08-03 09:29

And I'm sure you can piggyback off of the clipmap generation, although, if the debug collision is anything to go by, you guys may already be doing that.

---

**tokisangames** - 2023-08-03 10:23

My unreleased gdscript terrain only calculates collision in a 32 unit radius around the camera. Enemies may need to track ground height, but we provide for that, and a nav mesh may as well.

---

**skyrbunny** - 2023-08-03 23:50

here's what smix8 has to say so far

📎 Attachment: image.png

---

**skyrbunny** - 2023-08-03 23:50

while the multithreaded algorithm isn't yet perfect, I've gotten it down to about 30 seconds to bake one region, hammering all cores.

---

**skyrbunny** - 2023-08-03 23:52

it looks like the *really* slow part from the old algorithm is that it was parsing the geometry every single chunk, which takes a long time. I have found a way to do the geometry parsing beforehand.

---

**skyrbunny** - 2023-08-04 00:49

okay, it now works fully. 30 seconds to a minute of 100% CPU usage.

📎 Attachment: image.png

---

**lw64** - 2023-08-06 16:10

hello, I have one question about terrain3d: behind the modeled tiles, some autogenerated hills appear, but can I control for example the height of these?

---

**zak133862** - 2023-08-06 16:25

hi, many thanks for the plugin! I have a newbie question about the textures since the phrasing is not very clear to me. Are we supposed to (i)  combine the albedo and height files to generate the albedo texture and then do the process again for normal and roughness, treating  the normal as the target for decomposing rgb channels and pasting the roughness, or (ii) decompose the albedo and copy normal and roughness in the channels instead of the height file?

---

**tokisangames** - 2023-08-06 16:48

The fake hills are called world noise. You can adjust the settings or disable in the storage settings

---

**lw64** - 2023-08-06 16:50

thanks, that did it

---

**lw64** - 2023-08-06 16:50

<@455610038350774273> works really great so far by the way 🙂

---

**tokisangames** - 2023-08-06 16:50

Albedo decomposed as RGB + height pasted in as alpha, recomposed into one RGBA file. Normal+rough in a separate file.

---

**zak133862** - 2023-08-06 16:54

Doing the same procedure, decomposing the normal as RGB, pasting the roughness, compose as RGBA?

---

**tokisangames** - 2023-08-06 16:55

Exact same process, unless your normal map is directx, or your roughness is really smoothness and they need adjustment

---

**lw64** - 2023-08-06 17:32

is with height a displaycement map meant?

---

**tokisangames** - 2023-08-06 17:35

Displacement and height textures are synonymous.

---

**lw64** - 2023-08-06 17:35

ok, thanks 🙂

---

**saul2025** - 2023-08-06 17:40

or depht map in godot 3

---

**lw64** - 2023-08-06 17:47

what is it used for actually?

---

**tokisangames** - 2023-08-06 17:51

The standard material has an option for depth parallax. It's not very good and only useful for very specific texture types like brick. In engines and renderers that support it, those maps are used for tessellation or displacement

---

**lw64** - 2023-08-06 17:57

I see

---

**.broccoli** - 2023-08-06 21:19

hello is it possible I could get a run down on how setting textures for terrain generated in GDScript works, can I set the surface texture of individual areas on terrain or can I only set the whole texture of one area with set_surface() ?

---

**tokisangames** - 2023-08-06 22:46

If you want to programmatically paint the terrain, you'll need to edit the control map images for each region and set pixels according to the format described in the wiki, Terrain3Dstorage. 
A surface is a material or a texture set. Set surface just defines one texture set that can be used to paint the terrain with.  Eg you paint the terrain with surface 0, set surface 0 defines the particular textures.
To successfully operate the system via gdscript, you're going to need to study the gdscript API (found in bind_method functions) and the C++ code to learn what the classes and functions do. Sorry that it's not all documented yet.

---

**tokisangames** - 2023-08-06 22:49

You might get a better answer by reframing your question or sharing what you hope to achieve. Most likely a custom shader is what you want.

---

**.broccoli** - 2023-08-06 22:51

That's ok I appreciate the response, I'm just toying around with procedural generation

---

**.broccoli** - 2023-08-06 22:51

I'm kind of hoping for some system where low height terain is grass and anything above a certain height is rocky and snowy

---

**tokisangames** - 2023-08-06 23:03

That's an easy enough shader which can be done with a custom shader. No need for editing the control map.

---

**.broccoli** - 2023-08-06 23:31

Could the same approach be used to add different biomes to terrain storage regions where a little patch of the terrain is a different surface material at the same height

---

**lw64** - 2023-08-06 23:44

I guess to do that you actually need different materials

---

**tokisangames** - 2023-08-07 04:09

Setup textures in the surfaces. Then enable the shader override. You'll have to change it from one that reads the painted control map to one that picks your specific indices for grass, snow, rock, dirt and your conditionals for applying them like pixel_pos.y > 250. It isn't a difficult shader. There are tutorials on autoshaders out there. If you don't know shaders, now is a good time to learn.

---

**.broccoli** - 2023-08-07 08:54

I don't know shaders but I'm sure I can fiddle around and learn, thanks for the help !

---

**lw64** - 2023-08-07 12:15

Is there somewhere documentation on how to use the shader override?

---

**lw64** - 2023-08-07 12:27

is it possible to use more textures than the ones given by default in the shader?

---

**lw64** - 2023-08-07 12:29

or do I need to add more terrain textures in the editor, I can then use?

---

**tokisangames** - 2023-08-07 12:41

What do you mean? Click the button and you get a modifiable shader. If you mean a shader tutorial, there are plenty of them out there as well as the Godot docs. We won't be providing shader tutorials, but maybe snippets only like in the tips page in the wiki

---

**tokisangames** - 2023-08-07 12:44

Do you genuinely need more than 32 textures? Or do you mean more PBR channels? It is possible in the future once <@107185333531090944>  finishes the custom uniforms PR he's working on. I have a lava texture that I will be using an emissive map with. I definitely don't want emissive maps for all of the other 22 textures we have.

---

**tokisangames** - 2023-08-07 12:46

I don't understand your questions. We give you 32 materials, with 4 pbr channels. Plus I'll be adding AO, so that's 5. What else do you need?

---

**lw64** - 2023-08-07 12:46

sorry, I dodnt got it working immediately, but now its good

---

**lw64** - 2023-08-07 12:47

ok, wasnt sure if there is maybe another method

---

**lw64** - 2023-08-07 12:47

I think custom uniforms is what I would want

---

**lw64** - 2023-08-07 12:49

maybe it would be more convenient if you don't need to always pack the channels into two textures. currently adjusting them is a little tedious

---

**tokisangames** - 2023-08-07 12:52

Every engine and big game uses channel packed textures. There is an issue for creating a channel packer that you can follow.

---

**lw64** - 2023-08-07 12:52

ah, ok, will subscribe to that then. thanks! 🙂

---

**saul2025** - 2023-08-07 16:22

true, and also when you get the trick it kind of easier, check the channel pack docs, though the easiest way is with gimp, as it is the most known.

---

**vonvivant2** - 2023-08-09 02:38

Hello

---

**vonvivant2** - 2023-08-09 02:48

im getting a lot of errors.

---

**vonvivant2** - 2023-08-09 02:48

*(no text content)*

📎 Attachment: image.png

---

**vonvivant2** - 2023-08-09 02:48

*(no text content)*

📎 Attachment: image.png

---

**vonvivant2** - 2023-08-09 02:49

*(no text content)*

📎 Attachment: image.png

---

**vonvivant2** - 2023-08-09 02:49

i cant active the plugin

---

**vonvivant2** - 2023-08-09 02:50

if i run the proyect, i cant see the map

---

**vonvivant2** - 2023-08-09 02:50

Not proyect, the demo

---

**vonvivant2** - 2023-08-09 02:50

*(no text content)*

📎 Attachment: image.png

---

**saul2025** - 2023-08-09 05:08

try reinstalling and try again make sure to only paste terrain 3d not the whole addons folder.

---

**tokisangames** - 2023-08-09 06:08

The error message says you need the msvc++ runtime library. Download the latest. For x64:
https://aka.ms/vs/17/release/vc_redist.x64.exe

---

**tokisangames** - 2023-08-09 06:42

I added a note in the Troubleshooting wiki page as a result of this

---

**vonvivant2** - 2023-08-09 14:00

we can add these requeriment in the installation guide?

---

**vonvivant2** - 2023-08-09 14:01

hello

---

**vonvivant2** - 2023-08-09 14:01

thanks. i will try in a few moment

---

**saul2025** - 2023-08-09 14:29

Hi

---

**vonvivant2** - 2023-08-09 21:51

works

---

**vonvivant2** - 2023-08-09 21:52

res://addons/terrain_3d/editor/editor.gd:224 - Invalid get index 'surfaces_changed' (on base: 'null instance')

---

**vonvivant2** - 2023-08-09 21:55

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2023-08-10 02:40

Go back to the setup instructions. Make a Terrain3DStorage resource.

---

**vonvivant2** - 2023-08-10 21:57

done

---

**vonvivant2** - 2023-08-10 21:57

*(no text content)*

📎 Attachment: image.png

---

**vonvivant2** - 2023-08-10 21:57

*(no text content)*

📎 Attachment: image.png

---

**vonvivant2** - 2023-08-11 03:29

i cant fix

---

**tokisangames** - 2023-08-11 04:02

We can't help you without information about what you did or have tried. Does the demo work? It looks like you download the demo, then changed it (broke it). 
Remove these files, and download it again so you can open up the original files that work fine for everyone else.

---

**skellysoft** - 2023-08-11 15:06

Hmmm. Ive been trying to get Scatter to work, but it just makes Godot hang 😦 The demo scene works fine, but when making a new 3D scene with a box mesh in to act as ground, then adding a base ScatterNode, it just hangs indefinitely...

---

**saul2025** - 2023-08-11 16:17

what the error message in the console saying, and is it related to terrain 3d?

---

**tokisangames** - 2023-08-11 16:53

A new scene with a box mesh and no terrain 3d, scatter doesn't work? You've got to get support from hungry proton. You can see in my latest video I had it working fine on the terrain. But he's on beta or alpha so is changing it all the time. Perhaps the commit you're on is broken.

---

**skellysoft** - 2023-08-11 17:04

Cool, am talking to him now in the Godot Discord. 👍

---

**skellysoft** - 2023-08-11 17:49

Okay, I spoke to HungryProton and apparently the latest commit is broken - if anyone else asks, apparently the one before the latest commit works. Will try it out myself after dinner 🙂

---

**skellysoft** - 2023-08-11 19:13

Okay - I've tried it again with the previous version and it does work without crashing now - but, will not detect the Terrain3D collisionmesh in the editor.

Since you're using Scatter yourself for OOTA - how are you guys handling this? Surely there must be some sort of snap to terrain ability?

---

**skellysoft** - 2023-08-11 19:18

Just checked and the default Scatter *does* snap to regular StaticBodys (like the orange sphere that has a staticbody with collisionshape)

📎 Attachment: rn_image_picker_lib_temp_992fcd16-bf1d-40cb-9eae-dab36ff43dea.jpg

---

**saul2025** - 2023-08-11 19:21

enable the debug collisions if not already, that may be the issue, amd also you have to move the script that says about scatter from terrain 3d to the proton scatter modifer thing or somewhere else i don’t remember the name

---

**saul2025** - 2023-08-11 19:22

here a clearer explanation from cory

📎 Attachment: 84CAEDA0-6637-4A55-B3C0-FA0BD7A906E5.png

---

**skellysoft** - 2023-08-11 19:24

Okay cool, will give it a try. Thanks for the help!

---

**tokisangames** - 2023-08-11 20:04

Debug collision is unnecessary for scatter. Did you setup the scatter modifier included with Terrain3D in extras, and mentioned in the wiki?

---

**skellysoft** - 2023-08-11 21:27

My apologies, I didnt see it! No extra help needed, it works like a charm. 🙂

---

**vonvivant2** - 2023-08-12 00:15

the demo works

---

**vonvivant2** - 2023-08-12 00:15

Thx

---

**tokisangames** - 2023-08-12 17:44

<@732302536018624522> this is the appropriate channel for help

---

**tokisangames** - 2023-08-12 17:44

Please read through the wiki. Collision is not generated in the editor by default, but you can enable it on the debug options.

---

**tokisangames** - 2023-08-12 17:46

Regarding the brush, that white circle in your picture is the brush. Also your computer has tools built in for taking screenshots.

---

**ademdj12** - 2023-08-12 17:47

lol sorry am a bit dump, i was freaking out

---

**ademdj12** - 2023-08-12 17:52

the collision is working properly, but there is no circle

---

**ademdj12** - 2023-08-12 17:55

*(no text content)*

📎 Attachment: Screenshot_70.png

---

**tokisangames** - 2023-08-12 17:57

Does it work in the demo?

---

**tokisangames** - 2023-08-12 17:59

Why aren't you using Godot 4.1.1? Are you using the binary release or did you build it from source? If so, use the latest version.

---

**tokisangames** - 2023-08-12 18:07

Did you try restarting Godot?

---

**skyrbunny** - 2023-08-13 10:15

anyoone else having an issue with the new update where all textures beyond index 0 are just a flat color, as if the UVs were screwed up?

---

**tokisangames** - 2023-08-13 11:33

I haven't seen that, but you can change your surface UV scale. Which new update? From a few minutes ago? Is the demo messed up? What happens if you move your surfaces to different IDs?

---

**skyrbunny** - 2023-08-13 11:38

The one from earlier this week. I’ll have to check the other things in the morning

---

**tokisangames** - 2023-08-13 14:24

There was a breaking change listed in the release notes that uv scaling changed from a vec3 to a float.

---

**saul2025** - 2023-08-14 03:26

ye that change made texture flat, scale the texture uv scale  and it will work.

---

**skyrbunny** - 2023-08-14 04:01

changing the UV scale on indexes 2 and 3 has no effect. Changing scale on index 1 changes the scale on index 0, but has no effect on index 1. what

---

**skyrbunny** - 2023-08-14 04:02

Wait. That's right, I'm using a "custom shader" for my terrain

---

**skyrbunny** - 2023-08-14 04:02

hang on

---

**skyrbunny** - 2023-08-14 04:03

ok yeah that fixed it

---

**skyrbunny** - 2023-08-14 04:04

Sorry about that. I completely forgot I was using a shader override

---

**tokisangames** - 2023-08-14 15:24

<@136967405766180864> Please use this channel for help. What does your console say when you enable debug mode? What are the exact dimensions of the images? Which texture is causing the problem? Import them one at a time for testing.
The image the errors are likely complaining about is the region map, which is 16x16. One of your images might be something like 8193 tall.

---

**miro_horvath** - 2023-08-14 15:32

Will have a look thanks

---

**miro_horvath** - 2023-08-15 09:40

Hi <@455610038350774273> , so here are my findings. It's heightmap causing it, resolution is 8192x8192, in debug mode there was nothing else than the same error I posted in <#1065519581013229578>

---

**miro_horvath** - 2023-08-15 09:41

I tried playing with Import position, with (0,0,0) (-1024,0,-1024) I got errors, with (-8192,0,-8192) no errors

---

**miro_horvath** - 2023-08-15 09:46

I also came to a state when I can't remove a region, any hint how to get rid of it?

📎 Attachment: image.png

---

**miro_horvath** - 2023-08-15 10:02

Weirdly enough I never imported data to that region

---

**tokisangames** - 2023-08-15 10:02

Is that region there if you save the storage and scene, close it and reopen it?
What does your console say with debug level set to debug? There are most definitely logs printed to your console when trying to remove a region, or add regions or import. Which versions are you on? Is this the same heightmap file you sent me before or a different one?

---

**miro_horvath** - 2023-08-15 10:06

Saving and reopening don't help still there

📎 Attachment: image.png

---

**miro_horvath** - 2023-08-15 10:13

I'm going to try with the latest... the heightmap is the same I shared with you at Gdrive

---

**tokisangames** - 2023-08-15 10:15

I was able to import terrain_8k.exr at 0,0 just fine without any extra regions or errors

---

**tokisangames** - 2023-08-15 10:16

oh, until I moved the camera.....

---

**tokisangames** - 2023-08-15 10:16

If the camera was centered there was no issue

---

**tokisangames** - 2023-08-15 10:17

I can move it a few thousand units but when it gets close to the edge it produces those errors

---

**miro_horvath** - 2023-08-15 10:18

yup exactly, I have the same scenario

---

**tokisangames** - 2023-08-15 10:18

Once the camera Z crosses ~6500 it has a problem

---

**tokisangames** - 2023-08-15 10:24

Has nothing to do with the imported data. It breaks on a blank terrain.

---

**tokisangames** - 2023-08-15 10:28

https://github.com/outobugi/Terrain3D/issues/183

---

**emanuelyay** - 2023-08-15 13:02

Hey guys,
Im sure its my stupid mistake...

I cannot enable the plugin since it says: 

"Unable to load addon script from path: 'res://addons/terrain_3d/editor/editor.gd'. This might be due to a code error in that script.
Disabling the addon at 'res://addons/terrain_3d/plugin.cfg' to prevent further errors."

When I open then editor.gd it says it does know Terrain3D (i guess since its not activated?!)

📎 Attachment: Screenshot_2023-08-15_at_15.01.57.png

---

**emanuelyay** - 2023-08-15 13:06

So i guess it cannot find the Terrain3D because its not enabled, and I cannot enable it, since it cannot find the Terrain3D?

---

**emanuelyay** - 2023-08-15 13:06

(I am new to godot)

---

**emanuelyay** - 2023-08-15 13:07

*(no text content)*

📎 Attachment: Screenshot_2023-08-15_at_15.07.55.png

---

**tokisangames** - 2023-08-15 13:29

<@380267908577624064> These messages mean you didn't install the plugin properly or you installed binary files for the wrong system or version

---

**tokisangames** - 2023-08-15 13:30

What OS, what versions are you using?

---

**emanuelyay** - 2023-08-15 14:28

Hm does not sound to bad^^

---

**emanuelyay** - 2023-08-15 14:28

Im using OSX ( sorry for not mention)

---

**emanuelyay** - 2023-08-15 14:29

To run the demo:

=> Download, unzip, open => try to activate plugin ?!

---

**emanuelyay** - 2023-08-15 14:36

*(no text content)*

📎 Attachment: Screenshot_2023-08-15_at_16.36.36.png

---

**tokisangames** - 2023-08-15 14:45

Which processor? I don't build for OSX, so you either have to build it yourself or get community builds. The only one up there now is for Intel x64. You probably have an ARM processor. That won't work.

---

**emanuelyay** - 2023-08-15 14:45

that makes so much sense !! 🙂

---

**emanuelyay** - 2023-08-15 14:46

Yep! thank you Cory!!!

---

**emanuelyay** - 2023-08-15 15:18

ld: warning: -undefined dynamic_lookup may not work with chained fixups
scons: done building targets.

---

**emanuelyay** - 2023-08-15 15:19

/libterrain.macos.debug.framework/libterrain.macos.debug, 0x0002): symbol not found in flat namespace '__ZN16Terrain3DStorage16SURFACE_MAX_SIZEE'.

---

**emanuelyay** - 2023-08-15 15:23

if tried the 4.1.1 stable and the current@master (same result)

---

**tokisangames** - 2023-08-15 15:36

Hmm, Surface_max_size and region_map_size are the identical type but it only complains about one. Which compiler are you using?

---

**tokisangames** - 2023-08-15 15:42

Try adding `-Wl,-no_fixup_chains` to your linker flags
https://gitlab.haskell.org/ghc/ghc/-/issues/22429

---

**emanuelyay** - 2023-08-15 15:43

SCons: v4.4.0.fc8d0ec215ee6cba8bc158ad40c099be0b598297, Sat, 30 Jul 2022 14:11:34 -0700, by bdba

---

**tokisangames** - 2023-08-15 15:43

That is your build system. Scons uses a compiler like clang/llvm/gcc

---

**emanuelyay** - 2023-08-15 15:44

this is far away from my knowledge sorry ^^

---

**tokisangames** - 2023-08-15 15:44

No time to learn like the present when there is a need

---

**emanuelyay** - 2023-08-15 15:45

Apple clang version 14.0.0

---

**tokisangames** - 2023-08-15 15:46

When you run scons, what are the compiler and linker commands it prints to your console?
```
scons: done reading SConscript files.
scons: Building targets ...
scons: `godot-cpp\bin\libgodot-cpp.windows.template_debug.x86_64.lib' is up to date.
cl /Fosrc\terrain_3d.windows.template_debug.x86_64.obj /c src\terrain_3d.cpp /TP /std:c++17 /nologo /EHsc /utf-8 /O2 /MD /DTYPED_METHOD_BIND /DNOMINMAX /DDEBUG_ENABLED /DDEBUG_METHODS_ENABLED /Igodot-cpp\gdextension /Igodot-cpp\include /Igodot-cpp\gen\include /Isrc
terrain_3d.cpp
link /nologo /WX /OPT:REF /dll /out:project\addons\terrain_3d\bin\libterrain.windows.debug.x86_64.dll /implib:project\addons\terrain_3d\bin\libterrain.windows.debug.x86_64.lib /LIBPATH:godot-cpp\bin libgodot-cpp.windows.template_debug.x86_64.lib src\geoclipmap.windows.template_debug.x86_64.obj src\register_types.windows.template_debug.x86_64.obj src\terrain_3d.windows.template_debug.x86_64.obj src\terrain_3d_editor.windows.template_debug.x86_64.obj src\terrain_3d_storage.windows.template_debug.x86_64.obj src\terrain_3d_surface.windows.template_debug.x86_64.obj
   Creating library project\addons\terrain_3d\bin\libterrain.windows.debug.x86_64.lib and object project\addons\terrain_3d\bin\libterrain.windows.debug.x86_64.exp
scons: done building targets.
```

---

**tokisangames** - 2023-08-15 15:46

cl is the msvc compiler

---

**emanuelyay** - 2023-08-15 15:49

it spamms about 100000 pages, i dont have a chace to get the start

---

**tokisangames** - 2023-08-15 15:50

Then the error message you posted may not be the real problem. Generally the first error message is the problem. My scons output prints only the above.

---

**emanuelyay** - 2023-08-15 15:50

clang++ -o project/addons/terrain_3d/bin/libterrain.macos.debug.framework/libterrain.macos.debug -arch arm64 -framework Cocoa -Wl,-undefined,dynamic_lookup -shared src/geoclipmap.os src/register_types.os src/terrain_3d.os src/terrain_3d_editor.os src/terrain_3d_storage.os src/terrain_3d_surface.os -Lgodot-cpp/bin -lgodot-cpp.macos.template_debug.arm64
ld: warning: -undefined dynamic_lookup may not work with chained fixups
scons: done building targets.

---

**tokisangames** - 2023-08-15 15:50

Can you build the godot-cpp example project?

---

**tokisangames** - 2023-08-15 15:50

As described in the build from source wiki page?

---

**emanuelyay** - 2023-08-15 15:51

the one in the test folder?

---

**tokisangames** - 2023-08-15 15:51

Yes

---

**emanuelyay** - 2023-08-15 15:53

and with build you dont mean open i guess? ^^

---

**emanuelyay** - 2023-08-15 15:53

Javascirpt is a little bit far away from c++ ^^

---

**emanuelyay** - 2023-08-15 15:54

seoncd thats descirpted in the github

---

**tokisangames** - 2023-08-15 15:54

https://github.com/outobugi/Terrain3D/wiki/Building-From-Source#how-can-i-make-sure-godot-cpp-is-the-right-version-and-working

---

**emanuelyay** - 2023-08-15 15:57

Attempt to get non-existent interface function: string_resize
  Unable to load GDExtension interface function string_resize()
  core/extension/gdextension.cpp:476 - GDExtension initialization function 'example_library_init' returned an error.
  Failed loading resource: res://example.gdextension. Make sure resources have been imported by opening the project in the editor at least once.
  Cannot navigate to 'res://addons/terrain_3d/bin/libterrain.macos.debug.framework/' as it has not been found in the file system!

---

**tokisangames** - 2023-08-15 16:04

The last message is due to terrain3d. The first though says the example library is not working. That has to do with godot-cpp and godot, which has nothing to do with us. If that isn't working for you then terrain3d won't work.

---

**emanuelyay** - 2023-08-15 16:09

I totally get that!

---

**tokisangames** - 2023-08-15 16:09

I don't think your build chain is setup properly. I think your options are 1) read the documentation again and set up your system and build tools for building godot-cpp properly. Then try terrain3d again. Or 2) beg another arm mac user to build arm binaries. Perhaps <@113223592988217344> can help as the only arm user I know.

---

**emanuelyay** - 2023-08-15 16:11

Thank you Cory! 
I'll make a deeper dive into this and try to get your test build done!

---

**emanuelyay** - 2023-08-15 16:11

Amazing editor what I saw from youtube videos!!

---

**tokisangames** - 2023-08-15 16:15

Thanks. BTW, godot-cpp is not my test or my project. It is part of Godot.
https://github.com/godotengine/godot-cpp

---

**tokisangames** - 2023-08-15 16:21

Also as I mentioned, you can try adding `env.Append(LINKFLAGS='-Wl,-no_fixup_chains')` to SConstruct, after `env = SConscript`

---

**tokisangames** - 2023-08-15 16:24

https://github.com/Perl/perl5/issues/20381

---

**emanuelyay** - 2023-08-15 16:59

thank you! That fixed the warning!

---

**emanuelyay** - 2023-08-15 17:00

but problems still the same

---

**ee0pdt** - 2023-08-15 17:46

Hey Emanuel. I had to make two source code changes to get Mac version working I believe. I have not tried to build since then as I’m busy with other games jam stuff

---

**s.p.n** - 2023-08-18 03:09

So, what's the deal with HTerrain and Terrain3D. I was reading that it's possible to generate terrain in HTerrain- well, I mean I did some of that

---

**s.p.n** - 2023-08-18 03:09

*(no text content)*

📎 Attachment: image.png

---

**s.p.n** - 2023-08-18 03:12

But I noticed they have some of the same features in HTerrain as there are in Terrain3D. Is Terrain3D a whole lot faster or something?

---

**tokisangames** - 2023-08-18 06:21

HTerrain is a completely different project made by a different person, Zylann, who is in this server. They have similar features as all terrain systems do. HTerrain is written in gdscript, is more mature and feature complete, Terrain3D is written in C++ and still in alpha.

---

**tokisangames** - 2023-08-18 06:36

We can import height and color maps directly from hterrain without any conversion. Texturing will need to be redone.

---

**miro_horvath** - 2023-08-18 07:56

<@455610038350774273> "Texturing will need to be redone" - what do you mean exactly?

---

**tokisangames** - 2023-08-18 08:01

The hterrain texture control maps are a different format from ours. Every system is proprietary.

---

**miro_horvath** - 2023-08-18 08:09

oh so this is only about hterrain control maps conversion, nothing will be change regarding how current control maps are done in Terrain3D, right?

---

**miro_horvath** - 2023-08-18 08:10

I'm asking because I'd like to start preparing control map for 8k terrain(outside of Godot) and it'll be hell of a work

---

**tokisangames** - 2023-08-18 08:13

The colormap and heightmap formats will stay the same. The texture control map most definitely will be changed. Though we will have an automatic conversion from our current format.
https://github.com/outobugi/Terrain3D/wiki/Terrain3DStorage#control-maps

---

**skellysoft** - 2023-08-18 10:42

Having used both *extensively*, I'd say that Terrain3D is the far superior option in terms of speed -  I can get a further draw distance on the same machine at a much much higher FPS, I'm gonna guess because of the fact its written in C++

---

**skellysoft** - 2023-08-18 10:43

And perhaps the clipmap technique vs the chunk loading style (although I'm not too sure about that part)

---

**saul2025** - 2023-08-18 10:46

prob that,  though when adding texture performance goes decreases more with terrain 3d that hterrain , as far i remembered.

---

**tokisangames** - 2023-08-18 10:51

During game time, the GPU does most of the work to update the terrain, so that is the primary performance gain. HTerrain regenerates chunks of terrain mesh as you move around. We don't do that  even in C++.

---

**tokisangames** - 2023-08-18 10:54

Ours is a complex 32-texture shader made for high end machines. However you don't need the fancy shader. You can write your own that is much simpler, even base it off of one of Zylann's 16x or 4x shaders. Turn on one of the shader debug views, make a custom shader, and strip out everything except the simple debug GLSL, then look at your performance. That is the upper bound for your machine and will probably be 25-40% higher. You can also experiment with a smaller or larger mesh.

---

**s.p.n** - 2023-08-18 14:24

do you just put the whole map in memory when the game starts and leave it there then? I like that approach because I only want to make small games, and maybe it can be scaled by using multiple scenes (would *not loading a scene* stop Terrain3D from loading it to memory?). Or maybe I got the wrong idea of how it works.

---

**tokisangames** - 2023-08-18 14:43

Godot has no streaming capability and we haven't added it. The maps are both in memory and vram. In Out of the Ashes we have multiple levels with loading screens, each will have their own separate Terrain3D instances. Though our main outdoor level will be a larger level. Closed scenes are not loaded in memory.

---

**s.p.n** - 2023-08-18 15:22

Okay nice stuff. So I was wondering about the workflow. I'm going to have to generate a base terrain to start with before using brushes on it. Once I make an HTerrain node, how exactly should I go about generating, exporting and then importing into Terrain3D? I have found and played with the Terrain->Generate tool in HTerrain, but I suppose I need to change some size settings, and I don't know how to export.

---

**s.p.n** - 2023-08-18 15:25

And then after all that I'll need to figure out how to turn my PNG image textures into .dds, but I'm gonna goolge that actually

---

**tokisangames** - 2023-08-18 16:05

Just read our documentation. It says exactly how to setup textures as DDS. We have sculpting tools, so you don't need to generate in other tools. As for exporting and generating with HTerrain, read Zylann's documentation. TLDR: RTFM

---

**tokisangames** - 2023-08-18 16:07

PNG is NOT recommended as an export format. Godot cannot write 16-bit pngs. Our documentation recommends formats to use including discussing interoperating w/ HTerrain. Exporting isn't even necessary.

---

**s.p.n** - 2023-08-18 19:02

thanks that helped

---

**miro_horvath** - 2023-08-19 08:27

Hi guys, I tried running my terrain project on more powerful PC(with 4070Ti) and for some reason I'm getting only 30FPS compared to 60 FPS on "worse" PC(3070Ti). I searched for FPS limiter setting in Godot, but no luck... any idea?

---

**tokisangames** - 2023-08-19 10:04

How does the demo run on both, same resolution, with vsync off? I get 400-500 fps on a laptop 3070.
For your project, how many regions does it have?
How much vram is used vs available?
How much ram is used vs available?

---

**tokisangames** - 2023-08-19 12:02

https://github.com/outobugi/Terrain3D/issues/187

---

**s.p.n** - 2023-08-19 14:12

Just a shot in the dark here, but can you confirm the graphics card is actually being used and that it's up to date?

📎 Attachment: image.png

---

**karltoon** - 2023-08-19 18:00

Hey guys trying to get this terrain stuff sorted

---

**karltoon** - 2023-08-19 18:00

What does mean place the voxel tools unto the godot source tree?

---

**karltoon** - 2023-08-19 18:00

I feel like im being dumb

---

**tokisangames** - 2023-08-19 18:07

Terrain3D is not a voxel system. You must be confusing Zylann's plugin with ours.

---

**karltoon** - 2023-08-19 18:17

Oops

---

**karltoon** - 2023-08-19 18:18

So sorry

---

**woyosensei** - 2023-08-20 10:37

Hello guys, hope you all well!
I just want to say that I just found out about this add-on today and I love it so far. I mean, damn, the possibilities I have now 🙂 Connecting together my gridmap system for buildings with this terrain? It's huge. I have a one question, tho. So far I've been using gridmap for terrain as well so I could use another add-on called `simple grass`. It's a wonderful add-on for adding an animated grass, similar to `Terrain3D` (you draw/paint grass on the surface) but one of it's downsides is that the surface has to be staticbody or gridmap with staticbody in it. If you've heard about this add-on (`simple grass` I mean) do you know any way to use it with `Terrain3D`? Or do you know any other add-on for procedural kind-of-painted foliage working with `Terrain3D`?

---

**tokisangames** - 2023-08-20 10:59

Enable debug collision. Paintable foliage will be added later
https://github.com/outobugi/Terrain3D/wiki/Integrating-With-Terrain3D

---

**woyosensei** - 2023-08-20 11:04

It works! Thank you very much!

---

