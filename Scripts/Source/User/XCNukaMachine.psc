; Script Name
ScriptName XCNukaMachine Extends ObjectReference

; Properties
Group Main
	Message property Menu Mandatory Auto
	Message property RequiresPower Mandatory Auto
	Container property DummyContainer Mandatory Auto
	FormList property WarmDrinks Mandatory Auto
	FormList property ColdDrinks Mandatory Auto
	Sound Property IdleSound Mandatory Auto
EndGroup

; Variables
ObjectReference ContainerREF
Int SoundID

; Basic Events
Event OnActivate(ObjectReference AkActionRef)
	If (Self.IsPowered() == true)
		Self.ShowMenu(0)
	Else
		RequiresPower.Show()
	EndIf
EndEvent

; Power Events
Event OnPowerOn(ObjectReference akPowerGenerator)
	Sound.SetInstanceVolume(SoundID, 1)
EndEvent

Event OnPowerOff()
	Sound.SetInstanceVolume(SoundID, 0)
EndEvent

; Workshop Events
Event OnWorkshopObjectPlaced(ObjectReference akReference)
	ContainerREF = self.PlaceAtMe(DummyContainer as Form, 1, true, false, false)
	ContainerREF.BlockActivation(true, true)

	SoundID = IdleSound.Play(Self)

	If (Self.IsPowered() == true)
		Sound.SetInstanceVolume(SoundID, 1)
	Else
		Sound.SetInstanceVolume(SoundID, 0)
	EndIf
EndEvent

Event OnWorkshopObjectMoved(ObjectReference akReference)
	ContainerREF.Enable(false)
	ContainerREF.MoveTo(self as ObjectReference, 0, 0, 0, true)
EndEvent

Event OnWorkshopObjectDestroyed(ObjectReference akReference)
	ContainerREF.Disable(false)
	ContainerREF.Delete()
	ContainerREF.RemoveAllItems(Game.GetPlayer() as ObjectReference, true)
EndEvent

Event OnWorkshopObjectGrabbed(ObjectReference akReference)
	ContainerREF.Disable(false)
EndEvent

; Functions
Function ShowMenu(Int btn)
	btn = Menu.Show()

	If (btn == 0)
    		ContainerREF.Activate(Game.GetPlayer() as ObjectReference, true)
	ElseIf (btn == 1)
		Int i = 0

		While (i < WarmDrinks.GetSize())
			Int iCount = Game.GetPlayer().GetItemCount(WarmDrinks.GetAt(i))

			If (iCount > 0)
				Game.GetPlayer().RemoveItem(WarmDrinks.GetAt(i), iCount, false, none)
				ContainerREF.AddItem(ColdDrinks.GetAt(i), iCount, false)
			EndIf

			i += 1
		EndWhile
	ElseIf (btn == 2)
        ; Close Menu
	EndIf
EndFunction