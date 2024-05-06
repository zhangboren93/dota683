require("../../items/item_magic_stick")
function handleSpellStart(event)
	target = event.target
	target:Purge(true, true, false, true, true)
	ProcsMagicStick(event)
end
