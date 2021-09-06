extends VBoxContainer


func _on_SaveLoadButton_pressed():
    var features = get_tree().get_nodes_in_group("features")
    for feature in features:
        feature.visible = false
    self.visible = true
