# terrain-help page 8

*Terrain3D Discord Archive - 1000 messages*

---

**tokisangames** - 2025-03-06 04:59

It's something you need to write.
Why are you asking me about dotnet?

---

**deathmetalthanatos_42378** - 2025-03-06 07:46

https://m.youtube.com/watch?v=TGwHGy-FAbk&pp=ygUadGVycmFpbiAzRCBzcGxhdG1hcHMgZ29kb3Q%3D

because he linked a Computeshader with C# files and I cant see the C# files in Godot

---

**deathmetalthanatos_42378** - 2025-03-06 08:22

ahhh ha ha ha 
you need a special Godot .Net Version 🥸

---

**xtarsia** - 2025-03-06 08:28

That could be done in gdscript, without compute. Processing a 1k by 1k image takes about 0.16s with just GDscript.

---

**xtarsia** - 2025-03-06 08:30

Problem is splatmaps can be configured in multiple ways, especially when splitting more than 4 textures.

---

**tokisangames** - 2025-03-06 08:45

Xtarsia is right. All you need to do is read the data pixel by pixel and translate. The source data (splatmap, indexmap, etc) says this pixel is texture 4, translate that into our control map base id texture 4, or whatever arrangement you've setup. You need to understand your source data, which is done by reading the documentation for your tool. You can also add blending if the source data has varying strengths. This is a one time translation, which is all you need. Making a compute shader is entirely unnecessary unless you are setting up a real-time pipeline.

---

**deathmetalthanatos_42378** - 2025-03-06 09:03

we only have 3- 4 Textures

---

**deathmetalthanatos_42378** - 2025-03-06 09:03

per Splatmap

---

**deathmetalthanatos_42378** - 2025-03-06 09:06

I will try 🙂

---

**laurentsnt** - 2025-03-06 13:24

Hey team, thanks for finishing and merging my LOD PR, is there any work on stuff like octahedral impostors happening somewhere? I don't have time to implement it myself yet, but would love to alpha test if someone is working on it 🙏 

My issue:

I'm trying to use the `get_texture_id` (https://terrain3d.readthedocs.io/en/latest/api/class_terrain3ddata.html#class-terrain3ddata-method-get-texture-id) to implement features like footsteps, but I'm a bit confused with the result on auto slope'd areas:

On a painted area, when blend_value > 0.1 terrain3d renders the overlay texture, which depends on my texture's heightmap, I get it,
but on auto sloped area, even a blend_value > 0.8 renders the base texture.

📎 Attachment: CleanShot_2025-03-06_at_14.07.072x.png

---

**xtarsia** - 2025-03-06 13:37

is that blend value in the inspector the 3rd component of get_texture_id()?

I can verify its working correctly in the demo. Have you modified the auto shader in any way? the function does the same calculation as the shader does to determin the blend value to return if the auto shader is enable for that pixel.

---

**laurentsnt** - 2025-03-06 13:44

the shader_override_enabled is disabled, is there anything else that could mess with that result?

---

**tokisangames** - 2025-03-06 13:46

It should get the same value as the shader. https://github.com/TokisanGames/Terrain3D/blob/main/src/terrain_3d_data.cpp#L730-L748
Though <@188054719481118720> didn't you simplify this in the shader?

---

**tokisangames** - 2025-03-06 13:46

What does the control map blend look like? It should show both manual and auto

---

**laurentsnt** - 2025-03-06 13:53

> is that blend value in the inspector the 3rd component of get_texture_id()?

Yes, fwiw I use: https://gist.github.com/laurentsenta/f31f1570c55713a9776cfbcdc7b4bb92

Here is the blend texture:

📎 Attachment: CleanShot_2025-03-06_at_14.53.092x.png

---

**tokisangames** - 2025-03-06 13:54

The blending between the autoshader and manual are definitely different. The autoshader works per pixel, manual works per vertex.

---

**laurentsnt** - 2025-03-06 13:57

I guess the interpolation would be smoother but that wouldn't cause the same `get_texture_id(pos)` to render differently though?

---

**xtarsia** - 2025-03-06 13:59

the simpler version is in the draft PR, but it actually has the exact same output.

---

**tokisangames** - 2025-03-06 14:00

Does it work properly for you in the demo, and different from your project?

---

**tokisangames** - 2025-03-06 14:01

Our demo does seem fine

---

**tokisangames** - 2025-03-06 14:02

Do you have height textures?

---

**laurentsnt** - 2025-03-06 14:05

Yes, packed with terrain3d's tool

---

**laurentsnt** - 2025-03-06 14:06

They're not super contrasted yet, haven't worked much on it yet, is it possible there's some sort of noise in the manual painting (there is iirc) that doesn't shows in the auto slope?

---

**tokisangames** - 2025-03-06 14:07

And are your height textures reasonable? Grass shouldn't be 1.0 height. It should be around 0, while rocks should vary between .5-1 for peaks and 0-.5 for valleys

---

**tokisangames** - 2025-03-06 14:08

Since the shader height blends, if your heights are unreasonable, they'll need extreme blend values to look normal, which would skew your results.

---

**tokisangames** - 2025-03-06 14:08

Does our demo work as expected for you?

---

**deathmetalthanatos_42378** - 2025-03-06 14:30

Me again^^ 
another question: When I want to use Shaders on the Terrain 3D, is there a Option to make „Moving Lava“?

---

**tokisangames** - 2025-03-06 14:35

Use Waterways for rivers and lava

---

**crackedzedcadre** - 2025-03-06 14:54

Hi, I wanted to ask if theres a way to reduce the terrain quality as I edit. Im working on a laptop and the world is quite large, so editing mountains literally freezes the engine for a few seconds

---

**laurentsnt** - 2025-03-06 14:55

The demo works fine, until I bump the auto slope value, then I get an issue that looks similar to my project's

EDIT: that looks like it, if I reset autoslope to 1 on my project, the `get_texture_id` data looks similar on manual and auto textures

📎 Attachment: CleanShot_2025-03-06_at_15.54.052x.png

---

**tokisangames** - 2025-03-06 14:56

https://terrain3d.readthedocs.io/en/latest/docs/tips.html#performance

---

**tokisangames** - 2025-03-06 14:58

What do you bump it to?

---

**laurentsnt** - 2025-03-06 14:59

in the demo, 3, in my project 1.675

---

**virus_idk** - 2025-03-06 16:20

hey everyone, how do i remove the unwanted parts of terrain in the terrain3d add-on?

---

**virus_idk** - 2025-03-06 16:21

because what i noticed is that ctrl and remove terrain only removes the edited terrain

---

**virus_idk** - 2025-03-06 16:21

not the whole templates or whatever they're called

---

**tokisangames** - 2025-03-06 16:23

If you're not referring to sculpted regions, then change material/background = none

---

**virus_idk** - 2025-03-06 16:24

i'll try that

---

**virus_idk** - 2025-03-06 16:27

i can't seem to be able to create a "none" texture

---

**tokisangames** - 2025-03-06 16:50

I didn't say create a texture. Change the world background

---

**virus_idk** - 2025-03-06 16:51

oh i see

---

**virus_idk** - 2025-03-06 16:55

i did it but it's still there

📎 Attachment: image.png

---

**xtarsia** - 2025-03-06 17:01

*(no text content)*

📎 Attachment: image.png

---

**virus_idk** - 2025-03-06 17:01

okay thank you

---

**elvisish** - 2025-03-06 18:37

is it possible to add a 3-point texture filter to the terrain3d base material?
```swift
uniform sampler2D albedo;
uniform vec2 texSize;

void fragment() {
    vec2 offset = fract(UV*texSize - vec2(0.5));
    offset -= step(1.0, offset.x + offset.y);
    vec4 c0 = texture(albedo, UV - (offset)/texSize);
    vec2 c1off = vec2(offset.x - sign(offset.x), offset.y);
    vec4 c1 = texture(albedo, UV - (c1off)/texSize);
    vec2 c2off = vec2(offset.x, offset.y - sign(offset.y));
    vec4 c2 = texture(albedo, UV - (c2off)/texSize);
    
    ALBEDO = vec4(c0 + abs(offset.x)*(c1-c0) + abs(offset.y)*(c2-c0)).rgb;
}
```
i was having trouble figuring out what the albedo is to pass to this

---

**corvanocta** - 2025-03-06 19:08

Hey all! I'm having trouble importing/installing Terrain3D and not really sure why. It works fine on one project, but doesn't work on the project I want to work with. I have tried both the Asset Library, and downloading from GitHub, but neither seem to work.

Here are the list of errors I have when trying to import using a downloaded version. (I'm on Godot 4.3)

📎 Attachment: Errors.jpg

---

**tokisangames** - 2025-03-06 19:33

What does your console report, starting with the first errors?

---

**tokisangames** - 2025-03-06 19:37

Did you look at the shader that was generated for you when you enabled the override? We sample a texture array, and processing is much more complex. What does this "3-point texture filter" do for you?

---

**corvanocta** - 2025-03-06 19:46

Currently that is everything that is in the console. I am unable to allow the plugin to run, as it does not yet show up on thr list of plug-ins I can activate. This list of errors shows up right after importing (and it tells me it succeeded with no errors)

---

**corvanocta** - 2025-03-06 19:47

I don't see any other areas in any other parts of the editor either, only in the Output log

---

**tokisangames** - 2025-03-06 19:47

That is not your console

---

**tokisangames** - 2025-03-06 19:48

https://terrain3d.readthedocs.io/en/latest/docs/troubleshooting.html#using-the-console

---

**tokisangames** - 2025-03-06 19:49

It's not installed properly if it doesn't show up in your plugin list. Your console probably tells you why, in purple.

---

**corvanocta** - 2025-03-06 19:50

Oh! The console application. Sorry, that ones on me haha.

Let me try reinstalling it with the console open

---

**corvanocta** - 2025-03-06 19:54

So I'm not seeing any errors popping up in my console

---

**tokisangames** - 2025-03-06 19:55

If there's no errors in the console, there won't be any in the output window. So is the plugin in the list so you can enable it?

---

**corvanocta** - 2025-03-06 19:56

I'm getting no errors in the console, but I am getting lots of errors in the output window

---

**tokisangames** - 2025-03-06 19:59

Something else is wrong then. Everything in the output window and more goes in the console.

---

**corvanocta** - 2025-03-06 20:00

Hm... I'll see what I can find. Not sure why it wouldn't be showing up. I'll close it all and try it again

---

**tln1833** - 2025-03-06 20:04

Hello! First time here and first time using Terrain3D in Godot for a college project, I'm having a bit of a trouble with setting the textures.

So, the first texture, rock 30 from the demo is working fine, and I added my own texture using the first tutorial on Tokisan's channel, but when I try to add it to the textures, the whole map goes blank and I can't paint it unless I remove the second texture, is something missing on the settings?

📎 Attachment: image.png

---

**tokisangames** - 2025-03-06 20:05

https://terrain3d.readthedocs.io/en/latest/docs/troubleshooting.html#added-a-texture-now-the-terrain-is-white

---

**tln1833** - 2025-03-06 20:11

Thanks! Amazing work by the way

---

**corvanocta** - 2025-03-06 20:32

So no luck on the console not connecting with the editor, but I did try upgrading to Godot 4.4. It does work by downloading through the AssetLibrary. No idea why it works with that version and not 4.3.

---

**startland** - 2025-03-06 22:51

Hi if someone could please help, I'm having trouble understanding how to procedurally generate (or generate at all during runtime) grass mesh instances (I'm using the SimpleGrassTexture addon, which was referenced a solution in one of Cory's videos). So far I'm already at the point where I can draw them onto the Demo map, but on the "CodeGeneratedDemo" map (which I'm changing the code of just to see if I can achieve basic things so far), I don't have any idea how I'm supposed to spawn them in. I've so far tried add_transforms, add_instances, add_multimesh, and no luck. I was using the terrain.instancer instancer to do this, though I tried making my own too.

I don't really quite understand how everything connects or even where a lot of the arguments are supposed to come from. I'd very much appreciate an example of some code that simply spawns in a mesh instance one has already set up to wrap my head around what is supposed to happen.

I'm new to Godot, new to this plugin and new to working in 3D in general, but I do have quite a bit of experience within Unity, so it could make a lot of sense why this workflow just isn't obvious to me. Thanks for any help, this is a great plugin by the way I'm just struggling!

---

**tokisangames** - 2025-03-06 23:07

SGT is not recommended now that we have our own instancer. Those functions you named are for our instancer and have nothing to do with SGT. You should start by removing SGT.

---

**startland** - 2025-03-06 23:09

Oh? I was just going from the docs at the bottom: https://terrain3d.readthedocs.io/en/stable/docs/instancer.html

---

**tokisangames** - 2025-03-06 23:10

The section "Importing From Other Tools" is for if you have existing data in SGT and want to import it. You don't need it for new data. "Procedural Placement" directs you to the API.

---

**tokisangames** - 2025-03-06 23:11

Next, read ALL of the instancer API page. Add_transforms should be self explanatory. Mesh id, and a transform is all you need.

---

**tokisangames** - 2025-03-06 23:15

Then force update to generate the MMIs.

---

**tokisangames** - 2025-03-06 23:16

You need the meshes setup first. And need to ensure the visible distance is farther than camera distance.

---

**startland** - 2025-03-06 23:30

I've now created a mesh instance of my own the normal way for the grass I think

---

**startland** - 2025-03-06 23:31

I did try add_transforms too but it didn't work for me

---

**startland** - 2025-03-06 23:31

I'm not sure where to do this

---

**startland** - 2025-03-06 23:31

> terrain.force_update_transform()?

---

**tokisangames** - 2025-03-06 23:33

add_transforms is the way. It's how all instances get added.
You can create your own mesh types by code later when you have more experience.

---

**tokisangames** - 2025-03-06 23:33

> terrain.force_update_transform()?
No. GDScript is object oriented and that function is in the instancer class. All of these instancer function calls should be off of `terrain.instancer`, eg `terrain.instancer.force_update_transform()`

---

**startland** - 2025-03-06 23:34

This is the demo scene I added to manually, the top ones are the ones I just created, the smaller ones are from the import sgt script

📎 Attachment: image.png

---

**startland** - 2025-03-06 23:34

they all cull as usual from a distance

---

**startland** - 2025-03-06 23:35

my bad, I'm new to godot, didn't realize that was a common function

---

**tokisangames** - 2025-03-06 23:36

When you look at the API page for the Instancer, all of those functions are called off of the instancer object.

---

**startland** - 2025-03-06 23:36

yeah I got that part

---

**startland** - 2025-03-06 23:37

wait what?

📎 Attachment: image.png

---

**tokisangames** - 2025-03-06 23:37

It's just the wrong name, look at the API for the correct one

---

**startland** - 2025-03-06 23:37

was this what was meant?
> terrain.instancer.force_update_mmis()

---

**startland** - 2025-03-06 23:38

```var transforms: Array[Transform3D]
    transforms.append(Transform3D(Vector3(0, 0, 0), Vector3(0, 0, 0), Vector3(0, 0, 0), Vector3(0, 0, 0)))
    terrain.instancer.add_transforms(1, transforms)
    terrain.instancer.force_update_mmis()```

---

**xtarsia** - 2025-03-06 23:39

if you type the instancer by doing var instancer: Terrain3DInstancer = terrain.instancer

and then do instancer.forc... then autocomplete will work.

---

**startland** - 2025-03-06 23:39

This is my current code I've put directly after the CodeGenerated.gd script in the demo

---

**startland** - 2025-03-06 23:39

it did, I just got confused by the other name, wasn't sure if I was doing something wrong

---

**tokisangames** - 2025-03-06 23:39

Yes, where did you get `terrain.force_update_transform()`?

---

**startland** - 2025-03-06 23:40

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-03-06 23:41

That's not our code.
https://docs.godotengine.org/en/stable/classes/class_node3d.html#class-node3d-method-force-update-transform

---

**tokisangames** - 2025-03-06 23:43

Do you have two mesh types?

---

**startland** - 2025-03-06 23:43

yeah I got that I just mislead myself with the autocomplete and not knowing godot well enough yet

---

**startland** - 2025-03-06 23:44

I'm not even sure what that means, I only care to add 1 type of grass from SimpleGrassTextured

---

**tokisangames** - 2025-03-06 23:45

You don't need SGT. Just work with our instancer

---

**tokisangames** - 2025-03-06 23:45

In the Meshes tab how many entries are there?

---

**startland** - 2025-03-06 23:45

there are 2 right now

---

**startland** - 2025-03-06 23:45

but I'm not using the 1st anymore

---

**elvisish** - 2025-03-06 23:45

its like a diagonal looking billinear effect:

📎 Attachment: image.png

---

**startland** - 2025-03-06 23:45

*(no text content)*

📎 Attachment: image.png

---

**startland** - 2025-03-06 23:46

2nd was just created by dragging some of the files over from SGT

---

**startland** - 2025-03-06 23:46

like the material and texture

---

**tokisangames** - 2025-03-06 23:46

Ok.

> Transform3D(Vector3(0, 0, 0), Vector3(0, 0, 0), Vector3(0, 0, 0), Vector3(0, 0, 0)
This is not a valid Transform3D. At least not what you expect.
https://docs.godotengine.org/en/stable/classes/class_transform3d.html#properties

---

**tokisangames** - 2025-03-06 23:47

Replace it with Transform3D()

---

**startland** - 2025-03-06 23:47

Okay I replaced that, interesting, still isn't spawning anything I can see though but the game runs fine

---

**startland** - 2025-03-06 23:48

should it be spawning at 0, 0, 0 in relation to this?

📎 Attachment: image.png

---

**startland** - 2025-03-06 23:48

that's what I'm trying to get

---

**startland** - 2025-03-06 23:48

I'm in this in case it wasn't already clear, I just changed the texture on the ground of the procedural demo

📎 Attachment: image.png

---

**tokisangames** - 2025-03-06 23:49

Ok, well going through our material generation in the shader 3x is not going to be fast, nor recommended. You'll likely need to make your own shader. Start with our minimum.gdshader and you can write your own texturing. Use our default shader for an understanding of the uniforms that get populated.

---

**tokisangames** - 2025-03-06 23:50

Transform3D() is 0,0,0 at the origin, which is below your terrain. Increase the origin.y to the level of the terrain.

---

**tokisangames** - 2025-03-06 23:50

Or use update_transforms()

---

**startland** - 2025-03-06 23:51

would it place below the terrain if it was below or nah?

---

**startland** - 2025-03-06 23:51

I've been checking beneath the world too

---

**tokisangames** - 2025-03-06 23:52

Transform3D() is at the origin. 0,0,0, regardless of where the terrain is.

---

**tokisangames** - 2025-03-06 23:54

use dump_data() to see if it's there.

---

**tokisangames** - 2025-03-06 23:54

Compare with manually instanced and verify the data is the same.

---

**startland** - 2025-03-06 23:56

This isn't the full dump but its just a lot of this
``` Terrain3DInstancer#1116:dump_data: Region: (-4, -4)
Terrain3DInstancer#1116:dump_data: Region: (-3, -4)
Terrain3DInstancer#1116:dump_data: Region: (-2, -4)
Terrain3DInstancer#1116:dump_data: Region: (-1, -4)
```

---

**startland** - 2025-03-06 23:56

I'm not familiar enough with what its supposed to look like but, looks empty to me

---

**startland** - 2025-03-06 23:57

current code is:
```
    var transforms: Array[Transform3D]
    var transform: Transform3D = Transform3D()
    transform.origin.y = 15
    transforms.append(transform)
    terrain.instancer.add_transforms(1, transforms)
    terrain.instancer.force_update_mmis()
    terrain.instancer.dump_data()```

---

**startland** - 2025-03-07 00:01

yeah, here is a selection from the manually placed data:
```
Terrain3DInstancer#1159:dump_data: Mesh: 0 cell: (13, 23) xforms: 3 colors: 3 modified: false
Terrain3DInstancer#1159:dump_data: Mesh: 0 cell: (12, 23) xforms: 1 colors: 1 modified: false
Terrain3DInstancer#1159:dump_data: Mesh ID: 1
Terrain3DInstancer#1159:dump_data: Mesh: 1 cell: (6, 7) xforms: 25 colors: 25 modified: false
Terrain3DInstancer#1159:dump_data: Mesh: 1 cell: (5, 6) xforms: 2 colors: 2 modified: false
```

---

**startland** - 2025-03-07 00:01

It's got both the meshs I placed down there

---

**tokisangames** - 2025-03-07 00:06

force_update_mmis isn't even needed. Inserting this into codegenerated.gd works perfectly. I'm using the latest build.

```python
    var grass_ma: Terrain3DMeshAsset = create_mesh_asset("Grass") 
    terrain.assets.set_mesh_asset(0, grass_ma)

    # Instance
    var xforms: Array[Transform3D]
    for x in 100:
        for z in 100:
            var pos := Vector3(x, 0, z) * 2
            pos.y = terrain.data.get_height(pos)
            xforms.push_back(Transform3D(Basis(), pos))
    terrain.instancer.add_transforms(0, xforms)

func create_mesh_asset(asset_name: String) -> Terrain3DMeshAsset:
    var ma := Terrain3DMeshAsset.new()
    ma.name = asset_name
    return ma

```

---

**tokisangames** - 2025-03-07 00:07

*(no text content)*

📎 Attachment: 68512862-72F8-4E2A-8E27-59BC78C803A6.png

---

**startland** - 2025-03-07 00:11

ah this code worked for me too

---

**startland** - 2025-03-07 00:12

well, it got some white meshes, I'll work on getting my grass mesh in now

---

**tokisangames** - 2025-03-07 00:27

I just pushed my changes to the demo to main

---

**startland** - 2025-03-07 00:33

okay nice I just got this working

📎 Attachment: image.png

---

**startland** - 2025-03-07 00:34

However it was perhaps due to some major oversights on my part, though maybe the demo should be changed too to account for it

---

**startland** - 2025-03-07 00:34

I never created a terrain3D file in that demo, one was never included as a new one is generated in the script

---

**startland** - 2025-03-07 00:35

and a false assumption on my part was that the meshes/terrain you add were plugin/project wide rather than tied specifically to that terrain3D node?

---

**startland** - 2025-03-07 00:35

or to its data I guess?

---

**startland** - 2025-03-07 00:36

In any case, this line here:
```var terrain := Terrain3D.new()```
Seemed to wipe any previously set up textures or meshes I had made in the other scene where I manually placed the meshes

---

**startland** - 2025-03-07 00:48

Okay so referencing the data that the manual demo's terrain3D also works
```const ASSETS = preload("res://demo/data/assets.tres")
...
func _ready():
...
var terrain := Terrain3D.new()
    terrain.assets = ASSETS
```

---

**startland** - 2025-03-07 00:49

I got like 6 errors I couldn't figure out by using a totally different terrain 3D that existed in the scene prior to runtime instead of loading the data

---

**startland** - 2025-03-07 01:02

Anyway thanks for the help I really appreciate it, I have a much better understanding now. Just a couple things that would've helped in hindsight:
- Error messages for if you're trying to add_transforms a mesh that doesn't exist, perhaps even a "Are you sure you're using the correct Terrain3D data?"
- Something in the procedural demo saying if you're wanting to add objects like grass, foliage etc. that you'll need to create the meshes in script or set the data to a terrain3D you've already made, something like this.

Unless I'm still missing something, but that would've fixed my issues anyways but thank you!

---

**tokisangames** - 2025-03-07 02:21

I think it really comes down to lack of experience in Godot and GDScript. Procedural generation using a plugin, language, and engine you're unfamiliar with isn't easy. Expectations of instant success when you have no "intuitive" basis are unreasonable.

---

**startland** - 2025-03-07 02:23

You're definitely right about that, but if I'm correct in that attempting to spawn a mesh that doesn't exist doesn't give an error or a warning... I think it probably should just personally

---

**startland** - 2025-03-07 02:24

Its certainly a lot harder to know what is wrong if I'm unfamiliar but its even harder if my guesses are between general unfamiliarity, the addon, and the addon's configuration

---

**startland** - 2025-03-07 02:27

And I wasn't really up to the stage of procedural gen but just spawning anything at all. Even being able to do this was my own benchmark to see if this kind of thing would be achievable for me at all

---

**startland** - 2025-03-07 02:30

And I think that anyone trying to use that demo to see what procedural gen is like likely also wants to spawn things on top of it, which is direct tied in with terrain3D itself. I'm not saying it should have some full explanation of procedural generation or noise mapping or something like that, but small examples help a lot for basics like your grid spawning

---

**startland** - 2025-03-07 02:32

But yeah you're totally right that having more experience with these things would've let me isolate the problem a lot quicker, I just wasn't sure what to look at until your example made me sure that the problem had to be with the mesh config itself which made me investigate the terrain3D file

---

**hidan5373** - 2025-03-07 03:57

Is there a way to make this shader having unfiltered textures?

---

**hidan5373** - 2025-03-07 03:57

*(no text content)*

📎 Attachment: image.png

---

**hidan5373** - 2025-03-07 03:58

I want colour to be sharp and not blur on neighbour polygons

---

**tokisangames** - 2025-03-07 06:19

Yeah, I'll look at Add_transforms and see about messages if the mesh asset ID isn't there. That's a good idea.

---

**tokisangames** - 2025-03-07 06:20

Change the shader sampler for the colormap to nearest filtering.

---

**startland** - 2025-03-07 06:20

Nice! Thanks for considering it

---

**elvisish** - 2025-03-07 07:50

Thanks, so it’s not quite as simple as applying an effect to the final albedo? If you wanted to add a PSX vertex snapping or affine rendering effect (I don’t, but) you’d have to process every individual part of the shader texturing seperately?

---

**tokisangames** - 2025-03-07 08:22

Your code samples the albedo texture 3x. That's expensive. Our shader accumulates albedo and is quite expensive, but considering what it does and the work we've done on it, it's pretty amazing. Going through all of that 3x is foolishly expensive. Your best bet is to come up and an alternative algorithm you can apply to our final albedo that gives you a similar result. You'll have to figure that out. Alternatively you could apply effects to where we sample the textures. Or both. But you don't want to go through all of our lookups and processing 3x.

---

**elvisish** - 2025-03-07 08:26

this might not be much better but:
```swift
vec4 n64BilinearFilter(vec4 vtx_color, vec2 texcoord) {
    ivec2 tex_size = textureSize(albedoTex, 0);
    float Texture_X = float(tex_size.x);
    float Texture_Y = float(tex_size.y);

    vec2 tex_pix_a = vec2(1.0/Texture_X,0.0);
    vec2 tex_pix_b = vec2(0.0,1.0/Texture_Y);
    vec2 tex_pix_c = vec2(tex_pix_a.x,tex_pix_b.y);
    vec2 half_tex = vec2(tex_pix_a.x*0.5,tex_pix_b.y*0.5);
    vec2 UVCentered = texcoord - half_tex;

    vec4 diffuseColor = texture(albedoTex,UVCentered);
    vec4 sample_a = texture(albedoTex,UVCentered+tex_pix_a);
    vec4 sample_b = texture(albedoTex,UVCentered+tex_pix_b);
    vec4 sample_c = texture(albedoTex,UVCentered+tex_pix_c);

    float interp_x = modf(UVCentered.x * Texture_X, Texture_X);
    float interp_y = modf(UVCentered.y * Texture_Y, Texture_Y);

    if (UVCentered.x < 0.0)
    {
        interp_x = 1.0-interp_x*(-1.0);
    }
    if (UVCentered.y < 0.0)
    {
        interp_y = 1.0-interp_y*(-1.0);
    }

    diffuseColor = (diffuseColor + interp_x * (sample_a - diffuseColor) + interp_y * (sample_b - diffuseColor))*(1.0-step(1.0, interp_x + interp_y));
    diffuseColor += (sample_c + (1.0-interp_x) * (sample_b - sample_c) + (1.0-interp_y) * (sample_a - sample_c))*step(1.0, interp_x + interp_y);

    return diffuseColor * vtx_color;
}
```

---

**elvisish** - 2025-03-07 08:27

i was trying to figure out which part of the shader to apply this filter to, i'm guessing the final accumulated albedo?

---

**tokisangames** - 2025-03-07 08:29

No, that one samples 4x! Lol. Texture() is a texture lookup.

---

**xtarsia** - 2025-03-07 08:46

Setting the uniform filtering to nearest should help, if the effect still holds up with the gpu internal bilinear blend disabled it should recoup some performance

---

**xtarsia** - 2025-03-07 08:47

If that does save some perf, I would implement a preprocessor override for textureGrad()

---

**elvisish** - 2025-03-07 09:04

i think the textures have to be nearest for it to look correct, so that might work

---

**startland** - 2025-03-07 09:31

I don't need any help on this but it wasn't clear to me that you can't paint textures unless they've been interacted with by another tool. I'm not sure if this intended behaviour or a bug, but it means when you first put in a Terrain3D and you have a flat plane, it can't be painted on.

---

**startland** - 2025-03-07 09:34

I do have a question though related to this, how do I paint textures through script? I couldn't quite understand if this page talked about it but I don't see any functions so https://terrain3d.readthedocs.io/en/latest/docs/texture_painting.html

---

**tokisangames** - 2025-03-07 09:42

You absolutely can paint on the ground without interaction by another tool. You of course need a region to store the data in.

---

**tokisangames** - 2025-03-07 09:42

Read the data api which had several functions that can do it like set_pixel, Set_control_base_id, set_control_auto, etc

---

**startland** - 2025-03-07 09:45

right, with the add region button, I just got confused because the landscape shifting tools automatically create regions but the paint ones (and the ones below those) don't

---

**startland** - 2025-03-07 09:46

there's also some strange behaviour I managed to get from copying a terrain3D to a different scene and it makes it look like the outer regions have been changed but in reality they're fakes, and they cannot be painted on and when a new region is created, they revert to being flat

📎 Attachment: image.png

---

**tokisangames** - 2025-03-07 09:46

Or by script. Everything you can do in the editor you can do via script, as we've already demonstrated.

---

**startland** - 2025-03-07 09:47

which originally made me wonder what was going on, because they seemed painted

---

**tokisangames** - 2025-03-07 09:48

Yes? That's normal and discussed at length in my videos and documentation. Regions have zero heights. When you add one to an area covered by world background noise, it goes to sea level so you can sculpt.

---

**startland** - 2025-03-07 09:50

I must've missed that then

---

**startland** - 2025-03-07 09:51

the part about the background noise

---

**startland** - 2025-03-07 09:53

was the world background noise added by you just for the demo? Or is it a setting? Because on new terrain3D I just have a flat world which is what made me confused

---

**tokisangames** - 2025-03-07 09:55

Material/world background. Have you watched all three of my videos? This is discussed in #2.

---

**startland** - 2025-03-07 09:58

I did watch them all yesterday, and am watching again now, but there was a lot covered

---

**startland** - 2025-03-07 09:59

Ah I got to it

---

**startland** - 2025-03-07 10:01

Okay that makes sense, I must've not committed it to memory very well 😓

---

**elvisish** - 2025-03-07 10:08

so ```swift
ALBEDO = albedo_height.rgb * color_map.rgb * macrov;
``` is the end of the shader where the texture is put together?

---

**elvisish** - 2025-03-07 10:09

but there's also `albedo_ht.rgb *= _texture_color_array[out_mat.base].rgb;`

---

**tokisangames** - 2025-03-07 10:15

ALBEDO is where we send our calculated value to the engine to be sent to the GPU. Same with the other capitalized words. This is a Godot shader, so you can read all of their tutorials and documentation to learn about it.

---

**kamazs** - 2025-03-07 10:57

What are the best practices of using Terrain3D with Godot navigation system (_NavigationRegion3D_ etc.)?  

Paint as little as possible? Small roaming areas for NPCs is a solution but not sure how to deal with NPCs that have long routes or companions. Anyone has real-life experience with their games to share?

---

**tokisangames** - 2025-03-07 11:01

Idk, we haven't used it much with our enemies. Use AABBs and define smaller regions. Route generation is slow so use sight and intelligence first, and nav as a fallback.

---

**kamazs** - 2025-03-07 11:08

Hm. Good point. Thanks!

---

**crackedzedcadre** - 2025-03-07 12:25

Hi, I'm having trouble with my normal maps.

📎 Attachment: Screenshot_55.png

---

**crackedzedcadre** - 2025-03-07 12:26

I followed all the steps to package it properly, but it still makes the terrain turn white.

---

**crackedzedcadre** - 2025-03-07 12:40

<@455610038350774273> help please 😭

---

**elvisish** - 2025-03-07 12:56

Yeah, I meant the multiplied values that go into that, I tried processing them with the filter but it was the wrong vec type

---

**xtarsia** - 2025-03-07 13:02

Triple check the texture formats and sizes, all albedo must be identical, and all normal must be identical.

---

**tokisangames** - 2025-03-07 13:23

https://terrain3d.readthedocs.io/en/latest/docs/troubleshooting.html#added-a-texture-now-the-terrain-is-white

---

**crackedzedcadre** - 2025-03-07 13:24

I referred to this, and Im beginning to suspect theres a problem with the texture itself

---

**crackedzedcadre** - 2025-03-07 13:24

I exported from GIMP as 512x512 for both textures as DDS

---

**crackedzedcadre** - 2025-03-07 13:24

I made sure to generate mipmaps and they have the same compression settings

---

**tokisangames** - 2025-03-07 13:24

Albedo is vec3. That's basic information you can learn in the Godot shader docs.

In addition to customizing or shader you can start with minimum.gdshader and do so the texturing yourself using these shaders you shared.

---

**tokisangames** - 2025-03-07 13:25

The same as the first texture in the list? I'm sure not. Your console probably tells you they're different. The inspector can reveal the exact size and format.

---

**crackedzedcadre** - 2025-03-07 13:28

Ok, so the normal texture says it’s 512x512 DXT5 RGBA8 with 9 mipmaps taking 341.3 KB.

The albedo texture is 512x512 with DXT5 RGBA8 with 9 mipmaps taking 341.3 KB as well

---

**xtarsia** - 2025-03-07 13:29

And the other texture id albedo and normal?

---

**tokisangames** - 2025-03-07 13:29

Two texture assets in the dock. That's 4 files.

---

**crackedzedcadre** - 2025-03-07 13:31

Yep, however, I haven’t set a normal for the grass yet as Im trying to figure out whats wrong with the dirt

---

**crackedzedcadre** - 2025-03-07 13:32

*(no text content)*

📎 Attachment: Screenshot_56.png

---

**crackedzedcadre** - 2025-03-07 13:32

I ended up switching back to the default normal

---

**xtarsia** - 2025-03-07 13:32

Either the albedo of the dirt, doesn't have the same size/format as the grass,

Or, the normal of dirt doesn't have the same size/format as the grass.

---

**tokisangames** - 2025-03-07 13:32

1024 != 512

---

**crackedzedcadre** - 2025-03-07 13:33

Yeah, for some reason the 1024x1024 one works

---

**tokisangames** - 2025-03-07 13:34

Probably because your second texture id also is 1024. When you put in 512 it doesn't match and breaks.

---

**tokisangames** - 2025-03-07 13:36

The yellow triangle next to Terrain3D here also tells you they don't match when you click on it.

---

**crackedzedcadre** - 2025-03-07 13:37

This is what happens when I try to use the 512x512 normal map

📎 Attachment: Screenshot_57.png

---

**crackedzedcadre** - 2025-03-07 13:37

I didnt change the albedo texture at all, just the normals

---

**crackedzedcadre** - 2025-03-07 13:38

The albedo texture remains as is at 512x512

---

**crackedzedcadre** - 2025-03-07 13:38

But for some reason, the 1024x1024 normal map works

---

**crackedzedcadre** - 2025-03-07 13:40

To be 100% sure, this is how the files show up in the inspector

📎 Attachment: image.png

---

**crackedzedcadre** - 2025-03-07 13:41

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-03-07 13:43

Show us exactly this for your grass textures

---

**crackedzedcadre** - 2025-03-07 13:52

I havent set a normal for the grass yet

---

**crackedzedcadre** - 2025-03-07 13:52

Wait

---

**crackedzedcadre** - 2025-03-07 13:52

I see what you mean

---

**crackedzedcadre** - 2025-03-07 13:53

Let me setup the normal for the grass texture and I'll get back to you

---

**crackedzedcadre** - 2025-03-07 13:58

<@455610038350774273> its worked!

---

**crackedzedcadre** - 2025-03-07 13:58

*(no text content)*

📎 Attachment: image.png

---

**crackedzedcadre** - 2025-03-07 13:58

<@188054719481118720> thank you too!

---

**startland** - 2025-03-07 14:01

Getting consistent crashes when adding a normal texture to the packing tool, using this texture: https://ambientcg.com/view?id=Ground081
I made a different one with grass earlier today and it worked fine so not sure what is going on with it

---

**startland** - 2025-03-07 14:04

Worked fine on a different texture I've tried just now

---

**startland** - 2025-03-07 14:06

I'm not particularly interested in the texture btw, I just thought I'd mention it not working as a potential bug report

---

**tokisangames** - 2025-03-07 14:06

There are probably 20 textures there, different PBR maps, different sizes, different formats. Which one did you crash on?
What does your console say when you crash? Which version of Godot. I'm sure it's a godot issue as we don't read the texture itself.

---

**startland** - 2025-03-07 14:07

Godot 4.4, the PNG 1K pack using Ground081_1K-PNG_NormalGL.png

---

**startland** - 2025-03-07 14:07

There's no hard crash it just stalls the window and I have to close the whole program

---

**tokisangames** - 2025-03-07 14:08

You can pack only albedo or only normals. Can you narrow it down?

---

**startland** - 2025-03-07 14:08

I dragged in those first and then went for the 3rd right away (which crashes/stalls it), I'll try packing those though if you'd like

---

**startland** - 2025-03-07 14:09

albedo + height works fine

---

**startland** - 2025-03-07 14:10

tried dragging in roughness also, that worked

---

**startland** - 2025-03-07 14:10

but again, dragging into normal stall/crashes it

---

**tokisangames** - 2025-03-07 14:10

What if you double click the file so it opens in the inspector?

---

**tokisangames** - 2025-03-07 14:10

Are you sure it's a valid file that was downloaded properly? Can you open it in another app?

---

**startland** - 2025-03-07 14:11

*(no text content)*

📎 Attachment: image.png

---

**startland** - 2025-03-07 14:11

I'll check

---

**startland** - 2025-03-07 14:11

yeah opens in a file viewer I'll check in godot now

---

**startland** - 2025-03-07 14:12

Seems to open fine in godot

---

**startland** - 2025-03-07 14:12

its showing in the inspector

---

**startland** - 2025-03-07 14:13

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-03-07 14:13

Non-square and no mipmaps are probably not what you want

---

**tokisangames** - 2025-03-07 14:14

I'll look at the file on my system and see if I can reproduce

---

**startland** - 2025-03-07 14:14

Oh yeah its not a square... weird

---

**startland** - 2025-03-07 14:14

the others aren't either but

---

**startland** - 2025-03-07 14:17

Not a big priority for me since I was just grabbing a random texture but hopefully this helps fix something

---

**startland** - 2025-03-07 14:20

I tried cropping to 512 and it could be added

---

**startland** - 2025-03-07 14:21

packed with the roughness too

---

**startland** - 2025-03-07 14:26

texture works too looks like, though at 512

📎 Attachment: image.png

---

**startland** - 2025-03-07 14:28

I'm about to head off in case you needed anything else about this from me

---

**hidan5373** - 2025-03-07 15:00

you mean like this?
```uniform highp sampler2DArray _color_maps : source_color, filter_nearest_mipmap_anisotropic, repeat_disable;```

---

**tokisangames** - 2025-03-07 15:01

Yes

---

**hidan5373** - 2025-03-07 15:01

Its already set like that by default

---

**tokisangames** - 2025-03-07 15:03

OK, that's what you asked for isn't it, unfiltered color map?

---

**hidan5373** - 2025-03-07 15:06

Yeah I want it to be unfiltered

---

**tokisangames** - 2025-03-07 17:14

Godot is "hung" because your console is reporting 10s of thousands of errors. Non-square textures triggered a bug. Will be fixed in main shortly. Thanks for the report.

You should always be running Godot with the console open, as discussed [here](https://terrain3d.readthedocs.io/en/stable/docs/troubleshooting.html#using-the-console).

---

**tokisangames** - 2025-03-07 17:15

add_transforms already gives an error if the mesh id is out of bounds. You probably missed it because you weren't looking at your console.
`ERROR: Terrain3DInstancer#0124:add_transforms: Mesh ID out of range: 3, valid: 0 to 0`

---

**pawelpudlik** - 2025-03-07 19:08

hiya, I'm getting a bunch of leaks when exiting in 4.4 - deleting Terrain3D from my main scene reduces leakage to 0. is this a known issue, will it be fixed in coming update?

📎 Attachment: image.png

---

**pawelpudlik** - 2025-03-07 19:24

as for the 1st error - I changed the physics back to default and the error remains the same (with GodotShape3D)

---

**pawelpudlik** - 2025-03-07 19:28

as for the other errors - I deleted all trees which were Meshes I added to the terrain using the plugin, and now only the 1st error with 6 RID allocations of something physics related remains - EDIT: disabling collision in editor gets rid of that error

---

**pawelpudlik** - 2025-03-07 19:44

OK: conclusion: all tree models I've tried (scene files) for painting cause leakage (game takes a few long seconds to close), cardboard textures cause no leakage. leaked RID allocations always remain with collision enabled.

---

**smolcatwizard** - 2025-03-07 20:54

The docs say terrain supports 4.2 and 4.3 but i've been messing with it in 4.4 without any problems for now, is it not recommended to use 4.4 for terrain 3d ?

---

**deathmetalthanatos_42378** - 2025-03-07 21:09

Ok, I dont get it... I just have to convert my Splatmap to a 32bit_int.exr right?

---

**deathmetalthanatos_42378** - 2025-03-07 21:24

I always get this

📎 Attachment: Bildschirmfoto_vom_2025-03-07_22-24-32.png

---

**deathmetalthanatos_42378** - 2025-03-07 21:25

*(no text content)*

📎 Attachment: Bildschirmfoto_vom_2025-03-07_22-25-10.png

---

**deathmetalthanatos_42378** - 2025-03-07 22:06

Fuck Im so close!

---

**xtarsia** - 2025-03-07 22:07

are you encoding the control map correctly?

---

**deathmetalthanatos_42378** - 2025-03-07 22:10

*(no text content)*

📎 Attachment: Bildschirmfoto_vom_2025-03-07_23-10-12.png

---

**deathmetalthanatos_42378** - 2025-03-07 22:10

have this result now

---

**deathmetalthanatos_42378** - 2025-03-07 22:10

but I cant use my Textures

---

**deathmetalthanatos_42378** - 2025-03-07 22:11

My Textures are "to Large" ? maybe?

---

**deathmetalthanatos_42378** - 2025-03-07 22:12

I created a Control map and used a PNG to mere it and export it again as a exr

---

**xtarsia** - 2025-03-07 22:12

you can use the debug views to see what data you wrote to that controlmap

---

**deathmetalthanatos_42378** - 2025-03-07 22:13

*merge

---

**deathmetalthanatos_42378** - 2025-03-07 22:13

ahh correct

---

**deathmetalthanatos_42378** - 2025-03-07 22:15

ehhmm where was the debug view? O.o

---

**xtarsia** - 2025-03-07 22:15

at the bottom of material

---

**startland** - 2025-03-07 22:21

Ah I see, thanks for the tip

---

**startland** - 2025-03-07 22:21

this too

---

**deathmetalthanatos_42378** - 2025-03-07 22:21

looks a bit wrong

📎 Attachment: Bildschirmfoto_vom_2025-03-07_23-21-18.png

---

**deathmetalthanatos_42378** - 2025-03-07 22:22

ignore the red text ... this is from last run

---

**deathmetalthanatos_42378** - 2025-03-07 22:25

*(no text content)*

📎 Attachment: Splatmapper.gd

---

**tokisangames** - 2025-03-07 22:32

I don't know why you're reading the control map, you only need to read the splatmap. You don't need to write an exr file and then reimport it either. Just read the splatmap and write the data directly to a Terrain3DData instance using set_control_base_id or set_pixel.

---

**tokisangames** - 2025-03-07 22:33

4.4 is fine

---

**tokisangames** - 2025-03-07 22:39

Which version of Terrain3D? Only test the latest from main, which has a fix for some instancer leaks. The others haven't been identified yet. They could be in Terrain3D, or godot-cpp, or Godot.

---

**tokisangames** - 2025-03-07 22:54

This is the same issue as the others, and my response is the same:
* This has 3 texture() lookups. It's not going to work as is in either location. 
* You can use minimum.gdshader instead of the default shader, and then you can put in your own texturing like this function.

`vec2 uv` are coordinates, the return is an RGBA color.

---

**xtarsia** - 2025-03-07 23:05

yeah its not awesome, about a 170fps hit.

```glsl
vec4 albedoTextureFiltered(sampler2DArray samp, vec3 uvl, vec2 ddx, vec2 ddy)
    {
        vec2 albedo_texture_size = vec2(1024, 1024);

        vec2 tex_pix_a = vec2(1.0 / albedo_texture_size.x, 0.0);
        vec2 tex_pix_b = vec2(0.0, 1.0 / albedo_texture_size.y);
        vec2 tex_pix_c = vec2(tex_pix_a.x,tex_pix_b.y);
        vec2 half_tex = vec2(tex_pix_a.x * 0.5, tex_pix_b.y * 0.5);
        vec2 uv_centered = uvl.xy - half_tex;

        vec4 diffuse_color = textureGrad(samp, vec3(uv_centered, uvl.z), ddx, ddy);
        vec4 sample_a = textureGrad(samp, vec3(uv_centered + tex_pix_a, uvl.z), ddx, ddy);
        vec4 sample_b = textureGrad(samp, vec3(uv_centered + tex_pix_b, uvl.z), ddx, ddy);
        vec4 sample_c = textureGrad(samp, vec3(uv_centered + tex_pix_c, uvl.z), ddx, ddy);

        float interp_x = modf(uv_centered.x * albedo_texture_size.x, albedo_texture_size.x);
        float interp_y = modf(uv_centered.y * albedo_texture_size.y, albedo_texture_size.y);

        if (uv_centered.x < 0.0)
        {
            interp_x = 1.0 - interp_x * -1.0;
        }
        if (uv_centered.y < 0.0)
        {
            interp_y = 1.0 - interp_y * -1.0;
        }

        diffuse_color = (
            diffuse_color +
            interp_x * (sample_a - diffuse_color) +
            interp_y * (sample_b - diffuse_color)) *
            (1.0 - step(1.0, interp_x + interp_y));

        diffuse_color += (
            (sample_c + (1.0 - interp_x) * (sample_b - sample_c) +
            (1.0 - interp_y) * (sample_a - sample_c)) *
            step(1.0, interp_x + interp_y));

        return diffuse_color;
    }
#define textureGrad(s, u, dx, dy) albedoTextureFiltered(s, u, dx, dy);
```
stick that near the top of the shader.

4x texture taps is a lot.

---

**xtarsia** - 2025-03-07 23:07

only really visible when zoomed in, but i suppose with very small texture sizes, like 128x128 it would be more noticeable

📎 Attachment: image.png

---

**.cinderos** - 2025-03-07 23:22

hello all! don't want to disturb you too much, but I can't figure out how impactful is using noise of terrain3D node as a background only (using holes)

---

**xtarsia** - 2025-03-07 23:23

just trying to see if this would work

---

**elvisish** - 2025-03-07 23:43

Thanks, that’s at the top of minimum shader?

---

**elvisish** - 2025-03-07 23:45

I’m curious why this is so much less performant than the built in linear filtering, which samples four times?

---

**pawelpudlik** - 2025-03-07 23:51

I was using 0.9.3a from the AssetLib, but I just compiled the newest one 1.0.0-dev from main... and pretty much all the errors related to leaks are gone - EXCEPT for the error relating to 6 leaked RID allocations of "P11JoltShape", which now turned into 32 leaked RID allocations. Something to do with collisions.
Edit: Changing collision mode to full/game lowers the leak to only just 2 RID allocations now in 1.0.0-dev

---

**hidan5373** - 2025-03-08 00:15

Soo any way to remove that Blending from terrain textures?

---

**parkerthedripper** - 2025-03-08 01:27

I have an issue, when i have no data directory and run the scene the game doesnt crash but obviously it wont work correctly without a data directory, but when i add one the game crashes.

---

**parkerthedripper** - 2025-03-08 01:30

so

---

**parkerthedripper** - 2025-03-08 01:30

nevermind

---

**parkerthedripper** - 2025-03-08 01:30

im a little stupid and new to the plugin

---

**parkerthedripper** - 2025-03-08 01:31

(i had to add a region) 😭

---

**parkerthedripper** - 2025-03-08 01:31

sorry guys

---

**vhsotter** - 2025-03-08 01:32

Don't be so hard on yourself. You're not stupid, you just don't have a ton of experience with the addon yet. We all started somewhere. :)

---

**parkerthedripper** - 2025-03-08 01:37

thanks haha i appreciate it : D

---

**tokisangames** - 2025-03-08 02:04

There might be a leak in how we allocate and free our collision shapes.

---

**tokisangames** - 2025-03-08 02:08

You can also set the albedo, normal textures to nearest. But I'm not sure how you created that picture you posted or what you really want. Please restate your original question and clarify what you want to achieve. An example pic of your goal would be helpful.

---

**hidan5373** - 2025-03-08 02:12

I want something like it is in Astroneer where map colours end's where polygones does

📎 Attachment: 20190201174601_1-630x354.png

---

**hidan5373** - 2025-03-08 02:13

but currently when I paint texture, it blends colours for a smooth transition between textures and i don't want that

---

**hidan5373** - 2025-03-08 02:15

Like in here, colour ends on vertexes and then smooths on another polygon

---

**hidan5373** - 2025-03-08 02:15

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-03-08 02:20

You'll need to modify the shader to remove the blending of 4 vertices, and pick only one vertex for the albedo color. You might also use the lowpoly_colormap shader, as you don't need textures at all, just color.

---

**hidan5373** - 2025-03-08 02:25

Soo reduce blending vertexes to one then

---

**paidview** - 2025-03-08 02:34

I should mention that the Moles are human sized, as it's anthropomorphic forest creatures... so the mesh may be fine 😄 haha. Good tip on the snow tracks though, that's a good inverse analogue.

---

**hidan5373** - 2025-03-08 02:52

Yeah I suck at shaders🥲

---

**paidview** - 2025-03-08 03:03

Do you have any references up for how you recommend stiching procedural world chunks together?

---

**paidview** - 2025-03-08 03:04

Sorry if I missed them, I'm looking but haven't found them yet.

---

**tangypop** - 2025-03-08 04:46

This might have been an intentional change in the Terrain3D API as part of LOD changes, but just in case it's not I figured I'd post here. Changing the mesh via Terrain3D.assets.mesh_list[i].scene_file causes the selected shader material to be removed. In my graphics options I have max quality levels for different foliage types (left image is before changing in options and right is after). With 0.9.3a it kept the shader material after toggling, but with main-godot4.4 it drops it. In any case, I'd like to say the build process for Terrain3D is well documented. I haven't touched C++ for a few decades and was able to get Terrain3D to build within an hour or so.

📎 Attachment: image.png

---

**Deleted User** - 2025-03-08 06:27

I have added another texture onto my terrain and now everything is all grayed out. Is there a solution for this?

📎 Attachment: Screenshot_309.png

---

**tokisangames** - 2025-03-08 07:02

This is a clipmap terrain not a chunked terrain as discussed in our introduction and system architecture documents. You don't stitch them together. You use one system with multiple regions and use the infrastructure we've already built for you.

---

**tokisangames** - 2025-03-08 07:05

https://terrain3d.readthedocs.io/en/stable/docs/troubleshooting.html#added-a-texture-now-the-terrain-is-white

---

**tokisangames** - 2025-03-08 08:11

You mean the override material is removed, because it uses the material in the scene file you added. Add your material to the scene in the mesh or material override slot(s). Our override uses the geometry override now, which you often don't want for a more complex mesh, especially if there are multiple material slots.

---

**tokisangames** - 2025-03-08 08:20

You can file an issue so it can be tracked. Editor and Collision modes work differently, the former makes nodes the latter makes RIDs, so both need to be evaluated for leaks. Then you or someone can look through the code in Terrain3DCollision.cpp to identify the leak(s). eg. See issue 630 and the fix.

---

**pawelpudlik** - 2025-03-08 11:24

would totally love to help, but I'm just an amateur, who doesn't even know how to clone git and stuff 🤪  I only just embarked on deep waters of solo game dev from scratch. I will try to file the issue

---

**fr3nkd** - 2025-03-08 12:05

super simple question for you guys today: I forgot how to center my imported height map on the Z axis

📎 Attachment: image.png

---

**tokisangames** - 2025-03-08 12:55

Use the Y field for Z

---

**fr3nkd** - 2025-03-08 12:56

https://tenor.com/view/confused-confused-math-gif-26401692

---

**creationsmarko** - 2025-03-08 14:46

How do I hide the region terrain that isnt allocated (im using 2 region terrains and am worried about the other ones being rendered when not needed)

---

**tangypop** - 2025-03-08 15:57

In your Terrain3DMaterial you can set World Background to None.

📎 Attachment: image.png

---

**creationsmarko** - 2025-03-08 16:23

You are a lifesaver! Big thanks

---

**drbellubins** - 2025-03-08 17:09

How do I get Terrain3d node in C#?

---

**drbellubins** - 2025-03-08 17:09

https://i.imgur.com/4QLmK2B.png

---

**drbellubins** - 2025-03-08 17:10

I see no namespace to add

---

**drbellubins** - 2025-03-08 17:28

Nevermind, I just used this: https://github.com/Delsin-Yu/CSharp-Wrapper-Generator-for-GDExtension

---

**drbellubins** - 2025-03-08 17:28

The default C# experience in Terrain3d is ass 😛

---

**drbellubins** - 2025-03-08 17:31

Nevermind again... it's busted in 4.4 😭

---

**drbellubins** - 2025-03-08 17:39

Man the api in C# (or lack thereof) is borderline unusable... Might as well not exist. I might use the generated api from this as a baseline. Lot's of errors

---

**tokisangames** - 2025-03-08 18:37

This is your choice for now unless you build a wrapper or get an automatic wrapper generator working. Plenty of other devs are using this without issue. An automatic generated wrapper would be great and needs a solution contributed from a C# dev.
https://terrain3d.readthedocs.io/en/stable/docs/programming_languages.html

---

**drbellubins** - 2025-03-08 18:39

My terrain does not have any collision whatsoever. I set the camera through script, I set it to in-editor (which has a warning saying it generated, no gizmos showing it actually did), both my player and a cube go through it.

---

**tokisangames** - 2025-03-08 18:41

Does it work in our demo?

---

**tokisangames** - 2025-03-08 18:42

Which version?

---

**drbellubins** - 2025-03-08 18:42

Wait a second, does WorldBackground contribute to collisions?

---

**tokisangames** - 2025-03-08 18:42

No

---

**drbellubins** - 2025-03-08 18:42

welp there's my problem lol

---

**tokisangames** - 2025-03-08 18:42

Docs explain this. Yes

---

**ozysandlias** - 2025-03-08 21:36

This is probably a long shot but is there any way to export the terrain map so I can use it as a standalone mesh? Just spent a few hours detailing a map for a game jam due monday and found out I can't run it in browser 🥺

---

**vhsotter** - 2025-03-08 22:22

Yeah, if you select the terrain, go to the Terrain3D menu, select Bake ArrayMesh, choose the appropriate LOD you want (minding the warning it gives in that dialog), save the resulting MeshInstance it gives into its own scene, open that scene, and then go to the Scene menu > Export As > glTF 2.0 Scene.

📎 Attachment: image.png

---

**vhsotter** - 2025-03-08 22:24

Just be warned that this does not do anything for optimization and running it in a web export might be slow depending on the size and density of the resulting mesh.

---

**ozysandlias** - 2025-03-08 22:32

That works! But no textures. I can live with that though

---

**tokisangames** - 2025-03-08 22:33

Remesh it in blender

---

**Deleted User** - 2025-03-09 00:34

Just started using terrain3d and am very impressed. I've got one question so far: after importing a heightmap, is there a way to move or rescale the whole thing/ parts of it? Right now I've just been removing it and reimporting. Sorry if I'm missing something obvious.

---

**tokisangames** - 2025-03-09 01:05

Move without reimporting, use the API or by renaming the files. The repo has a script that facilitates that in the extras directory. Rescale, do that in photoshop.

---

**Deleted User** - 2025-03-09 01:07

Thank you, I'll have a good look at the API tomorrow.

---

**newjblgg** - 2025-03-09 09:37

<@455610038350774273> friend, i have a question, please help me.     when i set the "mesh lod" as a little value such as 1,  the mesh far away is disappear,  i think it is better not disappear, it is better to show the outline of the mesh.

---

**newjblgg** - 2025-03-09 09:37

*(no text content)*

📎 Attachment: 2025-03-09_17-26-25.mkv

---

**newjblgg** - 2025-03-09 09:41

*(no text content)*

📎 Attachment: 2025-03-09_17-26-25.gif

---

**tokisangames** - 2025-03-09 09:41

That's expected behavior. This is a clipmap mesh. Read System Architecture in the docs. It doesn't exist where it's not shown. If you want to cover the horizon change the LODs to 8-10, and expand mesh_size.

---

**newjblgg** - 2025-03-09 09:56

what is the mesh size means, when i change it from 48 to 64, the terrain seems no change

---

**newjblgg** - 2025-03-09 09:57

when i change the vertex spacing from 1 to 5, the terrain increase a lot

---

**tokisangames** - 2025-03-09 10:05

It changes the size of LOD0 and the other lods. Look at wireframe view to see what it's doing.
Vertex_spacing scales the terrain laterally.
Read the description of these in the API docs for more details.

---

**_aleksanderr_** - 2025-03-09 10:18

Why are there strange white lines on the terrain and when I add a normal texture everything breaks?

📎 Attachment: image.png

---

**tokisangames** - 2025-03-09 10:28

Your textures are probably non-square or not power of 2.
> when I add a normal texture everything breaks?
Possibly not the same size/format as the others.
Opening your textures in the inspector will allow you to confirm both. Reread the texture prep doc and troubleshooting that covers most of this.

---

**devbre** - 2025-03-09 15:14

Hi, I am trying to use Terrain3D to build the world for my survival game, but I am really struggling with blending different Synty textures on terrain with the Terrain3D plugin.

Notice how the dark brown texture blends perfectly, while the light brown shows that square shading. 

Please note all 3 textures have been imported in the same way, they have the same size.

Anyone encountered this behaviour?

📎 Attachment: 2b3ba08ae646a281a8df8ee8db1978e7.png

---

**tokisangames** - 2025-03-09 15:20

As you were discussing with Xtarsia, you need height textures in order to properly blend heights. He told you that you can make them with our channel packer or materialize.

---

**devbre** - 2025-03-09 15:24

I am on Linux so materialise is not an option unfortunately. How can I add this from within the plugin with only albedo and normal textures?

---

**tokisangames** - 2025-03-09 15:24

You said your textures are albedo and normal only, which is exactly what it looks like in the picture. No heights, no heights blending. You have two options to fix them.

---

**tokisangames** - 2025-03-09 15:24

We both told you use the luminance option on the channel packer

---

**tokisangames** - 2025-03-09 15:27

It will generate a height texture from luminance.

---

**devbre** - 2025-03-09 15:27

Yeah I reposted here just because I thought it was better place for the post, Xtarsia was helping a lot. I thought I could use the tool only if I had all 4 textures.. I will try to see where this checkbox for luminance is..

---

**tokisangames** - 2025-03-09 15:29

You don't need all textures. You don't have to use height blending. You don't even have to use textures. But if you want height blending, you need heights.

---

**devbre** - 2025-03-09 15:39

i found the luminance button... i used the tool for both the grass and mud textures... which were working before... now I see this as I add the mud texture  (the second texture)...

📎 Attachment: Screenshot_From_2025-03-09_15-38-01.png

---

**tokisangames** - 2025-03-09 15:40

Do you have errors on your console telling you the textures are different sizes/formats? This info is also in the docs. All textures/formats must be the same.

---

**devbre** - 2025-03-09 15:41

yeah: Texture ID 1 albedo format: 19 doesn't match format of first texture: 17. They must be identical.  , but i used the tool for both... how can they be different?

---

**devbre** - 2025-03-09 15:42

actually... one is DXT5 RGBA8  and the other is DXT1 RGBA8... how i can make them the same? no idea why they are differnt..

---

**tokisangames** - 2025-03-09 15:47

DXT5 has alpha, DXT1 does not. It's probably RGB8, not RGBA8
Height and roughness go on the alpha channels

---

**devbre** - 2025-03-09 15:51

Ok so in order to have proper blending I need DXT5 for all I would assume. If I have dxt1 textures, is there a way to convert to dxt5? Sorry just trying to work out how to fix my issue

---

**tokisangames** - 2025-03-09 15:52

Put both heights and roughness maps in your texture sets, and they will be RGBA8 PNGs. Godot will convert them to DXT5. Right now you're mixing RGB and RGBA which isn't allowed by Godot/hardware.

---

**devbre** - 2025-03-09 15:53

I don’t have those additional textures, Synty only gives albedo and normal. Is there a way?

---

**tokisangames** - 2025-03-09 15:55

We've told you how to make height with luminance. Roughness you can make with materialize, or put in a blank/mid value.

---

**tokisangames** - 2025-03-09 15:55

All albedo and all normals need to be the same. But they can differ from each other. You can do RGB on all normals, and skip roughness.

---

**devbre** - 2025-03-09 15:58

When you say blank/mid for roughness what you mean? A texture with the same size of the normal tex but all white?

---

**tokisangames** - 2025-03-09 16:01

Black, white, or 0.5 grey. I'd do the latter if I wanted the texture, but more likely I'd do only RGB

---

**devbre** - 2025-03-09 16:05

Ok so if I skip the roughness, in the tool I put: 
- albedo tex from Synty
- create the height from luminance button
- put the normal tex from Synty 

What else I need to do? Sorry I am just looking for steps to take… spending too much on this so I am clearly missing something simple.

---

**tokisangames** - 2025-03-09 16:13

If you aren't going to use roughness textures on your normals you don't need to pack them in the tool. The channel packer is designed to pack channels from multiple maps into one file. You want albedo and height textures packed into the same file to solve your original problem and close the ticket you opened.

---

**devbre** - 2025-03-09 16:20

when i try to just use the top part of the tool which creates the albedo_height.png file, I see that the tool creates a DXT5 for the first albedo and creates a DXT1 for another I provide... what i am trying to understand is how to make sure that the tool creates the same type for the different textures so i can use them together

---

**tokisangames** - 2025-03-09 16:23

No it creates a PNG, which you save to disk. Godot converts it to DXT based on your import settings and the contents. If you have RGBA in the file it converts to DXT5. If you have RGB in the file, it goes to DXT1.

---

**devbre** - 2025-03-09 16:35

I tried that and i still see the issue... at this point I am starting to think there is something wrong with the Synty textures... but on the other hand in Unity I never had any issue with those when painting terrain

---

**tokisangames** - 2025-03-09 16:38

Tried what specifically? The textures are probably fine. With respect, I think what is missing is the understanding of the core concepts like channel packing, file formats, etc. These ideas are universal to all game engines. You can use the basic textures without heights, but if you want height blending you need heights.

---

**devbre** - 2025-03-09 16:40

Surely I am missing something here, thing is I followed the wiki and your suggestion and the result is still the same. I just DMed you as well.

---

**tokisangames** - 2025-03-09 16:41

I prefer general chats rather than DMs

---

**tokisangames** - 2025-03-09 16:41

I agree, I'm positive you're missing something

---

**tokisangames** - 2025-03-09 16:43

I don't know which suggestion you're referring to or which result is the same. We've told you a lot

---

**devbre** - 2025-03-09 16:52

what i did is:
- get the first texture from synty, it is a DXT1 RGB8, put into the tool , generated the luminance and grabbed the result... the result is a DXT1 
- get the second texture from synty, it is a DXT1 RGB8, put into the tool , generated the luminance and grabbed the result... the result is a DXT1 
The result is the usual one, where the second packed tex has those square edges.

📎 Attachment: Screenshot_From_2025-03-09_16-51-02.png

---

**tokisangames** - 2025-03-09 17:01

Let's be clear and rigorously specific. Which "first texture"? Albedo? 
You downloaded a PNG w/o alpha (RGB8)? It isn't a DXT1 until godot converts it into a separate file. The Godot inspector only shows you the converted file details.
 
> 1. generated the luminance and grabbed the result... the result is a DXT1
That's an issue. If you put in the albedo and generated height based on luminance and saved, that new file should give you RGBA8 PNG, which Godot converts to DXT5. If that's not the case, then first solve that issue.

---

**devbre** - 2025-03-09 17:06

- with "first texture" and "second texture" I mean the 2 albedo I get from Synty.
- yeah the original textures are RGB8 from Synty
- that new file should give you RGBA8 PNG ... this is not happening.

---

**tokisangames** - 2025-03-09 17:08

I just did it in the demo with the RGB8 icon.png and it gave a packed_albedo_height.png which reports DXT5 just fine.

---

**devbre** - 2025-03-09 17:10

could be something wrong with the synty texture then? I also noticed that when I generate the luminance, the result in the height texture of the tool is completely white, as if all parts of the texture have the same height?

---

**tokisangames** - 2025-03-09 17:12

Visually does the texture have variation in luminance? If its luminance is uniform you will need to figure out another way to generate heights.
If the alpha channel is completely white, that means no alpha, so it's possible godot is stripping it out automatically.

---

**devbre** - 2025-03-09 17:13

it does, you can see it in the picture i posted, you can see there is a polygonal pattern, but maybe not enough to be picked up by the tool?

---

**tokisangames** - 2025-03-09 17:15

Just make a black and white version of albedo with some contrast and offset adjustment in photoshop and use it as a height texture

---

**devbre** - 2025-03-09 17:17

i will try that... just to confirm... here is what happens. Is this the main reason  of the behavior I see (square shades)?

📎 Attachment: Screenshot_From_2025-03-09_17-16-08.png

---

**xtarsia** - 2025-03-09 17:17

yeah that particular texture has almost no variation in luminance

---

**xtarsia** - 2025-03-09 17:26

a minute or so using Materialize to make a height texture:

📎 Attachment: image.png

---

**xtarsia** - 2025-03-09 17:28

probably just get away with greyscaling + some contrast adjust

---

**devbre** - 2025-03-09 17:28

Thanks ! I will try this one now! I am on Linux hence the Materialize app is not an option... I tried with Gimp and the result is slightly better but still not good.

---

**xtarsia** - 2025-03-09 17:30

I would suggest to try and get the brightness histogram of the greyscale image to cover the full range, it makes blending much better visually

---

**devbre** - 2025-03-09 17:30

on it now thanks

---

**tokisangames** - 2025-03-09 17:34

Wine? VMs?

---

**devbre** - 2025-03-09 17:35

yeah i could try... i was hoping for an easier solution ... always had issues with Wine in the past

---

**rasho.711** - 2025-03-09 17:40

hi can anyone help me? idk why its flickering when im moving

📎 Attachment: Unbenanntes_Video_Mit_Clipchamp_erstellt_1.mp4

---

**xtarsia** - 2025-03-09 17:42

Turn off TAA/FSR. We have no way to write / reset motion vectors

---

**rasho.711** - 2025-03-09 17:44

can you maybe tell me how to do that?

---

**devbre** - 2025-03-09 17:44

Thanks a lot to you and <@188054719481118720> guys, turned out that the issue was the texture.. atm least I wasn;t being completely blind. I see that setting a height tex, the result is actually better... so now I will just go to Synty asking for a proper height map for that bloody tex. Thanks again for the grat support and apologies for being a pain.

📎 Attachment: Screenshot_From_2025-03-09_17-44-05.png

---

**xtarsia** - 2025-03-09 17:45

Project Settings > Rendering > Use TAA
Project Settings > Scaling 3D > Mode (Bilinear)

---

**tokisangames** - 2025-03-09 17:46

Please close your Issue

---

**rasho.711** - 2025-03-09 17:49

already have those setting set

---

**xtarsia** - 2025-03-09 17:50

are you using 4.4? if so its physics interpolation, there is a 4.4 branch that Cory has a fix in place for that.

---

**rasho.711** - 2025-03-09 17:50

im using 4.3

---

**tokisangames** - 2025-03-09 17:51

Turn off TAA, not set it.

---

**rasho.711** - 2025-03-09 17:51

its just happening when the game is running not in the editor

---

**rasho.711** - 2025-03-09 17:51

oh i mean that it was off

---

**rasho.711** - 2025-03-09 17:52

it was just like he said

---

**xtarsia** - 2025-03-09 17:52

and FSR?

---

**rasho.711** - 2025-03-09 17:52

same

---

**rasho.711** - 2025-03-09 17:52

bilinear

---

**tokisangames** - 2025-03-09 17:52

You have a temporal effect running. TAA, FSR, or Physics Interpolation. They're enabled in your project settings, your code, or possibly in your GPU driver? 
Test our demo, which is setup without those options. Does it flicker there?

---

**rasho.711** - 2025-03-09 17:55

it does not flicker in the demo

---

**tokisangames** - 2025-03-09 17:55

Great, now compare your project and code to the demo and find the difference. Diff the project files. Search your code.

---

**rasho.711** - 2025-03-09 17:56

i dont understand "my code"?

---

**rasho.711** - 2025-03-09 17:57

i am only using a fps controller from the assetlib

---

**rasho.711** - 2025-03-09 17:57

there is my only code in

---

**tokisangames** - 2025-03-09 17:57

Surely you have gdscript code for your game.

---

**tokisangames** - 2025-03-09 17:57

If you don't have any setting those parameters, fine. If you're using someone else's code, make sure they aren't setting those things.

---

**rasho.711** - 2025-03-09 17:58

you mean that one in the middle bottom?

📎 Attachment: image.png

---

**rasho.711** - 2025-03-09 17:58

thats my character

---

**rasho.711** - 2025-03-09 18:00

so i replaced my character with the one from the demo and it is still the same

---

**rasho.711** - 2025-03-09 18:00

could the issue caused by settings of the environment?

---

**tokisangames** - 2025-03-09 18:02

No, the ones listed are physics or renderer settings, set in your project file. Diff the project file with the demo like I said.

---

**rasho.711** - 2025-03-09 18:03

i dont know how to do that, if it is complicating i will just leave it like that or try something else

---

**rasho.711** - 2025-03-09 18:03

but thank you

---

**xtarsia** - 2025-03-09 18:05

its the motion blur

---

**xtarsia** - 2025-03-09 18:05

Have you got the motion blur addon?

---

**rasho.711** - 2025-03-09 18:06

ahhhh yeah thank you it was in the environment

---

**xtarsia** - 2025-03-09 18:06

any effect that uses motion vectors is not compatible with a clipmap terrain

---

**tangypop** - 2025-03-09 18:39

I'm testing out the new LOD functionality, finally replacing my manual billboard placements/rendering stuff. If right on the boundary of LODs it doesn't render either. In the video I slide the tree distance to 31.0 which will set the LODs 0, 1, and 2 to 31.0, 62.0, and 2062.0, respectively (code snippet attached). When standing about 62.0m away it doesn't render either LOD1 or LOD2, though. Same for between LOD0 and LOD1 but that's harder to stand right between the ranges to see the issue. I think the preferred behavior would be to fall back to either the LOD1 or LOD2 when standing right at the boundary between them. I assume making the changes in my material shouldn't be needed for render distance, since the mesh is either rendered or not based on the LOD config and distance.

📎 Attachment: 2025-03-09_14-20-36.mp4

---

**tangypop** - 2025-03-09 18:54

I did try fade_margin but I don't think it does what I think it does.

---

**xtarsia** - 2025-03-09 18:55

a small crossover is needed, there is an engine side hysteresis but it can actually result in the opposite of the desired effect.

---

**tokisangames** - 2025-03-09 19:10

Can you reproduce this in the demo with our lod asset?

---

**drbellubins** - 2025-03-09 19:21

Is fsr supported in 0.9.3a?

---

**deathmetalthanatos_42378** - 2025-03-09 19:31

What is the Methode call for set Control Map?

---

**deathmetalthanatos_42378** - 2025-03-09 19:33

storage.set_control_texture ??

---

**tangypop** - 2025-03-09 19:36

<@455610038350774273> It is reproducible with the demo. I think for my game the greater contrast between the trees and snow make it easier to perceive while walking. I built from commit ee5e9955d7ab06c447b21b06621486b2cda651d0.

📎 Attachment: 2025-03-09_15-23-40.mp4

---

**tokisangames** - 2025-03-09 19:43

It may work, but not reliably until the engine gives a means to neutralize motion vectors.

---

**tokisangames** - 2025-03-09 19:44

Please read the docs. The API has several functions to set various settings on the control map. "storage" was from 0.9.2, which you shouldn't be using.

---

**deathmetalthanatos_42378** - 2025-03-09 19:50

ohh

---

**salgueiroazul** - 2025-03-09 21:07

Hello! 
I've downloaded the most recent Nightly Build. **Symmetric grids** have been [implemented](https://github.com/TokisanGames/Terrain3D/pull/622), correct?

How would one enable that option? 👀

---

**xtarsia** - 2025-03-09 21:14

implemented, but not merged yet, pending any required changes. Also the LOD0 will still be regular until someone (maybe me) gets a PR into Godot to get the heightmapshape to also be symetric.

---

**salgueiroazul** - 2025-03-09 21:16

Darn! 😛 Really looking forward to see it merged then! Thanks for letting me know

---

**corvanocta** - 2025-03-09 22:27

Hey all! Quick question, I've got a texture that I'm using as my texture for the terrain, then building the terrain based on that texture. All is working fine, except that the texture comes in a little too small, and I can't find how to scale it up. How would I do that? Texture looks like it's roughly 3x too small

---

**vhsotter** - 2025-03-10 00:28

I assume you're talking about the texture slots for painting on the terrain. To scale that up and down, edit the texture slot and adjust the UV scale.

---

**amandella** - 2025-03-10 00:33

Hi all, ever since updating to Godot 4.4 I'm running into an issue where holes in my terrain stop the player. The edge of the terrain acts like a wall and then the colliding object gets stuck. Wondering if there is a setting or tweak that I may have missed or if this is a known issue. Thanks.

---

**vhsotter** - 2025-03-10 01:26

I'm experiencing an odd little issue in the addon nightly. Set up LOD assets in the foliage instancer and at a certain distance where the LOD would change the object instead disappears. It's a very tiny window where this happens. It does not happen if I create a new scene with a couple of MeshInstance3Ds. I need to mess around more to see if I can pinpoint the cause. But was curious if this is a current known issue or not.

---

**rcab__** - 2025-03-10 01:32

hey all, i'm getting started with Terrain3D 🙂 really exciting tool! I'm just wondering if it's possible to change the clipmap size? Like I think I understand the region concept, but i'm unsure why terrain stretches into infinity and is visible in-game even though when not actively used. how could I show only the active region content?

📎 Attachment: image.png

---

**vhsotter** - 2025-03-10 01:33

Click on the Terrain node, click on the Material to expand it, then click the dropdown next to World Background. Change it from Flat or whatever it's on to None.

📎 Attachment: image.png

---

**rcab__** - 2025-03-10 01:33

oh it worked amazing! tysm 🙂

---

**rcab__** - 2025-03-10 01:51

*(no text content)*

📎 Attachment: 20250310-0150-47.1100620.mp4

---

**rcab__** - 2025-03-10 01:52

~~hey again, i'm just curious what you think the bug could be, there's seams between regions (?) showing up frequently + the terrain itself seems to jitter? (more visible near the end)~~
It was the physics interpolation bug

---

**rcab__** - 2025-03-10 01:53

here the stutter is more visible

📎 Attachment: 20250310-0153-29.9446320.mp4

---

**tangypop** - 2025-03-10 02:04

I'm noticing the same. There are a few messages about it a little bit up. https://discord.com/channels/691957978680786944/1130291534802202735/1348364513929330790

---

**tangypop** - 2025-03-10 02:07

From what I can tell there is the fade attribute but it cannot be used until a fix is done in Godot. In Terrain3D it's probably here. If the fade margin is set then it does the first condition with range begin/end margins, otherwise it only sets range begin/end. I tried setting fade_margin and got some weird results.

---

**tangypop** - 2025-03-10 02:07

*(no text content)*

📎 Attachment: image.png

---

**vhsotter** - 2025-03-10 02:09

Bleh. I missed that conversation. I won't go spending a ton of time on this then. Thank you for the heads up.

---

**tokisangames** - 2025-03-10 05:56

Can you reproduce it in our demo? I cannot, with v1.0-dev. You can visualize the collision (described in the collision doc).

---

**tokisangames** - 2025-03-10 06:04

This is an engine issue/choice that we could work around. I see the gap in 4.3. In 4.4, there's a built in overlap. So do we add an overlap if the engine is 4.3?
<@78674731095556096> <@188054719481118720>

📎 Attachment: B3CF49B3-467D-4E18-ABD1-051E0A07B8EA.png

---

**tokisangames** - 2025-03-10 06:05

Use the main-godot4.4 branch nightly build if you want PI

---

**vhsotter** - 2025-03-10 06:24

I don't think I'm fully understanding the mechanics of what's going on internally and with respect to Godot versions. I'm using 4.4 with the latest dev nightly of Terrain3D. If there's a built in overlap does that mean that I shouldn't be seeing the disappearance of foliage LODs occurring?

---

**elvisish** - 2025-03-10 07:42

physics interpolation causes the regions to flicker on the seams, there's a topic about it here: https://forum.godotengine.org/t/weird-flickering-on-terrain3d-v0-9-3a/97698

and i can confirm, with physics interpolation:

📎 Attachment: 2025-03-10_07-41-12.mp4

---

**elvisish** - 2025-03-10 07:42

without physics interpolation:

📎 Attachment: 2025-03-10_07-42-15.mp4

---

**tokisangames** - 2025-03-10 08:16

Use the main-godot4.4 branch nightly build if you want physics interpolation

---

**tokisangames** - 2025-03-10 08:16

I can't reproduce it in the demo with 4.4. It is automatically overlapped as I showed.

---

**vhsotter** - 2025-03-10 08:23

Alright. I'll do some testing tomorrow. I have a suspicion why it might still be present in the minimal project I constructed.

---

**tokisangames** - 2025-03-10 08:29

<@177404097312325632> You did a test with our demo with 4.4? I think I saw in your video the lod0/lod1 transition was overlapped, but lod1/2 gaps

---

**vhsotter** - 2025-03-10 08:29

~~That wasn't my demo, that was TangyPop.~~

---

**tokisangames** - 2025-03-10 08:31

Yes, I tagged him and you

---

**tokisangames** - 2025-03-10 08:31

I see it gapping now in 4.4 as well

---

**tokisangames** - 2025-03-10 08:31

I'm going to try and induce a very small overlap

---

**vhsotter** - 2025-03-10 08:32

Sorry, it's quite late and I'm tired. I failed to notice you tagging Tangy. :P

---

**elvisish** - 2025-03-10 08:33

i am already, the main version needed meshes to be a child so i used the night build that allowed just plain meshinstance3d as the root node of the mesh

---

**tokisangames** - 2025-03-10 08:33

Sorry, I don't understand this.

---

**elvisish** - 2025-03-10 08:40

im on the nightly build as you suggested

---

**elvisish** - 2025-03-10 08:40

`1.0.0-dev`

---

**tokisangames** - 2025-03-10 08:41

<@78674731095556096> <@177404097312325632> See if [this](https://github.com/TokisanGames/Terrain3D/pull/639) fixes it for you

---

**tokisangames** - 2025-03-10 08:43

Good. main-godot4.4 is the only one that supports PI

---

**elvisish** - 2025-03-10 08:45

im super stupid when it comes to building, would i have to compile this or should i just wait for it to be auto built and download that?

---

**tokisangames** - 2025-03-10 08:45

Read the nightly builds doc and use the automatic build for the main-godot4.4 branch.

---

**elvisish** - 2025-03-10 08:46

i got the other nightly build one from here: https://github.com/TokisanGames/Terrain3D/actions/workflows/build.yml?query=branch%3Amain

---

**tokisangames** - 2025-03-10 08:47

That does not work with PI. I told you, only main-godot4.4

---

**tokisangames** - 2025-03-10 08:48

Are there no builds for that branch?

---

**elvisish** - 2025-03-10 08:49

i just did what it said on this tweet:

📎 Attachment: image.png

---

**elvisish** - 2025-03-10 08:49

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-03-10 08:50

Yes, that document says to get a build from the `main` branch. Now I'm telling you to use the `main-godot4.4` branch.

---

**elvisish** - 2025-03-10 08:50

*(no text content)*

📎 Attachment: image.png

---

**elvisish** - 2025-03-10 08:50

ohh okay

---

**tokisangames** - 2025-03-10 08:50

I don't need these pictures. I know what it looks like

---

**tokisangames** - 2025-03-10 08:50

That last picture literally says main branch. I'm telling you to use the other branch

---

**tokisangames** - 2025-03-10 08:50

Change the branch

---

**elvisish** - 2025-03-10 08:50

yes but im trying to show you want im seeing, i just cleared the search box and the new version shows, i told you i'm stupid when it comes to building

---

**tokisangames** - 2025-03-10 08:51

You're not building. The system already built it for you.

---

**elvisish** - 2025-03-10 08:53

build adjacent work, okay i've got the artifact from that latest push...

---

**elvisish** - 2025-03-10 08:55

i swapped out the files in bin with the new ones and it still flickers with PI on

---

**tokisangames** - 2025-03-10 08:57

Flickering comes from: motion blur, TAA, FSR, or PI. main-godot4.4 fixes PI. If it's still flickering, you haven't updated the library to the right version, or you have one of the other things enabled.

---

**pawelpudlik** - 2025-03-10 11:06

hey Cory, I think I've found another bug - I'm occasionally getting this while running a project with Terrain3D node present in 4.4. Not sure how to reproduce it, does it ring any bell?

📎 Attachment: image.png

---

**pawelpudlik** - 2025-03-10 11:08

obviously must be editor-related, it shows upon pressing F5 - before the scene is loaded in game

---

**tokisangames** - 2025-03-10 11:12

99% of our errors say "Terrain3D" somewhere. Just because you have Terrain3D doesn't mean all errors you get are ours. Many will come from your own code or the engine.

---

**pawelpudlik** - 2025-03-10 11:53

I shall not bother you with things I cannot reproduce, it's just a correlation I noticed and was trying to be helpful

---

**shalokshalom** - 2025-03-10 12:24

Then it should say that, imo

---

**tokisangames** - 2025-03-10 12:26

What should say it? Godot errors should say they aren't from Terrain3D?

---

**amandella** - 2025-03-10 12:56

Thanks for the reply. We figured this out late last night. Looks like when transitioning to 4.4 and removing the Jolt physics addin we had to set the physics in the project settings back to default and then back to Jolt.

---

**kamazs** - 2025-03-10 12:57

I think smth like that happened to me, too.

---

**drbellubins** - 2025-03-10 16:48

Does depth blur do anything to optimize the terrain, or is it just cosmetic?

---

**xtarsia** - 2025-03-10 17:25

its 99% cosmetic, you may see the worlds smallest FPS increase due to less VRAM bandwidth as it'll use higher mipmap levels, but thats about it.

If you use a depth of field screen space post process, then setting this as well, can make the terrain in the distance less "shimmery" as well.

---

**drbellubins** - 2025-03-10 17:26

Hmm, okay. There seems to be a lack of optimization options. I'll have to do some texture work to decrease GPU usage. thanks

---

**xtarsia** - 2025-03-10 17:30

https://terrain3d.readthedocs.io/en/stable/docs/tips.html#performance

---

**vhsotter** - 2025-03-10 19:33

Tested this and that seems to have done the trick. My trees are no longer popping out of existence at certain distances.

---

**shalokshalom** - 2025-03-10 20:14

All errors should report from where they come.

Errors from Godot should be reported as errors from Godot.

Errors from user input should be reported as user input errors.

And Terrain3D errors should be reported as Terrain3D errors.

Otherwise could everybody report issues from a random source, that would be about as helpful. 

Agreed?

---

**tokisangames** - 2025-03-10 20:15

Our errors report Terrain3D. We don't control Godot or their errors.

---

**shalokshalom** - 2025-03-10 20:43

Yeah, I understand that. And why do your errors not distinguish between both?

---

**shalokshalom** - 2025-03-10 20:43

As in this case.

---

**deathmetalthanatos_42378** - 2025-03-10 20:45

OK, sometimes it works and sometimes not :/ 
I dont get it

📎 Attachment: splatmapper.zip

---

**tokisangames** - 2025-03-10 20:49

These aren't our errors.

---

**shalokshalom** - 2025-03-10 20:53

I see. So Godot reports issues as problems of Terrain3D.

Would that make sense, to open a bug report on their side?

I mean ... that shouldn't happen?

---

**shalokshalom** - 2025-03-10 20:54

Welcome to software development 😅

---

**deathmetalthanatos_42378** - 2025-03-10 20:54

ha ha ^^

---

**deathmetalthanatos_42378** - 2025-03-10 20:58

ahhh I have to reload the szene

---

**tokisangames** - 2025-03-10 20:58

Godot is not reporting issues as problems of Terrain3D. I don't know where you're getting all of this from. You've misunderstood the situation.
If one has identified a bug in the engine, one should search to determine if the bug has been reported, and if not make a new issue. We already do that.

---

**shalokshalom** - 2025-03-10 21:00

If they are not your errors, and not those from Godot, whos errors are they.

And why are they reported as yours?

---

**tokisangames** - 2025-03-10 21:02

What? Those are Godot errors. No where are they reported as Terrain3D errors. Please drop it. Reread all the messages if you like to help you understand what you're missing.

---

**shalokshalom** - 2025-03-10 21:07

Thanks, I really missed a beat.

---

**drbellubins** - 2025-03-10 22:32

This is a technical question: Why is the terrain mesh constantly moving? I read in the docs this disables all temporal effects (taa, fsr, physics interpolation).

---

**drbellubins** - 2025-03-10 22:34

I also read it has something to do with the LODs. But I'm not aware of other terrain systems having this limitation

---

**drbellubins** - 2025-03-10 22:35

Is it really just a limitation with Godot at this point? (like the docs imply)

---

**tranquilmarmot** - 2025-03-10 22:46

Is there a reason I can't put any regions after y `-16`?

📎 Attachment: Screen_Recording_2025-03-10_at_3.45.20_PM.mov

---

**tranquilmarmot** - 2025-03-10 22:47

👆 that would be placing a new region at y `-17` but it refuses

---

**tranquilmarmot** - 2025-03-10 22:48

I have region size set to 128

---

**tranquilmarmot** - 2025-03-10 22:49

Goes in the other direction as well, can't place any regions above x or y `15`

---

**tranquilmarmot** - 2025-03-10 22:50

> There is currently a limit of 1024 regions or 32 x 32. So the maximum dimensions of the your world are 32 * region_size. The maximum being 32 * 2048 or 65,536m per side.
ahhh, okay okay

---

**tranquilmarmot** - 2025-03-10 22:51

So if I want a bigger world, then I need a bigger region size... 😭

---

**tokisangames** - 2025-03-10 22:57

Read System Architecture in the docs. All Clipmap terrains move. Witcher 3 and many other games use Clipmaps. The flickering problem is due to Godot not offering a method for neutralizing them.

---

**tokisangames** - 2025-03-10 22:59

Just change your region size.

---

**tranquilmarmot** - 2025-03-10 23:03

Yeah, I am doing some "weird" stuff here that I don't expect to be fully supported 😅 

My hope was to make a few of these "region groups" and then randomly assemble them into a corridor. I have a smaller region size because I wanted to be able make each group a little smaller, but this way I can only make it 32 regions "long".
I think I can deal with them being larger, though.

📎 Attachment: Screenshot_2025-03-10_at_4.00.02_PM.png

---

**moooshroom0** - 2025-03-11 00:37

so im curious, is there a way to have an "invisible layer" painted onto a terrain which would allow me to generate foliage types etc using particles? kind of my attempt at grass optimization with a good level of density. ive seen people just use planes but i want the grass to be controlled. and im really only asking this because im not sure if implementation of it will work with terrain 3d.

---

**tangypop** - 2025-03-11 00:40

What do you mean by controlled? If you mean wind/interaction you can achieve that with plane meshes.

---

**moooshroom0** - 2025-03-11 00:41

Limitations so that grass doesnt end up in sections i dont want it.

---

**moooshroom0** - 2025-03-11 00:41

kind of like when you look at a field and theres a forest, usually the grass kinda disapears as it gets there etc and perhaps far more detailed things.

---

**tangypop** - 2025-03-11 00:42

That's fair, but I think that's separate whether you use planes, particles, or something else.

---

**moooshroom0** - 2025-03-11 00:43

Just not sure how it would work/How to implement it.

---

**moooshroom0** - 2025-03-11 00:44

I kinda have a large scope project in mind(what im working on) and i want to get a good bit of things working.

---

**moooshroom0** - 2025-03-11 00:44

its technically been in plan for a few years now.

---

**tangypop** - 2025-03-11 00:45

If you're wanting to procedurally generate foliage you could probably use the texture from the control map if they correlate with your biomes. Like forest ground texture has x amount of plant a, but dirt ground texture would have y amount of plant b.

---

**moooshroom0** - 2025-03-11 00:48

is that a thing or am i just rather uncertain where that is XD

---

**moooshroom0** - 2025-03-11 00:50

So if im understanding correctly, i can have a duplicate of a texture and it could have the grass etc place in where its painted, which arguably is a good way to have controlled grass

---

**moooshroom0** - 2025-03-11 00:51

is this something i would have to code in? (i cant find an option for this so thats what my guess is)

---

**tangypop** - 2025-03-11 00:51

Terrain3D.terrain.data.get_texture_id(position: Vector3) will return the ID of the texture.

---

**tangypop** - 2025-03-11 00:53

Oh, yeah, definitely. If you're wanting to do anything procedural you'll need write the code for your gen. But if you're wanting to make use of some kind of map to know what kind of texture is at a given position the texture data from the control map might be workable.

---

**moooshroom0** - 2025-03-11 00:54

alrighty then, sounds great!

---

**moooshroom0** - 2025-03-11 00:55

i kinda wish there was a forum channel where things could get posted so i don't lose anything xD

---

**tangypop** - 2025-03-11 00:55

I already use it to know what kind of footstep sounds to play and alter player movement like ice based on texture.

---

**moooshroom0** - 2025-03-11 00:55

im nr going to be able to do much till may so i have to just put pins in things.

---

**moooshroom0** - 2025-03-11 00:56

pretty awesome stuff.

---

**moooshroom0** - 2025-03-11 00:58

as of right now im practically a newborn in godot so i need to get learning all the fun soon.

---

**tangypop** - 2025-03-11 01:00

It's a fun journey, take your time and enjoy it.

---

**moooshroom0** - 2025-03-11 01:00

i shall

---

**moooshroom0** - 2025-03-11 01:01

ive already been working on game projects and made some for fun so the grind is nothing new

---

**moooshroom0** - 2025-03-11 01:04

the only real difference thats harder with 3d is theres alot to remember.

---

**tangypop** - 2025-03-11 01:37

Just now getting a chance to build and try it out. It seems better for near transitions but still noticeable when they are distant. I changed the overlap from .01f to 1.0f, rebuilt, and then it looks better when transition is distant but then the overlap when transition is near is obviously more noticeable. I'll probably keep my local build with the 1.0f overlap and hope players keep tree detail distance slider far. lol

---

**tranquilmarmot** - 2025-03-11 02:49

I'm using scatter for foliage
https://github.com/HungryProton/scatter
There's a script you can copy from the Terrain3D repo that adds a "Place on Terrain3D" step you can add to the scattering. You can define areas where nodes get placed down and also define "negative" areas to prevent it from placing in specific spots.

---

**tranquilmarmot** - 2025-03-11 02:50

Works really great for things like rocks and trees that you want placed randomly with random rotations/scales

---

**tranquilmarmot** - 2025-03-11 02:51

I then have "negative" areas on roads so that it doesn't put trees in the middle of the road

---

**tokisangames** - 2025-03-11 06:01

You can write a particle shader. Search discord for others who have done it.

---

**tokisangames** - 2025-03-11 06:02

The PR already built it for you. I can look at increasing the offset as the lods progress. Thanks for the report.

---

**vhsotter** - 2025-03-11 06:43

Whoops. I did not realize the PR built it so I'd built it myself. Oh well, it's good to practice the routine.

---

**devbre** - 2025-03-11 10:30

I just noticed that the trees I add using the Mesh instancer, do not carry the colliders for collision. Is this by design? Any way we can keep the collision on?

---

**tokisangames** - 2025-03-11 10:33

Read the Instancer doc for limitations and plans

---

**devbre** - 2025-03-11 10:50

so I see that having instancer collision was blocked by another PR (which has been merged already), but I don't see any plan forward for the actual collision on meshes in the doc

---

**tokisangames** - 2025-03-11 10:55

Should be multiplied instead of added. Now there's a 0.05% overlap, which is 0.016f at 32, or 1.0 at 2000. This shows me both at the transitions through lod2/3 in the demo. Please try the updated PR. <@78674731095556096>

---

**tokisangames** - 2025-03-11 10:57

The plan is to generate it, which is more feasible now that dynamic collision is in. You can take it on if you like.

---

**devbre** - 2025-03-11 10:59

Not much a c++ dev myself, I can probably help on the Sky3d project which i see is a gdcript project instead. I am glad that adding collision to meshes is on sight.

---

**deathmetalthanatos_42378** - 2025-03-11 13:37

99% Done of the Splatmap Plugin for Terrain 3D

📎 Attachment: Bildschirmfoto_vom_2025-03-11_14-36-25.png

---

**deathmetalthanatos_42378** - 2025-03-11 13:40

*or maybe 95% 😉

---

**deathmetalthanatos_42378** - 2025-03-11 22:34

is there a possibility to "trigger" a specific Asset Texture? 
For Example: I have a Splatmap with only Red and I want this on Chanel  5 
Than I have a next Splatmap with only red for Chanel 4 
and a next one for Chanel 32 ?

---

**deathmetalthanatos_42378** - 2025-03-11 22:35

*or maybe a Splatmap with red and blue ...

---

**tokisangames** - 2025-03-12 05:04

I don't understand what you mean. You can select assets from the API. Looking at your picture, you don't need to add ground textures at all. Just have ints and a splatmap texture and you can tie that to the asset id. Are you building this to make a PR and add to the repository?

---

**deathmetalthanatos_42378** - 2025-03-12 07:59

Yeah, I think to add Ints and a Splatmap is the better Idea. 
So you will have a Array Texture 1 2 3…..32 .

What do you mean with a PR? 
Yeah you can Add my Splat Map Plugin to Terrain 3D if you like.

---

**deathmetalthanatos_42378** - 2025-03-12 08:12

but how do I say to Terrain3DRegion „get this slot from Terrain3DAssets“ ?

---

**tokisangames** - 2025-03-12 11:23

[These](https://github.com/TokisanGames/Terrain3D/pulls) are PRs. See [Contributing](https://github.com/TokisanGames/Terrain3D/blob/main/CONTRIBUTING.md).

---

**tokisangames** - 2025-03-12 11:25

You need to explore the API more. You don't even need to do anything with Terrain3DAssets, except query how many assets there are so you can clamp values. You also won't work with Terrain3DRegion. You'll work with Terrain3DData and use set_pixel() or its variants. Most commonly you'll be using set_control_base_id().

---

**deathmetalthanatos_42378** - 2025-03-12 13:33

ahhhhh!!! 
WOW
ok will try when Im home!

---

**deathmetalthanatos_42378** - 2025-03-12 13:33

thanks man!

---

**very.mysterious** - 2025-03-12 16:13

I'm curious if there's a way to change the `VisualInstance3D` layer of the terrain's mesh, I've looked around a bit and haven't seen anything that seems to let me... I was messing around with particle collisions and was curious if `GPUParticlesCollisionHeightField3D` worked with the terrain, surprisingly it does! However, that heightfield uses the `VisualInstance3D` layer to choose what to create the heightfield from, and luckily the terrain does count for it with the layer seemingly set to `1` which is the default for most objects so perfectly reasonable. I could reserve `1` for terrain and change this value for every other object I add, but it seems more efficient to change it for the terrain and leave the default for everything else. So, is there maybe a way to change this layer for the terrain that I'm missing? If not, I think it might be useful to have in the future 🤔

---

**very.mysterious** - 2025-03-12 16:21

Oh wait I found it I'm stupid 🤦‍♂️

---

**very.mysterious** - 2025-03-12 16:22

I went to code docs first and it was just a field on the object right there

---

**coolgaie** - 2025-03-12 20:42

Hey all, trying to get started with Terrain3D and following the tutorial video here: <https://youtu.be/oV8c9alXVwU?si=N8-XdERL9r05r1FJ&t=791> (timestamped)

I've prepared the textures and I am attempting to pull them in to godot, but the texture array as shown in the video is not there/locked:

📎 Attachment: image.png

---

**coolgaie** - 2025-03-12 20:42

I cannot figure out how to unlock it at all.

---

**coolgaie** - 2025-03-12 20:42

What am I doing wrong?

---

**xtarsia** - 2025-03-12 20:47

you add them via this UI.

📎 Attachment: image.png

---

**coolgaie** - 2025-03-12 20:48

That UI flatly does not exist for me.

---

**xtarsia** - 2025-03-12 20:48

it might be on the bottom, or somewhere else.

---

**coolgaie** - 2025-03-12 20:49

*(no text content)*

📎 Attachment: image.png

---

**coolgaie** - 2025-03-12 20:49

Like I have no idea what to say, it's just flat out not there

---

**deathmetalthanatos_42378** - 2025-03-12 20:49

<@455610038350774273> The Splatmap Plugin is 99.9% Done. You can import 32 Splatmaps now and put it on Chanal 1-32 🙂

---

**deathmetalthanatos_42378** - 2025-03-12 20:50

It will read always the red Chanal of a PNG

---

**deathmetalthanatos_42378** - 2025-03-12 20:51

and you can set a Value if you want 100% of Red Chanel or less

---

**xtarsia** - 2025-03-12 20:51

its a pannel that could be in 1 of many places, maybe at the bottom? look around for a Terrain3D tab

📎 Attachment: image.png

---

**deathmetalthanatos_42378** - 2025-03-12 20:52

(useful for small ways) :3 ha ha ha

---

**coolgaie** - 2025-03-12 20:52

here is the entire screen

📎 Attachment: image.png

---

**coolgaie** - 2025-03-12 20:52

i was looking around for 15 minutes before coming in here, i'm unfortunately completely lost

---

**xtarsia** - 2025-03-12 20:53

is this ticked?

📎 Attachment: image.png

---

**xtarsia** - 2025-03-12 20:53

you may need to restart godot editor a couple times too

---

**aldocd4** - 2025-03-12 20:53

is it supposed to work on 4.4 yet?

---

**coolgaie** - 2025-03-12 20:54

It was not, I now see it on the bottom

---

**coolgaie** - 2025-03-12 20:54

*(no text content)*

📎 Attachment: image.png

---

**xtarsia** - 2025-03-12 20:55

it does if physics interpolation is off, The next Terrain3D release may officially support 4.4 (since its very commonly asked now)

---

**coolgaie** - 2025-03-12 20:55

I did not see that step in the startup tutorial, I just saw that I needed to drop in the folder and reload a few times

---

**coolgaie** - 2025-03-12 20:55

Which I did

---

**coolgaie** - 2025-03-12 20:55

Would be good to add an annotation or if possible

---

**vhsotter** - 2025-03-12 21:05

The documentation explains the procedure and does say to restart after installing, make sure the addon is enabled, then restart a second time. The second tutorial video has a segment of "Common Problems" at the start that also goes over that particular issue as well. In general you'll want to refer to the online documentation as it tends to be more up to date over the video.

---

**tokisangames** - 2025-03-12 21:26

It works fine on 4.4

---

**kamazs** - 2025-03-13 20:37

👋🏼 Cannot paint any foliage or sculpt terrain anymore, no texture list in the dock (see image). The terrain itself is visible and works.

> Godot Engine `v4.4.stable.mono.official` & Terrain 3D `0.9.3`

I see errors like this:

> ERROR: res://addons/terrain_3d/editor.gd:326 - Invalid call function 'update_assets' in base 'PanelContainer (asset_dock.gd)': Attempt to call a method on a placeholder instance. Check if the script is in tool mode.
> 
> ERROR: Terrain3DEditor#2539:_operate_map: Invalid brush image. Returning
>    at: push_error (core/variant/variant_utility.cpp:1098)
> 
> ERROR: res://addons/terrain_3d/src/ui.gd:260 - Invalid call function 'get_current_list' in base 'PanelContainer (asset_dock.gd)': Attempt to call a method on a placeholder instance. Check if the script is in tool mode.

I recently moved 4.3 to 4.4 but there were no issues after migration. Not sure when this happened. 

Lemme know if there are any suggestions on what to check and in what direction should I debug. This probably is my issue but no clue where to start looking (apart from bisect :D).

📎 Attachment: 2B55446F-8905-43A1-A503-560AB458615C.png

---

**tokisangames** - 2025-03-13 20:52

When starting up what errors are at the top of your console (not output)
You should be on 0.9.3a at least, if not a nightly build.
Looks like you might need to remove and reinstall. The errors posted look like the files have been changed. You need to do that to upgrade to 0.9.3a anyway.

---

**kamazs** - 2025-03-13 21:12

Just as I restarted editor one more time, the textures are back. 🤦🏼‍♂️ Will update terrain to 0.9.3a or even nightly, thanks for the suggestion.

I probably need to go through all of the warnings/errors here that spawned after 4.3 -> 4.4.

📎 Attachment: B637BFFF-3599-42A0-B102-9A317128EA27.png

---

**tokisangames** - 2025-03-13 21:15

Drop SGT. Use our extras/import_sgt script to convert to our MMI system. And you probably know 4.4 has Jolt built in.

---

**kamazs** - 2025-03-13 21:17

> And you probably know 4.4 has Jolt built in.
Yes. I explicitly removed the old one and switched to the integrated. Probably some broken reference.

---

**kirbycope** - 2025-03-14 02:57

Are there any instructions for web builds besides what I might piece together here, https://github.com/TokisanGames/Terrain3D/issues/502 ?

---

**tokisangames** - 2025-03-14 06:19

Web builds are already included in the nightly builds for testing by adventurous people. Other necessary things like shader mods are in that issue.

---

**tranquilmarmot** - 2025-03-14 06:41

Is there a way to load a `Terrain3DRegion` without referencing `terrain.data` first?
Right now I have to do:
```
terrain.data.load_region(region_location, region_data_directory, false)
var region := terrain.data.get_region(region_location)
# (do something with `region`...)
terrain.data.remove_region(region, false)

return region
```

---

**tokisangames** - 2025-03-14 06:52

It is a Godot resource file. Load() and resourceloader.Load() will do so. You can also double click the file to load it in the inspector.

---

**tranquilmarmot** - 2025-03-14 07:06

Awesome, I'll try that out! Thanks

---

**kirbycope** - 2025-03-14 15:17

So grab the build from GHA. https://terrain3d.readthedocs.io/en/stable/docs/nightly_builds.html Anything else i should know or just do a Web (Compatibility) export?

---

**coolgaie** - 2025-03-14 19:12

Are there any gis resources out there that provide data downloads interoperable with Terrain3D? I realize the textures are a completely separate matter but I’m curious how quickly I can get any kind of world map spun up to test a proof of concept for a game I have in mind.

---

**drbonestorm** - 2025-03-14 19:13

Hi, having texture issues. Have read the documentation repeatedly. I cannot figure out why I can only have a base layer texture in terrain3d, all other layers come back grey

---

**tokisangames** - 2025-03-14 19:26

Read heightmaps documentation

---

**tangypop** - 2025-03-14 19:27

I use this site: https://tangrams.github.io/heightmapper/

With it I'm able to get terrain that's accurate to about 1m so it does require some smoothing.

These screens are from a map I created by importing data from that site.

📎 Attachment: Screenshot_20250314_152459_Discord.jpg

---

**tokisangames** - 2025-03-14 19:27

Does the demo work on your machine? Compare the setup of files and Terrain3D

---

**drbonestorm** - 2025-03-14 19:28

Tha k you, did not try that, let me assess that 1st.

---

**kirbycope** - 2025-03-14 20:08

HTML OpenGL Export

---

**coolgaie** - 2025-03-14 21:07

thank you, i'll look into this

---

**mendez4607** - 2025-03-15 20:23

guyz any idea why when i am using code from generated terrain example, and using proton scatterer, i cant make it work with "Project on colliders" ? it just keeps hanging in the air, its not detecting the mesh of the ground... idk whats wrong, collision alyers should be correct, i am even trying to creating the proton scatterer node with big delay to make sure it has something to collide with

---

**tokisangames** - 2025-03-15 20:32

Did you enable editor collision for Scatter to have something to collide with?

---

**mendez4607** - 2025-03-15 20:37

yep, I am creating it actually via code, after creating the randomized terrain with noise (literally using the demo example) and just trying to basic demo rocks from scatter to "land" on the generated terrain, no succes yet, but maybe i am approaching whole scatter wrong

---

**tokisangames** - 2025-03-15 20:42

Test it by hand in our demo. But if you're doing it by code, why not just use our instancer? Scatter is an order of magnitude slower.

---

**mendez4607** - 2025-03-15 20:44

built in instancer allows only for multimesh usage and non collision objects i thought?

---

**tokisangames** - 2025-03-15 20:49

That's right. 
Well, test by hand in the demo to figure out if it's your code or not. And Scatter is gdscript, so it's easy for you to debug the code.

---

**image_not_found** - 2025-03-15 20:53

For ProtonScatter to work with Terrain3D you have to take the `project_on_terrain3d.gd` file from `addons/terrain_3d/extras/` and copy it into ProtonScatter's `addons/proton_scatter/src/modifiers`
After this you'll get a new modifier in ProtonScatter called "project on Terrain3D" and it does exactly that (it works even without enabling the terrain's editor-time collision)

---

**tokisangames** - 2025-03-15 20:54

Yes, either option works fine,  Project on Colliders + editor collision, or Project on Terrain3D + none.

---

**jamonholmgren** - 2025-03-15 21:02

Is there a guide somewhere on which of these Terrain3D source files I can exclude from my exported resources?

*Keywords for future people searching discord: "Export all resources in the project except resources checked below",  "Resources to exclude", "Filters to export non-resource files/folders", "Filters to exclude files/folders from project"*

📎 Attachment: CleanShot_2025-03-15_at_14.00.292x.png

---

**tokisangames** - 2025-03-15 21:11

All of it is for the editor plugin, except for terrain.gdextension and utils if you use them.

---

**jamonholmgren** - 2025-03-15 21:13

Meaning I can exclude everything except the `addons/bin` and `terrain.gdextension` `terrain.gdextension.uid` ?

---

**tokisangames** - 2025-03-15 21:15

Brushes, extras, icon, menu, src, tools are all editor plugin. Utils only if you need them.

---

**mendez4607** - 2025-03-15 21:16

thanks both of you, seems my issue is purely with trying to adding scatter to generated terrain, and it seems that "Project on colliders" is not being called upon adding the scatter to the scene, but already on editor level which determines the positions...

---

**mendez4607** - 2025-03-15 21:25

it works when added manually to terrain and using editor collisions, but does not if i add the very same scatterer node via code

---

**tokisangames** - 2025-03-15 21:41

Good, now you have working and non working environments to compare and narrow down on the difference. Terrain3D is the same in both, differing only by collision settings. Scatter is probably more different running in game than in the editor.

---

**jamonholmgren** - 2025-03-15 21:50

Thanks Cory! Appreciate your timely replies (I don’t expect it, but I appreciate it)

---

**mendez4607** - 2025-03-15 21:50

yeah the issue is when calling scatterer from code... the placing on terrain does not work then it seems

---

**jamonholmgren** - 2025-03-15 21:51

I did some manual scattering for trees and it works decently well. Can share my script if you want.

---

**mendez4607** - 2025-03-15 21:52

thats exactly what i am trying to do using proton scatter... i am trying to make the game fully generated, and i guess i can go around it by writing the function manually to raycast and snap to the ground but yeah.. you are using proton scatter or just manual scatte code?

---

**mendez4607** - 2025-03-15 21:53

i keep ending up with floating trees if used with scatterer via code.. other then that it works fine

📎 Attachment: image.png

---

**mendez4607** - 2025-03-15 21:53

the very same area is fine if i add very same node via editor :/

---

**mendez4607** - 2025-03-15 21:54

not even calling full_rebuild works... for some reason it does not sees the terrain as collision target if its not present on init it seems

---

**jamonholmgren** - 2025-03-15 21:55

Manual scatter via terrain.data.get_height(), but actually this isn’t generated terrain, it’s from a preexisting height map, so maybe not relevant?

---

**jamonholmgren** - 2025-03-15 21:55

Not using ProtonScatter

---

**mendez4607** - 2025-03-15 21:55

well yeah, if you can, share the code with me please, i may use it as baseline for addon specifically for my needs, definitely can be helpful

---

**mendez4607** - 2025-03-15 21:56

ProtonScatter is pretty nice but i most likely might need customization anyway that would not be possible there

---

**jamonholmgren** - 2025-03-15 21:57

Will do when I’m back at my computer.

I do plan to populate the map with generated trees, plants, roads, villages, etc, even tho the height map will likely be real world data.

My game is a combat helicopter game so you cover ground at 150mph, meaning my maps are huge and mostly viewed from that height.

---

**mendez4607** - 2025-03-15 22:49

having just special problems today.. have you ever run into 

 servers/rendering/renderer_rd/effects/fsr2.cpp:415 - Condition "p_job.uavMip[i] >= mip_slice_rids.size()" is true. Returning: FFX_ERROR_INVALID_ARGUMENT

being spammed and being unable to edit terrain?

---

**mendez4607** - 2025-03-15 22:51

ah nvm that was caused by FSR...

---

**rasho.711** - 2025-03-16 10:20

hey, is there a way to create an evenly terrain like this for an desert? i cant make it looking good because some places are even and the others are like the picture

📎 Attachment: image.png

---

**tokisangames** - 2025-03-16 10:42

What specifically is the problem? It looks a little pointy. Use the smooth tool.

---

**rasho.711** - 2025-03-16 11:24

I want it to create a randomly generated area

---

**rasho.711** - 2025-03-16 11:25

is that possible?

---

**rasho.711** - 2025-03-16 11:27

nvm

---

**rasho.711** - 2025-03-16 11:28

i found a way to do it

---

**deviousmantis_** - 2025-03-16 16:42

Hey guys, I have a 4096x4096 terrain heightmap I generated, in game tho, this is huge after importing it. Is there a way to scale the the terrain down to a specific size or is the only way to do it by scaling down the heightmap image and reimporting? another thing, with the auto generated terrain is the only way to make that terrain a specific roughness with a custom shader?

---

**xtarsia** - 2025-03-16 16:52

1. Either use vertex spacing, or scale the import images so that 1m == 1 pixel.
2. Yes, tho baking smoother/rougher data into the textures used for the background would work too.

---

**deviousmantis_** - 2025-03-16 16:55

thanks

---

**coolgaie** - 2025-03-16 17:56

Mind commenting on your approach? Feel free to make a thread if you like, I'm mostly curious

---

**rasho.711** - 2025-03-16 17:59

oh no i meant i found a way how to solve my problem :/ i saw another terrain addon where you can generate one but idk with terrain3d

---

**coolgaie** - 2025-03-16 18:00

oh ok, thank you then

---

**waterfill** - 2025-03-16 21:42

Hello, I have a question, I read the documents but I didn't understand very well. I want to use several navigation meshes for several regions to weigh less, but I want them to be close together, this overlap doesn't work and the character doesn't walk over the division between them, is there any option that makes them stick to each other?

📎 Attachment: image.png

---

**tokisangames** - 2025-03-16 22:39

You need to read the Godot docs to learn how navigation works. Read how to Debug edge connections, adjust edge connection settings. Or add navigation links.

---

**pizzoots** - 2025-03-17 01:20

help idk what i did

📎 Attachment: 2025-03-16_21-19-54.mp4

---

**pizzoots** - 2025-03-17 01:21

nvm im dumb

---

**tranquilmarmot** - 2025-03-17 01:21

Do you have two Terrain3D nodes?

---

**pizzoots** - 2025-03-17 01:21

yeah lol

---

**drbonestorm** - 2025-03-17 01:27

hEY. Wanted to let you know, there is a plugin in KRITA that will take a huge image like that and break it up for you. I(ts literally a button you push, if you get the DDS exporter from KRITA, then Terrain 3D will like that much more. Though, I am still ahving trouble with textures in terrain3d

---

**waterfill** - 2025-03-17 02:33

thankss!

---

**a_twinkle** - 2025-03-17 11:49

Would it be better to use a solid color image to draw this stylized ground texture, and then blend other textures on top of it later?

📎 Attachment: image.png

---

**tokisangames** - 2025-03-17 12:10

It would be best to have a grass, dirt, gravel textures and paint and blend them like is done in our demo and documentation.

---

**a_twinkle** - 2025-03-17 12:12

ok

---

**deprofundiis** - 2025-03-17 15:58

Hey folks, I'm slightly banging my head on the wall with this and would really appreciate the help of smarter people than me 🙂 

So the problem I have is that for the crystal presented here in this pic I'm creating the concept of "corruption zones" whereby nature gets a visual effect from the realtime position of the crystal. I've already done that on the shader side for the grass - no biggie there - but I'm slightly lost here with the terrain.

In my perfect world I'd have a function I'd call in runtime with this signature:

`func paint_texture_at_position(node: Node3D, texture_index: int, radius: float, intensity: float):`

However there's a bunch of things I'm not getting access from the Terrain3D object and also since I'm new to Godot and Terrain3D (2 weeks only of experimenting) I feel super lost.

Any tips on how to do this?

[EDIT]: forgot to say this needs to work on webgl exports

📎 Attachment: image.png

---

**tokisangames** - 2025-03-17 17:00

Webgl is experimental, and not supported yet.
Draw on the ground using the Terrain3DData API. But you probably just want to use a Decal attached to your crystal to project on everything around it.

---

**deprofundiis** - 2025-03-17 17:07

Thanks <@455610038350774273> - our projects are also experimental so, I guess we're all just figuring things out as we move forward (Godot + Terrain3D is an avenue we just had to thread).

Looking at the API as we speak

---

**computerology** - 2025-03-18 01:11

I can't find anything on editing terrain at runtime in the docs...is it possible? Use case is: I want to set height of terrain to a value in a radius around a point.

---

**computerology** - 2025-03-18 01:11

All I can find is get_editor() which returns null at runtime.

---

**tokisangames** - 2025-03-18 06:12

There's more than 10 pages of API docs, which is even built into the Godot editor. Terrain3DData.set_height()

---

**tokisangames** - 2025-03-18 06:13

Yes, the editor only runs in the editor. But that's not what you want anyway.

---

**infinite_log** - 2025-03-18 11:42

Does anyone know what does the texture Boolean do in base paint option

---

**tokisangames** - 2025-03-18 11:50

Paints textures. Without it, it paints only the other factors like uv scale, rotation

---

**infinite_log** - 2025-03-18 11:52

Oh, I see. It did not paint any texture   when disabled. Now I know.

---

**deathmetalthanatos_42378** - 2025-03-18 13:39

When I load my textures in Terrain 3D the color looks so colorful.  How can I make my Scene also Colorful ?

📎 Attachment: Bildschirmfoto_vom_2025-03-18_14-09-06.png

---

**deathmetalthanatos_42378** - 2025-03-18 13:40

the Splatmap Addon

📎 Attachment: splatmapper_v0.2.zip

---

**deathmetalthanatos_42378** - 2025-03-18 13:42

ok ok ok its just roughness ^^

---

**deathmetalthanatos_42378** - 2025-03-18 13:42

upsi

---

**deathmetalthanatos_42378** - 2025-03-18 13:49

hm.. no, Its not roughness ...

---

**deathmetalthanatos_42378** - 2025-03-18 13:51

ok, it was metallic

---

**elzewyr** - 2025-03-18 18:07

Hello, I compiled Terrain3D from the `main-godot4.4` branch with `godot-4.4-stable` godot-cpp, but I still encounter the jitter caused by physics interpolation. It is the only enabled temporal effect. Am I missing something?

---

**tokisangames** - 2025-03-18 18:36

Github already builds it for you. But since you have the source you can ensure that you are building in this filtered line.
https://github.com/TokisanGames/Terrain3D/blob/main-godot4.4/src/terrain_3d_mesher.cpp#L383
If so, the recent mesher commit may have broken it.

---

**bokehblaze** - 2025-03-18 20:26

Hey everyone ! I have a little problem... when Terrain3D node is selected I can't rotate the camera nor use brushes

---

**tokisangames** - 2025-03-18 20:27

Try the latest push

---

**tokisangames** - 2025-03-18 20:28

Restart Godot. Try the demo. Otherwise post information about your setup we obviously need to help you.

---

**bokehblaze** - 2025-03-18 20:28

the demo works fine

---

**tokisangames** - 2025-03-18 20:29

Great, so if it's just an issue in your project, you have a working and not working environment to compare and see what is different. I'd start by disabling all of your addons and enabling one at a time.

---

**bokehblaze** - 2025-03-18 20:30

Alright, thank you :)

---

**elzewyr** - 2025-03-18 20:33

It works normally now, thanks

---

**bokehblaze** - 2025-03-18 20:37

I tried disabling everything, still nothing

---

**tokisangames** - 2025-03-18 20:39

Since it works fine in our demo and it's only in your project, then some code you or others (via addons) is interfering with Godot operations. You need to determine what that is. Start a new scene in your project and add a Terrain3D node.

---

**bokehblaze** - 2025-03-18 21:03

managed to fix it by restoring an older commit👍

---

**aldocd4** - 2025-03-19 01:01

Hello. I suspect the terrain 3D extension is crashing my game when the player enter an area 3D to change map. I free the currently loaded scene containing a Terrain3D node and I load another scene containing another Terrain3D node. I can change the map 3/4 times before the crash happens.

The crash happens when I do a simple `get_tree("/root/Game").add_child(myNewInstancedScene)`

I tried to debug it on visual studio, but atm I didnt found the problem yet. I'm using latest artifactory from github actions. 
I rebuilded godot editor with debug symbols, I can see in the stacktrace that the crash happens when enter_tree is propagated for node Terrain3D and it seems to be calling the extension.

I will try to create a minimal project that will reproduce the bug.

I'm using Godot 4.4 RC1

📎 Attachment: image.png

---

**aldocd4** - 2025-03-19 01:04

And here is the stacktrace with the Godot 4.4 official build:

📎 Attachment: image.png

---

**tokisangames** - 2025-03-19 05:41

Build Terrain3D with devbuild=yes and you'll be able to track crashes into our code. Use a Godot debug to be able to track crashes into their code. For this I recommend using both as you haven't hit on a useful call stack yet until you can see a code line.

---

**aldocd4** - 2025-03-19 17:35

Ok so I builded godot and terrain3D with debug symbols, here is the stacktrace. It seems that something is corrupted after between 2 and 4 scene loading (random). 

I tried the ~10 latest builds, and the bug seems to appears on build #1184: https://github.com/TokisanGames/Terrain3D/actions/runs/13885662306

#1191 crash
#1190 crash
#1189 crash
#1188 crash
#1187 crash
#1186 no crash
#1184 crash
#1183 no crash
#1182 no crash

📎 Attachment: image.png

---

**aldocd4** - 2025-03-19 17:37

My scene is a simple button, when clicked it load the scene that contain the Terrain3D node. After between 2 and 5 clicks it crashes. 
The scene and terrain is almost empty, just 4 regions

---

**aldocd4** - 2025-03-19 17:37

FYI if I remove the data directory and leave it blank, I dont have any crash

---

**tokisangames** - 2025-03-19 17:37

Git bisect is the better way to do this to identify a commit.

---

**tokisangames** - 2025-03-19 17:41

The commit tied to that build doesn't change the region map. Also your build results are out of order, so I have to say this test is a bit inconclusive.

---

**tokisangames** - 2025-03-19 17:41

Read this https://x.com/TokisanGames/status/1833584385138036861?t=s6g2fXcmsP4uX0dWCwISGg&s=19

---

**aldocd4** - 2025-03-19 17:42

ok thanks, gonna try that

---

**tokisangames** - 2025-03-19 17:43

Also provide an mrp, ideally using the demo data.

---

**aldocd4** - 2025-03-19 18:33

$ git bisect good
`9a854e6e76daabbf4966d96d47430d6e402ff017 is the first bad commit
commit 9a854e6e76daabbf4966d96d47430d6e402ff017
Author: ****
Date:   Sat Feb 15 22:23:08 2025 +0000

Implement Terrain3DMesher, geomorphing, circular LODs, partial symmetric grid`

---

**aldocd4** - 2025-03-19 18:34

*(no text content)*

📎 Attachment: terrain_3D_crash_mrp_without_addons.zip

---

**aldocd4** - 2025-03-19 18:35

I run it with Godot_v4.4.1-rc1_win64, just run the scene and click on the tp button between 2 and 5 times slowly

---

**aldocd4** - 2025-03-19 18:36

I didn't use demo data because this MRP should be enough, it is ultra simple. Just one empty terrain and one gdscript

---

**doomlord1504** - 2025-03-19 21:28

hey im trying to import a texture using the guide video but it doesnt have a height, displasment or bump file. it does have details, flow, protrusion, soil, and color file.

---

**skyrbunny** - 2025-03-19 21:36

why is the symmetric mesh only for the higher LOD levels, and not the closest to the camera

---

**xtarsia** - 2025-03-19 21:38

So that collision mesh is 1:1 with the geometry.

Collision uses heightmapshape, which is still regular grid.

Doing trimesh was terribly slow. And making heightmapshape be symmetric requires a PR to the engine.

---

**skyrbunny** - 2025-03-19 21:41

it was my understand that the heightmap collider was just a wrapper over generating a trimesh collider.

---

**xtarsia** - 2025-03-19 21:41

Mine too, but when I looked closer its not the case.

---

**skyrbunny** - 2025-03-19 21:41

hm

---

**tokisangames** - 2025-03-19 21:56

You might be confusing a ground texture that can be painted vs an import texture for the whole terrain.

---

**doomlord1504** - 2025-03-19 21:56

what?

---

**tokisangames** - 2025-03-19 21:56

For ground textures, if you don't have height, you'll be unable to use height blending with this texture. Pick a different texture source, or generate heights from luminance (in our channel packer).

---

**doomlord1504** - 2025-03-19 21:59

in my game the floor is a bunch of black and white boxes and I thought adding a grass texture would fix that.

---

**tokisangames** - 2025-03-19 22:00

You can see in the demo, adding ground texture sets indeed disables the checkerboard pattern.

---

**skyrbunny** - 2025-03-19 22:00

could there be a PR? It looks simple enough, I just don't know the index order of a symmetrical mesh

---

**xtarsia** - 2025-03-19 22:26

https://github.com/godotengine/godot/compare/master...Xtarsia:godot:heightmapshape_alternating_grid

and then similar in the jolt version.

Needs to be an option, maybe a checkbox type thing.

I just need to sort those bits, make the PR, and then wait 6 months for it to get merged 😄

---

**pizzoots** - 2025-03-19 22:33

whats causing all these bumps in the terrain? is it just because im using too big of a brush?

📎 Attachment: image.png

---

**xtarsia** - 2025-03-19 22:37

yeah, shift + click will smooth it.

---

**xtarsia** - 2025-03-19 22:54

Yep this crashes very consistently.

---

**xtarsia** - 2025-03-19 22:55

removing navigation and disabling collision still crashes too

---

**hartecycle** - 2025-03-19 23:09

probably a stupid question, when using the tool with a square brush the square oscillates (rotates) around when using it.  How do I get it to stop doing this?

---

**hartecycle** - 2025-03-19 23:09

Which makes is hard to get straight edges

---

**vhsotter** - 2025-03-19 23:09

If you look at the toolbar at the bottom for the brush settings there should be a jitter you can set to zero.

---

**vhsotter** - 2025-03-19 23:11

You may have to click the three dots on the far right to access that.

---

**hartecycle** - 2025-03-19 23:13

yeah

---

**hartecycle** - 2025-03-19 23:13

clicked on the 3 doits

---

**hartecycle** - 2025-03-19 23:13

dots that it, thanks for your help

---

**hartecycle** - 2025-03-19 23:13

surprised I got a reply so quickly

---

**hartecycle** - 2025-03-19 23:14

Its a pretty cool tool, but after using it for a bit I realize there is quite a bit of artistry to make the terrain look good

---

**vhsotter** - 2025-03-19 23:15

It is definitely a practiced skill.

---

**hartecycle** - 2025-03-19 23:16

I'm trying to make an rts game, textures are way better than a flat ground color, but I think until I add a lot of props to the map it won't look good

---

**tokisangames** - 2025-03-19 23:28

\_material->update_ maps() is called by data->initialize, load_directory() before _material is initialized.

---

**tokisangames** - 2025-03-19 23:29

True for all of gamedev

---

**xtarsia** - 2025-03-19 23:39

update_maps() should just return void if it hasnt been initialized yet, as its _terrain will be nullptr at that point?

---

**xtarsia** - 2025-03-19 23:44

is it worth noting that the MRP script is calling .free() rather than .queue_free() ?

---

**xtarsia** - 2025-03-19 23:45

it doesnt crash with queue_free() BUT other visual bugs happen instead

---

**xtarsia** - 2025-03-19 23:45

*(no text content)*

📎 Attachment: image.png

---

**aldocd4** - 2025-03-19 23:46

initially my game was working with queue_free, it was crashing

---

**aldocd4** - 2025-03-19 23:46

but yes in that MRP the bug is different with queue_free

---

**xtarsia** - 2025-03-19 23:52

looks potentially like z fighting between un-freed RS rids from the old scene - which shouldnt happen as clear up is quite thorough(at least I thought it was). But for now, i gotta sleep.

---

**xtarsia** - 2025-03-20 00:01

```        if old_map:
            old_map.get_parent().remove_child(old_map)
            old_map.queue_free()
```
this fixes/avoids the problem.

watching logs when clicking the button showed that queue_free() was only resulting in destroy logs 50% of the time O_O.

---

**xtarsia** - 2025-03-20 00:02

the issue now is why free() / queue_free() aren't being handled correctly 50% of the time.

---

**little7om** - 2025-03-20 00:15

`var falloff_value : float = combined_height * minf(falloff_profile.sample(x / float(heightmap.get_width())), falloff_profile.sample(y / float(heightmap.get_height())))`

📎 Attachment: image.png

---

**little7om** - 2025-03-20 00:16

Hi, getting weird issue as shown above, the falloff doesn't seem to be working on one edge of the terrain, plus the flat world background is missing. Not really sure what I might be doing wrong.

---

**little7om** - 2025-03-20 00:17

terrain is procedurally generated 8192m squared with a region size of `Terrain3D.SIZE_256`.

---

**tokisangames** - 2025-03-20 00:32

World background is enabled in your material.

---

**tokisangames** - 2025-03-20 00:32

What does this falloff do? We have no such thing in Terrain3D.

---

**little7om** - 2025-03-20 00:33

I posted the line above that applies falloff to the combined FastNoiseLite values based on the width and height of the heightmap image.

---

**tokisangames** - 2025-03-20 00:35

Is the falloff visible in your produce noise map that you are importing into Terrain3D?

---

**tokisangames** - 2025-03-20 00:37

You ate using the maximum boundary limits of the terrain. Is your falloff getting cutoff, outside the world limits? Visible with gizmos on.

---

**little7om** - 2025-03-20 00:40

Do I need to make the terrain generator script a @tool script to see gizmos?

---

**little7om** - 2025-03-20 00:41

I don't add the terrain3D node in the editor, I create it in the script

---

**tokisangames** - 2025-03-20 00:47

Perspective / view gizmos

---

**little7om** - 2025-03-20 00:47

The falloff and world backgrounds are generating fine in editor after making it a @tool script

---

**tokisangames** - 2025-03-20 00:47

Right. No gizmos in game. So just figure it with math then.

---

**tokisangames** - 2025-03-20 00:49

Either way, the question remains, is your falloff visible within the generated noise map that is being imported. You can write it to a png and look at it.

---

**little7om** - 2025-03-20 00:59

Falloff is being applied correctly to heightmap image

---

**little7om** - 2025-03-20 00:59

It is visible on all sides of the heightmap image when exported to png

---

**little7om** - 2025-03-20 01:01

Not really sure what this means, how would the gizmos being present affect how the terrain is generated?

---

**little7om** - 2025-03-20 01:07

Turning on and off the gizmos in editor doesn't have an effect on the terrain, even when reloading the scene

---

**tokisangames** - 2025-03-20 01:17

Now manually import it and see if you get the expected results.

---

**tokisangames** - 2025-03-20 01:17

Gizmos show the outward border just for a visual representation of where it is.

---

**little7om** - 2025-03-20 02:03

imported terrain seems fine

---

**godotpanda** - 2025-03-20 06:04

Hi I just dled the addon 0.9.3 and run the demo scene in godot 4.4, In some rare occasions, the pawn player capsule dropped into the terrain below ground level when hitting the border black wall repeatedly.
Am I doing something wrong or is it a bug with the demo scene?
Thankd.

---

**tokisangames** - 2025-03-20 06:38

So it's likely an issue with your code. Our importer.gd and codegenerated.gd show examples of using the API correctly.

---

**tokisangames** - 2025-03-20 06:40

Read the collision doc. Godot physics isn't perfect, and trying to force physics can break it. You can try jolt, or add a secondary get_height call to your player to prevent dropping due to faulty physics.

---

**godotpanda** - 2025-03-20 07:14

Thanks, I will give jolt3d a shot, godot homebrew 3d physics is indeed a pita.

---

**raphmoite** - 2025-03-20 07:46

Hey guys, Am i missing something very important in regards to the terrain's collision? Sometimes my characterbody3d's capsule collision clips through some parts of the terrain. Here in the screenshot, the wheels do respect collisions and move over the ground perfectly but the floor doesn't look right. Must I use the smoothing tool to avoid these? Just asking to clarify, thank you.

📎 Attachment: image.png

---

**tokisangames** - 2025-03-20 07:58

Version of Terrain3D? Sometimes the character clips through, your wheels are perfect? Why doesn't the floor look right? I don't understand. Is your player the wagon? What does the collision on your object look like? You can visualize the terrain collision.

---

**raphmoite** - 2025-03-20 08:09

version 0.9.2, is this much clearer now? The cart is a rigidbody3d. Don't worry about the grass. On the 2nd image, you can see the collision of the ground doesnt align with the floor visually.

📎 Attachment: image.png

---

**tokisangames** - 2025-03-20 08:15

Please upgrade to the last released or a nightly build. Can't support ancient versions. These bugs could have been fixed a year ago. If the collision doesn't align with the ground it's likely Terrain3D can't find your camera because  you're doing something special with it, like using viewports. It would tell you this on the console and to use Terrain3D.set_camera().

---

**raphmoite** - 2025-03-20 08:17

wait how ancient is this version im on? Okay i just saw the last commit of this version. Thanks again btw.

---

**tokisangames** - 2025-03-20 08:28

Look at the gh releases for the date.

---

**sinfulbobcat** - 2025-03-20 18:45

is this checker texture available in the source code?

📎 Attachment: image.png

---

**jamonholmgren** - 2025-03-20 18:59

I might be missing something obvious (looked at the docs for a while now), but how do I get the bounds (corner global location Vector3Ds) of the map?

I suppose getting all [region_locations](https://terrain3d.readthedocs.io/en/latest/api/class_terrain3ddata.html#class-terrain3ddata-property-region-locations) and then finding the min/max x/z values?

---

**spyrowastaken** - 2025-03-20 19:05

Greetings, i have a simple question:

Can i create floating islands with terrain 3d?
I am trying to create a platformer game set in an archepelago of sky islands and i have been trying to figure out a good way to create them.

---

**vhsotter** - 2025-03-20 19:11

It's kinda possible. Someone demonstrated it in the showoff channel here: https://discord.com/channels/691957978680786944/1185492572127383654/1272733866750120097

---

**spyrowastaken** - 2025-03-20 19:12

<:hmmm:609911633078124558> huh. Interesting trick!

---

**spyrowastaken** - 2025-03-20 19:12

Cheers for the reference!

---

**tokisangames** - 2025-03-20 19:19

Checkerboard shader. Of course it's in the source.

---

**tokisangames** - 2025-03-20 19:21

32*region_size, then centered
https://terrain3d.readthedocs.io/en/latest/docs/introduction.html#regions

---

**sinfulbobcat** - 2025-03-20 19:43

oh it's a shader? thanks for clarifying

---

**sinfulbobcat** - 2025-03-20 19:43

i was thinking about making a checkerboard texture with normals, so was trying to find the texture for this

---

**image_not_found** - 2025-03-20 19:55

You can make one easily though, create a 4x4 image in gimp, draw a checkerboard pattern, then upscale it to say 1024x1024 using nearest filtering and that's it

---

**tokisangames** - 2025-03-20 20:26

There are two checkerboard patterns we use. When you have no textures it turns on the checkerboard debug view, which is a shader. When you add new textures, it generates a checkerboard texture, which you could save to a file. Either way the source code for both is in the repo.

---

**m4rr5** - 2025-03-20 20:45

There are also a bunch of similar shaders here:
* https://godotshaders.com/shader/prototype-grid/
* https://godotshaders.com/shader/dashed-grid-the-best-darn-grid-shader-yet/
* https://godotshaders.com/shader/infinite-ground-grid/

---

**spyrowastaken** - 2025-03-21 01:04

So i figured out how to make the islands themselves

---

**spyrowastaken** - 2025-03-21 01:04

but i have encounred the issue of the terrain not adhering to the transform hierachy of other nodes

---

**spyrowastaken** - 2025-03-21 01:05

I have this scene that contains 2 terrain node (one for the bottom and one for the top)

📎 Attachment: image.png

---

**spyrowastaken** - 2025-03-21 01:05

This scene is saved separtely and is used as part of the level.

---

**spyrowastaken** - 2025-03-21 01:05

The issue that im having is that this terrain resets back to world origin when viewed from the parent scenes

---

**spyrowastaken** - 2025-03-21 01:06

Such as:

📎 Attachment: image.png

---

**spyrowastaken** - 2025-03-21 01:07

As such, i must ask if there is a way to fetch the parent-child data and somehow make sure that the terrain adheres to said data. If thats possible, then scenarios like this would be resolved and thus allow for the ability to create content like the way i am doing now.

---

**tokisangames** - 2025-03-21 05:38

Transforms are disabled. Make the terrain where you want it to exist in world space.

---

**sinfulbobcat** - 2025-03-21 06:39

thanks this is really helpful!

---

**athul1357** - 2025-03-21 10:23

I'm having an issue when tried to export the project to android, my phone is S20 FE android version 12, the textures are not applied to the terrain, everythings else works fine only issue with texture,  it shows only blank [https://imgur.com/a/GFOBaBq], tried lossless, uncompressed and all but same result, using zylann's terrain plugin i got no issues all works fine, i want to use the terrain3d plugin. pls help me out.

---

**tokisangames** - 2025-03-21 10:51

What version of Terrain3D? What renderer? Which android binary are you using eg arm64? Does our demo export properly? Zylann's terrain doesn't use texture arrays and isn't relevant to this issue.

---

**_zylann** - 2025-03-21 11:20

Do GPUParticles work with Terrain3D? I was asked if they do with my voxel terrain but I realize I have no idea if Godot just makes it "work" or if does assumptions about how the scene is made (like maybe meshes having gone through the Godot 3D model importer, which is of course not the case for terrain systems I worked on)
Had a look at `GPUParticlesCollisionSDF3D` and it's quite terrifying to think about it for voxel terrains^^"

---

**spyrowastaken** - 2025-03-21 11:27

That will unfortunately not work for me as many sections of the level are composed individually. If I were to create the terrain in world space, it would make level iteration nearly impossible for me.

I guess I'll find another solution, cheers for the help thus far.

---

**tokisangames** - 2025-03-21 11:28

GPUParticles3D is independent of terrain, it's just a node that just emits particles (like the waterfall if you've played our OOTA demo). It can interact with colliders. But not what you want.
Your user is likely asking about a particle shader. That is also independent from your terrain shader, but something they can add. It can be added to most terrains. They'll need the means to access heights and positions in the shader. Passing in the heightmap as a uniform is easy. Doing it on a voxel terrain will create a creative challenge. 
See https://discord.com/channels/691957978680786944/1219611622595891271/1219651785455702130

---

**tokisangames** - 2025-03-21 11:31

If you don't move your terrain at runtime, ours works fine. We have a world with many assets saved in separate scene files and edit on the terrain. We iterate with a team of several people without issue.

---

**tokisangames** - 2025-03-21 11:33

What must be done is having subscenes attached to a master scene that has the terrain. Then you can `make local` a scene, edit it, and `save as branch` back to the file. Then you can have quite large sections of your world with assets grouped by areas. I made a tool script that does these steps on demand, so my team can load, save, and unload in the editor. But doing it manually isn't much issue.

---

**_zylann** - 2025-03-21 11:33

Looks like grass though, I use something else for that already. My user asked about making GPUParticles collide with the terrain, like I imagine rain or droplets running down slopes/tunnels or whatever. Saw `GPUParticlesCollisionSDF3D` for that, but it sounds like yet another case of "voxel can't take the shortcuts heightmaps can and it's runtime-generated so it will cost you an arm" situation xD For heightmap there is `GPUParticlesCollisionHeightField3D`, which in this case is much easier, but yeah cant use that, or only use as approx

---

**spyrowastaken** - 2025-03-21 11:35

And that's fine. However, if I want to create new terrain that can be anywhere in the scene, I'd need a way to tie the terrain with the parent node so that they can align themselves properly.

Take my image example. The saved section maybe be composed at origin but I moved it down in the final level as part of the layout.

Not allowing transform hierarchies makes this process way more complicated and tedious than it should be imho.

---

**spyrowastaken** - 2025-03-21 11:36

Given your statement, I'd need to somehow shift the entire heightmap for both sections down and then compose the island there. It would be a huge undertaking and it would take time that I'd spend on other things.

---

**tokisangames** - 2025-03-21 11:37

I see, I misunderstood. For emission colliders, we would use the heightfield, but haven't been asked about it yet. Yeah, you'll need to make some SDF colliders. 😬

---

**xtarsia** - 2025-03-21 11:39

GPUParticlesCollisionHeightField3D, could be tied in to the current dynamic collision?

---

**xtarsia** - 2025-03-21 11:40

Tho it doesnt help Zylann's voxel situation

---

**tokisangames** - 2025-03-21 11:56

I won't get into the details of the technical decision. I understand the workflow you want. That works well for a chunked terrain. But that's not what Terrain3D is. That workflow isn't necessary, and wouldn't be optimal. If you can adjust your thinking on it, there are other workflows that work fine and are not tedious.

I understand you have multiple terrain nodes. To combine them into one world, the options are either place the region files in one directory and rename them to the appropriate coordinates - as long as they're all the same region size. Or export the data, combine in photoshop and reimport. This will be the most time consuming, but not bad. Probably less than an hour.

Then your scenes have objects placed on the terrain. Even 100k nodes in each can be moved in few minutes. You know the data offset. If it's all moved 2x256 regions, it's 512x512. Make sure all of the nodes are children of a node3d. Move that one node by 512, 0, 512 and everything goes back in place. You can unparent them and they'll stay there if desired. Save those nodes off as a scene or whatever you like.

So a process yes, but not a huge undertaking. We have nearly 100k nodes in 15-20 subscenes and I've offset all of them in a few hours. For smaller scenes it could be done in a few minutes.

---

**athul1357** - 2025-03-21 11:59

terrain v0.9.3a which was available in godot assetlib , renderer is mobile, android binary is arm64v8a,tried other binary and another old phones too, still same issue, demo also has the same issue when exported, when i tried to add the file from github , shows parse error and cannot enable the plugin. ```
SCRIPT ERROR: Parse Error: Too many arguments for "get_intersection()" call. Expected at most 2 but received 3.
          at: GDScript::reload (res://addons/terrain_3d/src/editor_plugin.gd:187)
ERROR: Failed to load script "res://addons/terrain_3d/src/editor_plugin.gd" with error "Parse error".
   at: load (modules/gdscript/gdscript.cpp:2936) 
```

---

**tokisangames** - 2025-03-21 12:00

Godot version? We have multiple people working fine on android.

---

**tokisangames** - 2025-03-21 12:01

You cannot download source code from github and run it without compiling it. Read Building From Source if that's what you want, but it isn't. You will get more use out of reading the Nightly Builds document.

---

**tokisangames** - 2025-03-21 12:03

You've enabled `Import ETC2 ASTC` as the docs say?

---

**athul1357** - 2025-03-21 12:09

yes, i have enabled ETC2 ASTC, godot 4.3 is the version i use.

---

**tokisangames** - 2025-03-21 12:12

Try our demo only until you make progress, using Godot 4.4 and a nightly build of Terrain3D. A white terrain would indicate a broken shader. Black suggests the phone can't read the textures, which may be an issue with texture arrays, or import or export settings. The way our demo textures are setup has been fine for other android users. You'll need to explore the other export and project settings to see if you can get the right combination.

---

**tokisangames** - 2025-03-21 12:13

What I would do is run the android version of godot on your phone so you can actually look at and adjust logs and texture configuration on the device to figure out what the issue is.

---

**athul1357** - 2025-03-21 12:53

tried i android mobile godot 4.4, and the nightly build of the latest , the terrain is all black. I have tried reimporting the textures in all different options, in project settings tried lossless compression, tried changing texture filter, could you tell me any options that i must try out in project settings or import settings.

---

**tokisangames** - 2025-03-21 13:22

I don't know what your device needs beyond the things already mentioned. You can see the Godot editor and Terrain3D running on an android here. https://discord.com/channels/691957978680786944/1185492572127383654/1262826703860928542
Using the android editor will give you more information and controls to test.

---

**athul1357** - 2025-03-21 13:49

tried other in other phones, it just works fine, issue is with s20 fe, s23 fe. Thanks

---

**raziid** - 2025-03-21 13:55

is there an intended path for modifying Terrain3DMeshAsset resource properties not shown in the inspector? the docs say you can edit way more properties than are shown in the inspector all I see in the inspector is the first section but in the docs (2nd image) there appears to be more property groups available for editing.

📎 Attachment: image.png

---

**tokisangames** - 2025-03-21 13:58

Strange. Maybe it needs a driver/os update.

---

**tokisangames** - 2025-03-21 14:00

You're looking at docs for a different version than you're using. Either look at the older version of the docs, or use a nightly build.

---

**raziid** - 2025-03-21 14:01

sweet, ill update to latest. thanks

---

**melgibzon** - 2025-03-21 16:49

What should you do when you get a seam where the grid is stiched together?

---

**melgibzon** - 2025-03-21 16:49

*(no text content)*

📎 Attachment: image.png

---

**melgibzon** - 2025-03-21 16:49

*(no text content)*

📎 Attachment: image.png

---

**xtarsia** - 2025-03-21 16:50

Its fixed in nightlys, and will be included in the next release.

---

**melgibzon** - 2025-03-21 16:50

also  simple grass doesnt work on the terrain for some reason (heard in one tutorial video it does)

📎 Attachment: image.png

---

**xtarsia** - 2025-03-21 16:51

imo, Its better to use the built in instancer for grass with Terrain3D.

---

**melgibzon** - 2025-03-21 16:52

I took the shader out and just added the grass png to terrain3ds scatter system

---

**melgibzon** - 2025-03-21 16:53

and then reapplied grasshader with wind from simple grass textured

---

**melgibzon** - 2025-03-21 16:54

*(no text content)*

📎 Attachment: image.png

---

**melgibzon** - 2025-03-21 16:54

now it places fine, otherwise if i use it ony the terrain it refuses to plant them

---

**melgibzon** - 2025-03-21 16:57

yeah no wind though

---

**melgibzon** - 2025-03-21 16:57

simple grass has wind

---

**melgibzon** - 2025-03-21 16:57

*(no text content)*

📎 Attachment: 2025-03-21_18-56-21.mp4

---

**melgibzon** - 2025-03-21 16:58

currently took simple grass shader and put it on 3dterrain to get the wind to use 3dterrain scatter with wind

---

**melgibzon** - 2025-03-21 16:58

*(no text content)*

📎 Attachment: grassshader_wind.txt

---

**melgibzon** - 2025-03-21 17:00

modifier the code a bit so it doesnt use the movement maps, but still has base of grass not move from ground

---

**melgibzon** - 2025-03-21 17:00

just need png for plants

---

**tokisangames** - 2025-03-21 18:43

SGT works fine if you enable collision in the editor. It is expected that you add wind, player interaction, and anything else you want to your own object material, as described in the instancer doc. We provide the instancer, you provide the object and its material.

---

**melgibzon** - 2025-03-21 18:44

Ye that was intuitive to figure out

---

**melgibzon** - 2025-03-21 19:04

*(no text content)*

📎 Attachment: 0001-0827.mp4

---

**melgibzon** - 2025-03-21 19:04

The issue is that every custom mesh i put in to godot

---

**melgibzon** - 2025-03-21 19:05

i can use simplegrass addon

---

**melgibzon** - 2025-03-21 19:05

but for some reason it projects weird and doesnt do anything when i want to scatter it on terrain3d

---

**melgibzon** - 2025-03-21 19:05

even when completely flat

---

**melgibzon** - 2025-03-21 19:07

but I can see that it tries to project on to it very streched

📎 Attachment: image.png

---

**melgibzon** - 2025-03-21 19:07

just nothing happens when i click

---

**tokisangames** - 2025-03-21 19:10

As I wrote, enable editor collision to get SGT to work. Terrain3D/collision/collision_mode. Read the collision page in our docs. But you should not use SGT. Our system is far faster and better in every way. If you still want to use SGT, we can't really help you with it. Collision mode turns on the colliders so SGT can place on the terrain, and that's all we can do. If SGT isn't working right, you'll need to get help from the author.

---

**melgibzon** - 2025-03-21 19:13

That works nice, I was dumb now im smarter

---

**melgibzon** - 2025-03-21 19:13

allready Ripped that addon and used your system though 😄

---

**sinfulbobcat** - 2025-03-23 18:25

is this a bug, or am i doing something wrong? this is just during me painting some terrain

📎 Attachment: image.png

---

**tokisangames** - 2025-03-23 18:41

https://terrain3d.readthedocs.io/en/latest/docs/getting_help.html#help-us-help-you

---

**sinfulbobcat** - 2025-03-23 18:49

> A concise description of the problem, what you expect to happen, and what is happening.
A have been trying to paint a section of the terrain using the Set Height brush, it works normally, but I get these errors as soon as I start painting.
> The exact version of Godot and of Terrain3D you’re using.
Godot 4.4 Stable(steam). Terrain 3D 0.9.3a
> Your Operating system and GPU.
Windows, No discrete GPU. AMD Ryzen 5 7600 APU.
> Confirmation of, or a screenshot of your Project Settings / Plugins screen to show that Terrain3D is enabled, and what other plugins you have.
Yes its enable ( _trust me bro_)
> A screenshot or copy of all text in your console, beginning with the initial Godot Engine startup message.

📎 Attachment: message.txt

---

**sinfulbobcat** - 2025-03-23 18:50

I couldn't get it to replicate the infinite repeating behaviour tho

---

**vhsotter** - 2025-03-23 18:58

A quick bit of clarification, the console isn't the output window in Godot. The documentation refers specifically to the CLI console for which there is a build of Godot that launches that alongside the editor. It can often contain more information than the editor's output window.

---

**sinfulbobcat** - 2025-03-23 19:01

i don't have that open with my godot editor, maybe because of my godot is from steam.

---

**sinfulbobcat** - 2025-03-23 19:02

im sorry, I'll send the correct one as soon as I get my hands on my pc

---

**vhsotter** - 2025-03-23 19:05

Yeah I just had a look. Doesn't look like the Steam version comes with the executable to also launch the console.

---

**image_not_found** - 2025-03-23 19:12

In that case, open the command prompt and run the version you have from that

---

**image_not_found** - 2025-03-23 19:12

Then everything gets logged in there

---

**tokisangames** - 2025-03-23 19:18

Do you get this error after restarting Godot? Do you get it in our demo? Does it occur on the other tools? Does it always happen? Does it occur with every brush? Try a nightly build.

---

**sinfulbobcat** - 2025-03-23 19:19

yes, haven't tried yet, nope, yes, set height and raise brush gave me this issue, alright.(in order)

---

**tokisangames** - 2025-03-23 19:20

```ERROR: vmaCreateImage failed with error -2.
  ERROR: servers/rendering/rendering_device.cpp:1023 - Condition "!texture.driver_id" is true. Returning: RID()
  ERROR: servers/rendering/renderer_rd/storage_rd/texture_storage.cpp:948 - Condition "texture.rd_texture.is_null()" is true```

You have a problem with your video card / drivers / godot. Update your drivers.

---

**sinfulbobcat** - 2025-03-23 19:21

i think I might have figured out the trigger. It happens when I by mistake try to sculpt on uninitialized terrain. It initializes a part of the terrain(a square), then it just removed the sculpting from the terrain altogether, but it reappears after I initialize another sqare part of the terrain

---

**sinfulbobcat** - 2025-03-23 19:22

My driver's are upto date, might need to tried downgrading godot.

---

**tokisangames** - 2025-03-23 19:22

```In Godot, the function vmaCreateImage() is used for creating Vulkan images with the Vulkan Memory Allocator (VMA).  ```

We don't control this. Vulkan allocation is between Godot and your driver.

---

**tokisangames** - 2025-03-23 19:23

Region. Hit the 3 dots menu and disable automatically create regions

---

**sinfulbobcat** - 2025-03-23 19:23

can this be a vram issue?

---

**tokisangames** - 2025-03-23 19:23

User task manager and check if you're running out

---

**sinfulbobcat** - 2025-03-23 19:23

alright thanks a lot, appreciate it👍

---

**kspplayer** - 2025-03-23 19:46

I'm working on textures for the terrain and It doesnt show it in the viewer It looks fine in GIMP but not in Godot any tips?

📎 Attachment: image.png

---

**kspplayer** - 2025-03-23 19:47

the normal one looks fine

📎 Attachment: image.png

---

**kspplayer** - 2025-03-23 19:47

(im new to godot and all of this stuff)

---

**vhsotter** - 2025-03-23 19:49

It's because of the alpha channel. That's usually normal-looking. It'll look different a lot of times between Godot and whatever photo editor you're using.

---

**tokisangames** - 2025-03-23 19:58

Looks like a texture with alpha. Does it work on the ground?

---

**kspplayer** - 2025-03-23 20:03

It turns the entire baseplate white

---

**kspplayer** - 2025-03-23 20:03

when I insert it into the scene

---

**tokisangames** - 2025-03-23 20:04

That's because it's a different format or size then the others, as the error messages tell you.

---

**kspplayer** - 2025-03-23 20:04

thank you

---

**melgibzon** - 2025-03-23 20:09

Thats one of two reasons, wrong size or sometimes the compressed to vram or detect 3d settings are different when you drag a texture to your project

---

**melgibzon** - 2025-03-23 20:09

I had two diffuse maps but when i clicked on import tab godot automatically gave bith different import settings and caused it to be white

---

**melgibzon** - 2025-03-23 20:10

When i made both import settings identical white issue disapeared

---

**melgibzon** - 2025-03-23 20:10

Then pressed reimport

---

**tokisangames** - 2025-03-23 20:10

Import settings change the format

---

**melgibzon** - 2025-03-23 20:12

I tried switching up textures deleted all textures and then imported the ine that caused all to be white

---

**melgibzon** - 2025-03-23 20:12

And figured out it was wring import settings

---

**melgibzon** - 2025-03-23 20:13

Always a good anchor when one texture works other turns white

---

**melgibzon** - 2025-03-23 20:13

Open both up and look at import settings

---

**kspplayer** - 2025-03-23 20:14

would this be causing problems or is it normally like this

📎 Attachment: image.png

---

**melgibzon** - 2025-03-23 20:14

Normal should be purple

---

**melgibzon** - 2025-03-23 20:14

Thats height or non color displacement or ambient occlusion

---

**melgibzon** - 2025-03-23 20:15

They go from 0 to 1, 0 is none and 1 is full

---

**melgibzon** - 2025-03-23 20:15

So black and white

---

**kspplayer** - 2025-03-23 20:16

this is they way the file looks in the photo editor

📎 Attachment: image.png

---

**kspplayer** - 2025-03-23 20:16

idk why it changed

---

**melgibzon** - 2025-03-23 20:17

Where did u get texture from? Ambient cg? Fab?

---

**melgibzon** - 2025-03-23 20:17

Try with ambuent cg

---

**melgibzon** - 2025-03-23 20:17

Ambientcg one

---

**kspplayer** - 2025-03-23 20:20

I used Polyhaven which was in the tutorial video but I'll try Ambientcg and get back to you

---

**tokisangames** - 2025-03-23 20:20

What's the format of the existing textures? Adjust the file or import settings to match.

---

**tokisangames** - 2025-03-23 20:23

This image shows a dds for albedo, and a png for normal. Fine if all albedos are the same, eg dxt5, and all normals are the same. Not if you have one that's different. You need to check them all and adjust.

---

**melgibzon** - 2025-03-23 20:26

Terrain 3d has a demo level with 2 textures set up that work out of the box

---

**melgibzon** - 2025-03-23 20:26

Its in addons and demo textures folder

---

**melgibzon** - 2025-03-23 20:26

Drag rhise demo textures to your own project and see if it still gives white or an error

---

**melgibzon** - 2025-03-23 20:26

If u use those textures included

---

**melgibzon** - 2025-03-23 20:27

They are allready channel packed if i understand correctly

---

**melgibzon** - 2025-03-23 20:27

If thise textures work fine

---

**melgibzon** - 2025-03-23 20:27

Your textures are packed or imported wrong

---

**melgibzon** - 2025-03-23 20:29

Its a grass and a rock Texture

---

**kspplayer** - 2025-03-23 21:09

Ok I believe I did it right this time

📎 Attachment: image.png

---

**kspplayer** - 2025-03-23 21:10

I used Ambientcg texture this time

---

**kspplayer** - 2025-03-23 21:12

nvm its still being weird

---

**melgibzon** - 2025-03-23 23:32

click this

---

**melgibzon** - 2025-03-23 23:32

*(no text content)*

📎 Attachment: image.png

---

**melgibzon** - 2025-03-23 23:33

then this appears

---

**melgibzon** - 2025-03-23 23:33

*(no text content)*

📎 Attachment: image.png

---

**melgibzon** - 2025-03-23 23:34

*(no text content)*

📎 Attachment: image.png

---

**melgibzon** - 2025-03-23 23:35

messa around with that

---

**melgibzon** - 2025-03-23 23:35

ops dont make it ortho

---

**melgibzon** - 2025-03-23 23:35

just insert texture in there

---

**melgibzon** - 2025-03-23 23:35

it will pack it

---

**melgibzon** - 2025-03-23 23:35

it will prompt you twice

---

**melgibzon** - 2025-03-23 23:36

save first one and second one

---

**melgibzon** - 2025-03-23 23:36

then use them later in yourland

---

**melgibzon** - 2025-03-23 23:36

voila fixed

---

**melgibzon** - 2025-03-23 23:36

you can generate the height map

---

**melgibzon** - 2025-03-23 23:36

using generate height from luminance

---

**melgibzon** - 2025-03-23 23:37

*(no text content)*

📎 Attachment: image.png

---

**melgibzon** - 2025-03-23 23:37

if its not included

---

**melgibzon** - 2025-03-23 23:37

otherwise u se materialize

---

**melgibzon** - 2025-03-23 23:37

or online heightmap generator

---

**melgibzon** - 2025-03-23 23:38

its really like a

---

**melgibzon** - 2025-03-23 23:38

Bring a friend to get in to the event for free

---

**melgibzon** - 2025-03-23 23:39

get first two textures left to rigth

---

**melgibzon** - 2025-03-23 23:39

and get bottom textures left from right

---

**melgibzon** - 2025-03-23 23:41

none of their friends were invited

---

**melgibzon** - 2025-03-23 23:41

but you pack them in there

---

**melgibzon** - 2025-03-23 23:41

to make the 8 bit and less detail

---

**melgibzon** - 2025-03-23 23:41

intead of having all textures seperately

---

**melgibzon** - 2025-03-23 23:42

( my pesant lknowledge)

---

**cirebrand** - 2025-03-24 23:53

Anyone know if this issue is fixed in a later build?

📎 Attachment: 2025-03-24_18-52-47.mp4

---

**cirebrand** - 2025-03-24 23:54

navigation view / tool removes the noise texture and the terrain disappears

---

**tokisangames** - 2025-03-25 06:34

First I've seen it. You'll have to try the latest commit. Please do so ASAP, as well be releasing soon. Your console probably has error messages.

---

**tranquilmarmot** - 2025-03-25 06:57

Any advice on dealing with holes + LODs? Seems like no matter what I try, at larger LODs the holes get huge

📎 Attachment: Screen_Recording_2025-03-24_at_11.56.19_PM.mov

---

**maker26** - 2025-03-25 06:58

seems like lods don't respect the location of boundary vertices

---

**tokisangames** - 2025-03-25 07:01

That's the nature of the clipmap. See the wireframe. Add rocks around the hole.

---

**tranquilmarmot** - 2025-03-25 07:02

"Add rocks" was what I was thinking 😅  should paper over it decently when further away. I suppose I could also lower the geometry around it to "hug" the tunnel a little better.

---

**vhsotter** - 2025-03-25 07:10

I see this technique used everywhere in all sorts of games. The first immediate thing that comes to mind is World of Warcraft. Everywhere there's a cave entrance the opening is either very thick around the edges where it intersects with the terrain or there's rocks and stuff smushed all together around it.

---

**xtarsia** - 2025-03-25 08:16

Having custom control map mipmaps helps this situation, as the hole won't propagate down all the way as mip level increases.

---

**tranquilmarmot** - 2025-03-25 08:51

Is that possible with Terrain3D? It seems like painting the terrain applies to all mipmap levels but maybe I'm wrong

---

**xtarsia** - 2025-03-25 09:01

Its 100% possible, already have a prototype setup.

---

**xtarsia** - 2025-03-25 09:22

To be clear, there's no extra geometry. Its just creating mipmaps for the control map, and accessing them based mesh scale in vertex, or the region derivatives in fragment.

---

**jakobismus** - 2025-03-25 11:56

Is there a way to remove a specific mesh and not just all of the same id/in the same region? I'm making a procedural generator and I don't want hand-placed meshes to be cleared when I regenerate
Seems like adding a dedicated mesh is the only way?

---

**tokisangames** - 2025-03-25 12:43

Remove the specific transform from the data and update_mmis. There is no way currently to distinguish between meshes placed by the API or by hand (which uses the API).

---

**tokisangames** - 2025-03-25 12:47

Also please see [this discussion](https://github.com/TokisanGames/Terrain3D/discussions/656) on building biome support into Terrain3D

---

**jakobismus** - 2025-03-25 13:02

How do I access the data? I don't see an API for that

---

**cirebrand** - 2025-03-25 13:05

ill try when i get back home

---

**tokisangames** - 2025-03-25 13:07

https://terrain3d.readthedocs.io/en/latest/api/class_terrain3dregion.html#class-terrain3dregion-property-instances

---

**aldebaran9487** - 2025-03-25 16:31

Hi, everyone !
I'm trying to bake my terrains shadow in some sort of global texture, to use it in the distance in a custom terrain shader (like a lightmap).
I have made a script for that, it works as expected by capturing the scene from the air with a camera and create an image. But i use a camera with orthogonal projection, and it seems that shadow don't render in this mode (appear to work like that, but i'm maybe wrong on that).
Someone has an idea to do it ? Or information on shadows and camera in orthogonal mode ?

---

**image_not_found** - 2025-03-25 16:36

Could it be an issue an issue of the camera being too far from the scene, so the shadows aren't visible from that distance?

---

**aldebaran9487** - 2025-03-25 16:38

I have tried to extended shadow distance but without any success. Shadow are working in perspective mode through.

---

**aldebaran9487** - 2025-03-25 16:50

Ok, i have played with the params; this set seems to work :

📎 Attachment: image.png

---

**aldebaran9487** - 2025-03-25 16:51

The fade start to 1.0 made the shadow appears

---

**xtarsia** - 2025-03-25 16:52

are you using a custom light shader, and modifying attenuation there?

---

**aldebaran9487** - 2025-03-25 17:01

Nop, for the moment i use regular terrain shader. I will try to apply this texture on the terrain, and hopefully, when i will reduce the shadow distance, the baked one will provide a sufficient alternative.

📎 Attachment: image.png

---

**aldebaran9487** - 2025-03-25 17:04

The sahdows are still a lot blocky, i could try increasing the texture atlas size; and maybe capturing an 8192 image before reducing it to 4096.

---

**image_not_found** - 2025-03-25 17:29

Disable shadow cascades, you don't want shadow quality to change depending on camera distance

---

**melgibzon** - 2025-03-25 22:11

put a rock around it and increase the lod slider

---

**melgibzon** - 2025-03-25 22:11

so you can see full silhouette from further away

---

**melgibzon** - 2025-03-25 22:13

theres a reason most cave enterances look like this 😄

---

**melgibzon** - 2025-03-25 22:13

*(no text content)*

📎 Attachment: c471e825-4c65-4dca-9cb3-cd056832d04c.png

---

**melgibzon** - 2025-03-25 22:13

*(no text content)*

📎 Attachment: meta_tag.png

---

