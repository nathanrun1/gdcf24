extends Panel
class_name PatternPanel 

func toggleCastPatternPanel(type: String) -> void:
	if type == "directions":
		$"summon patterns".visible = false
		$"direction patterns".visible = true
	elif type == "summon":
		$"summon patterns".visible = true
		$"direction patterns".visible = false
