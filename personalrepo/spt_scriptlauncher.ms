macroScript ScriptLauncher category:"FridayVFX" tooltip:"ScriptLauncher"
(
--include @"Z:\pipeline\Maxscripts\#lib.ms"
filein @"Z:\pipeline\Maxscripts\#lib.ms"
	rollout rloScriptLauncher "LaunchStuff" width:454 height:78
		(
			button btnLaunchScript "Launch!" pos:[12,40] width:430 height:27
			dropDownList ddlScriptList "" items:#() pos:[11,12] width:433 height:21
			local ListboxItems = #()
			local	ListboxItemsReadable = #()

			on rloScriptLauncher open do 
				(
				ListboxItems = (getFiles (pPaths.ScriptRepo + "\\*.ms"))
					for i in ListboxItems do -- Add readable names to the listbox
					(
						append ListboxItemsReadable (((filterstring	((filterstring i "_")[2]) ".")[1]) as string)
					)
					
				ddlScriptList.items = ListboxItemsReadable as array
				)
				
			on btnLaunchScript pressed do
				(
					filein ListboxItems[ddlScriptList.selection]
				)
		)

		createdialog rloScriptLauncher
)