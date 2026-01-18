# Terrain3D + LayerProcGen thread page 1

*Terrain3D Discord Archive - 126 messages*

---

**dekker3d** - 2024-08-19 20:08

Okay, Terrain3D + LayerProcGen thread starts *here.*

---

**dekker3d** - 2024-08-19 20:09

Right. <@211506854138740736>

---

**dekker3d** - 2024-08-19 20:09

Lemme look at my code, see what I can tell you.

---

**sythelux** - 2024-08-19 20:09

kk when I reach the point you can help me with wayfinding if you want btw

---

**dekker3d** - 2024-08-19 20:10

With baking navigation regions in realtime? Yeah, sure.

---

**sythelux** - 2024-08-19 20:10

it is doing nasty stuff

📎 Attachment: Bildschirmfoto_vom_2024-07-04_22-45-07.png

---

**dekker3d** - 2024-08-19 20:10

Oh my.

---

**sythelux** - 2024-08-19 20:10

ah not really

---

**sythelux** - 2024-08-19 20:10

it is literally building ways with slopes etc

---

**sythelux** - 2024-08-19 20:10

which can later be baked

---

**dekker3d** - 2024-08-19 20:11

Anyway, right now I only have a single TerrainHeightLayer thing, which does some basic FastNoiseLite stuff. Nothing special there. I did optimize the functions for actually feeding this into Terrain3D quite a bit, though.

---

**sythelux** - 2024-08-19 20:12

I'm doing that with heightmap images now, because that was the fastest

---

**sythelux** - 2024-08-19 20:12

aka the extra thread is generating an heightmap image which I then set synchronized

---

**dekker3d** - 2024-08-19 20:12

So my TerrainHeightLayer chunk simply has a float[,] heights, and the actual layer has separate functions to get the heights for the terrain (as a byte[] to create an Image from) and for physics (as a float[,] for a heightmapshape)

---

**dekker3d** - 2024-08-19 20:13

Because creating an Image from byte[] data is actually super fast.

---

**sythelux** - 2024-08-19 20:13

I realized that too

---

**sythelux** - 2024-08-19 20:13

there is also "terrain.HeightMap.BlitRect(heightmap, new Rect2I(0, 0, heightmap.GetWidth(), heightmap.GetHeight()), new Vector2I(startPos.x, startPos.y));"

---

**sythelux** - 2024-08-19 20:13

you can just blit the image into another

---

**dekker3d** - 2024-08-19 20:14

My TerrainLayer (which applies the heights from the TerrainHeightLayer) calls TerrainGenerator.FeedTerrainChunk. TerrainGenerator is mostly a wrapper for the Terrain3D class, really.

---

**dekker3d** - 2024-08-19 20:14

```public void FeedTerrainChunk(byte[] height, byte[] control, byte[] colour, float low, float high, Vector3 position)
{
    ulong time = Time.GetTicksUsec();

    Image img = Image.CreateFromData(1024, 1024, false, Image.Format.Rf, height);
    Image ctrl = Image.CreateFromData(1024, 1024, false, Image.Format.Rf, control);
    Image col = Image.CreateFromData(1024, 1024, false, Image.Format.Rgba8, colour);
    AddRegion(img, ctrl, col, position, true);
    UpdateHeights(low, high);

    time = Time.GetTicksUsec() - time;
    GD.Print(string.Format("Loaded terrain chunk, time in uS: {0}", time));
    Vector3I index = (Vector3I)((position / 1024).Floor()) * 1024;
    NavRegionManager.Instance.RegionLoadedUnitRect(new Rect2I(index.X, index.Z, 1024, 1024));
}```
My FeedTerrainChunk function.

---

**dekker3d** - 2024-08-19 20:14

Blitting is fine, but with the way Terrain3D currently works, there's really no point in doing terrain chunks in any size other than 1024x1024.

---

**dekker3d** - 2024-08-19 20:15

*Most* of the time is spent in the terrain update function anyway, which takes just as long if your chunks are large or small... and if your chunks are small, you're calling it much more often.

---

**sythelux** - 2024-08-19 20:15

yes that was a compromise, because the original demo was using different sized grids and I wanted to support that

---

**dekker3d** - 2024-08-19 20:15

It'll work better after some optimizations. Most of the time it spends really isn't necessary.

---

**sythelux** - 2024-08-19 20:16

I don't know why he put most of the things in except for showcasing, which I just reconstructed

---

**sythelux** - 2024-08-19 20:16

when I'll add it to my real project I probably only do 1024 grid

---

**dekker3d** - 2024-08-19 20:16

Well, it's a demo project.

---

**sythelux** - 2024-08-19 20:16

yes

---

**dekker3d** - 2024-08-19 20:16

It's basically meant to showcase stuff, right?

---

**dekker3d** - 2024-08-19 20:16

```public byte[] GetHeightsForTerrain(ILC requestingChunk, GridBounds bounds)
{
    byte[] heights = new byte[bounds.size.x * bounds.size.y * 4];
    int relX;
    int relY;
    HandleGridPoints(requestingChunk, bounds, chunkSize, (chunk, point, globalPoint) => {
        relX = globalPoint.x - bounds.min.x;
        relY = globalPoint.y - bounds.min.y;
        byte[] bytes = BitConverter.GetBytes(chunk.heights[point.x, point.y]);
        Buffer.BlockCopy(bytes, 0, heights, (relX + relY * 1024) * 4, 4);
    });
    return heights;
}```

The GetHeightsForTerrain function, used in TerrainHeightLayer

---

**sythelux** - 2024-08-19 20:17

```c#
public static class TerrainNoise
    {
        private static FastNoiseLite Noise;
        private static float TotalHeight = 1;
        private static float MinHeight = 0;

        private static Vector2 TerrainHeight { get; set; }

        public static void SetFullTerrainHeight(Vector2 terrainHeight)
        {
            TerrainHeight = terrainHeight;
            TotalHeight = Mathf.Abs(terrainHeight.X) + terrainHeight.Y;
            MinHeight = Mathf.Abs(terrainHeight.X);
        }

        public static float GetHeight(Vector2 coords)
        {
            return Mathf.Clamp(( Noise.GetNoise2Dv(coords)+ 1f) / 2f, 0, 1) * (TotalHeight - MinHeight) + MinHeight;
        }

        static TerrainNoise()
        {
            Noise = new FastNoiseLite();
            Noise.SetNoiseType(FastNoiseLite.NoiseTypeEnum.Simplex);

            Noise.SetFrequency(0.002f);
            Noise.SetFractalLacunarity(2f);
            Noise.SetFractalGain(0.5f);
            Noise.SetFractalOctaves(4);

            Noise.SetFractalType(FastNoiseLite.FractalTypeEnum.Fbm);
        }
    }
```

---

**dekker3d** - 2024-08-19 20:17

BlockCopy is a fast way to turn a float into 4 bytes for the terrain height image.

---

**sythelux** - 2024-08-19 20:17

I just made the TerainNoise a wrapper for FastNoise ^^

---

**dekker3d** - 2024-08-19 20:18

Ah

---

**sythelux** - 2024-08-19 20:18

I'll remember that.

---

**dekker3d** - 2024-08-19 20:19

Basically, you don't want to be swapping chunks constantly, so if you want to do something that requires adjacent grid points (pixels, or such), you should probably do it in a kind of awkward fashion...

---

**dekker3d** - 2024-08-19 20:19

For example, terrain normals or tangents.

---

**dekker3d** - 2024-08-19 20:20

For each point that you want data for, you need to sample 4 points around it. Best way to do that in LayerProcGen seems to be to just... do one neighbouring point for each grid point first, then do the next neighbouring point, etc.

---

**dekker3d** - 2024-08-19 20:20

So you sample the point to the left first, then the point to the right, then the point above, then the point below... or something like that.

---

**dekker3d** - 2024-08-19 20:20

And you should be able to do the math to get the values you need.

---

**dekker3d** - 2024-08-19 20:21

This is likely to be faster than actually... trying to get each neighbouring point in order, for each grid point.

---

**dekker3d** - 2024-08-19 20:22

The above is also a reason why Terrain3D's function for generating navmesh baking data is so slow. It calls getpixel() about 26 times for each vertex in the area you're trying to bake, and each getpixel() calls that function for getting a region map, which uses that Ref<Image> thing that's so terribly slow.

---

**dekker3d** - 2024-08-19 20:23

If it's changed to do one region at a time, it would be fine even if Ref<> is slow.

---

**sythelux** - 2024-08-19 20:23

probaby is. I try to see where I can use that

---

**dekker3d** - 2024-08-19 20:24

Well, terrain normals are likely to be relevant if you want to change the textures based on slopes, without using the autoshader.

---

**sythelux** - 2024-08-19 20:24

ah yes well I realised too, that it is sometimes easier to change the workflow with the data you have at hand

---

**dekker3d** - 2024-08-19 20:25

I noticed the filenames on your screenshots. You're German/Austrian?

---

**sythelux** - 2024-08-19 20:25

aye I have a problem with that thing in timing
for placing gras I need the autoshader, but before that I need to set the heightmap.

---

**sythelux** - 2024-08-19 20:25

yeah German

---

**dekker3d** - 2024-08-19 20:25

Why do you need the autoshader for placing grass?

---

**dekker3d** - 2024-08-19 20:26

I'm Dutch, by the way.

---

**sythelux** - 2024-08-19 20:26

the grass transforms should only be visible on the grass texture and not on rock

---

**dekker3d** - 2024-08-19 20:26

https://github.com/TokisanGames/Terrain3D/pull/374 this is the PR I'm waiting for, by the way. Cory says it shouldn't take too long to finish.

---

**dekker3d** - 2024-08-19 20:26

Ah, yeah.

---

**sythelux** - 2024-08-19 20:27

it would be cool to have AddTransforms to somewhat synchronize/filter with the autoshader

---

**dekker3d** - 2024-08-19 20:27

Tbh, if you're doing terrain generation like this, you would probably want to have manual control over textures anyway, and not bother with the autoshader.

---

**sythelux** - 2024-08-19 20:27

I'm doing it manually and it is slow as hell

📎 Attachment: image.png

---

**dekker3d** - 2024-08-19 20:27

Ah, lol, not what I meant.

---

**sythelux** - 2024-08-19 20:28

yeee I know, but it is sad

---

**dekker3d** - 2024-08-19 20:28

I meant just calculating the normal, and then deciding the texture based on that.

---

**sythelux** - 2024-08-19 20:28

I know what you meant sorry the pic was to emphazise my point above

---

**dekker3d** - 2024-08-19 20:28

I'll let you know when I get around to that. I've been messing around trying to make some decent general-purpose functions to address this kind of problem.

---

**sythelux** - 2024-08-19 20:29

btw about the different sized region

---

**sythelux** - 2024-08-19 20:29

is that a global setting aka they will all be 1024 or 512 or is that a per region setting?

---

**dekker3d** - 2024-08-19 20:29

Global.

---

**dekker3d** - 2024-08-19 20:29

Many things would be much harder to deal with if chunks could vary in size per chunk.

---

**dekker3d** - 2024-08-19 20:29

And there's no real reason to do so.

---

**sythelux** - 2024-08-19 20:29

ayeee

---

**dekker3d** - 2024-08-19 20:29

Shaders don't like that kind of complexity.

---

**sythelux** - 2024-08-19 20:30

makes sense and yes you'd need to have region fitting algorithms

---

**sythelux** - 2024-08-19 20:30

really tough matter, but if it is a global setting then I can continue with the 1024 so it is not really relevant for me

---

**dekker3d** - 2024-08-19 20:31

One of my pending PRs is about region sizes. But that'll have to be updated when that one PR hits, too.

---

**sythelux** - 2024-08-19 20:31

ok should I wait for the autoshader being queryable or really implement the normal calculation (aka I borrow it from LayerProcGen anyway)

---

**dekker3d** - 2024-08-19 20:31

My own opinion is that you should really not be using the autoshader for this.

---

**sythelux** - 2024-08-19 20:32

this is fine. I appreciate your opinion on that

---

**sythelux** - 2024-08-19 20:32

for me it was really a 50:50 choice

---

**dekker3d** - 2024-08-19 20:32

Any kind of interesting terrain generation will require you to know the normals or slope anyway.

---

**dekker3d** - 2024-08-19 20:32

Consider wind erosion, or sun exposure.

---

**dekker3d** - 2024-08-19 20:33

Wind erosion would mostly come from directions that have few obstacles, ideally flat stuff like large bodies of water. Sun exposure is mainly the south, and some on the southwest and southeast, facing partially up.

---

**dekker3d** - 2024-08-19 20:33

You might also want to mess with heights more or less depending on the existing slope. Like the gradient trick for quick eroded-looking infinite terrain.

---

**dekker3d** - 2024-08-19 20:34

https://www.youtube.com/watch?v=gsJHzBTPG0Y this vid is about that gradient trick.

---

**sythelux** - 2024-08-19 20:35

hahaha okay okay...
for 4 weeks youtube is recommending me this video at home and at work and I never wanted to watch it, but I guess I'll finally do it

---

**dekker3d** - 2024-08-19 20:35

Hah.

---

**sythelux** - 2024-08-19 20:35

although I probably won't include any of that

---

**dekker3d** - 2024-08-19 20:35

I found it an interesting watch.

---

**dekker3d** - 2024-08-19 20:35

It explains things at a nice pace, and quite clearly.

---

**sythelux** - 2024-08-19 20:35

Aye I'll watch it now

---

**dekker3d** - 2024-08-19 20:35

First half is gradient trick, second half is some other thing.

---

**sythelux** - 2024-08-19 20:37

this might be a reallly cool video for Terrain3D itself

---

**sythelux** - 2024-08-19 20:38

I kinda hope that I can provide the example for the plateaus, and ways at some point with baked meshes to have a demo for Tokisan as well

---

**dekker3d** - 2024-08-19 20:40

What do you mean?

---

**sythelux** - 2024-08-19 20:42

getting this mess fixed

📎 Attachment: Bildschirmfoto_vom_2024-07-06_10-49-41.png

---

**sythelux** - 2024-08-19 20:42

I think it explains itself better, when I have it implemented

---

**dekker3d** - 2024-08-19 20:42

Ah

---

**dekker3d** - 2024-08-19 20:43

Is your current code on GitHub? I could take a look later, if I can gather the dopamine for it.

---

**sythelux** - 2024-08-19 20:43

hehe

---

**dekker3d** - 2024-08-19 20:44

ADHD is a bit of a pain :P

---

**sythelux** - 2024-08-19 20:44

current code is not. it is rather broken

---

**sythelux** - 2024-08-19 20:44

I think the code with the failing wayfinding is actually there

---

**dekker3d** - 2024-08-19 20:45

By the way, this may have already been obvious by what I said earlier, but I don't use Terrain3D's physics.

---

**dekker3d** - 2024-08-19 20:45

Because if you do that, it has to re-generate all the physics stuff from scratch every time you update any part of the terrain.

---

**dekker3d** - 2024-08-19 20:45

Obviously not good for this.

---

**dekker3d** - 2024-08-19 20:47

```public float[,] GetHeightsForPhysics(ILC requestingChunk, GridBounds bounds, int step)
    {
        bounds = new GridBounds(bounds.min / step, bounds.size / step);

        bounds.Expand(0, 1, 0, 1); // We need that last point for the last part of the physics mesh.
        float[,] heights = new float[bounds.size.x, bounds.size.y];
        HandleGridPoints(requestingChunk, bounds, chunkSize/step, (chunk, point, globalPoint) => {
            Point relative = globalPoint - bounds.min;
            SetHeight(heights, relative.y, relative.x, chunk.heights[point.x * step, point.y * step]);
        });
        return heights;
    }

    internal void SetHeight(float[,] heights, int x, int y, float val)
    {
        heights[x, y] = val;
    }```
The function for that one. Note that the order is slightly different.

---

**dekker3d** - 2024-08-19 20:47

And obviously we need an extra little bit, to bridge the gap from one chunk to the next. Hence the bounds.Expand

---

**dekker3d** - 2024-08-19 20:48

SetHeight is just... for setting heights, because I was having trouble with my lambda stuff. It shouldn't be necessary.

---

**dekker3d** - 2024-08-19 20:49

```    public CollisionShape3D BuildPhysicsModelShape(float[,] heights)
    {
        HeightMapShape3D shape = new HeightMapShape3D();
        shape.MapDepth = heights.GetLength(0);
        shape.MapWidth = heights.GetLength(1);
        shape.MapData = heights.Cast<float>().ToArray();

        CollisionShape3D cs = new CollisionShape3D();
        cs.Shape = shape;
        cs.Scale = new Vector3(step, 1, step);
        return cs;
    }

    public StaticBody3D BuildPhysicsBody(CollisionShape3D shape)
    {
        StaticBody3D body = new StaticBody3D();
        body.CollisionLayer = 2;
        body.CollisionMask = 2;
        body.AddChild(shape);
        body.Position = worldOffset.xoy + new Vector3(TerrainPhysicsLayer.instance.chunkW / 2, 0, TerrainPhysicsLayer.instance.chunkH / 2 - step);
        body.AddToGroup("Navigation");
        body.AddToGroup("ClickableTerrain");
        MapManager.Instance.CurrentMap.AddChild(body);
        return body;
    }```
The stuff for making the physics shapes.

---

**tokisangames** - 2024-08-19 20:54

Real landscapes and realistic 3D environments don't use grass textures and put grass on dirt or debris. In OOTA we have 4 grass textures but are considering dropping all of them.

---

**sythelux** - 2024-08-19 20:54

wow I thought I could just let it bake a mesh and use the mesh for a mesh collider

---

**tokisangames** - 2024-08-19 20:55

You can already query the autoshader. Using get_texture_id(), or look at its code for your own use

---

**dekker3d** - 2024-08-19 20:55

Nope, that uses the same function and would be... just as slow to generate, but also even slower for the actual physics.

---

**sythelux** - 2024-08-19 20:55

the old H0 modeller trick is to have a brown texture, when you have dense grass litter and green texture, when you have less dense grass litter ^^

---

**dekker3d** - 2024-08-19 20:55

<@455610038350774273> Syd was already using that.

---

**dekker3d** - 2024-08-19 20:56

My first thought was of hair, which is done similarly: a vaguely hair-coloured blob covering the scalp under any actual hair model, so that if you see a gap in the model, it still looks kinda like hair.

---

**dekker3d** - 2024-08-19 20:57

It's also an okay-ish way to deal with PCs that need a lower density of foliage and such.

---

**dekker3d** - 2024-08-19 20:57

And terrain in the distance, outside of the render distance of your foliage.

---

**dekker3d** - 2024-08-19 20:57

So I would definitely use grass models on top of a grassy texture.

---

**dekker3d** - 2024-08-19 20:58

Though the grassy texture could have dirt showing through, too.

---

**sythelux** - 2024-08-19 20:59

I have to wait with the grass models until I have the recalc function in the C# wrapper ^^''

---

**tokisangames** - 2024-08-19 20:59

One of our references. Low foliage count. No grass textures.
https://www.youtube.com/watch?v=YkpvAOYo3Ok

---

**dekker3d** - 2024-08-19 20:59

That does look nice.

---

**dekker3d** - 2024-08-19 21:00

I'm aiming for a much less realistic art style, myself. Dunno how well it would work with that. But that's nice.

---

**sythelux** - 2024-08-19 21:01

realised when playing GTAV again, that it also helps to have patches of different flowers or just other grass mixed in.

---

**dekker3d** - 2024-08-19 21:01

Mhm

---

**tokisangames** - 2024-09-02 05:26

The first noise algorithm in the video is how we generate the world background noise. It has a very good explanation. I understand it much better now.

---

**dekker3d** - 2024-09-02 07:02

Oh, that's neat! I assumed it'd be pure perlin.

---

**dekker3d** - 2024-09-02 07:03

I do like how cleanly that video explains it.

---

