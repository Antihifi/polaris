class_name TutorialEntry extends Resource
## Data for a single tutorial category. Author content in the Inspector.

@export var title: String = ""
@export_multiline var brief_tooltip: String = ""  ## Short text shown on hover
@export var implemented: bool = true

@export_group("Detail View")
@export_multiline var detailed_text: String = ""  ## BBCode-formatted verbose description
@export var screenshot: Texture2D  ## Drag a PNG from the FileSystem dock
