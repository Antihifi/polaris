Phase 1: Prepare Meshes
1.1 — Separate into modular pieces

Starting from your pre-rigging save with the decimated model (18K tris), separate into individual mesh objects. Select mesh → Edit Mode → select vertices → P > Selection. Use L (Select Linked) for geometry islands.

Mesh Object	Contents
Head	Face, ears, neck skin
Eyes	Eyeballs (separate for shader control)
Facial_Hair	Beard cards
Hat	Welsh wig / officer cap
Jacket	Torso, sleeves, collar — merge eyelets, buttons, harness, collar base into this
Trousers	Legs, waistband — merge button ties into this
Boots	Boots — merge eyelets into this
Gloves	Both gloves (keep as one mesh, both bound to same armature)
Fur_Hood	Hood fur ring only
Fur_Glove_Left	Left wrist fur cuff
Fur_Glove_Right	Right wrist fur cuff
1.2 — Sculpt hand poses

Before binding, edit the glove vertices into final hand shapes:

Select Gloves → Edit Mode
Right hand — select finger vertices, rotate/move into a loose grip (for holding weapons/tools). Slight curl at knuckles, thumb wrapped around.
Left hand — select finger vertices, shape into a relaxed curl (support hand position)
Both hands: bring fingers together (no splay), natural slight bend
1.3 — Add bone stubs at cut points

Model small exposed bone geometry at every dismemberment joint. These are simple cylinder/cone shapes poking out ~2-3cm from the cut surface.

Stub	Add to which mesh	Location	Bind to bone
Shoulder stub (left)	Jacket (torso side)	Left shoulder seam, pointing outward	mixamorig_LeftShoulder
Shoulder stub (right)	Jacket (torso side)	Right shoulder seam, pointing outward	mixamorig_RightShoulder
Upper arm stub (left)	Jacket (sleeve side)	Left shoulder seam, pointing inward	mixamorig_LeftArm
Upper arm stub (right)	Jacket (sleeve side)	Right shoulder seam, pointing inward	mixamorig_RightArm
Hip stub (left)	Trousers (torso side)	Left hip seam, pointing downward	mixamorig_LeftUpLeg
Hip stub (right)	Trousers (torso side)	Right hip seam, pointing downward	mixamorig_RightUpLeg
Femur stub (left)	Trousers (leg side)	Left hip seam, pointing upward	mixamorig_LeftUpLeg
Femur stub (right)	Trousers (leg side)	Right hip seam, pointing upward	mixamorig_RightUpLeg
Neck stub (top)	Jacket (torso side)	Neck seam, pointing upward	mixamorig_Neck
Spine stub (bottom)	Head (head side)	Neck seam, pointing downward	mixamorig_Head
Important: The stubs must be part of the mesh they'll stay with after separation. The arm's stub goes on the sleeve geometry (it travels with the severed arm). The torso's stub goes on the torso geometry (it stays on the body).

Keep stubs hidden inside the mesh at rest — they only become visible when the other side is removed and the cut surface is exposed. Model them slightly recessed so they don't clip through clothing during normal gameplay.

1.4 — Ensure clean edge loops at cut seams

At every dismemberment joint (shoulders, hips, neck), make sure there is a clean edge loop where the geometry can be separated cleanly. No shared vertices across the cut line between the torso portion and the limb portion.

If the jacket sleeve shares vertices with the jacket torso at the shoulder, select the edge loop at the seam → Mesh > Split > Faces by Edges. This creates duplicate vertices at the seam so the geometry can later be separated without tearing.

Phase 2: Import and Prepare Armature
2.1 — Import Mixamo armature

File > Import > FBX → navigate to your Godot project → select characters/captain/Idle.fbx
In Object Mode, expand the imported hierarchy in the Outliner
Delete all the Mixamo MESH objects — keep only the Armature
Select the Armature → Ctrl+A > All Transforms
2.2 — Rename bones to mixamorig convention

Select the armature, open Blender's Scripting tab, paste and run:


import bpy

rename_map = {
    "Hips": "mixamorig_Hips",
    "Spine": "mixamorig_Spine",
    "Chest": "mixamorig_Spine1",
    "UpperChest": "mixamorig_Spine2",
    "Neck": "mixamorig_Neck",
    "Head": "mixamorig_Head",
    "LeftShoulder": "mixamorig_LeftShoulder",
    "LeftUpperArm": "mixamorig_LeftArm",
    "LeftLowerArm": "mixamorig_LeftForeArm",
    "LeftHand": "mixamorig_LeftHand",
    "LeftIndexProximal": "mixamorig_LeftHandIndex2",
    "LeftIndexIntermediate": "mixamorig_LeftHandIndex3",
    "LeftIndexDistal": "mixamorig_LeftHandIndex4",
    "RightShoulder": "mixamorig_RightShoulder",
    "RightUpperArm": "mixamorig_RightArm",
    "RightLowerArm": "mixamorig_RightForeArm",
    "RightHand": "mixamorig_RightHand",
    "RightIndexProximal": "mixamorig_RightHandIndex2",
    "RightIndexIntermediate": "mixamorig_RightHandIndex3",
    "RightIndexDistal": "mixamorig_RightHandIndex4",
    "LeftUpperLeg": "mixamorig_LeftUpLeg",
    "LeftLowerLeg": "mixamorig_LeftLeg",
    "LeftFoot": "mixamorig_LeftFoot",
    "LeftToes": "mixamorig_LeftToeBase",
    "RightUpperLeg": "mixamorig_RightUpLeg",
    "RightLowerLeg": "mixamorig_RightLeg",
    "RightFoot": "mixamorig_RightFoot",
    "RightToes": "mixamorig_RightToeBase",
}

armature = bpy.context.active_object
if armature and armature.type == 'ARMATURE':
    count = 0
    for bone in armature.data.bones:
        if bone.name in rename_map:
            bone.name = rename_map[bone.name]
            count += 1
    print(f"Renamed {count} bones successfully!")
else:
    print("ERROR: Select the armature first!")
Note: If the FBX imports with bones already named mixamorig_*, skip the rename script — they're already correct. Check the bone names in the Outliner first.

Phase 3: Align Meshes to Armature
3.1 — Position and scale

Move/scale your HQ meshes so they overlay the armature. Hips should overlap, heights should match. If you scale anything: Ctrl+A > All Transforms afterward.

3.2 — Edit arm meshes to T-pose

The HQ mesh is in A-pose, the Mixamo armature is in T-pose. Only the arms differ (~30-45°).

Left arm:

Select the armature → Pose Mode → click mixamorig_LeftArm
Shift+S > Cursor to Selected (places 3D cursor at shoulder joint)
Back to Object Mode
Select ALL meshes that have left arm geometry (Jacket, Gloves, Fur_Glove_Left) → Shift+Click each
Tab into Edit Mode (multi-object editing)
Set pivot point to 3D Cursor (dropdown in viewport header)
Alt+A to deselect all
Select all left arm vertices from shoulder to fingertips — use C (circle select), rotate view to get all sides
R > Y > 35 > Enter (if arm goes wrong direction, undo, try -35 or axis X)
Z > Wireframe to verify arm mesh overlays the armature bones
Right arm:

Tab back to Object Mode
Armature → Pose Mode → click mixamorig_RightArm → Shift+S > Cursor to Selected
Object Mode → select the same arm meshes → Tab Edit Mode
Alt+A → select right arm vertices → R > Y > -35 > Enter (opposite sign)
Wireframe verify
Phase 4: Bind Meshes to Armature
4.1 — Bind solid meshes (Automatic Weights)

For each solid mesh, one at a time:

Select the mesh first, then Shift+Click the armature (armature must be selected LAST)
Ctrl+P > Armature Deform > With Automatic Weights
Bind in this order:

Jacket (most volume, best auto-weights)
Trousers
Boots
Gloves
Head
Eyes
Hat
If "Bone Heat Weighting Failed" on any mesh: Edit Mode → Mesh > Clean Up > Merge by Distance (0.0001) → Mesh > Normals > Recalculate Outside → retry.

4.2 — Bind thin/card meshes (Data Transfer)

For each thin mesh (Fur_Hood, Fur_Glove_Left, Fur_Glove_Right, Facial_Hair):

First bind with Automatic Weights (same Ctrl+P process) — this creates the vertex groups even if the weights are bad
Select the thin mesh
Add modifier → Data Transfer
Set Source to the nearest solid mesh:
Fur_Hood → Source: Jacket
Fur_Glove_Left → Source: Jacket
Fur_Glove_Right → Source: Jacket
Facial_Hair → Source: Head
Enable Vertex Data > Vertex Groups → Nearest Face Interpolated
Click Apply
4.3 — Test everything

Select armature → Pose Mode → rotate bones one at a time:

mixamorig_Head — head, eyes, facial hair, hat, fur hood should follow
mixamorig_Spine — jacket torso, harness, trousers waist should follow
mixamorig_LeftArm — left jacket sleeve, left glove, left fur cuff should follow
mixamorig_RightArm — same, right side
mixamorig_LeftUpLeg — left trouser leg should follow
mixamorig_RightUpLeg — same, right side
mixamorig_LeftFoot / RightFoot — boots should follow
Ctrl+Z to undo all test rotations when done. Verify armature is back in T-pose.

Phase 5: Dismemberment Separation
Do this AFTER binding is confirmed working. The bone stubs you added in Phase 1 are already part of the meshes and bound to bones.

For each limb (left arm, right arm, left leg, right leg, head):

Select armature → Pose Mode
Scale the cut bone to 0 as a visual guide:
Left arm: scale mixamorig_LeftArm to 0
Right arm: scale mixamorig_RightArm to 0
Left leg: scale mixamorig_LeftUpLeg to 0
Right leg: scale mixamorig_RightUpLeg to 0
Head: scale mixamorig_Head to 0
Switch to the relevant mesh → Edit Mode
Select all vertices that belong to the severed portion (the part that detaches). The scaled-to-0 bone shows you where the cut is.
P > Selection — separates into a new mesh object
Rename it: LeftArm_Severed, RightArm_Severed, LeftLeg_Severed, RightLeg_Severed, Head_Severed
Reset the bone scale back to 1
Repeat for next limb
Note: For the jacket, you'll separate sleeve portions. For trousers, leg portions. The head separation comes from the Head mesh. Each severed piece includes its bone stub from Phase 1.

Export limb pieces:

For each severed limb mesh:

Select it + the armature
File > Export > glTF 2.0 (.glb) → check Selected Objects
Save to characters/dismember_parts/left_arm_severed.glb (etc.)
After exporting all limb pieces, delete the severed meshes from the scene (or move to a hidden collection). You don't want them in the main character export.

Phase 6: Final Export
6.1 — Verify scene state

Armature is in T-pose (all bones reset)
Only the INTACT meshes remain (no severed pieces)
All meshes are parented to the armature
All transforms applied (Ctrl+A > All Transforms on everything)
6.2 — Export the full character

Select the armature + all intact mesh children
File > Export > glTF 2.0 (.glb)
Settings:
Format: glTF Binary (.glb)
Selected Objects: checked
Transform: +Y Up (default)
Mesh: Apply Modifiers on, Normals on, Tangents on
Animation: UNCHECK
Skinning: CHECK
Save as characters/main_unit_model/unit_model_modular.glb
6.3 — Save the .blend file

This is your master character file. All future additions (Inuit parka, new hats, naked body) start from here.

Phase 7: Godot Setup
7.1 — Import settings

Select unit_model_modular.glb in FileSystem → Import dock:

Copy the BoneMap from Idle.fbx.import (same mapping: Hips→mixamorig_Hips, Spine→mixamorig_Spine, Chest→mixamorig_Spine1, etc.)
Set retarget/bone_renamer/unique_node/skeleton_name = "Skeleton"
Set animation/import = false
Click Reimport
7.2 — Create wrapper scene

Right-click unit_model_modular.glb → New Inherited Scene
Save as characters/main_unit_model/unit_model.tscn
Select the Skeleton3D node → Inspector → set motion_scale = 0.3143
Right-click Skeleton → Access as Unique Name (adds % prefix)
7.3 — Update captain.tscn (test first)

Delete existing UnitModel node
Drag unit_model.tscn into scene tree as child of root
Rename to UnitModel
Right-click → Editable Children
Select UnitModel/AnimationPlayer → set libraries = { "": unit_animations.tres } → set autoplay = "idle"
Re-add BoneAttachment3D under UnitModel/Skeleton → bone_name = "Spine" → add InteractionCollider child
Test — run the game, verify idle plays, click-to-move works, no floating
7.4 — Update men.tscn and officers.tscn

Same process as captain. Toggle mesh visibility per character type in your setup scripts.

I'm confused as to why we want the fur glove cuffs to have left/rights but we don't want left/right gloves and left/right boots?
You're right to question that — it's inconsistent. The reason I suggested splitting the fur cuffs was for dismemberment (hide one side when an arm is severed). But that same logic applies to gloves and boots.

Split these into left/right:

Mesh	Why
Glove_Left	Hide when left arm severed
Glove_Right	Hide when right arm severed
Boot_Left	Hide when left leg severed
Boot_Right	Hide when right leg severed
Fur_Glove_Left	Hide with left arm
Fur_Glove_Right	Hide with right arm
Fur_Hood, Jacket, Trousers, Hat, Head, Eyes, Facial_Hair stay as single meshes — they're either centerline or don't need per-side toggling.

Good catch. I'll update the guide if you want once you're done with the Blender session.

When I sever each limb, I'm doing so with ALL clothing meshes applied correct?
Yes. When you sever the left arm for example, you're cutting through and separating the left-side geometry from ALL relevant meshes:

Jacket (left sleeve portion)
Glove_Left (entire thing)
Fur_Glove_Left (entire thing)
These all get combined into one LeftArm_Severed.glb that includes jacket sleeve + glove + fur cuff as one export.

Wait — actually that creates a problem. If you have clothing variations (fur cuffs on vs off), you'd need separate severed limb exports for each combination. That's a combinatorial mess.

Better approach: Don't combine them. Export severed pieces per-mesh:

Export	Contents
left_arm_jacket.glb	Jacket left sleeve with shoulder bone stub
left_arm_glove.glb	Left glove
left_arm_fur_cuff.glb	Left fur cuff
Then in Godot, your SeveredLimb scene stacks them the same way the main character does — toggling visibility based on what that character was wearing when they lost the arm.

This is more work now but means you never have to redo dismemberment exports when you add new clothing. A new jacket style just needs its own severed sleeve pieces.

What I mean is I have THREE different types of jackets and TWO different types of gloves... so I'm having ALL of those items on ALL AT ONCE and then severing correct?  We will then instantiate the severed limb that matches the combination of what that character was wearing?  Or am I misunderstanding how this works?
You're understanding it correctly. All clothing variants are on the armature at once. When you do the dismemberment cuts, you cut each clothing piece separately:

The cuts you'd make:

Limb	Pieces to separate
Left arm	Jacket_Navy left sleeve, Jacket_Fur left sleeve, Jacket_Inuit left sleeve, Glove_Left_Wool, Glove_Left_Mitten, Fur_Glove_Left
Right arm	Same, right side
Left leg	Trousers left leg, Boot_Left
Right leg	Same, right side
Head	Head, Eyes, Facial_Hair, Hat, Fur_Hood
Each piece exports as its own .glb. Then in Godot, when a character loses their left arm, you spawn a SeveredLimb node and add the matching pieces as children based on what they were wearing:


# Pseudocode
var severed_arm = SeveredLimb.new()
severed_arm.add(left_arm_jacket_fur)      # because this unit wore fur jacket
severed_arm.add(left_arm_glove_wool)      # because this unit wore wool gloves
# don't add fur cuff — this unit wasn't wearing them
So yes — everything on at once, cut each piece individually, export each piece individually, assemble at runtime to match the character's loadout.

OK, please give me the full step by step one more time.
Complete Blender Session Guide — HQ Modular Character for Polaris

Phase 1: Prepare Meshes
1.1 — Separate into modular pieces

Starting from your pre-rigging save (18K tris), separate into individual mesh objects. Select mesh → Edit Mode → select vertices → P > Selection. Use L (Select Linked) for geometry islands. Use Ctrl+J to merge small details into their parent mesh.

Mesh Object	Contents
Head	Face, ears, neck skin
Eyes	Eyeballs only (separate for shader control)
Facial_Hair	Beard cards
Hat	Welsh wig / officer cap
Jacket_Fur	Current fur-lined jacket — merge eyelets, buttons, harness, collar base into this
Trousers	Legs, waistband — merge button ties into this
Boot_Left	Left boot — merge its eyelets in
Boot_Right	Right boot — merge its eyelets in
Glove_Left_Mitten	Left mitten
Glove_Right_Mitten	Right mitten
Glove_Left_Wool	Left wool glove (sculpt fingers into relaxed grip)
Glove_Right_Wool	Right wool glove (sculpt fingers into grip pose)
Fur_Hood	Hood fur ring only
Fur_Glove_Left	Left wrist fur cuff
Fur_Glove_Right	Right wrist fur cuff
1.2 — Sculpt hand poses on wool gloves

Before binding, edit glove vertices into final hand shapes:

Select Glove_Right_Wool → Edit Mode
Shape fingers into a loose grip (for holding weapons/tools) — slight curl at knuckles, thumb wrapped around, fingers together
Select Glove_Left_Wool → Edit Mode
Shape fingers into a relaxed curl (support hand)
Mittens don't need sculpting — they're already a closed shape
1.3 — Add bone stubs at cut points

Model small exposed bone geometry at every dismemberment joint. Simple cylinder/cone shapes poking out ~2-3cm from the cut surface. Keep them recessed inside the mesh at rest so they don't clip during normal gameplay — they only become visible when the other side is removed.

Torso-side stubs (stay on the body after severing):

Stub	Add to mesh	Location	Will bind to bone
Shoulder bone (left)	Jacket_Fur torso area	Left shoulder seam, pointing outward	mixamorig_LeftShoulder
Shoulder bone (right)	Jacket_Fur torso area	Right shoulder seam, pointing outward	mixamorig_RightShoulder
Hip bone (left)	Trousers torso area	Left hip seam, pointing downward	mixamorig_LeftUpLeg
Hip bone (right)	Trousers torso area	Right hip seam, pointing downward	mixamorig_RightUpLeg
Neck bone	Jacket_Fur collar area	Neck seam, pointing upward	mixamorig_Neck
Limb-side stubs (travel with the severed piece):

Stub	Add to mesh	Location	Will bind to bone
Upper arm bone (left)	Jacket_Fur left sleeve	Left shoulder seam, pointing inward	mixamorig_LeftArm
Upper arm bone (right)	Jacket_Fur right sleeve	Right shoulder seam, pointing inward	mixamorig_RightArm
Femur bone (left)	Trousers left leg	Left hip seam, pointing upward	mixamorig_LeftUpLeg
Femur bone (right)	Trousers right leg	Right hip seam, pointing upward	mixamorig_RightUpLeg
Spine bone	Head	Neck seam, pointing downward	mixamorig_Head
Important: Add the same torso-side stubs to EVERY jacket variant (Jacket_Fur, and later Jacket_Navy, Jacket_Inuit). Each jacket needs its own shoulder and neck stubs. Same for trousers variants if you make them — each needs hip stubs.

1.4 — Ensure clean edge loops at cut seams

At every dismemberment joint (shoulders, hips, neck), ensure no shared vertices cross the cut line between the torso portion and the limb portion.

Select the edge loop at each seam → Mesh > Split > Faces by Edges. This creates duplicate vertices at the seam so geometry can later be separated without tearing.

Check these seams on every mesh that crosses a joint:

Jacket_Fur — shoulder seams (left and right), neck seam
Trousers — hip seams (left and right)
Head — neck seam (bottom edge)
Phase 2: Import and Prepare Armature
2.1 — Import Mixamo armature

File > Import > FBX → select characters/captain/Idle.fbx from your Godot project
Expand the imported hierarchy in the Outliner
Delete all Mixamo MESH objects — keep only the Armature
Select the Armature → Ctrl+A > All Transforms
2.2 — Rename bones to mixamorig convention

Check the bone names first — if the FBX imported with mixamorig_* names already, skip this step.

If bones are named Hips, Spine, etc. (humanoid profile names), select the armature, open Blender's Scripting tab, paste and run:


import bpy

rename_map = {
    "Hips": "mixamorig_Hips",
    "Spine": "mixamorig_Spine",
    "Chest": "mixamorig_Spine1",
    "UpperChest": "mixamorig_Spine2",
    "Neck": "mixamorig_Neck",
    "Head": "mixamorig_Head",
    "LeftShoulder": "mixamorig_LeftShoulder",
    "LeftUpperArm": "mixamorig_LeftArm",
    "LeftLowerArm": "mixamorig_LeftForeArm",
    "LeftHand": "mixamorig_LeftHand",
    "LeftIndexProximal": "mixamorig_LeftHandIndex2",
    "LeftIndexIntermediate": "mixamorig_LeftHandIndex3",
    "LeftIndexDistal": "mixamorig_LeftHandIndex4",
    "RightShoulder": "mixamorig_RightShoulder",
    "RightUpperArm": "mixamorig_RightArm",
    "RightLowerArm": "mixamorig_RightForeArm",
    "RightHand": "mixamorig_RightHand",
    "RightIndexProximal": "mixamorig_RightHandIndex2",
    "RightIndexIntermediate": "mixamorig_RightHandIndex3",
    "RightIndexDistal": "mixamorig_RightHandIndex4",
    "LeftUpperLeg": "mixamorig_LeftUpLeg",
    "LeftLowerLeg": "mixamorig_LeftLeg",
    "LeftFoot": "mixamorig_LeftFoot",
    "LeftToes": "mixamorig_LeftToeBase",
    "RightUpperLeg": "mixamorig_RightUpLeg",
    "RightLowerLeg": "mixamorig_RightLeg",
    "RightFoot": "mixamorig_RightFoot",
    "RightToes": "mixamorig_RightToeBase",
}

armature = bpy.context.active_object
if armature and armature.type == 'ARMATURE':
    count = 0
    for bone in armature.data.bones:
        if bone.name in rename_map:
            bone.name = rename_map[bone.name]
            count += 1
    print(f"Renamed {count} bones successfully!")
else:
    print("ERROR: Select the armature first!")
Phase 3: Align Meshes to Armature
3.1 — Position and scale

Move/scale your HQ meshes so they overlay the armature. Hips should overlap, heights should match. If you scale anything: Ctrl+A > All Transforms on everything afterward.

3.2 — Edit arm meshes to T-pose

The HQ mesh is in A-pose, the Mixamo armature is in T-pose. Only the arms differ (~30-45°).

Left arm:

Select the armature → Pose Mode → click mixamorig_LeftArm
Shift+S > Cursor to Selected (places 3D cursor at shoulder joint)
Back to Object Mode
Select ALL meshes with left arm geometry: Jacket_Fur, Glove_Left_Mitten, Glove_Left_Wool, Glove_Right_Mitten, Glove_Right_Wool, Fur_Glove_Left → Shift+Click each
Tab into Edit Mode (multi-object editing)
Set pivot point to 3D Cursor (dropdown in viewport header)
Alt+A to deselect all
Select all left arm vertices from shoulder to fingertips — use C (circle select), rotate view with MMB to get all sides. Be careful NOT to grab torso vertices.
R > Y > 35 > Enter (if arm goes wrong direction, Ctrl+Z, try -35 or axis X)
Z > Wireframe to verify arm mesh overlays the armature bones
Right arm:

Tab back to Object Mode
Armature → Pose Mode → click mixamorig_RightArm → Shift+S > Cursor to Selected
Object Mode → select all meshes with right arm geometry → Tab into Edit Mode
Alt+A → select right arm vertices → R > Y > -35 > Enter (opposite sign from left)
Wireframe verify
Phase 4: Bind Meshes to Armature
4.1 — Bind solid meshes with Automatic Weights

For each solid mesh, one at a time:

Select the mesh first, then Shift+Click the armature (armature LAST)
Ctrl+P > Armature Deform > With Automatic Weights
Bind in this order (largest/most volume first):

Jacket_Fur
Trousers
Boot_Left
Boot_Right
Glove_Left_Mitten
Glove_Right_Mitten
Glove_Left_Wool
Glove_Right_Wool
Head
Eyes
Hat
If "Bone Heat Weighting Failed" on any mesh: select the mesh → Edit Mode → Mesh > Clean Up > Merge by Distance (0.0001) → Mesh > Normals > Recalculate Outside → retry.

4.2 — Bind thin/card meshes with Data Transfer

For each thin mesh:

Bind with Automatic Weights first (same Ctrl+P process) — this creates the vertex groups even if weights are bad
Select the thin mesh
Add modifier → Data Transfer
Set Source to the nearest solid mesh:
Fur_Hood → Source: Jacket_Fur
Fur_Glove_Left → Source: Jacket_Fur
Fur_Glove_Right → Source: Jacket_Fur
Facial_Hair → Source: Head
Enable Vertex Data > Vertex Groups → Nearest Face Interpolated
Click Apply
4.3 — Test everything

Select armature → Pose Mode → rotate bones one at a time:

mixamorig_Head — head, eyes, facial hair, hat, fur hood follow
mixamorig_Spine — jacket torso, trousers waist follow
mixamorig_LeftArm — left sleeve, left glove, left fur cuff follow
mixamorig_RightArm — right sleeve, right glove, right fur cuff follow
mixamorig_LeftUpLeg — left trouser leg follows
mixamorig_RightUpLeg — right trouser leg follows
mixamorig_LeftFoot / RightFoot — boots follow
Check that bone stubs at cut points move with their parent bones.

Ctrl+Z to undo all test rotations. Verify armature is back in T-pose.

Phase 5: Dismemberment Separation
Do this AFTER Phase 4 binding is confirmed working. Work on one limb at a time.

5.1 — Left arm

Armature → Pose Mode → scale mixamorig_LeftArm to 0 (visual guide for cut line)
Select Jacket_Fur → Edit Mode → select all LEFT SLEEVE vertices (from shoulder seam outward, including the limb-side bone stub) → P > Selection → rename to Jacket_Fur_LeftArm_Severed
Select Glove_Left_Mitten — the entire mesh IS the severed piece, so duplicate it: Object Mode → select it → Ctrl+C → Ctrl+V → rename copy to Glove_Left_Mitten_Severed
Same for Glove_Left_Wool → Glove_Left_Wool_Severed
Same for Fur_Glove_Left → Fur_Glove_Left_Severed
Reset mixamorig_LeftArm scale to 1
5.2 — Right arm

Same process with mixamorig_RightArm and all right-side meshes.

5.3 — Left leg

Scale mixamorig_LeftUpLeg to 0
Trousers → Edit Mode → select left leg vertices (from hip seam down, including limb-side femur stub) → P > Selection → Trousers_LeftLeg_Severed
Duplicate Boot_Left → Boot_Left_Severed
Reset bone scale
5.4 — Right leg

Same process, right side.

5.5 — Head

Scale mixamorig_Head to 0
Head is entirely the severed piece → duplicate → Head_Severed
Duplicate Eyes → Eyes_Severed
Duplicate Facial_Hair → Facial_Hair_Severed
Duplicate Hat → Hat_Severed
Duplicate Fur_Hood → Fur_Hood_Severed
Reset bone scale
5.6 — Export severed pieces

For each severed piece, one at a time:

Select the severed mesh + the armature
File > Export > glTF 2.0 (.glb)
Settings: Selected Objects checked, Animation: UNCHECK, Skinning: CHECK
Save to characters/dismember_parts/
Export file list:


characters/dismember_parts/
  left_arm_jacket_fur.glb
  left_arm_glove_mitten.glb
  left_arm_glove_wool.glb
  left_arm_fur_cuff.glb
  right_arm_jacket_fur.glb
  right_arm_glove_mitten.glb
  right_arm_glove_wool.glb
  right_arm_fur_cuff.glb
  left_leg_trousers.glb
  left_leg_boot.glb
  right_leg_trousers.glb
  right_leg_boot.glb
  head_head.glb
  head_eyes.glb
  head_facial_hair.glb
  head_hat.glb
  head_fur_hood.glb
5.7 — Clean up

Delete ALL _Severed meshes from the scene. Only intact meshes should remain for the main character export.

Phase 6: Final Export
6.1 — Verify scene state

Armature is in T-pose (all bones reset, all scales at 1)
Only INTACT meshes remain (no severed pieces)
All meshes are parented to the armature
Ctrl+A > All Transforms on everything
6.2 — Export the full character

Select the armature + all intact mesh children
File > Export > glTF 2.0 (.glb)
Settings:
Format: glTF Binary (.glb)
Selected Objects: checked
Transform: +Y Up
Mesh: Apply Modifiers on, Normals on, Tangents on
Animation: UNCHECK
Skinning: CHECK
Save as characters/main_unit_model/unit_model_modular.glb
6.3 — Save the .blend file

This is your master character file. All future additions (new jackets, Inuit parka, new hats, naked body mesh) start from here — open this file, add new meshes, bind to the same armature, re-export.

Phase 7: Godot Setup
7.1 — Import settings

Select unit_model_modular.glb in FileSystem → Import dock:

Under _subresources > nodes > PATH:Skeleton3D (or PATH:Armature/Skeleton3D depending on export):
Set retarget/bone_map with SkeletonProfileHumanoid — copy the exact BoneMap from Idle.fbx.import:
bone_map/Hips = mixamorig_Hips
bone_map/Spine = mixamorig_Spine
bone_map/Chest = mixamorig_Spine1
bone_map/UpperChest = mixamorig_Spine2
bone_map/Neck = mixamorig_Neck
bone_map/Head = mixamorig_Head
bone_map/LeftShoulder = mixamorig_LeftShoulder
bone_map/LeftUpperArm = mixamorig_LeftArm
bone_map/LeftLowerArm = mixamorig_LeftForeArm
bone_map/LeftHand = mixamorig_LeftHand
bone_map/LeftIndexProximal = mixamorig_LeftHandIndex2
bone_map/LeftIndexIntermediate = mixamorig_LeftHandIndex3
bone_map/LeftIndexDistal = mixamorig_LeftHandIndex4
(same pattern for Right side)
bone_map/LeftUpperLeg = mixamorig_LeftUpLeg
bone_map/LeftLowerLeg = mixamorig_LeftLeg
bone_map/LeftFoot = mixamorig_LeftFoot
bone_map/LeftToes = mixamorig_LeftToeBase
(same pattern for Right side)
bone_map/Root = (leave empty)
Set retarget/bone_renamer/unique_node/skeleton_name = "Skeleton"
Set animation/import = false
Click Reimport
7.2 — Create wrapper scene

Right-click unit_model_modular.glb → New Inherited Scene
Save as characters/main_unit_model/unit_model.tscn
Select the Skeleton3D node → Inspector → set motion_scale = 0.3143
Right-click Skeleton → Access as Unique Name (adds % prefix)
7.3 — Update captain.tscn (test first)

Delete existing UnitModel node
Drag unit_model.tscn into scene tree as child of root
Rename to UnitModel
Right-click → Editable Children
Select UnitModel/AnimationPlayer → set libraries = { "": unit_animations.tres } → set autoplay = "idle"
Re-add BoneAttachment3D under UnitModel/Skeleton → bone_name = "Spine" → add InteractionCollider (Area3D + CapsuleShape3D) as child
Hide meshes not needed for captain (toggle visible off on clothing variants he doesn't wear)
Test — run the game, verify idle plays, click-to-move works, no floating
7.4 — Update men.tscn and officers.tscn

Same process. Toggle different mesh visibility per character type. Add BoneAttachment3D nodes as needed (RightHand for weapons, etc.).

7.5 — Set up dismemberment scenes

For each severed piece .glb in characters/dismember_parts/:

Create a scene with RigidBody3D root
Add CollisionShape3D + InteractionCollider Area3D
Attach SeveredLimb script
At runtime, assemble matching pieces based on what the character was wearing