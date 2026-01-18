# First of all, thank you very much for page 1

*Terrain3D Discord Archive - 9 messages*

---

**ludwigseibt** - 2023-12-12 20:13

First of all, thank you very much for the Terrain-3D addon. I am evaluating different terrain addons for Godot at the moment, and this one is by far the most promising.

I have a question about importing data. I have a 4k normalised r16 heightmap that represents 1000m x 1000m horizontally and 100m in height. Is it possible to import this correctly at the moment or does one pixel always represent 1m?

Could you explain the function of the "R 16 Range" and "R 16 Size" Import options in detail?

The screenshot shows my current settings. They result in a 4km long terrain with the correct height.

📎 Attachment: image.png

---

**ludwigseibt** - 2023-12-12 20:46

It looks like changing R 16 Size does not work when Control and Color Maps are selected. Importing only Height File lets me change R 16 Size but still results in artefacts when using a value that is smaller than the image resolution.

---

**tokisangames** - 2023-12-13 03:15

1 pixel = 1m only, at the moment. 
Size is dimensions. Range is height range. Only for r16 files. What else do you want to know about it? 
Control map is proprietary. We do not interpret any other tool's control map.

---

**tokisangames** - 2023-12-13 03:17

Open your file in Krita and resize it to 1000x1000 if you want the world to be only 1000x1000.

---

**tokisangames** - 2023-12-13 03:19

We don't scale image dimensions at all currently. Only heights.

---

**tokisangames** - 2023-12-13 03:49

I just imported an r16 height and a color map simultaneously just fine.

---

**ludwigseibt** - 2023-12-13 07:10

Thank you.
How is R 16 Size supposed to behave when it is (a) smaller than the imported image or (b) greater than the imported image?

---

**tokisangames** - 2023-12-13 07:26

If you type a different size in `r16 size` than the actual size of your image data, you will get garbage results. The r16 file is just an array of data without dimension information. You are telling it how to interpret the data. If you give it wrong information you get wrong results.
1px = 1m. If you import 4096p you get 4096m. If you want 1024m from your 4096p image, resize it in Krita down to 1024 and import a 1024p r16 file.

---

**ludwigseibt** - 2023-12-13 15:31

I see, understood. Its the same as working with raw volume data where you need to specify the dimensions to get a correct interpretation. I wrongly assumed that this option was used to crop/repeat the image to achieve different sizes.

---

