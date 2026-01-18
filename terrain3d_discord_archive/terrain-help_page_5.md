# terrain-help page 5

*Terrain3D Discord Archive - 1000 messages*

---

**tokisangames** - 2025-05-30 23:10

The fix was put in. I'm only aware of it occurring if the mesh is a quad. There's an issue to fix that specifically.

---

**vhsotter** - 2025-05-30 23:22

Alright. The impostor trees I have aren't the built-in quads, but are two flat planes I created that are joined together in Blender. Oddly the issue does not appear to occur while running the actual game, only in the editor, but that could be because my character controller is moving too quickly and is unlikely to stop inside the boundary. I'd have to do more testing to be sure.

---

**vhsotter** - 2025-05-30 23:47

Ah, there we go, just happened to run into a case of it happening in-game.

📎 Attachment: image.png

---

**vhsotter** - 2025-05-30 23:56

Hmm. I can't get it to occur consistently though. There's only a few cells that do it. Really weird.

---

**tokisangames** - 2025-05-31 03:22

Flat planes are the range thing, it doesn't properly calculate AABB. Unless the planes are joined in a cross so the object has depth?
Do you see the gap on lods between other lods, before the planes?

---

**aowood** - 2025-05-31 05:00

Is there a map image i can use that can auto place the texture i have in the terrain editor? I know there's a colour map i can use to set colours. So something like that but for the textures?

---

**tokisangames** - 2025-05-31 06:47

I don't quite understand your question. You're using a 3rd party terrain tool? You cannot import a texture layout (eg a splat map) from a 3rd party tool with our current importer, but you could easily script one using our API as long as you have the documentation from your tool describing the output format.

---

**aowood** - 2025-05-31 07:07

Oh, sorry. So im just using built in features of your Terrain3D. In the importer you can import a coloured image that will add those colours to the terrain. I was just wondering if there was a similar method that could be used to add textures to the terrain instead of just colours.

---

**tokisangames** - 2025-05-31 08:03

Where will you get this texture map to import? Probably from a 3rd party terrain tool as I described.

---

**tokisangames** - 2025-05-31 08:04

There are lots of ways to get textures on the terrain. Import, code, hand painting, and more.

---

**aowood** - 2025-05-31 08:04

Okay, Ill look around at different methods for adding textures.

---

**wowtrafalgar** - 2025-05-31 14:39

would there be a good way to generate collision around multiple nodes instead of just the camera, or would that negate the performance gains of the dynamic collision?

My use case is I have racers but as soon as they get far away enough from the player they fall through the terrain with dynamic on

---

**xtarsia** - 2025-05-31 15:04

can fall back to a terrain.get_height() check, as suggested in the collision docs.

---

**wowtrafalgar** - 2025-05-31 15:06

thats what I was thinking, but ill need collision for them to ragdoll and everything, it seems like full collision isnt that big of a performance hit so ill probably just take the path of least resistance

---

**tokisangames** - 2025-05-31 19:47

It's a memory hit, depending on size of terrain.

---

**amethyst_cutie** - 2025-05-31 21:44

aaaaa

---

**amethyst_cutie** - 2025-05-31 21:46

i crashy when i sculpt the terrain

---

**amethyst_cutie** - 2025-05-31 21:56

```
Terrain3DMaterial#7371:_update_maps: Region_locations size: 64 [(-1, -1), (-1, -2), (-1, -3), (-1, -4), (-1, 0), (-1, 1), (-1, 2), (-1, 3), (-2, -1), (-2, -2), (-2, -3), (-2, -4), (-2, 0), (-2, 1), (-2, 2), (-2, 3), (-3, -1), (-3, -2), (-3, -3), (-3, -4), (-3, 0), (-3, 1), (-3, 2), (-3, 3), (-4, -1), (-4, -2), (-4, -3), (-4, -4), (-4, 0), (-4, 1), (-4, 2), (-4, 3), (0, -1), (0, -2), (0, -3), (0, -4), (0, 0), (0, 1), (0, 2), (0, 3), (1, -1), (1, -2), (1, -3), (1, -4), (1, 0), (1, 1), (1, 2), (1, 3), (2, -1), (2, -2), (2, -3), (2, -4), (2, 0), (2, 1), (2, 2), (2, 3), (3, -1), (3, -2), (3, -3), (3, -4), (3, 0), (3, 1), (3, 2), (3, 3)]
Terrain3DMaterial#7371:_update_maps: Setting region size in material: 64.0
Terrain3DMaterial#7371:_update_maps: Height map RID: RID(857984141890285)
Terrain3DMaterial#7371:_update_maps: Control map RID: RID(857992731824878)
Terrain3DMaterial#7371:_update_maps: Color map RID: RID(858001321759471)
Terrain3DMaterial#7371:_update_maps: Setting vertex spacing in material: 1.0
Terrain3DInstancer#0355:update_transforms: Updating transforms within [P: (8.09518, -70.7768), S: (14.5, 14.5)]
WARNING: Terrain3D#2620:_notification: NOTIFICATION_CRASH
     at: push_warning (core/variant/variant_utility.cpp:1118)

================================================================
handle_crash: Program crashed with signal 11
Engine version: Godot Engine v4.4.1.stable.mono.official (49a5bc7b616bd04689a2c89e89bda41f50241464)
Dumping the backtrace. Please include this when reporting the bug to the project developer.
```

---

**amethyst_cutie** - 2025-05-31 22:09

aahh i just to make al the terrain again

---

**totsamui.** - 2025-06-01 00:23

why if i change terrain and after just change scene and back , all my change lose? yas i'm don't save scene when change it but it's some confuse.
all this in redactor . i don't close it and something else.
it's not a catastrofic but it's a litl don uncomfortobl
addon don't save change from cash to data if i dont press save ?

---

**wowtrafalgar** - 2025-06-01 01:01

you probably need to set the directory

---

**tokisangames** - 2025-06-01 04:08

You crashed updating the instance locations. There is some bug in here, but not sure what and can't tell from this info. You might have gotten your instancer data out of sync with your meshes.

---

**tokisangames** - 2025-06-01 09:31

The PR with blending improvements has been merged. You can use a nightly build.
<@782919638291447819> <@1356492888602841138> <@490257000677244945> <@239451776896598016> <@160033458603687936>

---

**kesocos** - 2025-06-01 18:02

Is there a way retrieve the texture from the terrain with a raycast? I'm trying to implement a footstep system

---

**vhsotter** - 2025-06-01 18:04

https://terrain3d.readthedocs.io/en/latest/api/class_terrain3ddata.html#class-terrain3ddata-method-get-texture-id

---

**kesocos** - 2025-06-01 18:06

Thanks!

---

**sheepsheepx2** - 2025-06-01 18:58

can someone please attach a heightmap that works with terrain3D vanilla settings? Trying to see if my heightmap is the problem.

---

**tokisangames** - 2025-06-01 18:59

Export the demo heightmap, or sculpt your own.

---

**tokisangames** - 2025-06-01 19:00

You can reimport that one in a new scene.

---

**sheepsheepx2** - 2025-06-01 19:50

it worked. first tried exporting your demo. then try to re-import. that worked, then tried  mine. and now I know why. Had to change settings in World machine export file format to openEXR. in combination with the color png, it is also colored now.

---

**wowtrafalgar** - 2025-06-01 20:47

how do we change the camera that terrain3d uses for its lods? I am changing the camera for debugging and its still tying the location to the player

---

**xtarsia** - 2025-06-01 20:48

Terrain3D.set_camera()

---

**hutman** - 2025-06-02 00:51

Following tutorial one and I cant find where the add texture button is like for them in the video (photo of my world atm)

📎 Attachment: image.png

---

**vhsotter** - 2025-06-02 00:53

Do you not have the Terrain3D tab at the bottom selected and the tray open? If you have the Terrain3D node selected there should be a panel at the bottom showing the texture buttons. Also when posting screenshots you should also include a shot of your entire interface as the screenshot you provided doesn't give enough information to help discern what might be wrong.

---

**hutman** - 2025-06-02 00:54

*(no text content)*

📎 Attachment: image.png

---

**vhsotter** - 2025-06-02 00:55

Something's not right. Looks like the addon didn't load correctly. Try reloading your entire project.

---

**vhsotter** - 2025-06-02 00:55

(Also make sure Terrain3D is enabled in your project settings.)

---

**hutman** - 2025-06-02 00:56

where can I check it in the settings?

---

**vhsotter** - 2025-06-02 00:56

Project settings > Addons.

---

**hutman** - 2025-06-02 00:58

*(no text content)*

📎 Attachment: image.png

---

**hutman** - 2025-06-02 00:58

Thought it came enabled, oops

---

**hutman** - 2025-06-02 00:58

first addon ive used

---

**vhsotter** - 2025-06-02 00:59

No worries. You generally always have to explicitly enable an addon after installing it.

---

**hutman** - 2025-06-02 00:59

Good to know moving forward, thanks for the assistance!

---

**sheepsheepx2** - 2025-06-02 15:21

manual says "Godot only supports 8-bit PNGs. This works fine for the colormap, but not for heightmaps."

---

**sheepsheepx2** - 2025-06-02 15:22

but I used PNG 16 bit greyscale without problems. it does support it. World machine exports it by default as PNG,

---

**sheepsheepx2** - 2025-06-02 15:23

sRGB. any reason I must convert to EXR?

---

**sheepsheepx2** - 2025-06-02 15:24

post of pictures that it works: https://forum.world-machine.com/t/godot-and-wm-game-development-log-maintained-till-done/8095/5

---

**tokisangames** - 2025-06-02 15:27

8-bit height data creates terracing.
https://discord.com/channels/691957978680786944/1130291534802202735/1356540483714945166

---

**sheepsheepx2** - 2025-06-02 15:34

I do not completely compute. manual says it only support 8 bit PNG, you mention 8 bit create terracing. I am clearly missing the mark. If there is terracing it is a feature , a plus point for terrain3D I think.

---

**sheepsheepx2** - 2025-06-02 15:34

but 16 bit work.

---

**sheepsheepx2** - 2025-06-02 15:35

but it is not written in the manual. that is actually what I like to know. so 16 , is supported un-officially?

---

**sheepsheepx2** - 2025-06-02 15:36

so will the manual be changed or am I an hertic? ^^

---

**sheepsheepx2** - 2025-06-02 15:36

heretic *

---

**tokisangames** - 2025-06-02 15:51

A terraced terrain means data loss and is not desirable by most. Most want the full resolution of their heights on their imported data, with smooth and accurate curves. https://discord.com/channels/691957978680786944/1065519581013229578/1365342668632100897
The rare person who wants an 8-bit terraced terrain can already do that.
Just because Godot can read 8 of 16-bits from your PNG doesn't mean it's supported; it means 16-bit is not supported.
If you can demonstrate importing a 16-bit PNG and getting a smooth terrain height data, I will update the documentation.

---

**sheepsheepx2** - 2025-06-02 16:39

Hello Cory, please have a try with this file. I also made a screen shot

---

**sheepsheepx2** - 2025-06-02 16:40

please scale by factor -1000 it is a small picture.

📎 Attachment: image.png

---

**sheepsheepx2** - 2025-06-02 16:40

png created with gimp, radial and followign settings:

---

**sheepsheepx2** - 2025-06-02 16:41

so, please check if this verifies if png 16 bit is useful for height map or not.

📎 Attachment: image.png

---

**sheepsheepx2** - 2025-06-02 17:38

My World machine project export is at this moment only 1025 by 1025 pixel, only large enough for a 10 meter by 10 meter 3D terrain, so that looks terraced. Will try to get a World Machine export of higher resolution. I guess the resolution is the problem. Not entirely sure yet.

---

**tokisangames** - 2025-06-02 17:40

Was your image in 16-bit float mode? You cut out that information from your screenshot.

---

**tokisangames** - 2025-06-02 17:41

Your imported image does not look smooth.

---

**sheepsheepx2** - 2025-06-02 17:43

the imported file into terrain3D is not smooth enough?

---

**sheepsheepx2** - 2025-06-02 17:46

the outside comes together into a sharp point, there is no visible staircase effect.

---

**tokisangames** - 2025-06-02 17:50

That curve in that image looks like a mess.

---

**sheepsheepx2** - 2025-06-02 17:52

For sure it aint winning game awards soon. 🫡  just a quick demonstration that the line to the top is curved all the way

---

**tokisangames** - 2025-06-02 17:53

This file is most definitely imported as 8-bit

📎 Attachment: 0DAC0B00-4EC3-434E-87F7-B4DC6962ED3B.png

---

**bottroy_91014** - 2025-06-02 21:47

<@455610038350774273> Hi Cory, this build https://github.com/TokisanGames/Terrain3D/actions/runs/15373386600 doesn't seem to load textures when you actually run a project. Textures are visible in editor, but default checkers board texture is rendered when launching a project. info log https://pastebin.com/AYUX0vQr , exception https://pastebin.com/i99ajkGN

---

**tokisangames** - 2025-06-02 21:58

Can you reproduce this in our demo? Runs fine for me.

---

**tokisangames** - 2025-06-02 22:00

This output is not from your terminal/console. This is from your output panel isn't it? I want to see only from your terminal per the docs.

---

**tokisangames** - 2025-06-02 22:01

Did you save your assets to a separate file? Try that. There's likely a bug attempting to reload from assets saved in the scene like yours.

---

**bottroy_91014** - 2025-06-02 22:04

Yeah, it seems like it. your demo works. Mine isn't working because used "copy" to transfer assets to a new scene. If I start from scratch it seems to be working. Looks like it's not backwards compatible for some reason. I'm going to get logs you are requesting

---

**tokisangames** - 2025-06-02 22:05

No need, only for the future

---

**bottroy_91014** - 2025-06-02 22:05

oh wait.. i used differnt binaries. wait sec

---

**tokisangames** - 2025-06-02 22:05

As I said, save your assets to a separate file. Or you can also unmark rendering/free_editor_textures

---

**tokisangames** - 2025-06-02 22:06

There's a bug when assets are saved in your scene. Thanks for the report.

---

**bottroy_91014** - 2025-06-02 22:07

oh yeah... that's why your demo is working. Confirming that saving assets in file works

---

**bottroy_91014** - 2025-06-02 22:08

it was broken recently. it is working at least in https://github.com/TokisanGames/Terrain3D/actions/runs/15073652102

---

**hutman** - 2025-06-03 00:15

When using the "+" to add regions for physics ive noticed it flattens the area, is there a way to prevent this?

---

**vhsotter** - 2025-06-03 00:22

Are you talking about the auto-generated background terrain being flattened? If so then no.

---

**hutman** - 2025-06-03 00:23

No worries, thanks 😄

---

**ruyvictor** - 2025-06-03 01:24

hello guys

---

**ruyvictor** - 2025-06-03 01:24

i need help

---

**ruyvictor** - 2025-06-03 01:24

i cant see grass

---

**ruyvictor** - 2025-06-03 01:24

*(no text content)*

📎 Attachment: image.png

---

**ruyvictor** - 2025-06-03 01:25

*(no text content)*

📎 Attachment: image.png

---

**ruyvictor** - 2025-06-03 01:25

*(no text content)*

📎 Attachment: image.png

---

**ruyvictor** - 2025-06-03 01:28

I'm sorry if I'm being stupid, I'm new to the addon, I took a look at the creator's tutorial, but I'm having trouble seeing the grass

---

**ruyvictor** - 2025-06-03 01:28

I believe it would just be added to the terrain and at runtime it would already appear?

---

**ruyvictor** - 2025-06-03 01:29

My camera has access to the terrain layer.

---

**ruyvictor** - 2025-06-03 01:39

*(no text content)*

📎 Attachment: image.png

---

**ruyvictor** - 2025-06-03 01:42

*(no text content)*

📎 Attachment: image.png

---

**ruyvictor** - 2025-06-03 01:42

<@455610038350774273> Strange bug, I reloaded the project. It came without the grass, I put the grass back and it appeared

---

**ruyvictor** - 2025-06-03 01:44

I believe that perhaps a popup would be necessary to restart godot as soon as I saved this file. This bug happens when you create your first configuration

📎 Attachment: image.png

---

**bottroy_91014** - 2025-06-03 02:43

Click on Terrain3D and save Terrain3DAssets to file by clicking "save to file"

---

**tokisangames** - 2025-06-03 04:54

Please describe the sequence of steps you performed. It's not clear at all what you did to trigger any potential bug.
And the versions used.

---

**danvin.exe** - 2025-06-03 15:54

Hey, I'm very new to 3D and making a small forest scene for my friends birthday using the Terrain3D. I've added tree I made to the world but the issue is it doesn't show properly. Do you have any ideas on how can I fix it? I really need help😭

📎 Attachment: image.png

---

**ruyvictor** - 2025-06-03 16:02

<@455610038350774273> Hello!

📎 Attachment: image.png

---

**ruyvictor** - 2025-06-03 16:03

To be more precise, I started decorating the land with grass before setting anything up.

---

**ruyvictor** - 2025-06-03 16:03

That's why the bug happened

---

**tangypop** - 2025-06-03 16:25

Your tree is probably multiple meshes. Combine your trunk and leaves in Blender. You can keep the leaves and trunk faces using separate materials. You can use multiple meshes but only for LOD purposes. Right now it's probably treating your leaves mesh as LOD0 and trunk as LOD1.

---

**danvin.exe** - 2025-06-03 18:05

Hey, thank you! It helped with the previous issue, but now tree is added sideways, do you know why such behavior could be triggered? Also, do you know is there any way to add collision shapes to the mashes?

📎 Attachment: image.png

---

**tangypop** - 2025-06-03 18:09

In Blender select everything and do shift+A then accept all transforms. Make sure your tree is at origin. I think collision is in the pipeline but I've been using an older Terrain3D build and using a script to place collision meshes.

---

**vhsotter** - 2025-06-03 18:09

There's two possibilities here.
1. You didn't apply rotation in Blender.
2. Check the settings of the brush using the three vertical dots in the panel at the bottom and make sure that rotation isn't set to 90˚.

---

**vhsotter** - 2025-06-03 18:10

Yep. PR 699 is working on collision.

---

**tangypop** - 2025-06-03 18:10

Good call, didn't think of rotation in Terrain3D. Could be that, too.

---

**danvin.exe** - 2025-06-03 18:11

Here is my brush settings in terrain3D

📎 Attachment: image.png

---

**danvin.exe** - 2025-06-03 18:11

Also in import settings it looks fine

📎 Attachment: image.png

---

**danvin.exe** - 2025-06-03 18:13

Could you give me some starting points on the script you are using for collisions? For what node do I need to write it? Will it be ok for the trees? Also, thank you very much for taking your time and helping me I really appreciate it

---

**vhsotter** - 2025-06-03 18:13

Looks fine. It would have been the Fixed Tilt if that were the case. Next thing is to look at the model in Blender. If you open the object properties (press "N") look at its rotation. If it's anything but zero, you'll need to apply rotation to the whole thing by pressing Ctrl+A and select apply rotation. Then re-export. There's a possibility you may have to export/import it under a different name because Godot has this weird bug sometimes where it'll cache the previous import and it might look like nothing's changed. (at least, I've experienced this).

---

**tangypop** - 2025-06-03 18:14

Random tilt looks very high. Are all trees sideways or are they seemingly random?

---

**danvin.exe** - 2025-06-03 18:14

Got it, will try that, thank you!

---

**danvin.exe** - 2025-06-03 18:16

Tried with zeros on everything, the trees are sideways

📎 Attachment: image.png

---

**vhsotter** - 2025-06-03 18:16

Apply rotation in Blender then.

---

**tangypop** - 2025-06-03 18:21

Here's the script I use for adding collisions, but it's very crude. Probably only use it until dynamic collision PR is merged.

https://discord.com/channels/691957978680786944/1130291534802202735/1321949034394685502

---

**vhsotter** - 2025-06-03 18:35

Yeah, instantiating a huge number of nodes for collision eats up memory like crazy, so if you plan to have a massive forest of trees be mindful of that. The PR that ShadowDragon is working on makes use of the PhysicsServer directly and has a few optimizations that significantly help with performance and memory usage.

---

**shadowdragon_86** - 2025-06-03 18:40

It's about 90% done, just the other 90% to go

---

**vhsotter** - 2025-06-03 18:41

Relatable.

---

**danvin.exe** - 2025-06-03 18:41

You were right about Blender, it helped, thank you very much! But I have another issue, it's now half way into the ground, even when I'm changing height offset to 20, can I somehow change it more then 20?

📎 Attachment: image.png

---

**xtarsia** - 2025-06-03 18:42

Also needs fixing in blender

---

**vhsotter** - 2025-06-03 18:42

The position is set by its origin point on the mesh. You'll need to relocate that in Blender.

---

**danvin.exe** - 2025-06-03 18:42

That sounds very cool! Is there any way I can try the raw version already?

---

**danvin.exe** - 2025-06-03 18:43

2D was so much easier God save my soul😭 .

---

**danvin.exe** - 2025-06-03 18:43

Thank y`all for such an extensive help you are awesome!

---

**vhsotter** - 2025-06-03 18:45

If you want the quick-and-dirty way of relocating the origin point, use this menu in Blender.

📎 Attachment: image.png

---

**vhsotter** - 2025-06-03 18:47

If you want it to align in a very specific place, such as a vertex or the middle of a ring of vertices, select the vertex(ices), Shift+S and select "Cursor to Selected", exit edit mode, then select the Object menu > Set Origin > Origin to 3D Cursor.

📎 Attachment: image.png

---

**danvin.exe** - 2025-06-03 19:07

It helped thank you a lot y`all!

---

**danielschardosin** - 2025-06-06 17:10

Good afternoon everyone,

After watching the tutorials and reading the documentation, I created my first textures using albedo, ambient occlusion, and normal maps based on the information provided.

While using the brushes to paint the ground with grass and other textures since my game has a cartoony style and doesn't aim for realism I noticed that the edges of the brush strokes sometimes appear slightly pixelated.
I’d like to ask: is this usually a result of poorly made textures, or is it a common limitation of the brushes themselves?

Thanks in advance!

---

**danielschardosin** - 2025-06-06 17:11

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-06-06 17:19

If you want to blend textures naturally, you need height textures and to use the Spray tool.

---

**tokisangames** - 2025-06-06 17:20

If you want a hard line between textures, use a nightly build that allows for that with careful use of the Paint tool.

---

**danielschardosin** - 2025-06-06 17:22

tanks

---

**wowtrafalgar** - 2025-06-06 18:47

has anyone made a gdshader that can grab normals from the terrain? I have a particle shader that does but am having trouble passing that to the foliage material to get better lighting

---

**tokisangames** - 2025-06-06 19:00

If you need the ground normal in the foliage (I doubt you do), you need to do the same thing you did for the particle shader. Pass the heightmap and calculate the normal. For every vertex of every piece of foliage. I don't think that will be very efficient.

---

**wowtrafalgar** - 2025-06-06 19:19

the use case is for a lod 3 billboard foliage to have it mimic the lighting of the terrain

---

**aleamanic2023** - 2025-06-06 22:57

If I correctly understood the previous discussion around use case of mapping Terrain3D onto planet surface (spherical topology), this is currently not feasible? Not making a space game, but still need to interactively travel high altitude across Earth, or track NPC travel (god game) across the globe, correctly reflecting planetary topology (going long enough in one direction gets you closer to the starting point again).

---

**aleamanic2023** - 2025-06-06 22:58

Also noticed that the chunks/LoD get created based on X (landscape surface) distance from camera, but not based on Y (altitude). Is flight simulator use case not within scope for this?

---

**tokisangames** - 2025-06-06 23:04

If you want a spherical terrain, use Zylann's voxel terrain. We can do a flat terrain up to 65,535m/side.

---

**tokisangames** - 2025-06-06 23:06

Lods are adjusted by X, Z. Y is not considered. Flight sums should be fine. Space / orbit Sims, won't work without tricks.

---

**wowtrafalgar** - 2025-06-07 22:08

what is a standard blend value? I assumed it would be a float from 0 to 1 but I see it is encoded as an int, is it 0-100?

---

**tokisangames** - 2025-06-08 02:23

The blend value is 0-1. When written to the control map it is encoded to an 8-bit int which has a range of 0-255.

---

**wowtrafalgar** - 2025-06-08 02:24

So should it be encoded as a float?

---

**wowtrafalgar** - 2025-06-08 02:24

For example enc_blend(.8)

---

**tokisangames** - 2025-06-08 02:25

Either use the setter in the Data class, or the helper functions in the Util class. The API docs tell you the type it expects. Float or int.

---

**wowtrafalgar** - 2025-06-08 02:28

thats what I'm confused about it looks like in the util it wants an int, the example doesn't show a value
int enc_blend(blend: int) static

var bits: int = util.enc_base(base_id) | util.enc_overlay(over_id) | \
util.enc_blend(blend) | util.enc_uv_rotation(uvrotation) | \
util.enc_uv_scale(uvscale) | util.enc_auto(autoshader) | \
util.enc_nav(navigation) | util.enc_hole(hole)
var color: Color = Color(util.as_float(bits), 0., 0., 1.)
data.set_control(global_pos, color)


Returns a control map uint with the blend value encoded. See the top description for usage.

---

**tokisangames** - 2025-06-08 02:30

Encoding might just mean shifting bits into position. If it wants an int, it's 0-255.

---

**wowtrafalgar** - 2025-06-08 02:31

var blend = int(round(clampf(blend,0,1) * 255))
This is what I was trying to pass into it but it didnt seem to be working

---

**wowtrafalgar** - 2025-06-08 02:31

util.enc_blend(blend)

---

**tokisangames** - 2025-06-08 02:31

Why aren't you using the Data setter?

---

**tokisangames** - 2025-06-08 02:32

You should always type your variables, and your literals.

---

**wowtrafalgar** - 2025-06-08 02:32

im using this for a splat import and am trying to set the blend with the value of the second highest pixel on the splat, here is the complete code

---

**tokisangames** - 2025-06-08 02:33

Is that variable an int or a float? You're using it as both. Don't do that.

---

**wowtrafalgar** - 2025-06-08 02:34

the server isn't letting me link the full code, but basically its taking the second highest color value from a splat and setting it as the overlay and the blend while the highest value is the base texture

---

**wowtrafalgar** - 2025-06-08 02:34

that was me converting the splat value 0-1 to int and range from 0-255 based on the util

---

**wowtrafalgar** - 2025-06-08 02:35

then I was returning the code img to be imported as the control map

---

**tokisangames** - 2025-06-08 02:36

Make it simpler until you understand bit packing. Pack hard coded int blend values of 0, 128, and 255. And make sure it works and you understand the output. Then go back one step to get a 0.0-1.0 into 0-255, or whatever your source is.

---

**tokisangames** - 2025-06-08 02:37

Use separate int and float variables, statically typed. Don't use duck typing.

---

**tokisangames** - 2025-06-08 02:38

Use typed literals. All floats have a decimal. Ints do not.

---

**wowtrafalgar** - 2025-06-08 02:40

just to make sure I understand the intent of the encoding, if I wanted to mix 50/50 between material 1 and 2 then I would do 
var bits = util.enc_base(1) | util.enc_overlay(2) | util.enc_blend(128)
var color: Color = Color(util.as_float(bits), 0., 0., 1.)
code_img.set_pixel(x,y, color)

for that particular pixel on the import

---

**wowtrafalgar** - 2025-06-08 02:42

I think you were spot on, since I wasn't setting the var as an int when declaring it, I was passing a float into the encode which did nothing here is the current improt with the control blend debug on

📎 Attachment: image.png

---

**wowtrafalgar** - 2025-06-08 02:44

so now I can get a traditional splat with blended values for the rgba and set the first as base texture, second as the overlay then take the value of the second as the blend, makes a bit cleaner of an import than the rough exclusions from before

---

**tokisangames** - 2025-06-08 02:52

You were also mixing float and int math with messy implicit type conversion.
Your bits var needs to be an int.

---

**wowtrafalgar** - 2025-06-08 02:54

this is what I ended up doing 
            var blend_float :float = int(round(clampf(second_highest,0,1) * 255))
            var blend : int = int(blend_float)

---

**tokisangames** - 2025-06-08 02:59

Again mixing float and int math. Clampf is a float. 255 is an int, as are 0 and 1. Give them all decimals.

---

**tokisangames** - 2025-06-08 03:00

Then don't take an int and assign it to a float, which you're doing twice!

---

**wowtrafalgar** - 2025-06-08 03:00

Gd script has given me bad habits

---

**tokisangames** - 2025-06-08 03:02

I strictly enforce types for my team, and Terrain3D and Sky3D. Our code is coherent.

---

**wowtrafalgar** - 2025-06-08 03:13

Lol mine isn't, but I'll get there!

---

**wowtrafalgar** - 2025-06-08 03:14

I think I'm more of a natural on the 3d modeling/animation side but it's just me so I'm playing the part of programmer

---

**tokisangames** - 2025-06-08 03:17

Best results come from learning and practicing modeling, animating, or programming the right way. If I winged my modeling or animation work, it would be as bad as winging programming work.

---

**tokisangames** - 2025-06-08 03:18

There's a saying to think about: "How you do anything is how you do everything."

---

**vhsotter** - 2025-06-08 03:21

I strongly recommend going into your project settings, turn on the Advanced Settings, then under Debug > GDScript, set "Untyped Declaration" to Error. It'll force you to declare your variables and function types and returns explicitly.

---

**wowtrafalgar** - 2025-06-08 03:22

Great idea, I have a lot of code to go back through and fix

---

**vhsotter** - 2025-06-08 03:22

Not only will it help you avoid many various errors, but there's also an actual performance boost from doing that. :)

---

**wowtrafalgar** - 2025-06-08 03:37

Yeah now that I'm implementing NPC racers I need all the optimization I can get

---

**topjimmies** - 2025-06-09 14:59

Ah, looks like terrain3d just breaks when using fsr2

---

**xtarsia** - 2025-06-09 15:05

Should be ~~fixed~~ fixable once godot 4.5 is released, earlier versions, yeah it's broke. Same with TAA, or any effect reliant on motion vectors.

---

**tokisangames** - 2025-06-09 15:48

https://github.com/TokisanGames/Terrain3D/issues/302

---

**topjimmies** - 2025-06-09 15:55

Ah, yeah I'm using 4.4.1 it's not a visual problem but it won't let me select the brushes or draw on terrain, just switched back to select mode saying the gizmo is missing.
I'll upgrade and try it again. Thank you!

---

**tokisangames** - 2025-06-09 17:41

No don't upgrade to an unsupported version that requires several steps to get working. Instead disable FSR until it is supported.
But FSR should only have visual problems. It doesn't break anything. I can use it fine on my system with some visual artifacts. You might have another issue.

---

**ruyvictor** - 2025-06-09 18:16

Hello

---

**ruyvictor** - 2025-06-09 18:16

I have a question, how do I make a mesh have a collision?

---

**ruyvictor** - 2025-06-09 18:17

I generated a StaticBody, but when I use it as a mesh the collision doesn't work

---

**tokisangames** - 2025-06-09 18:20

Since you asked in the terrain channel, the terrain already has collision generated when the scene is run. Read our collision document.

If you want to know how to make your own meshes have collision, you need a static body and a collision shape. Our rocks by the cave are examples. You should read through the Godot tutorials to learn these basics.

---

**ruyvictor** - 2025-06-09 18:26

<@455610038350774273> Thank you for contacting me, I read a lot of stuff in your documentation, I was a layman in the question (my English is not that good). It's just that I have a "Terrain3DMeshAsset" that already has collision configured

---

**ruyvictor** - 2025-06-09 18:27

In this case a tree,

---

**ruyvictor** - 2025-06-09 18:27

*(no text content)*

📎 Attachment: image.png

---

**ruyvictor** - 2025-06-09 18:28

*(no text content)*

📎 Attachment: image.png

---

**ruyvictor** - 2025-06-09 18:35

<@455610038350774273> Sorry, i found

---

**ruyvictor** - 2025-06-09 18:35

*(no text content)*

📎 Attachment: image.png

---

**ruyvictor** - 2025-06-09 18:36

The problem is that taking advantage of the random size and intensity feature is a godsend.

---

**ruyvictor** - 2025-06-09 18:37

Than placing the objects 1 by 1. Unless you use other addons for this, which I find a bit verbose.

---

**tokisangames** - 2025-06-09 18:52

https://github.com/TokisanGames/Terrain3D/pull/699

---

**ruyvictor** - 2025-06-09 19:00

I was already looking at your code to see what could be done

📎 Attachment: image.png

---

**ruyvictor** - 2025-06-09 19:01

But it's good that there's this PR XD

---

**rokass** - 2025-06-10 11:30

**Hi everyone, sorry for the disturbance!**
I'm a beginner and this is my first project using a game engine.
I'm not sure which channel is the right one to post this in, so I’m sharing it here, hoping it’s the best place.
Also, English isn’t my strong suit, so I wrote this message with the help of ChatGPT — I hope that’s okay!

---

**I need some help with Terrain3D in my multiplayer project.**

I’m working on a project where I launch multiple instances: one for the server, and one for the client.

* The **server** loads the `world.tscn` scene, which contains the `Terrain3D` node.
* The **client** first goes through a menu screen, then connects to the server and also instantiates the `world.tscn` scene.

The `world.tscn` scene **does not have a camera** by default. So, on the server side, the screen stays grey until a client connects. Once a client joins, the server seems to start rendering using the client's camera somehow.
After that, I can move around the map and everything looks fine **from the server's perspective**. However, the **client sees the terrain without textures** — it's just flat grey and white colors. On the other hand, the server can see the correct textures **through the player's camera**.

In the console, I get this error (only on the client side, I believe):

```
push_error: Terrain3D#9099:_grab_camera: Cannot find the active camera. Set it manually with Terrain3D.set_camera(). Stopping _physics_process()
```

If I add a camera directly to the `world.tscn` scene, the error disappears, but the issue remains — the client still doesn't see the textures, even though the server does.
I also get this warning, which seems unrelated (it concerns only one texture), but I’ll share it just in case:

```
push_warning: Terrain3DAssets#8816:_update_texture_files: ID 4 normal texture is not connected to a file.
```

Does anyone have an idea what could be causing this texture issue on the client side?
Thx a lot in advance!

---

**rokass** - 2025-06-10 11:30

----------------

Left : Server 
Right : Client

Image : https://cdn.discordapp.com/attachments/1170135022557216878/1381955533896024075/image.png?ex=684965e2&is=68481462&hm=959785116500d58fcfe836459699d02c73cc00a7d2daee56d1a4043de64f2732&

---

**tokisangames** - 2025-06-10 11:48

Uncheck free_editor_textures, as discussed in the release notes.
Or use a nightly build.
> push_warning: Terrain3DAssets#8816:_update_texture_files: ID 4 normal texture is not connected to a file.
Fix your texture. You've saved it in the scene or asset list.

---

**rokass** - 2025-06-10 11:51

bro

---

**rokass** - 2025-06-10 11:51

thx

---

**rokass** - 2025-06-10 11:51

so much

---

**ludo_sniper** - 2025-06-10 11:52

love you so much you can't understand how much time we've spent on that

---

**rokass** - 2025-06-10 11:52

3 days only

---

**tokisangames** - 2025-06-10 11:56

The Release Notes have relevant information about every release.

---

**tokisangames** - 2025-06-10 11:56

Your game looks very attractive. Make sure to get it in the Games Using Terrain3D list

---

**bluegradient** - 2025-06-10 23:57

Hey, so im experimenting with making a bunch of alpha stamps in Gaea for use on my terrain. I know the documentation mentions using a baked image for importing any textures or colors. Would there be any way to line up the colormap image with the alpha stamp rather than the whole terrain?

---

**tokisangames** - 2025-06-11 07:08

If using the import script, it provides coordinates where you can import and place height and color maps.

---

**bluegradient** - 2025-06-11 13:49

Thank you!

---

**eng_scott** - 2025-06-11 14:26

Any idea what would keep setting my T3d node to locked?

📎 Attachment: image.png

---

**xtarsia** - 2025-06-11 14:31

Terrain3D does i think, since it can't be moved anyways.

---

**eng_scott** - 2025-06-11 14:44

it keeps causing all my region files to go into read only mode and it crashes the editor when i go to save

---

**eng_scott** - 2025-06-11 14:44

im baffled it must be a godot thing because nothing in the region save function sets file attributes

---

**tokisangames** - 2025-06-11 15:08

Terrain3D intentionally locks itself.
Region files are intentionally read only in the inspector as well. You can edit the data through the tools or the API.

---

**tokisangames** - 2025-06-11 15:09

Crashing on save is a separate issue. Review your console logs if you can. Try a nightly build.

---

**eng_scott** - 2025-06-11 15:14

Yea im digging through code to try and trace whats happening:

📎 Attachment: image.png

---

**eng_scott** - 2025-06-11 15:15

somethign is setting the files on disk to read only and it crashes godot on save

---

**eng_scott** - 2025-06-11 15:18

just was curious if anyone had this issue to its possibly windows defender, git lfs or godot i feel like im trying to nail jello to the wall. Crazy thing is its happening on multiple team members computers

---

**tokisangames** - 2025-06-11 15:49

That's your Output panel, not your console/terminal. Your console often reports errors that do not go in the Output panel.
We don't lock the files on your filesystem. That is a Godot/OS issue.
Never heard of anyone with file issues.

These messags are indeed likely related to the crash. As I said, use a nightly build. Then:

* Identify "how" the files are set to read only. Not how it got set. What made you determine that the file is read only? That is an interpretation, but not one I would make based on the presented data. Are the file permissions set to read only?
* Check your filesystem for errors.
* Check your disk for bad sectors.
* Verify you don't have crashed instances of Godot still running.
* Run an open files report and see which process if any have the files open. On linux it's `lsof`. There's a windows tool for it as well.
* Ensure your project directory file permissions have full read and write access.
* Ensure you have adequate disk space.
* Test w/ disabled AV, and outside of a git directory.

---

**eng_scott** - 2025-06-11 15:53

i just hit it with a hammer and made an editor plugin that hooks pre save and changes the file permissions 😂

---

**tokisangames** - 2025-06-11 15:55

Your system has a problem. Ignoring that could lead to data loss. Backup continuously.

---

**eng_scott** - 2025-06-11 15:57

I understand that, however it happens on 7 different machines but only on windows. So in the sake of time this will works for now and stops blocking saving and crashing which was causing data loss. actually dont think this is a t3d issue but it only appears to happen with the region files. thanks

---

**eng_scott** - 2025-06-11 16:36

TLDR; it is `git lfs` setting locks on files. Which is actually doing what it is suppose to in a multi team environment godot just doesn't respond well to the locking

---

**eng_scott** - 2025-06-11 16:36

verify locking specificly

---

**tokisangames** - 2025-06-11 16:39

Do you have multiple people using the same system?
We use git lfs on separate computers and have had no such issue.

---

**eng_scott** - 2025-06-11 16:40

do you have verify locking enabled?

---

**eng_scott** - 2025-06-11 16:49

Soon as i run a git pull and check file permissions they all get set to read only if i disable verify locking it doesnt happen. Took a but of work with chat gpt to figure it out but we got there 😂

---

**eng_scott** - 2025-06-11 16:54

from the git manual ```Once file patterns in . gitattributes are lockable, Git LFS will make them read-only on the local file system automatically. This prevents users from accidentally editing a file without locking it first.```

---

**tokisangames** - 2025-06-11 16:54

No

---

**wowtrafalgar** - 2025-06-13 17:03

I have two scenes using Terrain, if I swap between scenes then the terrain assets do not load on the second scene but if I launch the scene directly then it works fine. My method of "changing scenes" is I have a level root node and then load the next scene, and after that scene has been loaded make it the first child of the level root and then queue_free() the previous scene. I think the issue might be coming from during that switch two terrain nodes are active at once. Any tips on how to resolve this?

---

**wowtrafalgar** - 2025-06-13 17:10

ok interestingly this only occurs if both scenes are referencing the same terrain3dassets

---

**tokisangames** - 2025-06-13 17:11

Uncheck free_editor_textures as documented in the release notes or use a nightly build

---

**wowtrafalgar** - 2025-06-13 17:16

worked like a charm thanks!

---

**zaiah_b** - 2025-06-14 05:36

I switched from using a foliage addon to the one built in to terrain 3D. Shining a flashlight right at the grass here and its black. Any tips to try to fix this?

📎 Attachment: image.png

---

**tokisangames** - 2025-06-14 05:50

Your material is rendering the back face of your mesh backwards. Add backlighting or make it a shader and reverse your backwards normals.
`NORMAL = !FRONT_FACING ? -NORMAL : NORMAL;`

---

**zaiah_b** - 2025-06-14 06:32

backlighting works great, and loving the performance of the foliage system. This addon should be built into godot. Thanks again.

---

**andy.designs** - 2025-06-16 03:59

Hello i have the problem that the terrain wont add the mesh. While it works with threes the grass isnt placed

---

**momikk_** - 2025-06-16 04:14

*(no text content)*

📎 Attachment: image.png

---

**momikk_** - 2025-06-16 04:14

can I move regions? If I want to move a mountain

---

**shadowdragon_86** - 2025-06-16 06:39

More information is needed,

Check the docs and make sure you followed the process properly.

If you don't find the problem please share your console output, a  screenshot of your scene file set up and also the mesh asset settings (right click the mesh in the asset dock)

---

**shadowdragon_86** - 2025-06-16 06:50

You could export the heightmap, edit it outside of Godot then reimport it. 

You could rename the data files with the new region location.

Neither are likely to give you a good result! Better to block out your map quickly without details, flatting the old mountain and raising a new one. When the mountains are in the right place, move on to the details.

---

**tokisangames** - 2025-06-16 07:47

Rename the files with Godot closed. There is a region mover script in extras for more in depth moves.

---

**tokisangames** - 2025-06-16 07:51

So it will add instances and is working fine with your trees. It's not working with your grass mesh. Therefore something is likely broken in your grass mesh setup. We can't guess at what that is if you don't share any information about it.

---

**andy.designs** - 2025-06-16 09:23

Ok I will check when I’m at home from work

---

**andy.designs** - 2025-06-16 09:23

I think it’s because the mesh itself

---

**tokisangames** - 2025-06-16 09:35

Review our instancer documentation.

---

**momikk_** - 2025-06-16 09:40

how do I transfer a scene to a blender? It is not transferable

---

**tokisangames** - 2025-06-16 09:47

Of course, they are constructed entirely differently. You can bake an array mesh without texturing and export that [as documented](https://terrain3d.readthedocs.io/en/stable/docs/import_export.html#exporting-gltf). I see there are some typos in there.

---

**introverted_hey** - 2025-06-16 15:20

Hi! I'm new to game dev and am trying to understand if Terrain3D would suit my needs.

I want a relatively small map which has several caves. Low poly look as well.

At the first glance, Terrain3D is quite the opposite: ability to build huge maps with good graphics without caving or overhang features.

But here is what I found already, a list of options to make Terrain3D suit me more:
* decreasing lods to lowest, increasing the mesh size.
* playing with vertex spacing
* using square brushes
* lowpoly_colormap shader (included in Terrain 3D extras). but it doesn't work with textures and I'm a complete newbie at editing shaders. But I can try.

I’d really appreciate any thoughts or advice. Or may be there are some fundamental caveats that Im missing.

For example, I'm thinking about making second Terrain3D node, mirror it and use as a upper part of the cave 🙂 not sure it can be done though

---

**tokisangames** - 2025-06-16 17:25

Two terrain nodes for caves could work, but it's not a great workflow. You're better off making your caves in blender and importing a full cave mesh, or just the top to sit on a Terrain3D floor.

---

**polcovnicflint** - 2025-06-17 04:34

how do I access Terrain3D methods from c#

---

**polcovnicflint** - 2025-06-17 04:35

Gdscript works, but I don't have any ideas from c# at all.

---

**tokisangames** - 2025-06-17 06:16

Read the programming languages page in the docs

---

**legacyfanum** - 2025-06-17 20:15

I want to extend the terrain shader and it's been a long time I tackled this and went through all the shader code to understand it.

---

**legacyfanum** - 2025-06-17 20:15

I see you've done many improvements on it

---

**legacyfanum** - 2025-06-17 20:16

Should I expect a major change

---

**legacyfanum** - 2025-06-17 20:17

Because I don't want rebuild it again after some cool feature lands in, I once again ask for the final shader lol <@188054719481118720>

---

**legacyfanum** - 2025-06-17 20:19

bonus points if it has the light function perfectly imitating that of the godot's shader

---

**nate8thomas** - 2025-06-17 21:08

I'm having issues with textures even after following the documentation. After channel packing and reimporting, when I apply some albedo and any normal textures, it causes the whole terrain object to turn white-ish. I am also confused as to why both height and normal textures are created if there is only space for a normal texture.

📎 Attachment: image.png

---

**nate8thomas** - 2025-06-17 21:09

Is there a YouTube guide I can watch to ensure I am channel packing and reimporting correctly?

---

**xtarsia** - 2025-06-17 21:14

there's things like displacement, and potentially RVT / compute stuff down the line, so "final shader" might be around.. 2030 :p

i'd consider using some #includes for now, to try and self-contain your changes as much as possible to make upgrading easier

---

**xtarsia** - 2025-06-17 21:15

this is very likely to be import settings, not matching between all textures, high quality / mipmap generation / texture sizes, not matching.

---

**xtarsia** - 2025-06-17 21:16

https://terrain3d.readthedocs.io/en/stable/docs/texture_prep.html

---

**nate8thomas** - 2025-06-17 21:28

I channel packed the images as shown in the first image. This gave me the packed_albedo_height.png file. I reimported each file shown in the FileSystem (second image) with the settings shown in the third image. I then applied the reimported textures as shown in the fourth image, to the same result.

📎 Attachment: image.png

---

**nate8thomas** - 2025-06-17 21:29

The white-ish effect occurs even without a normal texture.

---

**nate8thomas** - 2025-06-17 21:29

*(no text content)*

📎 Attachment: image.png

---

**xtarsia** - 2025-06-17 21:31

this has to be identical between all ID for albedo. and the same is true that all normal maps must match too.

📎 Attachment: image.png

---

**nate8thomas** - 2025-06-17 21:33

You're saying that all albedo must be the same even if they are different textures?

---

**xtarsia** - 2025-06-17 21:35

the size, format, and mipmap configuration must match, yes.

---

**nate8thomas** - 2025-06-17 21:37

Thank you! That worked!

---

**nate8thomas** - 2025-06-17 21:38

Last question, is there any way to disable the NavPart so that it's not constantly highlighted overtop the terrain?

---

**nate8thomas** - 2025-06-17 21:38

*(no text content)*

📎 Attachment: image.png

---

**xtarsia** - 2025-06-17 21:40

either hide gizmos, or make the nav mesh not visible in the scene tree.

---

**nate8thomas** - 2025-06-17 21:43

Perfect, tysm

---

**effect_and_cause** - 2025-06-17 22:57

quick question, I figured I would ask if spherical terrains are a thing/ will ever be developed?

---

**tokisangames** - 2025-06-17 23:08

No. Use Zylann's voxel terrain.

---

**effect_and_cause** - 2025-06-17 23:09

ok thank you!

---

**tokisangames** - 2025-06-17 23:09

You can look at the commit history of just the main shader. Lots of changes. There will never be a final shader.

---

**legacyfanum** - 2025-06-17 23:16

use bevy engine and bevy terrain for that

---

**effect_and_cause** - 2025-06-18 02:00

do you happen to have a video for install? the docs that come with it arent sufficing

---

**tokisangames** - 2025-06-18 05:32

The docs have a page on tutorial videos. Are you looking at the documentation linked from github? There are many pages and 3 videos.

---

**legacyfanum** - 2025-06-18 06:05

I was looking for the one with the light shader

---

**xtarsia** - 2025-06-18 06:15

there is no custom light() for terrain3D at the moment. Changes were made to allow use of it tho, thats all.

---

**legacyfanum** - 2025-06-18 07:14

what's with the passes, what they are and what is the search depth. can you make it a little more descriptive for me

📎 Attachment: Screenshot_2025-06-18_at_10.13.07_AM.png

---

**legacyfanum** - 2025-06-18 07:39

new comments you added are just 👌

---

**mustachioed_cat** - 2025-06-18 08:53

<@188054719481118720> what does RVT mean? I keep seeing it but no clear definition and internet doesn’t turn anything up either.

---

**xtarsia** - 2025-06-18 08:54

Runtime Virtual Texture

---

**jordan4longshaw** - 2025-06-19 05:40

Hey guys, wanting terrain3D in a Godot (4..2.2) project. Is 0.9.3a the best option for that?

Asking cause it's a beta release. And version 1.0 doesn't support Godot 4.2.2

---

**tokisangames** - 2025-06-19 05:47

Or build the 0.9 branch. 0.9 is beta.

---

**jordan4longshaw** - 2025-06-19 05:51

Damn, sounding like a Godot upgrade to Godot 4.3 or 4.4 is inevitable.. If I want a stable Terrain3D version with it, init

---

**tokisangames** - 2025-06-19 06:03

Terrain3D has been stable since our first alpha release 0.8.0.

---

**tokisangames** - 2025-06-19 06:04

If you want the improved features, you need to upgrade. We support approximately the current and previous generation.

---

**jordan4longshaw** - 2025-06-19 06:05

Ahhh, I was misunderstanding what "beta" means in terms of releases, when compared to non-beta releases

---

**jordan4longshaw** - 2025-06-19 06:06

So 0.9.3a should have no nasties or issues cropping up later, assuming I'm using a compatible version (like Godot 4.2.2)

---

**tokisangames** - 2025-06-19 06:07

It is stable, not bug free. Use the 0.9 branch nightly builds.

---

**jordan4longshaw** - 2025-06-19 06:23

Will do, thanks for your help 🙂

---

**legacyfanum** - 2025-06-19 11:57

do varyings get interpolated from vertex to fragment shader

---

**legacyfanum** - 2025-06-19 11:57

```glsl
float far_factor = clamp(smoothstep(dual_scale_near, dual_scale_far, length(v_vertex - _camera_pos)), 0.0, 1.0);
```

---

**legacyfanum** - 2025-06-19 11:58

what if I had this in the vertex stage and stored this in a varying float

---

**legacyfanum** - 2025-06-19 11:58

I would save performance, no?

---

**xtarsia** - 2025-06-19 12:01

Yes they get interpolated if they don't have the flat flag.

However it isn't free, and having a large number of varying can affect performance in its own way as well.

---

**legacyfanum** - 2025-06-19 12:01

understood.

---

**xtarsia** - 2025-06-19 12:02

Especially on low end hardware. Also I want to keep the vertex function light so that when the high density "tesselation" effect goes in, it doesn't cost too much performance.

---

**legacyfanum** - 2025-06-19 12:02

totally makes sense

---

**lithrun** - 2025-06-19 14:23

Is there a low poly shader which also supports textures? I used one that was referenced in some PR comment for Terrain3D v0.93a, but that isn't working anymore now that I upgraded to v1.0.0.

As a temporary workaround I am using the lowpoly_colormap.gdshader, but it doesn't support textures.

---

**tokisangames** - 2025-06-19 14:31

Nightly builds have one built in to the material

---

**lithrun** - 2025-06-19 14:33

That's perfect. I will check it out!

---

**mattmilburn** - 2025-06-19 16:23

Hello! I’m new to Terrain3D and I’m wondering if anyone can give me a quick yes/no answer if my idea is out of scope for Terrain3D.

I want to create an open world game that would use Terrain3D but it would not have boundaries, it would eventually repeat the same terrain if the player runs straight in one direction for long enough. Imagine playing Final Fantasy or some RPG on the SNES or PS1 that let's you fly an airship or something across an overworld area - that’s what I want to do. I imagine this would involve moving the world rather than moving the player… sorta like running on a conveyor belt. I know the implementation would be another conversation, but I’m trying to decide if this is possible with Terrain3D first. Thanks in advance for any help with this idea 🙂

---

**tokisangames** - 2025-06-19 17:09

> but it would not have boundaries
Current max is 65,536m per side, which is >30x larger than GTA5 and Witcher3.
> it would eventually repeat the same terrain if the player runs straight in one direction for long enough
You'd need to build the engine and export, and Terrain3D with double precision if moving >32,768 or so down any axis or you run the risk of jitter in your game.
> moving the world
Terrain3D does not support this.

---

**xtarsia** - 2025-06-19 17:20

> it would eventually repeat the same terrain if the player runs straight in one direction for long enough.
This is usually achieved by teleporting the player. There is a reason that the old FF games world map edges were 100% ocean, as its effectively a void space that makes teleportation to a different edge instant and seamless.

So if you ensure that the map boundary is further away than the max view distance of any terrain from that boundary, you can just teleport the player to wrap them around.

---

**xtarsia** - 2025-06-19 17:20

Wind Waker did this as well

---

**xtarsia** - 2025-06-19 17:22

you could even fade in some fog to hide it, or any number of other visual tricks. Its all smoke and mirrors really 😄

---

**mattmilburn** - 2025-06-19 17:43

<@455610038350774273> <@188054719481118720> Thank you for the great feedback! I'll tinker with the "teleport" idea or just refactor my idea to embrace world boundaries in the game design 🙂

---

**buddypalepic** - 2025-06-20 00:41

yo can it just bake everything into a mesh with textures and all

---

**tokisangames** - 2025-06-20 02:36

No. You can bake a non optimal arraymesh. Read the bottom of the export doc.

---

**buddypalepic** - 2025-06-20 02:38

could it bake to an array mesh with uv baked too so it still could use textures

---

**tokisangames** - 2025-06-20 02:45

You should not use this arraymesh in Godot. It's too dense, and only for reference. You can move it into blender and remesh it. You could unwrap its UVs as part of this process. Then it could be used in Godot once it's optimized.

---

**legacyfanum** - 2025-06-20 07:04

I am trying to paint snow using the brushes
1 - how can I use brushes other than default ones. I export my maps from the terrain tool and I want to paint snow using the snow map. I don't want to deal with writing a compute shader to alter the control map.
2 - I tried using the default brushes, and it seems to not work.

---

**legacyfanum** - 2025-06-20 07:10

preparing a demonstration

---

**legacyfanum** - 2025-06-20 07:17

*(no text content)*

📎 Attachment: Screen_Recording_2025-06-20_at_10.11.49_AM.mp4

---

**legacyfanum** - 2025-06-20 07:28

strength at 100..

---

**legacyfanum** - 2025-06-20 08:56

in theory it should work, right?

---

**tokisangames** - 2025-06-20 09:05

* Docs discuss adding your own brushes to the brushes directory outside of Godot.
* We added a snow texture and were able to paint snow without issue.
* Shown in your video is how one would paint with an alpha stamp or alpha mask, which also works fine and is shown in my videos (video tutorial page). Use the raise brush and increase strength to 10,000-30,000. To do so with Spray, which is designed to have the mouse held down, and since there is no GPU editing, you need to get all of the strength done in one click. Try a strength of 10,000.

---

**legacyfanum** - 2025-06-20 09:59

thanks

---

**legacyfanum** - 2025-06-20 11:32

How can I use the color map in another shader? I cannot find the instance of the color map in the directory and when I edit the color map using the terrain editor does it also write to a file that I can use somewhere else?

---

**shadowdragon_86** - 2025-06-20 11:47

You can export it:

https://terrain3d.readthedocs.io/en/stable/docs/import_export.html

Or access the maps through the API:

https://terrain3d.readthedocs.io/en/stable/api/class_terrain3ddata.html#class-terrain3ddata-method-get-maps

---

**tokisangames** - 2025-06-20 12:53

https://terrain3d.readthedocs.io/en/stable/docs/tips.html#accessing-private-shader-variables

---

**legacyfanum** - 2025-06-20 13:12

this seems like what I'm looking for. How can I set it as a global shader variable though?

---

**tokisangames** - 2025-06-20 13:19

Look in godot docs on how to make or access global shader uniforms and set it in a tool script.

---

**legacyfanum** - 2025-06-20 13:49

while painting, can I have a height filter just the way I do for slope of the vertices?

---

**legacyfanum** - 2025-06-20 14:09

also please warn me if Im clogging up the chat, I won't hesitate to create a thread

---

**buddypalepic** - 2025-06-20 14:58

doesnt worok

---

**il_loree** - 2025-06-20 15:23

Hi everyone,

I'm trying to create my first terrain in Godot using the latest version of the Terrain3D plugin. I have a 32-bit EXR heightmap in sRGB color space, with a resolution of 8192×8192 pixels, which I exported from a terrain in Blender that represents a 1000 square meter area.

Despite carefully reading the official documentation, I haven’t been able to configure the plugin correctly to get a terrain that matches the real-world size of 1000 meters by 1000 meters. The terrain always appears much larger than expected.

Could someone please guide me through the correct settings for importing this heightmap so that the final terrain in Godot matches the intended scale?

Thanks in advance!

📎 Attachment: image.png

---

**tokisangames** - 2025-06-20 15:24

What doesn't work? My message to another person is accurate. The docs specify the details

---

**tokisangames** - 2025-06-20 15:30

Did you read the heightmap document which explains this exact scenario? You have a lateral terrain resolution of 8:1, which is way overkill for a game. You need to reduce your maps to 4:1 at most dense and a 0.25 vertex scaling, but 1:1 is most likely all you need. The document goes over the steps.

---

**tarzwrld** - 2025-06-20 21:06

Uh so I just had to reinstall godot from steam to get it to update and now Im starting from scratch. I just cant get the material and assets to show up for me

---

**tokisangames** - 2025-06-20 21:09

Does our demo work?

---

**tarzwrld** - 2025-06-20 21:10

I uploaded the add on like normal, thats probably what happen3d

---

**tarzwrld** - 2025-06-20 21:19

<@455610038350774273> I opened a new project with a 3d scene and put in terrain 3d, I get an all white floor but i cant see anythig else. I tried doing exactly whjat was done in the video, but theres nothing to import when given the chance for a new project

---

**tarzwrld** - 2025-06-20 21:30

Im so lost

---

**tarzwrld** - 2025-06-20 21:43

I found out how to do it

---

**legacyfanum** - 2025-06-21 16:15

```python
print(get_shader_param("_texture_normal_depth_array"))
```
returns null even though the shader includes the array. the shader is a shader override.

---

**legacyfanum** - 2025-06-21 16:17

I set the shader in init.
```python
shader_override = load(shader_path).duplicate(true)
```

---

**legacyfanum** - 2025-06-21 16:22

could it be this? https://github.com/godotengine/godot/issues/80861

---

**legacyfanum** - 2025-06-21 16:24

If it's this I don't understand what the first comment meant at all.

---

**xtarsia** - 2025-06-21 16:49

You need to get the rid of the terrain material, and use the rendering server version of that. It's in the docs somewhere, tho I'm on mobile atm

---

**legacyfanum** - 2025-06-21 17:02

terrain3d docs or godot docs?

---

**legacyfanum** - 2025-06-21 17:08

```python
RenderingServer.material_get_param(terrain.get_material().get_material_rid(), "_background_mode")
``` this?

---

**legacyfanum** - 2025-06-21 17:09

let's try

---

**legacyfanum** - 2025-06-21 17:14

it worked, it's very clever why you do this.

---

**legacyfanum** - 2025-06-21 17:15

This way, regardless of the shader you can freely set the parameters. If new shaders match their uniform variables, they get changed.

---

**pedraopedrao** - 2025-06-21 21:22

hello, still trying to optimize better the game, i reinstall the terrain 3d and i am testing on the demo scene. i created 108 new areas (1024 region size) and still the game breaks. i play games like red dead 2 and elden ring on my pc. so i thinks maybe theres something else. you guys have any suggestions for what can i do? pls

---

**tokisangames** - 2025-06-21 21:26

Post versions, PC specs, renderer, memory/vram usage and total, framerate.

---

**legacyfanum** - 2025-06-22 05:48

to the people who worked on the terrain3d assets resource, what did you pay attention to while packing & updating the texture2darray

---

**legacyfanum** - 2025-06-22 05:48

what were the rules & steps?

---

**tokisangames** - 2025-06-22 05:51

https://github.com/TokisanGames/Terrain3D/pull/728 was merged to account for your billboard gap issue by increasing the overlap on the last lod. Let me know if it persists. <@78674731095556096>

---

**tokisangames** - 2025-06-22 05:52

I don't understand your question. Perhaps it will be clear if you just look at the code.

---

**maarrine** - 2025-06-22 22:46

how come I'm unable to locate Terrain3D in the asset library? was it temporarily removed?

📎 Attachment: image.png

---

**maarrine** - 2025-06-22 22:50

oh wait i'm stupid

---

**maarrine** - 2025-06-22 22:50

lol

---

**pedraopedrao** - 2025-06-23 00:23

you know if it is possible to make low poly terrain with terrain 3D?

---

**snowminx** - 2025-06-23 00:38

This might help https://terrain3d.readthedocs.io/en/stable/docs/tips.html#low-poly-ps1-styles

---

**pedraopedrao** - 2025-06-23 23:32

godot version 4.4 and the terrain 3D i think its the last version, i downloaded on godot asset lib. pc specs: gtx 1050ti 4gb, xeon e5 2666 v3, 16 gb ram. framerate 60 when there is few areas,  but the more areas you have, the more broken it gets and the fps drops a lot. i created a new project where there is only the terrain3d, i made it to make a few tests and the result is the same. more areas = more stutter until it becomes impossible even to play the game. on youtube someone said it that can created 16k terrain. maybe my pc just doenst have such power. But still, there must be some way to make the game not generate all the areas at the same time, so I believe the game would be playable. any tips? pls

---

**iolechka** - 2025-06-24 03:34

hey, i've been doing my map and terrain3d (1.0.0) crashes godot (4.4.1) when using any of the height tools. terrain has 5 meshes (already instanced a lot of them), and settings are on the screenshots

any tips on what might be wrong?

📎 Attachment: image.png

---

**iolechka** - 2025-06-24 03:42

okay solved, but not sure what exactly helped.
i did 2 things:
1) i checked logs in this server. on previous instance of "height crash" the thing that helped was checking that there are exactly as many textures and meshes as there are slots for them. i added sixth mesh, which apparently WAS on my map, and then deleted it for sure.
2) after that i disabled "height blending, world space normal blend and enable projection" and reenabled them. any combination of them being on/off works fine

---

**tokisangames** - 2025-06-24 05:46

You probably have vsync enabled. Turn that off so you can see the real measure above 60fps. A 1050ti is a bit old and lightly powered, but should run OK. I asked you about usage as well. Use your task manager and report vram consumed. 

 Games typically occlude distant objects. Bake and enable occlusion culling. Try using the lightweight shader. Also disable the material features described in the Tips document under performance.

---

**tokisangames** - 2025-06-24 05:51

You're using a server?
What crashed? Your OS, your game, your editor?
You can test with a nightly build which might have fixed any known crashes. There might have been one with the instances. 

If that isn't it, nothing you're doing in the material settings should cause a crash unless there is a bug in your video card driver. Thus you should upgrade your driver.

---

**ryo2948** - 2025-06-24 07:19

For some reason my terrain looks different in editor than in export. I tried exporting multiple times in different folders and even re-saved the data in the directory. What could be the issue? https://youtu.be/fyYlzVHoOTc

---

**tokisangames** - 2025-06-24 08:30

I don't see any difference except in your lighting. Show us a test with the same rendering environment. Use unshaded in both.

---

**ryo2948** - 2025-06-24 08:48

https://youtu.be/pOPouAzYLoI

---

**legacyfanum** - 2025-06-24 08:54

do you automatically fetch these from the uniform list of the current shader, or do you store these in the code beforehand?

📎 Attachment: Screenshot_2025-06-24_at_11.37.48_AM.png

---

**tokisangames** - 2025-06-24 09:33

All non-private (no _ preface) uniforms are pulled into the material.

---

**legacyfanum** - 2025-06-24 09:38

when I change/ rename the uniforms in the custome shader it doesn't appear in the editor though

---

**legacyfanum** - 2025-06-24 09:39

is it supposed to first of

---

**tokisangames** - 2025-06-24 09:40

Are you able to produce this in our demo? I cannot, and haven't noticed it as an issue on our game. Here is a perfectly aligned mesh instance with the terrain and renders with exact placement in editor and in game. If you can produce it in our demo, give me settings or an MRP and we can track the bug. If you cannot, only in your project, then you need to strip your project down into test scenes to narrow down the cause.

📎 Attachment: Godot_v4.4.1-stable_win64_QmYZOuisk3.png

---

**tokisangames** - 2025-06-24 09:41

The material updates with them instantly.

📎 Attachment: 9E26CF50-1C35-4BBC-A474-DB7CFD8DDE27.png

---

**ryo2948** - 2025-06-24 09:49

Idk if I can reproduce it in the demo because I dont know what causes it in the first place. However, I did change the region size a few times some days ago, from 256 to 512, then back to 256 later and edited the terrain afterwards. Maybe that contributed to the issue?

The main problem is that it seems like as if the exported version of the terrain is of a lower resolution heightmap. Certain mountains that are smoother in editor look lower poly in the exported version. 

This never used to happen until recently, so I can't be sure what the cause is. Maybe I should recreate the whole terrain, but that sounds like a hassle too lol.

---

**tokisangames** - 2025-06-24 09:51

> Idk if I can reproduce it in the demo because I dont know what causes it in the first place.
Your mesh doesn't align with the terrain in game.
Can you make mesh align with terrain in our demo or not?

---

**legacyfanum** - 2025-06-24 09:51

worked this time thankss

---

**tokisangames** - 2025-06-24 09:51

Do you have an error about setting your camera in the console? Perhaps you're not updating your lods because you ignored the message.

---

**ryo2948** - 2025-06-24 09:56

Demo seems fine. It aligns. I do have multiple cameras in my main scene. I am using code to make the player camera the 'current' camera after a cutscene finishes. But maybe terrain3d doesnt know yet that the cameras have switched and it still thinks we are in the other camera? which might be causing the low LOD?

---

**tokisangames** - 2025-06-24 09:57

If you haven't told it to change the camera, then no it doesn't know. That's exactly the problem.

---

**tokisangames** - 2025-06-24 09:57

From now on always use your console/terminal. Don't develop in the dark.

---

**ryo2948** - 2025-06-24 10:00

Okay. Thanks for that.

---

**ryo2948** - 2025-06-24 10:21

Umm... I looked at the docs and it says I should use the set_camera() function. But where exactly do I put it? Because the terrain3D node doesnt seem to have a script attached.

---

**tokisangames** - 2025-06-24 10:36

Put it wherever you like. Probably in your class that instantiates and controls your camera, like your player, or your scene script. Or add a script to the Terrain3D node, but that's probably a poor choice. Terrain3D is a gdextension so operates like an engine class; none of the engine classes come with a script already attached. 
Wherever you put it, it's not for me to dictate how you structure your code.

---

**ryo2948** - 2025-06-24 10:37

Alright then. Thanks

---

**br0therbull** - 2025-06-24 17:55

Hello, first thanks for the awesome terrain3D. Would you have any idea how to make a texture (like an AoE sprite around an object) snap to the terrain height? I tried particles, but they keep horizontal and end up below the relief. I tried an AoE shader with volume, but it's not exactly what I'm looking for... I assume it would be through something in shader vertices accessing the terrain data?

---

**tokisangames** - 2025-06-24 17:59

Terrain height is accessible from terrain.data.get_height(). Shaders can access the heightmap as shown in the Tips doc.
Do you have a video showing what you're attempting to achieve?

---

**br0therbull** - 2025-06-24 18:10

I tried to follow the instructions from the tip doc, without success. Here is a small video showing the textures. It works on a plane terrain, but any relief of course makes it disappear...

📎 Attachment: Gravacao_de_Tela_2025-06-24_150826.mp4

---

**tokisangames** - 2025-06-24 18:20

Easy ways are to use a decal, or a sprite with no depth test.
Medium way is to insert your own shader include into our override shader that paints your own textures on the terrain, but that won't show through foliage or assets.

---

**br0therbull** - 2025-06-24 18:34

I was able to use the sprite with no depth test, fantastic! Now, i'll work on the medium way :p. Thank you so much for your time.

---

**pedraopedrao** - 2025-06-24 18:49

57% memory usage, tested on the demo scene with more or less 110 areas (1024 region size) and i did these things you said, but the game still run slow, and has a lot of fps drop

---

**tokisangames** - 2025-06-24 19:10

You used the light weight shader, and baked occlusion, and did all of the things in Tips, and there's no difference? I doubt that.
You still have not told me about your ram and vram consumption. If you're using all of your resources your system will be saturated swapping into virtual memory which will kill the performance of any thing.
I can run 100 regions sized at 1024 in the editor viewport at 900fps, and in game 280fps at 1920x1200, using only 3GB of ram and 2GB of vram as reported by task manager. You should be able to do 60fps without issue.
You're not giving us all of the information and aren't adequately testing your system.

---

**tokisangames** - 2025-06-24 19:12

Let's start the tests over. Use our demo to test, not your game. The region size is already 1024. Add 100 regions and tell me all of these points:
* Your FPS in the editor
* Your FPS running the demo at full screen
* Your monitor resolution
* Your total RAM and VRAM consumption out of maximum via task manager

---

**pedraopedrao** - 2025-06-24 19:31

just the light weight shader i do not tested, and i dont know how to use it. baked oclusion and the tips i tested. my monitor resolution is 1920x1080. i have 16gb ram and it used 47% on the tests. in the task manager, the cpu usage are very slow, slower than 10%. while the GPU usage fluctuates a lot, it goes from like 5% to 20% very quickly. but it doesn't go much beyond that and i used the demo to do the tests. the fps on the editor i dont know how to see it, but looks well. in the game its around 80fps, but drops a lot, It quickly drops to, like, 2 fps. impossible to play the game. These FPS drops are the problem, if it weren't for that the game would be playable

---

**pedraopedrao** - 2025-06-24 19:35

before, i also have reduced mesh lods and mesh size. It got to a point where I could barely see anything on the map because the area was so small. But even so, the game had FPS drops.

---

**tokisangames** - 2025-06-24 19:36

Editor viewport / Perspective / View Frame Time

---

**pedraopedrao** - 2025-06-24 19:40

around 130-200fps

---

**tokisangames** - 2025-06-24 19:43

Consistently, no frame drops in the editor?

---

**pedraopedrao** - 2025-06-24 19:45

yes, Consistently

---

**tokisangames** - 2025-06-24 19:46

In our demo, disable collision and run it. Press G to disable gravity in the game.

---

**tokisangames** - 2025-06-24 20:01

Do you still have the frame drop in the demo game?

---

**pedraopedrao** - 2025-06-24 20:15

collision mode disabled but still has frame drop

---

**tokisangames** - 2025-06-24 20:19

How frequently? Under what circumstances? If hovering and not moving the player or camera? Or what? 
Mimic the exact same behavior in the editor, where you don't get a frame drop.
There's very little difference between editor and game mode, except for collision. Since you've turned collision generation off, there's basically zero difference between the two.

---

**tokisangames** - 2025-06-24 20:19

Record a video.

---

**pedraopedrao** - 2025-06-24 20:29

https://youtu.be/aRxvZW88_hA?si=Iq8zTffMUn7fySxj

---

**tokisangames** - 2025-06-24 20:45

In the video you're constantly moving. What happens to the FPS if you stand still? 
In the editor what happens if you move as much as you did in game?

---

**tokisangames** - 2025-06-24 20:46

What does your terminal say? Do you have any messages or errors in it?

---

**pedraopedrao** - 2025-06-24 20:48

if i stand still the fps still drops.

---

**tokisangames** - 2025-06-24 20:48

When in game, switch back to the godot editor and minimize it. Then return to the game and check FPS.

---

**pedraopedrao** - 2025-06-24 20:52

in the editor the fps doenst drop, even if i am moving or not. the terminal you say the debugger? right now nothing shows up.
but I remember that when I created 256 areas and the game crashed, an error message appeared that said "vk error out of host memory"

---

**tokisangames** - 2025-06-24 20:55

The [terminal or console](https://terrain3d.readthedocs.io/en/latest/docs/troubleshooting.html#using-the-console) you should always be using. 

> vk error out of host memory
Your video card ran out of vram. We can't do anything about that.

---

**_even_steven** - 2025-06-24 21:04

I'd export a build, quit the editor and run the build to rule a couple things out. a 4gb card is not going to cut it eventually.

---

**pedraopedrao** - 2025-06-24 21:05

I figured, but even so, it seems like the entire map runs all at once, I don't need that. Isn't there any way to make it run only the area I'm in, or something like that? That way the game gets really heavy. The map I had made before was supposed to be more or less the same size as the GTA San Andreas map. My PC runs GTA San Andreas, and I'm aware that the game's map doesn't load all at the same time, and the game disguises this with a fog. Isn't there a way to do something similar with Terrain3D? Maybe if I split the map into several different Terrain3Ds? My game has PS1 style graphics, it would be strange for it to be heavier than many games, as is already the case.

---

**tokisangames** - 2025-06-24 21:07

What about this? https://discord.com/channels/691957978680786944/1130291534802202735/1387172626211930233

---

**tokisangames** - 2025-06-24 21:08

You can't evenly compare an optimized, polished, finished game with an in development work environment.

---

**tokisangames** - 2025-06-24 21:10

We already know your system can run Terrain3D at 130-200fps without issue, since it does so in the editor. This is currently a Godot or driver issue, likely caused by running two games simultaneously.

---

**pedraopedrao** - 2025-06-24 21:45

it's an optimized, polished, finish game from 20 years ago bro. and i know that its an in development project and of course it will be some errors, but what we are trying to do here is literally trying to correct this errors and improve the game. theres only one game running and i updated my drivers today just to see if was that the error (it wanst) now i will try to split the game map and if dont work i will use blender or some shit like that. thx for trying to help anyway

---

**tokisangames** - 2025-06-24 21:48

I'm trying to help you, but you're not answering all of my questions.
You are running two games at once. The editor is a game.
Please answer my question I linked above and asked twice.

---

**_even_steven** - 2025-06-24 21:49

I promise you GTA was built on workstations with well in excess of the retail minimum memory requirements. This is true across the board, even in debug console units, they have more memory than the retail counterparts. Did you try running a build without the editor?

---

**tokisangames** - 2025-06-24 21:49

Testing an export of the demo as EvenSteven suggested is also a good test that you should do.

---

**_even_steven** - 2025-06-24 21:51

If the exported build runs ok, you know you're running into a vram issue.

---

**tokisangames** - 2025-06-24 21:52

He monitored his vram with taskmanager. Most likely it's that his GPU/driver cannot context switch between the two running games (editor and game). We've had a couple people with that issue.

---

**_even_steven** - 2025-06-24 21:59

Gotcha. I didn't scroll back far enough. I am still inclined to think he's just running out of vram, and OS is shuttling data in and out of GPU to try and satisfy everyone. I could be wrong, which is why I'd like to see how he fares on an exported build only. I am curious 🙂

---

**xtarsia** - 2025-06-24 22:05

did he increase physics tick rate to something much higher than 60 ?

---

**matryoshika** - 2025-06-24 22:05

So I recently had an issue with Godot 4.4.1 crashing _a lot_. After looking around for bug fixes, I saw an issue on the official godot github with the same thing happening to them, and followed Calinou's request to switch to Single Window mode 
Everything was fine, until I attempted to use Terrain3D again (it was working perfectly before) but every time I selected a tool and clicked on the scene, the toolbar would "pop" and disappear, and I was unable to do any further terrain sculpting
I've manually reset _every_ setting back to default with the ↩️, I went into the project folder and deleted settings, and I was back in multi window mode again. Still no luck. I deleted Terrain3D and removed it as plugin and reinstalled it, same behaviour, Terrain3D was still unusable.
I've now re-created the project, and Terrain3D is working again.
Is this a known issue? Was there any other fix I could have attempted or was a complete project recreation the only way to fix it?

---

**tokisangames** - 2025-06-24 22:17

4.4 is indeed less stable and slower than 4.3. I've had stability issues mostly with debugging. Hopefully 4.5 will be better than both.
I just switched to single window mode and back in the terrain3D demo and didn't see any issue. You can also explore this in the demo in a clean project.
What you described sounds like it was an issue with your godot project - something in your .godot or %appdata%/godot folders, not Terrain3D. As evidenced by nothing you did with Terrain3D fixed it, only by erasing your Godot settings was it fixed. There's surely something you could do to fix it, but it would take more investigation while experiencing the symptoms.

---

**matryoshika** - 2025-06-24 22:21

Gonna attempt 4.5 beta if I can, otherwise I'll just downgrade to 4.3 until 4.5 is out then, thanks for the swift reply

---

**tokisangames** - 2025-06-24 22:22

You'll need to use a different nightly build for 4.3.

---

**pedraopedrao** - 2025-06-25 02:25

I exported it and now the game runs smoothly. thx 👍

---

**sammich_games** - 2025-06-25 07:55

Is there an example of rendering just the heightmap to a shader? I've been reading through the docs and playing around with the minimum shader & debug views, but so far I haven't been able to draw the heightmap to a simple plane mesh, though I am able to render the normals. I'm hoping to use height data as a basis for an ocean shader that will scale wave size based on shore depth (with the shoreline at y=0)!

---

**tokisangames** - 2025-06-25 08:00

https://terrain3d.readthedocs.io/en/stable/docs/tips.html#using-the-generated-height-map-in-other-shaders

---

**sammich_games** - 2025-06-25 08:10

Yes, I did follow that to set the shader params with the correct sampler2DArray, but within the shader I'm not sure how to sample it correctly. If I have the heightmap param set, what are the minimal steps needed to sample it and draw it to a flat plane?

---

**tokisangames** - 2025-06-25 08:56

Pulled from our minimal shader. This is non-interpolated so it's banded. Pull out the full interpolation from the minimal shader, or the particle shader (`pos`).
```glsl
uniform highp sampler2DArray _height_maps : repeat_disable;
void fragment(){
  ...
  ALBEDO = vec3(texelFetch(_height_maps, get_index_coord(floor(uv) + offsets.xy, FRAGMENT_PASS), 0).r/500.);
}
```

---

**sammich_games** - 2025-06-25 09:23

Perfect, thanks for the help!

---

**ionide** - 2025-06-25 12:49

Need terrain3d help, am noob.
how can i hide this grid? kinda hard to sculpt with it.

📎 Attachment: image.png

---

**tokisangames** - 2025-06-25 13:06

Viewport Perspective menu / View gizmos

---

**ionide** - 2025-06-25 13:12

thanks, found it!

---

**rolker** - 2025-06-25 14:06

Hi, I've read the documentation but the terms are really way above my knowledge level so I want to know if I'm doing it right

I want to upload my height map to godot to make the terrain look like it, so I turned a png into exr, is this correct?

📎 Attachment: image.png

---

**ionide** - 2025-06-25 14:10

anyone know what is happening here?
im trying to add a new texture.
It get's added as ID 2, but the moment i add the albedo or normal it is overriding ID 0 and ID 1.

📎 Attachment: image.png

---

**tokisangames** - 2025-06-25 14:11

Height textures are the bumps on rocks.
Height map refers to the heights of your terrain: mountains and valleys. 
You've mixed them up. Read the Heightmap and Import documents to import heightmaps. Read Texture Prep to setup your height textures into your packed textures that you will paint on the ground.

---

**rolker** - 2025-06-25 14:12

Ahhh damnit that explains it

---

**ionide** - 2025-06-25 14:13

I fixed the texture problem, apparently the texture i tried to add wasnt a perfect square

---

**tokisangames** - 2025-06-25 14:13

Always run godot in a terminal and read the error messages. It tells you your texture formats or sizes are not the same. You can also find this on the troubleshooting document. Review the texture prep document for requirements.

---

**yzempx** - 2025-06-25 23:23

Hello guys, noob here.

Could anybody explain to me why the sides of the texture brush look so pixelated? I'm guessing it has to do with the resolution of the terrain, but I don't see any setting for that.

I tried to look at the documentation before asking, if it's there somewhere and I missed it I'm sorry :')

📎 Attachment: image.png

---

**tokisangames** - 2025-06-25 23:25

To blend you need textures with heights, and to use the Spray tool, and in an area where you've disabled the autoshader. Read the texture painting doc and watch the 2nd tutorial video. 
Nightly builds work better, but natural results can be achieve with the current version.

---

**yzempx** - 2025-06-25 23:26

OH right, thank you very much

---

**legacyfanum** - 2025-06-26 07:28

auto shader is tested with slope of the vertices and then is height/normal blended

---

**legacyfanum** - 2025-06-26 07:28

this gives unrealistic results

---

**legacyfanum** - 2025-06-26 07:29

it disallows fine details like snow or moss on rocks, it's a bare minimum in auto materials

---

**legacyfanum** - 2025-06-26 07:29

how can I modify the shader to do the following

---

**legacyfanum** - 2025-06-26 07:32

*(no text content)*

📎 Attachment: Screenshot_2025-06-26_at_10.31.09_AM.png

---

**legacyfanum** - 2025-06-26 07:32

for now it's like this

📎 Attachment: Screenshot_2025-06-26_at_10.31.45_AM.png

---

**tokisangames** - 2025-06-26 07:46

Nightly builds look like this. Upgrade, adjust the slope settings, or change the slope algorithm in the shader. It's only one line.

📎 Attachment: 07721FC6-AF46-4F1D-9F7C-92EF047EA113.png

---

**xtarsia** - 2025-06-26 10:06

This effect does already occur in nightly builds. However it is balanced with the manual blend value as well. As when a texture has 100% weight, then it won't be affected by the texture is the prior slot.

Managing height blend, bilinear blend, and world normal blend all at the same time was a bit tricky. Potentially could shift the world space normal influence up a bit more by bending the normals slightly.

Once displacement is in, it all ties together rather nicely anyways.

---

**xtarsia** - 2025-06-26 10:09

If you look at certain corner spots, you can see it already doing the same thing. It's just the textures aren't quite so extreme. Maybe I could factor in the normal map strength value before the world normal blend adjustment is obtained.

---

**xtarsia** - 2025-06-26 10:11

This here is from the world space normals.

📎 Attachment: tempFileForShare_20250626-111024.jpg

---

**legacyfanum** - 2025-06-26 10:11

yeah but you test with vertex normals

---

**legacyfanum** - 2025-06-26 10:11

not normal_maps

---

**xtarsia** - 2025-06-26 10:11

Nope

---

**legacyfanum** - 2025-06-26 10:12

it even happens before sampling normal map?

---

**legacyfanum** - 2025-06-26 10:12

idk if it's changed in nightly builds though

---

**xtarsia** - 2025-06-26 10:13

It happens during the material sampling. The auto shader just sets the blend value. But when 2 textures are blended, the 1st ID normal map is converted to world space and the resulting y component used to modify the blend value of the 2nd ID blend weight.

---

**legacyfanum** - 2025-06-26 10:15

yeah true. and autoshader disregards the vertices with slope value greater than autoslope. in this demonstration normal map blend should appear even on the vertices slopes of which is greater than the auto slope

---

**legacyfanum** - 2025-06-26 10:15

like in the cliffs

---

**legacyfanum** - 2025-06-26 10:15

a quick draw is incoming

---

**legacyfanum** - 2025-06-26 10:17

*(no text content)*

📎 Attachment: Screenshot_2025-06-26_at_1.17.44_PM.png

---

**legacyfanum** - 2025-06-26 10:18

but it should. because tangent space normal maps should contribute the geometry we're testing with for the final blend value.

---

**xtarsia** - 2025-06-26 10:20

I'll have a quick look when I get home, it may be possible to adjust things a bit.

---

**moooshroom0** - 2025-06-26 18:01

*(no text content)*

---

**moooshroom0** - 2025-06-26 18:01

do you think i could possibly attempt to make a in terrain 3d decal function? so like a section liked materials and meshes.

---

**tokisangames** - 2025-06-26 18:53

Make a what? I don't understand your question.

---

**legacyfanum** - 2025-06-26 20:30

i think i get what he means

---

**legacyfanum** - 2025-06-26 20:30

it's like a terrain stamp

---

**legacyfanum** - 2025-06-26 20:30

a brush that will paint materials, colors, height at the same time?

---

**coolmesto** - 2025-06-26 22:37

I am using the terrain 3d plugin for godot, but I keep getting this error when trying to modify terrain: “ERROR: core/variant/variant_utility.cpp:1098 - Terrain3DEditor#9861:_operate_map: Invalid brush image. Returning.” The error does not let me do anything to the terrain. It occurs after using the plugin on the fourth project reload (this includes the two times you have to reload the project when installing the plugin). So it works fine for a bit then breaks. Also reinstalling the plugin seems to fix the error for a bit but then it keeps coming back. I am using godot 4.4.1 on Windows 11 with terrain 3d 1.0 stable. If you need any more info to debug this just ask me!

---

**tokisangames** - 2025-06-26 23:06

Which brush are you using when you get the error?
Can you reproduce it in our demo?
Have you run chkdsk on your filesystem?
Is that the only error or regular message in your terminal window?

---

**coolmesto** - 2025-06-26 23:35

... There must have been something wrong with my install after redownloading it again (which I have done TWICE) and doing the setup it works? Sorry if I wasted any time, I must have the worst luck to get a bad install 2 times.

---

**tokisangames** - 2025-06-26 23:37

Again, check your file system. You may have a larger problem, not bad luck.

---

**coolmesto** - 2025-06-26 23:38

I did it was fine. That was the first thing I did.

---

**moooshroom0** - 2025-06-27 03:43

well i was thinking of trying to make another section to store decals matierals etc. ill probably just have to figure out how this actually works first.

---

**tokisangames** - 2025-06-27 06:30

What is a decal material? In Godot those are two separate things that don't work together.

---

**maarrine** - 2025-06-27 07:24

how do i set up autoshader? I enabled it but can't find where to set the textures

---

**maarrine** - 2025-06-27 07:24

rather, I'm just being blinded

---

**maarrine** - 2025-06-27 07:24

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-06-27 07:45

Uncheck debug views. Those are for debugging.
The demo is already setup for an autoshader, follow it. The settings are in the material.

---

**maarrine** - 2025-06-27 07:49

ty :D

---

**prehistoricknee** - 2025-06-27 13:54

hey

---

**prehistoricknee** - 2025-06-27 15:35

how to keep the terminal from closing when opening a project

---

**prehistoricknee** - 2025-06-27 15:35

in linux

---

**moooshroom0** - 2025-06-27 15:36

alrighty then, im going to do some more research into that then so i can figure out if im saying the correct thing.

---

**legacyfanum** - 2025-06-27 16:22

how expensive is it to have the uniform array types in the shader I added 10 more to it, each sized 32 floats 💀

---

**legacyfanum** - 2025-06-27 16:23

has it created any bandwidth bottleneck or something for you?

---

**tokisangames** - 2025-06-27 16:42

That is dependent upon your window manager. We don't control that. My terminal windows don't close when I run programs. I usually run them from a terminal in linux.

---

**xtarsia** - 2025-06-27 16:43

on desktop, not yet. but on mobile ive already run into problems with registers being full, with some reckless choices that needed fixing up. The full shader is riding on the edge of what mobile GPUs can handle atm.

---

**prehistoricknee** - 2025-06-27 16:43

i have a shjortcut that rns godot

---

**prehistoricknee** - 2025-06-27 16:43

```[Desktop Entry]
Name=Godot 4.x Engine
Comment=An open source game engine. Need i say more?
Exec=/home/ghost/DATA/GameDev/Software/Godot_v4.4.1-stable_linux.x86_64
Icon=/home/ghost/DATA/GameDev/Software/icon.png
Terminal=true
Type=Application
StartupNotify=true```

---

**xtarsia** - 2025-06-27 16:44

is there an _console file for linux?

---

**tokisangames** - 2025-06-27 16:46

Arrays are stored in VRAM, which means they're read across the bus instead of registers like regular variables. Potentially 500x slower than regular variables. See https://discord.com/channels/691957978680786944/1065519581013229578/1369685571215032472

---

**tokisangames** - 2025-06-27 16:47

This is specific to your desktop environment, whatever it is. We can't support it. Open a terminal window and run godot from the command line like normal linux programs are run. Look on forums for your specific os to learn how to open a terminal.

---

**legacyfanum** - 2025-06-27 18:28

what change has significantly reduced the hassle on mobile builds

---

**legacyfanum** - 2025-06-27 18:29

as is, can it run fine on new mobile phones

---

**xtarsia** - 2025-06-27 18:31

No release builds are affected, but recent changes to improve blending, had to be revised.

---

**legacyfanum** - 2025-06-27 18:32

if godot shader lang had allowed smaller data types it would be super useful

---

**legacyfanum** - 2025-06-27 18:35

i'm using full integers for special material types

---

**legacyfanum** - 2025-06-27 18:35

if I had i4 or something

---

**xtarsia** - 2025-06-27 18:35

Probably fine.

---

**legacyfanum** - 2025-06-27 18:41

any material property actually ...

---

**prehistoricknee** - 2025-06-27 19:50

why is the texture repeating so much?

---

**prehistoricknee** - 2025-06-27 19:51

*(no text content)*

📎 Attachment: Screenshot_From_2025-06-27_20-49-43.png

---

**xtarsia** - 2025-06-27 19:52

there are detiling options in the texture asset settings. You can also use dual scale for 1 texture, and make use of the macro variation feature

---

**prehistoricknee** - 2025-06-27 19:55

is it the texture i chose?

---

**prehistoricknee** - 2025-06-27 19:56

that contirbutes to this shite looking rock

---

**xtarsia** - 2025-06-27 19:56

a good texture can make all the difference.

---

**prehistoricknee** - 2025-06-27 20:03

this is another texture and it still looks flat

---

**prehistoricknee** - 2025-06-27 20:04

*(no text content)*

📎 Attachment: Screenshot_From_2025-06-27_21-02-53.png

---

**prehistoricknee** - 2025-06-27 20:04

maybe it needs a rough vertex brush'

---

**tokisangames** - 2025-06-27 20:05

What's the problem? Your normal map is reflecting light. You have ao/normal strength and roughness in the asset you can tweak. What are you expecting?

---

**prehistoricknee** - 2025-06-27 20:08

yes

---

**prehistoricknee** - 2025-06-27 20:08

the brush made it look like death stranding 2

---

**prehistoricknee** - 2025-06-27 20:08

the displacmeent map wasn't enough to give it a realistic look

---

**tokisangames** - 2025-06-27 20:11

You're expecting a raytraced result in a low resolution polygonal rendering environment. That's an unreasonable expectation.
However, displacement is coming later, and the fact that it's even an option for us is magic.

---

**prehistoricknee** - 2025-06-27 20:12

it's already great!

---

**prehistoricknee** - 2025-06-27 20:12

thanks to everyone working on the tool

---

**prehistoricknee** - 2025-06-27 20:12

this is AAA shite in godot

---

**prehistoricknee** - 2025-06-27 20:13

just a question

---

**prehistoricknee** - 2025-06-27 20:14

if i need to make roads, is it practical to use this tool ?

---

**prehistoricknee** - 2025-06-27 20:14

or should I implement my own extension to draw roads

---

**tokisangames** - 2025-06-27 20:16

Don't paint a road paint texture. Asphalt is fine. Or use godot-road-generator or make your own. Our height and slope brushes sculpt roads well.

---

**prehistoricknee** - 2025-06-27 20:16

how long did it take for this plugin to get to this?

---

**prehistoricknee** - 2025-06-27 20:17

it seems like a lot of work

---

**tokisangames** - 2025-06-27 20:17

2 years. Yes

---

**prehistoricknee** - 2025-06-27 20:17

woah

---

**prehistoricknee** - 2025-06-27 20:17

that's amazing

---

**prehistoricknee** - 2025-06-27 20:18

I am certainly mentioning this in my game

---

**maarrine** - 2025-06-28 03:24

Is there a way to have terrain vary in color while using the same textures?

---

**tokisangames** - 2025-06-28 07:06

Macrovariation in the material
Color map tool

---

**efeozyer** - 2025-06-28 07:08

Hello, is there any way to place tile textures based on the coordinates? I'm upgrading my C++ old game engine into Godot, and according to old game engine, tile textures placed by coordinates e.g
0, 0 -> tex_1
0, 1 -> tex_2

If I try to design terrain it will take plenty amount of time, instead I need to place textures based on the coordinates. e.g

📎 Attachment: tex_62.png

---

**maarrine** - 2025-06-28 07:09

so I'm guessing there's no way to do that for only one specific texture, for example? Any macrovariation will always be applied to every part of a Terrain?

---

**tokisangames** - 2025-06-28 07:10

Change the albedo tint in the texture asset.
Color map tool will filter by texture

---

**tokisangames** - 2025-06-28 07:11

You probably want to use the Godot built in tilemap tool

---

**efeozyer** - 2025-06-28 07:13

kinda yes

---

**maarrine** - 2025-06-28 07:13

I don't think I quite understand how to do that (sorry for repeated replies)

---

**tokisangames** - 2025-06-28 07:15

Two different things.
1. Right click a texture in the asset dock.
B. Click texture on the tool settings bar after clicking the color tool

---

**maarrine** - 2025-06-28 07:18

yeah i still don't really understand i think

---

**maarrine** - 2025-06-28 07:18

i assume asset dock is just the thing at the bottom so i get that

---

**maarrine** - 2025-06-28 07:18

i assume by color tool you mean this

📎 Attachment: image.png

---

**maarrine** - 2025-06-28 07:19

i don't think i follow afterwards

---

**tokisangames** - 2025-06-28 08:08

You asked how to color the terrain for one specific texture. I gave you a way to do it for the texture as a whole, or a way to paint it only on the texture.Click the texture filter, pick a color, and paint.

---

**maarrine** - 2025-06-28 08:19

figured it out now

---

**maarrine** - 2025-06-28 08:19

thanks

---

**.hisui** - 2025-06-28 10:03

Where is this "tools menu" I'm supposed to be seeing at the top of my viewport? Am I missing something?

📎 Attachment: image.png

---

**tokisangames** - 2025-06-28 10:11

Did you enable the plugin?

---

**tokisangames** - 2025-06-28 10:12

The menu at the top is called Terrain3D. Please refer me to the docs that say "tools menu". Unless it says "Terrain3D tools menu"?

---

**.hisui** - 2025-06-28 10:14

I disabled and re-enabled the plugin, and it appeared after a few seconds. /shrug

---

**.hisui** - 2025-06-28 10:15

And yes, it says "Terrain3D tools menu" everywhere I've seen it so far.

---

**tokisangames** - 2025-06-28 10:18

The UI docs define the toolbar on the left, the tool settings on the bottom of the viewport.
https://terrain3d.readthedocs.io/en/stable/docs/user_interface.html
It should list the Terrain3D menu on that page, but it's shown on Navigation.
https://terrain3d.readthedocs.io/en/stable/docs/navigation.html
Mention of 'tools' is out of date, that was removed. I'll look for it in the docs.

---

**.hisui** - 2025-06-28 10:20

The place I'm looking at it right now is in "Preparing Textures", where it describes how to channel pack textures "using the Pack Textures option in the Terrain3D Tools menu at the top of the viewport"
https://terrain3d.readthedocs.io/en/stable/docs/texture_prep.html#texture-files

---

**legacyfanum** - 2025-06-28 13:32

what do you think the problem is here? mipmaps?

📎 Attachment: Screenshot_2025-06-28_at_4.18.22_PM.png

---

**tokisangames** - 2025-06-28 14:31

Yes, lack of them on the normal/roughness texture, maybe albedo too

---

**arizoftgames** - 2025-06-28 18:02

I tried looking before asking, and didn't find anything;  so if this has been asked and answered somewhere, I apologize.  Does it look reasonable to assume that it's safe to perform the 1.1.0 upgrade with a work in progress, or would I be better advised to  hold off?

---

**vhsotter** - 2025-06-28 19:54

If you're using Git (and if you're not I STRONGLY recommend you do), just make a new branch with your project, upgrade, test things out thoroughly. If things look good, great. Merge that branch. If not, easy enough to revert.

---

**arizoftgames** - 2025-06-28 19:56

Makes sense...I just grudge the time if there is an issue, is all.  But then, given how good the product is to start with, there's not much room for complaint!

---

**tokisangames** - 2025-06-28 21:08

Right now 1.1.0-dev and 1.0.1 only differ by one commit or so, but it will vary more soon. If you are an experienced user the dev branch is fine, otherwise you should be using the stable version.

---

**arizoftgames** - 2025-06-28 21:11

I'll stick with the stable, then.  How about 1.0.0 to 1.0.1?  OK to upgrade in progress, you think?

---

**tokisangames** - 2025-06-28 22:43

Seamless upgrade. It's a maintenance release. No data changes.

---

**arizoftgames** - 2025-06-28 22:44

Thanks!  You and your team are magnificent!

---

**jamonholmgren** - 2025-06-30 04:37

Does anyone have a favorite how-to video on realistic ground (grass and more) textures? I am just terrible at it, and everything looks ugly.

Especially if it’s Godot, and even better if it’s about Terrain3D

(I have watched this one https://youtu.be/oV8c9alXVwU?si=oFhsZ1eYFUUSYLpg and it’s good, just wanting more info on making it look really good)

---

**tokisangames** - 2025-06-30 07:43

Regarding sourcing textures, you must experiment with a lot of textures to find good ones. You can't avoid or shortcut this work. I've replaced all of our textures multiple times, and I'm going to replace even more as I find better ones. The only way I've found to tell if they're good is by painting them on the ground. They typically all require adjustment, at least of color, maybe roughness to blend them.

---

**tokisangames** - 2025-06-30 07:44

To make things look good, you must have good textures, and good foliage assets, which also need experimentation and replacement. Then you need lots of practice. Not only of technique, but also composition. You need to train your eye. A video can't help with these. Fine art classes like drawing and photography can.

---

**tokisangames** - 2025-06-30 07:45

https://discord.com/channels/691957978680786944/841475566762590248/1388241976935321670 This is not just placing things randomly. Each piece is manually placed by a landscape designer IRL. And he spends a lot of time working on it. It's as time consuming as programming or any other job.

---

**tokisangames** - 2025-06-30 08:14

And we're not finished yet. This will get better as we improve or replace our lighting, textures, assets, materials, blending. Even these areas need polish.

---

**foyezes** - 2025-06-30 08:24

does anyone know how I can merge two grayscale images into a single channel? like one image will be in the 0-0.5 range, the other in the 0.5-1.0 range

---

**tokisangames** - 2025-06-30 08:49

You can do it easily in a handful of lines of code in GDScript using the Image class.

---

**foyezes** - 2025-06-30 08:49

Do you have any links for that?

---

**tokisangames** - 2025-06-30 08:51

Look at the Godot docs website for Image, or pull up the API in Godot. Basic programming task. For loop, get_pixel, set_pixel. This isn't a terrain question. Better asked in <#858020926096146484>

---

**jamonholmgren** - 2025-06-30 09:11

Yeah, this makes sense. It's compounded by how vast my terrain is. Of course, you mostly see it from 100-200 feet in the air, and often at night, so that helps, but I've been working on it off and on for months and months, and am looking for more techniques. Appreciate the help.

📎 Attachment: CleanShot_2025-06-30_at_02.08.082x.png

---

**tokisangames** - 2025-06-30 10:11

What I would do in your case is start a collection of relevant reference photos. Then make your terrain look exactly like the photos. Then later look at them again and improve your work, now that your eye has improved. Then do it again even later. We use a lot of reference photos. This example looks like you don't, and are working from a false mental image of what the world looks like.

---

**hornetdc** - 2025-06-30 11:03

Hi everyone. I am trying to recreate an area of about 30*30 km from satelite DEM. It doesn't need to be super precise as the elevation difference is ~100m at most, but it's important for me to get the scale correct, so if I create a 500m rectangle mesh it must match the map scale.
What resolution of an input image do I need?

---

**hornetdc** - 2025-06-30 11:04

I think my use case is similar to <@514132374901096461>'s

---

**tokisangames** - 2025-06-30 11:29

Read the Heightmap document which describes at length how to get your scale correct.

---

**hornetdc** - 2025-06-30 11:34

"Terrain3D generally expects a ratio of 1px = 1m lateral space", this bit?

---

**hornetdc** - 2025-06-30 11:37

That's lot of px's 🤔

---

**tokisangames** - 2025-06-30 11:38

What do you want to know about it? That is normal for a realtime rendering environment.

---

**tokisangames** - 2025-06-30 11:38

But you aren't limited to that, hence 'generally'. Change vertex_spacing.

---

**hornetdc** - 2025-06-30 11:39

I was hoping to use smaller file, I'll look into vertex_spacing, ty

---

**hornetdc** - 2025-06-30 12:16

Image size is a 7168px square

ERROR: core/variant/variant_utility.cpp:1098 - Terrain3DData#1986:import_images:886: (7168, 7168) image will not fit at (0.0, 0.0, 0.0). Try (-14336, -14336) to center

---

**hornetdc** - 2025-06-30 12:18

I also tried -3584 to center, but it still demands -14336 which I can't input in input_position

---

**tokisangames** - 2025-06-30 12:29

Try increase your region size. Max dimensions are 32*region_size which should fit that, but the importer wouldn't ask for -14k unless you changed something else. Maybe reset vertex_spacing and increase it after import.

---

**berilli** - 2025-06-30 12:52

Hello! Can vertex spacing be set less then 0,25? I want denser mesh at LOD0

---

**tokisangames** - 2025-06-30 13:10

I'm sure you don't want that in a realtime rendering environment. But I'll listen to your reasons why.
Displacement is coming and will provide negative lods.
You could lift the restriction by building from source.

---

**legacyfanum** - 2025-06-30 13:11

does godot not allow to get the camera position in shaders , and that's the reason why you pass the _camera_pos?

---

**tokisangames** - 2025-06-30 13:13

It does, but we are moving away from camera tracking. There was another reason that had to do with snapping.

---

**xtarsia** - 2025-06-30 13:53

The shader built in would alter to the shadow camera position, which would be at the light source. This meant that vertices would be at different positions between the shadow pass, and render passes.

Passing the tracked camera (and soon object position) solves that.

---

**xtarsia** - 2025-06-30 13:53

The miss match in vertex positions created some bad shadow artifacts.

---

**legacyfanum** - 2025-06-30 13:55

this is only true for moving meshes, yeah?

---

**legacyfanum** - 2025-06-30 13:56

because I was writing a billboard shader and had the same problem, someone suggested me pass the camera pos to solve that and I remember finding a solution for this with the built-in matrices. Couldn't pull it up now but...

---

**xtarsia** - 2025-06-30 14:00

The built in matrices change as well.

---

**thefatmike** - 2025-06-30 17:19

where do i find the textures for terrtain 3d?

---

**tokisangames** - 2025-06-30 17:27

Look at the UI document which shows you where the UI panels are. Also make sure you've installed it properly according to the install doc, including enabling the plugin.

---

**aldocd4** - 2025-06-30 21:14

Hello, I just upgraded to latest terrain3D 1.0.1 (from 1.0.0)  and maybe I did something wrong when creating my terrains before, but the spray/painting tools seems to be a little bit random for me with this version. I can pick any brush the result will always be the same.

Also, the blending between textures was smoother before and I'm unable to recreate this style (I tried to play with blend sharpness but doesn't really fix it). 

Do I need to rework my textures?

---

**aldocd4** - 2025-06-30 21:15

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-06-30 21:23

Blending is much more improved recently, correcting an issue in 1.0.0. Your technique isn't the process we recommend. Read the texture painting doc. Use the Spray tool. Start with a lower value. You should have a height channel in your textures and can generate one if you don't have one.

---

**aldocd4** - 2025-06-30 21:24

Ok thanks. Gonna read everything again from scatch and rework my terrains

---

**aldocd4** - 2025-06-30 22:28

Ok seems like something went wrong when upgrading to 1.0.1. Removing the textures and re-adding them fixed all my issues.  Now the spray/paint tools work correctly

---

**jabbathefrukt** - 2025-07-01 01:47

I know its been answered before, but is there no way to use motion blur and Terrain3D together?
Is this something that might get fixed in future Godot versions or future Terrain3D versions?

---

**tokisangames** - 2025-07-01 06:52

Unless you have the ability to reset motion vectors when the mesh moves, it will jitter.

---

**jabbathefrukt** - 2025-07-01 09:07

On the terrain's mesh you mean?

---

**tokisangames** - 2025-07-01 09:44

The motion vectors are in the renderer, your shader uses those motion vectors. Our terrain mesh is moving. We reset motion vectors for physics interpolation and in 4.5, TAA/FSR because of facilities built into the engine to do so. Unless there is an ability to reset the shader's use of motion vectors when the terrain mesh moves, it will jitter under motion blur. Perhaps your motion blur shader will take a clue from the reset done by 4.5 TAA/FSR, perhaps not. We can't do anything about it without that facility.

---

**jabbathefrukt** - 2025-07-01 09:46

I understand. Thx for the reply!

---

**efeozyer** - 2025-07-01 13:07

How can I disable randomizer of the texture brush?

---

**shadowdragon_86** - 2025-07-01 13:13

Do you mean how the brush spins while painting? If so, in the advanced tool settings on the asset dock (three dots button on the right) turn off Jitter (reduce to 0).

---

**jamonholmgren** - 2025-07-01 15:48

This makes sense. thanks

---

**antracitrom** - 2025-07-01 22:44

Hey guys, I just started using Terrain3d and run into some issues.
I installed it via the assetlib added into my scene and im missing the "terrain3d tools" button at the top and the sidebar on the left.
Im using 4.4.1 stable for reference.

---

**vhsotter** - 2025-07-02 00:57

Have you enabled the addon in project settings and restarted your project a couple times?

---

**aldebaran9487** - 2025-07-02 11:40

Hey everyone ! I was testing the foliage placement with LOD, it's mostly nice, but i have noticed a weird behaviour;
When the player move to or from an object direction, sometimes, there is a step with no displayed object between two LOD.
I have not see that with the exemple LOD throught, so it must be my mistake.

---

**aldebaran9487** - 2025-07-02 11:44

*(no text content)*

📎 Attachment: Enregistrement_decran_20250702_134309.webm

---

**aldebaran9487** - 2025-07-02 11:44

You can see the trees disappearing between LODs

---

**aldebaran9487** - 2025-07-02 11:45

Here my mesh conf in Terrain3D

📎 Attachment: image.png

---

**aldebaran9487** - 2025-07-02 11:46

The mesh scene (i have try to follow the doc)

📎 Attachment: image.png

---

**tokisangames** - 2025-07-02 12:02

What versions are you using?

---

**aldebaran9487** - 2025-07-02 12:32

Ohhh. I think that can be the root cause, i was testing the Xtarsia displacement branch yesterday, and forgot to replace the plugin.

---

**aldebaran9487** - 2025-07-02 12:32

I will retest the project with the last released plugin, and see if it's linked or not

---

**aldebaran9487** - 2025-07-02 12:36

I have do that, i switched to the 1.0.1 version, the pb stay

---

**aldebaran9487** - 2025-07-02 12:37

I can share the entire project if needed, it's the demo + some trees

---

**aldebaran9487** - 2025-07-02 12:39

Also, i see the pb in godot 4.4 stable and 4.5 dev5, and also on the latest 4.5 beta 2

---

**aldebaran9487** - 2025-07-02 12:43

Oh, and it's maybe not clear in the video because i'm moving, but if i stop moving when the object disapear, it stay invisible, it's not some sort of delay.

---

**aldebaran9487** - 2025-07-02 12:48

Ok, i have try to replace my second LOD mesh (it's an impostor mesh); the pb don't show, so it must be linked to my impostor mesh

---

**xtarsia** - 2025-07-02 13:17

I think the billboards need the same AABB as the lower LOD meshes to ensure no gaps when transitioning

---

**aldebaran9487** - 2025-07-02 13:19

I'm out of guess; i have try to replace my impostor by a basic billboard; but i have the same pb;

---

**aldebaran9487** - 2025-07-02 13:19

Oh, interesting, and how could i do that, i need to calculate it in a script ?

---

**aldebaran9487** - 2025-07-02 13:20

Or it can be fixed value maybe

---

**xtarsia** - 2025-07-02 13:20

unsure, i just thought about it now. when the mmi AABB is built, it uses the limit of all mesh AABB contained by it.

---

**xtarsia** - 2025-07-02 13:21

but of the AABB of 2 different LODS are different (specifcially on 1 axis in the case of billboards) then the total mmi AABB for the shorter side will also be smaller.

---

**aldebaran9487** - 2025-07-02 13:22

Hum, it's not a wrong guess i think, since my billboard plane is 0 depth, that could explain the step

---

**aldebaran9487** - 2025-07-02 13:22

I will dig in it thanks !

---

**aldebaran9487** - 2025-07-02 13:28

The impostor plugin i use already set custom AABB; i have also try to set them.

📎 Attachment: image.png

---

**aldebaran9487** - 2025-07-02 13:30

So, there is no diff for me; but maybe it is in the instancer code that the value is not used ?
I mean, some of you must be using billboard so if there is a pb on this area i think someone should have see it before; but maybe not ?

---

**aldebaran9487** - 2025-07-02 13:41

Hum, how can i see the debug output of the LOG call of the extension ? Should i rebuild the extension in debug or set and env var or something like that ?

---

**xtarsia** - 2025-07-02 13:46

im just testing now (tho i have go pick kids up in 5mins!)

---

**aldebaran9487** - 2025-07-02 13:49

Oh oh, that's a short testing session ^^

---

**xtarsia** - 2025-07-02 13:50

https://github.com/Xtarsia/Terrain3D/commit/94702f66cbb26826ca92064046a1eb5fc89fe75d

---

**aldebaran9487** - 2025-07-02 13:50

Ok, did you really made a fix in this short time ?

---

**aldebaran9487** - 2025-07-02 13:51

It's... Ok, i will try it, thank you sire, you rocks

---

**xtarsia** - 2025-07-02 13:51

maybe something i missed, super quickly put together. aand time to go! yw!

---

**aldebaran9487** - 2025-07-02 13:51

Thank again, go keep your littles humans 😉

---

**aldebaran9487** - 2025-07-02 14:06

It's working !

📎 Attachment: Enregistrement_decran_20250702_160503.webm

---

**aldebaran9487** - 2025-07-02 14:06

Thank you Xtarsia !

---

**tokisangames** - 2025-07-02 14:15

MMIs and billboards continue to have problems. If this works we could remove the gap fixes. How about storing the AABB in the mesh asset instead, then we can always set it.

---

**xtarsia** - 2025-07-02 14:17

Actually we could use a fixed AABB per cell, that is just cell size x cell size x mesh height.

---

**xtarsia** - 2025-07-02 14:19

Tho we need to know min and max height

---

**xtarsia** - 2025-07-02 14:19

The current quick fix i did does the job I think. The aabb is accumulated when adding transforms regardless.

---

**aldebaran9487** - 2025-07-02 15:03

For what my advice worth, it works pretty well on my assets and usecase.

---

**tmtoast** - 2025-07-02 18:01

Hey! I'm sorry if this is a really obvious question, I'm just starting to get into 3D modeling and blender, most of our game is inside buildings so I didn't think that Terrain3D seemed like a plugin that I would benefit from much. I've seen in tutorials and demos amazing examples of painting cobblestone paths and fading those into the existing texture which is making me wonder if this could be great for us. I am looking for a tool that I can use to paint UV maps, textures, and patterns on assets I am importing into Godot such as floors, walls, doors. I'm hoping to get a result where I can add cracks, moss, dirt or dust, and just add some randomness that makes it feel more lived in. 

Is this something that this plugin could help me with or do you know of another plugin/method that could help me get closer to this?

---

**tokisangames** - 2025-07-02 18:26

Terrain3D is a vertex painter for terrain. You want a vertex painter for general meshes. You can look for vpainter, but GD4's design isn't setup well for such a plugin at this time.

---

**tmtoast** - 2025-07-02 18:41

Gotcha that's good to know thank you, it's seriously an amazing plugin and I wish it fit our use case more, it seems so crazy powerful.

It also seems the decal nodes might be a good usecase for us, might be an easier solution to use for now while we try and find something like what you suggested.

---

**tmtoast** - 2025-07-02 18:42

More generalyl, do vertex painters edit the texture maps of the objects that you are painting them on, or do they create additional textures that like overlay on top of them? I struggle to understand how these tools actually work to engage with existing textures

---

**tmtoast** - 2025-07-02 18:50

Ah it looks like we had one years ago but it was broken by Godot 4 and never updated 😦 https://github.com/tomankirilov/VPainter

I'll keep looking, but this looks like exactly what I would have wanted for painting objects

---

**tokisangames** - 2025-07-02 19:12

There's another, but again gd4 isn't setup well for vertex painting, which edits the vertices of the mesh, not textures. Decals are a better choice for now.

---

**tmtoast** - 2025-07-02 19:15

What changed from Godot 3 to 4 that caused it to be worse for this?

---

**funofabot** - 2025-07-02 20:35

Before I make an attempt at creating a texturing system for this, I want to ask if there is already a texturing system for this terrain system (beyond auto shader)? 
For clarity, a texturing system with biomes/masks and filters such as noise and concavity. 

I also wanted to say that this is an amazing addon, and thanks to everyone who created it.

---

**tokisangames** - 2025-07-02 20:38

Was an issue in 3 as well, but worse in 4. A bit of a complicated history with how they handle mesh inheritance. Research github issues if interested.

---

**tokisangames** - 2025-07-02 20:41

The texturing system is hand painting or the slope based autoshader.
If you want to make a biome system, read this first. https://github.com/TokisanGames/Terrain3D/discussions/656
And the biome section here
https://github.com/TokisanGames/Terrain3D/issues/43

---

**rogerdv** - 2025-07-02 21:11

How can I make navigation baking exclude trees from the navmesh?

---

**tokisangames** - 2025-07-02 21:40

Change the settings of your navmesh to avoid mesh instances.
https://terrain3d.readthedocs.io/en/latest/docs/navigation.html#navigation-won-t-generate-where-foliage-instances-have-been-placed

---

**antracitrom** - 2025-07-02 22:33

💀 yup it wasnt enable thx (i just loaded it to mess around and i see nothing happens outofthebox) oopsie

---

**latintiro** - 2025-07-03 17:01

Heyy, i was wondering if procedural infinite world generation is possible with this?

---

**tokisangames** - 2025-07-03 17:27

Not with collision. Visual only in the shader is done

---

**latintiro** - 2025-07-03 17:27

okay thanks

---

**latintiro** - 2025-07-03 18:06

will that be a feature coming soon>

---

**latintiro** - 2025-07-03 18:06

?

---

**tokisangames** - 2025-07-03 19:19

Not soon. Once we have a GPU workflow, we'll have the proper infrastructure for noise based shaders that feed data to our collision generator.

---

**rogerdv** - 2025-07-03 23:42

I think i have the opposite problem. I can walk throug trees and I want to avoid that

---

**tokisangames** - 2025-07-04 00:05

Yes, that linked to the setting in Godot that changes how it generates. Read the Godot docs for what that option does and configure it to avoid your meshes on generation.

---

**rogerdv** - 2025-07-04 00:25

Ah, was looking in terrain config

---

**rogerdv** - 2025-07-04 00:26

Problem is that I generate navmesh from static bodies marked with an specific group

---

**legacyfanum** - 2025-07-04 13:17

how about MAIN_CAM_INV_VIEW_MATRIX

---

**legacyfanum** - 2025-07-04 13:20

```    vec3 camera_pos = (MAIN_CAM_INV_VIEW_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
```

---

**xtarsia** - 2025-07-04 13:21

that must be new, and probably got added because of the shadow issues, it may well work.

However for the terrain, we need a camera position that only updates as fast as the physics process, so that there wont be a "threshold break" between the snaping and the camera.

the geomorph, and soon displacement buffer, can suffer from small artifacts at frame rates greater than the physics (snap update) tick rate if a real time position is used.

---

**xtarsia** - 2025-07-04 13:23

```vec3 camera_pos = MAIN_CAM_INV_VIEW_MATRIX[3].xyz``` would be the same thing without invoking a matrix multiply

---

**legacyfanum** - 2025-07-04 13:23

better.

---

**legacyfanum** - 2025-07-04 13:24

idk about those stuff, this way you can also calculate length at vertex stage maybe 2-3 fps gain

---

**legacyfanum** - 2025-07-04 13:24

idk

---

**tokisangames** - 2025-07-04 13:48

Also in a pending PR, we're no longer tracking camera position. We're tracking the position of a target node (which may or may not be the camera).

---

**xtarsia** - 2025-07-04 14:10

Thinking about it, that should resolve the orthographic tracking issue too - tracking the player makes much more sense in that case.

---

**legacyfanum** - 2025-07-04 14:21

hardly ever would someone want to deal with setting the target node for a shader

---

**legacyfanum** - 2025-07-04 14:21

base reference should always be the camera

---

**legacyfanum** - 2025-07-04 14:21

thats how you perceive the world

---

**legacyfanum** - 2025-07-04 14:21

but idk thats me

---

**tokisangames** - 2025-07-04 16:03

3/4ths top down and third person games can both benefit by having lod0 centered on the player.  Even in first person, half of lod0 is wasted behind the camera. It would look better being positioned in front of the camera. Only 90 degree top down is best with lod0 right under the camera. Every other style is best positioned where the camera is looking at the ground.

---

**prehistoricknee** - 2025-07-04 21:14

Is there a way to use parallax mapping with terrain 3x

---

**prehistoricknee** - 2025-07-04 21:15

?

---

**tokisangames** - 2025-07-04 21:17

There is a pending PR for displacement.

---

**prehistoricknee** - 2025-07-04 21:28

I saw it

---

**prehistoricknee** - 2025-07-04 21:28

But is there like a hack to have parallax mapping in my textures

---

**xtarsia** - 2025-07-04 21:30

you can use the override shader, but having attempted to get some form of it working in many different ways, it just isnt performant, or image stable (of cutting corners for performance)

since the textures can be sampled upto 8x as a baseline.

---

**xtarsia** - 2025-07-04 21:30

if you pack the height texture - that the parallax mapping would use, then displacement will handle it.

---

**xtarsia** - 2025-07-04 21:31

the only exception i'd say would be an ice texture, which you could include a custom snippet that runs only for that texture ID

---

**xtarsia** - 2025-07-04 21:32

It would probably be much better to cut a hole, and use a custom mesh & shader for the ice tho

---

**xtarsia** - 2025-07-04 21:35

As for what displacement looks like: https://discord.com/channels/691957978680786944/1065519581013229578/1388295601107767326

---

**xtarsia** - 2025-07-04 21:36

Nightime, First person up close, with a torch to really show off the shadows etc. Parallax mapping couldn't do those long shadows at all.

---

**prehistoricknee** - 2025-07-04 21:43

That's exactly what I want

---

**prehistoricknee** - 2025-07-04 21:43

Are you implementing it in terrain3d?

---

**xtarsia** - 2025-07-04 21:43

As Cory said, there is a PR being worked on right now 🙂

---

**prehistoricknee** - 2025-07-04 21:44

So how long will it take?

---

**xtarsia** - 2025-07-04 21:44

90% done, the other 90% to go..

---

**prehistoricknee** - 2025-07-04 21:44

https://tenor.com/view/acoustic-dumb-funny-cat-cat-cat-acoustic-gif-8219440572128691401

---

**prehistoricknee** - 2025-07-04 21:44

Amazing

---

**prehistoricknee** - 2025-07-04 21:45

How can I test?

---

**prehistoricknee** - 2025-07-04 21:46

https://github.com/TokisanGames/Terrain3D/issues/175

---

**prehistoricknee** - 2025-07-04 21:46

Is this a pr ?

---

**xtarsia** - 2025-07-04 21:46

Can download the Artifact from here: https://github.com/TokisanGames/Terrain3D/actions/runs/16080416038

---

**prehistoricknee** - 2025-07-04 21:46

Nayce

---

**prehistoricknee** - 2025-07-04 21:47

I can't wait for the performance drop

---

**prehistoricknee** - 2025-07-04 21:47

It will look amaziiiiinngg

---

**prehistoricknee** - 2025-07-04 21:47

*(no text content)*

📎 Attachment: voice-message.ogg

---

**xtarsia** - 2025-07-04 21:47

anyways, best not to spam

---

**prehistoricknee** - 2025-07-04 21:48

Yes sir

---

**sander5158** - 2025-07-04 23:27

Can terrain3d import an existing mesh or heightmap? I have my terrain in Blender already, but would like to use this plugin for texture painting (if possible)

---

**prehistoricknee** - 2025-07-04 23:41

I think it's mentioned somewhere in the documentation that you can use a heughtmap

---

**tokisangames** - 2025-07-05 00:06

Read the heightmap and import documents.

---

**tokisangames** - 2025-07-05 00:07

Mesh, no. Convert your mesh to a heightmap.

---

**sander5158** - 2025-07-05 00:07

aight

---

**prehistoricknee** - 2025-07-05 00:26

<@188054719481118720> by the way that is parallax occlusion mapping not displacement mapping right?

---

**xtarsia** - 2025-07-05 04:24

It's displacement of a subdivided mesh.

---

**fizzyted** - 2025-07-05 05:06

Hey folks, first off thanks so much for this plugin, it rules!

Then, a sort of quick question. I am making a game with many regions/levels. The first level I made is ~500m x 1km in Terrain3D. The terrain part is quite performant and working well. The rest of it not so much, but that's a me problem.

I'm curious for a quick take without a clear answer. Would you prefer to develop the other ~6 regions of similar size all on one big Terrain3D node, or would you split it up into one node per level? I'm torn.

I am not a great programmer, so I'm not planning to do any streaming or fancy stuff like that. I will probably load everything for each level in transition zones. I'm just wondering if I should be loading a new terrain node as part of the new level scene, or just load the level scene on top of a shared terrain node.

My gut says that the terrain part is actually pretty performant, so I could just use one big terrain node. The advantage to that is I won't have to fake distant terrain in the cases where you can see other levels.

Anyway, if you have off the cuff opinions, please share. If this is not enough info to make a call, fair enough. Thanks!

---

**legacyfanum** - 2025-07-05 06:17

do you have any examples doing exactly that beautifully and in a systematic way, and not wasting code and performance

---

**legacyfanum** - 2025-07-05 06:19

because I'm about to copy the get_material function and check the ID right away and run that instead

---

**legacyfanum** - 2025-07-05 06:20

but then the blending/ far scaling would be broken

---

**legacyfanum** - 2025-07-05 06:20

the code in the get_material is very tangled to save performance

---

**tokisangames** - 2025-07-05 07:31

Depends on what you want and if you want loading screens. We are doing both, some areas like deep caves are behind loading screens with separate Terrain3D nodes. Half of the game is in one scene with a large map.

---

**fizzyted** - 2025-07-05 18:20

Thanks <@455610038350774273> . Seeing what you are up to, I think I will try one big terrain node and see how that goes.

---

**glossydon** - 2025-07-05 19:27

Not sure if this has been mentioned anywhere, but Terrain3D seems to work just fine in the 4.5 betas.

---

**tokisangames** - 2025-07-05 19:30

Thanks. Not supported until the RCs but good to know there aren't any current problems.

---

**mechanicalsanity** - 2025-07-06 21:01

hi! I want to create an infinite runtime terrain system. Ive done like 50 different implementations in C++, and they all were nowhere near performant and feature rich enough, so Im checking this out. 

I know this system was not designed with infinite runtime generation in mind, but I do have an idea where I update the heightmap texture in chunks as the player moves. My question is, how feasible is implementing that? 
Essentially hotswapping heightmaps

---

**mechanicalsanity** - 2025-07-06 21:11

I do not mind modifying the source code to accomodate, I just wanna know if its practical

---

**aldebaran9487** - 2025-07-06 21:12

if your okay to move in an infinite terrain where "infinite" mean moving on the same heightmap uv infinitely (it's close enought for me); you can check devmar videos.
https://www.youtube.com/watch?v=rcsIMlet7Fw

---

**mechanicalsanity** - 2025-07-06 21:14

This was not what I was referring to, I meant computing the heightmaps at runtime

---

**tokisangames** - 2025-07-06 22:57

We currently have a maximum world space for regions of 65.5km x 65.5km. So you could generate data, but you won't be able to place it with collision. Without collision, you can generate your world in a shader as we do outside of regions.

---

**mechanicalsanity** - 2025-07-06 23:00

Hmmmm, does the plugin allow heightmaps to be in pieces?

---

**mechanicalsanity** - 2025-07-06 23:01

Or does it have to be one big texture?

---

**mechanicalsanity** - 2025-07-06 23:02

I am still a bit confused on how this system works

---

**tokisangames** - 2025-07-06 23:04

Our heightmaps are in separate region maps. You should read the docs, starting with the introduction that explains the system.

---

**mechanicalsanity** - 2025-07-06 23:07

That's the part that confused me. If I can define my own regions, could I create a cache system that destroys the furthest region data, and then create new regions?
Can I manually generate my own custom regions from scratch?

---

**tokisangames** - 2025-07-06 23:09

You can create and destroy any regions on the fly. However we have a maximum bounds of 65.5km. Which is insanely big and very, very few game studios have the capacity to fill such an area with content.

---

**mechanicalsanity** - 2025-07-06 23:09

I just wanted to test if infinite terrain was possible in theory

---

**mechanicalsanity** - 2025-07-06 23:10

What was the reasoning behind the current limits? Is it the maximum of the gpu buffers or push constants?

---

**tokisangames** - 2025-07-06 23:17

As I said you can make an infinite terrain in a shader without collision. This is already enabled in our demo.
Current limitations of having a 1024 region size texture array. We need region streaming implemented to be able to lift it.

---

**mechanicalsanity** - 2025-07-06 23:18

Oh, the collision is the issue... in that case, not a problem

---

**mechanicalsanity** - 2025-07-06 23:19

My biggest issue with my own generation system was lod seam stitching, as fixing on the cpu is insanely expensive. Idk how you guys did it, but the circular lod meshing is genius, I still have no idea how it works.

---

**mechanicalsanity** - 2025-07-07 02:04

Is it possible to use this extension in a C++ module and not extension?

---

**tokisangames** - 2025-07-07 06:55

With minor modification. Others have done so

---

**mechanicalsanity** - 2025-07-07 14:15

thanks!

---

**zaytik** - 2025-07-07 15:24

HI I'm having trouble with stuff falling through the terrain

📎 Attachment: movie_2.mp4

---

**zaytik** - 2025-07-07 15:25

here are my collision settings on the terrain

---

**zaytik** - 2025-07-07 15:25

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-07-07 15:53

Not stuff. Very small, thin collision shapes. Your expectations of how physics engines work is off. They aren't magic. If you make your shapes too small or thin you make it exceedingly difficult for the physics system to calculate collision. This isn't a terrain issue. Read the Godot docs on physics, increase the AABBs of your physics bodies, change the physics calculation settings, use Jolt, have a terrain.get_height() fallback on characters.

---

**zaytik** - 2025-07-07 15:53

damn yeah I thought the thin shape was the issue

---

**zaytik** - 2025-07-07 15:54

it's supposed to be a piece of paper so yeah

---

**zaytik** - 2025-07-07 15:54

but I don't actually use jolts so I'll try it

---

**zaytik** - 2025-07-07 16:16

or I can find myself a solution that doesn't use physics :)

📎 Attachment: movie_3.mp4

---

**zaytik** - 2025-07-07 16:17

probably more performant than using physics anyways

---

**zaytik** - 2025-07-07 16:17

and my game does not need it so yeah

---

**xtarsia** - 2025-07-07 16:30

you could still lerp between the start and end points with an ease in tween over a very short time, like 0.2s (adjust as needed)

---

**xtarsia** - 2025-07-07 16:32

even quickly calculate a curve etc (tho thats probably something to look at later, rather than getting distracted early!)

---

**zaytik** - 2025-07-07 16:36

yeah looks better

📎 Attachment: movie_4.mp4

---

**zaytik** - 2025-07-07 16:37

this is supposed to be a photography game but I haven't really gotten around to doing any of the photography stuff lol

---

**xtarsia** - 2025-07-07 16:37

looks super nice!

---

**mechanicalsanity** - 2025-07-07 20:08

Good news, I am making good progress on creating a wrapper for gdextension, allow for direct compilation with modules.
The best part is that this will require very very minimal change on the part of terrain3d, only a few lines in the constants header file

---

**tokisangames** - 2025-07-07 21:02

I'm sure you already found this.
https://discord.com/channels/691957978680786944/1065519581013229578/1302573226505011220

---

**mechanicalsanity** - 2025-07-07 21:02

Oh I have, but that is not what I had in mind at all

---

**mechanicalsanity** - 2025-07-07 21:03

this wrapper allows for total integration

---

**mechanicalsanity** - 2025-07-07 21:03

it directly connects to the source code headers

---

**mechanicalsanity** - 2025-07-07 21:03

its as if you coded this as a module all along, and you also get all of the benefits that entails

---

**mechanicalsanity** - 2025-07-07 21:05

And it should be really easy to update if gdextension or terrain3d updates. 
Or in case of emergencies, easy to abandon

---

**spectralkorn** - 2025-07-08 17:07

where to pack channels?

---

**shadowdragon_86** - 2025-07-08 17:08

The tool can be found in the Terrain3D menu at the top of the viewport

---

**spectralkorn** - 2025-07-08 17:08

oh, i see, thanks

---

**mechanicalsanity** - 2025-07-08 20:04

Okay, so I think Im almost done, the only problem is Strings. Unlike the other extension classes, which are virutally identical to their source code counterparts, String might as well be a completely different thing.

---

**chiptop** - 2025-07-09 06:56

Hi there!
I'm following along with the documentation and have gotten stuck at getting Textures imported. I'll use one as an example, but I'm having trouble getting any of these to work.
I have 2 1024x1024 .pngs that I have downloaded from PolyHaven (https://polyhaven.com/a/rusty_metal_03), one is the diff (for albedo) and one is the normal map (for height).
In the instructions for packing using the built-in packer, it says:
Click Pack Textures As... and save the resulting PNG **files** to disk.
...but it only saves one file? So I'm not sure if I'm missing something where it should be outputting 2 files.
I've tried is using the GIMP method as well:
Also recommended is to export directly into your Godot project folder. Then drag the **files** from the FileSystem panel into the appropriate texture slots.
Again, I find where I can export as described, but it only outputs 1 file. Am I missing something foundational?

---

**tokisangames** - 2025-07-09 08:29

Diffuse for albedo, displacement for height.
Opengl Normal map goes into the bottom half of the packer, it is NOT height. Roughness goes with it.
Use 4 textures to get two packed files.

---

**chiptop** - 2025-07-09 09:07

Thank you for the quick response - I'm sure it must get tiring answering noob questions all the time, but I appreciate you taking the time

---

**erikbelhage** - 2025-07-09 11:22

Hey

I tried to run the demo scene in compability mode.
I get these errors

📎 Attachment: Screenshot_2025-07-09_132045.png

---

**erikbelhage** - 2025-07-09 11:22

And this result

---

**erikbelhage** - 2025-07-09 11:22

*(no text content)*

📎 Attachment: Screenshot_2025-07-09_132117.png

---

**erikbelhage** - 2025-07-09 11:23

Is there a quick fix for this?
It works fine in forward+

---

**tokisangames** - 2025-07-09 11:35

We can't help without any idea of your card, platform, driver ver, Godot version, or Terrain3D version. Compatibility mode works fine on my card in the main branch.

---

**erikbelhage** - 2025-07-09 11:37

Sorry for lacking info on the post!
I will get the extra info

---

**xtarsia** - 2025-07-09 11:37

I came across this the other day, and already have a fix included in an upcoming PR

---

**xtarsia** - 2025-07-09 11:38

or it might already be fixed in nightly actually

---

**xtarsia** - 2025-07-09 11:41

ah its not.

```glsl
        const int id = texture_id[0];
        bool projected = TEXTURE_ID_PROJECTED(id);
        const float id_w = texture_weight[0];
```
these const need removing (inside accumulate_material(), for the 1st and 2nd IDs), vulkan seems happy with them, since they are const selected from a const function input, but webgl isnt.

---

**erikbelhage** - 2025-07-09 11:44

Graphics card : Intel(R) UHD Graohics 620
Platform : Windows 11
Driver version : Not sure, what to look for
Godot version : 4.4.1
Terrain3D version : 1.0.1

---

**erikbelhage** - 2025-07-09 11:44

Awesome, I will check that out

---

**tokisangames** - 2025-07-09 11:47

> Driver version : Not sure, what to look for
This information is in your Device manager and reported in your console everytime you load Godot.

---

**tokisangames** - 2025-07-09 11:49

Compatibility mode works in 1.0.1 on my card.

---

**erikbelhage** - 2025-07-09 11:52

Ah, great!
OpenGL API 3.3.0 - Build 30.0.101.1122

---

**tokisangames** - 2025-07-09 11:59

That driver is from 2021. Upgrade it.

---

**mechanicalsanity** - 2025-07-09 18:02

<@455610038350774273> There is a scam post right above me, and in multiple channels

---

**mechanicalsanity** - 2025-07-09 18:02

I did not know who else to tell, so apologies if this is incorrect

---

**maker26** - 2025-07-09 18:03

he's the only admin

---

**maker26** - 2025-07-09 18:04

so he's the only one who can control things around the server

---

**mechanicalsanity** - 2025-07-09 18:04

damn

---

**mechanicalsanity** - 2025-07-09 18:04

Hopefully no one falls for it before he sees the message

---

**maker26** - 2025-07-09 18:04

and I don't think he's being notified either

---

**mechanicalsanity** - 2025-07-09 18:05

double damn

---

**mechanicalsanity** - 2025-07-09 18:07

Are you able to contact him?

---

**maker26** - 2025-07-09 18:11

I am but I don't think he'll be notified through dm either

---

**mechanicalsanity** - 2025-07-09 18:11

well, this is unfortunate

---

**maker26** - 2025-07-09 18:13

nice

---

**tokisangames** - 2025-07-09 18:14

Guys I can see them as well. No one is going to fall for them. Report things I'm not aware of in the <#1309478793173270548> channel.

---

**maker26** - 2025-07-09 18:15

you need a few moderators 😅

---

**mechanicalsanity** - 2025-07-09 18:15

gotcha, will do so next time

---

**tokisangames** - 2025-07-09 18:16

It's not the end of the world if the guy is banned in 60 minutes or 6 hours vs 10 minutes

---

**maker26** - 2025-07-09 18:16

its not, but unsurprisingly we still occasionally see hacked accounts around discord servers

---

**shadowdragon_86** - 2025-07-09 18:43

My old teams server has a hacked user about once a month 🤣 it's pretty much the only time it's active these days

---

**mechanicalsanity** - 2025-07-10 13:57

Im testing terrain3d with godot latest master, and I wanted to ask if anyone else keeps getting error messages with FileAccess. I know that Terrain3D doesnt officially support godot beyond the stable builds, but I just wanted to know if these errors are supposed to occur, or if I compiled it wrong

---

**wilcoco** - 2025-07-10 15:56

Is there an easy way to re-use setup textures? For example I have a "level1" scene with a terrain3d node, which I've used to sculpt/texture a map. And now I want to create a new "level2" scene. When I add a new terrain3d node I'm required to setup all the textures again, and copying terrain3d from level1 seems to cause some small issues (even after changing the data folder to somewhere seperate).

---

**trollgasm** - 2025-07-10 16:00

Normally I export my greybox scenes into blender, and work in there to keep sizing consistency. But terrain3D uses a custom class for it's meshes, and can't be properly exported. Is there a built in way to get around this like baking/creating the mesh data when it no longer needs to be edited/adjusted?

---

**xtarsia** - 2025-07-10 16:11

you can save these 2 as files, and set them onto the new scenes Terrain3D node. They can stay loaded between scene changes too.

📎 Attachment: image.png

---

**wilcoco** - 2025-07-10 16:16

Oh that sounds perfect for my use case, how do I save the assets as assets.tres? It's a "Terrain3dAssets" for me, sorry this was probably mentioned in the doc/tutorial video but I can't find it

---

**xtarsia** - 2025-07-10 16:18

You can name it whatever you want. Just keep an eye on the file size of the Assets file, if its suddenly a few MB or more, it means something is being saved directly in the file as text, as opposed to being a reference to something else. (This commonly happens with the generated placeholder textures)

---

**wilcoco** - 2025-07-10 16:20

Ok I've got it, thanks so much!

---

**xtarsia** - 2025-07-10 16:32

you can export to an array mesh, but it wont have any texturing, and will be of a fixed vertex density, that can have millions of vertices.

---

**corvanocta** - 2025-07-10 19:19

Odd question: is it possible to modify how the navigation area looks?

I'm working on a grid based movement system and being able to paint out the navigation areas tile by tile is super helpful to me! Makes it super fast and easy to create my world. But its a bit weird because I have my players navigating to locations with whole numbers for coordinates, which means the players all navigate to the upper left (or bottom right) corner of a highlighted square. Not the worst, just have to remember how it actually works from time to time which can be a little weird.

Is it possible then to change how the painted area looks? So instead of painting a whole square as navigable, it puts a square or circle over the corner? Basically move all of the painted areas by 0.5 in the X and Z

---

**tokisangames** - 2025-07-10 20:34

Not sure I understand. You shouldn't see the painted nav area except when painting. After you generate a nav mesh, that gizmo is the only visual indication of nav behavior you should care about. The painting is irrelevant and unrelated to nav and behavior after generation.

---

**corvanocta** - 2025-07-10 20:36

I actually don't use the generated navmesh. I generate my own since I need an array of points, rather than planes. Since the movement is grid based, its easier to generate it that way.

Hence the question if the painting can be altered. But if not, its not really a big deal. It doesn't take much to remember how it works, just wanting to know if it can be visually easier

---

**tokisangames** - 2025-07-10 20:55

The data is altered by where you paint. You can edit the shader and add the same code we use for the nav overlay, and modify it however you want to change the visual appearance and run it during game time.

---

**prehistoricknee** - 2025-07-11 01:59

<@188054719481118720> what do you think is more performant displacement mapping Vs parallax mapping

---

**xtarsia** - 2025-07-11 03:55

Displacement, no contest.

---

**biome** - 2025-07-11 04:13

<@188054719481118720> I recall you saying with autoshader projection you were going to take a look at the warping on the base texture, has there been any progress on that?

📎 Attachment: Godot_v4.4.1-stable_win64_gvfRzep3N4.png

---

**biome** - 2025-07-11 04:16

also updated from 1.0.0 to 1.0.1 and while i like the btter blending it is now extremely obvious when i'm going between autoshaded -> (hill texture) -> sand texture

📎 Attachment: image.png

---

**biome** - 2025-07-11 04:16

(autoshader view)

📎 Attachment: image.png

---

**paige_grace** - 2025-07-11 04:56

Hey! Totally niche question- I’m building a game with like spherical worlds, and want some editable terrain- is there a way I could make that work with this plugin? All the images I see of games using this are just flat rectangular regions

---

**xtarsia** - 2025-07-11 05:32

It didn't make it into 1.01 but is in nightly, you can disable projection for some textures, eg, the grass.

---

**xtarsia** - 2025-07-11 05:38

Probably best to use Zylanns voxel terrain. Or a custom solution.

---

**tokisangames** - 2025-07-11 08:13

You need to manually paint the same texture as the autoshader for adjacent vertices, then blend into that.

---

**tokisangames** - 2025-07-11 08:13

Warping fix is in nightly builds. Cliff face textures must now have vertical projection enabled.

---

**biome** - 2025-07-11 09:57

ah yes completely forgot about manual blending, thanks

---

**prehistoricknee** - 2025-07-11 11:02

<@188054719481118720> thanks mate glad you're working on this, you're amahhhzing

---

**hornetdc** - 2025-07-11 13:24

Having some issues with the mesh painter. I have a .glb tree exported from blender made of 2 planes. For some reason when I use it with terrain 3d it shows only 1 plane, and tree is tilted 90 degrees.

📎 Attachment: image.png

---

**tokisangames** - 2025-07-11 13:42

Your transforms are messed up, confirmed by the mesh thumbnail. You haven't applied them in your DCC, or they were warped during import/export. We don't apply transforms for you in that version. A properly setup mesh is imported with the neutral transforms: origin at 0,0,0 and no rotation.
As for the one side, your material might be culling back faces. Hard to say without information about your setup. Wireframe would show you if the mesh is actually there.

---

**hornetdc** - 2025-07-11 13:46

What's DCC? As for the back side culling, it seems to work fine with directly placed object like on the screenshot.

---

**tokisangames** - 2025-07-11 13:49

Digital Content Creation software, eg blender, 3ds max, maya.
Show the wireframe and see if the mesh is there as I said.
Given the information, I suspect it's not there. I suspect your two planes are separate objects and you didn't combine them, nor did you read the instancer documentation that explains both of these issues.

---

**tokisangames** - 2025-07-11 13:49

Join your objects and apply your transforms and you'll likely get what you expect.

---

**hornetdc** - 2025-07-11 13:50

You are right, I didn't join them. Going to try it, tnx

---

**prehistoricknee** - 2025-07-11 17:04

dcc digital crash course

---

**johnlogostini** - 2025-07-11 20:03

I am running into a bit of a problem. I packed my textures to the AH and NR format, but once loaded, the entertainer went crazy. Any tips?

📎 Attachment: Screenshot_2025-07-11_164510.png

---

**johnlogostini** - 2025-07-11 20:03

I am using PNG files

---

**tokisangames** - 2025-07-11 20:27

Use and read your console that tells you the problem with your textures, different format or size. Read Troubleshooting doc that discusses this.

---

**johnlogostini** - 2025-07-11 20:40

*(no text content)*

📎 Attachment: Screenshot_2025-07-11_173959.png

---

**johnlogostini** - 2025-07-11 20:40

Yup thanks

---

**legacyfanum** - 2025-07-12 07:49

is grok the best at shaders?

---

**tokisangames** - 2025-07-12 08:01

It's best when you already know what you're doing, like a calculator. It's helpful if you don't and are working on simple things. I've given it complex shaders and asked it to find bugs or implement small things. The more complexity, and the more vague your query, the worse your results.

---

**xtarsia** - 2025-07-12 08:22

AI will very happily give you giant nested for loops and not bat an eye lol

---

**vhsotter** - 2025-07-12 08:22

Generative LLM stuff are just overpowered Markov chain programs. They possess no reasoning capabilities despite the marketing behind them saying as much. They just spit out what sounds good. Sometimes might even produce working code. But if you don't possess the skills to debug anything it gives you then you're going to be wasting more time trying to get it to work than if you take the time to just learn to do it yourself.

---

**legacyfanum** - 2025-07-12 08:24

couldn't put better

---

**legacyfanum** - 2025-07-12 08:26

yeah when I worked for front-end job and had a decent understanding of jsx, it reduced my work time by a 50%. but with shaders It's me trying relentlessly juggling with shit it outputs

---

**.thymeout** - 2025-07-12 18:37

reposting this from the godot engine discord since we couldn't get to the core of the issue, therefore i assume it's a terrain3d thing
> hey, does anybody know what these white flashes at the top of the screen are and how to handle them?
> if i had to guess it's something to do with terrain3d, but idrk what might be causing this

📎 Attachment: ScreenRecorderProject31.mp4

---

**tokisangames** - 2025-07-12 18:49

What troubleshooting have you done? You could find out if it's your terrain or camera, or environment settings, or lighting in a few minutes by testing each. If it is terrain, it would only take a few more minutes to test each of the PBR channels. Since it doesn't look like you used any height textures, I assume you didn't use any roughness textures, and a strange roughness value might be the cause.

---

**vhsotter** - 2025-07-12 18:53

Looking at a still frame that looks familiar with an issue I had. Do you by chance have glow turned on in your project? I had a material set up with a custom shader that was producing extremely bright glow flashes from the edges of it. When I dug into that it turns out that the color values of something was being set well above 1 which glow uses for that purpose.

---

**.thymeout** - 2025-07-12 18:54

yeah glow is enabled o.o

---

**.thymeout** - 2025-07-12 18:55

i actually wrote a message to mr tokisan here in response so would be a shame to just erase it

---

**.thymeout** - 2025-07-12 18:55

started noticing flashes only after playing around with terrain3d, so it's not environment which was done a long time ago
there's no lighting or particles in the scene, and the camera doesn't have any planes in front of it or something that could cause this afaik

not sure if i understood the second part of the message correctly but the textures hold the default roughness value along with default normals

📎 Attachment: image.png

---

**vhsotter** - 2025-07-12 18:57

Okay, so my suggestion there, turn off glow and see if the problem still occurs. If it doesn't, then it's related to a material somewhere that's getting its values set above 1, such as an emission setting or a shader that isn't clamping values.

---

**vhsotter** - 2025-07-12 18:59

There is also the possibility that the HDRI threshold for glow is set too low.

---

**.thymeout** - 2025-07-12 19:11

okay so i did something and the flashes don't appear for a while now SO
thank you so much, at least if they return i know the core of the problem 🙏

---

**candycrushaim** - 2025-07-12 21:45

im watching a video about getting my assets imported into the addon for use, but I cannot seem to figure out how to do that in my own project as the video mostly shows how to do it in the demo.

---

**candycrushaim** - 2025-07-12 21:45

I have compiled my assets as dds files

---

**candycrushaim** - 2025-07-12 21:45

but it doesnt seem to recognise them

---

**candycrushaim** - 2025-07-12 21:45

help pls

---

**tokisangames** - 2025-07-12 21:54

Does godot recognize them, when you double click them?

---

**candycrushaim** - 2025-07-12 21:55

I might have figured it out, but its not similar to what I saw in the video

---

**candycrushaim** - 2025-07-12 21:55

It does yes

---

**tokisangames** - 2025-07-12 21:59

So what happens when you drag the texture to the add new texture button, or the albedo slot?

---

**candycrushaim** - 2025-07-12 21:59

it works

---

**candycrushaim** - 2025-07-12 21:59

thanks

---

**tokisangames** - 2025-07-12 22:00

So what was the problem?

---

**candycrushaim** - 2025-07-12 22:01

Just user error I think, Im new to game development

---

**deniedworks** - 2025-07-13 00:09

what's going on here. I packed the textures through the in editor packer and reimported them and this is how it looks. they are both 2048x2048 and it's the correct gl and everything

📎 Attachment: image.png

---

**deniedworks** - 2025-07-13 00:12

I also tried packing the textures through gimp same issue so i'm a bit lost. looks normal with checkered pattern so i don't think it's lighting or anything?

---

**deniedworks** - 2025-07-13 00:13

NVM it was because I had 2 blank textures that didn't match. strange it would mess up everything like that but got it ffixed

---

**tokisangames** - 2025-07-13 00:44

Matching textures is a requirement of your GPU using texture arrays. You should always be using your console, which would have told you the issue right away. And reading the docs, which address this.

---

**deniedworks** - 2025-07-13 00:52

Yah I just didn't realize because I added the blank textures, then imported one that was 2k, the default ones in the other slots were still at 1024. I figured it out no problem and even with the information on the docs wouldn't have known that without just happening to delete them

---

**biome** - 2025-07-13 02:56

Hello! I have updated to nightly, how do I disable projection for individual textures?

---

**biome** - 2025-07-13 03:18

found it lol

---

**tokisangames** - 2025-07-13 08:18

It should be disabled for all by default. You need to enable it. Was this not the case?

---

**dekker3d** - 2025-07-13 12:04

So I'm kinda sorta back to my RTS game project. Upgraded to Terrain3D 1.0.1 today (I was still on whatever version I first downloaded), excited for the ability to update parts of the terrain without needing to update all of it. But... when I called update_maps(3, false, false), while each new region should have Terrain3DRegion.edited set to true, it would only show a single tile (and everything else was black and at the same height). I don't see any obvious ways that this could be a bug in my code, and if I use update_maps(3, true, false), it works fine.

---

**dekker3d** - 2025-07-13 12:05

I imagine that the ability to update specific regions, while generating them on the fly (rather than loading from disk), isn't very well-tested, so it *could* be a bug in Terrain3D, so I thought I'd mention it.

---

**dekker3d** - 2025-07-13 12:20

Could it be that it's unable to resize the Texture2DArray if I call it with p_all_regions set to false?

---

**dekker3d** - 2025-07-13 12:23

Kinda looks like it.

---

**dekker3d** - 2025-07-13 12:24

The region_id is used as the layer. Hm.

---

**dekker3d** - 2025-07-13 12:28

I should see what happens if I just create 25 terrain tiles, update_maps for all regions, and then delete some tiles, and make some other tiles, and then only update those specific tiles. If it's smart about assigning region IDs, it could work.

---

**biome** - 2025-07-13 13:07

you are right!

---

**tokisangames** - 2025-07-13 18:16

> when I called update_maps(3, false, false), while each new region should have Terrain3DRegion.edited set to true, 
Edited means we're in between Terrain3DEditor::start_operation and stop_operation. New regions are marked modified. Update_maps updates only edited or all_regions.
> if I use update_maps(3, true, false), it works fine.
So the issue is you're not between start/stop_operation, or you didn't manually mark your regions as edited.

---

**esklarski** - 2025-07-13 18:20

I've imported a heightmap, brought it into my game scene and done some sculpting, and now I'd like to import a colormap.

However importing just the colormap in the Importer just gives me a completely flat terrain with the colormap applied.

Is there a way to separatly import the color and height maps?

---

**esklarski** - 2025-07-13 18:20

Or does the colormap __need__ to be imported with the initial heightmap?

---

**tokisangames** - 2025-07-13 18:35

Currently it overwrites all three maps of any region modified

---

**tokisangames** - 2025-07-13 19:02

I found a bug in this import process. I think we can support importing individual maps and fix the bug together.

---

**esklarski** - 2025-07-13 19:04

Oooh, do tell more 👀

---

**dekker3d** - 2025-07-13 19:18

I did mark the regions as edited, before calling update_maps, but I don't see any code in Terrain3D that would resize the Texture2DArray in that case. So if I add a new region, it seems I still have to use p_all_regions = true

---

**tokisangames** - 2025-07-13 19:21

I don't think texture arrays can be resized. I think they have to be recreated, and so we require the region map recreated also if the number of regions is changed. So you can pre allocate the destination number, then update them individually.

---

**esklarski** - 2025-07-13 19:21

When exporting a project, what from the Terrain3d folder needs to be included?

---

**dekker3d** - 2025-07-13 19:22

Is there a function to pre allocate them, or would I have to implement it myself?

---

**dekker3d** - 2025-07-13 19:22

I guess I could reuse Terrain3DRegions, perhaps, and move them to another spot, give them new data and recalculate stuff, if it's possible to move them like that at all.

---

**tokisangames** - 2025-07-13 19:30

The library and any GDScript you use.

---

**tokisangames** - 2025-07-13 19:31

For loop over add_region_blank()? Only update at the end.

---

**tokisangames** - 2025-07-13 19:33

You can change the location. Not sure if update_maps can be done with an incremental update or needs a full update.

---

**xtarsia** - 2025-07-13 19:35

once region streaming is dealt with (i'll probably look at it after I get a bit of time to finish up displacement, which only needs a couple things now)

There will likely be 3 data sets; 
possible regions to load. (doesn't currently exist)
regions loaded in RAM.
regions inside the GPU Array Area. (Currently resized as needed - will end up as a fixed size)

Possible regions to load, would be a full set of every potential region that could be loaded. (stored array of strings "res://etc")

A function then runs each frame that checks a skirt area and loads/unloads regions to RAM 1 by 1 asynchronously. (any region directly under the player would be forced to the front of the queue)

Region loaded in RAM can be stored in a dynamicly sized array.

Another function also runs each frame, and any region Inside the fixed Grid that VRAM covers, that isnt present, updates that region to the next empty region map slot.
Any region now outside the fixed grid, is left in place, but the region map is marked as empty (-1) ready for overwrite.


This way, Loading/unloading regions VRAM side will be automatic.
RAM side would also be automatic, and the insertion point for a newly created region (procedural / level loaded etc) would be to the "possible regions to load" data set.

(ive been mulling this one for a good while)

---

**johnlogostini** - 2025-07-13 19:36

I'm having some trouble importing my terrain. When I use the position offset, the terrain spawns in the wrong location. However, if I offset both my cliff and terrain mesh references, everything lines up correctly, but the position in Terrain3D still seems off. Am I missing something?

📎 Attachment: 2025-07-13_16-30-31.mp4

---

**xtarsia** - 2025-07-13 19:42

given the size of 1000x1000 doesnt match power of 2, you might need to offset +- some small ammount as well, depening on which corner of the regions is 0,0 vs the software you used to make the images.

Might need to be offset by +524 or +476 perhaps

---

**xtarsia** - 2025-07-13 19:44

each axis could be different offsets potentially as well.

---

**dekker3d** - 2025-07-13 19:59

Ah, that sounds pretty nice. I assume the displacement is about 3D displacement, so you can have overhangs and all that fancy stuff?

---

**tokisangames** - 2025-07-13 20:02

Use 512,512 offset. And for your maps 1024,1024. Powers of 2. And where did your mesh come from? An export at a lower lod?
Is this a heightmap and a mesh both generated in houdini? Were they made at a terrain resolution of 1m?

---

**tokisangames** - 2025-07-13 20:03

Poor man's tessellation. Not overhangs.

---

**xtarsia** - 2025-07-13 20:03

Overhangs for ants at the most ;D

---

**dekker3d** - 2025-07-13 20:18

Ah.

---

**dekker3d** - 2025-07-13 20:18

Oh, so displacement maps? To add relief.

---

**dekker3d** - 2025-07-13 20:19

... Uh, depth. Bas relief?

---

**tokisangames** - 2025-07-13 21:36

You can try this build artifact
https://github.com/TokisanGames/Terrain3D/pull/764

---

**johnlogostini** - 2025-07-14 01:46

Even with that, 500 should be the correct offset, with my terrain being 1,000 x 1,000.

---

**johnlogostini** - 2025-07-14 01:48

I’ll make my terrain a power of 2. I was rapidly prototyping and somehow ended up with a final heightmap size of 1,000 instead of 1,024, so I may as well fix that and see if it resolves the issue.

---

**johnlogostini** - 2025-07-14 01:48

Yeah, all the data was generated in Houdini. The terrain mesh was just for visualization and for verifying that Terrain3D matched the scale and orientation from Houdini. It's also lower resolution than the Terrain3D heightmap.

---

**johnlogostini** - 2025-07-14 01:50

I spent 2 years trying to solve the mysteries of open-world terrain overhangs!

---

**tokisangames** - 2025-07-14 02:00

I thought your video was to show the imported mesh doesn't match up with the Terrain3D mesh, but obviously lower resolution won't match up. It looks like a reasonable match given they're entirely different data. So if that's not it, I'm not sure what the issue is. I recommend you use a 1024 sized heightmap, imported at 0,0. Export a 1m terrain resolution mesh that is 1024m per side. Offset it at -512,-512.

---

**johnlogostini** - 2025-07-14 02:08

The problem is, if I import the terrain at (0, 0) and offset my meshes by 500, everything lines up correctly. But if I leave my meshes at (0, 0) and offset the terrain by -500, it no longer aligns.

---

**johnlogostini** - 2025-07-14 02:12

I’m just re-exporting at 1024, with new cliffs to match and a terrain mesh that has 1:1 resolution.

---

**johnlogostini** - 2025-07-14 02:13

I was trying to use the lower-poly mesh for collision, but the load times were terrible. What really pushed me toward Terrain3D over just using meshes was the LOD system—even though my scene is on the smaller side.

---

**tokisangames** - 2025-07-14 02:18

It's probably off by 12. Your default region size is 256. It doesn't import at -500. It imports at the nearest region, so -512, -512. The import doc explains this.

---

**johnlogostini** - 2025-07-14 02:36

OK, I fixed my resolution problems, but it's still doing the same thing. I’ll send a video.

---

**johnlogostini** - 2025-07-14 02:38

Never mind, I forgot to re-export the heightmap. Once I did that, it's working.

---

**johnlogostini** - 2025-07-14 02:45

<@455610038350774273> OK, looks like that works. There are some small mismatches, which is odd since it should be the same resolution, but either way, it looks workable.

📎 Attachment: 2025-07-13_23-42-49.mp4

---

**johnlogostini** - 2025-07-14 02:48

Now how do I get rid of the distant terrain?

---

**johnlogostini** - 2025-07-14 02:50

Is there a purpose to using the Data Directory? Am I just saving and then loading the same data?

📎 Attachment: Screenshot_2025-07-13_234946.png

---

**johnlogostini** - 2025-07-14 02:51

OK it's in the material settings

📎 Attachment: Screenshot_2025-07-13_235055.png

---

**johnlogostini** - 2025-07-14 02:55

<@455610038350774273> Should I use the import script on my final terrain, or should I be loading it in a separate scene and then loading the data?

---

**tokisangames** - 2025-07-14 03:41

material/world background

---

**tokisangames** - 2025-07-14 03:41

That's where your data is saved

---

**tokisangames** - 2025-07-14 03:41

Importer is only for importing. Load your data in your own scene.

---

**johnlogostini** - 2025-07-14 03:42

OK, got it. I’ll split it up.

---

**johnlogostini** - 2025-07-14 03:42

<@455610038350774273> Also, I'm just running some experiments, but the terrain appears to be slightly offset in most areas to the point where some of the cliff assets are completely buried under the terrain.

---

**johnlogostini** - 2025-07-14 03:43

You can see the offset in the video I posted.

---

**tokisangames** - 2025-07-14 03:51

Terrain3D defaults to 1px=1m. If it doesn't match, your mesh asset, vertices, or scale doesn't match the heightmap provided.

---

**tokisangames** - 2025-07-14 03:51

Compare the wireframe.

---

**johnlogostini** - 2025-07-14 03:54

Yeah, so the resolution is exact, but the terrain is mismatched by 0.5?"

📎 Attachment: Screenshot_2025-07-14_005254.png

---

**johnlogostini** - 2025-07-14 03:55

*(no text content)*

📎 Attachment: 2025-07-14_00-54-52.mp4

---

**tokisangames** - 2025-07-14 03:59

More than that, it's a different shape. Anyway we're not designed to make a pixel perfect match for houdini. There are different choices in meshing design. Your job is to understand your data enough to get it transferred between systems. Looks like you have a solid match now.

---

**johnlogostini** - 2025-07-14 04:01

Yeah, it's just a difference in the triangulation pattern, but I think I have it lined up now. Thanks for the help! I’ll be sure to ask questions as I go, but I think I have what I need to get started.

---

**esklarski** - 2025-07-14 07:35

I downloaded from here: <https://github.com/TokisanGames/Terrain3D/actions/runs/16253982225> which I __think__ is correct. It did work, but I can't seem to save the results.

My process:
- opened importer.tscn
- loaded data directory under Terrain3D inspector
- selected colormap
- clicked to run import

📎 Attachment: Screenshot_From_2025-07-14_00-12-32.png

---

**esklarski** - 2025-07-14 07:37

But if I then set the output directory (the directory loaded from previously) and click on the "save to disk" check, it says it saves in the log but if I open my main scene the color map has not been applied.

---

**esklarski** - 2025-07-14 07:37

According to git the .res files in the data directory are unchanged.

---

**tokisangames** - 2025-07-14 14:50

The artifact is right on the checks page. 
I have made more changes. Please try it again.

---

**bat117** - 2025-07-14 19:12

Hi, Im currently trying to implement a water shader using stencil depth and the alpha pass to compute the depth of the water from the camera angle. when i try to load the depth via depth_texture, it doesnt appear that depth is changing. Does godot's depth_texture have the stencil depth of Terrain3d? if not, is there anyways to get this texture?

📎 Attachment: image.png

---

**mr_squarepeg** - 2025-07-14 19:55

How big is your terrain btw?

---

**bat117** - 2025-07-14 19:56

do you mean number of cels

---

**mr_squarepeg** - 2025-07-14 19:57

How many cells and how big are those cells in km

---

**bat117** - 2025-07-14 19:57

i think region size is 256

---

**mr_squarepeg** - 2025-07-14 19:57

Ok cool.

---

**bat117** - 2025-07-14 19:57

the ocean is 3.2km wide and 3.2km tall

---

**mr_squarepeg** - 2025-07-14 19:58

Neat!

---

**tokisangames** - 2025-07-14 22:33

The depth texture works fine. The mouse decal uses it to sit on the terrain by using get_intersection(). 
Stencil support isn't in 4.4, so we do nothing for it. It was added to 4.5, and we don't support unstable engine versions until the rcs.

📎 Attachment: F5F0E107-4BD4-431D-8DAD-D73F25A1C5E6.png

---

**bat117** - 2025-07-14 22:35

Thanks for the response with code and scene tree, really appreciate ut

---

**esklarski** - 2025-07-15 04:27

That seems to have done the trick! Thanks.

---

**esklarski** - 2025-07-15 04:29

Now when I click "save to disk" the res files are updated and the terrain will load with the new colormap in the main scene. So at least loading a color map to existing terrain works.

---

**hornetdc** - 2025-07-15 14:54

Question about painting small textures, like a dirt road 1-2m wide. With my current setup the smallest size I can paint is 10m. Do I need to increase terrain detail?

📎 Attachment: image.png

---

**tokisangames** - 2025-07-15 15:00

Reduce vertex spacing back to 1. You cannot paint on vertices where you don't have them.

---

**tokisangames** - 2025-07-15 15:00

Reread the intro doc. This is a vertex painter, not a pixel painter.

---

**nagivt** - 2025-07-16 15:35

I have a question about terrain3D. In my game I wish to create a floating island with a diameter of 20km that you can fall off of the side of or out the bottom if you go to deep into a cave. Is there a way to add a bottom to the terrain mesh and keep it workable in the editor?

---

**tokisangames** - 2025-07-16 15:44

You could add a second Terrain3D node, inverse the culling in the shader, and use it to sculpt the bottom. It's not optimal, but you could swap their visibility and disable physics processing depending on if they're on top or underneath.

---

**toonnoah** - 2025-07-16 15:53

tldr; how do i manually update the camera terrain 3d uses for LODs and/or Dynamic Collision?

📎 Attachment: terrain3dhelp.mp4

---

**tokisangames** - 2025-07-16 15:59

Look in your terminal/console where it tells you to use set_camera(). Always run with it open and look at it. The engine gives you messages there.
In nightly builds you can manually set them to non-camera nodes.

---

**toonnoah** - 2025-07-16 16:00

i might get the nightly build, i just used the default build in the AssetLib

---

**tokisangames** - 2025-07-16 16:01

You should still run either version with your console open so you can address error messages like the one mentioned.

---

**toonnoah** - 2025-07-16 16:04

u mean the debugger console right? i see the error now, thank you.

📎 Attachment: image.png

---

**tokisangames** - 2025-07-16 16:06

No, I mean the terminal / console.
https://terrain3d.readthedocs.io/en/latest/docs/troubleshooting.html#using-the-console

---

**toonnoah** - 2025-07-16 16:12

so fun fact i am using a pre-compiled build of  GodotSteam MultiplayerPeer which has Steam Multiplayer built-in classes. the build does not come included with a console exe, as far as i am aware https://github.com/GodotSteam/MultiplayerPeer

---

**toonnoah** - 2025-07-16 16:13

but ill check to see if it works if i run it through a terminal instead.

---

**toonnoah** - 2025-07-16 16:16

good news: seems to work if manually started in terminal. sorry, im very new at this 💀

📎 Attachment: image.png

---

**toonnoah** - 2025-07-16 16:17

prints twice cus i forgot i was running 2 instances for multiplayer testing.

---

**toonnoah** - 2025-07-16 16:58

i believe i have correctly downloaded the latest nightly version and i have updated set_camera() (as you can see from the grass appearing now.) what function in the nightly build would i use to manually add non-camera nodes? or is it more complex than a function? i've skimmed through the addon documentation and the <#1131096863915909120> history and don't see anything about it unless i missed it.

📎 Attachment: image.png

---

**tokisangames** - 2025-07-16 17:05

Sky3D has nothing to do with this. 
Look in the inspector under collision and mesh for the target nodes.
The API docs online and built in have those node setter functions. You should familiarize yourself and get used to looking at the docs online and built into the engine. Most of your questions are answered there already.

---

**toonnoah** - 2025-07-16 17:06

i meant to say <#1131096863915909120> my bad. and thanks i'll keep reading.

---

**ollegn** - 2025-07-16 17:27

Hi folks, i need a hand, does anyone knows if it's possible to change the texture of the terrain during gameplay, like if it was done by a brush?
i need to paint some "Dirt" squares where i already have "Grass"

---

**xtarsia** - 2025-07-16 17:32

```c++
    var global_pos := Vector3()
    var texture_asset_id := int()
    terrain3DNode.data.set_control_base_id(global_pos, texture_asset_id)
    terrain3DNode.data.set_control_blend(global_pos, 0.)
```

should work.

---

**ollegn** - 2025-07-16 17:33

thanks, i will try it out!

---

**tokisangames** - 2025-07-16 18:05

Might also need to `data.update_maps()`. Read the docs for all of these functions you were given.

---

**trollgasm** - 2025-07-16 19:20

I found this documentation specifically shortly after my post haha. Thank you for the reply regardless! 😄

https://terrain3d.readthedocs.io/en/stable/docs/import_export.html#exporting-gltf

The bake array was perfect for the use case as you mentioned!

---

**limeullol** - 2025-07-17 07:50

Hi! I'm new and I was wondering if anyone knows why the terrain3d addon won't work by that I mean that the flat terrain doesn't appear when I add the terrain3d node

---

**limeullol** - 2025-07-17 07:51

I just want to know if I did anything or if I missed something

---

**limeullol** - 2025-07-17 07:53

I made a screenshot if it helps

📎 Attachment: Screenshot_2025-07-17_105239.png

---

**limeullol** - 2025-07-17 07:56

*(no text content)*

📎 Attachment: Screenshot_2025-07-17_105548.png

---

**xtarsia** - 2025-07-17 08:06

What are the error messages in the console?

---

**tokisangames** - 2025-07-17 08:09

What gpu and driver? Just copy everything in your console (see troubleshooting doc).

---

**tokisangames** - 2025-07-17 08:09

Godot isn't working at all. Even the textures on the rocks aren't loading.

---

**limeullol** - 2025-07-17 08:17

so I reinstalled my graphics driver (the latest) and restarted my laptop when I opened godot i got these errors

📎 Attachment: Screenshot_2025-07-17_111315.png

---

**limeullol** - 2025-07-17 08:18

here is another

📎 Attachment: Screenshot_2025-07-17_111800.png

---

**limeullol** - 2025-07-17 08:22

is this good?

📎 Attachment: Screenshot_2025-07-17_112207.png

---

**tokisangames** - 2025-07-17 08:27

As I said, see the troubleshooting doc, use your console, and copy what's in it starting from the top. This isn't a Terrain3D issue. You need to get your drivers and hardware working with Godot.

---

**hornetdc** - 2025-07-17 08:59

I increased vertex spacing to import heightmap at 1/12 scale, full 12288*12288 image is over 3gb and godot crashes when importing it 😕 
Is importing at 1 to 1 scale really the only option?

---

**tokisangames** - 2025-07-17 09:03

12k isn't that big. You shouldn't have a 3gb file. Likely your conversion was incorrect. You could fit a 16k exr in ~~under 100mb~~ maybe 400mb.

---

**tokisangames** - 2025-07-17 09:03

If you want to paint on vertices at a scale of 1m, you need vertices 1m apart. 🤷‍♂️

---

