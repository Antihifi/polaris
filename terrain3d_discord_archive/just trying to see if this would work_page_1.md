# just trying to see if this would work page 1

*Terrain3D Discord Archive - 35 messages*

---

**elvisish** - 2025-03-07 22:40

just trying to see if this would work with either the parts of the shader where you sample the textures or the final albedo:
```swift
vec4 albedoTextureFiltered(vec2 uv)
    {
        vec2 albedo_texture_size = vec2(textureSize(albedo_texture, 0));

        vec2 tex_pix_a = vec2(1.0 / albedo_texture_size.x, 0.0);
        vec2 tex_pix_b = vec2(0.0, 1.0 / albedo_texture_size.y);
        vec2 tex_pix_c = vec2(tex_pix_a.x,tex_pix_b.y);
        vec2 half_tex = vec2(tex_pix_a.x * 0.5, tex_pix_b.y * 0.5);
        vec2 uv_centered = uv - half_tex;

        vec4 diffuse_color = texture(albedo_texture, uv_centered);
        vec4 sample_a = texture(albedo_texture, uv_centered + tex_pix_a);
        vec4 sample_b = texture(albedo_texture, uv_centered + tex_pix_b);
        vec4 sample_c = texture(albedo_texture, uv_centered + tex_pix_c);

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
```
i can't figure out which part i can pass into this, though, it's a vec4 but it takes a vec2 which i assume is just a texture?

---

**xtarsia** - 2025-03-07 23:23

this is better and faster, but still not great performance wise:

```glsl
vec4 n64(sampler2DArray samp, vec3 uvl, vec2 ddx, vec2 ddy) {
    vec2 texSize = vec2(1024, 1024); // set manually
    vec2 offset = fract(uvl.xy * texSize - vec2(0.5));
    offset -= step(1.0, offset.x + offset.y);
    vec4 c0 = textureGrad(samp, vec3(uvl.xy - (offset)/texSize, uvl.z), ddx, ddy);
    vec2 c1off = vec2(offset.x - sign(offset.x), offset.y);
    vec4 c1 = textureGrad(samp, vec3(uvl.xy - (c1off)/texSize, uvl.z), ddx, ddy);
    vec2 c2off = vec2(offset.x, offset.y - sign(offset.y));
    vec4 c2 = textureGrad(samp, vec3(uvl.xy - (c2off)/texSize, uvl.z), ddx, ddy);
    
    return vec4(c0 + abs(offset.x)*(c1-c0) + abs(offset.y)*(c2-c0));
}
#define textureGrad(s, u, dx, dy) n64(s, u, dx, dy);
```

stick this near the top of the generated override shader.

ripped from: https://godotshaders.com/shader/3-point-texture-filtering/

📎 Attachment: image.png

---

**xtarsia** - 2025-03-07 23:27

make sure to set filter_nearest_mipmap for this one too.

---

**xtarsia** - 2025-03-07 23:43

<@298847767063822346> you can put it at the top of the full shader

---

**elvisish** - 2025-03-07 23:45

Oh thanks, sorry I missed this thread

---

**elvisish** - 2025-03-07 23:47

It looks really cool in that shot, I’ll try it in a sec, but what causes the performance hit that linear filtering doesn’t? I don’t really know the ins and outs of heightmap texturing so for all I know it’s a very different process than regular materials

---

**xtarsia** - 2025-03-07 23:47

likely because its asking the GPU to do things counter to how its setup internally hardware wise. There is a certain amount of "black box" with graphics programming.

---

**xtarsia** - 2025-03-07 23:48

the n64 3 point sampling was a hardware level thing, and this is emulating it on 4 point hardware

---

**xtarsia** - 2025-03-07 23:49

its also multiple every texture call by 3x

---

**elvisish** - 2025-03-07 23:50

Ahh yeah, and is this slower than when the material is on meshes? Or does the terrain shader have to be particularly optimised compared to other materials?

---

**xtarsia** - 2025-03-07 23:52

the default terrain shader with everything enabled is already - frankly - very complicated.

---

**elvisish** - 2025-03-08 00:19

*(no text content)*

📎 Attachment: message.txt

---

**elvisish** - 2025-03-08 00:20

i tried putting it at the top but it doesn't seem to be working, did i need to change something else?

---

**xtarsia** - 2025-03-08 00:25

did you decrease the UV scale of your textures enough?

---

**xtarsia** - 2025-03-08 00:25

in the screen shot above i had uv scale at 0.006

---

**elvisish** - 2025-03-08 00:28

ohh i see it there, i wonder if theres a way of making the texture appear smaller, with the same uv scale effect? like, if the processing could be done *after* its been scaled

---

**elvisish** - 2025-03-08 00:28

*(no text content)*

📎 Attachment: image.png

---

**elvisish** - 2025-03-08 00:28

you can see here the scaling is way too big

---

**xtarsia** - 2025-03-08 00:29

maybe resize the textures to something like 128x128 instead of 1024x1024

---

**elvisish** - 2025-03-08 00:30

its 64x64?

📎 Attachment: image.png

---

**xtarsia** - 2025-03-08 00:31

oh

---

**elvisish** - 2025-03-08 00:31

the scaling is good at 0.5, but the blur isn't noticable?

📎 Attachment: image.png

---

**xtarsia** - 2025-03-08 00:32

vec2 texSize = vec2(1024, 1024); // set manually

---

**xtarsia** - 2025-03-08 00:32

change that

---

**elvisish** - 2025-03-08 00:32

it should look kinda like...

📎 Attachment: Super2520Mario2520642520-2520Garden-468x.png

---

**elvisish** - 2025-03-08 00:32

one sec...

---

**elvisish** - 2025-03-08 00:33

oh wow thanks!

📎 Attachment: image.png

---

**elvisish** - 2025-03-08 00:43

really appreciate your help, and performance seems okay to me, maybe cause its quite low resolution its not too bad?

---

**xtarsia** - 2025-03-08 00:45

Yeah potentially the nearest filtering combined with only 64x64 textures might be letting you get away with it.

---

**xtarsia** - 2025-03-08 14:23

It may be cheaper to manually use 1k textures that are upscale from the 64x64 using this filter style

---

**tokisangames** - 2025-03-08 14:35

Yeah, there's nothing special about the look or behavior of these textures. Just do this affect in photoshop or something and use our default shader. Faster to develop, and faster to run.

---

**elvisish** - 2025-03-10 07:39

that's not true, the 3 point billinear has a diagonal kind of smoothing that isn't possible in regular 4-point smoothing and looking at certain textures up close is very noticable. plus, apparently i can adjust the UV size of the blur which helps get an even more pronounced effect which also isn't possible with the built-in filtering as far as i can tell

---

**tokisangames** - 2025-03-10 08:20

What is the visual difference between doing the diagonal smoothing in photoshop and using that texture as is, vs doing it in the shader? I see no fundamental difference. However using the texture will be far faster to develop and run 3-4x faster.

---

**elvisish** - 2025-03-10 08:32

the texture would have to be giant to look correct and i'd have to keep going back and forth to get the correct size, whereas here i can just set the per texture UV to get the correct visual scaling and the shader will do the blurring at the same resolution

---

**tokisangames** - 2025-03-10 08:32

Ok

---

