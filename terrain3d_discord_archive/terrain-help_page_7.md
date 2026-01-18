# terrain-help page 7

*Terrain3D Discord Archive - 1000 messages*

---

**melgibzon** - 2025-03-25 22:13

those rocks are not part of the terrain

---

**melgibzon** - 2025-03-25 22:13

and thats fortnite uefn

---

**melgibzon** - 2025-03-25 22:13

even epic games does this

---

**melgibzon** - 2025-03-25 22:14

witcher 3 cave enterance

---

**melgibzon** - 2025-03-25 22:14

*(no text content)*

📎 Attachment: latest.png

---

**melgibzon** - 2025-03-25 22:14

something you can't unsee after you know why 😄

---

**melgibzon** - 2025-03-25 22:14

*(no text content)*

📎 Attachment: latest.png

---

**melgibzon** - 2025-03-25 22:14

you know there's a BIG HOLE in the ground 😄

---

**melgibzon** - 2025-03-25 22:14

and it will look bad from distance

---

**melgibzon** - 2025-03-25 22:14

if you don't have a turtle neck around it

---

**melgibzon** - 2025-03-25 22:15

or a collar

---

**melgibzon** - 2025-03-25 22:15

I mean you could probably mask it somehow with lods, but aint nobody got time for that i guess

---

**melgibzon** - 2025-03-25 22:25

in skyrim if you had a cave you could go in to just like that without a loading screen

📎 Attachment: 1200px-EOTV-place-Snowspinner_Cave.png

---

**melgibzon** - 2025-03-25 22:26

you noticed that the ground turned in to rock meshes

---

**melgibzon** - 2025-03-25 22:26

instead of natural terrain

---

**melgibzon** - 2025-03-25 22:26

and always a "collar" around the enterance

---

**melgibzon** - 2025-03-25 22:26

which is super thick that the lod from distance doesnt revela the hole

---

**melgibzon** - 2025-03-25 22:32

one dev I knew said Never want to be a magician, if you know how the illusion works all the magic in your life will be gone 😄

---

**waterfill** - 2025-03-25 23:06

With the plugin have any way to make caves like these?

---

**tranquilmarmot** - 2025-03-25 23:07

Yes, you can put a "hole" in the terrain and then place the cave mouth inside of the hole. You have to make the geometry for the cave in an external program (Blender) and it's not part of the terrain.

---

**tranquilmarmot** - 2025-03-25 23:11

In the example above from the Witcher 3 (which is what Terrain3D's system is sort-of based on), you can see the "cave mouth" geometry (I outlined it in red) covering up the "hole" in the terrain (in green)

📎 Attachment: Screenshot_2025-03-25_at_4.08.36_PM.png

---

**waterfill** - 2025-03-25 23:14

but how would I create the side hole from one mouth to the other using the plugin? that part I didn't understand very well

---

**waterfill** - 2025-03-25 23:15

Would it just be raising the ground and digging horizontally? To make a hole from one end to the other?

---

**waterfill** - 2025-03-25 23:22

like this?? idk xD

📎 Attachment: image.png

---

**melgibzon** - 2025-03-25 23:30

what do you mean side hole?

---

**waterfill** - 2025-03-25 23:32

I mean a hole instead of being up or down, a hole inside the hill, horizontally

---

**melgibzon** - 2025-03-25 23:32

*(no text content)*

📎 Attachment: image.png

---

**melgibzon** - 2025-03-25 23:32

like this ?

---

**waterfill** - 2025-03-25 23:33

like this, but the ground but the floor is leaky

📎 Attachment: image.png

---

**waterfill** - 2025-03-25 23:33

yes!!

---

**melgibzon** - 2025-03-25 23:33

making a hole is just deleting faces 😄

---

**waterfill** - 2025-03-25 23:33

but what about inside terrain3d?

---

**melgibzon** - 2025-03-25 23:33

*(no text content)*

📎 Attachment: image.png

---

**melgibzon** - 2025-03-25 23:33

red = faces that are to the inside

---

**melgibzon** - 2025-03-25 23:33

you make a new mesh

---

**waterfill** - 2025-03-25 23:34

I know how to do it in Blender, but I wanted to know if Terrain3D also makes this hole!

---

**melgibzon** - 2025-03-25 23:35

you basically make a new model or mesh

---

**melgibzon** - 2025-03-25 23:35

like 4 cubes

📎 Attachment: image.png

---

**melgibzon** - 2025-03-25 23:35

*(no text content)*

📎 Attachment: image.png

---

**melgibzon** - 2025-03-25 23:35

drag em out and give them collision

---

**melgibzon** - 2025-03-25 23:36

*(no text content)*

📎 Attachment: image.png

---

**melgibzon** - 2025-03-25 23:37

*(no text content)*

📎 Attachment: image.png

---

**melgibzon** - 2025-03-25 23:37

THATS THE CORE CONCEPT

---

**waterfill** - 2025-03-25 23:38

You say you do this in terrain3d, right? Throw the objects that will serve as wall and floor with collision inside the hole made?

---

**melgibzon** - 2025-03-25 23:38

*(no text content)*

📎 Attachment: image.png

---

**melgibzon** - 2025-03-25 23:38

you give those cubes collision

---

**melgibzon** - 2025-03-25 23:38

inside of the mountain will still be red

---

**melgibzon** - 2025-03-25 23:39

you just walk through custom meshes

---

**melgibzon** - 2025-03-25 23:39

*(no text content)*

📎 Attachment: image.png

---

**melgibzon** - 2025-03-25 23:39

if you step in red you fall through map

---

**waterfill** - 2025-03-25 23:39

perfect!!

---

**melgibzon** - 2025-03-25 23:39

thats how most games do caves

---

**waterfill** - 2025-03-25 23:39

thanks so much 😄

---

**melgibzon** - 2025-03-25 23:40

or you could make it so when you hit "dark cave enteracne"

---

**melgibzon** - 2025-03-25 23:40

you load a new scene

---

**melgibzon** - 2025-03-25 23:40

that is inside the cave

---

**melgibzon** - 2025-03-25 23:40

like doors and interiors in skyrim

---

**melgibzon** - 2025-03-25 23:41

just use same rock material on the custom meshes

---

**melgibzon** - 2025-03-25 23:41

give it triplanar

---

**melgibzon** - 2025-03-25 23:42

with world coordinates

---

**melgibzon** - 2025-03-25 23:42

it will feel mostly the same like the mountain

---

**waterfill** - 2025-03-25 23:42

Yes, I'm still going to decide what to do, as the game will be isometric and I still have to see how the camera will behave with the hill in front.

---

**cirebrand** - 2025-03-26 01:16

I believe I had a nightly build / similar when xtarsia worked on the feature for fixing walls between regions -> empty space. (Would link the build but it is fixed on latest nightly build)

😃 So seems it's not an issue!

---

**tokisangames** - 2025-03-26 03:18

Use the hole brush. Make a hole. Put meshes around it. Look at the demo. This was already done for you to analyze.

---

**xtarsia** - 2025-03-26 06:05

If you used a nightly from my current PR this could happen as I renamed get_region_uv() but hadn't updated the editor/debug shader code yet. Already addressed with latest comit. (I had actually missed it before)

---

**kesocos** - 2025-03-26 13:13

Hi folks, I was wondering on how I could possibly remove the extra non used regions that comes by default when creating a terrain node? by extra non used regions I mean this :

📎 Attachment: Screenshot_2025-03-26_14-05-34.png

---

**xtarsia** - 2025-03-26 13:18

Click the terrain3d node > look at the inspector for the Terain3d node > click and expand Terrain3DMaterial > change world background to none.

---

**kesocos** - 2025-03-26 13:19

That worked, thanks a lot

---

**ricksan4552** - 2025-03-26 19:41

I'm planning a real-world project with a map consisting of five 8k (i.e. 8192) squares. Three are arranged N-S, one is east of the northernmost square, and one is west of the southernmost. I'm using heightmap data obtained in QGIS, which is further processed in Krita to create the five squares (which, conveniently, compensated for the oblong latitude-to-longitude ratio). I exported a single 8k heightmap into Terrain3D as .r16 which worked fine. However, the Importer would not accept heightmaps for any of the adjacent squares. Perhaps 8k is too big? If so, what max size size heightmap images are recommended? Should the 0,0 position (origin) be at the center of the overall map, with individual maps offset relative to that origin? Incidentally, I'd like to use a region size of 1024, but I'm flexible. Also what do the "R 16 Size" X and Y Importer parameters do?

---

**tokisangames** - 2025-03-26 20:11

When it failed to import, it probably gave you an error message that explained the issue. The importer will accept coordinates within about `+/-16*region_size`. 

As the introduction documentation explains, you get 32x32 regions centered around 0,0. 5*8k 40,000 across is larger than 32,768, so you cannot use a region size of 1024, and must use 2048.

---

**rogerdv** - 2025-03-26 20:55

Guys, Im having a problem in my project. I am testing in different PCs and half of them fail to run the scene that contains a Terrain3D. I just get a black screen and the UI. Any basic 3d scene with a model or something works (which means I can load my game and create a character). In the console I get a ton of this error ERROR: Source texture must be multisampled

---

**rogerdv** - 2025-03-26 20:56

Tested on Windows, RX 6600, RTX 4060 (latop), not working. Tested on RX 7900 and GTX 1060, working perfectly. The project runs on that same RX 6600 under Linux without issues.

---

**tokisangames** - 2025-03-26 20:58

What versions? Show the full error exactly. Does the demo work? Don't make us guess or work for information.

---

**rogerdv** - 2025-03-26 20:59

Godot 4.4. Im having similar issues with the demo, it works on some setups, but not in others

---

**rogerdv** - 2025-03-26 21:02

And that is the exact error. I copied it from the console

---

**tokisangames** - 2025-03-26 21:03

Terrain3D version. I'm sure the error has more, like the line of code. It's not a Terrain3D error or it would say "Terrain3D". 
Similar issues with the demo? Not exact? Again, don't make us work for information.

---

**rogerdv** - 2025-03-26 21:05

Sorry, it has been a while since I ran the demo. I think the error is related to some server, it is not terrain. Im just trying to figure out what to search and what is the cause, so I can fill a bug report in Godot

---

**rogerdv** - 2025-03-26 21:05

Plugin is 0.9.3a

---

**jakobismus** - 2025-03-26 21:16

Any idea why I'm getting a bunch of meshes at runtime that don't exist in the editor? Disabled my plugin so it's not that. When I delete the mesh they're gone, but when I re-add the mesh, they come back
Wonder if I'm messing with the data in the wrong way..but then again, it works fine in the editor 🤔

📎 Attachment: Screenshot_From_2025-03-26_21-02-09.png

---

**tokisangames** - 2025-03-26 21:17

Are the transforms in `Terrain3DRegion.instances`?

---

**jakobismus** - 2025-03-26 21:29

Counting all xforms with this snippet, I think this is right https://gist.github.com/jgillich/d92a5049076051ccc06f004130583be6
Returns 33. But my whole map is full of trees 😄

---

**tokisangames** - 2025-03-26 21:33

Terrain3DInstancer.dump_data(), dump_mmis(). Or if saved to disk, you can just open up the region res file and look at the dictionary in the inspector. MMIs you can look at in the remote debugger. Obviously you have more than 33 instances in the dictionary.

---

**jakobismus** - 2025-03-26 21:43

dump_data returns about the same https://gist.github.com/jgillich/5bc429d06685cfa4aa01638413cfce90

---

**tokisangames** - 2025-03-26 21:48

You can get the exact count from the MMIs in the remote scene tree.
Looks like you'll need to enable debugging and review the logs to figure out why the MMIs are displaying transforms you don't have data for.

---

**jakobismus** - 2025-03-26 22:05

Oh god I'm a moron, forgot about a random piece of test code that generated them 🤦‍♂️ 
Sorry for wasting your time lol

---

**melgibzon** - 2025-03-26 22:38

don't worry happens to everyone 😄

---

**aldebaran9487** - 2025-03-26 22:44

To follow the fill on particule grass, I have try the particles grass repo, i updated the addon to the 0.9.3a version.
It's seems to "work" when i comment this :
`#var grass_materials := PackedByteArray()
    #grass_materials.resize(terrain.texture_list.get_texture_count())
    #for i in range(terrain.texture_list.get_texture_count()):
        #var t = terrain.texture_list.get_texture(i)
        #if t.has_meta(&"grass"):
            #grass_materials[i] = t.get_meta(&"grass", 0) + 1
    #particles.process_material.set_shader_parameter(&"terrain_grass_materials", grass_materials)`

But, if the project launch and the particles are visibles and move with the camera, they are all at Y = 0.
It seems that when the script get informations from the Terrain3D shader (like heightmap), it fail to obtain some of them.
I tested in the debogger (evaluator), and i can access noise_texture like that ;
`terrain.material.get_shader_param("noise_texture")`
But, if i try `terrain.material.get_shader_param("_height_maps")`, it return null.

I suppose it's because "_" prefix ? It's a common behaviour with godot shader value ?

So, to made it simple, how can i get the missings values to put in the particule shader ?
How can i get terrain heightmap at runtime ?

---

**melgibzon** - 2025-03-26 22:49

Make a new empty project or open Terrain3D demo project, click on terrain 3D inspector
And start tweaking every value from top to down 😄 and then just CTR + Z them to see what they do

---

**melgibzon** - 2025-03-26 22:49

one of the fastest way to learn any program

---

**melgibzon** - 2025-03-26 22:49

I do the same thing in blender also when I'm not sure what a slider without a tooltip does (often the case with extensions or plugins)

---

**xtarsia** - 2025-03-26 22:52

I can share what I made yesterday.

---

**aldebaran9487** - 2025-03-26 22:53

Following this doc : https://terrain3d.readthedocs.io/en/stable/docs/tips.html#using-the-generated-height-map-in-other-shaders
I have try to set the shader param like this : RenderingServer.material_set_param(particles.process_material, "terrain_height_maps", terrain.get_data().get_height_maps_rid())
But i have no luck, if terrain.get_data().get_height_maps_rid() return an RID, the param don't seem to be setted in the particle shader

---

**xtarsia** - 2025-03-26 22:53

I was going to try sneak it into extras but its not polished enough for that yet

---

**xtarsia** - 2025-03-26 22:54

*(no text content)*

📎 Attachment: Example_gpu_particles_3d.gd

---

**melgibzon** - 2025-03-26 22:55

*(no text content)*

📎 Attachment: image.png

---

**aldebaran9487** - 2025-03-26 22:57

setting the param to none don't do that ?

---

**aldebaran9487** - 2025-03-26 22:57

thanks, i will try it, you use RenderingServer.material_set_param(process_rid, "_height_maps", terrain.data.get_height_maps_rid()), so it's working for you ?
I must have made an error somewhere then.

---

**melgibzon** - 2025-03-26 23:00

why not set to none? If you have an interior scene with some mountains in the background you can see out the window

---

**melgibzon** - 2025-03-26 23:00

and don't need other regions in the distance it should be fine or is there some reason Im not aware of? 😄

---

**aldebaran9487** - 2025-03-26 23:10

Sorry, I thought you were asking the question, but in fact you were answering it ^^

---

**tokisangames** - 2025-03-26 23:14

I followed the directions in the docs just now. Made a cube, added a material, attached the heights rid to texture_albedo, ran the scene and can see the heightmap on the cube.

---

**aldebaran9487** - 2025-03-26 23:50

Yeah, i just do the test, it's displayed on a cube.
I also tried your code, i have set 100 particles and the row count to 10.
The code needed a check before reading camero position, but except that it seems to  work.
But, i can't see the particles.

---

**aldebaran9487** - 2025-03-26 23:50

Oh, its seems to work if i set the mesh in the particule, and not from the script.

---

**aldebaran9487** - 2025-03-26 23:51

I will continue playing with it, thank a lot for your guidance ::)

---

**teadinker** - 2025-03-27 09:40

Hello all. I am enjoing the terrain tool quite a lot, but I am struggling to get something to work properly. How would I go about lowering the entire terrain by 50 units on the y-axis? Is this even possible?

---

**tokisangames** - 2025-03-27 10:15

Use the height brush at -50

---

**tokisangames** - 2025-03-27 10:17

Or if already sculpted, make a script to use terrain.data.get\_height and set\_height

---

**teadinker** - 2025-03-27 10:18

Ahh the height brush. Wow I feel silly! Thank you. Also good idea with the script to modify it. It does seem that edges will jump up to y = 0. I assume this is just how the system is built?

---

**tokisangames** - 2025-03-27 10:20

Edges of None background go to what you set. Flat background assumes sea level is zero. Modify the shader if you want a different level

---

**teadinker** - 2025-03-27 10:25

Thank you Cory. This has been incredibly helpful and I am now well on my way to prettify my sea bed!

---

**zephyrus375** - 2025-03-27 11:51

According to this topic, I've found that code ```img.set_pixel(x, y, Color(noise.get_noise_2d(x, y)*0.5, 0., 0., 1.))``` in this demo script. There's any way how to change noise texture to make procedural generated islands? What should I change in this code?

📎 Attachment: Godot_v4.4-stable_win64_U6qZGf3uhd.png

---

**tokisangames** - 2025-03-27 12:02

I've already written a demo to show you how to procedurally generate. I can't do everything for you. Learn how to customize the noise library to get the shape you want. If you want holes around blocks of land, enable them on the control map. Look through the data API. Really you should familiarize yourself with the entire API of you're going to procedurally generate.

---

**aldebaran9487** - 2025-03-27 12:28

Your shader is pretty cool, it's way more simple than the previous one.
And the result is stunning ! You allow me to prettyfy my terrain a lot !

📎 Attachment: image.png

---

**pace_p** - 2025-03-27 13:44

can anyone point me to a possible tutorial for runtime terrain modification?

---

**fr3nkd** - 2025-03-27 16:47

My client wants a stylized low poly map, is there a way to stop the LOD system?

📎 Attachment: terrain_lod.mp4

---

**aldebaran9487** - 2025-03-27 16:52

If you set it to 1 it do the trick ?

📎 Attachment: image.png

---

**tokisangames** - 2025-03-27 16:53

Maybe decrease lods to lowest, and increase the mesh size to highest, and high vertex spacing. We could probably expand mesh size/lod limits.

---

**xtarsia** - 2025-03-27 16:53

geomorphing works really well the lowpoly (coming this week!)

alternative, would be to use vertex spacing 2 (or more), max mesh size, and use only 2 or 3 LODs

---

**image_not_found** - 2025-03-27 16:53

You don't need to touch the lod, simply increase the distance between the vertices if you want low terrain resolution

---

**fr3nkd** - 2025-03-27 16:54

And can I paint the tarrain using the flat shaded shader?

---

**xtarsia** - 2025-03-27 16:55

there is a color map only example

---

**xtarsia** - 2025-03-27 17:20

Cheers, it's not bad for a quick draft. I have a fair number of ideas about improving it!

---

**aldebaran9487** - 2025-03-27 17:35

On a similar shader, i have been able to reduce not showed particles by offsetting and turning the grid to keep the particle in front of the player. The player is in a border, not at the center of the grid.
To ensure correct position of the particles, i have also rasterized the rotated grid.
I'm just a student with gamedev, but i don't have see this idea before. I can send you the shader if you want and a reddit thread where a genuis explained me how to do that.

---

**xtarsia** - 2025-03-27 18:06

Certainly worth looking at.

---

**amceface** - 2025-03-27 19:34

*(no text content)*

📎 Attachment: image.png

---

**amceface** - 2025-03-27 19:35

How can I fix this issue? There are certain areas where the nav mesh will go through the terrain

---

**xtarsia** - 2025-03-27 19:39

try baking with a lower LOD (eg use LOD3 instead of 4), baking will be a bit slower tho.

---

**tokisangames** - 2025-03-27 19:50

That's very likely not an issue. The nav mesh isn't supposed to perfectly shrink wrap the terrain. This is just a debug display. Verify your unit can or cannot traverse that space.

---

**amceface** - 2025-03-27 19:53

my agents get stuck in this area

---

**tokisangames** - 2025-03-27 19:57

The terrain appearing over the navmesh is basically meaningless. The agent is probably getting stuck because the navmesh looks terrible with those extremely long polygons. Try what Xtarsia said, or more likely play with the navigation settings to refactor how it generates, such as adjusting cell size. You're aiming for a better topology. Looks like you need to change your settings to have it exclude your trees anyway.

---

**amceface** - 2025-03-27 20:12

How do I decrease the LOD of the nav mesh??

---

**tokisangames** - 2025-03-27 20:17

Actually never mind that. Navigation is already baked at the highest resolution. We've given Godot all of the data for every vertex. If it generates a terrible looking nav mesh, it's out of our hands. You need to adjust the navmesh settings, or reshape the navigable area to get it to give you a good mesh.

---

**tranquilmarmot** - 2025-03-27 21:24

I ended up increasing cell height/size in the `NavigationMesh` from the default `0.25` to `0.3` to fix an issue similar to this

---

**userl5cfoc71th33cf** - 2025-03-28 04:09

help

📎 Attachment: image.png

---

**userl5cfoc71th33cf** - 2025-03-28 04:09

*(no text content)*

📎 Attachment: image.png

---

**userl5cfoc71th33cf** - 2025-03-28 04:27

Nvm I had an older version

---

**aldebaran9487** - 2025-03-28 08:23

Hi again, I found the code I was talking about:
https://gist.github.com/aldebaranzbradaradjan/c0382b02d225cae00b415548f9b503e5
It works basically the same as yours, but instead of a grid centered on the player, we define a triangle, with a rotation that follows the player's, and we rasterize this triangle to get the positions the different particles should take.

I haven't found anything better than a big loop, though. I have another version with a rectangular shape (it's neater, i can even have multiples gpuparticules, to make more complex shape): https://gist.github.com/aldebaranzbradaradjan/e5ee9ce1b736a40d3b9d04e4488f7202

The Reddit post by tunawasherepoo explained how to do it (with a very nice example):
https://www.reddit.com/r/godot/comments/y6afq4/comment/l56grl2/?context=3

---

**xtarsia** - 2025-03-28 08:36

Ah yes, that desmos makes it very clear. I'll have a play when I get home, thanks!

---

**aldebaran9487** - 2025-03-28 08:51

yeah desmos is really nice to use !

---

**aldebaran9487** - 2025-03-28 18:13

I have try to apply the rasterized grid method on your particle shader, it's working, but there is some caveat.
First i do 2 imbricate for loop to rasterize the grid (i don't figure out a better method).
And secondly, in the manner i do it i don't use all the particles, i need a better method to rasterize, or at least a not buggy one.
But, it's working for the most part i think.

📎 Attachment: image.png

---

**aldebaran9487** - 2025-03-28 18:14

Note how the particle are around there origin, they also follow the camera rotation to always be in the front.

---

**lutcikaur** - 2025-03-28 18:52

Hey could i get a sanity check?

I've been drawing ability hitboxes on the terrain by setting the terrains material subviewport texture, to one that im fueling with _draw() calls, and once i started building my maps with more than one region i realized its being duplicated on all regions... so that will get pretty bad pretty quick.

I liked _draw because it was kinda performant enough.. and easily mappable to a 2d represntation of the game for debugging. But im guessing that i should just swap to decals shouldnt I?

---

**tokisangames** - 2025-03-28 19:46

I understand the individual words, but not when you put them together without context. The terrain material doesn't have a subviewport texture.

---

**lutcikaur** - 2025-03-28 19:52

```
Terrain3D node; //script on the terrain
_t3dMaterial = node.Get("material").AsGodotObject();
SubViewport svp; //from elsewhere
var resp = _t3dMaterial.Call("set_shader_param", "subviewport_texture", svp.GetTexture());```
Basically i have a canvas with a custom viewport, the custom viewport gets fed into my terrain after I instantiate it, and then when i need to draw onto it, i instantiate a special Node2D and add it as a child to that canvas, and use its _Draw() override to paint onto the terrain.

---

**tokisangames** - 2025-03-29 05:07

What's the size of your texture? It's probably set to repeat, not "duplicated". You'd need one as large as your entire terrain, which is a waste of vram.

---

**tokisangames** - 2025-03-29 05:07

You could use decals or draw on the colormap.

---

**lutcikaur** - 2025-03-29 05:29

the SubViewport is 8192x8192 with a size2d override of 512x512. I opted to keep it repeating (i also dont see where to change it) because I am working around that by... Tracking  Position, and Position%512, and then drawing only things close in world position, but drawing them onto the texture at position%512, and using the repeating texture to my advantage because its a 3rd person combat game, i'll never really see stuff thats being duplicated on the other side 😅 . I was going to go into decals because i'll need to eventually but I was crashing when loading in new terrains on Forward+, so i am stuck on compatibility for now. (linux, hybrid nvidia graphics suck)

---

**paperzlel** - 2025-03-29 16:13

Is there a reason why using `Terrain3D.change_region_size(Terrain3D.SIZE_64)`causes godot to close the game? I'm assuming that it's a change from 4.4/4.3 that's breaking it

---

**xtarsia** - 2025-03-29 16:22

There the modified version of your

---

**tokisangames** - 2025-03-29 16:34

Changing region size in 4.4.1 w/ Terrain3D 0.9.3a works fine in the demo on my system. You'll need to do a lot more testing, debugging and providing information.

---

**paperzlel** - 2025-03-29 16:44

Ah, it's because the node isn't added into the scene tree when I modified the region size.

---

**rogerdv** - 2025-03-30 14:41

Need some advice about optimization. My game is an isometric RPG, what settings are recommended for such view where distance to terrain doesnt changes and visible area is limited to a section of the scene?

---

**rogerdv** - 2025-03-30 14:42

Yesterday I spent some time reducing region size to 128 and removing unused regions, does it has some impact in perfomance?

---

**tokisangames** - 2025-03-30 15:16

You're using an overhead orthographic camera? Distance still matters. Look at the wireframe, View Information and FPS and you'll see they definitely change based on distance. Play with the mesh settings for what is optimal. Don't have it generate outside of your camera FOV. 

Play with all of the material settings, or use the lightweight shader in extras.
Reduce dynamic collision to the smallest possible that you need, or disable collision altogether.

Removing unused regions saves VRAM. Smaller region sizes is better for teams and git users, but doesn't make much difference for performance until region streaming exists.

---

**image_not_found** - 2025-03-30 15:24

Depends on what kind of graphics (low poly, realistic, etc...) you're going for, and what platform you're targeting

---

**rogerdv** - 2025-03-30 15:25

Not ortho, perspective with small fov, to simulate old isometric games

---

**rogerdv** - 2025-03-30 15:26

Ortho produced a lot of weird errors and I discarded it when I saw what Adam Lacko did in his fallout 2 clone

---

**image_not_found** - 2025-03-30 15:26

For desktop platforms using Forward+ renderer, on anything newer than 10 years old midrange (200€ GPU from 10 years ago) hardware you probably won't have issues (I'd expect 100+ FPS even in complex scenes due to limited amount of items on screen at once)

---

**rogerdv** - 2025-03-30 15:27

Im getting around 170 in my rx 6600 under libux

---

**rogerdv** - 2025-03-30 15:28

But currently I have only one light, and very little details. Just a lot of modular houses

---

**image_not_found** - 2025-03-30 15:29

(at 1080p)

---

**rogerdv** - 2025-03-30 15:30

Hmm, terrain works un compatibility renderer?

---

**image_not_found** - 2025-03-30 15:31

If you're targeting desktop, use Forward+, it scales better when you throw more things at it (also no color format issues happening with lights depending on whether they cast shadows or not)

---

**image_not_found** - 2025-03-30 15:31

For the houses, I'd check the amount of geometry if there's a lot of them: https://www.youtube.com/watch?v=hf27qsQPRLQ

---

**image_not_found** - 2025-03-30 15:32

Otherwise, another thing that could have an impact on GPU time is whether you have expensive postprocessing effects enabled (SSAO, SSR, etc...)

---

**image_not_found** - 2025-03-30 15:32

These don't need any optimizations, they're essentially a fixed cost no matter what you render

---

**rogerdv** - 2025-03-30 15:32

The kitbash I use is low poly.

---

**tranquilmarmot** - 2025-03-30 15:59

This video was great, thanks

---

**aldebaran9487** - 2025-03-30 16:01

On that, ssr has a monstruous cost, far more than what i have expected. I don't know how it works in other game engines, but it seems pretty heavy in godot.

---

**image_not_found** - 2025-03-30 16:03

Disabling rough SSR in the environment project settings makes it cheaper if you didn't know

---

**image_not_found** - 2025-03-30 16:04

Still, considering that it runs at half of the screen resolution (1/4th of pixels), it is expensive

---

**image_not_found** - 2025-03-30 16:04

Also it takes ~150MiB of extra buffers in VRAM on a 1080 screen

---

**aldebaran9487** - 2025-03-30 16:04

Oh i didn't know that i will test it thanks !

---

**biome** - 2025-03-30 16:50

<@188054719481118720> since you coded this feature I think it's best to pick your brain with this. I love the projection but it creates some odd artifacts in my usecase, firstly with the default projection settings: 

Moving it to 0.9 makes the autoshader cliff better, but you can start to notice some stretching in the grass texture itself now, moving it forward 0.99 just makes it worse and worse but the cliff face looks better! I realize this is usually used with much higher textures, but im using 64x64 ones 😮

📎 Attachment: image.png

---

**xtarsia** - 2025-03-30 16:58

The current method is vertical or flat, much closer to usual triplanar, but without the large distance blend, as it will only blend with adjacent control map indices.

Its based on the normal for a given index. It might have to be something that's paintable, or per texture in the future.

For the screenshots there, id say to use a threshold around .8 and paint the grass closer to the cliff base.

Its always a trade off between different things.

Its possible to have a more surface accurate method, but it may break the horizontal lines a bit more.

---

**biome** - 2025-03-30 17:10

is it possible to force it to only affect the overlay texture? having 0.99 projection threshold makes the walls perfect but messes up the base 🤔

---

**xtarsia** - 2025-03-30 17:13

Hmmm it should be possible to make it per texture.

---

**biome** - 2025-03-30 17:19

i think with that then it would be perfect for my usecase, i was the original one asking if this was possible in here earlier in the year 😂

---

**slimfishy** - 2025-03-30 17:43

How to update Terrain3D without breaking stuff

---

**image_not_found** - 2025-03-30 17:43

"no"

---

**image_not_found** - 2025-03-30 17:44

Jokes aside, you should specify what issue you're having

---

**slimfishy** - 2025-03-30 17:44

I have no issue yet

---

**slimfishy** - 2025-03-30 17:44

I am trying to avoid having the issue haha

---

**slimfishy** - 2025-03-30 17:44

Im currently on a 0.9.3 version

---

**slimfishy** - 2025-03-30 17:44

So i wonder how to smoothly update

---

**slimfishy** - 2025-03-30 17:44

As there is no update button

---

**image_not_found** - 2025-03-30 17:45

Upgrade by replacing files then fix what breaks :P

---

**image_not_found** - 2025-03-30 17:45

If you're worried about breaking the project because you're not using version control (you should) copy all of the project somewhere else first, then replace the files

---

**image_not_found** - 2025-03-30 17:46

Once you've done that, open it in Godot and if there's issues then it's time to fix them

---

**slimfishy** - 2025-03-30 17:46

Im using git, just was wondering if there is an official update guide or something

---

**slimfishy** - 2025-03-30 17:47

Okay, will try doign it manually

---

**slimfishy** - 2025-03-30 18:24

alrighty so i updated but the terrain3d.res data is not loading properly

📎 Attachment: image.png

---

**image_not_found** - 2025-03-30 18:45

I updated from 0.9.3a, to an intermediary commit build some time back, to 1.0 today and aside from an issue with height blending (it was textures missing alpha), I didn't have anything like this happening

---

**image_not_found** - 2025-03-30 18:46

So I don't really know what could be causing this, sorry :|

---

**slimfishy** - 2025-03-30 18:49

ohh i fixed it

---

**slimfishy** - 2025-03-30 18:49

It was shader override

---

**slimfishy** - 2025-03-30 18:50

I need to rewrite the shader and it should be fine

---

**srwg** - 2025-03-30 19:54

hello! I just discovered the plugin via the /r/godot post, and I'm attempting to try out the demo

---

**srwg** - 2025-03-30 19:55

I am trying to fiddle with the texture settings to get the crunchy lofi look I crave, but I'm unable to figure out how to mess with these settings

---

**srwg** - 2025-03-30 19:55

*(no text content)*

📎 Attachment: image.png

---

**srwg** - 2025-03-30 19:55

they're just locked, so I'm assuming they're set to read only somewhere, but idk how to make my own copies

---

**srwg** - 2025-03-30 19:56

in the tutorial it looks like they're just freely editable

---

**srwg** - 2025-03-30 19:57

and then as I type this out I find it, woops

---

**srwg** - 2025-03-30 19:59

for the dummies like me out there you've got to click the texture down in the terrain 3d window at the bottom

---

**tokisangames** - 2025-03-30 20:26

Upgrade instructions are in the docs.

---

**tokisangames** - 2025-03-30 20:27

There shouldn't be a "terrain3d.res" in 0.9.3. You probably upgraded from an older version like 0.9.2. In that case, you need to upgrade to 0.9.3a first. Read the 0.9.3 upgrade instructions in the docs.

---

**slimfishy** - 2025-03-30 20:28

I got it working already, shader was at fault

---

**slimfishy** - 2025-03-30 20:28

Thanks!

---

**tokisangames** - 2025-03-30 20:28

Don't mess with the asset list there. Use the AssetDock. See the UI in the docs to learn how to use it.

---

**wungielpolacz** - 2025-03-30 20:56

Hey everyone, I've just started using the terrain literally 15 minutes ago for the first time. And already the problem. Here's the problem:

📎 Attachment: Screenshot_513.png

---

**wungielpolacz** - 2025-03-30 20:56

Once I create new texture, everything goes black.

---

**wungielpolacz** - 2025-03-30 20:57

Also loading texture files doesn't change it.

---

**wungielpolacz** - 2025-03-30 20:57

It's just still black.

---

**wungielpolacz** - 2025-03-30 20:57

Why is that?

---

**tokisangames** - 2025-03-30 20:58

4.5 is definitely not supported. Use 4.4 and run our demo. Also read the docs and watch the tutorial videos.

---

**wungielpolacz** - 2025-03-30 20:59

Ahh, unfortunately I need 4.5 because I want to create kinda complex scene and then changing it again to Godot 4.5 from 4.4 will 100% break it.

---

**wungielpolacz** - 2025-03-30 21:00

I need to make to work HTerrain or MTerrain then.

---

**wungielpolacz** - 2025-03-30 21:00

For example this I made with HTerrain

📎 Attachment: Game1.webp

---

**wungielpolacz** - 2025-03-30 21:00

But in Godot 4.4

---

**tokisangames** - 2025-03-30 21:01

Looks nice. 4.5 was just released so I'd be surprised if they broke it already. However because it's a moving target if they break it, and they will, I can't support it.

---

**tokisangames** - 2025-03-30 21:02

As the docs say, black textures usually occur when you have textures that aren't the same format or size. However it's never happened when there's only one texture set. Hence, 4.5 might already be broken.

---

**tokisangames** - 2025-03-30 21:03

Does our demo work?

---

**wungielpolacz** - 2025-03-30 21:03

Yeah, makes totally sense. I'm also aware I'm dumb for starting with Godot 4.5 instead of 4.4. But as I said, I will have a ton of files and textures because I plan to recreate ARK Survival Ascended scene. So I'm sure then moving it to 4.5 will break at least textures.

---

**wungielpolacz** - 2025-03-30 21:03

Idk I didn't download that

---

**tokisangames** - 2025-03-30 21:04

Why not? It was all part of the same package. You would have had to remove it to not have it.

---

**wungielpolacz** - 2025-03-30 21:04

No, I could just unselect the "demo" folder while installation. So I did because I didn't want those files.

---

**tokisangames** - 2025-03-30 21:04

Why are you so sure? Textures aren't specific to 4.5

---

**tokisangames** - 2025-03-30 21:05

You want those files.

---

**wungielpolacz** - 2025-03-30 21:05

I did that with project I showed you. I moved it from 4.3 to 4.4 and every texture was unset.

---

**wungielpolacz** - 2025-03-30 21:05

Why is it needed?

---

**tokisangames** - 2025-03-30 21:06

Because your setup isn't working. The demo is setup properly. If it's not working you need to test if the problem is in your setup or somewhere else.

---

**tokisangames** - 2025-03-30 21:06

Basic troubleshooting. Divide and conquer.

---

**wungielpolacz** - 2025-03-30 21:06

Ahh, I thought you meant that demo is needed for plugin to work.

---

**wungielpolacz** - 2025-03-30 21:06

Okay, lemme reinstall with the demo to check if works or not

---

**wungielpolacz** - 2025-03-30 21:15

*(no text content)*

📎 Attachment: image.png

---

**wungielpolacz** - 2025-03-30 21:15

Had some problems of crashing Godot but here we are

---

**niquedegraaff** - 2025-03-30 22:08

Am I correct that I cannot build Terrain3D `v1.0.0-stable` double precision with Godot 4.4.1 Double precision? I attempted it several times but failed 🙂
godot engine was compiled with 4.4.1-stable tag
the json config was created using that compiled godot exe and used to build Terrain3D:
godot-cpp == checked out to tag godot-4.4.1-stable

then i did `scons precision=double custom_api_file=extension_api.json; scons precision=double custom_api_file=extension_api.json target=template_release` as stated in the docs

📎 Attachment: image.png

---

**tokisangames** - 2025-03-30 23:04

Great, so there's a working setup and a nonworking setup. I'm the non working setup, try adding the same albedo and normal textures and see if it turns from black to the texture. If so, everything's fine you just need to use properly setup textures.

---

**tokisangames** - 2025-03-30 23:08

There might be a type mismatch that is easily correctable. It gave you the affected lines.

---

**niquedegraaff** - 2025-03-30 23:09

I'm trying to find out how i can edit those files with conditional casting correct type based on the command that is run (precision=double)

---

**tokisangames** - 2025-03-30 23:11

359, 410 wrap the second parameter of fmod with real_t( ).
485, change src_ctrl to float.

---

**niquedegraaff** - 2025-03-30 23:13

So like: 359: `angle = real_t(Math::fmod(Math::rad_to_deg(angle) + 450.f, real_t(360.f)));`

---

**niquedegraaff** - 2025-03-30 23:17

What i meant with my previous message was that i do not want to disrupt normal scons builds (without the precision=double param) 🙂

---

**tokisangames** - 2025-03-30 23:21

Pull the latest commit

---

**niquedegraaff** - 2025-03-30 23:22

oh dang thanks man. I was ready to commit my self 🙂 You are blazingly fast

---

**cirebrand** - 2025-03-31 01:46

Any idea why turning this on in editor freezes my godot and takes awhile to load?

I ask because if the same collisions are generated during runtime it takes like 1.5 seconds.

📎 Attachment: image.png

---

**cirebrand** - 2025-03-31 01:47

I assume it has something todo with editor/game mode? But it seems like such a drastic performance difference

---

**tokisangames** - 2025-03-31 02:11

You didn't share the difference. That generates collision for the entire terrain, and displays it with gizmos. Lots of terrain, GBs of memory consumed. Turn off gizmos and watch your ram consumption. Or don't use that mode.

---

**cirebrand** - 2025-03-31 02:12

I would like to use that mode to use the new shift+g feature of asset placing

---

**cirebrand** - 2025-03-31 02:12

it snaps to collisions

---

**cirebrand** - 2025-03-31 02:13

I can record a video. I understand game mode doesnt use gizmos, which I do turn off in editor for performance

---

**cirebrand** - 2025-03-31 02:13

but my godot nearly crashes when using the full/editor which I found odd since the loading of collisions during runtime is negligable

---

**cirebrand** - 2025-03-31 02:15

I can record a video if you like but essentially if I turn it on my godot freezes and it takes a couple mins for the editor collisions to load.

---

**cirebrand** - 2025-03-31 02:24

Example
- have full / game mode enabled
- the world is not loaded at this point. I load the terrain3D during that loading screen

📎 Attachment: 2025-03-30_21-22-28.mp4

---

**amceface** - 2025-03-31 02:48

Hello! I have a question related to dynamic collisions. Whats the best approach for NPC that will travel the terrain? Should I disable dynamic collisions? Is there another alternative to not make the agents fall through the terrain?

---

**tokisangames** - 2025-03-31 03:04

How many regions and how many nodes in the scene, and all child scenes, currently in the tree? It's likely a resource problem. Test with an empty scene and only Terrain3D loading the data. 
Editor mode creates collision nodes, while game mode creates node less shapes in the physics server, in game only. 
Why are you using full anyway? Are you placing assets far away from the camera? Just use dynamic and place within the generated area. You have up to 256m.

---

**tokisangames** - 2025-03-31 03:04

Read the bottom of the collision documentation page

---

**cirebrand** - 2025-03-31 03:10

Just tried dynamic again and it works with the Grid Snap feature.
Not sure what I did differently but thanks for the help.

I'll look into the Full again if needed

---

**enroy** - 2025-03-31 03:47

Hey, I'd been working on my own terrain system the past month and I stumbled into this project, interested in swapping to this as it's far further in dev. I've read I can import r16 height maps (since my data comes from real world), however, my textures are 1024x1024px where only the top-left 1k x 1k contain raw values. I'm currently not interpolating them to 1024^2. Is this `pixelspace`/`linespace` supported, should I simply use 1kx1k textures or should I upscale them before importing?

---

**infinite_log** - 2025-03-31 07:02

Hey, is auto shader supposed to be on by default. I downloaded the addon from the asset lib and when I tried to add textures, it turned black but the demo worked fine, so I checked and found, that auto shader was on by default

---

**tokisangames** - 2025-03-31 07:02

If you have a texture like a satellite photo, you can import it on the colormap. Our texturing system is designed to be paintable, so you need separate rock, grass, dirt textures. You can use the API to convert a splatmap from another system to ours.

---

**tokisangames** - 2025-03-31 07:04

Yes I defaulted it to on, but now I see that's an issue. I suppose I need to turn it back off.
<@749643265749418082> ☝🏻

---

**infinite_log** - 2025-03-31 07:04

*(no text content)*

📎 Attachment: rn_image_picker_lib_temp_caaf48fd-8c2f-49a1-b98e-a3fbc441b797.jpg

---

**tokisangames** - 2025-03-31 07:06

As soon as you add a second, it turns to autoshader checkers?

---

**infinite_log** - 2025-03-31 07:07

No it was on before adding any texture.

---

**tokisangames** - 2025-03-31 07:08

And now, leaving it on, when you add one texture it turns black, and adding a second it turns to autoshader checkers?

---

**infinite_log** - 2025-03-31 07:09

Yes

---

**xtarsia** - 2025-03-31 07:16

Are the auto base/over defaults 1 & 2 as well?

---

**wungielpolacz** - 2025-03-31 07:24

*(no text content)*

📎 Attachment: image.png

---

**wungielpolacz** - 2025-03-31 07:24

I should disable that one option?

---

**tokisangames** - 2025-03-31 07:25

Add more than one texture, or disable it. It's only cosmetic

---

**tokisangames** - 2025-03-31 07:26

Defaults to 0, 1. The autoshader is working, but it shades between checker on slopes and black on flats. On a new terrain, it's all flat so black.

---

**wungielpolacz** - 2025-03-31 07:32

So to make textures working I need to first reimport them as VRAM Compressed, dont generate normal maps and to generate mipmaps?

---

**wungielpolacz** - 2025-03-31 07:32

Also does it support 8K textures?

---

**tokisangames** - 2025-03-31 07:33

Follow the guide in the docs for specs and instructions. Use our channel packer. Godot supports textures as large as your hardware does, 16k or theoretically 32k but I haven't seen that tried by anyone.

---

**wungielpolacz** - 2025-03-31 07:38

So just for desktop it's best to use DDS instead of PNG for best quality?

---

**wungielpolacz** - 2025-03-31 07:38

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-03-31 07:38

Godot converts PNG converts to DDS.

---

**wungielpolacz** - 2025-03-31 07:39

Ahh, it's good. Then I will stick to PNG then because I don't want now to reimport everything

---

**tokisangames** - 2025-03-31 07:39

If you make textures manually in gimp, use their DDS as their algorithm is better than Godot's.
If using our texture packer use PNG and if you want higher quality mark High quality as shown.

---

**wungielpolacz** - 2025-03-31 07:58

Idk now.

📎 Attachment: image.png

---

**wungielpolacz** - 2025-03-31 07:58

Literally should be okay.

---

**wungielpolacz** - 2025-03-31 07:59

Here is also CompressedTexture2D but he doesn't have Mipmaps

📎 Attachment: image.png

---

**wungielpolacz** - 2025-03-31 08:00

Maybe BPTC_RGBA makes problems

---

**tokisangames** - 2025-03-31 08:12

Fix your textures and import settings until the info display in the inspector for your textures matches. Everything about those two textures is different. Size, format, and mipmaps.

---

**tokisangames** - 2025-03-31 08:12

The Demo textures are properly setup and use BPTC

---

**the_cloak** - 2025-03-31 10:13

Hey, Im completley lost. Just trying to deform the land, and I have zero idea how. Went into the demo scene and couldnt make anything change shape so gave up and came asking for answers.

---

**xtarsia** - 2025-03-31 10:35

Is the addon enabled in project settings?

---

**the_cloak** - 2025-03-31 10:40

Ys

---

**the_cloak** - 2025-03-31 10:40

Yes

---

**itsmikeyy** - 2025-03-31 11:52

Is it just me or does the new textures within the demo look very glossy compared to in v0.9.3a? not sure if i did something wrong or if that's how it's meant to look like now? 🤔

📎 Attachment: image.png

---

**itsmikeyy** - 2025-03-31 11:53

I'm not sure if this is just my weird preference, but the one on the right seems to look a lot more natural

---

**tokisangames** - 2025-03-31 13:05

Did you watch the tutorial videos and read the UI documentation? What version of Terrain3D and Godot, and renderer? When you select Terrain3D in the demo, and any of the sculpting tools, do you get a cursor on the ground? What happens when you click?

---

**tokisangames** - 2025-03-31 13:06

They're different textures. You can adjust roughness in the texture asset.

---

**moooshroom0** - 2025-03-31 14:03

Out of curiosity how does metallic work with textures in terrain 3d?

---

**xtarsia** - 2025-03-31 14:13

It doesn't unless you add an extra texture

---

**xtarsia** - 2025-03-31 14:14

Same process as adding emmision in the docs

---

**waterfill** - 2025-03-31 16:04

Hello, I'm sorry if I'm asking a silly question, but I have a question about how more realistic or exaggerated games manage to keep so much vegetation on the map and still not have a drop in performance? I know there are lod and simple textured plans for this, but when I used the plugin and tested using a lot of grass like in games, the fps dropped a lot, even using lod resources. Could the shader I put on the moving grass be the problem? Or is it normal for fps to drop?

---

**xtarsia** - 2025-03-31 16:22

Tune LOD and cull distances based on looking from the actual player perspective.

The flying about in the editor is very misleading.

---

**tokisangames** - 2025-03-31 16:31

Vertex wind is nominal. You need to get instances off the screen. Use distance and occlusion culling. Use a shadow impostor.
Optimize your meshes and materials. Reduce vertex count. Disable autolods on import. Use alpha scissor instead of alpha.

---

**wungielpolacz** - 2025-03-31 18:56

Only disabling auto shader helped

📎 Attachment: image.png

---

**wungielpolacz** - 2025-03-31 18:56

Also what are best settings for Delting Rotation and UV Scale?

---

**wungielpolacz** - 2025-03-31 18:56

Or there is no universal and everything depends on my texture?

---

**waterfill** - 2025-03-31 19:17

thanks! that's what i'm doing

---

**waterfill** - 2025-03-31 19:18

thanks!!

---

**jlsteward01** - 2025-03-31 21:42

Hi, hope this isn't a stupid question, but how do you erase holes painted in the terrain? With the hole brush selected, holding shift turns the projection red, but the brush acts like the smooth brush. I'm on Mac.

---

**image_not_found** - 2025-03-31 21:45

https://terrain3d.readthedocs.io/en/stable/docs/user_interface.html#keyboard-shortcuts

---

**jlsteward01** - 2025-03-31 21:47

I've tried that, but it doesn't invert any of the tools

---

**tokisangames** - 2025-03-31 22:16

Cmd is inverse on Mac as that document says. It does not say use shift. Read it again.

---

**jlsteward01** - 2025-03-31 22:19

I've tried both, and CMD doesn't invert any of the tools.

---

**jlsteward01** - 2025-03-31 22:19

is there a way to edit the keybinds?

---

**tranquilmarmot** - 2025-03-31 22:39

I had this issue as well - try restarting the editor

---

**klautless** - 2025-04-01 00:24

hey quick question for y'all! before i rabbit hole on this - is making a second autoshader feasible? have others tried?

---

**tokisangames** - 2025-04-01 00:33

You tried ctrl and cmd? And neither toggle the decal? What OS version and hardware do you have? Terrain3D and Godot version? Did you change any keyboard settings in Godot? We've had plenty of Mac users work fine with the plugin. 
You can edit the code in editor_plugin.gd. See PR 568.

---

**tokisangames** - 2025-04-01 00:34

You don't want to run more than one shader. Customize the single shader to do what you want.

---

**klautless** - 2025-04-01 00:35

sorry - poor phrasing on my part. more a confirmation that it should be possible within the one shader to make two functional auto-areas

---

**klautless** - 2025-04-01 00:36

just to explain use-case, i like keeping auto with a cliff face + sand as the overlay texture, so sand runs out to the water with the background on flat. but i don't want to use that for all the main areas per se

---

**tokisangames** - 2025-04-01 00:39

Extending the autoshader to use multiple textures won't be difficult once you determine how you want to separate them, and will delineate the areas in world space. The current does so simply by slope.

---

**klautless** - 2025-04-01 00:40

good point, i'll give it a look later and see about working the height into a fade. thank you!

---

**mainman002** - 2025-04-01 04:10

Another mac user here, you have to start drawing and then hold down control & move your cursor. It's a little weird but seems to work

---

**_askeladden__** - 2025-04-01 05:16

for godot 4.4, I have to use the Terrain3D plugin from the asset store, right? As opposed to the GD 4.3 version?

---

**srwg** - 2025-04-01 06:32

trying to resize textures to see how the tool fares with lower fi aesthetic

---

**srwg** - 2025-04-01 06:32

using the built in texture packer

---

**srwg** - 2025-04-01 06:33

despite using the exact same files and importing (then reimporting) the exact same way, I'm getting bright white textures any time I try to make the texture smaller

---

**srwg** - 2025-04-01 06:36

*(no text content)*

📎 Attachment: image.png

---

**srwg** - 2025-04-01 06:45

aaand just like last time I figured it out right after whining. didn't realize textures needed to all be the same size. converted the others to 128 and now it's workin

---

**wungielpolacz** - 2025-04-01 07:07

Is there option to not have infinite terrain and just 1 solid mesh?

---

**_askeladden__** - 2025-04-01 08:07

any one here has experience with importing heighmaps? I am importing a 16 bit heightmap generated using this https://manticorp.github.io/unrealheightmap/ and its still giving me a lot of terracing. Do i need to find 32 bit heightmaps (if so where) or is there a way to get rid of these terraces?

📎 Attachment: image.png

---

**xtarsia** - 2025-04-01 08:44

If you used png godot inly supports 8bit png. Exr or raw will work with 16bit

---

**tokisangames** - 2025-04-01 09:41

There are two entries in the asset store for 4.4 and 4.3. Each say which version they are for.

---

**tokisangames** - 2025-04-01 09:43

Use blender if you want one solid mesh terrain.
As for infinite terrain, it is already visually infinite. Collision on generated terrain isn't possible until there's a GPU workflow. In the meantime you have up to 65,535m on a side which is 30-37x the size of witcher3 and GTA5.

---

**_askeladden__** - 2025-04-01 10:03

So the tool i mentioned outputs 16 bit png. I opened it in krita and saved that as exr and then used that to generate terrain. Not sure if one of those steps compressed it to 8 bit or something.

---

**tokisangames** - 2025-04-01 10:06

Based on results, the data was converted to 8-bit along the way.
You can put 8-bit data in 16-bit mode in an image editor and blur it.

---

**slimfishy** - 2025-04-01 10:07

<@694581469565419661> im using alpha scissor for grass planes

---

**image_not_found** - 2025-04-01 10:08

Yep, that's another name for alpha clip, so that's not a problem

---

**slimfishy** - 2025-04-01 10:08

And my pc is decent with 3080

---

**slimfishy** - 2025-04-01 10:09

Hmm i will have to inspect it in profiler

---

**slimfishy** - 2025-04-01 10:09

And also check if that happend in 0.9.3 as i dont remember my pc wanting to fly away

---

**slimfishy** - 2025-04-01 10:10

Most Grass meshes im using are 3-4 planes

---

**image_not_found** - 2025-04-01 10:11

What's the framerate though?

---

**image_not_found** - 2025-04-01 10:12

You can check in the editor by enabling frame time from the viewport settings

---

**slimfishy** - 2025-04-01 10:15

Framerate is stable 60, i have vsync enabled

---

**slimfishy** - 2025-04-01 10:15

I will check it

---

**m4rr5** - 2025-04-01 12:02

I would be careful only measuring framerate and time in the editor. Ideally do it with your game running.

---

**_askeladden__** - 2025-04-01 15:03

Yup that was the issue, I converted it directly into r16 via the terminal and now it works perfectly, thanks.

---

**_askeladden__** - 2025-04-01 15:19

Although, even 16 bit isn't ideal, is it? The terracing is much less but Its still there. Or maybe its something different as the terrain does appear to be perfectly smooth but still getting these lighting effect (like the 3rd image).

📎 Attachment: image.png

---

**tokisangames** - 2025-04-01 15:21

16-bit is fine. Your data is not using the full range of the float. Blur it, or smooth it in the editor

---

**_askeladden__** - 2025-04-01 15:38

kk thanks

---

**leonrusskiy** - 2025-04-01 17:00

Hi, I wanna know how to edit my terrain by adding a shader to it.

📎 Attachment: image.png

---

**wungielpolacz** - 2025-04-01 17:18

So I can't just make 1 solid mesh instead of infinite terrain. So let's say I will import mesh from Blender. And can I paint textures or mesh on that using your plugin?

---

**tokisangames** - 2025-04-01 17:19

There already is a shader on the terrain. You can edit it by enabling the shader override in the material.

---

**leonrusskiy** - 2025-04-01 17:24

No shader works with the terrain, unfortunately. Thanks anyways.

---

**tokisangames** - 2025-04-01 17:24

This is a clipmap terrain system that generates many meshes that are contantly moving around, placed and reformed potentially every frame by your GPU. Like reality, it only appears solid but is not. See system architecture in the docs. All of our texturing and instancing tools are designed to work with our terrain system.

---

**tokisangames** - 2025-04-01 17:24

If you want a terrain that is a singular solid mesh, sculpt it and texture it in blender. It won't have LODs, will require a lot of VRAM to get a detailed texture, and will be far from optimal. And you cannot make a solid infinite mesh this way. The two concepts are incompatible.

---

**tokisangames** - 2025-04-01 17:24

What do you mean? Our terrain is run by the shader, and we provide you with that shader for you to modify.

---

**leonrusskiy** - 2025-04-01 17:25

Ok, I'll try to modify the existing shader.

---

**tokisangames** - 2025-04-01 17:25

You cannot erase all of our shader code and replace it with any random shader. The terrain requires half of the code in our shader. The minimum shader in extras provides what is necessary.

---

**wungielpolacz** - 2025-04-01 17:26

Tbh I didn't want infinite solid mesh terrain. Just terrain that is kinda 1 piece which doesn't move and stays in the place so I can freely edit it. But as I see I can't find it here.

---

**tokisangames** - 2025-04-01 17:26

I think you are missing some concepts. Maybe you should describe the outcome you wish to achieve, not what you think the best technical solution is.

---

**wungielpolacz** - 2025-04-01 17:27

Hmm, I will explain it easiest way possible

---

**wungielpolacz** - 2025-04-01 17:27

1 sec

---

**tokisangames** - 2025-04-01 17:28

> kinda 1 piece which doesn't move and stays in the place so I can freely edit it.
From the user perspective, this is exactly what is provided. What I described is how it works under the hood, but unless you are contributing should not matter to you.

---

**wungielpolacz** - 2025-04-01 17:29

Something like this. Small piece of terrain. Or larger if I change the size. That is not procedurally generated and doesn't move around with camera. Kinda static terrain object I can edit however I want. That I choose the size and it's not infinite.

📎 Attachment: image.png

---

**tokisangames** - 2025-04-01 17:29

Change material/worldbackground to none

---

**wungielpolacz** - 2025-04-01 17:30

So now it limits itself to where I've painted the zones?

---

**tokisangames** - 2025-04-01 17:30

> doesn't move around with camera
Do you observe the terrain moving around with the camera?

---

**tokisangames** - 2025-04-01 17:31

Yes, that's what you wanted right?

---

**tokisangames** - 2025-04-01 17:31

Regions

---

**tokisangames** - 2025-04-01 17:31

> can edit however I want
Were you ever not able to edit the terrain?

---

**wungielpolacz** - 2025-04-01 17:31

Actually not because I've painted texture before and it didn't move. Just terrain was weirdly generated.

---

**wungielpolacz** - 2025-04-01 17:32

Yeah, so I was asking if your plugin has that. Well, now I know. Thanks.

---

**tokisangames** - 2025-04-01 17:32

Did you read the documentation? Specifically the Introduction. I think it covers these core concepts.

---

**wungielpolacz** - 2025-04-01 17:33

I was always able, but just wanted to clarify what I expect from the plugin because you asked: "Maybe you should describe the outcome you wish to achieve."

So I explained you with details what I exactly wanted.

---

**tokisangames** - 2025-04-01 17:33

Yes, that was much better to address what you wanted to achieve.

---

**wungielpolacz** - 2025-04-01 17:33

I went only through most important for me parts.

---

**tokisangames** - 2025-04-01 17:33

The Introduction is an important part

---

**wungielpolacz** - 2025-04-01 17:34

I just wrongly assumed that plugin doesn't have what I want so prefered to ask main dev himself. My bad I didn't read the docs.

---

**tokisangames** - 2025-04-01 17:34

As the docs describe, you cannot edit the textures or sculpt in the areas outside of your defined regions.

---

**tokisangames** - 2025-04-01 17:35

Regions store your data. You can also choose what exists between your regions.

---

**wungielpolacz** - 2025-04-01 17:36

Yeah, those ones I figured myself when checking out the demo.

---

**wungielpolacz** - 2025-04-01 17:36

Demo is very useful actually.

---

**wungielpolacz** - 2025-04-01 17:36

I didn't know why I can't do anything. So checked the demo and saw that regions are painted.

---

**wungielpolacz** - 2025-04-01 17:36

So it helped.

---

**wungielpolacz** - 2025-04-01 17:37

From my first impressions I like the plugin but it feels really slow.

---

**wungielpolacz** - 2025-04-01 17:37

Painting the textures and sculpting the terrain.

---

**wungielpolacz** - 2025-04-01 17:38

For comparison HTerrain that I used in that project for example is way faster.

📎 Attachment: Game1.webp

---

**tokisangames** - 2025-04-01 17:38

Running the terrain, it is one of the fastest.
Editing uses the CPU, not the GPU. You cannot edit large sections quickly until we implement a GPU workflow. Editing small sections is fast.

---

**wungielpolacz** - 2025-04-01 17:39

Okay, understandable.

---

**wungielpolacz** - 2025-04-01 17:40

Thanks for support. I will consider contributing to the project.

---

**haporal** - 2025-04-01 19:30

hello, i'm trying to update godot from 4.3 to 4.4.1 and figured i had to update Terrain3D as well. so i installed 0.9.3a, and tried to follow the "Upgrading Terrain3D guide, but my level's terrain "disappeared" and it looks like i can't upgrade my storage file from the Data Directory Setup, i can select my terrain.res but once i click "ok" nothing happens

---

**haporal** - 2025-04-01 19:31

and it does that for both of my levels terrains

---

**tokisangames** - 2025-04-01 19:48

What version did you start with?

---

**haporal** - 2025-04-01 19:49

An old one, the last before updating to 0.9.3/4.4.2 was 0.9.2

---

**haporal** - 2025-04-01 19:49

My terrain worked fine there

---

**haporal** - 2025-04-01 19:49

And now on 0.9.3 i don't see it anymore

---

**tokisangames** - 2025-04-01 19:49

After installing 0.9.3a, opening your scene, and clicking Terrain3D, Did the directory setup wizard open automatically?

---

**tokisangames** - 2025-04-01 19:51

If not, what if you manually open the Terrain3D menu, directory setup wizard and use it to upgrade your storage file?

---

**haporal** - 2025-04-01 19:51

yes

---

**haporal** - 2025-04-01 19:51

i can't upgrade my storage file from the Data Directory Setup, i can select my terrain.res but once i click "ok" nothing happens

---

**tokisangames** - 2025-04-01 19:52

OK. And the old file was already filled in?

---

**haporal** - 2025-04-01 19:52

yes it was

---

**tokisangames** - 2025-04-01 19:52

And you specified a new, empty directory for your data?

---

**tokisangames** - 2025-04-01 19:52

What does your console say after starting the process?

---

**haporal** - 2025-04-01 19:52

i specified a non-empty one, the one with the old terrain files in

---

**tokisangames** - 2025-04-01 19:53

Don't do that

---

**haporal** - 2025-04-01 19:57

okay looks like it works if i set it to a new empty folder, thanks

---

**_askeladden__** - 2025-04-02 08:21

`ERROR: core/variant/variant_utility.cpp:1098 - Terrain3DData#9250:import_images: (8193, 8193) image will not fit at (-4096.0, 0.0, -4096.0). Try (-4096, -4096) to center`

Getting this error while trying to import a heightmap even though I have set the required position in the inspector. Is it possible 8193 is more than the max allowed resolution and I have to try 8192?

📎 Attachment: image.png

---

**tokisangames** - 2025-04-02 08:26

Max allowed worldspace is +/- (32/2)*region_size. Change your region_size.

---

**_askeladden__** - 2025-04-02 08:27

Yes, changed from 256 to 512 and that fixed it. Thanks!

---

**lutcikaur** - 2025-04-02 08:48

So i just upgraded from 9.3a-beta to 1.0.0... and the terrain material shader seems _weird_.... in the editor its all OK but when i run it & load the scene, it has the checkered debug view set. if i then unset it, its grayscale with a massive shadow around the camera. Both with default & override. (also it wont let me get or set params that start with an underscore, despite what the comments in the default shader say). I hunted through the commit logs and saw a bunch of changes to the shader itself, but nothing I think that would explain what i am seeing.

---

**tokisangames** - 2025-04-02 08:59

You're doing unusual things with your terrain loading probably. Uncheck rendering/free_editor_textures as mentioned in the release notes.

---

**lutcikaur** - 2025-04-02 09:49

Seems to have no effect. I'm doing what boils down to `AddChild(GD.Load<PackedScene>(newTerrain3DScenePath).Instantiate());` and then `QueueFree();` on the old Terrain3D.

---

**tokisangames** - 2025-04-02 10:25

Print the size of Terrain3D.assets. It's probably zero, because that option is turned on. Turn it off before attaching Terrain3D to the tree, as it's cleared in _ready.

---

**_askeladden__** - 2025-04-02 11:19

Anyway to import a 16k heightmap without getting the `ERROR: Condition "p_size < 0" is true. Returning: ERR_INVALID_PARAMETER at: resize (./core/templates/cowdata.h:343)`?

---

**tokisangames** - 2025-04-02 11:51

We've supported importing 16k since the first release. Something else is wrong. What are your exact file type, format, and dimensions?

---

**_askeladden__** - 2025-04-02 11:54

The file is 32 bit exr (700mb), dimensions are 16384x16384

---

**_askeladden__** - 2025-04-02 11:54

full error is this

---

**_askeladden__** - 2025-04-02 11:54

*(no text content)*

📎 Attachment: message.txt

---

**tokisangames** - 2025-04-02 11:54

What format is your data? Exrs can store different types

---

**tokisangames** - 2025-04-02 11:57

The crash is in Godot code. That's not a Terrain3D error. You should run a debug build of Terrain3D and Godot though a debugger so you can get to the exact line.

---

**tokisangames** - 2025-04-02 11:58

Most likely it's your data format. Should be float. Probably int.

---

**_askeladden__** - 2025-04-02 11:59

not sure how to find if its float or int, i'm exporting the file directly from world machine

---

**_askeladden__** - 2025-04-02 11:59

*(no text content)*

📎 Attachment: image.png

---

**_askeladden__** - 2025-04-02 11:59

i guess this sayys its float

---

**_askeladden__** - 2025-04-02 11:59

opened in gimp

---

**tokisangames** - 2025-04-02 12:04

Can Godot open the file in the inspector?

---

**tokisangames** - 2025-04-02 12:05

Godot gives us the data, but only if it can read it.

---

**_askeladden__** - 2025-04-02 12:07

no, importing the file in Godot (putting it in the project folder) crashes the editor, so i guess its probably a godot specific issue?
8k exr of the same format does work fine

---

**tokisangames** - 2025-04-02 12:09

It is indeed a godot issue. Once you have resolved that, we should be able to import it just fine. 16k normally is just fine, but Godot doesn't support something in this format. greyscale float should be fine. Check for nans, infs, or alpha and get rid of them. Gimp can do so with some clamping filters.

---

**_askeladden__** - 2025-04-02 17:05

I am trying to use the generated heightmap in another shader (so i can instance grass on top of it), although I am a complete newbie in shaders. The docs say this 
https://terrain3d.readthedocs.io/en/stable/docs/tips.html#using-the-generated-height-map-in-other-shaders

Here, do i get just one heightmap (for the entire terrain) or an array of heightmaps (one for each region)?

---

**xtarsia** - 2025-04-02 17:07

https://github.com/TokisanGames/Terrain3D/pull/665/files

You can see how thats done here.

In fact this whole thing is an example of exactly what you're wanting to do.

So if you want to test it, and make any suggestions feel free 🙂

---

**_askeladden__** - 2025-04-02 17:09

oooh, interesting, imma check it out, thanks for sharing!

---

**_askeladden__** - 2025-04-02 19:08

It works really well!

I've been going through the particle shader code (for learning purposes), and I am wondering why do we need to take the weighted average of 4 texels here (lines 129-154)?

```
h[0] = texelFetch(_height_maps, index[0], 0).r; // 0 (0,1)
h[1] = texelFetch(_height_maps, index[1], 0).r; // 1 (1,1)
h[2] = texelFetch(_height_maps, index[2], 0).r; // 2 (1,0)
h[3] = texelFetch(_height_maps, index[3], 0).r; // 3 (0,0)

pos.y =
  h[0] * weights[0] +
  h[1] * weights[1] +
  h[2] * weights[2] +
  h[3] * weights[3] ;
```

---

**xtarsia** - 2025-04-02 19:12

Old way would be to just use texture() and let the gpu handle interpolation, but the gpu can't know the correct layer index at region edges. So we do it manually instead.

---

**lutcikaur** - 2025-04-02 22:03

🤦 i had to go into every terrain scene i had and turn them all off. I had turned it off on the one i was transitioning to, but not from.

---

**biome** - 2025-04-02 22:23

having the collision mode to `Dynamic / Game` doesn't actually move the collisions around with the camera, it seems to always be centered around the first current camera in the scene (which might not actually be the one you're looking out of)

---

**tokisangames** - 2025-04-02 22:56

Both dynamic modes center collision around the camera that your viewport detects if it can, or the camera you specify with set_camera()

---

**biome** - 2025-04-02 23:49

I believe part of this to be broken. Here's the scenario I have: I have a camera in the world that isn't set to current (the only one in the scene at game start) and when I spawn my player later I add another camera and set that to current. There's no camera set to current, so Godot chooses the only original camera in the world. Once I spawn my player, I use `set_current(true)` on the player's camera, but the collisions are still centered around that original camera. I can verify this by moving the original camera further away and once I get far enough, eventually I have no collision at all when my player spawns.

---

**_askeladden__** - 2025-04-03 03:43

One strange thing I have noticed when I use it on a terrain with high elevation (doesn't occur when we are at 0 elevation). The objects dissappear at shallow angles. Weirdly, this also occurs in another grass instancing script so might be an issue with camera settings or something but I can't figure out.

📎 Attachment: test.mp4

---

**_askeladden__** - 2025-04-03 04:13

actually its happening on flat terrain too now

---

**_askeladden__** - 2025-04-03 04:16

*(no text content)*

📎 Attachment: 2025-04-03_09-15-10.mkv

---

**lutcikaur** - 2025-04-03 04:16

hmm, something changed in 1.0.0 with how navigation is drawn on the map now. it used to draw the whole squares instead of centered on the vertex

📎 Attachment: image.png

---

**_askeladden__** - 2025-04-03 04:35

actually, not happening anymore on low elevation, only on high elevation, so weird

📎 Attachment: sd-2400.mp4

---

**xtarsia** - 2025-04-03 05:30

the AABB was wrong, I was centering the Y axis over 0. instead of setting the position to the bottom. easy fixed!

---

**tokisangames** - 2025-04-03 05:48

You need to set the camera in the terrain manually after creating the new one

---

**tokisangames** - 2025-04-03 05:50

Now how it's drawn more closely resembles what is generated

---

**lutcikaur** - 2025-04-03 05:58

Damn, my game is tile based and the old drawing 1:1 matched where collisions actually were in my world. Is there a relatively easy way to go back to the old rendering?

---

**tokisangames** - 2025-04-03 06:00

I don't know why you'd have the navigation area drawn in game. But you can look at the changes to the debug view shader on github and draw the old version in a custom shader.

---

**lutcikaur** - 2025-04-03 06:03

i mainly use the 'paint navigable area' in the editor, and it helps when it matches to where my characters can move ingame :), although i do have an ingame debug setting for it.

---

**xtarsia** - 2025-04-03 06:04

with other changes, maybe that 0.5 offset in the debug view needs reverting? i'll check later cos i gotta go out now.

---

**tokisangames** - 2025-04-03 06:04

Now it more closely matches where they can move, and the generated nav mesh. It was off before.

---

**lutcikaur** - 2025-04-03 06:08

yea i fully understand it matches better for a navmesh which I expect basically everyone else to be using. I am not using the navmesh functionality -- I am pulling the controlmap images, stitching them together, and converting their nav pixels sorta into a bitmap for my collision detection. it was just helpful that the 'paint nav area' which you guys made super easy to use and visualize, i was reusing & exporting for my own nav area calcs

---

**tokisangames** - 2025-04-03 06:47

You'll be better served by a custom data painter, which is on the issues list. I'm the meantime, you can adjust the shader yourself to make your own

---

**lutcikaur** - 2025-04-03 06:50

yea i found what i need to change in editor_functions.glsl, looks like ill have to build from source to edit that 🙂

---

**tokisangames** - 2025-04-03 07:16

I'm not suggesting you do. Customize the shader and add that code toggleable by a uniform. Make it your own shader, using the nav bit until custom data is available.

---

**foyezes** - 2025-04-03 11:39

I can't get custom LODs working. I don't see any options for them

📎 Attachment: image.png

---

**foyezes** - 2025-04-03 11:40

*(no text content)*

📎 Attachment: image.png

---

**_askeladden__** - 2025-04-03 11:59

So i'm wondering what the best method would be to do the following

I am generating the terrain in world machine. World machine gives me the slope, height, roughness, erosion and wetness masks. I can use those masks to output a texture map from world machine to determine where to show each texture. What data format would be best for use with terrain3d? Do i need to get something in the control map format or a regular splatmap?

---

**tokisangames** - 2025-04-03 13:18

You're looking at 1.0 documentation while using 0.9.3. Look at older docs or upgrade.

---

**tokisangames** - 2025-04-03 13:21

You'll need to determine what texturing layout data you want from worldmachine and how to interpret it, likely using their documentation. Then write a script to translate that into our Terrain3DData API. Converting a set of splatmaps to our control base texture id could be written quickly. Utilizing blending or other parameters in their maps will take more work. We've long had an outstanding [Issue](https://github.com/TokisanGames/Terrain3D/issues/135) waiting for someone with these tools to contribute a conversion script. One person wrote one for their tool but never shared.

---

**foyezes** - 2025-04-03 13:55

I encountered the same issue again. The decal is stuck in place, unlike before, I can move around the scene while the terrain3D layer is selected.

📎 Attachment: image.png

---

**pege67** - 2025-04-03 14:50

Hello, I need help for an issue I got using terrain3d 1.0. I'm doing a turn by turn battle rpg, My main map is made with terrain3d and when I start a battle I queue_free the map scene because I can't pause it. When I finish the battle I call a new instance of my map scene and the height map is loaded fine but not the textures. Here is the code when I start and finish battle ```
func _on_event_start_battle(troop: Troop_Data, _background) -> void:
    GameProgression.party_progression["position"] = current_map.get_node("Actor").position
    bm = battle_manager.instantiate()
    bm.troop = troop
    var tween = get_tree().create_tween()
    tween.tween_property(fade_rect, "modulate:a8", 255, 1)
    await tween.finished
    current_map.queue_free()
    add_child(bm)
    tween = create_tween()
    tween.tween_property(fade_rect, "modulate:a8", 0, 1)

func _on_event_battle_end() -> void:
    var tween = get_tree().create_tween()
    tween.tween_property(fade_rect, "modulate:a8", 255, 0.6).set_ease(Tween.EASE_OUT)
    await tween.finished
    remove_child(bm)
    bm.queue_free()
    var map = scene_map.instantiate()
    current_map = map
    var player_scene = player.instantiate()
    player_scene.position = GameProgression.party_progression["position"]
    add_child(current_map)
    map.add_child(player_scene)
    tween = create_tween()
    tween.tween_property(fade_rect, "modulate:a8", 0, 1)
    GameProgression.is_on_map = true
    GameProgression.can_open_menu = true
    GameProgression.is_on_battle = false```
I think I'm doing something wrong but what?

📎 Attachment: Mirapolis_Debug_2025-04-03_16-47-36.mp4

---

**xtarsia** - 2025-04-03 14:53

in the inspector for the terrain3d node, under rendering, turn this off:

📎 Attachment: image.png

---

**pege67** - 2025-04-03 14:57

It worked, fast and easy. Thk!

---

**tokisangames** - 2025-04-03 16:48

What versions? Did it work then stop working, or never work? What was done right before? What does your console report? You can move the camera, but the decal is stuck? Do you see the mouse cursor in the viewport?

---

**foyezes** - 2025-04-03 16:53

I'm on 4.5 dev1 right now. It was working for a while, then I reloaded the project and it stopped working. The cursor is visible. I can move around but the decal is stuck in one place. I tried restarting the editor.

📎 Attachment: image.png

---

**tokisangames** - 2025-04-03 17:00

4.5 is definitely not supported until the rcs. Neither is FSR. Disable all temporal effects: FSR, TAA. Physics interpolation is supported now in 1.0. Test 4.4 w/o FSR. And what about Terrain3D version?

---

**foyezes** - 2025-04-03 17:01

ok. will try. terrain3d 1.0.0

---

**paperzlel** - 2025-04-03 20:04

How does the new dynamic collision work with cameras? I have two in my game scene (one for the title, one for the player) and it looks like the dynamically generated terrain isn't applying itself to the currently active camera (that being my player's once "play game" is selected).

---

**xtarsia** - 2025-04-03 20:14

call terrain.set_camera(player_camera) once the player camera is active

---

**xtarsia** - 2025-04-03 20:15

Tho it occurs to me that collision might want to have its own tracked object, and not the camera <@455610038350774273>

---

**xtarsia** - 2025-04-03 20:16

eg, if camera distance is zoomed out a bit, the collision should track the player character

---

**pege67** - 2025-04-03 20:56

Hello again,
I got some other issue using the addon. Sometimes (randomly) a colored square appear in the screen and become bigger when the camera is moving.
Using terrain3d 1.0, godot 4.4 stable, Vulkan 1.3.242 - Forward+ - Using Device #0: NVIDIA - NVIDIA GeForce RTX 2050

📎 Attachment: Mirapolis_DEBUG_2025-04-03_22-50-43.mp4

---

**tokisangames** - 2025-04-03 21:02

Does it appear on the sky? Did you customize the shader? What version of your video card driver? Does it appear only in game or editor? Can you reproduce it in our demo?

---

**pege67** - 2025-04-03 21:10

Sometimes it appear in the sky. I didn't customize the shader. The version of my video card driver is 31.0.15.3690.  It used to appear also in editor when I was using version 0.9.3a and godot 4.3 but since I updated to version 1.0 and godot 4.4 I didn't see it in editor.

---

**tokisangames** - 2025-04-03 21:10

If it shows in the sky where there is no terrain, it's unlikely the terrain.

---

**pege67** - 2025-04-03 21:10

I will try to reproduce it in your demo

---

**tokisangames** - 2025-04-03 21:12

That's not your driver version. The driver version is 3.2 digits

---

**tokisangames** - 2025-04-03 21:13

Godot prints it to your console every time it starts up.

---

**pege67** - 2025-04-03 21:16

OpenGL API 3.3.0 NVIDIA 536.90

---

**tokisangames** - 2025-04-03 21:16

That driver is from august 2023. Upgrading that should have been the first thing you tried.

---

**pege67** - 2025-04-03 21:17

ok I'll do that and tell you if it solve the problem

---

**pege67** - 2025-04-03 21:39

Updated my driver and the problem is still here

📎 Attachment: image.png

---

**xtarsia** - 2025-04-03 21:52

do you have any post process effects on?

---

**pege67** - 2025-04-03 21:53

I investigated bit more and found out it's comming from sky3d when i'm using volumetric fog, so I will post on the apropriate chanel

---

**kamazs** - 2025-04-04 06:10

FYI: after upgrading `0.9.3a` to `1.0.0` (Godot 4.4) white (or cut) lines like this popped up in editor and in game. They disappeared once I reset _Mesh_ settings (to defaults and then back to previous custom values).

📎 Attachment: image.png

---

**xtarsia** - 2025-04-04 06:28

hmm I bet mesh size was odd before?

---

**kamazs** - 2025-04-04 06:29

heh, I see, now I cannot even input odd numbers in the editor

---

**xtarsia** - 2025-04-04 06:31

its something I didnt catch propperaly, but if anyone asks with a similar issue, the solution is known now.

(it has to be even, because everything operates in 2x2 cells for the geomorph grid transitions)

---

**kamazs** - 2025-04-04 06:32

Yes, it was odd, just confirmed.

---

**tokisangames** - 2025-04-04 07:17

Enforcing that should be done in the C++ setters then, not just the GDScript.

---

**samwel_you** - 2025-04-04 14:47

so i have a terrain

---

**samwel_you** - 2025-04-04 14:47

*(no text content)*

📎 Attachment: Screenshot_2025-04-04_at_22.45.01.png

---

**samwel_you** - 2025-04-04 14:47

and i used the overlay spraying stuff on it but it still looks quite blocky

---

**samwel_you** - 2025-04-04 14:47

im not sure whats wrong

---

**tokisangames** - 2025-04-04 15:37

You must have height textures and follow the specific technique demonstrated in tutorial video #2 and written about on the texture painting document.
https://discord.com/channels/691957978680786944/1065519581013229578/1302538709362544660

---

**xtarsia** - 2025-04-04 15:46

I think there is room to make that better by interpolating the blend. But i've not come up with a good way to avoid the artifact caused by doing that yet.

---

**samwel_you** - 2025-04-04 15:59

I followed it but somehow it still didnt work

---

**tokisangames** - 2025-04-04 16:02

The process and directions work. It is likely you missed a step. Start again. Use the Paint tool to cover a whole area with grass. Use Paint to draw a wide path with dirt. Use Spray at 10% strength with grass, and lightly blend along the edges of the path.

---

**samwel_you** - 2025-04-04 16:02

Alright i will try that, thanks for the help

---

**mayumi9867** - 2025-04-04 16:21

Hello, I Hope I here on the Right Place. Im new in godot we using the Plugin in godot ist possiböe to make a Setting in the Plugin to docking the Assets as a House or other trinkst at the Terrain? In I will set a House or wall on the Terrain it will be Place Ober the Terrain map into the air

---

**jakobismus** - 2025-04-04 16:42

You need to enable in-editor collisions on your Terrain3D

---

**mayumi9867** - 2025-04-04 16:45

ollision is activated.

📎 Attachment: image.png

---

**mayumi9867** - 2025-04-04 16:45

bu the barrel is flying

📎 Attachment: image.png

---

**mayumi9867** - 2025-04-04 16:46

ah 🙂

---

**jakobismus** - 2025-04-04 16:46

Tbh the name is a little confusing but yea, set it to editor not game

---

**mayumi9867** - 2025-04-04 16:46

collision must set to editor. must i change the setting or is this enabled for the gamemode too?

---

**jakobismus** - 2025-04-04 16:48

Editor = Editor + Game, at least for me

---

**mayumi9867** - 2025-04-04 16:49

thx 🙂

---

**jakobismus** - 2025-04-04 17:15

Something changed in the auto material in 1.0, it now thinks my island is a mountain. Is there a fix? I played with the auto slope and auto height reduction settings and they don't help

📎 Attachment: Screenshot_From_2025-04-04_18-44-59.png

---

**tokisangames** - 2025-04-04 17:17

What is it supposed look like?

---

**jakobismus** - 2025-04-04 17:17

Flat ground on top should be green 🙂

---

**image_not_found** - 2025-04-04 17:18

Does disabling height blending in the material change anything? Somehow I ran into something similar for textures that were imported without alpha when upgrading to 1.0

---

**image_not_found** - 2025-04-04 17:18

I fixed it by reimporting as high-quality, which added the alpha channel

---

**tokisangames** - 2025-04-04 17:18

If it's just the top, change the auto height reduction.

---

**tokisangames** - 2025-04-04 17:20

If you look in the demo height reduction does have an effect. And it's the same as the previous version. Should similarly affect yours

---

**jakobismus** - 2025-04-04 17:21

I have, doesn't produce the desired result

📎 Attachment: Screenshot_From_2025-04-04_19-20-44.png

---

**jakobismus** - 2025-04-04 17:22

only fix i've found is to put the terrain at negative height values

---

**xtarsia** - 2025-04-04 17:22

set it to 0, or 0.01 etc

---

**xtarsia** - 2025-04-04 17:23

oh

---

**tokisangames** - 2025-04-04 17:24

If you flatten out the top in our demo, does it behave the way you want and did before? It does for me

---

**tokisangames** - 2025-04-04 17:25

At all heights 1000 to -1000 with auto height reduction at 0 and slope 1

---

**tokisangames** - 2025-04-04 17:27

What if you entirely reset your material by making a new one?

---

**jakobismus** - 2025-04-04 17:27

Ah yes, fully flat does render like I want. But even slight inclindes are blended a bit too much
Will try sec

---

**tokisangames** - 2025-04-04 17:28

I took my fully flat levels and roughed them up with the raise brush and they work as expected.

---

**jakobismus** - 2025-04-04 17:31

Huh interesting, new material didn't help but I recreated the textures too and now it's working

---

**jakobismus** - 2025-04-04 17:31

Maybe had I put something odd there, not sure

---

**vrimexd** - 2025-04-04 18:08

hello

---

**vrimexd** - 2025-04-04 18:09

just wanted to ask, is there any way to implement material based footsteps with this plugin?

---

**vrimexd** - 2025-04-04 18:12

like some way to detect material with raycast

---

**tokisangames** - 2025-04-04 18:20

Read Terrain3DData.get_texture_id() in the docs

---

**vrimexd** - 2025-04-04 18:23

thank you

---

**foyezes** - 2025-04-05 06:41

after reloading the Data Directory, it seems to work fine. although I had reload the meshes as it was replaced by the default texture card

---

**_askeladden__** - 2025-04-05 08:38

Is there any workflow where we can import a heightmap, make changes to the resulting terrain in the editor (like raising, smoothing etc), and then have an 'eraser' brush that allows us to paint an area to remove the manual changes we did (so that area goes back to the initial heighmap based one)?

---

**tokisangames** - 2025-04-05 08:47

You can undo or reimport now. There's an issue for a nondestructive workflow you can follow and discuss. Nothing implemented yet. However that particular workflow you described is probably less likely.

---

**_askeladden__** - 2025-04-05 08:54

The non destructive workflow proposed will work too for me

---

**kamazs** - 2025-04-05 09:37

and using the option from T3D submenu? (This got me once 😅 )

📎 Attachment: image.png

---

**tokisangames** - 2025-04-05 10:03

What is in this picture? Mesh stairs?
So you are using our nav mesh menu, to generate navmesh for the terrain, and for your mesh objects? And the nav mesh on your mesh objects is off?

---

**tokisangames** - 2025-04-05 10:08

Ok, please file an issue on our github and add your MRP there so we can track it. Godot generates the navmesh. We only pass it data for the terrain. We don't give it data for your objects.
Perhaps our baker script is using an option you weren't, or is adding an unexpected offset. You can review the baker here for problems:
https://github.com/TokisanGames/Terrain3D/blob/main/project/addons/terrain_3d/menu/baker.gd

---

**klautless** - 2025-04-05 11:47

so i've looked through as much of the stuff on roads as i could find, and after getting some pretty poor performance with a fully built road generator network on my first terrain, i don't want to use that plugin again; i'd like to bake the arraymesh and learn geometry nodes in blender to get those perfect seams. problem is, my region size is 2k, and with 22 regions, my godot just freezes and fails on an LOD0 bake. curious if anyone has ideas to get A to B? is there a way to bake individual regions or similar?

---

**tokisangames** - 2025-04-05 12:25

I don't know. That's what you're telling me. I've never baked on mesh objects.

---

**tokisangames** - 2025-04-05 12:32

Look at the source. bake_mesh could be modified to add an AABB, like generate_nav_mesh_source_geometry uses.

---

**tokisangames** - 2025-04-05 12:34

Alternatively you could just iterate over the 22 regions, load it, bake it, unload it.

---

**klautless** - 2025-04-05 12:44

that seems like the easier approach but i'm still a little behind the curve on this, sorry - methodology? i'm probably just missing something in the ui

---

**klautless** - 2025-04-05 12:45

could i copy individual regions out to an alternate terrain data folder 1 by 1 and bake in another scene or is there something more direct

---

**tokisangames** - 2025-04-05 12:47

I just gave you the methodology. Write a for loop. Look in the API for Terrain3D and Terrain3DData for the individual methods. You don't need to move the files at all.

---

**klautless** - 2025-04-05 12:47

sounds good - appreciate it!

---

**esklarski** - 2025-04-05 16:46

Upgraded a project last night from 0.9.2 to 1.0-4.3 last night and it all went smoothly. (amazing work achieving the 1.0, congrats)

---

**esklarski** - 2025-04-05 16:46

Tonight I'm planning to switch to Godot 4.4. Is there a particular order I should upgrade Godot + Terrain3D in? Or should I do both at the same time?

---

**bokehblaze** - 2025-04-05 17:12

The textures are suddendly appearing like this... has this ever happened to anyone?

📎 Attachment: image.png

---

**truecult** - 2025-04-05 17:14

Hey all, after upgrading from 9.3 -> 1.0 today, I'm noticing some odd behavior. When reloading a scene, Terrain3D loads with no textures. I haven't changed my save / load system since upgrading. I ran the load with 'Extreme' logs and the logs don't seem to show any errors.

I feel like I'm doing some pretty normal godot ResourceLoader stuff, but possibly this strategy is not compatible with the way Terrain3D data is handled internally. Here's a snippet of my SceneManager: https://gist.github.com/liamhendricks/af1017b2717bd39f576353a7c87cad0f.

Maybe someone can point me in the right direction to fixing this?

📎 Attachment: Screenshot_from_2025-04-05_11-01-21.png

---

**truecult** - 2025-04-05 17:25

I just tried unchecking the 'free editor textures' as suggested by another comment i found and it fixed it.

---

**truecult** - 2025-04-05 17:25

carry on

---

**tokisangames** - 2025-04-05 17:39

1.0 for 4.3 or 4.4 are essentially the same, different binary. Upgrading from previous versions requires upgrading data.

---

**tokisangames** - 2025-04-05 17:40

Suddenly? What changed? What is it supposed to look like? Reset all your texture asset settings.

---

**esklarski** - 2025-04-05 17:55

I see, thanks. The data upgrade process worked smoothly for me.

---

**_askeladden__** - 2025-04-05 19:04

I see that the control map format format has some reserved bits. If I want to utilize those reserved bits for something myself, will i only need to alter the terrain shader or will I also need to change the terrain3d source code too?

---

**xtarsia** - 2025-04-05 19:13

you can use an override shader no problem

---

**tokisangames** - 2025-04-05 19:58

Reserved for us. If you use them you run the risk of having to move your data in a later version.

---

**gosubian** - 2025-04-05 21:55

hey, long time lurker, congrats on 1.0 -  im running a double precession build, 4.4.1, can load and run the demo but when running i get these errors and collision doesn't work

📎 Attachment: image.png

---

**gosubian** - 2025-04-05 22:00

```tenpo@evo:~/src/Terrain3D$ git log
commit 821fe9c6787b7beae52b11ccbe391cbe4d74e8ad (HEAD -> 1.0, origin/1.0)```

---

**tokisangames** - 2025-04-06 05:01

Have you successfully built DB before?
Are these errors on your console? if so, show them there.
What commit of Godot and Godot-cpp?

---

**the_cloak** - 2025-04-06 07:31

Are there any specific changes I need to make to my enemy Ai agents? They seem to be not very happy when moving

---

**tokisangames** - 2025-04-06 07:33

I don't think we can answer that since we don't know anything about your enemy code.

---

**the_cloak** - 2025-04-06 07:34

Pretty much a normal state machine with nav agent and a nav mesh. What do you need to know?

---

**tokisangames** - 2025-04-06 07:35

I'm not going to guess. You need to troubleshoot it and determine if you've found a bug in the terrain system or Godot or in your own code.

---

**the_cloak** - 2025-04-06 07:35

I get the feeling it’s a collision problem, as other items I’ve (rigidbodies) are falling through the floor when both layer and mask match

---

**tokisangames** - 2025-04-06 07:36

Read the collision document

---

**tokisangames** - 2025-04-06 07:36

Dynamic collision and how to help distant enemies

---

**the_cloak** - 2025-04-06 09:07

Thanks, played around for a bit, read the docs, seems to all be working now

---

**gosubian** - 2025-04-06 10:51

thanks for quick response - ```ERROR: Method 'PhysicsServer3D.body_add_shape' has changed and no compatibility fallback has been provided. Please open an issue.
   at: gdextension_classdb_get_method_bind (core/extension/gdextension_interface.cpp:1614)
ERROR: Method bind was not found. Likely the engine method changed to an incompatible version.
   at: body_add_shape (godot-cpp/gen/src/classes/physics_server3d.cpp:471)
ERROR: Terrain3DCollision#6980:update: No more unused shapes! Aborting!
   at: push_error (core/variant/variant_utility.cpp:1098)
ERROR: Terrain3DCollision#6980:update: No more unused shapes! Aborting!
   at: push_error (core/variant/variant_utility.cpp:1098)
ERROR: 64 RID allocations of type 'P11JoltShape3D' were leaked at exit.``` 
godot: `commit 49a5bc7b616bd04689a2c89e89bda41f50241464 (HEAD, tag: 4.4.1-stable)` 
godot-cpp `commit e4b7c25e721ce3435a029087e3917a30aa73f06b (HEAD, tag: godot-4.4.1-stable)`

---

**gosubian** - 2025-04-06 10:53

i thought i had a normal precision build working but i might have just opened the demo without running it on second thought.  not sure exactly what DB is referring to or if its something beyond the 3 commits provided

---

**gosubian** - 2025-04-06 10:58

```ERROR: 64 RID allocations of type 'P12GodotShape3D' were leaked at exit.``` when switching to default physics

---

**tokisangames** - 2025-04-06 13:26

Double Precision. Have you ever successfully built Terrain3D in double precision mode before or is this your first attempt? You built all three repos with double precision?

---

**tokisangames** - 2025-04-06 13:26

Have you successfully built all three in single precision mode without these physics errors or leaks?

---

**gosubian** - 2025-04-06 13:28

first time, i believe i built all 3 with double, as it was crashing until i had (they changed the name of the arg).  am having some issues with the cpp/test project so might clean and start from scratch again..

---

**gosubian** - 2025-04-06 13:29

and my godot build is double as it warns when i open single projects

---

**gosubian** - 2025-04-06 13:32

i dont think i remember being able to build the godot-cpp project separately with double precision? but i thought it built ok when i did the whole terrain3d project

---

**tokisangames** - 2025-04-06 13:36

As the docs should say, all three must be built with the same precision. Start again, in single mode and ensure you don't have issues with physics. Then clean, and adjust your build scripts on all three. If the parameters have changed from the docs, let me know so I can update them.

---

**royal_x5** - 2025-04-06 14:02

Is there any way to have multiple small separated regions? I'm prototyping a sailing game and I would require detailed terrain only here and there for the islands, everything inbetween could be barren land, but I still would require a pretty big map.

---

**tokisangames** - 2025-04-06 14:13

You get up to 1000 regions in a world space of 32*region_size, and pay in ram/vram only for the regions used. See introduction in the docs.

---

**royal_x5** - 2025-04-06 14:14

I've seen that, but is there any way to have two separate Terrain3Ds in a single scene?

---

**royal_x5** - 2025-04-06 14:14

Like imagine each square was a terrain.

📎 Attachment: image.png

---

**tokisangames** - 2025-04-06 14:15

Absolutely no reason to use two instances. One will do exactly what you need.

---

**royal_x5** - 2025-04-06 14:15

But if I wanted to move certain squares around, or if I need a massive world?

---

**tokisangames** - 2025-04-06 14:19

You cannot move land around in game (eg floating islands). You'll have to use another terrain if you want to translate land. Offline or using the API you can move your regions to another area of the region grid.
How massive? Surely 65.5km x 65.5km is big enough?

---

**royal_x5** - 2025-04-06 14:21

65.5Km is pretty big, but if I introduce vehicles, such as boats, I can realistically cover the entire map side-to side in 2-2.30 hours.

---

**royal_x5** - 2025-04-06 14:22

Now that's not little, but if you make many archipelagos, then the distances between them become smaller and smaller, eventually it gets too saturated.

---

**tokisangames** - 2025-04-06 14:23

Not just pretty big. 30x Witcher 3. 37x GTA5. Indies don't have the resources to fill that with content.

---

**royal_x5** - 2025-04-06 14:24

I completely agree, but with a sailing game, most of that space, like 99%, will be filled with water.

---

**tokisangames** - 2025-04-06 14:24

Yes, and you'll only pay for what you use.

---

**_askeladden__** - 2025-04-06 14:26

When importing, does control map size and heightmap size need to be the same?

---

**tokisangames** - 2025-04-06 14:27

I think so

---

**tokisangames** - 2025-04-06 14:27

Though, you might be able to do them independently at different sizes.

---

**gosubian** - 2025-04-06 14:27

rebuilt single precision and works correctly, physics good. i was missing the json api steps before, whoops, my bad - after that though, i still have a runtime issue in the demo, spamming this every frame ```ERROR: Expected PackedFloat64Array or float Image.
   at: set_data (modules/godot_physics_3d/godot_shape_3d.cpp:2223)
ERROR: Expected PackedFloat64Array or float Image.
   at: set_data (modules/godot_physics_3d/godot_shape_3d.cpp:2223)
```
i saw in the godot docs a note mentioning you might need arg bits=64 on linux/windows but thats not recognised by scons and, well idk if godot recocognises it but tried none-the-less.

---

**royal_x5** - 2025-04-06 14:28

Yes, I understand that, but the fact that I'm "limited" to a 60kmx60km square is what concerns me, because most of it will be water and as such islands can't be as far apart as I'd like to.

---

**tokisangames** - 2025-04-06 14:29

For the DB mode? It's probably missing a cast in Terrain3DCollision.

---

**tokisangames** - 2025-04-06 14:31

If that is too limiting, then your options are to use another/your own terrain, use Terrain3D in different loadable scenes, or contribute a streaming regions PR that maintains a window of active regions which is on our roadmap.

---

**gosubian** - 2025-04-06 14:31

yeah double, jolt version ``` ERROR: Condition "maybe_heights.get_type() != Variant::PACKED_FLOAT64_ARRAY" is true.
   at: set_data (modules/jolt_physics/shapes/jolt_height_map_shape_3d.cpp:211)
```

---

**tokisangames** - 2025-04-06 14:32

You can file an issue. Or look through the code yourself and submit a PR. I'm sure it's a minor change. Just a matter of tracking it down.

---

**gosubian** - 2025-04-06 14:33

cool i can have a rummage some more

---

**gosubian** - 2025-04-06 14:33

thanks for your help

---

**royal_x5** - 2025-04-06 14:33

I'll look into different scenes for sure, that might be tricky due to the whole sailing but I can find a way to make it seamless probably. I'm sadly way too stupid for contributing to the PR but I'm keen on the streaming regions 👀

---

**tokisangames** - 2025-04-06 14:36

In Out of the Ashes we have multiple Terrain3D scenes. Our main land with coast will have a fishing town. Our character, Dorian, can take a boat to some islands and will load into other scenes. No live sailing for us.

---

**tokisangames** - 2025-04-06 14:37

Every terrain node is centered on 0, but we'll move her across the world in the player's mind.

---

**royal_x5** - 2025-04-06 14:45

Yes, that totally makes sense, it's just something that's not completely doable for me since I have live sailing (the whole game revolves around sailing).... but I can find shortcuts and the current size, after some calculations, is quite big regardless for now.

---

**royal_x5** - 2025-04-06 14:46

I'm wondering is there something regarding how streamed regions will work that I can read?

---

**tokisangames** - 2025-04-06 14:51

Search discord and github.

---

**gosubian** - 2025-04-06 15:45

fixed it - thank you, will send pr - i think you know what it was just needed  PackedFloat32Array -> 64 ifdef REAL_T_IS_DOUBLE for the map_data .. does that sound sane to you?

---

**tokisangames** - 2025-04-06 16:04

Yes, a preprocessor define. There was one in there at one point, but might have gotten lost when collision was moved.

---

**gosubian** - 2025-04-06 16:07

going through contributing docs atm and will go over the double docs as well see if theres anything i think has changed

---

**infinite_log** - 2025-04-06 18:26

Is there any plan to add shortcuts to the tools (like in blender you can scale using F key or shift F for strength).

---

**tranquilmarmot** - 2025-04-06 18:31

I would love a shortcut key for changing the size/strength of the selected brush. Hold shortcut key, move mouse left/right to increase/decrease size and up/down to increase/decrease strength

---

**adianlz** - 2025-04-06 18:39

Quick Q, would it be possible to make a blocky looking terrain with Terrain3D?

---

**adianlz** - 2025-04-06 18:39

Appearing like it's made of voxels I suppose but without actually being made of them

---

**adianlz** - 2025-04-06 18:40

Still using heightmaps

---

**slimfishy** - 2025-04-06 18:44

Is it possible to paint texture overlay with lower opacity, instead of full texture?

---

**tokisangames** - 2025-04-06 19:13

There's an issue about it you can follow and contribute to

---

**tokisangames** - 2025-04-06 19:14

Use the Spray tool

---

**slimfishy** - 2025-04-06 19:14

I didnt see opacity setting on spray tool

---

**slimfishy** - 2025-04-06 19:14

will check again

---

**infinite_log** - 2025-04-06 19:15

Ok

---

**tokisangames** - 2025-04-06 19:15

That would require more vertices, 2 per location instead of one. An entirely different mesh design. Use Zylann's voxel terrain

---

**adianlz** - 2025-04-06 19:15

Understood, thank you!

---

**tokisangames** - 2025-04-06 19:15

It's called strength

---

**slimfishy** - 2025-04-06 19:18

*(no text content)*

📎 Attachment: image.png

---

**slimfishy** - 2025-04-06 19:19

Same result for me

---

**tokisangames** - 2025-04-06 19:21

Watch tutorial 2 and read the texturing doc. The right technique works very well.

---

**slimfishy** - 2025-04-06 19:24

okay i know which one you mean

---

**slimfishy** - 2025-04-06 19:34

alright, it works just fine, thanks

---

**vividlycoris** - 2025-04-07 05:03

how could i change the albedo of a texture asset with an animationplayer node, i simply cannot get the animation key button to show up within the texture asset's inspector, or select/find the property with the add track button

(im trying to turn my "grass" to a white color so it looks like snow)

---

**m1ngc1** - 2025-04-07 07:26

<@455610038350774273>i got a question,terrain3D only run godot 4.3 or above?

---

**tokisangames** - 2025-04-07 07:31

There are older releases that support older engines on github.

---

**m1ngc1** - 2025-04-07 07:34

anyway！thats crazy

---

**m1ngc1** - 2025-04-07 07:35

godot can build big 3d world now

---

**tokisangames** - 2025-04-07 09:55

You can only animation properties of **Nodes**, not of resources or other things attached to the tree. That's how Godot works, nothing to do with Terrain3D. Drop the animation player and instead tween properties via code. Look at the demo and walk into the cave and back out. The lighting changes. It's not GI, it's fake. Figure out how I did that.

---

**samwel_you** - 2025-04-07 09:58

what's the best method for foliage atm? is it the in-built one or another plugin perhaps?

---

**tokisangames** - 2025-04-07 10:24

Built in

---

**samwel_you** - 2025-04-07 10:35

alright

---

**samwel_you** - 2025-04-07 10:35

thanks a lot

---

**samwel_you** - 2025-04-07 11:12

is it possible to do a fade in effect on the grass?

---

**tokisangames** - 2025-04-07 12:16

Enable distance fade on your material

---

**samwel_you** - 2025-04-07 13:05

👍

---

**_askeladden__** - 2025-04-07 13:30

Hi, 
for this line in the importer script
```ts
img = Terrain3DUtil.load_image(height_file_name, ResourceLoader.CACHE_MODE_IGNORE, r16_range, r16_size)
```
and assuming the height map is in r16 format
What `image_format` (e.g `RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM`) do i need to pass to the below function? I am trying to write an edited version of the import script where I want to send the height map to a compute shader.

```ts
var texture_format := RDTextureFormat.new()
texture_format.width = img.get_width()
texture_format.height = img.get_height()
texture_format.format = image_format
texture_format.usage_bits = RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT | RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT
    
var texture_view := RDTextureView.new()
var data = img.get_data()
return rd.texture_create(texture_format, texture_view, [data])
```

---

**_askeladden__** - 2025-04-07 13:43

nvm, I think its `DATA_FORMAT_R32_SFLOAT`

---

**_askeladden__** - 2025-04-07 14:17

Whats wrong with this code if I want to write a texture_id (e.g 1 in this case) to a control_map? Doesn't seem to be working properly (I am getting a shiny gray texture instaed of the one that I have added with texture_id = 1) 

```glsl
uint encode_control_map_value(int texture_id, int overlay_texture_id, int texture_blend, int uv_angle, int uv_scale, int hole, int navigation, int autoshader) {
  uint encoded = uint(texture_id & 0x1Fu) << 27u;
  encoded |= overlay_texture_id & 0x1Fu << 22u;
  encoded |= texture_blend & 0x1Fu << 14u;
  encoded |= uv_angle & 0xFu << 10u;
  encoded |= uv_scale & 0x7u << 7u;
  encoded |= hole & 0x1u << 2u;
  encoded |= navigation & 0x1u << 1u;
  encoded |= autoshader & 0x1u;
  return encoded;
}
uint encoded_value = encode_control_map_value(1, 1, 0, 0, 0, 0, 0,0 );
    
vec4 output_color = vec4(
  float((encoded_value >> 24) & 0xFFu) / 255.0,
  float((encoded_value >> 16) & 0xFFu) / 255.0,
  float((encoded_value >> 8) & 0xFFu) / 255.0,
  float(encoded_value & 0xFFu) / 255.0
);
    
// Write to output control map
imageStore(output_control_map, pixel_coords, output_color);
```

---

**_askeladden__** - 2025-04-07 14:18

*(no text content)*

📎 Attachment: 2025-04-07-191750_hyprshot.png

---

**tokisangames** - 2025-04-07 14:48

Is the shader compiling? It may not be, complaining about all of the int variables anded with units

---

**_askeladden__** - 2025-04-07 14:48

yes it compiles, i tried without units as well but same result

---

**xtarsia** - 2025-04-07 14:49

output RGB might be backwards?

---

**tokisangames** - 2025-04-07 14:49

If it's compute, send it to the CPU as an image first so you can tell what it is and the data on it. Compare the data with the functions in the API, as well as the format.

---

**tokisangames** - 2025-04-07 14:49

I'm suggesting adding more uints

---

**_askeladden__** - 2025-04-07 18:04

Any way to 'blend' two different texture ids using control map?

---

**_askeladden__** - 2025-04-07 18:04

*(no text content)*

📎 Attachment: image.png

---

**xtarsia** - 2025-04-07 18:05

1 as overlay, 1 base, blend via the blend value

---

**esklarski** - 2025-04-07 20:53

How do I adjust what gets rendered beyond the terrain3d terrain? I remember it being on the Terrain3D node under Mesh or Rendering but I cannot find the setting since upgrading to 1.0.0 😅

📎 Attachment: Screenshot_From_2025-04-07_13-46-20.png

---

**image_not_found** - 2025-04-07 20:56

Terrain3D node > material > world background

---

**vividlycoris** - 2025-04-07 21:57

(the terrain has a unique name on it in local view)
im trying to tween it now instead like you recommended, but my script thinks that the terrain node is "wrapped:0"? despite the terrain node being shown inside it's inspector in remote view, i've tried setting the terrain3dasset itself but it gives the same result where the texture is "null", am i missing something entirely?

📎 Attachment: ss414.png

---

**tokisangames** - 2025-04-08 04:04

Wrapped is the `name` of gdextensions. Use `if is Terrain3D ` if you wish to check what it is.
Uncheck rendering/free_editor_textures

---

**vividlycoris** - 2025-04-08 04:10

the setting made it work now, thanks

---

**tokisangames** - 2025-04-08 16:08

Can you look at this issue please? https://github.com/TokisanGames/Terrain3D/issues/671
Have you experienced this either before or after your double precision PR?

---

**gosubian** - 2025-04-08 16:10

i don't have this issue

---

**gosubian** - 2025-04-08 16:24

i didn't test this when i had the collision issue, maybe see what happens if they run the demo

---

**gosubian** - 2025-04-08 16:25

but guessing it would be related

---

**tranquilmarmot** - 2025-04-09 06:43

Has anybody run into issues with runtime baked navmeshes not rendering when "Visible Navigation" is turned on? All of the other debug rendering works.

I'm doing a lot of runtime loading of Terrain3D regions and something somewhere is breaking the debug view, but I can't figure out what. Agents are still able to properly generate paths just fine, so I know the navmesh is there.

---

**tranquilmarmot** - 2025-04-09 06:45

Spent a few hours tonight trying to get a minimal repro but I have a _lot_ of moving parts so it's hard to tell what is going wrong (not even sure the issue is with Terrain3D...)

---

**tokisangames** - 2025-04-09 07:33

We neither make the nav mesh, nor display it. All we do is send the data to Godot. You control how much data is sent and how Godot bakes via the settings in the nav region mesh, so start there. Make it a smaller amount, and tweak other settings. Try different versions of Godot and look for a regression bug. If you can find one, an MRP will help them track it down, but better if you have hard coded data without Terrain3D, eg a baked array mesh and a baked nav mesh you've saved to a resource file.

---

**thereiver** - 2025-04-09 08:18

Hi, thank you for this plugin, it's awesome. I'm having trouble importing >16km exrs - do you have any pointers? The heightmap is coming from Gaea 2.0 and can be more than 2gb in size for a 32km exr. I tried PNG16/64 but there was a pixel size limit. If I load the exr from the importer externally rather than putting the exr directly in my project, that stops it from crashing when starting Godot. But then it'll crash during the import process

---

**tokisangames** - 2025-04-09 08:31

Do your GPU, driver, and Godot even support 32k textures? Probably not. PNG16 is also unsupported by Godot. Limit your files to 16k slices and do multiple imports.

---

**thereiver** - 2025-04-09 08:33

I'm not sure tbh, but I'm using a 4090. Thanks, I'll do that!

---

**thereiver** - 2025-04-09 08:58

So if it's split into 64 files does it essentially coming down to importing 64 times and manually aligning them? Is there an easier way to align them that you know of?

---

**tokisangames** - 2025-04-09 09:02

We support only up to 65,535m per side, not 131km per side. It's unlikely your players will have enough vram for that anyway.
Write a script to import your slices. You already have one to work off of.

---

**thereiver** - 2025-04-09 09:02

Nice one, thanks

---

**thereiver** - 2025-04-09 09:04

Gaea outputs 64 files for a 32km map even though each subdivision is 4k so not sure what's going on there. Might need to split them manually in gimp or something

📎 Attachment: image.png

---

**tokisangames** - 2025-04-09 09:52

32k per side / 8 tiles per side = 4k per side
It's already split properly for you.

---

**thereiver** - 2025-04-09 09:54

Ahhh that makes sense, thank you

---

**thereiver** - 2025-04-09 09:56

I'm writing a little plugin that'll import these, I'll drop it in here when I'm done as it might help somewhat

---

**tokisangames** - 2025-04-09 10:19

Great. What would also be helpful from someone who owns a terrain gen tool is a script to import the texture layout (splat or index map) into our index map. It's not hard.

---

**thereiver** - 2025-04-09 10:27

I have Gaea 2.0 Pro (the $200 license) so can do that, it's np. Would need to look into it more to find out how exactly to do that though

---

**thereiver** - 2025-04-09 11:42

Got something working, it extends terrain3d and just drops in your addons folder. need to refine it though

---

**thereiver** - 2025-04-09 11:56

Lol damn that actually works better than I expected. I'll work on this a bit more and drop it as an addon or PR maybe

---

**tokisangames** - 2025-04-09 13:30

It can go in our extras folder with the other items. Eventually there will be a more integrated tools menu w/ importer and more options.

---

**thereiver** - 2025-04-09 13:32

here it is at 32km with size 2048 regions

📎 Attachment: image.png

---

**thereiver** - 2025-04-09 13:32

Ignore the height scale - needs some tweaking

---

**thereiver** - 2025-04-09 13:33

You mentioned vram - are we unloading and loading regions dynamically? I guess the only hurdle left is making sure if I was to upload a really really big map, that it handles all of that

---

**thereiver** - 2025-04-09 13:53

I’ll continue demo’ing it in <#1065519581013229578>

---

**tokisangames** - 2025-04-09 15:08

Great. Region streaming is not yet implemented

---

**thereiver** - 2025-04-09 15:13

Thanks for confirming, I will take a shot at it today

---

**_askeladden__** - 2025-04-11 15:03

is this stretching an issue with the heighmap or something else? Seems to occurs where there is a sharp bend (crevice or peak)

📎 Attachment: image.png

---

**tokisangames** - 2025-04-11 15:04

Disable or adjust projection settings, or smooth out the height.

---

**_askeladden__** - 2025-04-11 15:07

Thanks, decreasing projection threshold fixes it.

---

**amceface** - 2025-04-12 12:28

how do you recommend one should handle enemy ragdolls? If the collision is dynamic, the ragdoll will just fall through the terrain

---

**tokisangames** - 2025-04-12 12:54

If far from the camera. Read the collision page in the docs. The option for full physics is available, just expensive.

---

**amceface** - 2025-04-12 12:58

Yeah, I read it. I was hoping there is a way to force a collision area to a specific zone, same as the player's camera.

---

**tokisangames** - 2025-04-12 13:01

It is the same as the players camera. How far away from your player and camera is your enemy?

---

**amceface** - 2025-04-12 13:11

50 - 100 meters

---

**thereiver** - 2025-04-12 13:18

When we "Save to disk" when importing, how comes it saves the files with varying "-" and "_" in the name like "terrain3d_00_00" and then we have "terrain3d_01-01"

---

**thereiver** - 2025-04-12 13:18

At first I thought it was a bug, but now I'm not sure

---

**xtarsia** - 2025-04-12 13:36

Location coordinate (0,1) vs (0,-1)

---

**xtarsia** - 2025-04-12 13:37

Can consider the underscores to be +

---

**thereiver** - 2025-04-12 13:38

ahhhhhh

---

**thereiver** - 2025-04-12 13:38

How did I not see that

---

**thereiver** - 2025-04-12 13:40

Thanks!

---

**tokisangames** - 2025-04-12 14:47

You can easily expand dynamic collision that far.

---

**tokisangames** - 2025-04-12 15:03

<@68074670280159232> Please ask terrain help questions here.

---

**enroy** - 2025-04-12 15:07

Is there a way to use a higher resolution color map? I have 10k^2px satellite images but the height maps are 2k. Right now I'm splitting them into 4 and scaling to SIZE_2048 regions but that means I'm still downscaling the color map from 5k to 2k, which still looks really blurry when up close. Should I split them further and apply vertex_spacing < 1? I don't know if I'll be running into a region count limit this way, unless the limit is in size, not count.

---

**thereiver** - 2025-04-12 15:19

Are they .exrs? If so I've been working on a feature which will solve this for you

---

**tokisangames** - 2025-04-12 15:21

You can make your own uniform in the shader, and add a high res map to it, then look it up instead of the colormap, which is currently 1px = 1 vertex.

---

**enroy** - 2025-04-12 15:31

I can convert them as such if need be yes

---

**enroy** - 2025-04-12 15:31

ah I see okay thank you

---

**vividlycoris** - 2025-04-12 22:03

is there a way to prevent the project on terrain3d modifier for proton scatter to exclude certain collision layers (the option project on colliders modifier has), or would i have to figure out how to change the modifier script to support that option?

📎 Attachment: ss427.png

---

**tokisangames** - 2025-04-12 23:07

We don't make or support Scatter. The script is there to help you use it, or adjust it for your needs, but its no longer as important since our instancer is better in most cases. The script doesn't use physics, so collision layers are irrelevant. Use project on colliders if you want to use collision layers.

---

**maxibruv** - 2025-04-13 03:51

is there a way to make the terrain transparent?

---

**maxibruv** - 2025-04-13 03:51

*(no text content)*

📎 Attachment: image.png

---

**maxibruv** - 2025-04-13 03:52

im trying to add depth to this flat map

---

**maxibruv** - 2025-04-13 03:52

but the terrain just clips thru the map

---

**puppy_souls** - 2025-04-13 04:01

just curious as to why teh terrain looks so grainy after applying a texture

📎 Attachment: environment_test_-_Godot_Engine_2025-04-13_14-00-25.mp4

---

**vhsotter** - 2025-04-13 04:23

Do you have the filtering on the terrain textures set to nearest?

---

**truecult** - 2025-04-13 04:24

Hey guys, I'm trying to make a map UI, and was wondering if anyone has some tips. I am trying to decode the control maps to get a 2D image of the Terrain with correct material at each pixel, but having trouble matching it properly. Kinda feels like I'm essentially re-creating the terrain shader itself and there might be an easier way lol. Was hoping there was maybe a method like `Terrain3DUtil.get_thumbnail()` but for control maps or something

---

**puppy_souls** - 2025-04-13 04:28

i managed to fix it somehow im not sure how though

---

**puppy_souls** - 2025-04-13 04:28

anti aliasing maybe but i turned it off and its not there

---

**tokisangames** - 2025-04-13 08:15

Edit the shader to make it so, same as any object. Make a MeshInstance3D w/ material, make it transparent, convert that material to a shader material to see the code then apply that to ours.

---

**tokisangames** - 2025-04-13 08:15

Your textures don't have mipmaps.

---

**tokisangames** - 2025-04-13 08:19

Typically one would make an orthographic camera overhead, feed that into a viewport texture, and take a picture of it.

---

**tokisangames** - 2025-04-13 08:19

On the other hand learning how to use bitfields will make you a better programmer. But even that's not necessary, as Terrain3DUtil and Terrain3DData both have many functions to enc/decode the data for you in multiple ways.

---

**tokisangames** - 2025-04-13 08:20

There are many ways to accomplish your objective.

---

**highgame_def** - 2025-04-13 15:40

hey, I can't import a r16 heightmap (all my previous tests were in png and no problem) is there anything more to do for r16? Even the color doesn't display

📎 Attachment: EBAE729B-454F-4E31-A14A-73F4122CECEE.png

---

**thereiver** - 2025-04-13 15:41

What happens if you increase the scale to 1000?

---

**highgame_def** - 2025-04-13 15:42

*(no text content)*

📎 Attachment: 692D684D-AAE2-45E2-ADF8-36D641BF11A4.png

---

**highgame_def** - 2025-04-13 15:42

still nothing

---

**highgame_def** - 2025-04-13 15:42

i touch all parameters and nothing show when i import

---

**highgame_def** - 2025-04-13 15:43

i might just re export the heightmap in png

---

**thereiver** - 2025-04-13 15:44

Id recommend .exr over png as it stores up to 32 bits whereas godot only supports 8 with png

---

**highgame_def** - 2025-04-13 15:45

you can export exr out of world machine ? i only see png and r16

---

**thereiver** - 2025-04-13 15:45

You could probably convert r16 to .exr https://convertio.co/exr-converter/

---

**highgame_def** - 2025-04-13 15:47

thx i'll test it

---

**thereiver** - 2025-04-13 15:48

They can be quite big files, I built a tool that imports sliced exr's into godot and auto aligns them in a grid. you'd need to find a way to slice and name them a certain way though, as I'm testing with Gaea 2.0 rather than world machine (which splits the files for you)

---

**thereiver** - 2025-04-13 15:48

no worries

---

**highgame_def** - 2025-04-13 15:50

i exported this only in 4k i dont think i need much higher quality for this project but thats cool to know. I was testing MTerrain the other day and it recognize tiles with proper naming directly

---

**highgame_def** - 2025-04-13 15:51

however, Convertio doesn't know the r16 and I can't find a converter on the internet that will take it.

📎 Attachment: E911B180-63FC-451C-8C1A-2F2545A669ED.png

---

**thereiver** - 2025-04-13 15:51

Damn, what other file types can you export to?

---

**thereiver** - 2025-04-13 15:51

with WM

---

**highgame_def** - 2025-04-13 15:51

but

---

**highgame_def** - 2025-04-13 15:52

sorry i want to do everything fast

---

**highgame_def** - 2025-04-13 15:52

BUT

---

**highgame_def** - 2025-04-13 15:52

world machine export in exr

📎 Attachment: C743AA06-026B-4DDA-A02C-B34C325253E9.png

---

**highgame_def** - 2025-04-13 15:52

i'm just blind <:gunmouth:1146904437919580273>

---

**thereiver** - 2025-04-13 15:52

Oh sweet, how big is that file?

---

**thereiver** - 2025-04-13 15:52

Just out of curiosity

---

**highgame_def** - 2025-04-13 15:53

4k by 4k and its giving me 56mo

---

**highgame_def** - 2025-04-13 15:53

the r16 one was 32mo

---

**thereiver** - 2025-04-13 15:53

mb? that's quite good

---

**highgame_def** - 2025-04-13 15:53

it shows mega octet

---

**highgame_def** - 2025-04-13 15:54

i will try an 8k export later i just want to see the terrain in godot before i do anything

---

**thereiver** - 2025-04-13 15:55

ahh

---

**highgame_def** - 2025-04-13 15:56

yep it work with exr, so bye my beloved r16, i dont know you but i will remember you <:KEKW:1097101207278977044>

📎 Attachment: C220370E-7729-4B9D-8ED0-8F593B1DB7B3.png

---

**thereiver** - 2025-04-13 15:58

Looks awesome man

---

**highgame_def** - 2025-04-13 15:59

thank you 💖

---

**jamonholmgren** - 2025-04-13 17:48

I'm running into the terrain collisions not matching the terrain very closely in some areas of my map. You can see if you look at the tires of the apache helicopter, there are contact points there with the terrain.

I'll try to make a minimal repro, but if there's something obvious in the settings, let me know.

You can also see a bush from the Terrain3D instancing feature floating there.

📎 Attachment: CleanShot_2025-04-13_at_10.43.342x.png

---

**cepodi2** - 2025-04-13 17:56

Hello I need some help please, I was trying to add a New texture to Terrain3D, but then when i try to add It, this happens

---

**cepodi2** - 2025-04-13 17:56

*(no text content)*

📎 Attachment: IMG_20250413_145448.jpg

---

**cepodi2** - 2025-04-13 17:56

Before:

---

**cepodi2** - 2025-04-13 17:56

*(no text content)*

📎 Attachment: IMG_20250413_145411.jpg

---

**cepodi2** - 2025-04-13 17:57

It loses completely all the texture that already was in the map

---

**tokisangames** - 2025-04-13 21:42

You're doing something strange with your camera or viewport and haven't told Terrain3D which camera to use with set_camera()

---

**tokisangames** - 2025-04-13 21:44

Look up how to use your computer to take screenshots, rather than using your phone.
Record a video with OBS. Your pictures don't show what you did to add a new texture.
Try adding one in our demo.

---

**aowood** - 2025-04-14 02:46

Was dealing with the same issue so glad there's a feature to dealing with it! Thank you!

---

**puppy_souls** - 2025-04-14 03:29

thanks so much

---

**ansraer** - 2025-04-14 08:09

Is there a way to split my terrain across multiple scenes? 
I am working on a small demo with multiple islands and would like to edit each island in its own scene. That way I could freely reposition them in my world map as my game evolves.

---

**thereiver** - 2025-04-14 08:10

Why don't you just split the heightmap file itself?

---

**ansraer** - 2025-04-14 08:13

I don't want to have multiple terrain objects in my scene. Everywhere I have an island it would be rendered over my seafloor terrain, thus wasting the seafloors vertex performance for nothing.

---

**ansraer** - 2025-04-14 08:14

Plus, there would be no easy way too smoothly blend the seafloor with my islands height.

---

**ansraer** - 2025-04-14 08:15

Ideally I would like to have some kind of "terrain stamps". 3D objects that contain their own heightmap, can be paibted on, can be moved around and are automatically blended into the terrain they are on top of.

---

**ansraer** - 2025-04-14 08:16

That would allow me to have one of these "stamp" objects for every one of my island scenes and I could then place those islands wherever I want to on my global map and have the terrain take care of itself.

---

**highgame_def** - 2025-04-14 08:49

Hey, i have a little question, if i re import my heightmap for making it a little bit taller, all the painting i've done with my actual version will be apply with the new data ? Or is it not save in the terrain material ?

---

**tokisangames** - 2025-04-14 10:59

We have many multiple levels in different scenes. To split your data either just move and rename the region files to different directories, or export and reimport it.

---

**tokisangames** - 2025-04-14 10:59

Texturing is saved in the control map, stored in your region files. You can export and reimport any of height, control, or color maps independently.

---

**jamonholmgren** - 2025-04-14 15:05

Seems to be working! Somehow I missed this [troubleshooting step](https://terrain3d.readthedocs.io/en/stable/docs/troubleshooting.html#collision-is-offset-from-the-mesh-and-it-s-showing-lower-lods-near-the-camera). Thanks for the direction!

---

**cepodi2** - 2025-04-14 15:20

Alright thanks

---

**cepodi2** - 2025-04-14 15:21

I will fix the vídeo and screenshot problem for more accurate explanations

---

**aldebaran9487** - 2025-04-14 15:21

I have had this kind of result before. Try to verify the import options of your texture, they must be the same format.

---

**cepodi2** - 2025-04-14 15:21

Oh ok thanks brother

---

**aldebaran9487** - 2025-04-14 15:28

Also, when i have tested import format, ensure that all the textures have mipmap, when we don't have them but that terrain3d option to anistropic filter is enabled they must be generated at runtime, and hit perdormance a lot.

---

**maxibruv** - 2025-04-14 17:27

theres no transparency option

📎 Attachment: image.png

---

**tokisangames** - 2025-04-14 17:28

You completely misunderstood what I wrote.

---

**maxibruv** - 2025-04-14 17:28

yes...

---

**maxibruv** - 2025-04-14 17:29

i didnt understand what you wrote :(

---

**tokisangames** - 2025-04-14 17:29

If you want the terrain to be transparent, you must edit the shader to make it so.

---

**maxibruv** - 2025-04-14 17:30

wheres the shader...?

---

**tokisangames** - 2025-04-14 17:30

In the material, shader override

---

**maxibruv** - 2025-04-14 17:43

```shader_type spatial;

void vertex() {
    // Called for every vertex the material is visible on.
}

void fragment() {
    ALBEDO = texture(TEXTURE_ALBEDO, UV).rgb;
    ALPHA = texture(TEXTURE_ALBEDO, UV).a * 0.5;
}```

---

**maxibruv** - 2025-04-14 17:43

i tried this code

---

**maxibruv** - 2025-04-14 17:44

*(no text content)*

📎 Attachment: image.png

---

**maxibruv** - 2025-04-14 17:44

but is not working :(

---

**maxibruv** - 2025-04-14 17:44

to be fair ive never touched shaders before

---

**tokisangames** - 2025-04-14 17:53

Indeed, but unfortunately I can't be your personal shader tutor. I gave you instruction on how to get transparency shader code in my first message. You need to spend time with youtube tutorials learning the basics of shaders before editing ours. Do not erase our entire shader and put in your own or you'll break the terrain. You need to modify it.

---

**vhsotter** - 2025-04-14 17:56

Yeah, shaders are a wholly different animal and don't operate quite the same as most other programming languages in how it works. If you've not touched them before, it's strongly recommended you spend some time with tutorials and futzing around first so you can get a feel for what's going on. On top of that, there's a lot of shaders out there for Godot that are outdated because some things were either renamed or removed in more recent versions, so you gotta be careful about that.

---

**maxibruv** - 2025-04-14 18:05

how do i access your shader, the built in one?

---

**tokisangames** - 2025-04-14 18:07

Enable the shader override in the material like I said. It will give you the whole shader currently being used for you to modify.

---

**maxibruv** - 2025-04-14 18:10

i dont see a material or shader overide option on the terrain textures

---

**maxibruv** - 2025-04-14 18:10

i see it on my floor map but i dont want that to be transparent

---

**maxibruv** - 2025-04-14 18:14

GASP\

---

**maxibruv** - 2025-04-14 18:14

I FOUND IT

---

**maxibruv** - 2025-04-14 18:14

sorry i didnt know where to look

---

**maxibruv** - 2025-04-14 18:15

but i see now

---

**maxibruv** - 2025-04-14 18:15

its this one right?

📎 Attachment: image.png

---

**tokisangames** - 2025-04-14 18:16

Yes.
> i see it on my floor map but i dont want that to be transparent
What do you mean? That is exactly what you asked me for, a transparent terrain.

---

**maxibruv** - 2025-04-14 18:17

no no i want the terrain that is being built to be semi transparent so I can see the map underneath while im buiilding the terrain up

---

**maxibruv** - 2025-04-14 18:17

i can make the map on the floor transparent but that doesnt make the terrain transparent

---

**tokisangames** - 2025-04-14 18:18

You can just import your map into the colormap and forget about modifying the shader. Or go with the shader route, but I wouldn't.

---

**maxibruv** - 2025-04-14 18:23

oh yeah that workers way better 💀

---

**infinite_log** - 2025-04-14 18:24

Does holes result in performance gain?🤔

---

**tokisangames** - 2025-04-14 18:34

Yes. Change the material/world background to none for the most.

---

**tokisangames** - 2025-04-14 18:34

Read performance tips in the docs

---

**maxibruv** - 2025-04-14 19:02

i imported but the import scale isnt working

---

**tokisangames** - 2025-04-14 19:02

Scale is vertical height

---

**maxibruv** - 2025-04-14 19:02

and I cant see any oither way to chagne the size

---

**tokisangames** - 2025-04-14 19:02

Photoshop resize

---

**maxibruv** - 2025-04-14 19:02

ahhh oki

---

**maxibruv** - 2025-04-14 21:01

yay :D

📎 Attachment: image.png

---

**maxibruv** - 2025-04-14 21:01

sorry for all the questions and confusion, but thank you for the help!!

---

**tokisangames** - 2025-04-14 23:09

Your heightmap is 8-bit, which is not recommended and will require a lot of smoothing. Convert to 16-bit in photoshop and blur.

---

**somerandomguy2471** - 2025-04-15 00:07

is there a way to make the textures low polly I am trying to make a like PS1 style game

---

**vhsotter** - 2025-04-15 00:32

What do you mean by making textures low poly?

---

**somerandomguy2471** - 2025-04-15 00:34

sorry I figured it out

---

**somerandomguy2471** - 2025-04-15 00:34

thank you though

---

**somerandomguy2471** - 2025-04-15 02:25

new question how do you fill holes

---

**aldebaran9487** - 2025-04-15 06:56

If you want to fill hole with thing, there is a cave example in the demo map.

---

**tokisangames** - 2025-04-15 08:16

Ctrl inverses most operations. Read UI page in the docs.

---

**.yannk** - 2025-04-15 09:05

Hi there. thanks a lot for your  wonderful addon 🙂
I wanted to test it out a bit but I encounter a problem I have not seen in the FAQ in the doc. I have just downloaded from the AssetLib in my 4.4.1.stable Godot Under GNU/Linux Debian, then launched the demo scene with F6 and the terrain seems to have no collision, the capsule just fall through the terrain. The CodeGeneratedDemo is fine, nevertheless. So did I miss something in using the demo scene ?

---

**tokisangames** - 2025-04-15 09:16

Not sure, you'll need to do some troubleshooting on your end. It's worked fine for countless people for a long time. Clearly it works in one scene which largely uses the same code. Change the options in collision mode.

---

**.yannk** - 2025-04-15 09:18

Thanks for the quick answer, so I will check on my side. As there is a lot of documentation and info, I thought I have perhaps missed a point somewhere.

---

**aldebaran9487** - 2025-04-15 09:27

Hi !
I have some problem to add some sort of shell texturing to my terrain, i have this code :

---

**aldebaran9487** - 2025-04-15 09:28

*(no text content)*

📎 Attachment: message.txt

---

**aldebaran9487** - 2025-04-15 09:28

*(no text content)*

📎 Attachment: message.txt

---

**aldebaran9487** - 2025-04-15 09:30

The first layer is ok :

📎 Attachment: image.png

---

**aldebaran9487** - 2025-04-15 09:30

My problem is that the layer don't show, i have search for them and finaly, they are far under the terrain :

📎 Attachment: image.png

---

**aldebaran9487** - 2025-04-15 09:32

It seems to be influenced by skip_vertex_transform; but i i remove that then even the first shell layer in misplaced :

📎 Attachment: image.png

---

**aldebaran9487** - 2025-04-15 09:38

Ok, found it, it was my fault, was not setting the other shader params for the shells other than 0

---

**.yannk** - 2025-04-15 09:52

I answer to myself if that can be of any help to anybody : the addon seems not to have properly loaded or installed the demo files the first time. As my project was not empty, perhaps it has generated some mess. I have deleted everything (addon + demo folder) and reuploaded again, and everything is fine now. I have just unchecked `icon.png `/ `icon.png.import` / `project.godot` for them not to be installed.

---

**tokisangames** - 2025-04-15 10:11

Did you restart Godot twice after installing, per the instructions?

---

**.yannk** - 2025-04-15 17:57

Yep. I just didn’t take care if the files installed message was indicating any possible problem

---

**throw40** - 2025-04-16 03:18

The new particle examples dont seem to show up in the file on the releases page. Is that on purpose?

---

**xtarsia** - 2025-04-16 03:41

Not a release, just nightly builds.
https://github.com/TokisanGames/Terrain3D/actions/runs/14477869806

---

**throw40** - 2025-04-16 04:06

oh ok, thanks

---

**truecult** - 2025-04-16 04:40

Hey guys, so I took the advice that was given to me a few days ago about creating a map ui. I've added a new subviewport to render the texture from, but I'm having an issue with the camera. The image gets cut off on the left side because it's past the point where the terrain will render. Terrain3D is using my player camera as it's snapping point, so I have tried placing a different camera out in the world and setting the terrain camera to use that one, but no luck. Anyone got some advice?

📎 Attachment: map.png

---

**truecult** - 2025-04-16 05:07

I messed around with it and fixed it by choosing the correct subviewport render update mode. carry on

---

**nucky.rsps** - 2025-04-16 15:11

Is there a way to do region/chunk in based loading? Like only rendering the surrounding regions while you’re in the game with a terrain

---

**tokisangames** - 2025-04-16 15:13

There are no chunks. You can load or unload regions via the Data API. The terrain does render the surrounding regions in game. You can turn off non-regions with Material/WorldBackground. There's a PR for region streaming you can follow if interested.

---

**nucky.rsps** - 2025-04-16 17:11

Where can I find more information about region streaming?

---

**tokisangames** - 2025-04-16 17:13

Look at the open PRs there's only a few of them.

---

**tokisangames** - 2025-04-16 17:15

Also search this discord

---

**zacharycarter** - 2025-04-16 20:56

I had a question about the collision. I had been having issues with it on the newest 1.0.0 version. I understand now that I had to do set_camera() to get it to work properly, but I was wondering if it is possible to make it work with multiple cameras?

---

**tokisangames** - 2025-04-16 21:06

A clipmap terrain is designed to have LOD0 and collision at the origin of one camera per frame. Change to full collision or use the several alternate methods described in the docs.

---

**titruc** - 2025-04-17 15:20

hello there, i want to use terrain3D for creating a skyisland so i've setup terrain3d, paint a little testscene and to give the illusion of a floating island i've write a little shader that detect if a vertex is under a certain height to discrad it, but this seam to have a lot of performance issus, from the virtual profiler i can see that a lot of work for the gpu is actually to render transparent pass so i guess this is because of my shader, so is there any way i can use terrain3D but without having the infinite terrain and only terrain who are alternate ?

---

**tokisangames** - 2025-04-17 15:31

Our WorldBackground None and holes discard vertices in the default shader without issue and with a performance gain. I would use our technique instead of your own.

---

**titruc** - 2025-04-17 15:37

ok WorldBackground discard vertice in the background and then i have to paint hole everywhere i want to not have a floor ?

---

**tokisangames** - 2025-04-17 15:47

Customize the shader if you want auto by height. Just don't use `discard`, that's the point. Our shader doesn't go in the transparency pipeline.

---

**infinite_log** - 2025-04-17 16:13

You can also divide the vertex by 0.0 so that godot will not render it rather than using discard.

---

**beyondbelief954** - 2025-04-18 10:03

Hello everyone,

I am trying to follow the tutorial for painting the textures on the terrain but my textures paint it blocky, instead of a smooth circle for example. What am I doing wrong here?

So, the video is from the YouTube tutorial, the screenshot is my project. Same use case, except my base texture painting blocky, not smooth like in the video.

Thanks in advance.

📎 Attachment: tutorialvid.mp4

---

**tokisangames** - 2025-04-18 10:04

Read the texture setup and painting docs. You need quality textures with heights and proper technique. Lack of one gives poor results.

---

**beyondbelief954** - 2025-04-18 10:12

Already did that.  Packed with albedo/height, normal/roughness. Walked through the docs to the letter.

---

**beyondbelief954** - 2025-04-18 10:18

by the way... The demo project textures also are blocky

📎 Attachment: Screenshot_2025-04-18_131824.png

---

**tokisangames** - 2025-04-18 10:18

How the textures blend is a mathematical operation. Either it's right or it's wrong. Just because you added a texture height map doesn't mean it's a good texture. Or you didn't use the technique described in the docs and shown in the video.

---

**tokisangames** - 2025-04-18 10:18

I have no issue painting with them. It's your technique.

---

**tokisangames** - 2025-04-18 10:19

You're not following the recommended technique in the docs and video.

---

**tokisangames** - 2025-04-18 10:19

https://discord.com/channels/691957978680786944/1130291534802202735/1357747065350000791

---

**beyondbelief954** - 2025-04-18 10:19

I am literally doing the same thing in the video...

---

**beyondbelief954** - 2025-04-18 10:19

Anyway. thanks!

---

**tokisangames** - 2025-04-18 10:20

Sorry, you are not. Read that link I just sent you.

---

**tokisangames** - 2025-04-18 10:20

Record a video and I will correct your process

---

**tokisangames** - 2025-04-18 10:21

Proper techinque blends like this: https://discord.com/channels/691957978680786944/1065519581013229578/1302538709362544660

---

**beyondbelief954** - 2025-04-18 10:36

Uploading in a sec. Using your textures in the video

---

**tokisangames** - 2025-04-18 10:37

You might also be disabling the autoshader rather than painting texture. This is also discussed in video 2. It's easier to see how the blend works if you disable the autoshader in an area first. The instructions say Paint a whole area first, which disables the autoshader. It looks like you didn't do that in the demo picture. Then you can use Paint and Spray in the manual area. Once you understand how it works, you can blend into the autoshader.

---

**beyondbelief954** - 2025-04-18 10:40

https://streamable.com/3yrhyh

My issue is not really with the overlay texture blending. Painting base texture with a circle should result in a circle(just like your tutorial video), not blocky circle...Then what's the point with the brush?

---

**beyondbelief954** - 2025-04-18 10:42

Might be something to do with the UV scale(seems like reducing it reduces the blockiness)

---

**tokisangames** - 2025-04-18 10:42

Some key things to understand:
* This is a vertex painter, not a pixel painter
* If you want to paint a circle, which you did get on the ground, it must be large enough to cover enough vertices to give resolution to the circle.
* If you want blended textures you must use the Spray tool and have quality textures.

---

**tokisangames** - 2025-04-18 10:45

Try drawing a circle with squares on paper. What size must the squares be to give you what you would call a circle? You just drew an 8m circle with 1m squares. Try drawing a 50m circle. Or reduce vertex spacing to .25m and draw 8m again.

---

**tokisangames** - 2025-04-18 10:47

Read the introduction doc that talks about vertex painting

---

**beyondbelief954** - 2025-04-18 11:00

As I said, don't care about the blending at the moment.

"Try drawing a circle with squares on paper. What size must the squares be to give you what you would call a circle? You just drew an 8m circle with 1m squares. Try drawing a 50m circle. Or reduce vertex spacing to .25m and draw 8m again."

Why not blend the square textures to get a circle instead of binary the textures to asphalt or not?

I just drew an 8m circle with 1m squares because I need a asphalt road that 8m wide

Again, I might be completely out of touch about the topic but current workflow does not make sense to me.

Thank you for your help. I'll go over the docs again

Edit: Just wanted to point out that I am not trying to bash the plugin or something, just trying really hard to understand. Without it, my project wouldn't exist so THANK YOU

---

**tokisangames** - 2025-04-18 11:05

> Why not blend the square textures to get a circle instead of binary the textures to asphalt or not?
I don't understand. We are blending textures based on texture height, a noise map, and weighted strengths of 4 vertices. We aren't painting squares. If you look at our blending algorithms and have a suggestion to improve them, we're all ears. The goal is not to get a circle. The goal is to get realistic, natural blending, and optimal performance and we've achieved both.

---

**tokisangames** - 2025-04-18 11:06

> I just drew an 8m circle with 1m squares because I need a asphalt road that 8m wide
Is your road going to be an 8m circle? I still don't understand your complaints. You can make an asphalt road 8m wide and blend it into the environment just fine. It can also be a curved road without looking blocky. Maybe you need to spend a lot more time with the tools. The tools are very good. Be an artist for a while and learn how they work.

---

**tokisangames** - 2025-04-18 11:15

Painting lines on a road or using a painted road texture will be challenging. Possible for a good artist. It might be easier to use the Godot road generator. But for a plain asphalt texture painted on dirt, everything above works fine.

---

**xtarsia** - 2025-04-18 11:43

there is some room for improvement by interpolating the control map blend value, though currently it creates artifacts at some transitions (tho changing the painting logic a bit can fix it)

📎 Attachment: image.png

---

**magnanimoose.** - 2025-04-18 16:07

I love your plugin but I suck at it!  I would love to a video of it being used to design your game.  Just to get a sense of the best practices.  Just stream an hour of designing landscapes for Out of the Ashes.  That would be soooo helpful.  Thanks.

---

**shadowwolf2719** - 2025-04-18 18:16

Hey all, I've been trying to use this plugin for a couple days, it doesn't seem like there's any way to get my mouse to interact with the terrain and nothing appears wrong to me. Sometimes the brush does appear on the terrain but is always "stuck" and doesn't move.

📎 Attachment: Recording_2025-04-18_141436.mp4

---

**shadowwolf2719** - 2025-04-18 18:19

I'm using v4.4.1.stable.mono.official [49a5bc7b6] with the latest release 1.0.0 version from GitHub on Windows.

---

**aldebaran9487** - 2025-04-18 18:19

Try to disable fsr2 if you have it enabled ? I remember a pb like that but i'm not sure.

---

**shadowwolf2719** - 2025-04-18 18:19

I saw that in the console but figured it was unrelated. Let me try

---

**aldebaran9487** - 2025-04-18 18:20

Ah and reopen the project without fsr2

---

**shadowwolf2719** - 2025-04-18 18:22

Yup, that did it! Thanks! That's so weird. I wonder why FSR would do that. They seem disconnected so I didn't give it a second thought.

---

**aldebaran9487** - 2025-04-18 18:26

Your welcome, yeah i didn't research about why it do that in the editor, but i have see recent talk about a pr on terrain-dev, that allow to resolve issue with taa and fsr2. I'm not sure if the behaviour with fsr2 and editor will be fixed by that. It's maybe other thing.
We could open an issue if none is already open, i didn't have checked.
On my project, setting fsr2 under 1.0 scale even cause crash at game runtime (no pb in editor), but i'm not sure if it's related to terrain3d.

---

**megarapidz** - 2025-04-19 20:09

There is an add region tool. How do I remove regions? CTRL-Z doesnt seem to generally work for me in this editor

📎 Attachment: image.png

---

**tokisangames** - 2025-04-19 20:11

Read the UI docs. Ctrl +z is undo and works fine. Ctrl inverses most operations like add region

---

**megarapidz** - 2025-04-19 20:12

That solved my problem I'm being silly lol, thank you

---

**cepodi2** - 2025-04-19 20:57

Terrain lags alot when i run It in game and start to move around, the fps drops, and then returns to normal Very suddenly

---

**cepodi2** - 2025-04-19 20:57

No props in the map, Just the terrain

---

**cepodi2** - 2025-04-19 20:58

Curiosly tho It doesnt drop fps when i stop moving and Just look around, but as soon as I start moving It drops

---

**cepodi2** - 2025-04-19 20:58

Any idea at How or why this is happening?

---

**tokisangames** - 2025-04-19 21:39

Which renderer?

---

**tokisangames** - 2025-04-19 21:41

This is experienced in our demo scene?

---

**tranquilmarmot** - 2025-04-20 01:45

Running into a weird issue:
- Load scene w/ Terrain3D in it, textures work fine
- Call `.free()` on the scene
- Load the same scene, see a checkered pattern on the terrain

I'm using the default shader, auto shader turned on.

Looking at the debug logs, the first time the scene is loaded I see:
```
Terrain3DAssets#3549:initialize: Initializing assets
Terrain3DAssets#3549:update_texture_list: Reconnecting texture signals
Terrain3DAssets#3549:_update_texture_files: Regenerating albedo texture array
Terrain3DAssets#3549:_update_texture_files: Regenerating normal texture arrays
Terrain3DMaterial#5958:_update_texture_arrays: Updating texture arrays in shader
Terrain3DMaterial#5958:set_show_checkered: Enable set_show_checkered: false
Terrain3DMaterial#5958:_update_shader: Updating shader
Terrain3DMaterial#5958:_generate_shader_code: Generating default shader code
Terrain3DAssets#3549:_update_texture_settings: Updating terrain color and scale arrays
Terrain3DMaterial#5958:_update_texture_arrays: Updating texture arrays in shader
Terrain3DMaterial#5958:set_show_checkered: Enable set_show_checkered: false
Terrain3DMaterial#5958:_update_shader: Updating shader
Terrain3DMaterial#5958:_generate_shader_code: Generating default shader code
```

And the second time, it only prints:
```
Terrain3DAssets#3549:initialize: Initializing assets
Terrain3DAssets#3549:update_texture_list: Reconnecting texture signals
Terrain3DMaterial#5958:_update_texture_arrays: Updating texture arrays in shader
Terrain3DMaterial#5958:set_show_checkered: Enable set_show_checkered: true
Terrain3DMaterial#5958:_update_shader: Updating shader
Terrain3DMaterial#5958:_generate_shader_code: Generating default shader code
Terrain3DMaterial#5958:_update_texture_arrays: Updating texture arrays in shader
```

If I forcefully set `show_checkered = false` after loading the scene the second time, I can see the albedo color of the textures but not the albedo/normal textures.

Let me know if I should open a GitHub issue

---

**tranquilmarmot** - 2025-04-20 01:49

Ah! Setting the material and asset resources for the `Terrain3D` node to be "Local to Scene" fixes it - probably because when the `Terrain3D` node is freed it removes the textures from memory, so they can't be used again by that resource. But if it's local to the scene, then they are re-created when the scene is.

---

**tranquilmarmot** - 2025-04-20 01:55

Looks like un-checking "Free Editor Textures" also does the trick (per https://github.com/TokisanGames/Terrain3D/issues/664)

---

**megarapidz** - 2025-04-20 02:23

`  ERROR: core/variant/variant_utility.cpp:1098 - Terrain3DAssets#4416:_update_texture_files: Texture ID 5 normal format: 17 doesn't match format of first texture: 19. They must be identical. Read Texture Prep in docs.`

My particular texture does not have a roughness image. I tried without and got errors. Then, I tried making a plain white (as I assume the artist wants flat roughness since its not provided) and used that in the texture packer. Combining the two textures in a Terrain3DTextureAsset then throws the above error. Anyone know why?

---

**cepodi2** - 2025-04-20 02:38

Oh sorry for answering too late, its foward+

---

**cepodi2** - 2025-04-20 03:07

Well, im not using the demo scene as my terrain but i suppose I runs the Same problem im my game

---

**tokisangames** - 2025-04-20 07:02

Test our demo and report. Test the components/demobase scene also. Don't assume what's slowing down your scene, test it.

---

**tokisangames** - 2025-04-20 07:03

Disable Rendering/free_editor_textures documented in the release notes

---

**tokisangames** - 2025-04-20 07:05

It literally tells you the problem. You have more than one texture, and the a subsequent one doesn't match the format of the first. Your hardware requires they be the same size, mipmaps, and format. Open them in the inspector and see their format. Read the docs noted.

---

**mkgiga** - 2025-04-20 11:29

I have a game server that chunks my game world's maps and sends per-chunk terrain data to my player's godot client, I was considering using Terrain3D as a solution for my game client, but because my chunks are rather small (16x16 units) I don't know if Terrain3D will like that. What is the smallest chunk size supported by Terrain3D?

---

**xtarsia** - 2025-04-20 11:35

64x64. 
a potential idea - you could still use larger regions, and have the client blit chunks into the region images, and then call update_maps() (or something along these lines)

---

**mkgiga** - 2025-04-20 11:42

do you mean that i'd scale down the chunk after it's built? sorry, i'm having some trouble understanding, and thank you for your patience!

---

**tokisangames** - 2025-04-21 00:30

We don't have chunks. We have regions. Read the introduction at least, if not the system architecture docs. Xtarsia did not say scale. He said blit. Look up that function in Image.

---

**bat117** - 2025-04-21 14:25

hi, quick question -- is there a way to lower the base terrain height or just press down regions -- the raise tool doesnt seem to take negatives.

im using this in complement with a water shader to simulate oceans

---

**tokisangames** - 2025-04-21 14:29

Press CTRL to inverse operations and look at the UI docs.
"Base height" assumes sea level is zero. Modify the shader if you want to change that outside of regions. Edit region data within.

---

**cepodi2** - 2025-04-22 16:50

Ok Ive tested with the demo and my Terrain, with the demo It also happens but with way less frequency compared to the Terrain i made

---

**tokisangames** - 2025-04-22 16:54

What about demobase?

---

**tokisangames** - 2025-04-22 16:55

Lag is usually from shader compilation, which has nothing to do with Terrain3D. Or running out of resources.

---

**tokisangames** - 2025-04-22 16:55

I want you to run a scene that has nothing other than Terrain3D, a light, and a camera.

---

**tokisangames** - 2025-04-22 16:55

Also look at your ram and vram usage vs total

---

**tokisangames** - 2025-04-22 16:58

If it's experienced in our demo base, only use that for testing until the cause is determined. 
Lots and lots of users don't have this issue across many platforms. You need to do more testing and troubleshooting to narrow it down. More frequent updates and communication will help us help you. You haven't shared anything else about your system.

---

**cepodi2** - 2025-04-22 17:02

Alright

---

**reidhannaford** - 2025-04-22 20:46

Hi all - is this behavior normal? When texture painting, I'm getting this really blocky transition line between textures that follows the grid scale of the terrain. I could have sworn it wasn't behaving like this earlier so I'm wondering if I've somehow changed some setting? You can see the airbrush tool doesn't have any effect either. Thank you!

📎 Attachment: 2025-04-22_16-42-51.mp4

---

**xtarsia** - 2025-04-22 20:50

Ive got a decent improvement coming, however your textures look like they have no height data packed in the alpha, which is important for good blending too.

---

**reidhannaford** - 2025-04-22 20:51

What's the improvement you're working on?

---

**reidhannaford** - 2025-04-22 20:52

And re: height data yeah I didn't add normal maps or anything because I'm going for a stylized look and didn't think I needed them. Would this cause issues? I do see in the documentation it says every texture needs both an albedo and a normal map but I figured the default was no normal data

---

**reidhannaford** - 2025-04-22 20:53

*(no text content)*

📎 Attachment: image.png

---

**xtarsia** - 2025-04-22 20:54

if you dont want normal maps at all, then you should make a custom 2x2 normal map and apply it to every texture asset. otherwise the default will consume more vram than needed.

---

**xtarsia** - 2025-04-22 20:55

or 1x1 should be fine too

---

**reidhannaford** - 2025-04-22 20:55

Got it will do. Am I going out of my mind though that earlier today the transitions were smoother? Here's a video from earlier today - the transitions between textures seem smooth

📎 Attachment: 2025-04-22_09-33-36.mp4

---

**reidhannaford** - 2025-04-22 20:56

But now the grid seems much more apparent

📎 Attachment: image.png

---

**tokisangames** - 2025-04-22 20:58

Height data != normal maps. No height map, no height based blending

---

**tokisangames** - 2025-04-22 20:59

Even stylized textures should have heights

---

**tokisangames** - 2025-04-22 21:00

Generate w/ luminance via our channel packer if nothing else

---

**reidhannaford** - 2025-04-22 21:01

Got it - yeah the textures I was using earlier today didn't have any height info either. They were literally just these 128x128 tiny textures I made in blender. Do you think the lack of height info is the culprit here? And the smoother transitions in the video example is just an illusion because the textures have more noise? Or have I done something else wrong in the process

---

**reidhannaford** - 2025-04-22 21:02

I feel like the video above looks much smoother than the bright green/brown image right/

---

**tokisangames** - 2025-04-22 21:03

The default shader uses height blending. If you have no heights, there is no height blending. Only alpha blending. You could disable height blending in the material and see if it helps. If the first video also has no heights, then it doesn't look so blocky because of less contrast and more care put into painting.

---

**reidhannaford** - 2025-04-22 21:04

by the way just for clarity, the textures im using now are literally a solid color. It's solid green, 256x256, and solid brown, 256x256. All the color variation is generated using the noise texture parameters on the terrain3D material

---

**tokisangames** - 2025-04-22 21:04

Attractive blending comes from height textures and proper technique with the tools, Paint and Spray.

---

**reidhannaford** - 2025-04-22 21:08

Right so, forgive my ignorance here, just trying to understand - if my textures are just solid blocks of color - what height info can I or should I be generating from that? My textures are just squares of color without any variation.

And re: the spray, am I doing something wrong here? The spray tool appears to not be doing anything when I use it

📎 Attachment: 2025-04-22_17-06-37.mp4

---

**xtarsia** - 2025-04-22 21:10

yeah with no height data the blend can be a bit delayed

---

**xtarsia** - 2025-04-22 21:12

note that it takes a good couple of seconds to pop through

📎 Attachment: Godot_v4.4.1-stable_win64_I7VlyGvG1a.mp4

---

**reidhannaford** - 2025-04-22 21:15

What debug view do you have on to see the red?

---

**xtarsia** - 2025-04-22 21:15

I just added another texture (as default) and changed the color

---

**reidhannaford** - 2025-04-22 21:17

in this example, your red texture doesn't seem bound by the square vertex grid - the edge of the texture is showing up between the vertices, which is the issue I'm experiencing. My texture seems to either be ON a square, or OFF a square. You're saying this is because I have no height data?

---

**tokisangames** - 2025-04-22 21:17

If you're just painting with colors, you don't even need textures, you could just be using the color map and the color brush.
If its easier to use textures, even 256px is overkill. 
Right now you're using two high contrast colors, on a vertex painter (not pixel painter), with 1m between vertices. It's working as designed. If you won't put in detail into your textures, then you can lower the contrast, be more subtle and larger in your painting, decrease your vertex spacing, and/or use a build from Xtarsia's PR or wait for it to be merged.

---

**reidhannaford** - 2025-04-22 21:20

Here's what happens when I try to paint a color using the color tool - something is definitely going wrong haha

📎 Attachment: 2025-04-22_17-19-40.mp4

---

**xtarsia** - 2025-04-22 21:20

*(no text content)*

📎 Attachment: image.png

---

**reidhannaford** - 2025-04-22 21:21

ah excellent, yup that fixed the color tool (but not the other issue)

Ok thanks guys, I'll just use the color tool for now since I'm only using flat colors anyway

---

**reidhannaford** - 2025-04-22 21:22

Also <@455610038350774273> and <@188054719481118720>  I'm new to the server (as you can see from my flair) so just want to say thanks to you and your team for making this super robust tool for Godot and making it free

---

**reidhannaford** - 2025-04-22 21:50

Sorry one more issue for now - I didn't see this listed in the troubleshooting guide in the docs so wondering if it's something new. When I reload my scene, using `get_tree().reload_current_scene()` - my textures on my terrain disappear and the terrain reverts back to the checkered grid. No errors in the console.

---

**xtarsia** - 2025-04-22 21:52

uncheck "Free Editor Textures"

📎 Attachment: image.png

---

**reidhannaford** - 2025-04-22 21:54

that did it - cheers

---

**tokisangames** - 2025-04-22 22:24

It's on the release notes, where all new things go. I'm just wrapping up a doc update and adding a variety of options to troubleshooting.

---

**.chaonic** - 2025-04-24 14:47

I've gotten back to an older project, upgraded to 4.4 and..
How does one turn the Terrain3D editor on?

📎 Attachment: image.png

---

**.chaonic** - 2025-04-24 14:48

Everywhere I look in videos, it's just there when clicking on the Terrain3D node.

---

**image_not_found** - 2025-04-24 14:49

Is the plugin enabled? What's that error in the output window?

---

**.chaonic** - 2025-04-24 14:53

That's it, it wasn't enabled. 😂

---

**.chaonic** - 2025-04-24 14:57

I removed so much in the upgrade progress, but it didn't occur to me that removing the plugins might have deleted some settings aswell.
Probably would have been wiser to just start a new project and copying over the relevant files and following the installation guides.

---

**moooshroom0** - 2025-04-25 16:16

trying to test out the particles* by downloading the terrain 3d from github but i keep getting these errors and am unsure of what to do.

📎 Attachment: image.png

---

**moooshroom0** - 2025-04-25 16:21

I think its cause im reinstalling it and its trying to run the demo or something along those lines and its conflicting. i think i might figure it out in a moment but just unsure at the moment.

---

**aldebaran9487** - 2025-04-25 16:28

Hey, did you have downloaded a release ? I have had error one time when i was using the addon folder from the github, but that's not that error. I'm still using a custom code for the grass particle, i will try the last released version soon too.

---

**tokisangames** - 2025-04-25 16:31

The first two lines tell you exactly what's wrong. It's expecting to be installed in terrain_3d and you put it in Terrain3D-main

---

**tokisangames** - 2025-04-25 16:31

Also you cannot run source code. You need to build the source into a binary, or use the provided releases per the instructions.

---

**tokisangames** - 2025-04-25 16:32

As for the particles example, you could download that single folder independently and try it. But not with the file paths you've used.

---

**moooshroom0** - 2025-04-25 16:32

ah i see.

---

**moooshroom0** - 2025-04-25 16:33

ive practically only used github to code js etc so i kinda have no clue what im doing with any of it 😅

---

**moooshroom0** - 2025-04-25 16:46

I really appreciate the help!

---

**moooshroom0** - 2025-04-25 16:46

i got it to work.

---

**moooshroom0** - 2025-04-25 16:49

now i just have to figure out how to limit it to a certain texture or something along those lines

---

**kamil2009** - 2025-04-25 19:16

why pleas

📎 Attachment: image.png

---

**tokisangames** - 2025-04-25 19:16

The particle example already does that

---

**tokisangames** - 2025-04-25 19:17

Use full sentences to describe what you did, and what you want

---

**kamil2009** - 2025-04-25 19:18

I have raised black squares that have appeared on my land and I want to remove them

---

**kamil2009** - 2025-04-25 19:18

pleas

---

**tokisangames** - 2025-04-25 19:19

I see that. How did you get it?

---

**kamil2009** - 2025-04-25 19:19

I don't know

---

**tokisangames** - 2025-04-25 19:19

Use the height tool, set height to 0, paint over it

---

**tokisangames** - 2025-04-25 19:20

Use the paint tool, select your grass texture, paint over it

---

**tokisangames** - 2025-04-25 19:20

Watch the tutorial videos

---

**kamil2009** - 2025-04-25 19:22

Sorry, I don't speak English and I have trouble with English videos. I'm using Google Translate. Can you tell me which button to press, please?

---

**kamil2009** - 2025-04-25 19:22

it's not a paint

---

**tokisangames** - 2025-04-25 19:24

I told you. Height and paint. Match the words with the tooltip on the buttons

---

**tokisangames** - 2025-04-25 19:24

I've never seen that from any user, so if you don't know how you made that, no one knows.

---

**tokisangames** - 2025-04-25 19:24

Delete the region and make a new one.

---

**kamil2009** - 2025-04-25 19:25

I don't find any height sory

---

**tokisangames** - 2025-04-25 19:26

There's less than 10 buttons, go down the list. It's like 3-5

---

**kamil2009** - 2025-04-25 19:26

*(no text content)*

📎 Attachment: image.png

---

**kamil2009** - 2025-04-25 19:26

in this buttons?

---

**tokisangames** - 2025-04-25 19:27

Those are not buttons

---

**tokisangames** - 2025-04-25 19:27

Did you enable the plugin?

---

**kamil2009** - 2025-04-25 19:27

yes

---

**tokisangames** - 2025-04-25 19:27

Review the installation instructions

---

**tokisangames** - 2025-04-25 19:28

Then review the user interface docs. It shows you exactly what it looks like

---

**tokisangames** - 2025-04-25 19:29

The buttons are on the left

---

**kamil2009** - 2025-04-25 19:30

I set the height to 0 but it doesn't work. The only thing I can do is add relief on top, but the problem is that it grids the area; there are squares at regular intervals and everywhere.

---

**tokisangames** - 2025-04-25 19:31

Does the height brush work anywhere?

---

**tokisangames** - 2025-04-25 19:32

Relief on top of what?

---

**tokisangames** - 2025-04-25 19:32

Grids the area? There are 3 grids you can turn on. Show pictures or a video.

---

