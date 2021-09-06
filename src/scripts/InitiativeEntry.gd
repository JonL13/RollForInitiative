extends PanelContainer

var initiative = -1
var combatantName = ""
var ac = -1
var hp = -1

func setup(init, comb, newHp, newAc):
    self.initiative = init
    self.combatantName = comb
    self.ac = newAc
    self.hp = newHp
    updateChildren()

func updateChildren():
    $"HBoxContainer/Initiative".text = str(self.initiative)
    $"HBoxContainer/Name".text = str(self.combatantName)
    $"HBoxContainer/AC".text = str(self.ac)
    $"HBoxContainer/HP".text = str(self.hp)

func getSaveData():
    var saved_initiative = {
        "initiative" : self.initiative,
        "combatantName" : self.combatantName,
        "ac" : self.ac,
        "hp" :self.hp
    }
    return saved_initiative

func _on_DeleteButton_pressed():
    queue_free()
