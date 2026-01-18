# Ok, I'm onto something. For height page 1

*Terrain3D Discord Archive - 45 messages*

---

**notarealmoo** - 2024-05-07 18:32

Ok, I'm onto something. For height colouring....

`float yy = get_height(uv2)*0.01;
ALBEDO = vec3(0.0,yy,0.0);`

What's the range of uv2 (the 0.01 is a throwaway number)

📎 Attachment: image.png

---

**xtarsia** - 2024-05-07 18:35

the get height function return the height as stored in the height map.

uv2 is a coordinate in xz space only

---

**notarealmoo** - 2024-05-07 18:35

thanks. I determined that I'm getting height in meters with yy

---

**notarealmoo** - 2024-05-07 18:36

where's the minimum / maximum heightmap value stored?

---

**xtarsia** - 2024-05-07 18:39

practically its unlimited

---

**notarealmoo** - 2024-05-07 18:57

i feel i'm close with slopes. I just need to grab the right texture but I'm not sure where it's stored

📎 Attachment: image.png

---

**notarealmoo** - 2024-05-07 18:57

texture_color_array isn't it, AFAIK

---

**xtarsia** - 2024-05-07 19:01

have you looked at the autoshader? it does this for you as a built in feature?

elsewise, its ``vec4 grass_tex = _texture_array_albedo[0];`` etc

i'd have a good look at the default generated shader that pops up when you enable "shader override"

---

**notarealmoo** - 2024-05-07 19:02

I'm using the pre-gen shader as a base. Can I direct the autoshader with procedural terrain?

---

**xtarsia** - 2024-05-07 19:09

its just a blending formula similar to what you have

---

**tokisangames** - 2024-05-07 19:16

Procedural height? The autoshader doesn't care where your data comes from.
The shader already does shading by slope, w/ reduction by height. Adding height shading to it is only a line or two.

---

**tokisangames** - 2024-05-07 19:21

We already have documented the shader in the code and in the documentation. If you spend more time to understand more of what is there you'll find examples of things you want to do, or components of them, already present.

---

**notarealmoo** - 2024-05-07 19:27

this is fair. shaders are newer to me. the objective for this question is to permit me to automatically apply the right texture and color variation within a given height range (ie: underwater, coastal, hill, mountain), and to apply the principle of autoshading across the spectrum (ocean floor / ocean cliff, sandy shore / sandy rocks, grass / rock,  etc) 

>> all while using procedural terrain so no manual painting

---

**notarealmoo** - 2024-05-07 19:27

little problem 🙂

📎 Attachment: image.png

---

**xtarsia** - 2024-05-07 19:37

ah oops

---

**tokisangames** - 2024-05-07 19:39

Get_material() shows you how to lookup textures in the arrays. Follow the examples already there.

---

**notarealmoo** - 2024-05-07 19:53

Thanks. I got two textures on slopes working in a fundamental sense

📎 Attachment: image.png

---

**tokisangames** - 2024-05-07 20:32

Good. 0.0 is already float. Use float when converting an int.

---

**notarealmoo** - 2024-05-07 21:09

thanks got that one. Overall I'm successful. just some tiling issues and tweaking to actually do a rock face

📎 Attachment: image.png

---

**notarealmoo** - 2024-05-08 07:55

Hi. Made a ton of progress! I do have a weird texture line bordering regions. Is there a sort of pixel blend going on?

---

**notarealmoo** - 2024-05-08 07:55

*(no text content)*

📎 Attachment: image.png

---

**notarealmoo** - 2024-05-08 07:56

It ALSO occurs to a degree on a 45 diagonal, sort of like a LOD is cutting through

---

**notarealmoo** - 2024-05-08 07:58

*(no text content)*

📎 Attachment: image.png

---

**xtarsia** - 2024-05-08 08:10

given that you're writing a custom shader, when issues like that come up that aren't present in the generated shader you'd have to look at what you are doing vs the generated implementation.

---

**tokisangames** - 2024-05-08 08:22

The region boundary line is from issue [#185](https://github.com/TokisanGames/Terrain3D/issues/185), solved in PR [#353](https://github.com/TokisanGames/Terrain3D/pull/353). The 45 degree angle is an issue in your shader, not present in the default.

---

**notarealmoo** - 2024-05-08 21:55

Cool. I'm focusing on a distance scale implementation at the moment now. My new question is how to calculate the distance/length from the camera to the vertex, relative to world coordinates (ie: meters).

I plan to use that value to blend the overlap say: [0-32m, scale of 2.0] and [16-64m, scale of 1.0]

---

**notarealmoo** - 2024-05-08 21:57

I do see this in the original vertex shader: v_camera_pos = INV_VIEW_MATRIX[3].xyz;

As well later in the vertex shader: v_vertex_dist = length(v_vertex - v_camera_pos);

I was trying to use v_vertex_dist but I must not understand it's value range

---

**xtarsia** - 2024-05-08 21:58

its the distance in m from that vertex to the camera

---

**notarealmoo** - 2024-05-08 21:58

Oh, I must of not realized.

---

**notarealmoo** - 2024-05-08 22:05

Well, I have a blend of some form implemented but it's all squirrelly. My close / mid range textures are clear. It's the "blend zone" that has the issue

📎 Attachment: image.png

---

**xtarsia** - 2024-05-08 22:08

yeah trying to blend UV directly will cause that, have to use multiple texture samples and then mix between them

---

**notarealmoo** - 2024-05-08 22:13

Oh, I found later on I was multiplying my distanceFactor into the uv. I added it and the squirls went away.

><

---

**notarealmoo** - 2024-05-08 22:17

Ahh it's working! When I'm moving, it's like a morph effect at the various blend zones.

---

**notarealmoo** - 2024-05-08 22:23

I quickly looked at the mterrain 10K terrain video and I see there's texture pop in (and LOD adjustment of the terrain).

In your opinion, is it preferred to have texture resolution pop-in, compared to changing texture scaling?

---

**notarealmoo** - 2024-05-08 22:24

Actually, I'm giving this a live play and the morphing on 'flatish' terrain is not noticable

---

**xtarsia** - 2024-05-08 22:27

i would look at how the dual scaling is implemented

---

**tokisangames** - 2024-05-09 03:56

Yeah, it seems like you're reinventing the wheel. That's great if you want to learn and understand the shader. But so far you're running into challenges that have already been solved.

---

**tokisangames** - 2024-05-09 04:00

The GPU already handles variable texture resolution by distance by using mipmaps. We're changing scale to get maximum use of one most commonly used texture, rock on mountains. Without dual scaling, the texture is useless far away.

---

**tokisangames** - 2024-05-09 04:01

It also automatically handles lods, as it's built into the nature of a clipmap terrain. We have a little pop in, until we implement one of a variety of solutions. I don't know how mterrain works, so can't speak to its design.

---

**tokisangames** - 2024-05-09 04:03

One more note, you should be using a nightly build and learning from the latest shader. There have been significant changes to everything.

---

**notarealmoo** - 2024-05-09 04:17

I'm learning. I've gotten 4 blends working on a procedural terrain using the heights, plus a slope 5th texture. I'm onto Triplanar now, but I'm stuck with trying to translate the sampler2Darray and applying the translation for both the texture and normal

---

**notarealmoo** - 2024-05-09 04:20

I think my current issue is that I can't access the _texturearray while also wanting to apply a Triplanar xyz modification

---

**notarealmoo** - 2024-05-09 04:22

Doesn't like the vec4

📎 Attachment: image.png

---

**notarealmoo** - 2024-05-09 04:23

(ignore the missing z)

---

**notarealmoo** - 2024-05-09 04:54

if it helps - im picking through https://catlikecoding.com/unity/tutorials/advanced-rendering/triplanar-mapping/ chapter 2

---

