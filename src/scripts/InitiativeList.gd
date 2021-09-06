extends VBoxContainer

var InitiativeEntry = preload("res://src/scenes/InitiativeEntry.tscn")

onready var initiativeList = get_node("InitiativeEntriesPanelContainer/VBoxContainer")
onready var newInitLineEdit = $"PanelContainer/HBoxContainer/NewInitiativeLineEdit"

func _ready():
    addNewInitiativeEntry(15, "Jonk", 34, 17)
    addNewInitiativeEntry(17, "Amondus", 50, 16)
    addNewInitiativeEntry(12, "Bob", 25, 13)
    loadInitiative("auto.save")

func addNewInitiativeEntry(init, combatantName, hp, ac):
    var initiativeEntry = InitiativeEntry.instance()
    initiativeEntry.setup(init, combatantName, hp, ac)
    initiativeList.add_child(initiativeEntry)
    sortInitiativeList()

func sortInitiativeList():
    var initiativeCopy = initiativeList.get_children()
    initiativeCopy.sort_custom(self, "compareInitiative")
    
    for initiativeEntry in initiativeList.get_children():
        initiativeList.remove_child(initiativeEntry)
    
    for initiativeEntry in initiativeCopy:
        initiativeList.add_child(initiativeEntry)

func compareInitiative(initA, initB):
    return initA.initiative > initB.initiative

func clearInitiativeList():
    for initiativeEntry in initiativeList.get_children():
        initiativeList.remove_child(initiativeEntry)

func parseInitiativeText(new_text):
    var initEntryArray = new_text.split(" ")
    if initEntryArray == null or initEntryArray.size() != 4 or int(initEntryArray[0]) == 0:
        return

    addNewInitiativeEntry(int(initEntryArray[0]), initEntryArray[1], initEntryArray[2], initEntryArray[3])
    newInitLineEdit.text = ""

func saveInitiative(fileName):
    var savedInitiativeJson = getInitiativeListJson()
    var saveFile = File.new()
    saveFile.open("user://" + fileName, File.WRITE)
    saveFile.store_line(savedInitiativeJson)
    saveFile.close()

func loadInitiative(fileName):
    var saveFile = File.new()
    var saveFileDirectory = "user://" + fileName
    if not saveFile.file_exists(saveFileDirectory):
        print("Could not find filename[" + fileName + "]")
        return

    clearInitiativeList()
    
    saveFile.open(saveFileDirectory, File.READ)
    var savedInitiativeJson = saveFile.get_line()
    var savedInitiative = parse_json(savedInitiativeJson)
#    print(savedInitiativeJson)

    for index in savedInitiative:
        var initiative = savedInitiative[index]["initiative"]
        var combatantName = savedInitiative[index]["combatantName"]
        var hp = savedInitiative[index]["hp"]
        var ac = savedInitiative[index]["ac"]
        addNewInitiativeEntry(initiative, combatantName, hp, ac)
#        print(savedInitiative[index])
#        print(savedInitiative[index]["combatantName"])

func getInitiativeListJson():
    var savedInitiative = {}
    var index = 0
    for initiativeEntry in initiativeList.get_children():
        if initiativeEntry["initiative"] == -1:
            continue
        savedInitiative[index] = initiativeEntry.getSaveData()
        index = index + 1
    var savedInitiativeJson = to_json(savedInitiative)
    return savedInitiativeJson


# Signal Handling
func _on_LineEdit_text_entered(new_text):
    parseInitiativeText(new_text)

func _on_TextureButton_pressed():
    var text = newInitLineEdit.text
    parseInitiativeText(text)

func _on_DeleteInitiativeListButton_pressed():
    clearInitiativeList()

func _on_InitiativeListButton_pressed():
    var features = get_tree().get_nodes_in_group("features")
    for feature in features:
        feature.visible = false
    self.visible = true


func _on_SaveButton_pressed():
    saveInitiative("auto.save")
