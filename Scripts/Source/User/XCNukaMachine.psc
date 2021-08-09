Scriptname XCNukaMachine extends ObjectReference

Group Main
	Message property Menu mandatory auto
	Container property dummyContainer mandatory auto
	FormList property WarmDrinks mandatory auto const
	FormList property ColdDrinks mandatory auto const
EndGroup

ObjectReference containerREF
bool isPowered = false

; Events
Event OnActivate(ObjectReference AkActionRef)
	If (isPowered == true)
		self.ShowMenu(0)
	Else
		debug.Notification("This requires power to work!")
	EndIf
EndEvent

Event OnPowerOff()
	isPowered = false
EndEvent

Event OnPowerOn(ObjectReference akPowerGenerator)
	isPowered = true
EndEvent

Event OnWorkshopObjectPlaced(ObjectReference akReference)
	containerREF = self.PlaceAtMe(dummyContainer as Form, 1, true, false, false)
	containerREF.BlockActivation(true, true)
EndEvent

Event OnWorkshopObjectMoved(ObjectReference akReference)
	containerREF.Enable(false)
	containerREF.MoveTo(self as ObjectReference, 0, 0, 0, true)
EndEvent

Event OnWorkshopObjectDestroyed(ObjectReference akReference)
	containerREF.Disable(false)
	containerREF.Delete()
	containerREF.RemoveAllItems(Game.GetPlayer() as ObjectReference, true)
EndEvent

Event OnWorkshopObjectGrabbed(ObjectReference akReference)
	containerREF.Disable(false)
EndEvent

; Functions
Function ShowMenu(int btn)
	btn = Menu.Show()

	If (btn == 0)
    	containerREF.Activate(Game.GetPlayer() as ObjectReference, true)
	ElseIf (btn == 1)
		int i = 0

		While (i < WarmDrinks.GetSize())
			int iCount = Game.GetPlayer().GetItemCount(WarmDrinks.GetAt(i))

			If (iCount > 0)
				Game.GetPlayer().RemoveItem(WarmDrinks.GetAt(i), iCount, false, none)
				containerREF.AddItem(ColdDrinks.GetAt(i), iCount, false)
			EndIf

			i += 1
		EndWhile
	ElseIf (btn == 2)
        ; Close Menu
	EndIf
EndFunction