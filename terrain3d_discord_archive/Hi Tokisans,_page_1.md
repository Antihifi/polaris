# Hi Tokisans, page 1

*Terrain3D Discord Archive - 9 messages*

---

**nerkn** - 2024-07-14 17:28

Hi Tokisans,
my meshes got wild

📎 Attachment: image.png

---

**nerkn** - 2024-07-14 17:29

*(no text content)*

📎 Attachment: image.png

---

**nerkn** - 2024-07-14 17:29

when I try to add bushes, they are also huge and spread to kms far away

---

**nerkn** - 2024-07-14 17:30

little tree added normally to scene, and height should be around 2meters

---

**nerkn** - 2024-07-14 17:31

scale is 100%, other is +- 20%

---

**tokisangames** - 2024-07-14 18:09

Read the instancer documentation page on transforms.
Your meshes are inconsistent and not scaled properly, with centered origins and neutral transforms.
Clean them up. Take them into blender, scale them to real world units, reset the origins, and apply the transforms so they get imported with neutral transforms. Our tool is placing them exactly as the mesh was designed, without any transforms applied. So if they look odd, it's because they are.

---

**nerkn** - 2024-07-14 19:13

how can I remove those already added?

---

**tokisangames** - 2024-07-14 21:19

Hold ctrl to remove the type selected

---

**tokisangames** - 2024-07-14 21:20

But once you fix the mesh and replace it in the asset dock, it will replace those on the ground.

---

