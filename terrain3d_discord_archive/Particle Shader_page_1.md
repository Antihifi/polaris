# Particle Shader page 1

*Terrain3D Discord Archive - 349 messages*

---

**aldebaran9487** - 2025-03-28 18:17

There the modified version of your shader if you want to test it.
What are your others ideas to improve the system ?

📎 Attachment: grass_particule_terrain3d.gd

---

**xtarsia** - 2025-03-29 16:22

Sadly, running that type of loop is costing around 6 whole ms of GPU time for only 10,000 particles.

---

**xtarsia** - 2025-03-29 16:25

setting up a 4x4 grid of GPUParicles3D and letting the engine handle the culling that way is likley much more efficient (and simpler)

it would follow the same setup that the instancer uses too

---

**xtarsia** - 2025-03-29 16:26

that said, the idea is cool so i'll probably explore it a bit more 🙂

---

**aldebaran9487** - 2025-03-29 18:31

I have redo the rasterisation logic in gdscript, but i see no perf diff.

---

**aldebaran9487** - 2025-03-29 18:31

*(no text content)*

📎 Attachment: grass_particule_terrain3d.gd

---

**aldebaran9487** - 2025-03-29 18:33

Yeah, it's pretty inefficient even if it's a bit cool, i will try to create multiple GPUParticules (with less particles) and dispatch them in batch;

---

**xtarsia** - 2025-03-29 18:34

this achieves pretty much the same thing for almost free:

``    pos -= round(camera_transform[2].xyz * float(instance_rows) * 0.5);``

---

**xtarsia** - 2025-03-29 18:35

just shifts the entire grid in the view direction, Y component doesnt matter i guess.

---

**aldebaran9487** - 2025-03-29 18:35

wait, you don't have ugly mispositionned particles ? If you cut this ugly rasterisation logic in favor of 2 multiplication it's awesome !

---

**xtarsia** - 2025-03-29 18:36

its just this:

```glsl
    //create centered a grid
    vec3 pos = vec3(0.0, 0.0, 0.0);
    pos.z = float(INDEX);
    float rows = float(instance_rows);
    pos.x = mod(pos.z, rows);
    pos.z = (pos.z - pos.x) / rows;
    pos.x -= rows * 0.5;
    pos.z -= rows * 0.5;
    
    // Apply view offset before applying spacing
    pos -= round(camera_transform[2].xyz * rows * 0.5);
    
    pos *= instance_spacing;
    
    // Move the grid to the emitter, maintain snapping.
    pos.x += EMISSION_TRANSFORM[3][0] - mod(EMISSION_TRANSFORM[3][0], instance_spacing);
    pos.z += EMISSION_TRANSFORM[3][2] - mod(EMISSION_TRANSFORM[3][2], instance_spacing);
```

---

**aldebaran9487** - 2025-03-29 18:39

Hum, what is camera_transform ? It's setted from gdscript ? Or it's a built in ?

---

**xtarsia** - 2025-03-29 18:40

yeah, RenderingServer.material_set_param(process_rid, "camera_transform", camera.get_camera_transform())

---

**aldebaran9487** - 2025-03-29 18:47

Ok, it's much more smooth than mine. There is minor errors on particles positionning, but nothing as visible than my first attempt with clamp.

---

**aldebaran9487** - 2025-03-29 18:48

On my 6800XT it jump from 80 - 90 with my raster shader to 90 -115

---

**aldebaran9487** - 2025-03-29 18:48

It must be even more visible with a less capable gpu, or with more particles

---

**aldebaran9487** - 2025-03-29 18:50

you are some kind of wizard

---

**xtarsia** - 2025-03-29 18:51

i think the edges can be handled by using a pair of GPUParticles3D and moving their positions around as the camera rotates as well

---

**xtarsia** - 2025-03-29 18:52

as long as FOV isnt more than 90 it would give 100% horizontal coverage

---

**xtarsia** - 2025-03-29 18:53

over 90, would need 3 of them

---

**aldebaran9487** - 2025-03-29 18:54

*(no text content)*

📎 Attachment: Enregistrement_decran_20250329_195229.webm

---

**xtarsia** - 2025-03-29 18:55

thats floating point precision with the mod(float, float) func I think

---

**xtarsia** - 2025-03-29 18:55

thats why I did this: uniform float instance_spacing : hint_range(0.125, 10.0, 0.125) = 0.125;

---

**xtarsia** - 2025-03-29 18:55

the steps should be in powers of 2 (or divisions of 2)

---

**xtarsia** - 2025-03-29 18:57

uniform float instance_spacing : hint_range(0.03125, 10.0, 0.03125) works nice

---

**aldebaran9487** - 2025-03-29 19:00

Hum, this don't seems to change nothing on my test, the effect is maybe less visible but not sure.

---

**xtarsia** - 2025-03-29 19:00

```glsl
void start() {
    //create centered a grid
    vec3 pos = vec3(0.0, 0.0, 0.0);
    pos.z = float(INDEX);
    float rows = float(instance_rows);
    pos.x = mod(pos.z, rows);
    pos.z = (pos.z - pos.x) / rows;
    pos.x -= rows * 0.5;
    pos.z -= rows * 0.5;
    
    // Apply view offset before applying spacing
    pos -= round(camera_transform[2].xyz * rows * 0.5);
    
    pos *= instance_spacing;
    
    // Move the grid to the emitter, maintain snapping.
    pos.x += EMISSION_TRANSFORM[3][0] - mod(EMISSION_TRANSFORM[3][0], instance_spacing);
    pos.z += EMISSION_TRANSFORM[3][2] - mod(EMISSION_TRANSFORM[3][2], instance_spacing);

    // Create a random value per-instance
    vec3 r = vec3(random(pos.xz), random(pos.xz + vec2(0.5)), random(pos.xz - vec2(0.5)));

    // Randomize instance spacing
    pos.x += ((r.x * 2.0) - 1.0) * random_spacing * instance_spacing;
    pos.z += ((r.y * 2.0) - 1.0) * random_spacing * instance_spacing;
```

this is my whole block atm

---

**aldebaran9487** - 2025-03-29 19:00

I did'nt know that hint_range can be controled with a min and max value, it's nice

---

**xtarsia** - 2025-03-29 19:03

rotating a set of 2 emmiters will resolve this:

📎 Attachment: image.png

---

**xtarsia** - 2025-03-29 19:03

(the edges left and right)

---

**xtarsia** - 2025-03-29 19:03

tho there will be more offscreen, the simplicity is worth the trade off

---

**aldebaran9487** - 2025-03-29 19:05

Hum, the misposition appear only at certain terrain pos and angle; I don't understant how your two emmiters work; There is 2 GPUParticles shader at the same time ?
There are not overlapping themself ?

---

**xtarsia** - 2025-03-29 19:06

there is only 1 in that pic, ive not implemented it yet 😄

---

**aldebaran9487** - 2025-03-29 19:08

Ah ok ^^ But, how two emmitter could resolve the strange behaviour we see here ?
Sorry for all those dumb question, maths and shaders are not easy for me, even if i like them, you allreadty teach me a lot of thing with this shader !

---

**xtarsia** - 2025-03-29 19:09

with 2 emmiters, they would be side by side (filling the whole horizontal view)

---

**xtarsia** - 2025-03-29 19:10

but as you look around in a circle, they would have to snap to different offsets, depening on +/- xz view direction

---

**aldebaran9487** - 2025-03-29 19:20

Either we're not talking about the same thing, or I don't understand what you're trying to explain to me ^^
Can the weird 3-line separation on this screenshot be corrected using two emitters?

---

**aldebaran9487** - 2025-03-29 19:20

*(no text content)*

📎 Attachment: Enregistrement_decran_20250329_201736.webm

---

**aldebaran9487** - 2025-03-29 19:21

(note that i have been lucky to find this spot, i have try to find an other on that do that on my terrain and i don't have for the moment)

---

**xtarsia** - 2025-03-29 19:22

are you using the exact same code as I pasted above?

---

**aldebaran9487** - 2025-03-29 19:23

yes

---

**xtarsia** - 2025-03-29 19:23

its completley stable for me, even at 15,000 x -15,000m from origin (the random function is breaking down tho)

---

**aldebaran9487** - 2025-03-29 19:24

Ok, i was thinking i was completly dumb; like i said, i search for an other spot that do this think, and don't find it.

---

**xtarsia** - 2025-03-29 19:25

what position is that happening at?

---

**aldebaran9487** - 2025-03-29 19:27

X : -235 Y : 243 Z :-33

---

**aldebaran9487** - 2025-03-29 19:29

In fact, i forgot, but i have a diff with your code, in my gdscript :
`if(player) :
                RenderingServer.material_set_param(process_rid, "player_rotation", -deg_to_rad(player.rotation_degrees[1] + 90))
                RenderingServer.material_set_param(process_rid, "camera_transform", player.transform)
            else :
                RenderingServer.material_set_param(process_rid, "player_rotation", -deg_to_rad(camera.rotation_degrees[1] + 90))
                RenderingServer.material_set_param(process_rid, "camera_transform", camera.get_camera_transform())`

I do that because my player camera is not directly rotated, rotation are on a parent object. I will test only in the editor.

---

**aldebaran9487** - 2025-03-29 19:31

It's doing the same thing. I don't know what else i could have messed...  camera_transform in the shader is a mat4 right?

---

**xtarsia** - 2025-03-29 19:31

yeah its a mat4

---

**xtarsia** - 2025-03-29 19:32

paste the begining of the start() function

---

**aldebaran9487** - 2025-03-29 19:33

```glsl
void start() {
    //create centered a grid
    vec3 pos = vec3(0.0, 0.0, 0.0);
    pos.z = float(INDEX);
   float rows = float(instance_rows);
    pos.x = mod(pos.z, rows);
    pos.z = (pos.z - pos.x) / rows;
    pos.x -= rows * 0.5;
    pos.z -= rows * 0.5;
    
    // Apply view offset before applying spacing
    pos -= round(camera_transform[2].xyz * rows * 0.5);
    
    pos *= instance_spacing;
    
    // Move the grid to the emitter, maintain snapping.
    pos.x += EMISSION_TRANSFORM[3][0] - mod(EMISSION_TRANSFORM[3][0], instance_spacing);
    pos.z += EMISSION_TRANSFORM[3][2] - mod(EMISSION_TRANSFORM[3][2], instance_spacing);

    // Create a random value per-instance
    vec3 r = vec3(random(pos.xz), random(pos.xz + vec2(0.5)), random(pos.xz - vec2(0.5)));

    // Randomize instance spacing
    pos.x += ((r.x * 2.0) - 1.0) * random_spacing * instance_spacing;
    pos.z += ((r.y * 2.0) - 1.0) * random_spacing * instance_spacing;

    // Lookup offsets, ID and blend weight
    const vec3 offsets = vec3(0, 1, 2);
    vec2 index_id = floor(pos.xz * _vertex_density);
```

---

**aldebaran9487** - 2025-03-29 19:33

Should be the same as your

---

**aldebaran9487** - 2025-03-29 19:34

Ok, I have to go eat, I'll test it later; Anyway, I think it's a great addition you almost solved all my problem with this thing !

---

**xtarsia** - 2025-03-29 19:34

pos = instance_spacing;

should be pos *=..

that would break the entire thing tho

---

**aldebaran9487** - 2025-03-29 19:35

Seems that discord eat the *; EDITED

---

**xtarsia** - 2025-03-29 19:35

fair

---

**xtarsia** - 2025-03-29 19:36

for when you get back:

📎 Attachment: image.png

---

**xtarsia** - 2025-03-29 19:37

type shader code into discord like that 😄

---

**aldebaran9487** - 2025-03-29 19:37

Oh i see 😉

---

**aldebaran9487** - 2025-03-29 19:38

Totaly forgot the markdown notation, ok, see you later if you're still there 😉

---

**aldebaran9487** - 2025-03-29 19:57

When i return to my pc, I will update my github repo if you want to test it yourself, but you will need my assets to open the project. If needed i will try to reproduce this in a test project. It's maybe not related to your shader at all. It's maybe my project setup, or my terrain3d version.

---

**aldebaran9487** - 2025-03-29 19:58

If you use the last main it's maybe related, i have see your changes on lod, i will try main to see if there is differences.

---

**xtarsia** - 2025-03-29 20:00

i might have a fix

---

**xtarsia** - 2025-03-29 20:26

```glsl
    // Create a grid, center and then offset in view direction along XZ plane.
    vec3 pos = vec3(float(INDEX % instance_rows), 0.0, float(INDEX / instance_rows));
    pos.xz -= float(instance_rows >> 1u) + round(camera_transform[2].xz * float(instance_rows >> 1u));
    // Apply spcaing
    pos *= instance_spacing;
    // Move the grid to the emitter, maintain snapping.
    pos.x += EMISSION_TRANSFORM[3][0] - mod(EMISSION_TRANSFORM[3][0], instance_spacing);
    pos.z += EMISSION_TRANSFORM[3][2] - mod(EMISSION_TRANSFORM[3][2], instance_spacing);
```
make sure to set the instance_rows uniform type to uint

---

**aldebaran9487** - 2025-03-29 20:40

You did it ! (hi again)
It seems totaly good to me !

---

**aldebaran9487** - 2025-03-29 20:45

Could you explain the `instance_rows >> 1u` thing ? I don't figure how this shift work.
Also, like we are on this, how this is possibly good  ? :
    ```glsl
// Surface slope filtering
if (surface_slope_min > w_normal.y + (r.y - 0.5) * condition_dither_range) {
    pos.z = 0. / 0.;
}
```
It surprise me that a / 0. don't produce error, or maybe it's to cause shader failure on purpose ?

---

**aldebaran9487** - 2025-03-29 20:46

Anyway, it's really, really cool like that !

---

**xtarsia** - 2025-03-29 20:47

>> is a bit shift. since we're using uints, and dividing by 2, thats the same as doing a 1 bit shift to the right, so rather than telling the GPU to do potentially expensive divide, just do the bit shift (only works in case of divide or multiply by 2)

---

**xtarsia** - 2025-03-29 20:48

doing that divide by zero, creates a NAN value, which the GPU will then just not render to the screen.

---

**xtarsia** - 2025-03-29 20:50

that only works for position/vertices

---

**aldebaran9487** - 2025-03-29 20:50

Ooook, i didn't know that, i was just putting y to -10000

---

**xtarsia** - 2025-03-29 20:50

passing NAN to fragment will give you black / or random memory values

---

**aldebaran9487** - 2025-03-29 20:51

It's specific to godot or it's a general shader behaviour ?

---

**xtarsia** - 2025-03-29 20:51

general

---

**aldebaran9487** - 2025-03-29 20:52

good to know, thanks you

---

**xtarsia** - 2025-04-01 19:58

running a 3x3 grid that tracks the camera is just better it seems

---

**aldebaran9487** - 2025-04-02 00:04

Oh ? I'm not ready to another performance improvement, it's too much ^^
Anyway, a grid approch could also be a good start to do some sort of lod no ?
Like, a patch for the closer particules at the center, and a border made of patch of lower quality particles.

---

**xtarsia** - 2025-04-02 16:51

https://github.com/TokisanGames/Terrain3D/pull/665/files

you can test this if you want, and if it works well, or you have any suggestions?

---

**aldebaran9487** - 2025-04-02 23:39

I have tested it, it's pretty good so far, that said i have an issue when the player don't move; after 1 or 2 sec, the particles vanish, it's maybe related to AABB compute. We see than in depth tomorow.
If the perfs seems fine i'm not sur there are better than previous; i will also try benchmark it properly tomorow.
Thanks for this hard work.

---

**aldebaran9487** - 2025-04-02 23:40

I will also add a toggle to disable the cast_shadow on the particle emitter, it's usefull to be able to do that.

---

**aldebaran9487** - 2025-04-02 23:42

I also need to test the new MMI lod, it's maybe faster than particles, i don't know. Particles have the advantage of being procedural, but since based on multimesh they could be less performant.

---

**xtarsia** - 2025-04-03 06:05

added shadows, variable grid size,  fixed aabb 🙂

---

**xtarsia** - 2025-04-03 06:06

<@581586326839754842> can use this thread (or comment on github)

---

**xtarsia** - 2025-04-03 06:52

Pretty sure I know whats causing the vanishing problem.

---

**aldebaran9487** - 2025-04-03 06:58

Hey, can't test right now, but yeah, the vanishing really smell like aabb problem.
You program fast, i tested before going to bed, and when i wake up it's already fixed (or at least there is something to test) !

---

**aldebaran9487** - 2025-04-03 07:00

I will do the benchmark during my lunch break

---

**xtarsia** - 2025-04-03 07:41

I was throwing things to see what would stick to get compat working, and I think one of those was 1shot mode which is the culprit now. I'll sort it later.

---

**xtarsia** - 2025-04-03 07:41

Benchmark vs old method would be good.

The total particle value should make it easy to compare.

---

**aldebaran9487** - 2025-04-03 09:02

I am more inclined to test it for an equivalent visual result than for a number of particles.
Because, even if the amout of particles culled is enormous, in the end if the shader achieve better coverage with less particles at the start it will be better 😉

---

**aldebaran9487** - 2025-04-03 09:11

I have tested the last version on your github, in my case the particles still disappear after 1-2 sec.

---

**aldebaran9487** - 2025-04-03 09:11

*(no text content)*

📎 Attachment: Enregistrement_decran_20250403_110849.webm

---

**aldebaran9487** - 2025-04-03 09:11

It doesn't happen in the editor, only at runtime.

---

**aldebaran9487** - 2025-04-03 09:12

And if i move they comeback

---

**aldebaran9487** - 2025-04-03 11:28

I have do some tests

---

**aldebaran9487** - 2025-04-03 11:28

*(no text content)*

📎 Attachment: test.ods

---

**aldebaran9487** - 2025-04-03 11:28

*(no text content)*

📎 Attachment: particles_01_01.png

---

**aldebaran9487** - 2025-04-03 11:28

*(no text content)*

📎 Attachment: particles_01_02.png

---

**aldebaran9487** - 2025-04-03 11:28

*(no text content)*

📎 Attachment: particles_01_03.png

---

**aldebaran9487** - 2025-04-03 11:28

*(no text content)*

📎 Attachment: particles_01_04.png

---

**aldebaran9487** - 2025-04-03 11:29

There is the result on my demo for the 4 coverage test cases

---

**aldebaran9487** - 2025-04-03 11:29

I have see that on my 3700X/6800XT under linux (for the test, i run a moment, then turn left, run a moment, the stop and look around) :

📎 Attachment: image.png

---

**aldebaran9487** - 2025-04-03 11:32

So, if rotated particles do a good job, and deliver solid performance even on high distance coverage; on small coverage, the 3*3 grid of N size is better.
But on the other hand, the N*N grid of size 32 perform close to the better at each time.
I think it's the better solution, but not sure yet.

---

**aldebaran9487** - 2025-04-03 11:32

Also; the cast_shadox parameter is not set at launch, only when setter in editor. i have bypassed it for now.

---

**aldebaran9487** - 2025-04-03 11:35

I need to be sure that the NxN grid of 32 is better than the simple rotated particles.
It's maybe a statistical margin. Need more test to confirm.
Also, i want to test mixed setting, with NxN grid of S size. I also want to compare with MMI approch.

---

**aldebaran9487** - 2025-04-03 11:35

To see if there is a sweet spot. And even then, it will surely be a sweet spot specific to my system.

---

**aldebaran9487** - 2025-04-03 11:36

So other tester will be needed to find good settings for range of devices.

---

**aldebaran9487** - 2025-04-03 11:36

I'm full into testing nightmare now.

---

**aldebaran9487** - 2025-04-03 11:36

Everything is testable.

---

**aldebaran9487** - 2025-04-03 11:36

https://tenor.com/view/harry-styles-tape-measure-gif-8071078

---

**aldebaran9487** - 2025-04-03 11:44

I will try to setup a better methodology, with scripted scenario.

---

**aldebaran9487** - 2025-04-03 11:44

Something reproductible by others

---

**aldebaran9487** - 2025-04-03 11:45

And that compute the min, max and average.

---

**_askeladden__** - 2025-04-03 12:00

Thanks, it works perfectly for me after the fix!

---

**xtarsia** - 2025-04-03 13:15

vanishing should be fixed now, and shadow setting is applied on startup too.

---

**xtarsia** - 2025-04-03 15:09

on the performance side of things, very eyeballed results:
```
9x9 - 28 width - 63504 particles - 690~ fps
7x7 - 36 width - 63504 particles - 650~ fps
5x5 - 51 width - 65025 particles - 610~ fps
3x3 - 84 width - 63504 particles - 550~ fps
1x1 - 252width - 63504 particles - 420~ fps
```
larger grid seems quite beneficial

---

**aldebaran9487** - 2025-04-03 15:27

Hi again, this fix the vanishing !
Thank you ! Yeah, i see the same thing for the perf of the grid.
The spacing also do a lot with the ratio perf/eyecandy.
Cellwidth 32,spacing 1,09, grid width 9, particles count 68121; I get :    163 average fps;    min 107 (i have one occurence, next min is 144)    ; max 198;
And it's really gorgeous.

---

**xtarsia** - 2025-04-03 15:29

spacing is really the inverse of density, I went with setting the area size first, and letting density change independantly as its easier to keep things consistent.

its also a good setting to hook into for quality settings in graphics options menus etc.

---

**xtarsia** - 2025-04-03 15:30

the whole thing is really just an example of one way to do this.. Tho if people make improvements to it down the line, all the better 😄

---

**xtarsia** - 2025-04-03 15:31

i added this little info bit as well

📎 Attachment: image.png

---

**aldebaran9487** - 2025-04-03 15:31

Yes, i was thinking the same, it's really a piece that you need to tweak to have what you want.

---

**xtarsia** - 2025-04-03 15:31

so setting up distance fade in a material is a no brainer

---

**xtarsia** - 2025-04-03 15:32

*(no text content)*

📎 Attachment: image.png

---

**aldebaran9487** - 2025-04-03 15:33

Ah, i have it in the mesh material, it's a setter for the draw material param in the script ?

📎 Attachment: image.png

---

**xtarsia** - 2025-04-03 15:33

thats the default material

---

**xtarsia** - 2025-04-03 15:33

if you have a custom shader, you can just copy the code from it

---

**xtarsia** - 2025-04-03 15:34

```glsl
// Distance Fade: Pixel Alpha
    ALPHA *= clamp(smoothstep(distance_fade_min, distance_fade_max, length(VERTEX)), 0.0, 1.0);
```

---

**aldebaran9487** - 2025-04-03 15:34

Yeah, i have do that. I use the dither method, because this is much faster.

---

**xtarsia** - 2025-04-03 15:35

yep, it is

---

**aldebaran9487** - 2025-04-03 15:36

I wonder if i can move the pattern of the dittering effect at a high speed, to smooth it.
I don't know if this is possible, but i will try, the AA will maybe do a better job on the moving dither, idk.

---

**aldebaran9487** - 2025-04-03 15:36

And get the look and feel of the alpha method, with the perf of the dither

---

**aldebaran9487** - 2025-04-03 15:38

Anyway, you really killed the problem. The only thing i can think to made it better is LOD, or (we can dream) some sort of tesselation or meshshader ^^

---

**xtarsia** - 2025-04-03 15:38

I tried before, but it only works with TAA

---

**aldebaran9487** - 2025-04-03 15:38

oh, fsr2 too maybe ? To bad, i'm stuck with FXAA for now.

---

**xtarsia** - 2025-04-03 15:39

could do lods

---

**aldebaran9487** - 2025-04-03 15:39

I can't stop thinking at the grass of ghost of tsushima, it's the best i have ever seen.

---

**aldebaran9487** - 2025-04-03 15:40

but they use some fancy mesh generation on the gpu, so it's out of the scope of godot for now

---

**xtarsia** - 2025-04-03 15:40

with the grid, have the rings further out, use LOD meshes

---

**xtarsia** - 2025-04-03 15:41

its just strips, and its not really needed tbh

---

**aldebaran9487** - 2025-04-03 15:41

Yeah, i was thinking to exactly that when you talked about grid yesterday

---

**aldebaran9487** - 2025-04-03 15:42

I'm not sure, i have see a video where a dev explain the process, it was similar to that : https://gpuopen.com/learn/mesh_shaders/mesh_shaders-procedural_grass_rendering/

---

**aldebaran9487** - 2025-04-03 15:42

I think it's at a terrifying level of coolness

---

**xtarsia** - 2025-04-03 15:43

its such a huge ammount of unneeded work..

---

**aldebaran9487** - 2025-04-03 15:44

Yes, it's some sort of demonstration i suppose.

---

**xtarsia** - 2025-04-03 15:47

compute is very useful, but its never free.

---

**xtarsia** - 2025-04-03 15:48

so if the compute is run every frame, then its not really saving anything.

---

**xtarsia** - 2025-04-03 15:49

if it can be run once and saved then its super useful ofc

---

**aldebaran9487** - 2025-04-03 15:50

I see. This must be the tech fashion victim in me talking.
I also test the particles with the sphinx motion blur addon, surprisingly, it was ok.
The terrain is out of control, of course, but the particles was not moving and blurred as expected.
My old approch with the raster was completely broken in the same condition. I suppose the particles move less.

---

**xtarsia** - 2025-04-03 16:03

should be done for now. Im looking at getting GPU painting going next via viewports so compatibility works with it as well.

---

**aldebaran9487** - 2025-04-03 16:13

Fine, i will do little test with particles LOD on my side, the main issue will be my skill in blender i think.
Thanks again for your help/guidance/work !

---

**xtarsia** - 2025-04-03 16:13

I would just use LOD 0 sphere, LOD1 Cube, LOD2 quad to test with.

---

**xtarsia** - 2025-04-03 16:14

the more annoying bit is setting up the lods for the grid etc

---

**xtarsia** - 2025-04-03 16:15

tho it wouldnt be too bad actually.. just have to work out wich ring the particle node belongs to and set the correct mesh

---

**aldebaran9487** - 2025-04-03 16:16

Hum, it's not stupid, will do that to start !

---

**xtarsia** - 2025-04-03 16:33

lol

📎 Attachment: image.png

---

**aldebaran9487** - 2025-04-03 16:39

fuck, you do things a lot faster than me, it's unfair

---

**xtarsia** - 2025-04-03 16:40

well, i wrote everything so far, so i know how everything is set up already. So its easier to work out exactly what needs changing

---

**aldebaran9487** - 2025-04-03 16:41

yeah, don't take it bad neither, it's super cool

---

**xtarsia** - 2025-04-03 16:56

*(no text content)*

📎 Attachment: image.png

---

**xtarsia** - 2025-04-03 16:57

can likley reduce density for higher LODs too..

---

**xtarsia** - 2025-04-03 16:57

this smells very much like feature creep tho :p

---

**aldebaran9487** - 2025-04-03 17:01

*(no text content)*

📎 Attachment: image.png

---

**aldebaran9487** - 2025-04-03 17:01

ahah, we can even have flag particles

---

**aldebaran9487** - 2025-04-03 17:01

*(no text content)*

📎 Attachment: Copie_decran_20250403_190041.png

---

**xtarsia** - 2025-04-03 17:04

it becomes a balancing act between cell size, and draw calls at this point

---

**aldebaran9487** - 2025-04-03 17:42

Do you know how to expose an array of meshs in the editor ?
I have tried @export var lod_meshs: Array but it seems it don"t support Mesh in Array like that.

---

**aldebaran9487** - 2025-04-03 17:44

This do it : @export var lod_meshs: Array[Mesh]

---

**aldebaran9487** - 2025-04-03 18:08

Yeah 🙂
You have surely do a cleaner job, but i like this way to expose meshs, how have you do it on your side ?

📎 Attachment: image.png

---

**aldebaran9487** - 2025-04-03 18:09

```gdscript
var center_x = (grid_width - 1) * cell_width * 0.5
    var center_y = (grid_width - 1) * cell_width * 0.5
    #var radius = 80.0

    for i in range(grid_width * grid_width):
        var x = (i % grid_width) * cell_width
        var y = (i / grid_width) * cell_width

        var particle_node = GPUParticles3D.new()
        particle_node.amount = amount
        particle_node.lifetime = 1.0
        particle_node.explosiveness = 1.0
        particle_node.amount_ratio = 1.0
        particle_node.process_material = process_material
        particle_node.draw_pass_1 = lod_meshs[0]
        
        for lod_index in lod_meshs_radius.size() :
            var radius = lod_meshs_radius[lod_index]
            var lod_mesh = lod_meshs[lod_index]
            var lod_half_size = radius / 2.
            if abs(x - center_x) <= lod_half_size and abs(y - center_y) <= lod_half_size:
                particle_node.draw_pass_1 = lod_mesh
```

---

**aldebaran9487** - 2025-04-03 18:10

And just this to define the meshs :
@export var lod_meshs: Array[Mesh]
@export var lod_meshs_radius: Array[int]

---

**xtarsia** - 2025-04-03 18:18

```
    var half_width: int = grid_width / 2
    for x in range(-half_width, half_width + 1):
        for z in range(-half_width, half_width + 1):
            var ring: int = clampi(maxi(absi(x), absi(z)), 0, mesh.size() - 1)
            var particle_node = GPUParticles3D.new()
            particle_node.draw_pass_1 = mesh[ring]
```

---

**xtarsia** - 2025-04-03 18:22

adjustable range is def needed. my plan was to do similar, but just have the LOD distant be an integer ring number

---

**xtarsia** - 2025-04-03 18:23

the other approach would be to use a clipmap style grid

---

**xtarsia** - 2025-04-03 18:23

and have 4x4 center, and then each ring is 4x4 with no center, but doubled in size

---

**aldebaran9487** - 2025-04-04 07:43

Ok, i have made a 3d grass with lod based on one of those : https://opengameart.org/content/group-of-exotic-vegetation

---

**aldebaran9487** - 2025-04-04 07:43

*(no text content)*

📎 Attachment: grass_04.7z

---

**aldebaran9487** - 2025-04-04 07:44

It's not exactly what i want, but it allow to test the lod. There 7 LOD, in vertex : 160, 30, 15, 10, 4, 2, 1

---

**aldebaran9487** - 2025-04-04 07:47

*(no text content)*

📎 Attachment: image.png

---

**aldebaran9487** - 2025-04-04 07:49

In these scene, with cell width 32, spacing 1,0, grid width at 9 and particles count of 82944; i get 180 fps on average, min 149, max 220.

---

**aldebaran9487** - 2025-04-04 07:52

In my tests, the lod seems much faster than a simple grid of low poly mesh (that i used until). In the scene i have used these LOD variation : 30, 10, 2, 1

---

**aldebaran9487** - 2025-04-04 07:57

I have had pretty much the same fps with LOD like this : 160, 10, 2, 1

---

**aldebaran9487** - 2025-04-04 07:58

Even better, i have an average of 188 fps this time.

---

**aldebaran9487** - 2025-04-04 07:58

Maybe a statistical error margin

---

**xtarsia** - 2025-04-04 08:01

meanwhile, i got a bit distracted.

📎 Attachment: Godot_v4.4.1-stable_win64_KUQUmaVk0G.mp4

---

**aldebaran9487** - 2025-04-04 08:02

Thats sooo cool

---

**aldebaran9487** - 2025-04-04 08:06

Have you consider using the same computation than the terrain fragment (or close, the idea is to have the average color of the terrain under the grass, to tint it) to colored the grass ?

---

**aldebaran9487** - 2025-04-04 08:06

It's maybe too expensive.

---

**aldebaran9487** - 2025-04-04 08:06

Or maybe with a baked globalmap.

---

**aldebaran9487** - 2025-04-04 08:06

But just be able to draw on it allow a lot of variation

---

**xtarsia** - 2025-04-04 08:07

it should be doable inside the start() function

---

**xtarsia** - 2025-04-04 08:07

thats how im doing wind / color mod here

---

**xtarsia** - 2025-04-04 08:07

the actual mesh has 0 texture lookups

---

**xtarsia** - 2025-04-04 08:07

i was able to push 21 million particles and still hit 60fps

---

**aldebaran9487** - 2025-04-04 08:09

Hum, the start function can affect the color of the mesh ? I was thinking it was limited to position and scaling

---

**xtarsia** - 2025-04-04 08:09

you can set COLOR, and CUSTOM which are passed to vertex()

---

**aldebaran9487** - 2025-04-04 08:10

Oh ok, interesting.

---

**aldebaran9487** - 2025-04-04 08:11

So in you exemple it's a full land of one grass blade ? the LOD is not used ?

---

**xtarsia** - 2025-04-04 08:11

0 LOD atm

---

**xtarsia** - 2025-04-04 08:12

adding in LODs would probably let this end up rather cheap

---

**aldebaran9487** - 2025-04-04 08:12

btw, i don't know how to do LOD to a grass blade, its a triangle after all

---

**xtarsia** - 2025-04-04 08:12

higher LODs, just have less of them, but wider blades

---

**aldebaran9487** - 2025-04-04 08:12

Hum, so it's more a density thing ?

---

**xtarsia** - 2025-04-04 08:13

yeah

---

**aldebaran9487** - 2025-04-04 08:13

okay, make sense.

---

**aldebaran9487** - 2025-04-04 08:16

Wait, in fact you use the colormap of the terrain in your video ? I don't see well but the terrain seems colored too.

---

**xtarsia** - 2025-04-04 08:16

yep

---

**aldebaran9487** - 2025-04-04 08:16

Okay, it turn to be really powerfull

---

**xtarsia** - 2025-04-04 08:19

also, rather than distance fade, can use process to grow the grass through the ground based on vamera distance 😄

---

**xtarsia** - 2025-04-04 08:20

exagerated example

📎 Attachment: Godot_v4.4.1-stable_win64_rbg4ZtFueI.mp4

---

**aldebaran9487** - 2025-04-04 08:21

I have made something like this, but it was a little too obvious; your will work very well with more depth i think 🙂 It's pretty

---

**xtarsia** - 2025-04-04 08:44

https://xtarsia.itch.io/terrain3d-grass-test web export working flawless (chrome faster, firefox seems a bit slow)

---

**aldebaran9487** - 2025-04-04 09:03

It's nice, i can use the mouse throught (under firefox).

---

**aldebaran9487** - 2025-04-04 09:03

But, i really like the result, it's dense

---

**aldebaran9487** - 2025-04-04 16:38

It could be interresting to mimic this project : https://github.com/2Retr0/GodotGrass

---

**aldebaran9487** - 2025-04-04 16:38

It use different density like you suggested it

---

**aldebaran9487** - 2025-04-04 16:40

Et look damn beautifull, but it's a style.
So, if we add a density parametter to the LOD system i think it will look at least as good.

---

**xtarsia** - 2025-04-04 16:42

yeah im most of the way there already

---

**xtarsia** - 2025-04-04 16:43

I just need to parameterize a fair number of things that ive hard coded whilst playing with it

---

**xtarsia** - 2025-04-04 16:44

in fact the current method is superior to that project as its almost entirely done on the GPU already.

---

**xtarsia** - 2025-04-04 16:44

ive doing clumping / scaling bend factor etc in the particle process() and just applying the result in vertex from the passed in data, so its very fast

---

**aldebaran9487** - 2025-04-04 16:45

Yeah, the particles are all on gpu, it's more on the density lod that it's interesting

---

**xtarsia** - 2025-04-04 16:45

particle process() has its own independant FPS too. So ive set outer rings to lower FPS as well

---

**aldebaran9487** - 2025-04-04 16:46

Yes, on the repo it seems it does it in the vertex of the material.

---

**xtarsia** - 2025-04-04 16:47

so when rendering at 300fps, the particle shader only does 1 texture read every 10th frame, per instance, instead of every frame per vertex.

---

**xtarsia** - 2025-04-04 16:47

so.. its potentially 270x less texture() calls, for a blade with 27 vertices (that im currently using)

---

**aldebaran9487** - 2025-04-04 16:48

Hum, it's the framerate of the process material or of the particule drawmaterial ?
It sound very interesting to optimization.

---

**aldebaran9487** - 2025-04-04 16:48

yes ok

---

**xtarsia** - 2025-04-04 16:48

add in lower FPS, and lower instance count for outer rings..

---

**xtarsia** - 2025-04-04 16:48

its insanely fast

---

**aldebaran9487** - 2025-04-04 16:49

i see potential

---

**xtarsia** - 2025-04-04 16:50

if density follows a half (per axis - so 1/4th) per ring

---

**xtarsia** - 2025-04-04 16:50

it should be possible to grow in the inner ring to match next ring (similar to geomorph logic)

---

**xtarsia** - 2025-04-04 16:51

so transitions in each ring will be smooth too

---

**xtarsia** - 2025-04-04 16:51

thats what im faffing with atm 🙂

---

**xtarsia** - 2025-04-04 16:52

at this rate.. it might be worth making an extra tab in assets and converting all this to c++ as a full fledged feature.. <@455610038350774273> ?

---

**aldebaran9487** - 2025-04-04 16:53

I see, was thinking of blending the lods, maybe by offsetting the grids and with ditering.

---

**xtarsia** - 2025-04-04 16:53

the gdscript example can stay for education purposes perhaps

---

**aldebaran9487** - 2025-04-04 16:53

You already pushed this far

---

**aldebaran9487** - 2025-04-04 16:54

I have never do c++ in godot (but i do outside), you mean convert you script in gdextension ?

---

**xtarsia** - 2025-04-04 16:55

once most of the structure and logic is fleshed out, its mostly a case of mild refactor to c++

---

**xtarsia** - 2025-04-04 16:55

i have a bunch of gdscript clipmap code hanging around

---

**xtarsia** - 2025-04-04 16:55

gdscript is just super nice for fast prototyping

---

**aldebaran9487** - 2025-04-04 16:58

Yes of course, i'm curious of the difference in perf, i don't know if the computation in the gdscript is very intense.
There is maybe more faster options to interacts with godot internal that can be usefull to the usecase in c++ ?

---

**aldebaran9487** - 2025-04-04 16:58

Like i said, even i do c++ for years, i'm pretty ignorant with gdextension

---

**xtarsia** - 2025-04-04 16:59

for this case, there isnt really much CPU processing going on, so there wouldnt be much perf gain.

---

**xtarsia** - 2025-04-04 16:59

it'd just be keeping things inline.

---

**aldebaran9487** - 2025-04-04 16:59

Okay, it make sense

---

**aldebaran9487** - 2025-04-04 17:01

It's really interesting to follow you working on this, it teaches me a lot of things and gives me ideas.

---

**tokisangames** - 2025-04-04 17:05

I'm open to an integrated feature. What would be on the new assets tab? Why not use the same meshes?

---

**xtarsia** - 2025-04-04 17:08

I guess it could read from assets. I just envisage a significant number of options, and cluttering the hand-painting focused tab with particle rules might be annoying

---

**tokisangames** - 2025-04-04 17:16

Yes, we can change things up, add new panels, etc. Asset dock internals needs a rewrite anyway.

---

**aldebaran9487** - 2025-04-05 10:58

I have tested a lod with variable density code. It works but there is some issue in the position stability of the particles, and the lod pattern is very visible.
I then tested an alternative, no lod, but 3 differents terrain particle node, with different density, size and a alpha dithering to blend each 3 node at different distance.
It's visualy better, transition is smooth and the perfs are still good but not as much as expected.

What is the alternative, can we generate the particles position to follow the same pattern as a clipmeshmap ?

---

**aldebaran9487** - 2025-04-05 11:01

If we take a clipmap mesh, we could maybe parse the position of each vertex to apply on the particle grid, allowing to define the density pattern with blender for example. Not sur if it's good idea.

---

**xtarsia** - 2025-04-05 22:39

had to adjust snapping to sort the stability, from my testing the transitions are still noticable with half density even with fixing the snapping. Thickening the grass in the distance helps, but its just not worth the hassle, the performance save doesnt beat propper LOD meshes.

just setting LODs was better

---

**aldebaran9487** - 2025-04-06 07:25

Ok, same. So a solution could be to use different lod meshs and variable density to each lod.
When i have reuse the fragment code of GodotGrass project, i have note that the particles grow with distance. It's interesting to keep same aspect with less density. Combined with a special lod mesh and a texture that mimic multiples grass it should be more interresting.
Also, if we make each lod ring overlap the next one, and make use of alpha dithering, we could also reduce the lod transition visibility.

---

**aldebaran9487** - 2025-04-06 07:31

Oh, and i was thinking of using an alternative method to distant grass. I have made a test with shell texturing in old project with zylan plugin. it's not bad, i have had hard time to make the shell grass look more or less like my grass mesh, but it cover really long distances without problem. I was doing the shell texturing on the terrain mesh itself, with multiples next pass shader.

---

**xtarsia** - 2025-04-06 07:47

Billboards are far distances make more sense to me.

---

**aldebaran9487** - 2025-04-06 08:35

I don't know, shell texturing is maybe a complementary solution. I plan to retest it with your particle system when i will be home. Could i add a next shader stage to the terrain (i don't check how it works yet) ?

---

**aldebaran9487** - 2025-04-06 08:49

I have an old video of what i mean : https://youtu.be/yjqnrSZLAIs?feature=shared

---

**aldebaran9487** - 2025-04-06 08:49

The distant grass in this example is shell texturing.

---

**aldebaran9487** - 2025-04-07 17:51

To follow discusion of grass density etc, i have try to create multiples grass mesh for the lod system, based on the GodotGrass project obj, i have made 1, 2, 3, and 4 blades highpoly grass blade mesh; and a lowpoly one.
In my test, it seems that just using this setup is not bad :
LOD0 : 4 blades highpoly
LOD1 : 2 blades highpoly
L0D3: 1 blade lowpoly

It allow to have different density, but the grid structure is still noticiable.

📎 Attachment: image.png

---

**aldebaran9487** - 2025-04-07 17:53

The files i use if someone is interested.
<@188054719481118720> Should i continue to post questions and trials here, or this thread is now reserved to your particle system ? In this case i could post in general terrain-help instead.

📎 Attachment: blade_01.zip

---

**xtarsia** - 2025-04-07 17:54

Discuss away!

---

**aldebaran9487** - 2025-04-07 18:01

Arf, my english is not so good, discuss away means "go discuss this on other thread" (like in go away), or "we can talk here" ?

---

**xtarsia** - 2025-04-07 18:04

"Talk here" was the correct intent 🙂

---

**xtarsia** - 2025-04-07 18:17

before any randomness, but after the instance is set to world space, can determine its grid alignment with the next LOD:

```glsl
bool is_even = bool(int(pos.x / instance_spacing) % 2) || bool(int(pos.z / instance_spacing) % 2);
```
then at the appropriate place, fade out the instance (shrinking into the ground in this case)
```glsl
    // half density fade
    float density_factor = 1.0 - smoothstep(0., max_dist + 0.0001, length(camera_position - pos)) + 0.001;
    scale.y *= !is_even ? density_factor : 1.0;
    offset *= !is_even ? density_factor : 1.0;
```

---

**xtarsia** - 2025-04-07 18:24

however, if the LODs are square, then length might have to be
```glsl
vec2 instance_view_distance = vec2(camera_position.xz - pos.xz);
max(instance_view_distance.x, instance_view_distance.y);
```
the min and max would need to be set according to the LOD (which can be derived from round((EMISSION_TRANSFORM[3].xz - camera_position.xz) / (instance_spacing * instance_rows)), which would put the emission transform back into the grid co-ordinates (might need some tweeking)

---

**xtarsia** - 2025-04-07 18:28

doing just this with a single LOD.. I cant see the transition between full / half density at all O_O

---

**xtarsia** - 2025-04-07 18:32

ok i pulled the transition in really close:

---

**xtarsia** - 2025-04-07 18:32

*(no text content)*

📎 Attachment: Godot_v4.4.1-stable_win64_IGuMg0mSVx.mp4

---

**xtarsia** - 2025-04-07 18:33

spread over a full cell width tho its imperceptible

---

**xtarsia** - 2025-04-07 18:41

not really imperceptible, but it requires actively looking for it. (like geomorph / dual scaling fade etc)

---

**aldebaran9487** - 2025-04-07 18:47

It's way more nice than doing alpha dithering !
If we could  expland a little the grid on the next lod i think it we be even less visible. But it's already very nice.

---

**xtarsia** - 2025-04-07 18:47

i pushed a bunch of changes to to the PR (no lods tho)

---

**xtarsia** - 2025-04-07 18:48

grass is too distracting lol

---

**aldebaran9487** - 2025-04-07 19:03

After 3 hours of testing i was considering just disable it and go away with a basic plain green color ^^

---

**xtarsia** - 2025-04-07 19:08

unless the grass is really tall, i dont think its worth trying to have it render really far away

---

**aldebaran9487** - 2025-04-07 19:14

But it could interesting to mimic the look of the distant grass on the terrain texture. At least the moving effect of the wind.

---

**xtarsia** - 2025-04-07 19:14

can add the wind to the terrain shader, and blend it with only specific textures

---

**aldebaran9487** - 2025-04-07 19:16

Was just thinking about it, i have see a shader for faking grass on the terrain mesh, something like some sort of parallax effect. It must be consuming too.

---

**aldebaran9487** - 2025-04-08 10:05

An other possibility is to perform a rotation on the particle  or reduce it's width to make it disaspear less obviously. Or even a composition of all this tricks.

---

**xtarsia** - 2025-04-08 10:13

Yeah scaling xz to 0 could look better.

---

**aldebaran9487** - 2025-04-08 10:25

I checked your video again, you already overlap the grass patches right?

---

**xtarsia** - 2025-04-08 11:31

No overlap. I'm calculating which particles for the current LOD aren't sharing a position with the next LOD, and applying a transition to them before the next lod arrives as the grids moves around.

---

**aldebaran9487** - 2025-04-08 11:56

Oh ok, so it's only the border of the patch that's affected ?

---

**xtarsia** - 2025-04-08 12:01

Yeah pretty much

---

**aldebaran9487** - 2025-04-10 08:39

Hi, was thinking about an old experiment.
One time i was playing with a planemesh, I was able deform the mesh to follow my terrain (with terrain3d heightmap), then I warped the resulting top to make it look like grass.
Is there a name for this technique?
To be more clear, i create a plane mesh, and apply a vertex deformation on it in shader, to follow the shape of the terrain, after that, i apply again a vertex deformation, but on 1 vertex each 3, and i set this vertex higher. It then look a bit like field of grass.
I'm playing with this idea here : https://github.com/aldebaranzbradaradjan/starfiles/tree/main/ressources/grass
You can see what i do in the grass grass_patch_material.tres.

---

**aldebaran9487** - 2025-04-10 08:39

*(no text content)*

📎 Attachment: apsur.png

---

**aldebaran9487** - 2025-04-10 08:40

I just see my old result and thinking it was very dense for grass.

---

**aldebaran9487** - 2025-04-10 08:41

I think it could play well with the lod particle system (the mesh will be a plane mesh, and for each load use less and less subdivision).

---

**aldebaran9487** - 2025-04-10 08:44

But, there is a lot of not displayed vertex too, it must be more efficient to continue with a normal grass obj. however, it seems that my gpu is more capable of display numerous object with a medium amount of vertex than an bigger number of smaller mesh. Even with batch instancing.

---

**aldebaran9487** - 2025-04-10 08:45

Also, the look is dense, but there is no curve, the terrain just turn into hedgehog

---

**xtarsia** - 2025-04-14 19:25

<@410497853346021377> fair bit of stuff here that might be worth reading

---

**aldebaran9487** - 2025-04-14 22:20

For record, i'm still experiment on alternative to particle grass at medium / long distance . I have made little progress to add a shell grass on the terrain. My plan is to not create particle patch for the last lod, but instead, create un planemesh, deform it in vertex to follow the terrain, add some layers with the next pass shader, and discard the color when the shell is not on grass point.

---

**aldebaran9487** - 2025-04-14 22:21

Not very clear, but hopefully i will post the result soon.

---

**aldebaran9487** - 2025-04-15 12:15

Okay, i think it was not a good idea to try shell texturing. Or my implementation need to be optimized a lot.

📎 Attachment: image.png

---

**aldebaran9487** - 2025-04-15 12:16

130 fps in editor vs 146 for the particle solution

---

**aldebaran9487** - 2025-04-15 12:16

*(no text content)*

📎 Attachment: image.png

---

**aldebaran9487** - 2025-04-15 12:17

For more or less the same coverage (and the particles look far better)

---

**aldebaran9487** - 2025-04-15 13:02

Okay, the shadow was activated on the shell layers, so i tweaked all the scene and try to mix with the particles.

---

**aldebaran9487** - 2025-04-15 13:07

I can have dense grass object at short distance and the shell after that:

📎 Attachment: image.png

---

**aldebaran9487** - 2025-04-15 13:08

It's not the same that the grass only (compare with the last-1 screenshot), but i think it's close.
I prefer the particles, even far away, but meh. I suppose the shell could look better that what i have done, i dont know.
For the same coverage with particles only i reach around 90-100 fps in editor vs 155 with the hybrid method.

---

**aldebaran9487** - 2025-04-15 13:09

We could maybe just apply a pattern on the terrain through.

---

**aldebaran9487** - 2025-04-15 13:11

Something like that maybe ?
https://www.youtube.com/watch?v=pbM3ufYSRY8

---

**aldebaran9487** - 2025-04-15 13:12

But i have no idea of how to do. I need to do research, it's maybe like the paralax effect.
Tell me i this experimentations goes to far from the particle shader perspective. Even if i think they are linked, i could just open a new thread if needed.

---

**aldebaran9487** - 2025-04-15 13:27

I can maybe use something like this ?
https://godotshaders.com/shader/cheap-parallax-planes-array/

---

**aldebaran9487** - 2025-04-17 07:57

I wonder if we could use this project : https://godotengine.org/asset-library/asset/1488
To subdivide a particle mesh at runtime based on distance (like some sort of tesselation shader, but not a shader).
Like it's made on CPU it must be slow, but i will try to test it. If that work that could solve the need for LOD (but don't solve the LOD blending i think, the tool seems to go from one subdivision to other without transition).

---

**wasd_keys_studio** - 2025-04-29 16:05

ok try and we just take our snacks and watching u trying

---

**aldebaran9487** - 2025-04-29 18:40

In fact, i have digged in a simpler way, and i don't think i really need anything more than the basic mesh lod to make a beautiful grass. Things like parallax grass could be interesting but i'm not on this for now.

---

**giltong** - 2025-05-12 23:46

hi, sorry to necro on this. i started a project a couple days ago and wanted to use the particle shader. i ended up combining the sample with a shader based on the GodotGrass github repository and got something that turned out pretty good. I've been following the conversation going on in here over LOD and have pieced together a basic LOD system that uses the rings of and decreases the density and mesh further out. 

im wanting to ask if I could get a bit more information on what yall used for better blending the LODs together, as right now my only solution is to put the high detail further out until its not as noticeable.

another thing i wanted to ask is how you update the density; currently I adjust the amount of particles given to the particle node based on the ring value, and then in shader calculate a new instance_rows and instance_spacing for that specific lod. are you doing something similar to this?

---

**aldebaran9487** - 2025-05-14 10:04

Hey, For the LOD blending, i have try two approch.
1 - make the different lod look close, but it's not suitable to any design.

---

**aldebaran9487** - 2025-05-14 10:05

2 - Use 2 particles shader (one by LOD), and dither the LOD0 at a certain distance; (and for the LOD1 i just don't create patch at certain distance.

---

**aldebaran9487** - 2025-05-14 10:06

An other option could be to offset the size of the center LOD patch, and alpha dither the border, to mix it with the next lod.

---

**aldebaran9487** - 2025-05-14 10:09

Also, for the density diff, i have try to add it to the script (each load was having different density), but i never manage to resolve the visible difference in the placement of the particles.
So, for now, i have instead make may LOD0 with 3 meshs, LOD1 with 2, etc.

---

**aldebaran9487** - 2025-05-14 10:09

It's in my opinion less visible.

---

**aldebaran9487** - 2025-05-14 10:11

For the moment i'm sticking with a basic 1 LOD mesh (just 5 or 6 triangles) and it's ok for now; But a better solution could be nice, i just don't have the time/motivation for now 😉

---

**aldebaran9487** - 2025-05-14 10:14

It look like that

📎 Attachment: image.webp

---

**aldebaran9487** - 2025-05-14 10:15

The grass mesh used if you want it

📎 Attachment: grass_05.glb

---

**aldebaran9487** - 2025-05-14 10:16

*(no text content)*

📎 Attachment: grass_05_CF_DSC03369_norm.png

---

**giltong** - 2025-05-14 17:38

yeah the main issue im having on the ground is the snapping with the camera movement. after the camera snaps, from ground level its pretty difficult to tell the difference between my LOD0 and LOD1. 

im thinking of adding in the update checking each grass blades "ring" distance (i think Xtarsia described it when doing their scaling thing) and comparing it to what it should be based on the unsnapped camera position, then dithering from there, so as you approach the snap it will fizzle out or something idk

---

**giltong** - 2025-05-14 17:39

i do prefer the look where every grass blade is its own instance, but i might try your way of having multiple per mesh as well idk how well it will look but it wouldnt hurt to try

---

**aldebaran9487** - 2025-05-14 21:22

I have the files used here if you want to do quick test  : https://discord.com/channels/691957978680786944/1355244384941248603/1358861656658153624

---

**giltong** - 2025-05-14 21:53

thanks, ill give it a shot

---

**saul2025** - 2025-06-14 17:59

hey how do i change the texture  id the shader uses to position grass to another texture?

---

**xtarsia** - 2025-06-14 18:48

It's currently hard coded in the particle process material .gdshader

---

**saul2025** - 2025-06-14 19:09

ok, but where is it or line? I looked on it  a bitbut couldnt really find it.

---

**xtarsia** - 2025-06-14 20:20

particles.gdshader:
```glsl
    // Hardcoded example, hand painted texture id 0 is filtered out.
    if (!auto && ((base == 0 && blend < 0.7) || (over == 0 && blend >= 0.3))) {
        pos.y = 0. / 0.;
        pos.xz = vec2(100000.0);
    }

```
this section, from line 241

---

**saul2025** - 2025-06-15 06:40

Ty i have modified it and also the  material in order to make it match  the terrain texture.
Though While testing, even if performance is better that just using mmi  there were 2 big performance throtles  on mobile :

1 While running or being fast generating the grass  cost  many ms  ie from 46 moving  to 53 when  standing  still. Prob caused by ram or lack  streaming( godot engine  issue most likely ).

2 The density doesnt seem to change when being far which makes it critical since with the grass enabled  you are rendering  1m200k primitives with a cell witdh of  24 and grid witdh of 5( or  160k instances) Which for mobile  its expensive.  The solution could be a bit related to this issue  along with maybe in more far distance the blades movement could be dissabled to  reduce the ms . Moreover  reducing the plane sections. https://github.com/TokisanGames/Terrain3D/issues/545 

Either way it's impressed that increasing the process frame to a higher value doesnt hurt performance at all , really cool stuff.

---

**aldebaran9487** - 2025-06-15 07:48

There is a version of the script and shader in this thread that allow lower density with lod, but it was causing issues if i remember well.

---

**saul2025** - 2025-06-15 08:29

Pretty cool, hopefully it gets in oficially someday.

---

**saul2025** - 2025-06-16 03:11

Any tips on matching the color of the grass with the material ?  Been tinkering  the params  of the code but cant find something that matches it well.

📎 Attachment: Screenshot_20250616_050525.jpg

---

**xtarsia** - 2025-06-16 06:19

currently it reads the color map value, and passes that to the grass model shader.

however it should be reasonable to read the base / overlay texture as well, at a high mipmap level to get the  average color, and use the blend value, and  then apply color on top?

---

**xtarsia** - 2025-06-16 06:22

need to add the texture arrays as well in that case

---

**saul2025** - 2025-06-16 19:15

that sounds cool , but maybe a simpler optiom  could be have a color variable at the material  parameters that lets you change the base color and then apply the blending from the ground. I guess texture arrays might reduce performance no as it adds more complexity?

---

**giltong** - 2025-06-17 00:16

whenever i modified the code for my use, I did a bit of what the GodotGrass project did and specified a base and tip color, and then would blend between the two based on the height within the individual grass shader. you could probably do something similar but instead make the base color the color sampled from the ground

---

**saul2025** - 2025-06-17 01:48

The weird thing is that in the particle shader when modifyint the base stuff, it only does so with the position., but not the color. Thats ehy i requested  a color parameter  and then get it blended from.terrain.

---

**giltong** - 2025-06-17 03:54

that's pretty similar to what i did lol, I dont think its too difficult to add your own parameter for controlling that.

---

**saul2025** - 2025-06-17 18:03

does this 0 marked as red handle  which colormap is read for the grass color .

📎 Attachment: IMG_3190.jpeg

---

**tokisangames** - 2025-06-17 18:05

"if this vertex is in a region, look up the color map at mipmap 0, otherwise use the default color map color (white)"

---

**saul2025** - 2025-06-17 18:44

oh cool, then  where does it read it since it seems that at the 240  lines just by changing the base to 1 ie positions it to the grass texture, nut doesn’t change the color of the grass so it stays  with the texture id 0 ( ie staying yellow color).

---

**xtarsia** - 2025-06-17 19:27

*(no text content)*

📎 Attachment: image.png

---

**xtarsia** - 2025-06-17 19:28

```glsl
    COLOR = vec4(1.);
    if (apply_texture_color) {
        vec3 t_base = textureLod(_texture_array_albedo, vec3(pos.xz, float(base)), 4.0).rgb;
        vec3 t_over = textureLod(_texture_array_albedo, vec3(pos.xz, float(over)), 4.0).rgb;
        t_base = _texture_color_array[base].rgb;
        t_over = _texture_color_array[over].rgb;
        COLOR.rgb = (t_over * blend) + (t_base * (1.0 - blend));
    }
    if (apply_color_map) {
        COLOR *= color_map;
    }
```

has to be after the control map is read

---

**xtarsia** - 2025-06-17 19:29

needs tidying up, could be interpolated etc etc.. tho at that point almost recreating the entire shader...

---

**xtarsia** - 2025-06-17 19:29

RVT would be better for this as well

---

**xtarsia** - 2025-06-17 19:41

oh yeah, the gdscript needs this adding to _update_process_parameters() too:

```c++
    RenderingServer.material_set_param(process_rid, "_texture_array_albedo", terrain.assets.get_albedo_array_rid())
    RenderingServer.material_set_param(process_rid, "_texture_color_array", terrain.assets.get_texture_colors())
```

---

**saul2025** - 2025-06-17 19:55

cool ty, will add it tomorrow if i have time, though it causes some slowdown?

---

**xtarsia** - 2025-06-17 21:20

and some uniforms too:

```glsl
group_uniforms coloring;
uniform bool apply_color_map = true;
uniform bool apply_texture_color = true;

group_uniforms private;
uniform vec4 _texture_color_array[32];
uniform highp sampler2DArray _texture_array_albedo : source_color, filter_linear, repeat_enable;
```

---

**saul2025** - 2025-06-18 03:03

Um  i think its not working as intended  pls it still seems to not take the texture color information

Edit at the end of the day atleast by modifying the 3 floats  from the hard coded color  gives   a decent color that matches the trees.

📎 Attachment: Screenshot_20250618_045718.jpg

---

**saul2025** - 2025-06-18 03:34

*(no text content)*

📎 Attachment: Screenshot_20250618_052217.jpg

---

**saul2025** - 2025-06-21 02:08

Ok aside from this, is the grass  spawn done on a single thread  or is it multi threaded? I do ask because of the ongoin frame Drops the more you run  on the grass, the more time and it keeps going down the longer you keep running.

---

**saul2025** - 2025-10-07 16:32

I think this  instancing grass stuff  would be useful for this particle shader, it has a masskve good perf https://x.com/panoskarabelas1/status/197556079134548808   https://github.com/PanosK92/SpartanEngine/blob/master/source/runtime/Rendering/Instance.h

---

