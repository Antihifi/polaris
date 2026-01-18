# terrain-help page 17

*Terrain3D Discord Archive - 1000 messages*

---

**felipe_muniz** - 2024-01-29 15:17

Hello everyone, i have textures in png, how i can use in Terrain3Dtexture? i am try convert to dds, but dont works.
errain3DTexture::_is_texture_valid: Invalid format. Expected channel packed DXT5 RGBA8. See documentation for format.

---

**p.uri.tanner** - 2024-01-29 15:47

It's not easy. But it's well documented here:
https://terrain3d.readthedocs.io/en/stable/docs/texture_prep.html

---

**p.uri.tanner** - 2024-01-29 15:47

It's work and you need to carefully follow each step, but in the end it works.

---

**tokisangames** - 2024-01-29 16:16

There's also a tutorial video showing how to do it, part 1. When you've done it once, it takes 2 minutes.

---

**xorblax** - 2024-01-29 18:28

On the topic of runtime editable terrain, what if it were possible to just alter the collision heightmapshape3d’s values directly at the same time that the heightmap is edited, using the same information input into the set_height method? Instead of having to parse over the whole heightmap image in update_collision to see where changes occurred. Sorry if I’m misunderstanding anything. Amazing terrain tool by the way

---

**xorblax** - 2024-01-29 18:34

Dynamic collision sounds like it’d work, but I’m curious how it would handle collisions on objects very far from the camera, as my game would involve quite a bit of that.

---

**tokisangames** - 2024-01-29 18:45

The collision shape doesn't allow inline modification. You must dump in a whole array of values at once.  PR 278 allows for dynamic collision. Dynamic collision doesn't work far from the camera, and for most games you don't need collision far away. Your enemies shouldn't be processing gravity or anything far away. You can however query height at any point on the terrain without physics based collision.

---

**xorblax** - 2024-01-29 18:53

I wouldn’t be able to get the map_data packedfloat32 as a variable, modify it and then set it again? 
The game I’m doing is a large scale physics based fighting game inspired by dragonball Z, so I’d need collisions to be the same for distant opponents.

---

**tokisangames** - 2024-01-29 19:00

Don't know if you can retrieve it. Maybe. You just have to set the whole thing at once. 

Thought, If you want large scale destructability and physics, Zylann's voxel tools is a better tool. Pick the right tool for the job.

---

**lw64** - 2024-01-29 19:01

<@110555726031654912> since the collision system works with chunks, with a bit of work in terrain3d,  you could also make extra chunks appear in locations specified by you, far away from the camera

---

**xorblax** - 2024-01-29 19:08

Wow I hadn’t heard of zylanns tool until now and I will check it out, thank you. I do lean towards heightmap based because what I need are mainly just craters and 10x10 km maps with reasonable performance.

---

**xorblax** - 2024-01-29 19:09

That sounds like it’d work too. There shouldn’t be very many enemies in my scenes

---

**tokisangames** - 2024-01-29 19:11

Sub to my YouTube. I've been talking about terrain in Godot for years, starting with when I was working with him on his voxel terrain. Heightmaps work on the voxel terrain.

---

**tokisangames** - 2024-01-29 19:12

I haven't kept up to date on his terrain, so I don't know the limits or capabilities on Godot 4

---

**xorblax** - 2024-01-29 19:14

Sorry I should’ve said that I want heightmaps because I don’t want to store all the voxel data since I don’t need caves or overhangs, I wasn’t talking about terrain creation. But I don’t know anything much about voxels, maybe theyre not as resource heavy as I’m assuming? I will check out your channel, this is all very interesting.

---

**tokisangames** - 2024-01-29 19:19

What voxel data? I think you're making a lot of assumptions without basis. A voxel terrain is just a mesh generator. Our mesh generator makes a flat terrain with fixed points. The voxel mesher creates a different style mesh using a variety of surface algorithms like dual marching cubes or transvoxel. The reason I said it's the better tool for destructability is because it provides an API for destroying or rebuilding meshes and collision in realtime.

---

**Deleted User** - 2024-01-29 19:22

Hey is there anyway to disable visibility on unused regions?

---

**xorblax** - 2024-01-29 19:37

I don’t want detailed 3D volume destruction, what I want is the creation of simple craters or ravines that may be 100 or more meters in diameter. Voxels can do this, but voxels seem like an overkill solution because again I don’t need caves or overhangs, and I’d like my game to be performant. I read the voxel documentation and it states that it’s rather cpu intensive for large 10x10km maps. Is it wrong to assume a 3D editable volume takes more data and processing than an editable 2D mesh?

---

**tokisangames** - 2024-01-29 19:38

world background is the first setting in the material

---

**tokisangames** - 2024-01-29 19:43

The 3D space is managed by an octree. It's not a cubic array or anything dumb like that. CPU processing is generally irrelevant as most 3D games are bound by the GPU. The bigger concern is occlusion. I don't know if he can bake occlusion, but you could put in manual shapes. In any case, you should let go of your assumptions and actually try it and compare which will work better for you.

---

**xorblax** - 2024-01-29 19:46

I’m absolutely going to try it out once I get home from work. Thanks for your help

---

**Deleted User** - 2024-01-29 20:02

Oh ok thanks will check

---

**quazar_cg** - 2024-01-29 23:16

Is there.... any way at all with *any* terrain system to have large terrain that can also move around in world space so I can actually use them for large terrain. I need a map larger then 16x16. I've asked around does *anyone* know?

---

**quazar_cg** - 2024-01-29 23:17

I like this terrain but I just need to add an offset to the locations

---

**skyrbunny** - 2024-01-29 23:59

Unfortunately T3D only supports terrains up to 16x16 for now

---

**quazar_cg** - 2024-01-30 00:07

If you could offset the terrain you could have multiple. But I've put my project on hold indefinitly now.

---

**tokisangames** - 2024-01-30 00:30

16k is large. Wait for PR 276 for more size at lower resolution. Implement issue 77 if you want more size. 
Once it is supported, you'll need to build the engine and release templates with 64-bit floats. 
Or you can customize Terrain3D to add in a translation offset. No need to put your project on hold forever. It's expected that gamedevs build what we need. That's why Terrain3D exists at all. Built by people who needed something.

---

**quazar_cg** - 2024-01-30 00:37

I do not want larger terrain, I'm looking for multiple terrains. Anywho. I like the system, it's great. I will use for other smaller projects.

---

**tokisangames** - 2024-01-30 05:52

We use multiple terrains in OOTA, as levels loaded behind a loading screen.

---

**mrpinkdev** - 2024-01-30 18:40

level of detail changes when entering playmode? also colliders don't match

📎 Attachment: image.png

---

**tokisangames** - 2024-01-30 19:00

You disconnected the camera from the terrain somehow, perhaps by having multiple cameras in the scene. Set it manually w/ terrain.set_camera

---

**selvasz** - 2024-01-30 19:25

Can I use auto shader to paint two different mountains with different shaders

---

**tokisangames** - 2024-01-30 19:43

Customize the shader as you like. I gave you a framework to expand the code as needed.

---

**chrissi_kiwi** - 2024-01-31 15:28

Hello 🙂
I would like to use Terrain3D in combination with a Folage Painter. I tested Spatial gardener from dreadpon, but for that i need a StaticBody3D Node. Is there a way to use Terrain3D to paint Foliage on it?

---

**benan** - 2024-01-31 16:00

Guys when I design the terrain I can see it properly, but when I test it in-game I get something like this:
Where only 1 quadrant will load and the rest will be invisible except for their borders. Anyone knows what am I doing wrong?

📎 Attachment: image.png

---

**tokisangames** - 2024-01-31 16:02

Enable debug collision

---

**tokisangames** - 2024-01-31 16:03

Does the demo work? Looks like you enabled a custom shader, then broke it.

---

**benan** - 2024-01-31 16:12

Yep demo works just fine 😅

---

**tokisangames** - 2024-01-31 16:26

Then compare projects until you find what you did, starting with disabling the override shader

---

**benan** - 2024-01-31 17:22

Happens when I instantiate the player and add it as a child through script, doesn't happen when player is a child on the scene tree.

---

**tokisangames** - 2024-01-31 17:39

We insantiate a player via script in OOTA without issue. Perhaps you're breaking the camera Terrain3D uses. Try setting it with terrain.set_camera.

---

**Deleted User** - 2024-02-01 01:03

i cant really get a screenshot but the terrain has these random white pixels that show up in shadowed areas while the camera is moving

📎 Attachment: image.png

---

**Deleted User** - 2024-02-01 01:03

any way to fix that

---

**Deleted User** - 2024-02-01 01:04

*(no text content)*

📎 Attachment: image.png

---

**skyrbunny** - 2024-02-01 01:04

oh yeah, I've seen those seams too

---

**skyrbunny** - 2024-02-01 01:04

not really sure what's causing them

---

**tokisangames** - 2024-02-01 01:39

When you hide the terrain and put two planes adjecent to each other in a shadowed area, with a light background, do you see them?

---

**vvarsin** - 2024-02-01 02:48

why when I create new material it makes my terrain white?

📎 Attachment: image.png

---

**tokisangames** - 2024-02-01 06:49

What version of Terrain3D ?
What is the size and format of your 4 textures, both for each slot? Click them on top to reveal.

---

**vvarsin** - 2024-02-01 13:49

0.9.1-dev and this is the two textures both work fine individually but when I add a new texture it turns white idk why lol

📎 Attachment: image.png

---

**saul2025** - 2024-02-01 14:01

Try adding the normal map or change position Ids.

---

**vvarsin** - 2024-02-01 14:06

tried both and reloaded the scene now its black also I cant change texture Ids othan than 0-1 cause thats how many I have. Is that what you mean?

---

**vvarsin** - 2024-02-01 14:07

*(no text content)*

📎 Attachment: image.png

---

**vvarsin** - 2024-02-01 14:09

wait I the other textures work its only this one thats causing probelms

📎 Attachment: image.png

---

**tokisangames** - 2024-02-01 14:09

The problem is the textures must be the same size and format as it says on your console error messages, and in the docs. 
In the dev version we loosened the restrictions on textures. But you've highlighted that there might be an issue with the automatically generated  checker grid not matching up with the first texture in your original message. That's what I wanted to see the size and format of.

---

**vvarsin** - 2024-02-01 14:12

OH okay ty

---

**vvarsin** - 2024-02-01 14:12

*(no text content)*

📎 Attachment: image.png

---

**Deleted User** - 2024-02-01 16:11

no

📎 Attachment: image.png

---

**tokisangames** - 2024-02-01 17:25

I have seen it, but I'm not able to reproduce it. Do you see it with the Grey debug view?

---

**Deleted User** - 2024-02-01 17:27

yes

📎 Attachment: image.png

---

**tokisangames** - 2024-02-01 17:29

Then it's likely not the shader. It may be occuring between the mesh components. This was an issue in the Godot 3 renderer with separate objects that were aligned. There was a fix available that might help here.
https://github.com/godotengine/godot/issues/35067

---

**kalderopana** - 2024-02-01 17:55

https://discord.com/channels/691957978680786944/841475566762590248/1137411741723148338 How can I make puddles like this

---

**tokisangames** - 2024-02-01 18:25

Flat normal map and low roughness

---

**flynndynamics** - 2024-02-02 14:37

Hello everyone! I'm relatively new to creating 3D environments for games. I've noticed that I can model my environments with much more detail by simply scaling up all other objects. This leads me to wonder: Is it technically sensible, in terms of performance, to do this? I don't necessarily want every part of the environment to be highly detailed. Would it be better to create more detailed areas in Blender and then import them into Godot as meshes, combining them with my existing terrain? Using standard size ratios, I've found it impossible to construct small elements like tiny streams or canals.

📎 Attachment: image.png

---

**esklarski** - 2024-02-02 16:38

If you're working with physics, things get weird when out of scale. That 30m tall capsule will act very heavy and sluggish.

You can tune things like gravity but in my experience (limited) it's a lot of trouble.

---

**tokisangames** - 2024-02-02 16:41

In Out of the Ashes, we've gone to great lengths to ensure the model, armature and animations of all characters are scaled to 1 in real world units. Scaling physics bodies creates problems. Scaling characters with root motion animations and bone attachments creates problems. Some of these are subtle issues you won't discover until months or years into your project.

If you want a higher resolution terrain, 0.9.1 includes `vertex_spacing` for higher or lower mesh density. However, most likely you just need to improve your sculpting and painting technique. I've been practicing for years. I don't expect you'd get it in a few hours. You may find that some of those "tiny details like streams" aren't actually necessary and can be adquately sculpted with better technique or painted on by using a puddle texture (which Kaldera just asked about right above your comment) or some other trick.

---

**joe718** - 2024-02-02 20:09

Is it possible to make a patch of terrain smaller than 1km x 1km?

---

**tokisangames** - 2024-02-02 20:31

https://terrain3d.readthedocs.io/en/stable/docs/tips.html#make-a-region-smaller-than-1024-2

---

**joe718** - 2024-02-02 20:32

Thank you for the reference

---

**dimaloveseggs** - 2024-02-02 20:57

<@455610038350774273> hey is it possible to make our own alpha fro brushes to sculpt the terrain?

---

**tokisangames** - 2024-02-02 20:59

The brushes are just exr files sitting in a directory on your disk. Add more if you like. These aren't designed like alpha stamps in UE, so don't insert 4k files.

---

**dimaloveseggs** - 2024-02-02 21:00

sure thanks for the info !!!

---

**felipe_muniz** - 2024-02-04 01:45

Here the buttons dont show in left side:

📎 Attachment: image.png

---

**felipe_muniz** - 2024-02-04 01:45

this buttons:

📎 Attachment: image.png

---

**felipe_muniz** - 2024-02-04 01:46

i am using godot v4.2.1

📎 Attachment: image.png

---

**felipe_muniz** - 2024-02-04 01:55

a reload project resolved

📎 Attachment: image.png

---

**felipe_muniz** - 2024-02-04 04:54

I am trying import a raw map following this doc: https://terrain3d.readthedocs.io/en/stable/docs/import_export.html#importing-data
I have imported the file, but in terrain nothing change, only in inspector load the some things.
When i save the terrainstorage3d and load in another scene in a new terrain3d, nothing changes in terrain again.

📎 Attachment: image.png

---

**tokisangames** - 2024-02-04 08:12

The docs say what to do in this circumstance. Your heightmap is normalized. Scale it up.

---

**mrpinkdev** - 2024-02-04 11:16

trying to run ProtonScatter and it won't let me select the terrain. is somekind of special node tree structure needed?

📎 Attachment: image.png

---

**tokisangames** - 2024-02-04 11:29

That bug in scatter was fixed a month ago. Update to the latest version.

---

**p.uri.tanner** - 2024-02-04 11:43

It's fixed, but you need to get the master branch from github. Hasn't made it into the Asset Library yet.

---

**p.uri.tanner** - 2024-02-04 11:44

It is what it is with Godot.

---

**tokisangames** - 2024-02-04 11:50

Yes, that's normal.

---

**p.uri.tanner** - 2024-02-04 11:50

For Godot maybe. It's not good.

---

**p.uri.tanner** - 2024-02-04 11:51

Maybe that's just me, but Terrain3D is one of the hottest opportunities for Godot to bring larger scale 3D projects to the street.

---

**p.uri.tanner** - 2024-02-04 11:51

Having to fiddle tools will block artists from participating. Hence you get content from coders and VERY tech affine people only.

---

**tokisangames** - 2024-02-04 11:52

Sorry. Complain to HungryProton. I have yet to use the asset library.

---

**tokisangames** - 2024-02-04 11:53

Yes, thanks. Hopefully it will help to expand the community

---

**p.uri.tanner** - 2024-02-04 11:53

I won't. Complaining is shit. Devs are working for free. There is a structural issue foremost with Godot not having a marketplace that values devs.

---

**p.uri.tanner** - 2024-02-04 11:53

All will be good in due time.

---

**pandelfd** - 2024-02-04 13:00

Getting these weird seams near the vertex grid when there's a big elevation change (flattened a small area to show it's not visible on flat surfaces) gonna see if i can reproduce it on a new project

📎 Attachment: Captura_de_ecra_de_2024-02-04_11-53-44.png

---

**mrpinkdev** - 2024-02-04 13:06

can i somehow split my terrain into few different terrains?

---

**tokisangames** - 2024-02-04 13:09

See issue #185

---

**tokisangames** - 2024-02-04 13:09

We have multiple levels in scenes, each with their own terrains. Slice your images how you see fit. You can import and export as needed.

---

**pandelfd** - 2024-02-04 13:21

Thank you! For now i'll just avoid big elevation shifts near the vertex grid but it's nice to know that the issue's source has been identified and a workaround has been suggested if it ever turns into a unavoidable issue.

---

**mrpinkdev** - 2024-02-04 13:25

is that worth doing performance wise? I thought Terrain3D's region system kinda handles that by itself

---

**mrpinkdev** - 2024-02-04 13:26

i have 5X4 regions terrain, each region is 1024x1024

---

**tokisangames** - 2024-02-04 13:28

It's up to you to test and decide based on your target platform. There is no streaming. So do you need 20 regions in VRAM simultaneously or not?

---

**mrpinkdev** - 2024-02-04 13:28

i don't 🥲

---

**tokisangames** - 2024-02-04 13:28

You can also cover with foliage and objects.

---

**mrpinkdev** - 2024-02-04 13:39

what am i doing wrong with the export?  a lot of height data is lost, and the color map is completely blank

📎 Attachment: image.png

---

**tokisangames** - 2024-02-04 13:41

What settings did you input? It works for perfect round trips with the right formats like exr for height, and png for color map and whatever the docs say for control png or exr. Did you read the export documentation? You aren't using color map unless you've painted the terrain.

---

**mrpinkdev** - 2024-02-04 13:45

height is exr, color is png and there's some hand painted stuff, export path is C:\@gamedev\godot_stuff\terrain_height.exr
is there something else i'm missing?

---

**tokisangames** - 2024-02-04 13:55

Since it's not working, I would say yes. Start with one at a time. Height. How did you determine that a lot of the data is lost? Did you export and reimport it to Terrain3D and see it's lost? Or are you looking at a non-normalized image in program like photoshop that expects it to be [0,1] normalized and is blowing out all values above 1?

---

**mrpinkdev** - 2024-02-04 13:58

🫠 got it, thanks!

---

**thelordofman** - 2024-02-04 17:08

Hi, really sorry to bother you about this, but I'm currently using set_height to modify the terrain in runtime (and using set_collision_enabled(true/false) to update collision).  I can only get sharp artificing of terrain points if I try to do anything that's not rectangular and aligned to the world grid. I'm iterating over individual coordinates, is there perhaps a way to edit a range from Vector3 to another Vector3?  Or is there the possibility of having runtime access to the Raise, Lower, Flatten, etc tools? I've looked into the source and don't see anyway to do this, or am I just be being stupid.

---

**tokisangames** - 2024-02-04 20:23

With the caveat that this isn't designed for runtime manipulation and you should use Zylann's voxel tools if you want destructible terrains, the editor is a gdscript "game" running in realtime in the engine. So you have an example of how to operate the editing system in gdscript at runtime. Start reading at editor.gd.

> I can only get sharp artificing of terrain points if I try to do anything that's not rectangular and aligned to the world grid. I'm iterating over individual coordinates, 

I don't know what you mean by these statements. 

> is there perhaps a way to edit a range from Vector3 to another Vector3?

v0.9.1-dev has a slope sculpting tool that does exactly this, which I [demonstrated on twitter](https://x.com/TokisanGames/status/1750627284204294177?s=20)

---

**thelordofman** - 2024-02-04 20:26

Amazing, thank you so much, didn't realise about editor.gd!

---

**psartech** - 2024-02-05 13:14

Good afternoon, I'm using Terrain 3D with WorldMachine and I have two issues:
1. Export as r16 gives a weird output, as if the files is not read properly (Image 1 is WM render, Image 2 is in Godot Terrain3D importer)
2. When setting a R16 Size larger (for 4 tiles for instance, to be accurate to my desired world size. See Image 3), the output is not what I could expect.

I'm a newbie to both Terrain3D and WorldMachine 🙂
Any help is appreciated ❤️

📎 Attachment: World_Machine64_ufEyqutcgA.png

---

**psartech** - 2024-02-05 13:14

Note: export is correct when imported as an exr file in Terrain3D importer
Note 2: I'm using Godot 4.2, Terrain 3D 0.9.0-beta, WorldMachine 4031.2, And I can join WM files (Godot project files are mostly empty)

---

**tokisangames** - 2024-02-05 13:18

The dimensions you're inputting into our importer must be wrong. You can import r16 into Krita and verify your settings.

---

**psartech** - 2024-02-05 13:23

That was exatly that. I misunderstood the R16 Size setting. Thanks a lot <@455610038350774273> 
Also, I need to import regions one by one ? because WorldMachine doesn't support tiled export for indie users. So I'd need to split it into 16 images If I want 16 regions, right ?

---

**tokisangames** - 2024-02-05 13:24

You can import any size up to 16k. So do them individually or combine in photoshop and import

---

**psartech** - 2024-02-05 13:25

I understand. Thanks again ! Have a great day

---

**fringesci** - 2024-02-05 13:32

hey, just started messing with the plugin and it's really good so far
I just have one problem which is that the terrain I'm making is coming out really bumpy despite using the brush that looks like it's supposed to be a smooth circle gradient

---

**fringesci** - 2024-02-05 13:33

I can get it smooth using the smooth tool afterwards, but that's really annoying for what I'm doing

---

**fringesci** - 2024-02-05 13:33

I'm trying to recreate the skiing mechanic from the tribes games, so I need really smooth hills for the gameplay to work

---

**fringesci** - 2024-02-05 13:34

~~I played with the jitter setting and it doesn't seem to do anything~~

---

**tokisangames** - 2024-02-05 13:36

What does bumpy mean? You can see plenty of smooth sculpting in the demo and tutorial videos.

---

**fringesci** - 2024-02-05 13:39

bumpy as in the geometry has a bunch of little bumps in it, I'll see if I can take a screenshot to help show what I mean

---

**fringesci** - 2024-02-05 13:39

*(no text content)*

📎 Attachment: image.png

---

**fringesci** - 2024-02-05 13:39

see how there's a sort of grit to it?

---

**fringesci** - 2024-02-05 13:39

if I use the smooth tool it goes away

---

**fringesci** - 2024-02-05 13:39

*(no text content)*

📎 Attachment: image.png

---

**fringesci** - 2024-02-05 13:40

it seems like the brush has a texture to it, despite just being a round gradient from the look of it

---

**fringesci** - 2024-02-05 13:41

if I was doing more traditional movement then it probably wouldn't be that big a deal, but for skiing it messes things up

---

**fringesci** - 2024-02-05 13:42

cause it effects the collision geometry

---

**tokisangames** - 2024-02-05 13:43

I have not experienced that. You're using the default brush?
All of the brushes are EXRs. You can evaluate if any of them have noise or replace them.

---

**fringesci** - 2024-02-05 13:43

just using the default circle brushes

---

**fringesci** - 2024-02-05 13:48

yeah, looking at it in krita it might have a slight graininess to it

---

**fringesci** - 2024-02-05 13:49

part of it might just be that blowing it up to the max size causes it to be pixely, some of these brush textures are only 100x100px big

---

**fringesci** - 2024-02-05 13:54

made a brush in krita that was 1024x1024 and that seems to have done the trick

---

**tokisangames** - 2024-02-05 13:59

In v0.9.1-dev you can set a higher than max brush size

---

**fringesci** - 2024-02-05 14:00

🤙

---

**fringesci** - 2024-02-05 14:12

actually it still might have that bumpiness to it, hmm

---

**fringesci** - 2024-02-05 14:13

going to experiment with something

---

**psartech** - 2024-02-05 16:35

Just to make sure, I have textures from Poliigon with these files:
- AO: Ambien Occlusion
- BUMP: Bump map
- COL: Color / Albedo
- DISP: Displacement
- GLOSS: Gloss map (Inverse of roughmap)
- NRM: Normal map
- RFL: Reflection

So for the texture packer:
- Albedo: COL (Color/Albedo)
- Height Texture: BUMP ?
- Normal Texture: NRM
- Roughness: GLOSS but I must invert the green channel

Am I correct ? Thanks ^^'

---

**tokisangames** - 2024-02-05 16:40

Inverting green is only for directx normal maps. Invert the whole image for smoothness to roughness maps.
Height is probably displacement, but could be bump. Depends on their interpretation. Compare with the demo textures and what the material is, or try both.

---

**psartech** - 2024-02-05 16:41

Thanks 🙂 I'll try and update here, in case it helps someone

---

**lw64** - 2024-02-05 17:06

is there a difference between height and bump actually?

---

**lw64** - 2024-02-05 17:07

height can also be negative?

---

**tokisangames** - 2024-02-05 18:38

In some systems they are interchangeable. In this case of poligon one might be detail, the other height. Or they might be identical, under two names

---

**tokisangames** - 2024-02-05 18:39

No image can have negative color values.

---

**scramblejams** - 2024-02-06 01:21

Good evening all. I'm kicking Terrain3D's tires. I built from source from main latest (with precision=double, I'm waiting for it all to explode!), hoping to try the new channel packer tool, but I don't see it in the toolbar. User error, or am I waiting on something else to hit the repo?

---

**tokisangames** - 2024-02-06 06:20

Look at your console. Enable plugin. Restart twice. All in the docs.

---

**tokisangames** - 2024-02-06 06:34

Project settings / plugins

---

**scramblejams** - 2024-02-06 07:46

User error, then. Thanks. 🙂

---

**ysterklou** - 2024-02-06 07:53

Does Terrain3D support to check which texture a character is moving around on? ex, a sand and grass texture?

---

**tokisangames** - 2024-02-06 10:21

Storage.get_texture_id(). In the API and docs. `Latest` docs has more detail filled out

---

**ysterklou** - 2024-02-06 15:00

Thanks!

---

**esklarski** - 2024-02-06 22:49

I was thinking of trying this plugin with https://github.com/roalyr/godot-for-3d-open-worlds

Does this plugin need to be compiled with a double precision flag to support double precision in engine?

---

**basthepanda** - 2024-02-06 23:53

Hey! This might be a bit goofy and I hope I'm just being dumb here but my spray isn't working for me!

Tried to follow exactly how the tutorial said but I'm having two problems:

1. The texture of the overlay spray is locked to whatever Texture ID is set to 0 (did I miss a step or something??)

2. It doesn't seem to let me paint over the base texture; followed tutorial grass + path painted with paint base texture then tried spraying to blend but can't change texture or even spray over it!

Anyone know a fix or where I went wrong? I'm stumped :c

---

**tokisangames** - 2024-02-06 23:55

Of course. There's an issue that shares some info about double precision.

---

**tokisangames** - 2024-02-06 23:58

So you can't paint at all. Can you sculpt? Does the demo work? What OS and versions of Godot and Terrain3D?

---

**basthepanda** - 2024-02-07 00:03

Yeah! I can sculpt just fine and the demo works great, it's literally just the spray overlay thing! I can paint everything  normally with the paint base texture tool (even change the texture! literally everything normally)- but when I try to use the 'spray overlay texture' tool I can't spray over it, or change the texture! (I tried in the demo and it's weirdly happening there too!)

 Windows 11, Newest release of Terrain3D I believe, and Godot v4.2.1 (The newest one as well I think?) Perhaps that's where my issue comes from??

---

**tokisangames** - 2024-02-07 00:05

What exact version of Terrain3D? It says at the top of the inspector.
So you cannot spray in the demo?

---

**basthepanda** - 2024-02-07 00:07

0.9.0-beta!

The spray has the same issue in the demo! Only spraying whatever my texture ID 0 is set to and I can't overlay on base paint!

---

**tokisangames** - 2024-02-07 00:10

In the demo, Disable the autoshader. Select rock, paint a section with rock, even if it already appears there. Paint a line of grass.
Then spray grass along the edges to expand the grass.
What happens?

---

**basthepanda** - 2024-02-07 00:18

Wait! Totally my bad! It's definitely working fine- false alarm!

It just takes a solid five seconds to work and the other texture disappearing was confusing me a ton-

I honestly didn't expect such a quick response btw, thanks for helping so fast! And I wanted to give my appreciation to your guides, super helpful and pushing me through the rough world design phase!

---

**basthepanda** - 2024-02-07 00:19

we good wegood wegooddd goood

---

**tokisangames** - 2024-02-07 00:20

It shouldn't take 5 seconds to work. Perhaps your opacity is too low.

---

**zurichii** - 2024-02-08 09:15

I'm having a problem with the collision and I don't know how to solve it, for some reason the collision doesn't Update it's always flat and it doesn't update with the terrain, I'm using a version compiled using double precision

📎 Attachment: image.png

---

**tokisangames** - 2024-02-08 09:40

Yes, collision doesn't update automatically in the released version. Disable debug collision and reenable it to regenerate it. If you're only sculpting, you don't need debug collision on at all. It just slows your system while editing.

---

**zurichii** - 2024-02-08 09:43

The debug collision is only activated to take the screenshot, I have already tried deactivating and activating it again The collision does not update

---

**zurichii** - 2024-02-08 09:51

here you can see the video, even after running the game it doesn't work sometimes it doesn't even have the flat collision

📎 Attachment: 2024-02-08_06-48-36.mp4

---

**zurichii** - 2024-02-08 09:52

I have these errors in the log, could it be related?

📎 Attachment: image.png

---

**tokisangames** - 2024-02-08 09:53

Not only related but the problem.

---

**zurichii** - 2024-02-08 09:55

Is there any way I can fix it, or do I have to wait for an update?

---

**tokisangames** - 2024-02-08 09:55

We're using Terrain3D 0.9.0 and .1-dev on 4.2.1 stable and mono without issue. You can try a more recent dev build or build it from source

---

**tokisangames** - 2024-02-08 09:55

Are you using stock physics?

---

**zurichii** - 2024-02-08 09:55

yes

---

**tokisangames** - 2024-02-08 09:55

You're sure you're not using an out of date version of Jolt?

---

**tokisangames** - 2024-02-08 09:56

What's in your addons folder?

---

**zurichii** - 2024-02-08 09:57

I tried the Dev branch but the editor crashes when starting

I didn't change the physics and I don't know how to change it. Shouldn't it be the default?

---

**zurichii** - 2024-02-08 09:57

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-02-08 09:58

Our Terrain3d dev branch crashed?

---

**zurichii** - 2024-02-08 09:58

yes

---

**tokisangames** - 2024-02-08 09:59

Does the demo project work? for both the main release and whichever dev build you downloaded?
Which dev build commit do you have?

---

**tokisangames** - 2024-02-08 10:00

What console errors did you get when it crashed?

---

**zurichii** - 2024-02-08 10:01

The demo has the same problem The collision stays flat

I think the last commit I tried to compile 30 minutes
​

---

**zurichii** - 2024-02-08 10:03

engine closes before I can read the log, is there any other way to read the log?

---

**tokisangames** - 2024-02-08 10:05

Which exact version or github link did you use for the dev build?

---

**tokisangames** - 2024-02-08 10:06

Open a command line console on your system and run the project from there. All OSes have terminals. If godot crashes the command line based console will stay open. Godot has command line options.  This page describes how to get console information or look at logs. 
https://terrain3d.readthedocs.io/en/latest/docs/troubleshooting.html

---

**zurichii** - 2024-02-08 10:06

https://github.com/TokisanGames/Terrain3D/tree/main

---

**tokisangames** - 2024-02-08 10:08

Did you build this version yourself or downloaded the artifact from github actions?

---

**zurichii** - 2024-02-08 10:09

I compiled it myself, I don't know what github actions

---

**tokisangames** - 2024-02-08 10:09

https://terrain3d.readthedocs.io/en/latest/docs/nightly_builds.html

---

**tokisangames** - 2024-02-08 10:10

This error message suggests that the version of godot-cpp/gdextension that was compiled is incompatible with the version of the engine used. Or the physics library was replaced with an incompatible version (eg an old Jolt)

---

**tokisangames** - 2024-02-08 10:12

I would like you to download Godot 4.2.1 official non-mono, and the most recent nightly build from github. Then run the demo with those two versions and see what happens.

---

**zurichii** - 2024-02-08 10:18

It works in the official version, but I need to use it in the engine with double float

📎 Attachment: image.png

---

**zurichii** - 2024-02-08 10:20

.

---

**zurichii** - 2024-02-08 10:25

The version I used of godot-cpp was this
https://github.com/godotengine/godot-cpp/tree/godot-4.2.1-stable

And this was the engine version
https://github.com/godotengine/godot/tree/4.2.1-stable

---

**tokisangames** - 2024-02-08 10:27

Ok, I missed that part about doubles. Double support is experimental so you'll need to get your hands dirty with troubleshooting and probably fixing or implenting code, or reporting upstream bugs in godot-cpp or godot. Refer to our issue #30 and PR #232 for the progress that has been made. We can compile but no one has tested it yet to finish it. It looks like you've encountered a bug that is probably in godot-cpp.

---

**tokisangames** - 2024-02-08 10:29

We should not crash after being built with double support and that's a bug we can most likely fix on our end. But if HeightMapShape3D.set_map_data is broken we can't fix that. There may be a new API we need to use for doubles. Someone needs to research that in the API then and see what changed or what's not implemented.

---

**zurichii** - 2024-02-08 10:39

It's just crashing on the dev branch

so no solution?

I'll have to abandon the plugin for now, I hope there's a fix in the future, the plugin is very good, thanks for the help

---

**tokisangames** - 2024-02-08 11:00

We need logs or debugging to determine if the cause of the crash is in our plugin, godot-cpp, or godot engine.
It's an experimental feature. That means developers like yourself and all of us test, debug and fix code so that it works well. If you're not willing to troubleshoot and debug it, then the solution will wait until someone who needs double support is willing.

---

**zurichii** - 2024-02-08 11:17

I'm willing to do it, I just don't have the knowledge to do it, I don't know how to debug, I came from Unreal, the little knowledge I have in C++ is from there,

It took me 3 days to compile Godot because on the website it shows how to compile using a (~) On the command line in the Windows version even if (~) It is only used on Mac/Linux

---

**tokisangames** - 2024-02-08 11:26

The journey of game development is a long one and all effort invested into programming will continue to pay dividends throughout your entire career.

---

**tokisangames** - 2024-02-08 11:28

If you need double support for your game your options are build your own terrain system and/or engine, use another engine that already supports it, or take this existing infrastructure and improve it for your needs as other devs are doing.

However, this might not be the right plugin for you. Presumably if you need double support you're considering locations that are out 10s or 100s of units away from 0,0,0. However we have a current limit of 16k x 16k. That will likely expand later, but not any time soon unless someone implements it.

---

**tokisangames** - 2024-02-08 11:31

Inexperience isn't a problem. That's a short term issue that is always resolved by effort (experience). Unwillingness to learn or put out effort is the real problem many have. So you spent 3 days on a command line issue. NBD. I bet next time it will take you only 3 seconds to know what to do with a command.

---

**zurichii** - 2024-02-08 11:31

I have these errors when trying to use the Plugin in the Dev version

📎 Attachment: image.png

---

**tokisangames** - 2024-02-08 11:32

The only problem here is it says the gdextension library is not found. That means no dll was compiled and placed where it belongs.

---

**tokisangames** - 2024-02-08 11:33

There are probably more relevant errors on your console

---

**zurichii** - 2024-02-08 11:33

I don't need such a large landscape, I would only need the landscape in the initial area The rest of the map would be created Procedurally generated

---

**zurichii** - 2024-02-08 11:33

*(no text content)*

📎 Attachment: message.txt

---

**tokisangames** - 2024-02-08 11:34

Why do you need doubles then?

---

**tokisangames** - 2024-02-08 11:39

The console messages say the same. Terrain3D wasn't compiled, or the libraries weren't placed in the right spot.

---

**zurichii** - 2024-02-08 11:40

my game is multiplayer and generating dungeons far from the origin is not possible without double float

---

**zurichii** - 2024-02-08 11:40

I will try to recompile again

---

**zurichii** - 2024-02-08 11:51

I recompiled open the demo project
here is the engine log

📎 Attachment: message.txt

---

**tokisangames** - 2024-02-08 11:57

It still says the same thing. The error is clear:
> ERROR: GDExtension library not found:
If you are building successfully, then the .dll files you are creating are not being placed in the directory specified by the file it mentions. Look inside that file and make sure your file system matches its contents.
> res://addons/terrain_3d/terrain.gdextension

---

**zurichii** - 2024-02-08 12:02

The files are there

📎 Attachment: image.png

---

**tokisangames** - 2024-02-08 12:02

What's in the bin directory? terrain.gdextension gives the exact paths to the .dll files yet godot can't find them.

---

**tokisangames** - 2024-02-08 12:03

Library means `.dll` file.

---

**tokisangames** - 2024-02-08 12:06

To resolve the crash the direction we're heading in is:
* Complete your build environment setup so you can build and load it in godot.
* Run godot on the command line with verbose and terrain3D debugging and see where it has an issue. If that's not clear
* Compile terrain3d with debug symbols and debug it in MSVC to see where exactly it crashes and under what conditions.
There are a lot of learning opportunities for you if you're willing.

---

**zurichii** - 2024-02-08 12:08

When I compile using version 9.0 beta I have these files

📎 Attachment: image.png

---

**zurichii** - 2024-02-08 12:08

When I compile the dev version I only have these

📎 Attachment: image.png

---

**zurichii** - 2024-02-08 12:14

Log that I sent above is already used terrain3d debugging, the log does not work for me in the dev version

---

**tokisangames** - 2024-02-08 12:17

That's because you are building for the release target. Specify the debug target on the scons command line (the default)
https://terrain3d.readthedocs.io/en/latest/docs/building_from_source.html#build-the-extension

---

**tokisangames** - 2024-02-08 12:18

No, Godot and Terrain3D can provide 100x more logging. But you have to build properly first.

---

**tokisangames** - 2024-02-08 12:19

What godot-cpp commit are you on? Go into the directory and type `git log` and report the first line

---

**zurichii** - 2024-02-08 12:25

PS Z:\Terrain3D> git log
commit bc660a30aa4233234ae2c31b10cf44e60ddc4642 (HEAD -> main, origin/main, origin/HEAD)
Author: Cory Petkovsek <632766+TokisanGames@users.noreply.github.com>
Date:   Thu Feb 1 21:06:19 2024 +0700

    Update docs

commit 8f0aaa25fd172d77e51dd75bbd97f4ef689a229f
Author: Cory Petkovsek <632766+TokisanGames@users.noreply.github.com>
Date:   Thu Feb 1 04:02:45 2024 +0700

    Update docs

commit b7719114c2f2278bd02dbd10322560c67cbe7dd2
Author: Cory Petkovsek <632766+TokisanGames@users.noreply.github.com>
Date:   Tue Jan 30 18:48:44 2024 +0700

    Update build scripts

commit 46b86acbb547197a6ca744e258fe05601a4bca81
Author: Cory Petkovsek <632766+TokisanGames@users.noreply.github.com>
Date:   Tue Jan 30 18:41:29 2024 +0700

    Update build scripts

commit f08e813b0a924c577bcedd31c551527b1386e348
Author: Cory Petkovsek <632766+TokisanGames@users.noreply.github.com>
Date:   Tue Jan 30 18:37:49 2024 +0700

    Update build scripts

---

**zurichii** - 2024-02-08 12:27

I managed to compile and make the dev version work, but it has the same collision problem

📎 Attachment: image.png

---

**zurichii** - 2024-02-08 12:39

I used the command line godot.windows.editor.double.x86_64.mono.console.exe -e --terrain3d-debug=DEBUG As you can see in the screenshot But there is no log

📎 Attachment: image.png

---

**tokisangames** - 2024-02-08 12:51

What is the first line of `git log` within the godot-cpp directory.

---

**tokisangames** - 2024-02-08 12:52

This won't work until the heightmapshape error is addressed, which is likely caused by a version mismatch as mentioned.

---

**tokisangames** - 2024-02-08 12:55

Try updating godot-cpp to the 4.2.1 tag, whatever it is called. You're probably on 4.1.3, which is fine for most but you have an issue now.
https://terrain3d.readthedocs.io/en/latest/docs/building_from_source.html#identify-the-appropriate-godot-cpp-version

---

**tokisangames** - 2024-02-08 12:56

The command line debugging not working is an issue we'll have to look at.

---

**zurichii** - 2024-02-08 13:03

PS Z:\godot-cpp> git log
commit 78ffea5b136f3178c31cddb28f6b963ceaa89420 (HEAD -> 4.2, tag: godot-4.2.1-stable, origin/4.2)
Author: Rémi Verschelde <rverschelde@gmail.com>
Date:   Tue Dec 12 13:48:47 2023 +0100

---

**tokisangames** - 2024-02-08 13:36

`set_map_data` is expecting a `Vector<real_t>` aka a `PackedFloat32Array`.
https://github.com/godotengine/godot/blob/41564aaf7708b0bf594f745dd2448a54dd687cc5/scene/resources/height_map_shape_3d.h#L54

That's what we are sending it and it works fine in 32-bit float mode
https://github.com/TokisanGames/Terrain3D/blob/bc660a30aa4233234ae2c31b10cf44e60ddc4642/src/terrain_3d.cpp#L395
https://github.com/TokisanGames/Terrain3D/blob/bc660a30aa4233234ae2c31b10cf44e60ddc4642/src/terrain_3d.cpp#L302

In double mode we have a lot of `real_t` variables that get compiled as doubles. However from L302 to L395 above, we're not using any `real_t` or doubles (nor even floats for that matter). 

The first godot link above `Vector<real_t>` is converted to `Vector<double>` in a double build. And `PackedFloat64Array` does exist. So you could try making map_data a `PackedFloat64Array` on L302. Any values assigned should convert seamlessly.

---

**tokisangames** - 2024-02-08 13:39

I'm not sure if that will build. The error refers to `godot-cpp\gen\src\classes\height_map_shape3d.cpp:70`. Line 68, which is a generated file. On my system it looks like this:
```
void HeightMapShape3D::set_map_data(const PackedFloat32Array &data) {
```
Which won't work with Godot expecting a `Vector<double>` aka `PackFloat64Array`, nor you changing map_data to the latter. However since it is a generated file, your version might already have the PackedFloat64Array in it, in which case changing map_data will work. 

So look in at your `HeightMapShape3D::set_map_data` and see what it says. And try changing map_data type and we'll see what happens.

---

**zurichii** - 2024-02-08 14:04

Z:\Projetos\Godot\Terrain3D\Terrain3D-main\Terrain3D-main>scons precision=double
scons: Reading SConscript files ...
Auto-detected 32 CPU cores available for build parallelism. Using 31 cores by default. You can override it with the -j argument.
Building for architecture x86_64 on platform windows
scons: done reading SConscript files.
scons: Building targets ...
scons: `godot-cpp\bin\libgodot-cpp.windows.template_debug.double.x86_64.lib' is up to date.
cl /Fosrc\terrain_3d.windows.template_debug.double.x86_64.obj /c src\terrain_3d.cpp /TP /std:c++17 /nologo /utf-8 /MT /O2 /DHOT_RELOAD_ENABLED /DTYPED_METHOD_BIND /DNOMINMAX /DWINDOWS_ENABLED /DDEBUG_ENABLED /DDEBUG_METHODS_ENABLED /DNDEBUG /D_HAS_EXCEPTIONS=0 /DREAL_T_IS_DOUBLE /Igodot-cpp\gdextension /Igodot-cpp\include /Igodot-cpp\gen\include /Isrc
terrain_3d.cpp
src\terrain_3d.cpp(395): error C2664: 'void godot::HeightMapShape3D::set_map_data(const godot::PackedFloat32Array &)': não é possível converter um argumento 1 de 'godot::PackedFloat64Array' em 'const godot::PackedFloat32Array &'
src\terrain_3d.cpp(395): note: Razão: não é possível converter de 'godot::PackedFloat64Array' para 'const godot::PackedFloat32Array'
src\terrain_3d.cpp(395): note: Nenhum operador de conversão definida pelo usuário disponível que possa realizar esta conversão, ou o operador não pode ser chamado
godot-cpp\gen\include\godot_cpp/classes/height_map_shape3d.hpp(55): note: consulte a declaração de 'godot::HeightMapShape3D::set_map_data'
src\terrain_3d.cpp(395): note: ao tentar corresponder a lista de argumentos '(godot::PackedFloat64Array)'
scons: *** [src\terrain_3d.windows.template_debug.double.x86_64.obj] Error 2
scons: building terminated because of errors.

---

**tokisangames** - 2024-02-08 14:31

So that means on your system `godot-cpp\gen\src\classes\height_map_shape3d.cpp:68` says `PackedFloat32Array`? That means you've discovered a bug in godot-cpp that needs to be reported on that repository.

---

**tokisangames** - 2024-02-08 14:32

And that's what it asked you to do here: https://discord.com/channels/691957978680786944/1130291534802202735/1205088756349145098
However, we've now confirmed it by looking at the source code.

---

**tokisangames** - 2024-02-08 14:33

As I said, you can try making godot-cpp `void HeightMapShape3D::set_map_data(const PackedFloat32Array &data)` receive a 64 bit and have our map_data provide one and see if that works. But the permanent fix is through filing a godot-cpp issue.

---

**zurichii** - 2024-02-08 14:48

Do you mean for me to edit the file cpp\gen\src\classes\height_map_shape3d.cpp

If so, I already tried, it didn't work
Compiled normally but the terrain remains flat

---

**tokisangames** - 2024-02-08 14:49

Yes. Does it produce the same message or is it different?

---

**zurichii** - 2024-02-08 14:49

The same message

---

**tokisangames** - 2024-02-08 14:50

Ok. Then the only step forward is filing an issue on the godot-cpp repo unless you want to step through and debug godot-cpp code yourself.

---

**tokisangames** - 2024-02-08 14:53

Include the commit versions of everything, your build command lines, your error messages, what we did for troubleshooting godot-cpp. Then tag me or send the link here. They won't care if the Terrain3D heightmap shape is flat. They'll care that the function isn't being bound properly as the message states.

---

**zurichii** - 2024-02-08 15:11

I don't know where to report the bug

---

**tokisangames** - 2024-02-08 15:12

The godot-cpp repo
https://github.com/godotengine/godot-cpp/issues

---

**zurichii** - 2024-02-08 16:34

https://github.com/godotengine/godot-cpp/issues/1386

---

**thelordofman** - 2024-02-09 12:38

I've looking into the editor.gd and all of the component files, as well as more diving into the actual cpp source code however this is the best I've been able to come up with, 

In theory it should have the same properties as a correct function call, however it simply freezes and nothing I do (besides removing operate, which defeats the purpose) will make it unfreeze. I've seen nothing in the operate cpp function which should be causing this so wonder if there's an obvious set-up step which I'm missing? I know the reload section at the bottom works as I've had success with it and set_height, however that has the drawbacks mentioned in my previous question.

All I want to do is allow the player to flatten the ground below them (in this demo I'm hard coding location and height for simplicity) and I really love this tool, hence the hesitation to move to Zylann voxel system.  I was also wondering if this kind of modification could ever become a supported feature in the far future/ down the road, or if it's definitely off the table for the long run.

Again I hugely appreciate any help

---

**thelordofman** - 2024-02-09 12:42

Also I know this implementation is really suboptimal, I'm just trying to get it to work for now 😅

I should also add the script is attached to the Terrain node itself, hence self in set_terrain

---

**thelordofman** - 2024-02-09 12:43

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-02-09 16:16

If I wanted to edit the terrain in a circle around the player, I'd get the height maps the player is on, edit the pixels to draw a circle on them, and push the region map back into storage. Mimicking brushing is a viable option, but a bit indirect. Since it's not working for you might as well go direct. Carefully review the API. Read the latest docs for more completeness.

---

**thelordofman** - 2024-02-09 16:26

Oh I see set_pixel now! Sorry and much appreciated!

---

**tokisangames** - 2024-02-09 19:24

get_map_region or get_maps are the most direct way. set_pixel works, is easier, but a little slower.

---

**skilning** - 2024-02-09 22:51

I'm having an off night, and I know the answer to this is probably REALLY simple, but...in the CodeGenerated example, why is it using a for-loop, set_pixel, and get_noise2d to create an image in Image.FORMAT_RF instead of just using noise.get_image and then converting the format in-place? I tried it, and it doesn't work, I just don't grok why.

---

**skilning** - 2024-02-09 22:52

Yep...I'm just dumb. Didn't notice the `*0.5` in the loop.  Using get_image2d just creates a higher block of terrain. 🤦

---

**thelordofman** - 2024-02-10 00:06

Thanks so much, I've got it all working now.

As you mention in the docs the only thing causing a slowdown is the collision re-gen. Just thinking, how possible/difficult would it be to generate a second collision mesh as an async function in the background over 1-3 seconds (with hardware usage limits to avoid stuttering) and then just swapping over the meshes? For minor operations which are infrequent, which seem like the most likely use-cases, that seems like the most realistic option. 
I am talking out of my ass here, I have no idea how hard that would be or if it's even possible.

---

**skellysoft** - 2024-02-10 03:52

Is there a way to cut q piece of the terrain itself out? like as a mesh?

---

**tokisangames** - 2024-02-10 04:59

Just wait for PR #278. And since your game is dependent on terrain, spend more time with the copious amount of information available in the project. The docs, the API, the pending PRs and issues. I haven't shared anything with you that hasn't been readily available.

---

**tokisangames** - 2024-02-10 05:01

You can export the maps in the importer. You can generate a mesh in tools. The mesh is suitable only for reference unless you retopologize it (in blender).

---

**tokisangames** - 2024-02-10 05:05

Noise.get_image produces an RGBA8 file. 8-bit gradations on a heightmap looks like garbage. That code produces 32-bit noise.

---

**tokisangames** - 2024-02-10 05:07

Did you try regenerating the bindings? Stay on that ticket or it will lose interest and momentum. By the way, you are Op.

---

**skellysoft** - 2024-02-10 07:54

Hmm, okay. I read something online about being able to generate a limited NavMesh region by adjusting the AABB of the NavigationRegion as an offset because I don't really know if baking the entire map is a great solution? Esp with how wasteful itd be...

---

**tokisangames** - 2024-02-10 08:52

Generating a nav mesh and a mesh are two different things. Our docs have a page on navigation. We just pass the painted geometry to the nav server that generates the nav mesh. So ours and all Godot nav docs from 4.x are important to review.

---

**zurichii** - 2024-02-10 08:54

I'm sorry, I didn't expect you to talk to me here, I didn't try, how do I do that?

---

**skellysoft** - 2024-02-10 08:54

Oh no, I'm aware of that - but my idea was that if it were possible to generate a limited navmesh region by cutting out part of the terrain and the  just baking *that* and its associated scenes, yeah.

However, I'll go look at the Navigation pages. Thanks 🙂

---

**tokisangames** - 2024-02-10 09:08

Read the ticket. I responded and gave you direction and link.

---

**tokisangames** - 2024-02-10 09:09

The nav page already documents how to generate multiple nav meshes.

---

**zurichii** - 2024-02-10 09:12

You want to say that, I'll try

📎 Attachment: image.png

---

**tokisangames** - 2024-02-10 09:14

Yes. You are Op. "original poster". Those directions are for you

---

**zurichii** - 2024-02-10 09:15

Sorry, I'm not a native English speaker, I didn't know what op means

---

**darylvincent** - 2024-02-10 09:24

First off hi -- loving Terrain3D, thank you so much for sharing it!

I've got png textures working on Windows, but not on Android... are there any specific different steps to get them working on Android? (textured one is Windows, checkered one Android -- same build)

ignore the waves in the background -- they're different shaders per platform

📎 Attachment: image.png

---

**tokisangames** - 2024-02-10 10:01

Android is experimental. Use 0.9.1-dev with GD4.2.1 and review the mobile page in the latest docs. If it still doesn't work be prepared to invest time to troubleshoot and experiment.

---

**darylvincent** - 2024-02-10 10:24

Thanks, will do!

---

**thelordofman** - 2024-02-10 13:22

I got it working with set_height before coming on here, which is what I thought you meant in the docs, because you didn't mention any methods directly and because 95% of the methods and attributes in the docs are missing descriptions. 

I'm sure it's all obvious if you've made the system, but lots of people can't and shouldn't have to learn the whole thing and look over every pending issue to understand the project to a reasonable level. That's what docs are for.

Again, I really do appreciate the help, it's what makes projects like this so great, but it's just silly to leave the docs barren and then get annoyed when people ask you things which should have been in the docs.

---

**tokisangames** - 2024-02-10 13:34

Change to the latest docs and you'll see everything filled out. 
I'm not annoyed.
My recommendation was given due to your lack of familiarity with what is available in the project. It wasn't a dig at you. It just makes business sense that if you're basing your game studio on a dependency, that the time you invest in learning about it pays great dividends in accelerated progress and efficiency.

---

**thelordofman** - 2024-02-10 13:44

Shit, my bad, I had no clue about the version control of the docs, thanks. 

Yeah sorry, I totally misread the vibe, I'll take your advice and keep digging deeper.

Much appreciated Cory, thank you.

---

**skellysoft** - 2024-02-10 13:51

So it does! My apologies. 

I'm still not using the latest version of Terrain3D, so I didn't see this. I would upgrade, but a large amount or stuff in my current build is dependant on Scatter not being broken with Terrain3D, and I understand theres been some issues (I know that's HungryProtons wheelhouse, not your's!)

---

**tokisangames** - 2024-02-10 13:51

No problem, all good. 👍

---

**zurichii** - 2024-02-10 13:51

It seems to have worked by making the bindings from the double precision executable

---

**tokisangames** - 2024-02-10 13:52

We're using the latest scatter and the latest dev Terrain3D without issue. Scatter in the asset library is broken/out of date.

---

**tokisangames** - 2024-02-10 13:52

Collision lines up properly and works lifting up the player?

---

**skellysoft** - 2024-02-10 13:54

OHHHH It's just that version? well thats brilliant news! 

So all the navmesh islands, theyre baked seperately, yeah? Actually.... why am I even asking, lemme go check the docs haha

---

**zurichii** - 2024-02-10 13:55

Yes, everything seems to be working as it should.

📎 Attachment: image.png

---

**tokisangames** - 2024-02-10 13:55

Yes, the docs. Thank you. I'm not the resident expert on navigation. I've never navigation and didn't build the generator.

---

**tokisangames** - 2024-02-10 13:56

Great news. We learned some things. Make sure to report it, thank thousandsofsuns and close your ticket. I'll make a note on our doubles ticket that the bindings need to be regenerated.

---

**skellysoft** - 2024-02-10 13:57

Its okay, I'm just a little out of the loop. I'm actually quite used to using navigation meshes in Godot so once Ive got Terrain3D updated so it can do the regions I should have no issues 🙂

---

**tokisangames** - 2024-02-10 14:23

Can you confirm that these are the only steps you needed to get it working properly?
* Build Godot with `scons precision=double`
* Regenerate godot-cpp bindings with this new executable
* Build Terrain3D (and thus godot-cpp) with `scons precision=double custom_api_file=YOUR_CUSTOM_FILE`

Please continue to let me know how it's working as you continue to build out your game. Issue #30 was completed but looking for a tester. You're the first person to actually test it in any capacity so now I'm closing this ticket. https://github.com/TokisanGames/Terrain3D/issues/30

cc <@199046815847415818>

---

**zurichii** - 2024-02-10 15:23

I build godot with the command line (scons precision=double) Also using C#, I don't know if it interferes with anything, I regenerated the bindings with a double precision executable, then I manually build godot-cpp with the command line (scons precision=double custom_api_file=YOUR_CUSTOM_FILE), I didn't use the command line (bits=64), As the site said, it always caused an error in the compilation, after having build godot-cpp , I build Terrain3D with a command line ( scons precision= double), I don't build the 2 together, I first build godot-cpp then I build Terrain3D, I don't know if it works to build the 2 together
​

---

**tokisangames** - 2024-02-10 15:25

Thank you. You should be able to build Terrain3D and godot-cpp with the custom api file simultaneously.

The bits=64 (where supported) is for if you want to make a 32-bit or 64-bit executable (eg Windows 11 64-bit), which has nothing to do with double precision floats.

---

**skilning** - 2024-02-10 21:00

Yeah, I noticed that pretty quickly. 😄

---

**skilning** - 2024-02-10 21:04

I'm a little confused about the second parameter to Terrain3DStorage.import_images. It says it's global offset, but no matter how I tweak the vector I pass in, it doesn't seem to change the location of the section.

---

**tokisangames** - 2024-02-10 21:09

The docs explain values

https://terrain3d.readthedocs.io/en/latest/api/class_terrain3dstorage.html#class-terrain3dstorage-method-import-images

You should look at the code directly if things don't work the way you expect
https://github.com/TokisanGames/Terrain3D/blob/bc660a30aa4233234ae2c31b10cf44e60ddc4642/src/terrain_3d_storage.cpp#L689

---

**skilning** - 2024-02-10 21:10

Thanks, I'll take a look at the code. I guess there's some sort of translation between "region space" and Godot world space that I'm missing.

---

**skilning** - 2024-02-10 21:14

Ah HAH!  There it is in the comments:

📎 Attachment: image.png

---

**skilning** - 2024-02-10 21:14

"Rounded down to the nearest region_size multiple" is the bit that wasn't in the HTML docs. (Or that I missed in the HTML docs.)

---

**skilning** - 2024-02-10 21:55

I don't see anything about this in the docs, so maybe someone here will know. Is there a technical reason you can't reposition a Terrain3D node by using its transform, or was it just not part of the intended use case?

---

**tokisangames** - 2024-02-10 22:36

Being a clipmap terrain, the mesh is moved constantly by the shader. See system architecture. The node transform is unused and irrelevant.

---

**skilning** - 2024-02-10 22:37

Yeah, I grok the way the clipmap works. I was hoping I could fake infinite terrain regions by re-centering the terrain's origin and shuffling the regions.

---

**skilning** - 2024-02-10 22:37

Basically have my cake and eat it, too, with the chunk-based terrain concept. 🙂

---

**skilning** - 2024-02-10 22:38

But as I've thought about it, I'll run into floating point precision problems there, anyway. So I'm currently just playing with hot-swapping region images to see if this is even feasible.

---

**tokisangames** - 2024-02-10 22:39

We load multiple terrain data files behind loading screens. Even though our largest is only 2k, since we already use a ton of vram from so many mesh textures

---

**skilning** - 2024-02-10 22:43

Not sure that's relevant to the idea I'm playing with, but I'll keep it in mind, thanks!

---

**stakira** - 2024-02-11 03:02

It's entirely possible to just feed a uniform to offset the terrain. Personally I don't think it's a unreasonable ask.

---

**tokisangames** - 2024-02-11 05:49

Yes, plus an offset for collision could be added. However we have a limit of 16k x 16k so infinite terrain `regions` is not possible. 90k or 180k is.

---

**tokisangames** - 2024-02-11 07:54

That's for add_region. It receives any location and internally rounds it down to the region_size multiple. Eg. adding a region at 1500,1500 is the same as adding it at 1024, 1024.
 I'll add those notes to the html docs.

---

**skilning** - 2024-02-11 15:32

Yep, I've seen that. My current idea is to treat the region maps like the chunks from a chunk-based system. When the player is more than 1/2 way from the map's origin, then:

- Loop through the region heigtmaps and adjust their origins opposite the player's offset
- Any region that's out of bounds for the clipmap, discard and add a new one on the opposite side
- Warp all of the other actors back to Godot's worldspace origin with their current relative offsets

Just haven't had the time to actually implement it yet to see if it's even feasible performance-wise without hacking your source code to the point that I'm better off writing my own. 😄 Real life keeps throwing obstacles to my coding time.

---

**dimaloveseggs** - 2024-02-11 17:18

<@455610038350774273> hey so is there another addot to place grass trees ect that has more controll , basically painting it by hand istead of the proton scatter?

---

**tokisangames** - 2024-02-11 17:19

Look at project status in the docs

---

**dimaloveseggs** - 2024-02-11 19:16

This? So it would be wiser to wait for the implementation you mean?

📎 Attachment: image.png

---

**tokisangames** - 2024-02-11 19:17

The project status described 4 options for you if you don't want to wait. However most likely foliage will exist in the tool long before you finish your project.

---

**dimaloveseggs** - 2024-02-11 19:19

Alright ill wait there of course thank you for your great work so far the base terrain functions work great on the december build and it enabled me to test and work on my players mechanics animations and such so good job keep it up!!!

---

**denismvp** - 2024-02-11 20:10

Hello everyone! one question, I am trying to set up navmesh with terrain 3D. But I am failing to add existing 3D objects on the nav mesh, how could I approch this?

---

**davkey** - 2024-02-12 16:13

||Hi I am new here!|| I am using this script to generate a terrain on startup and I have I have 3 questions:
1.How can I generate Biomes?
2.How can I place structures, buildings, and other things depending on the biomes?
3.How can I generate caves?

This is my script:
```extends Node

@export var noise : FastNoiseLite

func _ready():
    if has_node("RunThisSceneLabel3D"):
        $RunThisSceneLabel3D.queue_free()
    
    # Create a terrain
    var terrain := Terrain3D.new()
    terrain.set_collision_enabled(false)
    terrain.storage = Terrain3DStorage.new()
    terrain.texture_list = Terrain3DTextureList.new()
    terrain.name = "Terrain3D"
    add_child(terrain, true)
    terrain.material.world_background = Terrain3DMaterial.NONE
    
    # Generate 32-bit noise and import it with scale
    var noise := FastNoiseLite.new()
    noise.frequency = 0.005
    var img: Image = Image.create(1024, 1024, false, Image.FORMAT_RF)
    for x in 1024:
        for y in 1024:
            img.set_pixel(x, y, Color(noise.get_noise_2d(x, y)*0.5, 0., 0., 1.))
    terrain.storage.import_images([img, null, null], Vector3(-1024, 0, -1024), 0.0, 300.0)

    # Enable collision. Enable the first if you wish to see it with Debug/Visible Collision Shapes
#    terrain.set_show_debug_collision(true)
    terrain.set_collision_enabled(true)
    
    # Retreive 512x512 region blur map showing where the regions are
    var rbmap_rid: RID = terrain.material.get_region_blend_map()
    img = RenderingServer.texture_2d_get(rbmap_rid)

        

```

---

**tokisangames** - 2024-02-12 16:25

Objects on the mesh? We only generate a mesh based on the area you painted, and send it to the godot navigation server to generate the nav mesh. We have a page in the docs that talks about the extent of what we do and where to go for help. The Godot Navigation server creates the navmesh and utilizes it, so all of the godot docs and tutorials should be your guide.

---

**tokisangames** - 2024-02-12 16:28

This looks like my script, CodeGenerated.gd
* What is a biome? To a computer, that is. The answer is nothing. You need to define that concept and create the logic around what that means in regards to textures, assets, and placement logic.
* We don't provide caves. This is a heightmap terrain. We provide the ability to make holes in it. Make a cave in blender, or get rock assets from an asset store, and place them inside of godot. Then position them so they fit over the holes as I did in the demo.

---

**davkey** - 2024-02-12 16:30

okay, let's leave caves out of the picture, however by biomes, I mean how can I create random areas of the mesh and (for example) paint them a random color?

---

**tokisangames** - 2024-02-12 16:37

You're asking very high level questions that a programmer would then break down into many smaller problems that can be addressed one at a time. I can't teach you how to program here. You need to design the whole thing in your head or on paper. Then tackle each aspect, breaking it down into smaller problems until you can figure out each one, and then implement it. Doing this design, breakdown, and implementation you'll become a better programmer.

A very basic way to create random areas, I would generate a noise map, then assign certain values of luminosity to certain biome areas (e.g. near black, middle grey, near white ).
With that "biome" definition, I'd set textures, color map values, and meshes according to the noise map.

---

**davkey** - 2024-02-12 16:38

okay, that's fair, thanks!

---

**davkey** - 2024-02-12 17:00

How can I atleast generate a new reigon within the player's radius?

---

**tokisangames** - 2024-02-12 17:30

You can make regions with storage.add_region, documented in the API (look at the latest version). There's lots of documentation for you to become familiar with.

---

**tokisangames** - 2024-02-12 17:31

But if you want to have generated content, you'll likely want to use import_image instead of add_region, as shown in that CodeGenerated script.

---

**denismvp** - 2024-02-12 19:28

thansk so much for the help, Terrain3D just bakes the navmesh for its terrain. What I am wondering if there is a way to to have trees or objects in the scene to bake too

---

**denismvp** - 2024-02-12 19:28

thanks for your time and amazing tool!

---

**tokisangames** - 2024-02-12 19:31

You'll have to review the Godot docs to put in exclusion shapes, or unpaint them on the navigable areas.

---

**denismvp** - 2024-02-12 19:31

oh thats smart

---

**denismvp** - 2024-02-12 19:31

gonna look for both options

---

**denismvp** - 2024-02-12 19:32

thanks so much!

---

**skyrbunny** - 2024-02-14 01:58

Is saving terrains slow for anyone else?

---

**selvasz** - 2024-02-14 02:12

It takes 5 to 6 seconds for me

---

**skyrbunny** - 2024-02-14 02:15

ok so it's not just me

---

**skyrbunny** - 2024-02-14 02:15

alright I will need to design a faster saving method

---

**skyrbunny** - 2024-02-14 02:15

it's really frustrating for me...

---

**selvasz** - 2024-02-14 02:26

I have a low end laptop but every Saturday & Sunday i will go to my friend's house then work the higher process on his system

---

**selvasz** - 2024-02-14 02:28

How many regions are you currently having

---

**skyrbunny** - 2024-02-14 02:41

just 1

---

**skyrbunny** - 2024-02-14 03:36

hmm maybe i am wrong, since it is skipping the save. I think. Unless it's taking a long time to realize it hasnt changed

---

**skyrbunny** - 2024-02-14 03:45

still I need to figure out a git-compatible solution

---

**tokisangames** - 2024-02-14 03:49

Not if it's saved as a binary .res file. Saving 1 region I don't even notice.

---

**skyrbunny** - 2024-02-14 03:49

hmm. ok

---

**skyrbunny** - 2024-02-14 03:49

I think I am mistaken, my long save times is somethign else

---

**skyrbunny** - 2024-02-14 04:02

Hang on. I changed the texture array resource to a .res and it saved like a Lot of time

---

**tokisangames** - 2024-02-14 07:35

You probably made your textures unique and have disassociated them from the files, and are now saving the textures inside the resource. The texture resource file should be a very small text file. Relink the textures to your files and resave it.

---

**selvasz** - 2024-02-14 09:26

When i paint on the slope it painting behind the slope so what to do

📎 Attachment: IMG_20240214_145005.jpg

---

**tokisangames** - 2024-02-14 10:18

Use a nightly build of v0.9.1 which improves the mouse cursor.

---

**selvasz** - 2024-02-14 10:55

Ok thanks

---

**selvasz** - 2024-02-14 15:35

Bro how to implement the slope sculpting tool

---

**saul2025** - 2024-02-14 18:19

It in the latest build. Cory tweet shows how it works, you have to click two points between each other and then paint the slope, starting from the higher point https://twitter.com/TokisanGames/status/1750627284204294177

---

**.musikai** - 2024-02-15 00:58

(Love the tutorial videos.) When updating to another build, are there any instructions available how to do this most intelligent to not break stuff in a project?

---

**tokisangames** - 2024-02-15 03:29

Read the release notes for every build for necessary steps. Nightlies don't have those, but this transition doesn't have anything except maybe for custom shaders.

---

**mrpinkdev** - 2024-02-15 10:35

can i use brushes from code? say i spawn a building and i want to force smooth the terrain height under the building

---

**tokisangames** - 2024-02-15 12:55

I would just edit the maps directly. Look at the API, latest version is more complete. But yes all of the brushes are already operated from gdscript code. Look at editor.gd.

---

**mrpinkdev** - 2024-02-15 13:52

Terrain3DStorage.set_height(location, height) sets the height for a single pixel on image and that roughly translates to a single Godot unit right? Can I just feed global position to it?

---

**tokisangames** - 2024-02-15 14:02

Read the document entry for that again. It takes a global position. That is one of several ways to modify the maps. What I said refers to get_maps or get_map_region. Or you can set_pixel, or use the brushes like the editor. After changing it you need to force_update_maps, and regenerate collision and follow PR#278. 
Also see https://terrain3d.readthedocs.io/en/latest/docs/integrating.html#querying

---

**.musikai** - 2024-02-15 22:16

Thanks. It really was just to replace the files in the addons folder. Didn't expect it to be so easy and worked like a charm!!!
And really, the new cursor is so much better (old one jumped around and was a pain sometimes) and the slope tool is exactly what I needed! These 2 features are sooo great! Thank you!

---

**.musikai** - 2024-02-15 22:17

*(no text content)*

📎 Attachment: 2024-02-02_00_17_33-Godot-Hochablass.png

---

**selvasz** - 2024-02-15 23:58

Bro the nightly build isn't working for me

---

**tokisangames** - 2024-02-16 02:55

I don't now who bro is.
No one can help you without information. Could you help your friend who wrote only that?

---

**tokisangames** - 2024-02-16 02:55

It's working for many people, so you need to read the troubleshooting documentation, look at the console, and put out effort to troubleshoot why it isn't, and share details about what you're experiencing and what you've tried, and the results.

---

**selvasz** - 2024-02-16 02:56

Ok thanks

---

**sysdelete** - 2024-02-17 10:24

Getting this error which i think is the root cause for my terrain not being visible in the game in my ui scene ```push_error: Terrain3D::_grab_camera: Cannot find active camera. Stopping _process()
  <C++ Source>   core/variant/variant_utility.cpp:1091 @ push_error()``` A little confused on how to fix it pics for reference

📎 Attachment: image.png

---

**sysdelete** - 2024-02-17 10:25

anyone got any ideas?

---

**tokisangames** - 2024-02-17 10:31

use `Terrain3D.set_camera()`

---

**sysdelete** - 2024-02-17 11:12

thanks for the swift response cory, im still alittle confused on exactly to set it could you give me few tips on how to call the setter. I was trying to use it like this ```extends Terrain3D

var camera = "Background/3dBackground/SubViewportContainer/SubViewport/Moneyshot"

func _ready():
    var loginscreen = Terrain3D.new()
    loginscreen.set_camera(camera)
    
```

---

**sysdelete** - 2024-02-17 11:13

But i fear im still misunderstanding 🥴

---

**tokisangames** - 2024-02-17 11:25

This is basic Godot GDScript programming that you need to learn. Spend more time with the GDScript tutorials. There are many problems with this script. 

Your code instantiates a new Terrain3D, when you presumably already have one in the tree, in 3Dbackground. Don't create another. 

Then your code passes a String to set_camera. Our API tells you to send a Camera3D to the function. So use get_node or $ to get the object and pass it properly.

Finally, I would put the set_camera line in a script in this scene, either in the menu script or another attached to one of the background nodes. You don't have a Terrain3D node directly in this scene, so it makes no sense to write a script that extends Terrain3D in this scene.

---

**sysdelete** - 2024-02-17 11:35

Thanks cory that clears it up

---

**wowtrafalgar** - 2024-02-17 18:43

for OOTA are you guys doing 16k height maps or is your world smaller than that. Hitting a major roadblock due to the engine bug

---

**tokisangames** - 2024-02-17 19:23

We have several maps swapped behind a loading screen. Our largest is 2k.

---

**wowtrafalgar** - 2024-02-17 19:23

Do you hide it in the world visually with mountains? How do you handle distant terrain

---

**wowtrafalgar** - 2024-02-17 19:51

My character moves really fast on the terrain so will need to find a good way to manage the terrain loading

---

**tokisangames** - 2024-02-17 20:57

Our character runs and walks. For distant terrain we have mountain meshes. However you can also use distant regions.

---

**wowtrafalgar** - 2024-02-17 22:12

I think I’m going to try cutting up the 16k height and control map and do imports to it when I am nearing an edge and just do a loading screen like in half life 2

---

**wowtrafalgar** - 2024-02-17 22:13

I’ll need to have a stored “global coordinate” if I want to have placements work though

---

**tokisangames** - 2024-02-17 22:19

PR 278 dynamic collision will make that feasible when finished. You could also preload the next map off disk in another thread so you can do a quick swap in memory. Moving coordinates is the least of your challenges.

---

**wowtrafalgar** - 2024-02-17 22:54

Unless Godot 4.3 fixes the crash on saving then I’ve got nothing to worry about

---

**truecult** - 2024-02-17 23:47

Hey guys, wondering if someone has worked with the exporter tool that could lend me a hand? Here is a screenshot of the test terrain i made, and one of the export settings i am using. The resulting .exr image does not seem correct

📎 Attachment: terrain_test1.png

---

**truecult** - 2024-02-17 23:48

here is the result

📎 Attachment: test_map.exr

---

**truecult** - 2024-02-17 23:48

you can see that the resulting image is missing the mountainous bumps

---

**truecult** - 2024-02-17 23:48

in the middle

---

**tokisangames** - 2024-02-18 00:00

How did you determine that there is a problem? By reimporting the exr? (Which probably works fine) Or by opening it up in a photo editing app that expects the values to be normalized (0-1)? The import docs state the exr has full range values (0-247 in your case). If you need a denormalized image use get_thumbnail in the API, or tonemap it in a photo app.

---

**tokisangames** - 2024-02-18 00:01

The cause hasn't been found yet, so it might be a bit longer of a wait.

---

**truecult** - 2024-02-18 00:07

I see, didn't realize the implications of the image being 'full range'. I just opened it up in gimp and it looked wrong

---

**tokisangames** - 2024-02-18 00:08

Try tonemapping in gimp and you'll see it is correct.

---

**truecult** - 2024-02-18 00:10

thx, cheers

---

**alghost** - 2024-02-18 21:07

Is there a way to use Terrain3D for terrain that's procedurally generated at runtime?

I'd like to use it for the ocean floor in our game.
Either with small hand built areas that get stitched together or using a height function including simplex noise.

---

**heinermann** - 2024-02-18 21:23

One of the examples in the download has procedurally generated terrain (`demo/CodeGenerated.tscn`).

---

**alghost** - 2024-02-18 21:24

Thanks, I'll check that out 🙌

---

**azengar** - 2024-02-20 09:04

Hi all, I've been searching the documentation and the issues but failed to find something on the matter. I would like to use more than 32 textures, as far as I understand it's not supported and I'm not sure what's the best way to go forward.

Of course the textures will not be found in the same region, but likely far away (so there will never be more than 32 textures rendered at the same time on the terrain).

1) Should I roll my own fork and modify the control map format so that more bits are allocated for texture ids?
2) Maybe I could implement a mode where each region uses its own texture list instead of a global one set to the terrain?
3) I could use different scenes that I spawn / despawn as the player gets in/out of range, each of these containing their own terrain, but that would result sometimes in multiple terrains being active at the same time, and of course I would have to make sure that regions don't overlap / stitch the edges manually, and I'm not sure what complications having multiple terrains active will bring

Has anyone attempted anything like this? Or was this already discussed at all?

---

**tokisangames** - 2024-02-20 10:00

1) You could. Though, we have other intended purposes for those bits, such as foliage instances, and you'll sacrifice those features or run into conflicts in the future.
2) This would require separate materials or you might be able to get away with instanced uniforms, but you'll have to swap them out on the meshes which are constantly moving. This option will be very messy.
3) The terrain regions are fixed at 0,0,0 and you cannot transform them, so you'd have to introduce an offset in your fork, which isn't difficult. In our game, we have multiple terrains separated by loading screens, and you could have an entirely different texture set or material in each scene. If it's just for background, you can also use mountain meshes instead of terrain.

There are a few `Discussions` on our github about it. Very few people need more than 32 textures. We are using the most textures of all the projects that I know of and are doing fine with multiple levels and environments under 24. Witcher 3 only uses 32. So it's unlikely you need more unless you're a very experienced technical artist. More likely you'll be better served by learning how to use shaders to reuse and modify textures and optimize vram usage. 

Ex 1. We have edge blending now, but the goal is to combine textures to make new ones as demonstrated in [the Witcher 3 notes](https://ubm-twvideo01.s3.amazonaws.com/o1/vault/GDC2014/Presentations/Gollent_Marcin_Landscape_Creation_and.pdf). If you are an experienced technical artist, than we can use help implementing this.

Ex 2. All of the buildings in the witcher 3 blood and wine expansion were created with 1 material and 7 texture sets. The inefficient, naive approach would make 1 material, 1 texture set per building.

https://polycount.com/discussion/174377/witcher-3-blood-and-wine-architectural-material
https://www.artstation.com/artwork/keXwn

---

**azengar** - 2024-02-20 10:24

Thanks a lot for the detailed answer, I will read through the Witcher 3 notes.

I admit that I'm not very experienced in writing shader, but I will research to see if it can fit my purpose.

Sadly I'm no experienced technical artist, just a regular dev.

The reason I need that many textures is not because I have a complex environment but because I'm working on a large open-world with **many** different biomes each with 2-3 different textures (think something like zones in WoW or biomes in Minecraft). This is why I say that most of the textures are not rendered at the same time, at most it will be 10-12 textures actively rendered, while the rest is not currently loaded because too far away from the player. 

Then maybe multiple terrains that I load/unload as the player moves sounds like the easier solution to implement.

---

**tokisangames** - 2024-02-20 10:50

Loading textures you aren't using in far away biomes is a waste of precious vram. The more vram you use, the smaller your customer base as card requirements increase.

---

**azengar** - 2024-02-20 10:54

Yes this much I understand, but I wasn't aware that setting 32 textures meant they were loaded at all time, for example Unity terrain will load only the visible Layers, allowing up to 8 layers per terrain tile, which fits more what I want to do. But I will look around and experiment until I figure something out. 🙂

Thanks again for the answers, and for open-sourcing Terrain3D, it's a really amazing addon!

---

**adriankenobi** - 2024-02-20 14:16

I've painted a large navigable area across my Terrain3D and dyed everything purple with it. I have no idea how to make the purple invisible, I'd like to do that please, where would I find the button to hide the purple tint? xD

---

**tokisangames** - 2024-02-20 14:32

Click any other tool other than the navigation tool

---

**adriankenobi** - 2024-02-20 15:15

I have used up all my brain cells on some frustrating navigation code, they have failed at the most basic thing ever xD Thanks

---

**martisbu** - 2024-02-22 18:05

I know I might be dumb, but how do I paint terrain? I watched all the videos online and they seem to be able to just use brush straight away and it doesnt do anything despite me picking the brush type.

---

**martisbu** - 2024-02-22 18:09

I might be doing something wrong, but I cant figure that part out

📎 Attachment: image.png

---

**tokisangames** - 2024-02-22 18:17

Add a texture set, click a texture paint brush. You have the region tool selected.

---

**martisbu** - 2024-02-22 18:24

How do I do that? :)))

---

**martisbu** - 2024-02-22 18:26

I can't seem to find how to choose different toy than region selection tool. I am brand new to this engine and it's pretty hard to figure some stuff out.

---

**tokisangames** - 2024-02-22 19:04

All those pink buttons on the left side of your viewport are the terrain tools. Re-watch the videos more carefully and explore more. You could have figured this one out.
For textures, I showed how to add a texture slot in the lower right in the first video.

---

**martisbu** - 2024-02-22 19:05

When I press on them, the tool is still region select

📎 Attachment: image.png

---

**tokisangames** - 2024-02-22 19:06

When you clicked that, the additive sculpting brush is selected and you can lift the terrain where you draw, within regions. By default it adds regions when you click the terrain if not already there.

---

**martisbu** - 2024-02-22 19:07

I understand that concept, but it doesnt work like that, I cant press on anything, it gives error that I have the region tool selected, but I have something else chossen from the menu on the left side

---

**martisbu** - 2024-02-22 19:07

My questions might sound stupid, but I've been trying to figure this out without luck

---

**tokisangames** - 2024-02-22 19:07

Show me the error

---

**martisbu** - 2024-02-22 19:08

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-02-22 19:09

Where on your screen did you click to produce that?

---

**martisbu** - 2024-02-22 19:09

on the Terrain3D element

---

**martisbu** - 2024-02-22 19:10

every single press on it, generates these 2 error lines

---

**tokisangames** - 2024-02-22 19:10

No, where on the terrain did you click

---

**tokisangames** - 2024-02-22 19:10

Click the perspective menu in the viewport, then view information. What is the position of your camera?

---

**martisbu** - 2024-02-22 19:11

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-02-22 19:11

Compatibility renderer is not supported.

---

**martisbu** - 2024-02-22 19:11

oh...

---

**tokisangames** - 2024-02-22 19:11

Switch to mobile or forward

---

**martisbu** - 2024-02-22 19:11

But then I can change it back and the terrain will still work

---

**martisbu** - 2024-02-22 19:11

Right?

---

**tokisangames** - 2024-02-22 19:11

Change it back to compatibility? No

---

**martisbu** - 2024-02-22 19:12

Yeah, that was the issue... Then I cant use the tool I guess

---

**tokisangames** - 2024-02-22 19:14

The docs describe the compatibility renderer is incomplete. 

https://terrain3d.readthedocs.io/en/stable/docs/mobile_web.html#webgl

---

**martisbu** - 2024-02-22 19:15

Didn't see that part, thanks for clarifying that. It sad that I can't use this tool to speed up my work, but oh well. Good luck on the project!

---

**theshultz** - 2024-02-22 23:35

Anyone happen to be seeing an error like this after upgrading to 0.9.1? 
E 0:00:07:0521   execute_gpu_job_compute_rd: Condition "p_job.uavMip[i] >= mip_slice_rids.size()" is true. Returning: FFX_ERROR_INVALID_ARGUMENT
  <C++ Source>   servers/rendering/renderer_rd/effects/fsr2.cpp:418 @ execute_gpu_job_compute_rd()

---

**tokisangames** - 2024-02-23 02:47

FSR has an issue with Terrain3D. There's an issue in our repot you can follow or comment on. 
We aren't using any compute shaders yet.

---

**theshultz** - 2024-02-23 02:52

Ahh got it, thanks

---

**tokisangames** - 2024-02-23 15:32

I see it. You can create a new issue for it.

---

**tokisangames** - 2024-02-23 18:09

HeightMapShape3D needs one more than the number of vertices to cover the gap between regions. Cutting off the edge is incorrect and unnecessary in the non-code generated demo. There's something else going on.
https://github.com/TokisanGames/Terrain3D/discussions/152

---

**wowtrafalgar** - 2024-02-23 18:41

FYI there is a bug, where if you show collision in the editor, in run time it does not correctly set the collision layer/mask to your settings, not a big deal you just turn it off, but when placing objects it can be cumbersome

---

**tuysuztavsan** - 2024-02-23 19:13

Hey, it may sound stupid but...
I cant find a way to set a terrain size. Is there any related thing I am missing?

---

**tokisangames** - 2024-02-23 19:48

Create regions with the region tools. That defines the size of terrain in 1k blocks.

---

**tuysuztavsan** - 2024-02-23 19:49

I cant change region size

📎 Attachment: image.png

---

**tokisangames** - 2024-02-23 19:49

Please make an issue or PR so we don't lose it in the chat stream

---

**tokisangames** - 2024-02-23 19:50

Correct. Look for the related issue on github. And look in tips in the docs for more discussion.

---

**tuysuztavsan** - 2024-02-23 19:51

and even tho I have no region it still displays seamless terrain mesh

---

**tuysuztavsan** - 2024-02-23 19:51

like this

---

**tuysuztavsan** - 2024-02-23 19:51

*(no text content)*

📎 Attachment: image.png

---

**tuysuztavsan** - 2024-02-23 19:51

I was expecting it to show only existing regions

---

**tokisangames** - 2024-02-23 19:52

It's an infinite clipmap terrain. If you want to hide the mesh outside of the regions change the world background in the material

---

**tuysuztavsan** - 2024-02-23 19:53

ty so much

---

**snowminx** - 2024-02-25 04:44

Probably a dumb question, but how do I update my existing plugin with a newer one? Do I just drag the new one over the old?

---

**skyrbunny** - 2024-02-25 04:55

yeah

---

**skyrbunny** - 2024-02-25 04:55

with godot closed

---

**throw40** - 2024-02-25 05:05

how do i center my imported terrain (its 1024x1024)

---

**tokisangames** - 2024-02-25 07:09

Center your world objects on 512, 512, within the 1 region you have.

---

**throw40** - 2024-02-25 07:35

thx!

---

**snowminx** - 2024-02-27 02:09

Is there a way to make the edges smooth when using a texture for raising or lowering terrain, I want to ad d texture lol

📎 Attachment: stamp.png

---

**tokisangames** - 2024-02-27 05:16

You are using the alpha stamp brushes? They are just low resolution stamps. I'm not sure if they're even useful and might remove them. Add your own high res stamps and smooth out the edges.

---

**snowminx** - 2024-02-27 06:47

Oh I thought they were nice, the terrain ones are cool, and I use one of them to make mixed textures when painting

---

**snowminx** - 2024-02-27 06:47

I’ll look at adding one, where do you get the stamps?

---

**tokisangames** - 2024-02-27 07:00

search online for `alpha stamps`, `alpha masks`, w or w/o `terrain`

---

**quazar_cg** - 2024-02-28 06:14

I have a fun issue:
I am using multiple quite large terrain nodes in my main scene (They are all parts of segments for a map). Because I can't move these segments all I do is snap the player to the other side of the next one and only show one at a time, every segment is in the same place. These segments overlap each other but only one is enabled at a time. So anyway, Blue:

📎 Attachment: image.png

---

**quazar_cg** - 2024-02-28 06:17

The sections just decide to be blue sometimes, I mess around with the material resource and it kinda fixes things but it's gotten unfixable at this point. Do I just only have one section in the scene at a time instead of just hiding them? (Please ignore the terrible performance this setup might be causing because I will improve it.)

---

**tokisangames** - 2024-02-28 07:53

We have multiple terrains in different scenes that get disconnected and attached to the scenetree.

---

**quazar_cg** - 2024-02-28 09:29

I don't quite understand, my problem is that it is blue. I gotta fix that. Multiple terrains in a scene works most of the time but the materials seems to get confused when there are multiple. I'm not sure how to get around this.

---

**quazar_cg** - 2024-02-28 10:21

I think I fixed it by reloading the materials when I unhide the terrain at runtime.

---

**tokisangames** - 2024-02-28 10:50

I don't know why it's blue. We didn't design it to work with two Terrain3D nodes attached to the scenetree at the same time, so I have no idea what the conflict is. I told you that we have multiple terrains in separate scenes, but never two attached to the scenetree simultaneously. Rather than hiding and unhiding, you'll probably be better off removing it from the tree so it stops processing and maybe even unloading it to free up the vram and ram.

---

**quazar_cg** - 2024-02-28 10:57

Yeah, I'll eventually do that once I've finished editing the terrain. I did try to have a list of Storages but I'm not sure how to put those into an array right now.

---

**adnerf** - 2024-03-02 03:14

Why does my terrain change into this weird thing whenever I add an albedo texture to a new texture ?

📎 Attachment: image.png

---

**tokisangames** - 2024-03-02 05:59

Does your console have error messages reporting an inconsistent size or format? Refer to the texture setup documentation if so.

---

**heinermann** - 2024-03-02 06:20

I got something like that when it was the wrong size, resizing the new texture fixed it for me

---

**tokisangames** - 2024-03-02 07:16

Just about any size works. They must all be the same size.

---

**dimaloveseggs** - 2024-03-02 11:58

How do we safely update the plugin without losing any data from the scene and also cause some kind of corruption?

---

**tokisangames** - 2024-03-02 12:02

Close Godot, replace the files, open Godot. Follow the version upgrade path outlined in the release notes if applicable.

---

**tokisangames** - 2024-03-02 12:02

Also always use version control and backup.

---

**dimaloveseggs** - 2024-03-02 12:07

And another question what is the best way to update for the latest latest features?

---

**tokisangames** - 2024-03-02 13:04

Read the nightly builds, or building from source in the docs (and all the docs)

---

**.mobuis** - 2024-03-02 14:35

hello guys ! I've a quick newbie question (as a newbie gamedev I am)
I've discovered this plugins : `Heightmap terrain`.
But I'm wondered what's the difference between `Terrain3D` and `Heightmap terrain` ?
Looks like Terrain3D is doing the work of Heightmap terrain no ?

---

**tokisangames** - 2024-03-02 14:59

If you mean Zylann's HTerrain, the fundamental differences is hterrain is more mature and feature rich, is a chunk based terrain, and is written in GDScript. Terrain3D is written in C++, still building features, and is a clipmap terrain. Both are heightmap terrains.

---

**.mobuis** - 2024-03-02 15:38

You right, I'm speaking about Zylann's HTerrain.

---

**.mobuis** - 2024-03-02 15:43

Thanks for you answer and thanks/congrats for the amazing work you've done 🙏

---

**keithmintoff** - 2024-03-02 16:03

Hi, I'm trying to modify the autoshader script such that below a given height threshold only the base texture is used. 

I managed to update the shader code so that a specific albedo is applied below the desired height, but I can't figure out how to get the base texture.

Could anyone point me in the right direction please?

---

**tokisangames** - 2024-03-02 16:29

The base texture is looked up in the shader in get_material. The code already shows you how to retrieve it.

---

**keithmintoff** - 2024-03-02 18:36

Thanks for the pointer. Managed to figure it out.

---

**snowminx** - 2024-03-02 23:52

How do you add the alpha masks to the stamp?

---

**tokisangames** - 2024-03-03 00:10

Look for the other exr files in the addon folder, outside of Godot and add more there

---

**snowminx** - 2024-03-03 00:34

It only accept exr?

---

**tokisangames** - 2024-03-03 00:38

You can convert, but 8-bit brushes probably won't look good.

---

**snowminx** - 2024-03-03 00:49

<@455610038350774273> Thank you, that worked

📎 Attachment: Screenshot_2024-03-02_164931.png

---

**snowminx** - 2024-03-03 00:49

🙂

---

**coyotetraveller** - 2024-03-03 07:27

I'm writing a grand strategy game with Terrain3D as the map, plus a 2d hud.  I'm having trouble detecting mouse events on the map.  I expected to see an input_event on Terrain3D but it looks like there's no such thing, since it's just a Node and not a Node3D.

How should I be doing this?

---

**tokisangames** - 2024-03-03 07:30

Describe the situation more. editor.gd already has an example of using the API to detect the mouse cursor on the map, as that's how you paint and sculpt. Or you can enable collision and run a raycast is commonly done for all other 3D objects.

---

**coyotetraveller** - 2024-03-03 07:35

Sorry, I'm pretty new to Godot in general, I've only been working with it for a couple weeks and most of that's in 2d.
I see `_forward_3d_gui_input` in editor.gd, but I don't know how to wire that up to receive messages.

---

**tokisangames** - 2024-03-03 07:44

That's the right area for you to learn how it uses the Terrain3D mouse picking code, but you will not use _forward_3d_gui_input() in your code unless you are making an editor plugin. That code requests the mouse position on the terrain using get_intersection(), it doesn't receive a signal. Read our docs on this function (and everything else).

---

**tokisangames** - 2024-03-03 07:45

Many of the things in 2D have no basis in 3D, such as getting an event if the 2D mouse is in front of a 3D object.
Unfortunately you just lack experience and need to spend a lot more time with Godot, programming, and 3D.
You can learn it all, but don't have a false expectation that you're going to get it all in a couple weeks. Spend more time reading Godot and Terrain3D documentation, studying editor.gd and how it uses the C++ API for mouse movement, analyzing our demo, and more 3D Godot tutorials.
If you are a competent programmer, expect to get up to speed in Godot in 1-3 months. If you're learning how to program, while also learning gamedev, and 3D, competency will take 2+ years, but it will be growing the whole time.

---

**coyotetraveller** - 2024-03-03 07:50

Alright, thanks.
I'm a senior dev outside of Godot, so no issues there.
I'm detecting clicks on other 3d objects like CollisionObject3Ds using the input_event signal, but I can't find where to *start* running the raytracing code when the user clicks on the map.  If I can detect a click signal, I can write code with get_intersection().

---

**coyotetraveller** - 2024-03-03 07:50

I didn't see anything like that in the docs.

---

**tokisangames** - 2024-03-03 07:50

Your mouse isn't *clicking* on the terrain. The mouse is a 2D object on your screen, and has nothing to do with the 3D world.

---

**tokisangames** - 2024-03-03 07:51

You are clicking on a 2D viewport. There are a few tricks to project the 2D mouse click into the 3D world.

---

**tokisangames** - 2024-03-03 07:53

So you need to capture the click. You can do that with a basic _input() available in nearly every class, in a script tied to your UI scene. You can capture events from the viewport or window. There are multiple ways to capture mouse events in godot. Upon your mouse event, you use get_intersection to project 2D to 3D the same way editor.gd does it.

---

**tokisangames** - 2024-03-03 07:54

Or as mentioned, you can enable collision, then you can do a raycast, from the same 2D-3D projected angle. But I wrote get_intersection so that we don't have to depend on having distant collision.

---

**coyotetraveller** - 2024-03-03 07:55

Alright, that makes sense.  Looks like I was just confused based on CollisionObject3D's misleading similarity to 2d nodes.  Thanks for the help!

---

**tokisangames** - 2024-03-03 08:04

Rather than raw _input, which works, but gets all events all the time, it's cleaner to have UI more contained and layered. I would look at having a Control based SubViewportContainer, which contains your main game viewport and camera. Then you can also utilize all of the Control signals, and you can also implement _gui_input() to replace _input.

---

**coyotetraveller** - 2024-03-03 08:05

Cool - I'll take a look at that.

---

**zhivkob** - 2024-03-03 20:19

Hey guys, I am currently having issues running the demo project (either 0.9 or 0.9.1 beta versions) on iOS and I would appreciate some help, since I don't have much time to figure it out myself right now. This is the errors I am getting in Xcode and as soon as I hit those I have to terminate the application. Any ideas if it is on me (although that is the plain repo clone from GH) or some other issue? Thanks!

```-[MTLDebugRenderCommandEncoder validateCommonDrawErrors:]:5775: failed assertion `Draw Errors Validation
Vertex Function(main0): The pixel format (MTLPixelFormatR32Float) of the texture (name:<null>) bound at index 11 is incompatible with the data type (MTLDataTypeUInt) of the texture parameter (m_dus_control_maps [[texture(0)]]). MTLPixelFormatR32Float is compatible with the data type(s) (
    float,
    half
).
Fragment Function(main0): The pixel format (MTLPixelFormatR32Float) of the texture (name:<null>) bound at index 11 is incompatible with the data type (MTLDataTypeUInt) of the texture parameter (m_dus_control_maps [[texture(0)]]). MTLPixelFormatR32Float is compatible with the data type(s) (
    float,
    half
).```

---

**tokisangames** - 2024-03-04 05:07

Unfortunately, you're going to have to invest the time to figure it out. Terrain3D on mobile is experimental. Some have gotten the demo to work fine on iOS. You need to use the latest version with Godot 4.2.1. Read through the mobile docs and all related issues. And run tests with other Godot projects.

---

**scaranova** - 2024-03-05 00:37

​Hi everyone, I am a young developer and I would like to create an island. Luckily, I discovered Terrain 3D, which helped me immensely! Despite this, I would also like to use the ProtonScatter add-on to create a random tree layout. By searching a little, I found this reddit post which explains how to do it: https://www.reddit.com/r/godot/comments/1angh6w/terrain3d_and_proton_scatter/.
I also thought about uncommenting the lines of code once I copied the file into the folder. Despite this, it still doesn't work, and I also noticed, with VS Code, that the file concerned (project_on_terrain3d.gd) contained indentation or syntax errors (I don't know anything about .gd code). I would like to know if it would be possible to resolve this?
Thanks in advance for the response!

---

**tokisangames** - 2024-03-05 03:55

We can only help you if you provide information. "it doesn't work" is too vague to do anything with. It certainly does work when setup properly.
First of all you need to uncomment properly. Revert the file. Since you don't know anything about GDScript, then you shouldn't use vscode with it. Use the Godot editor. Place the file in the right directory. Remove the comments and make sure the tabs are properly aligned and indented with tabs and not spaces.

---

**scaranova** - 2024-03-05 08:37

Ok thanks you i will try

---

**scaranova** - 2024-03-05 10:43

Ok, after spending a few hours manipulating all the parameters, I found the solution and the problem, ProtonScatter works with Terrain 3D only when I activate the "show collision" parameter in the debug section of the Terrain 3D node. However, ProtonScatter seems to work on a CSGBox3D object.
And once again sorry for the lack of precision in my first message and thank you for the advice!

---

**scaranova** - 2024-03-05 10:44

My trees stay in their place once I deactivate the "show collision", but I have to reactivate it if I want to modify their position

---

**tokisangames** - 2024-03-05 10:47

If you use the Project on Colliders modifier, `debug collision` is required.
If you use our addon script, you get a Project on Terrain3D modifier and debug collision is not required.

---

**scaranova** - 2024-03-05 10:48

oooh ok, That explains everything! thank you very much for this valuable information and really sorry for the inconvenience!

---

**ungur4074** - 2024-03-05 21:30

hello, would someone help me with something in terrain3d?

---

**ungur4074** - 2024-03-05 21:33

why when i paint, the texture is a rectangle?

📎 Attachment: image.png

---

**rcosine** - 2024-03-05 23:02

which brush do you have selected?

---

**tokisangames** - 2024-03-06 03:07

If you increase the brush size, does it remain square?
You can only paint on vertices.

---

**ungur4074** - 2024-03-06 06:37

*(no text content)*

📎 Attachment: image.png

---

**ungur4074** - 2024-03-06 06:37

here's with the increased brush size

---

**ungur4074** - 2024-03-06 06:39

here in more detail

📎 Attachment: 2024-03-06_08-38-30.mov

---

**ungur4074** - 2024-03-06 06:40

it's not like in this video: https://www.youtube.com/watch?v=YtiAI2F6Xkk

---

**ungur4074** - 2024-03-06 06:40

at 2:31

---

**tokisangames** - 2024-03-06 07:05

Brush size is 30 in that video, then switches to spray to blend the edges

---

**tokisangames** - 2024-03-06 07:06

As I said, you can only paint on vertices, which are 1m apart by default. Make your brush size larger or spray so you can use opacity.

---

**tokisangames** - 2024-03-06 07:24

Also you may not be just painting, but also disabling the autoshader, explained at length in that video.

---

**ungur4074** - 2024-03-06 12:13

why is the spray tool not working?

📎 Attachment: 2024-03-06_14-12-33.mov

---

**tokisangames** - 2024-03-06 13:30

I'm able to spray at 4m/100%.  Use the debug views to see what is on the ground, and you're actually changing with the control texture, and control blend modes. These brushes interact with what you've already placed on the ground. You can always reset it with the paint tool. 

Spend more time with these two tools in another practice area to become more familiar with how they work, and how to blend textures together. You can easily avoid the squares and hard lines with proper technique. Practice with larger and smaller brushes.

---

**xtarsia** - 2024-03-06 19:09

loaded up 4.3-dev4 no-idea what is causing this

📎 Attachment: Godot_v4.3-dev4_win64_MOMbhIAoVZ.mp4

---

**ungur4074** - 2024-03-06 19:17

can i change the vertex size?

---

**tokisangames** - 2024-03-06 19:27

4.3 is definitely not supported until it stabilizes

---

**tokisangames** - 2024-03-06 19:28

mesh_vertex_spacing. Vertex sizes are always infinitely small. Though your objects and world are probably a bit small.

---

**ungur4074** - 2024-03-06 19:29

where i can find the "mesh_vertex_spacing"?

---

**tokisangames** - 2024-03-06 19:30

In the searchable docs, or in the inspector under `Mesh`

---

**ungur4074** - 2024-03-06 19:31

thanks

---

**ungur4074** - 2024-03-06 19:32

does this reduce performance if set low?

---

**tokisangames** - 2024-03-06 19:36

It will increase the number of vertices and physics faces on screen at any given time since they're closer together, so likely. How much depends on the system.

---

**ungur4074** - 2024-03-06 19:36

ok and one more question

---

**ungur4074** - 2024-03-06 19:37

is this the minimum size of the brush? cuz it is pretty big

📎 Attachment: image.png

---

**ungur4074** - 2024-03-06 19:37

i can change it in the source code

---

**tokisangames** - 2024-03-06 19:41

Big is relative. As I mentioned your objects look a bit small, and you can reduce vertex spacing, and improve your painting technique. Nevertheless, I've changed it to 2m. You can look in one of the commits from today for guidance.

---

**denismvp** - 2024-03-07 12:43

Hello everyone! One question. I am using Terrain3D to make the terrain and the navmesh. But i wonder how you guys draw navigation meshes for objects in the scene. Like for example a bridge. I noticed that the bake navmesh tool in the terrain3D node just bakes the terrain only, Would love to hear how you guys deal with this kind of situations. Thanks so much for your itme

📎 Attachment: image.png

---

**denismvp** - 2024-03-07 12:44

using navigation link works, but i would love to walk around the bridge not just cross It

---

**denismvp** - 2024-03-07 13:09

well i dropped the bridge as a sibling of the terrain node and it worked pretty well. It used to crash in a more complex map but this works

📎 Attachment: image.png

---

**tokisangames** - 2024-03-07 14:09

We only pass the terrain mesh to Godot's nav server to generate the nav mesh. You still need to learn how to use Godot's system inside and out. Read our navigation docs, and all of the rest of the Godot navigation docs to learn how to separate and combine segments.

---

**denismvp** - 2024-03-07 14:25

thanks for the help!

---

**ungur4074** - 2024-03-07 19:31

hi tokisan. would you change the minimum vertex spacing from 0.25 to like 0.10? im just asking

---

**tokisangames** - 2024-03-07 19:41

We limited it to .25 for a reason. You shouldn't use even that unless you understand the ramifications of it. No one needs 100 vertices per square meter for a terrain.

---

**.ethlongmusk** - 2024-03-07 20:24

I'm trying to build the extension custom for double precision from source and it seems like sometimes it works and others leads to this error in 4.2.1-stable with custom bindings etc.  Am I doing something obviously wrong here? lol I'm not sure why sometimes it would work and others not...

```core\extension\gdextension_interface.cpp:1344 - Method 'Node3D.look_at' has changed and no compatibility fallback has been provided. Please open an issue.
  godot-cpp\gen\src\classes\node3d.cpp:467 - Method bind was not found. Likely the engine method changed to an incompatible version.```

---

**.ethlongmusk** - 2024-03-07 20:25

It all loads fine I just cant move the brushes on the terrain

📎 Attachment: image.png

---

**ungur4074** - 2024-03-07 20:26

what are these errors??

📎 Attachment: image.png

---

**tokisangames** - 2024-03-07 22:15

It says what's wrong. An incompatible engine version. Double engine, godot-cpp matching same version as the engine, bindings built off the double engine, double Terrain3D, as stated in the double and building docs.

---

**tokisangames** - 2024-03-07 22:18

You've probably messed up your texture list, but cut it off of your screenshot and didn't include the first errors. I can't guess without information. Revert your changes, or review the errors from the beginning. They probably tell you what is wrong.

---

**uhgoomba** - 2024-03-07 23:08

do you guys know why this weird lighting issue is happening?

📎 Attachment: image.png

---

**uhgoomba** - 2024-03-07 23:08

that's an omni light

---

**uhgoomba** - 2024-03-07 23:08

and it always has this weird line against

---

**uhgoomba** - 2024-03-07 23:08

no matter where the light is

---

**uhgoomba** - 2024-03-07 23:31

And it’s not a shadow

---

**uhgoomba** - 2024-03-07 23:32

So maybe there is a normal issue or something

---

**uhgoomba** - 2024-03-07 23:32

But the line is relative to the light

---

**rcosine** - 2024-03-07 23:38

which lines

---

**rcosine** - 2024-03-07 23:38

do you mean the ones for the range of the light?

---

**uhgoomba** - 2024-03-07 23:51

Edge of the light

---

**uhgoomba** - 2024-03-07 23:51

It goes from lit to dark

---

**uhgoomba** - 2024-03-07 23:51

Right next to the omni light

---

**uhgoomba** - 2024-03-07 23:51

The right side of the image

---

**.ethlongmusk** - 2024-03-08 00:32

Got it and I found the issue 🙂 when I was following the instructions while reading the initial convo with iii he said it required him to build both separately godot-cpp and terrain3d to avoid an error that was popping up for him which is how I "forced" it to work as well, it triggered my memory that in the version I have that is working I edited the extension_api.json specifically in the heightmap3d section because it was still looking for packedfloat32array and additionally in terrain3d.cpp once i changed those to packedfloat64array it compiled completely and works as expected. Once I fixed  that error I was able to regenerate the bindings for terrain3d as well. I can try to write up the corrected steps for you if that would be helpful. I am happy to test anything with this build process going forward.

line 369 in terrain_3d.cpp:         PackedFloat64Array map_data = PackedFloat64Array();
lines 112151 and 112163 in extension_api.json: PackedFloat64Array

I actually build this all from a CMakeLists.txt file in case that would be of interest to anyone 🙂 I'll have to add a patch etc but should make the process way less painful.

---

**uhgoomba** - 2024-03-08 00:58

maybe this screenshot shows it better

📎 Attachment: image.png

---

**uhgoomba** - 2024-03-08 00:58

it happens with spotlights too

---

**uhgoomba** - 2024-03-08 00:59

and only on terrain3d

---

**uhgoomba** - 2024-03-08 01:00

wait

---

**uhgoomba** - 2024-03-08 01:00

it's my material

---

**uhgoomba** - 2024-03-08 01:01

I think it's my normal map

---

**uhgoomba** - 2024-03-08 01:01

might not actually be a terrain thing lol

---

**uhgoomba** - 2024-03-08 01:06

okay I'll take the shit for this one, but you guys are on thin ice

---

**skyrbunny** - 2024-03-08 01:57

i just work here mate dont look at me

---

**tokisangames** - 2024-03-08 03:22

Most likely your normals are reversed. You probably produced directx normal maps instead of opengl. Videos and docs discuss this at length. Use the grey debug view in the material to confirm that it fixes the problem.

---

**uhgoomba** - 2024-03-08 03:29

Hey, I was using an opengl map

---

**uhgoomba** - 2024-03-08 03:29

I just switched to a different texture though

---

**uhgoomba** - 2024-03-08 03:29

But it wasn’t a terrain problem

---

**tokisangames** - 2024-03-08 03:29

Docs don't say build godot-cpp separately. They say generate custom bindings off of your engine build. You don't need to edit the API.json file at all. The above steps already do that. 
The only step that is likely necessary and missing from the docs is changing PackedFloat64Array in terrain_3d.cpp, and that could probably be wrapped in some #defines to automatically switch.

---

**uhgoomba** - 2024-03-08 03:29

That normal map just have been messed up

---

**skellysoft** - 2024-03-08 16:20

Has anyone else in here had the issue that their Terrain3D doesn't seem to be updating/following the active camera while running the program? Weird bug literally just appeared when I last ran my game. Terrain3D version 2.8, I believe.

I can update my version when I get back home (out doing errands atm) but I just wanted to know if anyone else had run into this issue before

---

**skellysoft** - 2024-03-08 16:21

Like, I changed a few things in my games code? but nothing that should mess with the Terrain3D node.

---

**lukepro173** - 2024-03-08 19:21

I wanted to download the terrain 3d out of the ashes tutorial you have made on github but it imports me something completely different

---

**tokisangames** - 2024-03-08 19:35

I don't know what 2.8 is. We can only support the latest version. If it doesn't follow the camera, it's because you've set it to something else, usually by having a second camera in the scene. Use set_camera to manually set.

---

**tokisangames** - 2024-03-08 19:37

The videos show exactly how to do it, and it works for others. We can't help you without information, so rather than saying vague things like "it's something different" tell us exactly what you did and exactly what is happening, with error messages on your console.

---

**tokisangames** - 2024-03-08 19:58

This should be all that is needed in addition to the existing directions.
https://github.com/TokisanGames/Terrain3D/commit/a020a7c1892de46d15598a8d77c6ffa64ceb9283

---

**bunlysh** - 2024-03-08 21:17

Hey folks! Does anybody know what this here is? It happened by accident, but does not seem to be a hole since I cannot "unhole" it.

📎 Attachment: unholeme.gif

---

**coyotetraveller** - 2024-03-08 22:00

When I clear all storage data from my Terrain3D node, there's still what looks like a default map in place.  When I load in a .res file, it just loads it into the middle of the terrain, it doesn't replace it.  How can I make the rest of the terrain go away?

📎 Attachment: image.png

---

**coyotetraveller** - 2024-03-08 22:01

(Even 'delete region' won't remove them.)

---

**coyotetraveller** - 2024-03-08 22:33

I'm also running into some pretty hideous z-fighting when I add a plane of water.
My intuition is, this would be better if my terrain height didn't go from 0, 1, 2, 3... at the bottom, but instead was 0, 4, 5, 6... with my water at 2.  Does this sound like a good approach?  Wanted to check before I write a script to make that change to my dataset.

📎 Attachment: image.png

---

**_zylann** - 2024-03-08 22:40

Godot doesnt have the best depth buffer strategy currently, though there was discussion on using a better one <https://github.com/godotengine/godot-proposals/issues/3539#issuecomment-1879578742>
In the  meantime you may indeed push things further apart to prevent Z-fighting. You can also increase your camera near distance if it's not going to look at things from up close.
(not sure, but you could also try chunking your ocean, as I've seen some float-precision issues arise when triangles get really big)
Yet another thing I considered was to bake water into the terrain's surface at very far distances, where height differences would barely matter, which would eliminate all Z-fighting, but that sounds like work to properly blend it

---

**coyotetraveller** - 2024-03-08 22:48

Ah, tweaking the near distance helped a lot.  Thanks!

---

**skellysoft** - 2024-03-09 00:28

.... wait, what am i saying? v 0.8.3. Sorry, had a brainfart. I'll use set_camera and then update the version of Terrain3D.

---

**tokisangames** - 2024-03-09 04:10

Tutorial videos showed how to fix this and the result. You should watch both for other things you're missing.

---

**tokisangames** - 2024-03-09 04:12

Change world background in the material. Explained in the tutorial videos.

---

**tokisangames** - 2024-03-09 04:16

Don't know what happened. 
Does it move or change with the camera? 
Does the square brush work? 
Can you undo or revert using your version control? 
What versions?
Does it remain after a restart?
Cycle through the material debug views to see if they give a clue.

---

**bunlysh** - 2024-03-09 04:58

Actually it crashed after a while. Since it was a test scene it was gone, so I was unable to try your suggestions.

I think it happened exactly in the Moment when I laxly painted on the edge of the terrain which had no neighbouring tile.

Plus I used PNG textures. I will try to reproduce the issue and afterwards convert them to .dds as you suggest in the docs. I recall that Terrain3D complained when I duplicated a tex to give it a different albedo in the layer settings... saying that something with the albedo was wrong. So thats the most likely reason I can see. On the other hand: it happened while painting height, not materials.

Thank you for the response! :)

---

**tokisangames** - 2024-03-09 05:00

Doubt it has anything to do with textures. Demo currently uses PNGs to support mobile. DDS is good for desktop.

---

**bunlysh** - 2024-03-09 05:02

Alright. Despite of being highly experimental: does Steamdeck count as Desktop?

---

**tokisangames** - 2024-03-09 05:20

Depends on if steamdeck supports DDS textures. Mobiles don't and need ASTC or ETC.

---

**bunlysh** - 2024-03-09 09:27

I managed to reproduce it.

Godot 4.2.1
Latest release Terrain3D v.0.9.1-beta (https://github.com/TokisanGames/Terrain3D/releases)

[1] Paint with the "special brushes" onto the ground next to a different terrain
[2] Smooth that area with whatever brush.

📎 Attachment: unholeme4.gif

---

**bunlysh** - 2024-03-09 09:27

*(no text content)*

📎 Attachment: t3d_error.png

---

**bunlysh** - 2024-03-09 09:27

Here you can look at it yourself. Please note that this is NOT the scene which I was showing in the gif, but it got the same hole problem.

📎 Attachment: T3D_Blackhole.7z

---

**bunlysh** - 2024-03-09 09:28

**Questions from before: **

It does not move or change with the camera.

The square brush works as in: it makes the holes much bigger. Actually any brush does that now.

I did not try the version control part.

It remains after restart.

---

**bunlysh** - 2024-03-09 09:34

**Further Notes**
It does not happen if you do not paint on the edges.

It does not happen if you add an adjacent terrain tile.

Adding an adjacent terrain tile after the issue occurred ain't a solution (unfortunately).

It does not matter which brush you use. It's simply "Raise" / "Lower" and afterwards "Smooth"

Best fix: simply never turn off "Automatic Regions".

---

**bunlysh** - 2024-03-09 09:35

**Another Note**
I want you guys to know that I love this tool and that I am not complaining. After all the fix is rather simple: hands off the edges.
But mayhaps those information help to fix it.

---

**tokisangames** - 2024-03-09 10:02

Thanks for this detailed report. You should be able to operate on the edges, so this bug needs to be fixed.

---

**slakimil_black** - 2024-03-09 12:27

Hello. By default, flat terrain is created at height 0. How can I change this height? For example y = -200.

---

**bunlysh** - 2024-03-09 12:33

You mean this?

📎 Attachment: flatten.gif

---

**slakimil_black** - 2024-03-09 12:37

Not really. This is already a manual change in terrain. But if the map is large, it will be convenient to immediately generate the entire terrain at the desired height. And then raise or lower the necessary areas. In my case this is the seabed, which should be below the water. And I will draw individual islands as needed.

---

**bunlysh** - 2024-03-09 12:41

So you mean transform.y?
Otherwise you'd need a big brush, I guess.

---

**slakimil_black** - 2024-03-09 12:42

Yes,  transform.y.

---

**bunlysh** - 2024-03-09 12:43

Guess it is feasible if you use it from the Node3D, which Terrain3D inherits from.... as long as you only got the Ocean.

---

**tokisangames** - 2024-03-09 16:27

Import an image map with the desired value. See the codegenerated demo. If you want to set height outside of regions do it in a custom shader

---

**tokisangames** - 2024-03-09 16:27

Terrain3D ignore transforms.

---

**mrpinkdev** - 2024-03-09 16:42

is there a support for opengl?

---

**mrpinkdev** - 2024-03-09 16:42

i tried switching to compatibility and terrain is just flat

---

**truecult** - 2024-03-09 19:12

Hey wondering if anyone has any tips on how to bake multiple navmesh regions? I feel like I followed the docs correctly, but it does not produce a navmesh so I think I've done something wrong.

I've set my navmesh resources to use `SOURCE_GEOMETRY_GROUPS_EXPLICIT`and added Terrain3D node to the named group. I set the `filter_baking_aabb` on each NavigationRegion3D to encompass the region I want to bake and then painted the purple nav brush. The output says it baked the number of regions I have, but no navmesh is created.

---

**tokisangames** - 2024-03-09 20:40

No, forward or mobile only. Compatibility is incomplete. Discussed in the docs under mobile support

---

**tokisangames** - 2024-03-10 04:38

Try a single section, smaller sections, and read the Godot docs and experiment more with the settings, try with a larger cell size, and review the console. We just pass the area to Godot to generate the nav mesh. You still need to be intimately familiar with Godot's system.

---

**tokisangames** - 2024-03-10 05:08

It is easier to receive and manage bug reports on github:
https://github.com/TokisanGames/Terrain3D/issues/336

---

**drakorle** - 2024-03-11 00:08

Hello, 
If I understand right, Terrain3D wouldn't be suited for heightmap changes on runtime, like what Valheim does ? I think Zylann's voxel tools is a bit too much for this usecase tho.

---

**tokisangames** - 2024-03-11 03:56

I don't know what valheim does. What you quoted described an example of changing at runtime. For a competent programmer, it's possible.

---

**tokisangames** - 2024-03-11 06:20

In addition to editing how the editor does so, I would just edit the maps directly. The API is documented at length and presents at least 3 ways to edit the terrain.

---

**kuco0259** - 2024-03-11 12:20

any idea why terrain differs when running the game ?

📎 Attachment: image.png

---

**kuco0259** - 2024-03-11 12:21

is there some cache I need to clear ?

---

**saul2025** - 2024-03-11 12:34

that because the enviroment not is not added into the scene, but as a preview.to add it click at the 3 dots option that is at the top and click at adding enviroment and directional light.

---

**kuco0259** - 2024-03-11 12:37

it only added shadows 😐

📎 Attachment: image.png

---

**tokisangames** - 2024-03-11 14:40

The terrain centers on the initial camera. Perhaps you have another camera in the scene and are looking at low lods. Use set_camera

---

**kuco0259** - 2024-03-11 14:57

yes I am trying to create split screen coop game - did put $Terrain3D.set_camera($FirstChar/Camera)  in scene _ready but still not working

---

**kuco0259** - 2024-03-11 14:57

also both of the cameras are near each other so lod should be set to 0

---

**tokisangames** - 2024-03-11 15:01

Presumably it works fine in the demo, so you're going to have to divide and conquer on your project until you figure out what you did in your settings, shader, or code to break it. I would start with a blank scene, Terrain3D, and your storage. The add in pieces at a time until you find the cause.
You should also turn on debug logs and become intimately familiar with the messages. They're all in the code, so you can track exactly what is happening.

---

**kuco0259** - 2024-03-11 15:19

thanks, nvm I will just use regular mesh (generated through Terrain3d) - it's small project/map so it will be sufficient - Problem might lay in that I am doing split-screen via 2 windows - so not sure whether this is valid use-case scenario for terrain3d

---

**tokisangames** - 2024-03-11 15:44

The editor can edit in 4 viewport mode simultaneously.
The generated mesh is only for utility purposes, and isn't a good mesh for terrain unless you retopologize it in blender. 
If you're not willing troubleshoot your project when you have trouble, you're going to have a long and difficult game development process.

---

**tokisangames** - 2024-03-11 15:49

No issue when done correctly. The caveat is the lods focus only on one camera at a time. 
https://twitter.com/TokisanGames/status/1754244533444026547?t=v_uegwEnvrZpDcjvd34fcQ&s=19

---

**throw40** - 2024-03-11 20:55

is there a way to scale terrain without using a different size heightmap or increasing resolution? I want a bigger terrain but it starts getting really laggy at a certain point

---

**tokisangames** - 2024-03-11 21:55

Increase mesh_vertex_spacing

---

**tokisangames** - 2024-03-11 21:56

Elaborate on "laggy". What kind of card do you have? What "certain point" and how does performance change.

---

**throw40** - 2024-03-11 22:03

i'm using integrated graphics, and i was using a heightmap that was 8192x8192

---

**throw40** - 2024-03-11 22:03

when i try to import a heightmap at that size, godot just crashes

---

**throw40** - 2024-03-11 22:07

4096x4096 works

---

**.ethlongmusk** - 2024-03-12 00:22

If its r16 cant you just set it to a larger size and scale the height range if its not auto set, at the cost of reduced detail? Default is 1024 isnt it?

---

**.ethlongmusk** - 2024-03-12 00:24

you should be able to import a 4096 map and scale it by 2 is what I meant to say kek

---

**throw40** - 2024-03-12 00:30

understood, I can definitely do r16, but would that make a mesh with more verts? because im worried about alot of lag from increased mesh complexity

---

**throw40** - 2024-03-12 00:33

im trying to make a game that will run on a lowend hardware while still having really big terrain, and I can already tell that im hitting a wall at more than 4 zones, so Im ok with really low detail terrain as long as its big compared to the player (i plan to add in props anyways like big rock meshes and stuff)

---

**throw40** - 2024-03-12 00:51

I just tried the vertex spacing

---

**throw40** - 2024-03-12 00:52

works really well, thanks for letting me know

---

**.ethlongmusk** - 2024-03-12 02:53

I meant like import lower res r16 and then just scale it but Cory's already thought of that with vertex spacing 🙂 I learned something from this to!  lol

---

**tokisangames** - 2024-03-12 05:17

Vertex count per region is always 1024^2. You can laterally scale with spacing, vertically scale on import, and consume more regions by scaling your heightmap before importing.

---

**rubiebubie** - 2024-03-12 06:17

Hey guys, I just started out with Terrain3D and what I could not grasp from the tutorial videos:
1. Is there a way to generate a height map from code (not procedural), or
2. Is there a way to generate height map in Godot (or Blender)? I do not want to install hTerrain just for the height map

---

**tokisangames** - 2024-03-12 06:20

How do you envision generating heightmap data from code that is not procedural? What's the difference?

---

**rubiebubie** - 2024-03-12 06:21

Maybe I got it wrong from the tutorial. Technically, there is no difference, right. But I looked for it in the documentation and could not find anything at all so I thought, maybe, its not meant to be done

---

**rubiebubie** - 2024-03-12 06:21

I just want to have a like a basic terrain that I can "draw" on that is not a flat plane. Just with some random roughness to make it more realistic

---

**rubiebubie** - 2024-03-12 06:23

I would do it in blender but then I need to export a complete mesh, which we do not want here

---

**tokisangames** - 2024-03-12 06:29

Tutorials can't cover all possibilities. You need to understand the features and think about how to use them to meet your needs. Here are 3 ways to do it. 

* Create or download a noise texture or terrain heightmap from anywhere on the internet and import it.
* Use the FastNoise library to generate a noise image with the settings you like and extract that to a heightmap to import into Terrain3D.
* Use those FastNoise settings you like in the codegenerated demo and use the Terrain3D API to save this as a reusable data file.

---

**tokisangames** - 2024-03-12 06:32

Later we'll look at incorporating a visual generator like hterrain has but it's low priority.

---

**rubiebubie** - 2024-03-12 06:34

Ok, great, thank you very much. I will try out 2 and 3

---

**adnerf** - 2024-03-12 17:15

hi, I get this error when exporting and the export doesn't work, is there a way to fix it ?

📎 Attachment: image.png

---

**tokisangames** - 2024-03-12 17:24

WebGL is not supported yet. Read the mobile/web documentation.

---

**adnerf** - 2024-03-12 17:25

That means I can't export for html ?

---

**tokisangames** - 2024-03-12 17:27

Exactly

---

**adnerf** - 2024-03-12 17:27

ok, thanks

---

**nico_s** - 2024-03-12 18:00

Hi, I'm sorry if the question has already been answered. Is it possible to load a terrain when no camera exists in the three ? I instantiate the camera further in the game setup (when the player spawns, which doesn't happen rigorously at the game start since i'm developping a multiplayer game), and the terrain is bugged when i do so

---

**tokisangames** - 2024-03-12 18:10

Should be fine as long as you set the camera manually later.

---

**nico_s** - 2024-03-12 18:11

Okay, I'm thinking I could just put a loading screen 👍

---

**tokisangames** - 2024-03-12 18:33

What do you mean? Why do you say you need a loading screen in this context?

---

**nico_s** - 2024-03-12 18:35

Because when I load the scene having the Terrain3D node without a Camera, the terrain doesn't load properly (I can give you some pictures, but I assume it is normal since an error is print in the console saying that no camera has been found). Thus I could load the scene with a Camera but I dont want the player to see the scene if its character has not spawned yet, so I'd have to hide the scene behind a loading screen

---

**tokisangames** - 2024-03-12 18:43

How do you see the scene on screen if there is no camera?
You can load Terrain3D without attaching it to the tree. Then it won't initialize.
Or you could create and give it a dummy camera that your Player's scene is not attached to.

---

**nico_s** - 2024-03-12 18:43

Yep that is what I meant : a dummy camera, sorry if this was not clear ahah

---

**greedydragon81** - 2024-03-12 18:51

Hello, I am working on a rts game, where I am trying to implement navigation regions in a 3d grid system.  What I am trying to do is find a way to subdivide the Terrain3D mesh at runtime into a grid and bake each region. Is this possible to implement within godot using terrain3d by writing a custom script to sub divide the mesh, or is this not possible?   ***repost. I accidently posted in wrong hashtag

---

**tokisangames** - 2024-03-12 18:53

Elaborate more on what you mean with "bake each region" and "subdivide the mesh".

---

**greedydragon81** - 2024-03-12 19:00

I am trying to create a grid system at runtime, each of which will have a navigation region 3d, that will be baked individually.   If it helps I can post 2 example videos of what i mean as a reference. (you dont have to watch but the image and video description might explain a little better than me) In this video series this guy creates a terrain in blender and divides it into agrid of individual meshes, imports into godot and bakes navigation meshes on each individual grid

---

**outobugi** - 2024-03-12 19:01

so a chunk based terrain

---

**greedydragon81** - 2024-03-12 19:01

yes

---

**tokisangames** - 2024-03-12 19:03

This is an entirely different system, unrelated to and incompatible with chunk based terrains and their tutorials.
We have a system and documentation for passing mesh data to Godot's navigation server for generation.

---

**tokisangames** - 2024-03-12 19:04

You can have Godot bake navigation regions at runtime or edit time. Our nav documentation describes how to partition sections.

---

**tokisangames** - 2024-03-12 19:05

There's very little you can do in blender that we can use, or need, in Terrain3D. The only useful 3rd party data would come from dedicated terrain system generators like Worldmachine or Gaea.

---

**tokisangames** - 2024-03-12 19:08

You do need to learn how to use Godot's navigation system to use it well. So if you watch tutorials that combine concepts from multiple areas, you'll need to filter out the irrelevant information and adapt what you learn about navigation to the system you're using.

---

**greedydragon81** - 2024-03-12 19:19

Ok Thank you. I now see the section you were referring to in the documentation. It did not realize at the time thats what I was looking for. So let me see if I got this right, I have currently a large terrain map with painted navigation areas. I should then find a way to implement this section of the documentation "To use the same Terrain3D node with multiple NavigationRegion3D, set up the nav meshes to use one of the SOURCE_GEOMETRY_GROUPS_* modes instead of the default SOURCE_GEOMETRY_ROOT_NODE_CHILDREN, and add the Terrain3D node to the group." and use filter_baking_abb to create a grid system.

---

**tokisangames** - 2024-03-12 19:27

Unfortunately I'm not the resident expert on Navigation and haven't used it. Our document was written by a Terrain3D dev who is familiar with navigation and as you see, it describes how to define AABBs to limit generation. I can tell you if any individual navigation region is too large the nav mesh won't generate or have other problems. You need to become an expert on how Godot's navigation system works in and out, independent of Terrain3D.  All we do is pass the terrain data to their system to generate.

---

**greedydragon81** - 2024-03-12 19:29

Ok sounds good. I will need to dig back into to the godot docs! thank you again.

---

**smthedev** - 2024-03-12 19:53

Hey there! Im loving Terrain3D so far, however Im encountering a bug where the noise background is visible in the editor but not in-game.

---

**tokisangames** - 2024-03-12 19:54

Does that occur in the demo scene?

---

**smthedev** - 2024-03-12 20:01

Umm no I haven't checked, but it does occur in my current project (Godot 4.2)

---

**tokisangames** - 2024-03-12 20:18

You need to check. If it works fine in the demo, we know it's something specific to what you've setup in your project, and not Terrain3D. Then you can divide and conquer to figure out what that was.

---

**smthedev** - 2024-03-12 21:13

Hmm okay, I'll mess around with some settings and get back to you tomorrow.

---

**smthedev** - 2024-03-12 21:14

Thanks tho

---

**rubiebubie** - 2024-03-13 14:53

Why is the region size fixed to 1024? Can I also make a smaller square?

---

**tokisangames** - 2024-03-13 15:05

That's all that is currently implemented.
Look in the tips document.

---

**link4728** - 2024-03-14 10:14

Can I check if what I'm trying to do is possible? I want to use terrain3d to generate a set of ready made terrains, and then re-use them. I had though to just add new terrain3d nodes and move the transforms, but they seem to sit at 0,0,0 regardless. Would that be expected behavior?

---

**link4728** - 2024-03-14 10:20

To hopefully illustrate what I mean. Node 'Terrain3d2' has unique storage, but the material and textures copied from node terrain3d. I have moved the transform, which has caused the highlighted region to move, but the actual terrain and textures are overlapping the originals

📎 Attachment: image.png

---

**tokisangames** - 2024-03-14 11:03

Terrain3D ignores transforms. The mesh is placed by the shader. You can load and replace storage resources in one or multiple scenes, but there's little value to running multiple nodes currently. There are a few rare use cases though. You could set the world background to none, then have different enabled regions on the different nodes, without needing transform adjustment. Or you could modify the code to add the transform as an offset, or to expand the 16k limits, depending on your needs.

---

**link4728** - 2024-03-14 11:06

Ok, that makes sense. Thanks for taking the time to reply

---

**quazar_cg** - 2024-03-16 11:01

Hi, you guys recommended simple grass textured and proton scatter. They seem nice but don't detect the terrain mesh. I have collision enabled on the terrain.

---

**tokisangames** - 2024-03-16 11:12

We have lots of people using both successfully with Terrain3D. You'll need to provide information about how you've set it up and what you did to troubleshoot so people can help you.

---

**quazar_cg** - 2024-03-16 11:15

All default.

---

**quazar_cg** - 2024-03-16 11:26

Sorry

---

**tokisangames** - 2024-03-16 11:29

I can't help if you're not willing to share or troubleshoot. I can't read your or your computer's mind.

---

**snowminx** - 2024-03-16 18:53

But Cory you’re ✨magical✨

---

**rcosine** - 2024-03-17 04:59

try to enable show collision in the debug view for the terrain3d

---

**ultragigamegaskeleton** - 2024-03-17 17:03

Hi there, I've been trying to create a system to change footstep audio in my game based on what material/texture the player is currently walking on and I was trying to use the blended height map (the one which determines whether one material or another is displayed based on height, in my case "grass" or "rock") but I can't figure out if I can access that map at runtime or how to go about it, sampling the right pixel would be easy enough I just can't get the map.
Any advice?

---

**ultragigamegaskeleton** - 2024-03-17 17:08

This is the map I'm aiming to use, all I can find in the API documentation is the function to show it visually, if theres a better or more common solution to this I'm all ears, I found a tutorial which used a color map and a camera which seemed like a good solution but I don't have a color map either haha

📎 Attachment: Godot_v4.2.1-stable_win64_7ABBRcwCaf.jpg

---

**tokisangames** - 2024-03-17 19:56

The API already has get_texture_id(), which you can read about the limitations of it in the docs. However there's a bug in that it ignores the autoshader and only reports the painted texture.
You can access all maps at runtime. If you think you can't, that just tells me you haven't really looked at the fully documented API.
Note that read values are limited to vertices. The shader bilinearly interpolates each pixel between the adjacent 4 vertices. So either you need to do that as well, or just rely on whichever nearest vertex you read, which is probably fine. Witcher 3 isn't pixel perfect either and no one cares or notices.

---

**ultragigamegaskeleton** - 2024-03-17 21:59

get_texture_id() solved it (as it literally does say in the API docs, I missed it I swear lol) I'm not too fussed about pixel perfection so thats a total non-issue

---

**ultragigamegaskeleton** - 2024-03-17 21:59

Cheers!

---

**benbot3942** - 2024-03-18 00:17

Would you happen to have an example of the footsteps system? I'd like to implement something similar and examples online tend to sample the material rather than vertex or blendmaps.v

---

**tokisangames** - 2024-03-18 05:41

We were just talking about get_texture_id() above. Or you can sample any of the maps directly at any given location. Read the API documentation.

---

**benbot3942** - 2024-03-18 05:53

Yeah I saw that, thank! Sorry I'm just new to this so I didn't quite understand how to implement it based on the information above. I'll read the API and dig around.

---

**.berightback.** - 2024-03-18 15:42

how can i use height map and apply that to terrain

---

**nikitapodgornyy** - 2024-03-18 15:56

hello everyone, please tell me how to get rid of pixelation?

📎 Attachment: image.png

---

**skyrbunny** - 2024-03-18 17:03

Read the docs

---

**skyrbunny** - 2024-03-18 17:03

Something might be wrong with your texture normals but it’s hard to tell

---

**tokisangames** - 2024-03-18 17:14

You mean import a heightmap? Import documentation explains how

---

**tokisangames** - 2024-03-18 17:15

You didn't generate mipmaps when creating your textures. Described in texture docs.

---

**.berightback.** - 2024-03-18 17:17

ye i imported it and its flat

---

**tokisangames** - 2024-03-18 17:18

Your heightmap is normalized. Scale it up. All documented

---

**.berightback.** - 2024-03-18 17:25

thanks

---

**skellysoft** - 2024-03-21 16:27

Hello again!

So I'm having a new issue with Terrain3D. I've got the active Terrain3D camera being set to the players camera, and have definitely got the Terrain3D initalised, as the raycast beneath the players feet is saying that it is colliding with Terrain3D, as you can see in the first screenshot. However, as you can see, the terrain itself is invisible when running the game. 

The scene is structured, as you can see in the second screenshot, using "Folders" - which is a simple custom class I made: just a Node3D that can't be moved around the game world. It's a way I'm using to organise the scene tree in a structured fashion - I've even made my own basic plugin to generate a standard layout for a scene tree which allows for the creation of a new environment, so all the areas of the game are layed out in the same way. There's nothing in this setup that instantly springs to mind, however, that should prevent the Terrain3D from appearing in the 3d view.

I'm using Godot v4.1.3 and Terrain3D 0.9.1.

📎 Attachment: techissue1.png

---

**tokisangames** - 2024-03-21 17:09

The demo is fine, right? so it's something in your project, which means you need to divide and conquer until you figure it out. 

Make a test scene with just your player, and the terrain. If not, do only a static camera, default environment, a directional light, and terrain, default material, no code.

Also switch to wire frame mode, add an additional light to see if the terrain is rendering but you've messed up your environment, or if it's not rendering.

In addition to manually setting the camera, you can get the camera and make sure it is the same as your player camera.

---

**skellysoft** - 2024-03-21 17:23

Well, thats the thing: I *have* a different scene that wasnt made using that level creation plugin I made, which AFAIK is structured exactly the same way - and the terrain works! In fact, the terrain Im using in the screenshots above has the same data, just set to make it unique so there's no conflicts.

I'll double check, but I'm pretty sure there are no differences in how it's laid out. Thats why I wondered if it might be a Terrain3d issue, as it seems to work fine in the other hand created scene...

I know the divide and conquer problem solving method, I use it often. The only issue is finding a place to *start.* There could, ofc, be a problem with my environment/world generating tool, but I'm having trouble figuring out what that could be... Under what conditions, in Godots 3D, does something function as intended, but just not show up? 🤔

---

**skellysoft** - 2024-03-21 17:26

Ill compare the scenes to make sure theyre set up the same, and if they are and they work, Ill try making a version of the handmade scene with nothing but the terrain and player spawn and see if it works. If it does, I'll take the player spawn out and try instantiating it in the plugin generated scene and see if *that* works.

---

**tokisangames** - 2024-03-21 17:28

You have a place to start when you have a working setup and a not working setup. Then you move one towards the other until you find it.

You can and should also debug. Terrain3D has copious logs. You need to fill your own code with `print k` debug lines, and/or step through it line by line. You can have your computer compare verbose debug logs between a working setup and a not working setup in seconds

---

**skellysoft** - 2024-03-21 23:45

Alright, I *think* I've managed to get it working consistently - but I can't for the life of me understand *why* this thing I've done makes it work. I'll give it a few more tests quickly before counting my chickens, though

---

**skellysoft** - 2024-03-22 01:22

Yep, I managed to confirm it: The issue is that when the scene with the terrain3d in first starts, there isnt a camera in the scene - because the scene instead has a player spawn point, and the camera is part of the player scene. 

So, if I add a dummy Camera3d node to the scene root, the terrain renders fine. *Weird!*

---

**tokisangames** - 2024-03-22 01:42

If you had looked at your console it probably said Terrain3D couldn't find the camera, so didn't initialize. You can look at the code for how it starts up. It attempts to grab the active camera.
Rather than giving it a dummy camera at first, does it work if you skip that and manually assign the correct camera later?

---

**skellysoft** - 2024-03-22 01:53

No, it doesn't. :/ There has to be a dummy camerai the scene.

---

**tokisangames** - 2024-03-22 01:55

OK. Perhaps I can add an initialization check to set_camera() to kickstart it if done much later.

---

**skellysoft** - 2024-03-22 01:57

it's not *much* later on in the initialisation? I think the transition fade in from black is like 0.3 seconds long, but yeah. I'll use the dummy camera trick for now :)

---

**tokisangames** - 2024-03-22 02:13

As you know, a long time on the CPU.

---

**tokisangames** - 2024-03-22 07:39

https://github.com/TokisanGames/Terrain3D/commit/622f9e753eb0e92dcde61fcd79e3af512aaa7d67

---

**berilli** - 2024-03-22 13:11

Hello! Great plugin! I'm currently trying to update terrian at runtime. From the documentation I see that I can use set_hieght with force_update_maps and it works. But according to the documentation, I need to manually update collision or unable dynamic collision. Can't figure out how to do it.

---

**tokisangames** - 2024-03-22 17:23

See PR 278.

---

**dekker3d** - 2024-03-22 17:33

So... apparently other people are able to get NavigationRegion3D to recognize their terrains. I can't seem to get it to work. It's in a group, I've got navigation regions that are bounded to AABBs, set to use groups as input, they're already generating proper navmeshes for some simple cubes with static bodies, but they're not picking up the terrain.

---

**dekker3d** - 2024-03-22 17:33

Collision is enabled, on layer 1 and mask 1.

---

**tokisangames** - 2024-03-22 17:37

You've both read our navigation document, and tried baking in our demo to see it working?

---

**dekker3d** - 2024-03-22 17:38

Ah, I did not even know you *had* a navigation document. I tried searching for answers but couldn't find much. I'll try those.

---

**dekker3d** - 2024-03-22 17:39

Found the doc.

---

**dekker3d** - 2024-03-22 17:40

*Oh.* So I have to paint navigation stuff on the terrain, and *that* will be picked up by the navmesh?

---

**dekker3d** - 2024-03-22 17:40

I thought they were parallel.

---

**dekker3d** - 2024-03-22 17:40

Like, you don't need a navmesh if you do the painting.

---

**dekker3d** - 2024-03-22 17:43

Oh, this is a problem for me. I was planning to use relatively small navmesh tiles, and when the player places or removes an obstacle, I'd only update the tiles that contain that obstacle. That might not be so easy if I have to use the navmesh baker in your terrain node?

---

**dekker3d** - 2024-03-22 17:44

Ah, you have an example script that covers runtime baking too.

---

**dekker3d** - 2024-03-22 17:53

This strategy seems... odd. It looks like you're rebaking a large navmesh fairly often, rather than tiling it, because edge connectivity on tiling navmeshes causes hitches on the main thread?

---

**dekker3d** - 2024-03-22 18:06

So this is interesting. I have three nav regions, each one set to a 20x20 area. Two of them also have a 20x20 slab under them, the third doesn't. Terrain does raise the navmesh up, but no navmesh seems to be generated over terrain unless there's soemthing else under there.

📎 Attachment: image.png

---

**dekker3d** - 2024-03-22 18:06

If I move the third navmesh to overlap the slabs (and rebake), I see this:

📎 Attachment: image.png

---

**tokisangames** - 2024-03-22 18:53

The painted area is passed to Godot to generate a nav mesh. We provide a facility for Godot to generate off of both terrain and objects. You still need to be intimately familiar with how Godot's nav system works, and it's quirks.

---

**dekker3d** - 2024-03-22 18:53

Yeah, it is pretty quirky.

---

**tokisangames** - 2024-03-22 18:55

You're welcome to contribute a better designed system. The documentation presents the means to bake sections with AABBs, which could be done manually or via code. The runtime baker is an example you can improve upon for your needs.

---

**dekker3d** - 2024-03-22 18:55

I guess I'd have to test it, and try my own alternative, and benchmark all that.

---

**dekker3d** - 2024-03-22 18:55

>_>

---

**dekker3d** - 2024-03-22 18:56

I'll consider it.

---

**tokisangames** - 2024-03-22 18:57

I don't how what you're pointing out. But anyway, as I mentioned you need to explore the ins and outs of Godot's nav system to figure it out. If we have bugs you can identify, we can fix them. But if these are Godot quirks, you'll either have to report them upstream or find workarounds for design limitations.

---

**dekker3d** - 2024-03-22 19:00

Well... part of the terrain doesn't seem to be parsed for the navmesh, despite being part of the same terrain, and also painted to be enabled for navigation.

---

**dekker3d** - 2024-03-22 19:00

I just moved the middle slab to the left. Now the third navmesh (on the left) recognizes the slab, but still doesn't recognize the terrain. The middle area does recognize the terrain and doesn't need the slab (I thought it did, at first)

📎 Attachment: image.png

---

**dekker3d** - 2024-03-22 19:01

Which is odd.

---

**tccoxon** - 2024-03-22 19:01

is the Terrain3D node a child of the NavigationRegion3D?

---

**dekker3d** - 2024-03-22 19:01

No, it's selected via groups.

---

**dekker3d** - 2024-03-22 19:01

I want tiled nav regions, so I can't have stuff be a child of a single nav region.

---

**tccoxon** - 2024-03-22 19:02

it looks like your third region just isn't finding the terrain at all

---

**tccoxon** - 2024-03-22 19:02

i'd check the group is set right

---

**dekker3d** - 2024-03-22 19:02

Mhm. And if I move the first (middle) navmesh to the left, overlapping the third, it also doesn't see the terrain.

---

**dekker3d** - 2024-03-22 19:02

*(no text content)*

📎 Attachment: image.png

---

**dekker3d** - 2024-03-22 19:03

So it's not in the navmesh. It seems to be something in the terrain.

---

**tccoxon** - 2024-03-22 19:03

it can depend on your other navmesh settings. like agent size / max climb and cell size/height

---

**dekker3d** - 2024-03-22 19:03

If I only move it by half, then only half of it recognizes the terrain.

📎 Attachment: image.png

---

**tccoxon** - 2024-03-22 19:04

if the terrain is too steep for the agent settings (for instance) it won't generate a navmesh there

---

**dekker3d** - 2024-03-22 19:04

Oh... hm.

---

**dekker3d** - 2024-03-22 19:04

But that wouldn't explain the sharp cutoff on the last image?

---

**tccoxon** - 2024-03-22 19:05

which bit is the sharp cutoff you're referring to?

---

**tokisangames** - 2024-03-22 19:05

Hide the terrain, or put it in wire frame mode. Part of your nav mesh is there, just hidden due to the z order on the rendering

---

**dekker3d** - 2024-03-22 19:05

You can see that one half is just following the slab on the left.

---

**dekker3d** - 2024-03-22 19:05

Yeah, but it's not following the slope of the terrain at all.

---

**dekker3d** - 2024-03-22 19:09

I could screenshare it and show how weird it's being, if that makes things more clear, but it seems like it's probably some weird edge case that will be quite hard to track down.

---

**tccoxon** - 2024-03-22 19:10

it's hard to tell what's going on from a few screenshots

---

**dekker3d** - 2024-03-22 19:10

Yeah, which is why I brought up screensharing.

---

**tccoxon** - 2024-03-22 19:10

are you using the mesh vertex spacing setting at all?

---

**dekker3d** - 2024-03-22 19:10

Might not even be relevant anyway. I'll likely try writing my own navmesh-geometry-submitting code so I can just take a chunk of the terrain for the tile I'm trying to bake, and not have to paint the entire map purple.

---

**tccoxon** - 2024-03-22 19:11

shouldn't matter in theory but it's worth checking

---

**dekker3d** - 2024-03-22 19:11

I'm not quite sure what setting you're referring to. So, maybe not?

---

**tccoxon** - 2024-03-22 19:11

is it set to something other than 1?

📎 Attachment: image.png

---

**dekker3d** - 2024-03-22 19:11

It's 1.

---

**dekker3d** - 2024-03-22 19:12

What does it do?

---

**dekker3d** - 2024-03-22 19:12

Size is 48, the default.

---

**tccoxon** - 2024-03-22 19:12

increases horizontal distance between vertices in the terrain. it's a new feature that in the past caused some issues with nav mesh (which were fixed)

---

**dekker3d** - 2024-03-22 19:12

Ah

---

**tccoxon** - 2024-03-22 19:17

The RuntimeNavigationBaker script does this btw, if you need reference code to figure it out. The steps are:
1. Call `Terrain3D.generate_nav_mesh_source_geoemetry` to generate faces for a section of the terrain
2. Pass that data through to `NavigationMeshGenerator.bake_from_source_geometry_data` to get a navmesh

---

**dekker3d** - 2024-03-22 19:17

Yeah, I was reading it earlier.

---

**yahkub** - 2024-03-22 19:19

Hi y'all, curious if anyone has a good way of getting the texture for the region youre in? I'm implementing some terrain blending and cant seem to get access to Terrain3DUtil to convert the control map into a readable image.

---

**yahkub** - 2024-03-22 19:42

ah, i see my question has been answered. its not exposed yet: https://discord.com/channels/691957978680786944/1065519581013229578/1217146800264450080

---

**tokisangames** - 2024-03-22 20:01

* Get_texture_id() - only for manual painting, ignores auto for now
* You can read the control map right now. The docs show how to extract desired bits out of the pixel
* The Util converter functions are in the nightly builds, but they are not necessary

---

**xtarsia** - 2024-03-22 21:09

any idea why Terrain3D_Node.storage.get_height(Vector3(pos.x,0.0,pos.z)) is, seemingly at random returning non-interpolated values?

sometimes a grass mess is dropped either under/ over the terrain by a small amount

📎 Attachment: image.png

---

**xtarsia** - 2024-03-22 21:09

im populating a multimesh with a fairly straightforwards loop

---

**tokisangames** - 2024-03-23 02:08

* Interpolation is only in 0.9.2. It doesn't interpolate near vertices as it doesn't need to, but perhaps the threshold is too big.
* splitting your pos vector is unnecessary. Y is ignored.
* I am building an MMI painter so you will likely toss what you're doing in a few weeks

---

**tokisangames** - 2024-03-23 03:17

You should print out the position and heights and see if there's a pattern

---

**dimaloveseggs** - 2024-03-23 10:07

Btw i got latest terrain and i dont see the slope feature yet

---

**xtarsia** - 2024-03-23 11:28

tis just multimesh being crap it seems, there are multiple issues about, some open for over a year.

---

**tokisangames** - 2024-03-23 11:39

Slope feature has been in for a couple months. Restart godot after installing a version with new buttons.

---

**dimaloveseggs** - 2024-03-23 11:40

Its in documentation the new button pics and such?

---

**tokisangames** - 2024-03-23 11:42

Second from the bottom

📎 Attachment: image.png

---

**dimaloveseggs** - 2024-03-23 11:44

Ill check it out after work thank you !!!

---

**tokisangames** - 2024-03-24 08:53

Do you have some issue #s or links for me to look at?

---

**tokisangames** - 2024-03-24 09:30

I think it's just a problem with the threshold being too big. I saw the issue, then lowered it and don't see it anymore. Looks fine to me.

📎 Attachment: image.png

---

**xtarsia** - 2024-03-24 13:35

https://github.com/godotengine/godot/issues/75485 my take from this: dont build mm buffer until we know everything that's going into it, set the exact buffer size needed, so as to not have any values not be updated, which could lead to junk/uninitialized data appearing and there being weird errors showing up.

tho perhaps you're already doing it that way anyways.

but threshold changes 100% helped. tho instancing with silly high numbers still produced 1 or 2 of errors (talking 130k+ instances in a 64m sq chunk)

currently im just playing around making a rule based generation system, mostly for self education purposes...

---

**tokisangames** - 2024-03-24 13:43

Yes, That issue is about changing the buffer after creation. I am currently recreating the MM upon changes.

---

**xtarsia** - 2024-03-24 13:48

Same actually, fresh multi-mesh every time. but leaving any uninitialized space in the buffer could produce an error.

I was filling an entire 4kx4k map with 64m chunks filled with 32k instances and getting 1-20~ errors total.

---

**xtarsia** - 2024-03-24 13:50

populating an array with transforms first, then setting instance count to the size of the array, then filling in all the transforms produced no errors

---

**dearfox** - 2024-03-24 17:05

https://discord.com/channels/691957978680786944/841475566762590248/842147471143731210
Oh, I wonder if it supports pressure 🤔﻿ 
I think that would be cool 🙂

---

**mlepage** - 2024-03-24 18:30

Hi. Simple question, maybe a FAQ? If I make a small terrain with just one 1024x1024 tile, it starts with "back left" corner at the origin. If I want the origin to be in the center of the terrain tile, I can just transform the terrain to (-512,-512). Is there anything "bad" about doing that? E.g. would it affect performance or have any other negative effects?

---

**tokisangames** - 2024-03-24 20:38

That's using hterrain. But pens are just fancy mice. Terrain3D doesn't use any pressure settings yet. I don't know if Godot even reads and exposes it

---

**tokisangames** - 2024-03-24 20:40

You cannot move the terrain without code modification. Just move your objects by (512,512).

---

**dearfox** - 2024-03-24 20:42

You can get stylus pressure force in Godot.
https://docs.godotengine.org/en/stable/classes/class_inputeventscreendrag.html

---

**_zylann** - 2024-03-24 20:42

<https://github.com/Zylann/godot_heightmap_plugin/blob/74437e6d1c106adee38f9c0fd0e775759b6e2974/addons/zylann.hterrain/tools/plugin.gd#L502>

---

**dearfox** - 2024-03-24 20:47

I think it would be really cool to have support for stylus pressure in Terrain3D.
 Although more like a nice addition than a really important function.
 Although it is possible that some actions using stylus pressure could become faster and more convenient.

---

**dearfox** - 2024-03-25 08:53

By the way, if for some reason you don't have the console version of Godot, you can run godot.exe via CMD (at least on Windows)
As far as I understand, it's the same thing.
(I discovered this when I tested official Godot builds with Spine Pro runtime built in)

---

**dimaloveseggs** - 2024-03-25 10:13

Will the instancing of meshes on the terrain include prefabs or i dont know what is the equivalent on godot.

---

**dearfox** - 2024-03-25 10:33

Is there any way to disable the creation of collision for distant parts of the terrain but still leave it visualized?
I understand that this can lead to objects falling through the world when the player is far away, but I think this can be solved using some scripts and such.

📎 Attachment: a5562de96a3ac1ee.png

---

**dearfox** - 2024-03-25 10:38

Although this may not affect performance
 I'm just not sure if there is a difference between the collision mesh and the terrain rendering itself
I just assumed that these are two different grids that are created when the game starts

---

**tokisangames** - 2024-03-25 10:42

PackedScenes. Yes. Not with collision or manual lods in the first pass

---

**tokisangames** - 2024-03-25 10:43

Follow PR 278
Far enemies shouldn't be processing, but get_height() can detect anywhere

---

**tokisangames** - 2024-03-25 10:44

?? Collision mesh and terrain mesh are two different things and processed entirely different.

---

**tokisangames** - 2024-03-25 10:47

Long shot guess here, look at material/debug views/vertex grid

---

**dimaloveseggs** - 2024-03-25 10:47

First pass should be mostly testing i suppose but if it planned im happy either way

---

**dearfox** - 2024-03-25 11:03

Oh, yes
 I think I see that now the collision mesh is always quite detailed

📎 Attachment: d5716f6713391dc5.png

---

**dearfox** - 2024-03-25 13:59

It seems that if you macro noise with pixel textures without anti-aliasing, you can get a little unpleasant behavior.  Perhaps it would be possible to add a separate anti-aliasing setting for this noise?
 As far as I know, the game VintageStory uses a similar approach, but there is noise that is superimposed on top of the textures of pixel blocks - not pixelated, but blurred.

📎 Attachment: 1f03678d0e228922.png

---

**dearfox** - 2024-03-25 14:02

Of course, you can adjust the size of the noise so that it is pixel to pixel with the texture, but in this case it’s really not very useful for “removing the mosaic effect”

---

**tokisangames** - 2024-03-25 15:24

I don't understand. Macro noise? You mean macro variation?
Anti-aliasing? You mean nearest filtering?
Please clarify using the terms used in the Terrain3D settings.
What is the unpleasant behavior? 

> Perhaps it would be possible to add...

Create an override shader and the current material settings will generate a shader that you can modify as much as you like.

> If you reduce the uv scale, your textures will get blocky.

Yes, that's how it works. ??

> it’s really not very useful for “removing the mosaic effect”

Reducing your UV scale will give you a mosaic effect. If you don't want that, don't reduce your UV scale so much, or use much higher resolution textures.

---

**dearfox** - 2024-03-25 15:32

Sorry, I'm using a translator, and I don't know some of the terms very well yet.
 And yes, I meant macro variation. 
 Perhaps I should create an issue asking for this feature I mentioned to be added for improvement.
 I can edit the shader, and if I figure out how it works I think I'll do it

---

**tokisangames** - 2024-03-25 16:26

I don't know what you want. If you can't explain it here, making an issue isn't going to be any clearer.

---

**snowminx** - 2024-03-25 17:29

<@246499948290375681> change texture settings to be not blur, I think nearest neighbor. Increase UV X and y to make texture smaller looking but still pixel

---

**dearfox** - 2024-03-25 17:35

Ultimately, I had in mind the possibility of turning on texture filtering on linear for macro variation noise

---

**snowminx** - 2024-03-25 17:38

Linear is right now nearest neighbor I think

---

**tokisangames** - 2024-03-25 17:41

Texture Filtering can be linear (space between texels are interpolated) or nearest (between texels are not interpolated, hard edges)

---

**tokisangames** - 2024-03-25 17:41

<@246499948290375681> You mentioned a game, VintageStory. Why don't you post a shot of the look you are attempting to achieve.

---

**dearfox** - 2024-03-25 17:46

Okay, I'll send it when I finish work.
 In other words: the texture terrain has clear pixels (Texture Filtering nearest), while the macro variation is “blurred” (Texture Filtering linear)

---

**tokisangames** - 2024-03-25 17:58

No, not at all. Macro variation has nothing to do with texture filtering on the ground textures. You should turn off macro variation (by setting the colors to white) and forget about it until you figure out the other aspects.
Then reduce your uv scale and move the camera close, then compare linear filtering with nearest filtering until you understand what they do.

---

**dearfox** - 2024-03-25 18:03

🐇  but I know what they do

---

**tokisangames** - 2024-03-25 18:08

Then your words are confusing. Your last sentence, for example.
Anyway, start with a picture of what you want to achieve.

---

**dearfox** - 2024-03-25 20:18

Here's an example of what I was talking about.

📎 Attachment: cbeae56f0472c006.png

---

**tokisangames** - 2024-03-25 22:56

That's what you have. What do you want?

---

**dearfox** - 2024-03-26 07:06

This is a screenshot from the Vintage Story game I was talking about.
 Ultimately, I wanted the ability to use pixel textures with clear pixels for the terrain and macro variation, which is customized noise, but with anti-aliasing, so that the macro variation noise itself is not pixelated with clear edges, but blurred as if it was turned on Texture Filtering linear or something like that

---

**dearfox** - 2024-03-26 07:11

Here's another example of how it works now, and roughly what I want to get:

📎 Attachment: 085efefd02d352c7.png

---

**snowminx** - 2024-03-26 08:01

Looks like linear filtering with some kind shader that apply AA to edges

---

**dearfox** - 2024-03-26 08:03

This is an example I made in Photoshop
 This is just a demonstration.  About what I would like to receive

---

**dearfox** - 2024-03-26 08:04

I didn't have a noise texture with transparency on hand
 That's why this is such a rough example

---

**tokisangames** - 2024-03-26 08:37

> I wanted the ability to use pixel textures with clear pixels for the terrain

Done with nearest filtering

> but with anti-aliasing, so that the macro variation noise itself is not pixelated with clear edges, but blurred as if it was turned on Texture Filtering linear 

Generate an override shader and you can indepently change if the terrain texture or noise texture use nearest or linear filtering. Set terrain to nearest and noise to linear.

Or don't use macrovariation at all. Change the colors to white, or remove it from the shader, and add your own variation method that achieves the look you want.

---

**sniderthanyou** - 2024-03-27 23:37

Hey team, I'm trying to use Spatial Gardener with Terrain3D. I have the Terrain3D Demo scene open, and I imported my Spatial Gardener plugin, but it seems that I can only paint on the Borders.
- Collision is enabled on the Terrain3D, as shown in the screenshot
- Terrain3D has Collision Layer 1, Mask 1 2
- Gardener has Gardening Collision Mask 1
I see that <@179723809421656066> and <@328692301419511810>  and <@555219956418215936> have had succees with this in recent months. Do you see anything incorrect with this setup?

📎 Attachment: image.png

---

**sniderthanyou** - 2024-03-27 23:42

🤦 how is it that I can spend an hour on something making no progress, and then as soon as I ask someone for help, I figure it out? 😂  Debug -> Show Collision was the magic wand.

📎 Attachment: image.png

---

**tokisangames** - 2024-03-27 23:51

That's documented in our docs, and tutorial videos.
I'm building a foliage instancer. The other tools will be redundant in a couple weeks.

---

**little_jimbo** - 2024-03-28 01:27

Glad you got it figured out!

---

**orca936** - 2024-03-28 12:40

Hello, I'm curious about using Terrain3D in Godot, however I noticed that the docs mention a 'control map' which is proprietary - is it necessary to use a control map and if so, would one run into any licensing issues if using Terrain3D for their projects (possibly commercial)?

---

**tokisangames** - 2024-03-28 14:16

Control map is necessary if you want to texture the terrain. Proprietary means specific to us, not a restrictive license.
MIT license allows commercial use. Read it to understand what you are using.

---

**orca936** - 2024-03-28 14:24

OK, thank you Cory - I have read the MIT license but I'm quite new to how these work, apologies. Thank you for answering and for making Terrain3D available - I've just downloaded the plugin and it is quite astounding. I hope Out of the Ashes is a major success too.

---

**narria** - 2024-03-28 22:20

Hi all, I am trying to play around with Terrain3D and it seems like top of tree main is for 4.1 and I am running 4.2.  Is there another branch I need?

---

**narria** - 2024-03-28 22:54

Why am I getting this?

📎 Attachment: image.png

---

**narria** - 2024-03-28 22:54

When I have my git setup like this

---

**narria** - 2024-03-28 22:54

*(no text content)*

📎 Attachment: image.png

---

**narria** - 2024-03-28 22:55

When I try to open it, it says I need to restart and then I get hang

---

**narria** - 2024-03-28 22:56

but then it seems like things are sort of working

---

**orca936** - 2024-03-28 23:09

Hi Narria, I've only just started using this too, but I think you need to restart Godot twice to finish installing it:
https://terrain3d.readthedocs.io/en/stable/docs/installation.html#install-terrain3d-in-your-own-project

---

**tokisangames** - 2024-03-28 23:25

The 0.9 branch is the stable release, 0.9.1. The main branch is the development version, 0.9.2-dev.
Either works with Godot 4.1 or 4.2.
The directions tell you to restart Godot twice regardless of version. The Godot message telling you it will upgrade your project can be ignored.

You should read the docs, and if you don't intend to develop Terrain3D (or use macos), just use the releases or nightly builds.

---

**snowminx** - 2024-03-29 03:49

You have to change the texture import setting in godot, I think in project settings > render > texture filtering

---

**snowminx** - 2024-03-29 03:49

Something like that

---

**snowminx** - 2024-03-29 03:58

Yeah

---

**snowminx** - 2024-03-29 03:58

I do that too, I do low poly as well and it work well

---

**tokisangames** - 2024-03-29 04:00

Change the texture filtering option in the material to nearest.

---

**tokisangames** - 2024-03-29 04:04

Yes

---

**tokisangames** - 2024-03-29 04:04

In the material

---

**snowminx** - 2024-03-29 05:14

I forgot that part sorry haha

---

**wowtrafalgar** - 2024-03-29 14:04

Does anyone know what would cause white flickering dots and seems in the terrain?

---

**tokisangames** - 2024-03-29 14:22

Bugs in the renderer

---

**tokisangames** - 2024-03-29 14:22

There's a gd3 issue. Search fireflies

---

**tokisangames** - 2024-03-29 14:23

Might possibly be fixable in the shader.

---

**wowtrafalgar** - 2024-03-29 14:23

https://github.com/godotengine/godot/issues/35067

---

**wowtrafalgar** - 2024-03-29 14:23

I see

---

**wowtrafalgar** - 2024-03-29 14:26

any tips on how to minimize? I see in that thread MSAA can help

---

**tokisangames** - 2024-03-29 14:26

The thread gives solutions iirc

---

**tokisangames** - 2024-03-29 14:27

The shader adjustment worked for gd3. Don't know if it applies to gd4 as I can't frequently reproduce the fireflies

---

**wowtrafalgar** - 2024-03-29 14:29

so sounds like I would need to modify the terrain shader

---

**tokisangames** - 2024-03-29 14:36

At a minimum to experiment with the vertex shader

---

**4697570827** - 2024-03-29 15:08

hi, can anyone help me with this error: The addon script cannot be loaded along the path: 'res://addons/terrain_3d/editor/editor.gd'. This may be due to an error in the script code.
Disabling the 'res://addons/terrain_3d/plugin.cfg' addon to prevent further errors.

---

**narria** - 2024-03-29 18:05

I read it and got the docs but the process was confusing due to the nested subproject and it didn't clearly say I had to sync up two versions and even in the end it still had a 2.1 project for the demo project but in the end it all works.  And if I use this I will probably contribute to it in some ways ^_^

---

**tokisangames** - 2024-03-29 20:59

You didn't download or install it properly. Re-read the install directions and follow them exactly. There's also a tutorial video, but you also need to read the written install instructions.

---

**tokisangames** - 2024-03-29 21:06

You didn't need to build it yourself. The simple installation directions explain using the binary Releases. If you're going to build it yourself, which you chose to do, you needed to follow the more complex Build From Source documentation page which does clearly say you need to match the engine version, and exactly how to do it. All of it is extensively documented.

You're welcome to contribute, but again, read the docs on contributing, building from source, system architecture, and the API.

---

**ryan_wastaken** - 2024-03-31 05:52

For creating procedural terrain, would I want to use "Terrain3DStorage.import_images" or "Terrain3DStorage.add_region"?

---

**tokisangames** - 2024-03-31 06:00

Import_images calls add_region

---

**ryan_wastaken** - 2024-03-31 06:17

I have an issue with the control image and i dont know how to solve it.
```csharp
func generate_all_async():
    print("---------- Generating ----------")
    
    var images: Array[Image] = await call_on_thread(generate_images).wait_for_result_async()

    # temporarily disable control image
    images[1] = null

    terrain.storage.import_images(
        images,
        global_position,
    )

    print("---------- Done ----------")
```
When I disable using my custom control image, auto shading works just fine, but when i enable it, becomes broken.

📎 Attachment: image.png

---

**ryan_wastaken** - 2024-03-31 06:18

and this is the function im using to generate the control image
```csharp
func generate_control_image() -> Image:
    var img: Image = Image.create(size.x, size.y, false, Image.FORMAT_RF)

    var texture_id: int = 0
    var overlay_texture_id: int = 0
    var blend_amount: int = 0
    var is_hole: bool = false
    var is_navigation: bool = false
    var is_autoshaded: bool = true

    for x in size.x:
        for y in size.y:
            var color := TerrainControlMapUtil.encode_control_map_colour(
                texture_id, 
                overlay_texture_id, 
                blend_amount, 
                is_hole, 
                is_navigation, 
                is_autoshaded
            )
            img.set_pixel(x, y, color)
    return img
```

---

**ryan_wastaken** - 2024-03-31 06:20

and this is what im using to encode the colour.
```lua
class TerrainControlMapUtil:
    static func encode_control_map_colour(base_texture_id: int, overlay_texture_id: int, texture_blend: int, is_hole: bool, is_navigation: bool, is_autoshaded: bool) -> Color:
        var blend_int: int = int(clamp(round(texture_blend * 255.0), 0.0, 255.0))
        var bits: int = encode_base_texture_id(base_texture_id) | encode_overlay_texture_id(overlay_texture_id) | encode_blend(blend_int) | encode_hole(is_hole) | encode_navigation(is_navigation) | encode_autoshader(is_autoshaded)
        var dest: Color = Color(float(bits), 0.0, 0.0, 1.0)
        return dest

    # Encode functions
    static func encode_base_texture_id(value: int) -> int:
        return (value & 0x1F) << 27

    static func encode_overlay_texture_id(value: int) -> int:
        return (value & 0x1F) << 22

    static func encode_blend(value: int) -> int:
        return (value & 0xFF) << 14

    static func encode_hole(is_hole: bool) -> int:
        const NO_HOLE: int = 0
        const IS_HOLE: int = 1

        var value: int = IS_HOLE if is_hole else NO_HOLE
        return (value & 0x1) << 2
    
    static func encode_navigation(is_navigation: bool) -> int:
        const NO_NAVIGATION: int = 0
        const IS_NAVIGATION: int = 1
        
        var value: int = IS_NAVIGATION if is_navigation else NO_NAVIGATION
        return (value & 0x1) << 1

    static func encode_autoshader(is_autoshaded: bool) -> int:
        const NO_AUTOSHADER: int = 0
        const IS_AUTOSHADER: int = 1

        var value: int = IS_AUTOSHADER if is_autoshaded else NO_AUTOSHADER
        return value & 0x1
```

---

**ryan_wastaken** - 2024-03-31 06:21

Does anyone have any idea what im doing wrong? I've been trying to solve this issue for quite some time

---

**tokisangames** - 2024-03-31 06:48

* Import images requires all three image types at the moment. See importer.gd
* Terrain3DUtil exposes all of the encoding functions in 0.9.2-dev, demonstrated in the `latest` docs
* bools and ints cast to each other. false=0, true=1, non-zero=true
* Your fundamental problem is that you converted the `value` of your encoded bits instead of reinterpreting the `memory`.

---

**tokisangames** - 2024-03-31 06:48

> float(bits)
This is the problem.

---

**ryan_wastaken** - 2024-03-31 06:49

ok thanks, ill look into it

---

**tokisangames** - 2024-03-31 06:50

https://terrain3d.readthedocs.io/en/latest/api/class_terrain3dutil.html

---

**ryan_wastaken** - 2024-03-31 06:51

Im on 0.9.1 and I don't have that class. Is it available on the latest github release?

---

**tokisangames** - 2024-03-31 06:53

Read the documentation on the nightly builds. (and all of the `latest` documentation)

---

**ryan_wastaken** - 2024-03-31 07:02

I got it to work, Thank you!

---

**asterion_11** - 2024-03-31 11:36

Hey everyone! I'm working on a 3D game in Godot, and I'm using the Terrain 3D plugin for the landscapes. I've noticed a significant drop in frame rate (from 60 to about 25 FPS) whenever I add a texture from the plugin to the terrain. Even the default texture provided by the plugin causes this issue so the framerate is fine when there are no textures in the textures menu and there is only the "add new" option in the textures list but when i add a texture even the default one the plugin provides when you click that option I have a fps drop . I've tried adjusting the texture size and UV scale, but it doesn't seem to make much difference. Please note that this issue only occurs on mobile devices.  Could anyone help me troubleshoot this problem and suggest possible solutions? Thanks in advance for any assistance!

---

**asterion_11** - 2024-03-31 11:56

Here's the photo. The textures look identical but one of them tanks the framerate.

📎 Attachment: Screenshot_20240331_152448_Car_Arcade.jpg

---

**tokisangames** - 2024-03-31 12:28

Mobile is highly experimental. I don't know of anyone making a game with it yet. You'll need to be prepared to do a lot of experimentation and troubleshooting, and provide a lot more information about your device, setup, material settings, renderer, and game. Hopefully you are familiar with shaders.

---

**asterion_11** - 2024-03-31 12:55

I'm familiar with opengl shaders and a little bit of godot shaders. My mobile device is Samsung galaxy s20FE and the texture setup and material is as mentioned in my last message. The renderer is mobile. I'm not familiar with the source code of this plugin but if I were to make a guess the problem has something to do with the way textures are stored and accessed based on the fact that the default texture(when no texture is added) works fine

---

**tokisangames** - 2024-03-31 13:02

What about versions of godot and terrain3D?
The material has a lot of relevant options. What are your settings?
Textures are stored in a texture array.
There is no default texture. The checkerbox you see without textures is generated in the shader.
What texture formats have you experimented with? Are you using etc2 or astc?
You have of course read the mobile documentation and associated issues.

---

**sniderthanyou** - 2024-03-31 15:56

I'm excited to see it! What did you find insufficient with the existing tools, such that you felt the need to build your own? Different feature set, better performance, or just want a more integrated feel in the editor?

---

**sniderthanyou** - 2024-03-31 15:57

I suppose one benefit I can think of is keeping the LoD in sync

---

**tokisangames** - 2024-03-31 16:10

C++ is 100x faster. Existing external tools aren't built for 16k and larger terrains.

---

**sniderthanyou** - 2024-03-31 16:13

Roger dodger

---

**sniderthanyou** - 2024-03-31 16:29

Will the new foliage painter be built in to Terrain3D, or could you use it independently?

---

**asterion_11** - 2024-03-31 17:48

Both are the latest stable releases that are available. For the material options world background is set to none, texture filtering is linear, auto shader, dual scaling and shader override are all disabled and the rest are all the default settings. Ive also used a plain image(godot logo) as the texture but that didnt change anything. I have enabled the " import etc2 ASTC " option but I don't exactly know which one I'm using.

---

**tokisangames** - 2024-03-31 18:27

Try making an override shader, add your own sampler, and texture the terrain albedo with it and see what your frame rate is.

---

**tokisangames** - 2024-03-31 18:28

Built in

---

**soakil** - 2024-03-31 19:48

Hello, sounds like ... maybe a dumb question but how can I don't display/hide the dark/magenta navigable areas in game? 😓

---

**snowminx** - 2024-04-01 00:17

I bought some island heightmaps, but like they huge! like 8192 x 8192 lol Could I just scale the image down for use? I made one into an island to test and it is hugeee lol

---

**tokisangames** - 2024-04-01 01:45

Click any other tool

---

**tokisangames** - 2024-04-01 01:46

Yes, just crop or scale down in photoshop/gimp to whatever size you want

---

**snowminx** - 2024-04-01 01:47

Thank you

---

**tokisangames** - 2024-04-01 01:56

And you can scale brightness there, or leave it and scale height on import.

---

**snowminx** - 2024-04-01 01:57

I love the height scaling on import feature, cuz maybe you want a little more flat than some of the islands can be

---

**soakil** - 2024-04-01 10:34

I figured, thanks 🙂

---

**asterion_11** - 2024-04-01 14:35

Hi again. I did what you said and the framerate is still around 20 to 30. Any other suggestions on what can resolve this problem?

---

**asterion_11** - 2024-04-01 14:42

Also even when I set the ALBEDO to just pure black it still doesn't make a diffrence. The same bad fps as before

---

**tokisangames** - 2024-04-01 14:42

This terrain is driven by the GPU. Yours works fine with texture arrays and setting vertex height in vertex(), but so far it seems your GPU can't handle basic texturing.
Strip out all of the extra items in fragment() and test just using only the single texture albedo. If that's also slow, then indeed your card, driver, texture format is killing your performance. If it can't handle even looking up one texture at speed, then you need to explore the problem at a lower level than the shader.
If it does pick up speed, then you need to pick apart the shader and see what is slow and what not.

---

**asterion_11** - 2024-04-01 14:43

It runs fine on pc. This problem only occurs on mobile devices

---

**tokisangames** - 2024-04-01 14:44

Yes. At least one mobile device. Have you tested others? Your mobile device has a card, driver, and texture format.

---

**asterion_11** - 2024-04-01 14:56

I tested it on 3 mobile devices and the results were similar. I'll try to see which part of the shader causes the problem. Is there any specific part that you think slows down the game?

---

**tokisangames** - 2024-04-01 15:31

At this point, no idea. You haven't done enough testing to provide anywhere near enough evidence to determine a cause. You need to test different aspects to rule out things. You don't know if it's a problem with the shader.

* Strip down the shader to the most minimal, removing all unnecessary lookups. There is a minimal shader in the extras folder. The default checkerbox is a debug view, which you can enable in the material, or copy from the github source in src/shaders. 

* Does the most minimal, grey shader run fast w/ textures in the list? Or is it fast with an empty list and slow with? 

* Does a minimal shader with one custom texture operate fast or slow? Is it fast with an empty list and slow with contents, or is it always fast or slow?

* When the texture list is populated, the system generates TextureArrays out of the textures. I don't know what texture format you're using, or dimensions, or how much VRAM you're using. How much vram do you have on your device? VRAM filled up by the Terrain3D texture arrays is a possibility. Once the terrain is built, the CPU doesn't do anything. It's driven by the shader. You have a 60fps shader, and presumably some other results from the testing above. Texture arrays seem to work, as the heightmap is stored in one.

---

**tokisangames** - 2024-04-01 15:31

* Find out exactly what texture format you are using. The documentation explains what the s3tc/etc2/astc project settings do and where it generates the texture (ctex files). You can look at the file itself using a utility like unix `file` to tell what it is. Or read through the godot docs to know what format you're using depending on the Project settings AND Export settings. Then look at what your device supports. It most likely doesn't support DXT5, which your desktop is using.
```
file .godot/imported/you_died.png-fe0bca45e123abec11aab1216c569613.s3tc.ctex
.godot/imported/you_died.png-fe0bca45e123abec11aab1216c569613.s3tc.ctex: Godot 4 texture v1: 712 x 164 (rescale to 711 x 161), DXT5
```

* The easiest place to start troubleshooting is the shader. But the problem could be in VRAM allocation, CPU lag from other code in Terrain3D or your game, texture format incompatibility or inefficiency

---

**asterion_11** - 2024-04-01 17:50

After a bit of messing around with the shader here's what I found out:
The calculations in the fragment shader to compute the weights and materials causes the issue. When I use a custom sampler or use vec3 for the albedo and comment out the rest of the fragment shader the performance is great. However I don't know how to fix this issue as that part of the shader seems crucial

---

**tokisangames** - 2024-04-01 20:02

> calculations in the fragment shader to compute the weights and materials

Which calculation? Is it caused by branching, or texture reads, or by the math?

---

**tokisangames** - 2024-04-01 20:19

So what happened when you had a simple shader with a mostly empty fragment, and a grey albedo and experimented with an empty or non-empty texture list? Was there any difference?

What about the same with a single custom sampler and texture on albedo, any difference caused by the texture list?

---

**tokisangames** - 2024-04-01 20:27

I suspect your mobile card has a problem with branching. But you haven't shared enough testing results for me at least to make that determination. The existence of the texture list shouldn't matter. The speed difference should be fixable by removing the branches in the shader and turning the general, multi-option shader into one with a specific configuration.

---

**narria** - 2024-04-01 21:13

I went through that detailed doc. I think here it would help make it more clear if you added text like this 
## 3. Ensure you Right Versions For Main Project and godot-cpp Sub-Project
You need to check out the correct version of the main project and godot-cpp sub-project in order to have everything work correctly.  For example for Godot Engine 4.0.2 you need the following pair of versions
* **(godot-4.0.2-stable , godot-cpp 4.0.2)**
We are including updated versions in our updates so this step may not be necessary unless you get a lot of build errors or Godot crashes on load.

📎 Attachment: image.png

---

**tokisangames** - 2024-04-01 21:22

Thank you for the suggestion. I will consider it. Though I don't see that there is a material difference between the two. Perhaps the perceived difference is from being a native english speaker vs as a second language.

FYI, the main repo is on Godot-cpp 4.1.3, though we build for the 4.2.1 Engine. As the last paragraph states, it's not as strict as it once was.

---

**asterion_11** - 2024-04-01 21:23

All of them I guess. I couldn't really debug them individually because all of them depended on each other

---

**narria** - 2024-04-01 21:24

It makes a difference because you have an example of a userr (me) that didn't catch that she needed to version both the project and sub-project so it is probably worth calling out.  It is too bad that git doesn't let you have cross project tags so it is easy to get this screwed up.  BTW I am a retired senior software engineer from Apple and getting internal technical doc for setting up projects for newcommers is a challenging thing to get right but worth it when you do.

---

**asterion_11** - 2024-04-01 21:25

The simple shader had good performance. Empty and non empty list had similar good performances. Custom sampler also results in a good framerate.

---

**asterion_11** - 2024-04-01 21:28

So you're saying other users haven't had such a problem before?
You're correct the existence of texture list alone doesn't make a diffrence. The calculations in the fragment shader that's caused by creating a new texture causes the frame drop

---

**tokisangames** - 2024-04-01 21:29

It's most definitely not all of them. It may be 2, it's most likely only 1: branching

---

**tokisangames** - 2024-04-01 21:30

I shared that there are few mobile users. No one else has reported this performance issue

---

**tokisangames** - 2024-04-01 21:31

Convert the main shader into a branchless shader. Remove all if statements. You pick an execution path by stripping out all of the options that the general shader provides.

---

**tokisangames** - 2024-04-01 21:32

Or you can work the other way. Now that you have a simple shader that works at speed, gradually add things in from the original shader until you achieve the feature set you want. But exclude any if statements.

---

**asterion_11** - 2024-04-01 21:44

Strange. Alright thanks for the help so far. I'll try that

---

**stakira** - 2024-04-02 04:22

The amount of sampling is too much for mobile’s memory bandwidth.

---

**supersand21** - 2024-04-02 12:06

hello, I'm trying play around with procedural generation with terrain3d, but im currently having issues getting the control map to work correctly. Im following the docs here: https://terrain3d.readthedocs.io/en/stable/docs/controlmap_format.html
So far ive managed to get a heightmap and texture list programmatically added to a terrain3d node, and by default the terrain displays texture id 0 which is grass. I also have a stone texture with id 1 that i am trying to display using the control texture.

to do this i made a function based off the docs
```python
func calcControl(BaseTexture: int, OverlayTexture: int, Blend: int, Hole: int, Navigate: int, Autoshade: int):
    var v1: int = (BaseTexture & 0x1F) <<27
    var v2 = (OverlayTexture & 0x1F) <<22
    var v3 = (Blend & 0xFF) <<14
    # Reserved bits
    var v4 = (Hole & 0x1) <<2
    var v5 = (Navigate & 0x1) <<1
    var v6 = Autoshade & 0x1
    return v1 + v2 + v3 + v4 + v5 + v6```
to return an integer with the corresponding bit values that i then put into a 1024x1024 image to set the control texture:
```python
var imgHeight: Image = Image.create(1024, 1024, false, Image.FORMAT_RF) 
    var imgControl: Image = Image.create(1024, 1024, false, Image.FORMAT_RF)
    for x in 1024:
        for y in 1024:
            imgControl.set_pixel(x, y,  calcControl(0, 1, 244, 0, 0, 0))
            imgHeight.set_pixel(x, y, Color(noise.get_noise_2d(x, y)*0.5, 0., 0., 1.))
    terrain.storage.import_images([imgHeight, imgControl, null], Vector3(0, 0, 0), 0.0, 100.0)```
ive been testing the functionality of this by chaning the used texture ids and hole value, but i either get a default grass terrain or a black terrain. not the rocky or invisible terrain i would expect. Any ideas on what the issue could be?

---

**tokisangames** - 2024-04-02 12:48

Addition and Logical OR are two different calculations. calcControl might be technically correct but, right for the wrong reasons.
However your bigger problem is you are converting an int value to a float value rather than reinterpreting the memory so what you're writing to the pixel is entirely wrong. 
See https://discord.com/channels/691957978680786944/1130291534802202735/1223886576174632990

---

**tokisangames** - 2024-04-02 12:51

Also you should static type all of your code. That might have helped you here as you missed your invisible, implicit, and incorrect int to float cast.
Set_pixel takes a Color, not a float, and certainly not an int

---

**supersand21** - 2024-04-02 13:14

got it to work, thanks for the help!

---

**supersand21** - 2024-04-02 13:59

<@455610038350774273> would you know what the reason is for having a +/-(8192, 0, 8192) limit to terrain placement locations?

---

**tokisangames** - 2024-04-02 14:04

Because we use texture arrays, it's arbitrary. The true limit is the max of (45k, vram), but beyond 10k or so you may need double precision. There's an issue for expanded region sizes you can follow or contribute to.

---

**supersand21** - 2024-04-02 14:20

ok thanks, im asking because im trying to make a massive explorable world where, for example terrain3D would only ever have around 8x8 regions in memory but as the player explores i would load in new regions from storage and if the player were to only go in one direction i would like it to be possible to travel hundreds of regions without any hickups. I havent looked into how to do this much. Do you recon i would have to increase the 8192 limit in my own build of terrain3d to get access to a wider range of global coordinates but with same memory usage (since i would unload distant regions), or would this be possible in the existing build with some sort of region ofset i havent seen yet?

---

**tokisangames** - 2024-04-02 14:38

What is "massive"?

You will undoubtedly need a double precision build of the engine and Terrain3D.

We currently don't stream regions. All are loaded at startup. We could potentially unload in the future or you could contribute it.

Rather than thinking about making your own custom fork that you have to continually update and maintain, you should think about open tickets you can contribute an implementation to like the one highlighted. You want to maintain as little custom code in 3rd party projects as possible if you want a sustainable game business. While you might not be able to get all of your custom code in to the main tree, if 80% of it is universally useful, that means you only need to maintain 20% of it.

---

**minimumadhd** - 2024-04-03 18:30

What is Terrain3D heightmap importing absolute measuring unit? Is it Meters or what else? (In case, I have a terrain high 4390m and occupying 5km^2)

---

**wowtrafalgar** - 2024-04-03 18:32

I’m pretty sure it is meters

---

**minimumadhd** - 2024-04-03 18:33

*(no text content)*

📎 Attachment: lt38aZn.png

---

**minimumadhd** - 2024-04-03 18:33

Which one should I tweak for this?

---

**wowtrafalgar** - 2024-04-03 18:33

range for the height size for the 5km ^2

---

**minimumadhd** - 2024-04-03 18:36

While for the range? what would that be? for what my limited knowledge about terrain3d is i assume it's 4.390

---

**minimumadhd** - 2024-04-03 18:46

Also, I see from docs that I need to input a control and a color map, but Gaea (the engine i'm using) doesn't export any of these

---

**wowtrafalgar** - 2024-04-03 19:01

you can leave the control and color map empty that would be for assigning color or textures

---

**tokisangames** - 2024-04-03 19:49

1px = 1 vertex. Default mesh_vertex_spacing is 1m and adjustable.

---

**tokisangames** - 2024-04-03 19:51

If your heightmap is normalized, import scale=4390. If it's not, leave it alone.
Import doc has this information

---

**minimumadhd** - 2024-04-03 20:11

Will you make any tutorial on the subject like you did with the basics of terrain3d? It'd be pretty useful

---

**tokisangames** - 2024-04-03 20:14

On Importing heightmaps? It was already in my videos and there's a while document dedicated to it.

---

**minimumadhd** - 2024-04-03 20:37

Oh yeah, sorry, I just found it. Also, is that normal?

📎 Attachment: HBVjKtJ.png

---

**tokisangames** - 2024-04-03 20:42

Yes, I wrote that warning for your benefit. Follow the directions. Save your imported data in a res file.

---

**zdevz12** - 2024-04-04 07:33

Texture normals and roughness don't work for me,

---

**zdevz12** - 2024-04-04 07:34

I did everything you did in the video, import my texture etc, but my texture is flat

---

**zdevz12** - 2024-04-04 07:34

When trying to paint roughness it just stayed the same

---

**zdevz12** - 2024-04-04 07:34

It was not a basic error, there is no error in the output

---

**zdevz12** - 2024-04-04 07:35

I enabled the roughness map for debug and the result was something like this

---

**zdevz12** - 2024-04-04 07:37

I think the resolution of the canvas is very small but I don't know how to "enlarge" it

---

**zdevz12** - 2024-04-04 07:38

I confirmed this because when trying to paint on the surface, everything was painted pixelated like that image

---

**zdevz12** - 2024-04-04 07:38

I can't send images because I'm literally uninstalling windows

---

**zdevz12** - 2024-04-04 07:38

But

---

**zdevz12** - 2024-04-04 07:38

It would be great if you could help me resolve it

---

**zdevz12** - 2024-04-04 07:48

And hey

---

**zdevz12** - 2024-04-04 07:48

I have a question

---

**zdevz12** - 2024-04-04 07:48

Note that you are also the creator of the voxel tools

---

**zdevz12** - 2024-04-04 07:49

Why did you decide to make a heightmap editor and leave out the voxels?

---

**tokisangames** - 2024-04-04 09:17

No, that is Zylann. I worked with him on his module years ago and he is still working on it.

---

**tokisangames** - 2024-04-04 09:18

Let me know when you've finished setting up your system again and we will troubleshoot. You either missed a step or your original texture files are no good.

---

**adnerf** - 2024-04-04 15:09

That was a random ping lol 😂

---

**obeyeveryday** - 2024-04-04 19:36

is there a way or is it planned to use more than first 2 texture-id's as "autoslope", "auto-height", "autopaint" etc?

---

**tokisangames** - 2024-04-04 19:44

It doesn't use the first 2. It uses 2 that you specify in the material settings. If you want to mix in more than 2, enable the override shader and customize as you like.

---

**zdevz12** - 2024-04-04 22:18

Maybe i could help in creating a voxel terrain plugin, because I actually need a good plugin

---

**zdevz12** - 2024-04-04 22:18

I've done some research

---

**zdevz12** - 2024-04-04 22:19

This is currently the best plugin out of the others, but I don't like the idea of ​​heightmaps because they limit you to just the height of the terrain bruh

---

**mushroompixels** - 2024-04-04 22:25

How should I go about creating terrain? Should I make a map first then try to re create it in godot?

---

**snowminx** - 2024-04-04 23:20

Maybe you should create one if you need a good one instead of using one that is offered

---

**zdevz12** - 2024-04-04 23:44

Yes, that's what I'm doing

---

**snowminx** - 2024-04-05 00:13

That’s not what you had originally wrote lol

---

**zdevz12** - 2024-04-05 01:09

No, I was just wrong.

---

**zdevz12** - 2024-04-05 01:10

I don't speak English very well, so I use a translator

---

**snowminx** - 2024-04-05 01:32

Ah makes sense

---

**tokisangames** - 2024-04-05 01:35

Just use Zylann's voxel tools. It already has years of development and isn't limited to heightmaps. You can contribute there to improve it for your needs.

---

**tokisangames** - 2024-04-05 01:40

You need experience, then you'd be able to answer that question yourself. So use the tool to sculpt, practice, use photos of real life as reference, start over, download heightmaps to import, sculpt on top of those, and practice. Then you'll have experience. We remade the map for OOTA 5-6 official times before settling on our current layout, and we're still making significant changes. That's the fundamental reason we needed an in-editor tool instead of using a blender mesh.

---

**zdevz12** - 2024-04-05 08:33

Tokisan

---

**zdevz12** - 2024-04-05 08:33

How do you get the Inputs in a script tool?

---

**tokisangames** - 2024-04-05 10:19

I don't understand exactly, but you can look at importer.gd and codegenerated.gd for some examples of running terrain3d via code.

---

**badresult** - 2024-04-05 21:42

I saw the Terrain3DUtil is now usable in GDScript, but I am guessing it isn't in the 9.1 release and I want to try it out. I can't seem to download any of the nightly builds from the github action artifacts, am I missing something?

---

**tokisangames** - 2024-04-05 21:53

Yes. The artifact files for the builds are there.

---

**badresult** - 2024-04-05 21:54

I see them, but cant seem to download. Wonder if it's a permissions thing or if I need to be signed in

---

**tokisangames** - 2024-04-05 21:57

Yes, of course you need to sign in to github

---

**tokisangames** - 2024-04-05 21:57

Don't know why, but that came up in the past

---

**badresult** - 2024-04-05 22:00

I got it, didn't noticed I was signed out, not sure why it doesn't say anything about being signed in and just turns off the download button. Sorry about that

---

**zdevz12** - 2024-04-05 22:49

*(no text content)*

📎 Attachment: Screenshot_2024-04-05-15-48-54-58_572064f74bd5f9fa804b05334aa4f912.jpg

---

**zdevz12** - 2024-04-05 22:49

Somebody could help me?

---

**skyrbunny** - 2024-04-05 22:55

That should work as it is. There is context we’re missing. Also <#858020926096146484>

---

**zdevz12** - 2024-04-05 22:55

Tks

---

**buntaga** - 2024-04-05 23:56

any idea why textures don't show up here

📎 Attachment: image.png

---

**tokisangames** - 2024-04-06 03:20

Did you enable the plugin?

---

**buntaga** - 2024-04-06 08:48

Not sure what that means, I just followed the steps in the part 1 video

---

**saul2025** - 2024-04-06 08:53

he means that if in project sethings- plugins the terrain 3d is on.  If you did so then try reinstall the plugin or restart the editor.

---

**buntaga** - 2024-04-06 09:17

alright, thanks for clarifying it so quickly! it worked

---

**Deleted User** - 2024-04-06 16:20

hello. i would need some help. why when i preview the camera everything looks good, but when i run the scene, it looks like this:

📎 Attachment: image.png

---

**tokisangames** - 2024-04-06 16:26

Set your camera manually when working with custom viewports
And look at your console that probably tells you more messages

---

