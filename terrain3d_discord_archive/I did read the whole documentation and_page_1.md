# I did read the whole documentation and page 1

*Terrain3D Discord Archive - 27 messages*

---

**tuto193** - 2023-10-26 09:00

I did read the whole documentation and used scaling at `4` as the people from `Geodot` used in their `RasterDemo.gd` example (they only scale the pixel size of the orthophoto, though, since the height map is not normalized). I also tried simply importing the `jpeg` Orthophoto (into the `Color` Layer (?)), but didn't see any changes, or at least I assume that they should be visible after the import is finished, but I don't really notice any changes.
I will post some pics of what I expect to see, and what I'm seeing, and some logs here if that might help

---

**tuto193** - 2023-10-26 09:06

This is what I'm kind of expected to see (it's a 1000x1000 `jpeg` on top of the height map)

📎 Attachment: image.png

---

**tuto193** - 2023-10-26 09:07

Original jpeg

📎 Attachment: vienna-test-ortho.jpg

---

**tokisangames** - 2023-10-26 09:08

I don't know what that tool is or what the export data looks like. Can you import it into standard painting tools and see the heightmap? Jpeg is not the right format to use for importing height data.

---

**tokisangames** - 2023-10-26 09:08

Importing a jpg into the colormap works fine.
https://twitter.com/TokisanGames/status/1683529241634414594?t=-s0fJrpq3b9rsGtqh8TN0g&s=19

---

**tuto193** - 2023-10-26 09:09

Yeah, I'm trying just that at the moment, to see where I'm going wrong, but I don't see anything after the import:

---

**tokisangames** - 2023-10-26 09:10

Scaling normalized data means 300-500, rather than 4. But if it's not normalized, then you need to use another software like Krita / gimp to validate it. It sounds like you're not sure what is in your file

---

**tokisangames** - 2023-10-26 09:11

Turn on debug logging and read the console. It tells you what it's doing, or not doing.

---

**tuto193** - 2023-10-26 09:12

This is what it looks like to import just the color layer (`jpeg`)

📎 Attachment: image.png

---

**tokisangames** - 2023-10-26 09:12

Import height and color together. It may not work independently yet.

---

**tuto193** - 2023-10-26 09:14

The heightmap in question is also just a `GeoTIFF`. I don't expect this part to work directly, and can use other libraries/programs to convert it to `RAW` or `R16`. That's no problem.  Here it is how it looks like

📎 Attachment: image.png

---

**tuto193** - 2023-10-26 09:15

Oh, ok!
I will convert the `tif` to `r16` and try that out then!

---

**tuto193** - 2023-10-26 09:16

I turned it on (set it to `2`), but the output is over 2000 lines long, but I'll try with the convert + both layers together to see if something happens

---

**tuto193** - 2023-10-26 09:16

Thanks a lot for the help so far though!

---

**tokisangames** - 2023-10-26 09:26

You only need to read the lines from the storage module, right after you click import.

---

**tuto193** - 2023-10-26 13:15

I have some weird news, but long story short, I had a hard time converting my `TIF` (heightmap) to `R16` or even `RAW`. `PNG` was off the table due to the limitations and `bmp` didn't work with my current converter. This led me to use `jpeg` as format for the height map, and with some scaling I'm now able to see some bumps! (see below). The problem still seems to be the `jpeg`. This time I even passed it through `GIMP`. The logger output is much more readable, and there seems to be some problem with the formatting, but I'm not sure what exactly what the actual problem is. Here is what I've managed so far:

---

**tuto193** - 2023-10-26 13:15

*(no text content)*

📎 Attachment: image.png

---

**tuto193** - 2023-10-26 13:18

The logger output in question (looks the same whether I use the Orthophoto as `jpeg` or as `png` with the recommended settings from [the wiki](https://github.com/TokisanGames/Terrain3D/wiki/Setting-Up-Textures):

---

**tuto193** - 2023-10-26 13:19

```
Terrain3D::set_debug_level: Setting debug level: 2
Importing files:
        /home/tuto/git/bachelor-thesis/Agrodot/geodata/heightmap.jpeg

        /home/tuto/git/bachelor-thesis/Agrodot/geodata/vienna-test-ortho-png.png
Terrain3DStorage::load_image: Attempting to load: /home/tuto/git/bachelor-thesis/Agrodot/geodata/heightmap.jpeg
Terrain3DStorage::load_image: ImageFormatLoader loading recognized file type: jpeg
Terrain3DStorage::load_image: Loaded Image size: (1000, 1000) format: 0
Terrain3DUtil::get_min_max: Calculating minimum and maximum values of the image: (0, 0.705882)
Terrain3DStorage::load_image: Attempting to load: /home/tuto/git/bachelor-thesis/Agrodot/geodata/vienna-test-ortho-png.png
Terrain3DStorage::load_image: ImageFormatLoader loading recognized file type: png
Terrain3DStorage::load_image: Loaded Image size: (1000, 1000) format: 5
Terrain3DStorage::import_images: Importing image type TYPE_HEIGHT, size: (1000, 1000), format: 0
Terrain3DStorage::import_images: Applying offset: 0, scale: 40
Terrain3DStorage::import_images: Importing image type TYPE_COLOR, size: (1000, 1000), format: 5
Terrain3DStorage::import_images: Creating new temp image to adjust scale: 40 offset: 0
Terrain3DStorage::import_images: Creating (1, 1) slices for (1000, 1000) images.
Terrain3DStorage::import_images: Reviewing image section (0, 0) to (1024, 1024)
Terrain3DStorage::import_images: Uneven end piece. Copying padded slice (0, 0) size to copy: (1000, 1000)
```

---

**tuto193** - 2023-10-26 13:19

```
Terrain3DStorage::import_images: Copying (1000, 1000) sized segment
Terrain3DStorage::add_region: Adding region at (0, 0, 0), uv_offset (0, 0), array size: 3, update maps: yes
Terrain3DStorage::sanitize_maps: Verifying image set is valid: 3 maps of type: TYPE_MAX
Terrain3DStorage::sanitize_maps: Map type TYPE_HEIGHT correct format, size. Using image
Terrain3DStorage::sanitize_maps: Map type TYPE_CONTROL correct format, size. Using image
Terrain3DStorage::sanitize_maps: Map type TYPE_COLOR correct format, size. Using image
Terrain3DUtil::get_min_max: Calculating minimum and maximum values of the image: (0, 28.23529)
Terrain3DStorage::add_region: Checking imported height range: (0, 28.23529)
Terrain3DStorage::add_region: Pushing back 3 images
Terrain3DStorage::add_region: Total regions after pushback: 1
Terrain3DStorage::add_region: Updating generated maps
Terrain3DGeneratedTex::create: RenderingServer creating Texture2DArray, layers size: 1
Terrain3DGeneratedTex::create: 0: <Image#-9223313394226849942>, empty: false, size: (1024, 1024), format: 8
Terrain3DGeneratedTex::create: RenderingServer creating Texture2DArray, layers size: 1
Terrain3DGeneratedTex::create: 0: <Image#-9223313394210073307>, empty: false, size: (1024, 1024), format: 4
Terrain3DGeneratedTex::create: RenderingServer creating Texture2DArray, layers size: 1
Terrain3DGeneratedTex::create: 0: <Image#-9223313394193295605>, empty: false, size: (1024, 1024), format: 5
Terrain3DMaterial::_update_regions: Updating region maps in shader
Terrain3DMaterial::_update_regions: Height map RID: RID(12202384340033350)
```

---

**tuto193** - 2023-10-26 13:19

```
Terrain3DMaterial::_update_regions: Control map RID: RID(12202392929967943)
Terrain3DMaterial::_update_regions: Color map RID: RID(12202405814869822)
Terrain3DMaterial::_update_regions: _region_map.size(): 256
Terrain3DMaterial::_update_regions: Region map
Terrain3DMaterial::_update_regions: Region id: 1 array index: 136
Terrain3DMaterial::_update_regions: Region_offsets size: 1 [(0, 0)]
Terrain3DMaterial::_generate_region_blend_map: Regenerating (512, 512) region blend map
Terrain3DGeneratedTex::clear: GeneratedTex freeing RID(12073526731218666)
Terrain3DGeneratedTex::clear: GeneratedTex unref image<Image#-9223314140477417689>
Terrain3DGeneratedTex::create: RenderingServer creating Texture2D
Terrain3DUtil::dump_gen: Generated blend_map RID: RID(12202418699771626), dirty: false, image: <Image#-9223313394109447051>
```

---

**tuto193** - 2023-10-26 13:20

[It ends there]

---

**tokisangames** - 2023-10-26 14:26

JPG and PNG are unusable 8-bit formats for height data. You'll end up with blocky garbage. Only use R16 or EXR. Not many paint apps work with R16, but krita supports it.
The import log looks fine. Now that I'm home, I'm testing it. The latest restructuring may have broken it. I believe you said you're running the master branch, which is inherently less stable. The last binary release is more tested and probably imports better.

---

**tokisangames** - 2023-10-26 14:56

Ah, the importer and colormap aren't broken. Importing the colormap by itself works fine. Disable the checkered view in the material debug view settings and enable the colormap. Checkers are enabled by default when you have no texture slots. It's designed for using texture slots, but you can override it this way. You can then enable the override shader.

---

**tokisangames** - 2023-10-26 15:05

As for importing heights, it's also working fine, provided your source files are accurate and you are scaling any normalized heightmaps. So the problem here is likely just lack of experience manipulating images in image programs. 
Tiff is not yet supported by Godot. So open up the file in krita and make sure it looks like a heightmap, then save it as r16 or exr. If the former, use the r16 parameters to scale it up. If the later, the import scaler on the order of 300-500.
If you open it in krita and it doesn't look like a heightmap, then you need to learn more about how your data is stored, exported from the source tool, and how to make sense of it in other tools.

---

**tokisangames** - 2023-10-26 19:57

I pushed some updates that improve the handling of colormap importing. Now if the texture list is empty and a colormap is imported, it will automatically disable checkers and enable the colormap. Also it properly handles colormaps as srgb and converts to linear in the shader, instead of storing as linear, previously

---

**tuto193** - 2023-10-27 15:46

Yes that was it! I see stuff! Thanks a lot!

---

