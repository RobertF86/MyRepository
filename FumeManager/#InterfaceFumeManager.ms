
fn SetCachePaths MyFumeNode NewPath =(
	
	def = getFilenameFile  (MyFumeNode.GetPath "default" ) 
	wav = getFilenameFile  (MyFumeNode.GetPath "wavelet")
	ret = getFilenameFile  (MyFumeNode.GetPath "retimer")
	ill = getFilenameFile  (MyFumeNode.GetPath "illummap")		
	
	defPath = getFilenamepath  (MyFumeNode.GetPath "default" ) --Getting
	pathNameStrings = (Filterstring defPath "\\")			   --Fume Grid
	FumeNodeName = pathNameStrings[pathNameStrings.count - 1]  --Name
	
	Defaultpath  = (NewPath + "\\" + FumeNodeName + @"\def\"  + def + ".fxd") 
	Waveletpath  = (NewPath + "\\" + FumeNodeName + @"\wav\" + wav + ".fxd")
	Retimerpath  = (NewPath + "\\" + FumeNodeName + @"\ret\" + ret + ".fxd")
	illummappath = (NewPath + "\\" + FumeNodeName + @"\ill\" + ill + ".fim")
	
	MyFumeNode.SetPath (Defaultpath)  #("default","nocheck")
	MyFumeNode.SetPath (Waveletpath)  #("wavelet","nocheck")
	MyFumeNode.SetPath (Retimerpath)  #("retimer","nocheck")
	MyFumeNode.SetPath (illummappath) #("illummap","nocheck")
	
)

fn SetCachePathsAndFileNames MyFumeNode rootPath vari = (
	
	FumeNodeName = MyFumeNode.name as string
	
	makedir (rootPath + "\\" + (FumeNodeName as string + "_" +  vari) + @"\def\")
	makedir (rootPath + "\\" + (FumeNodeName as string + "_" +  vari) + @"\wav\")
	makedir (rootPath + "\\" + (FumeNodeName as string + "_" +  vari) + @"\ret\")
	makedir (rootPath + "\\" + (FumeNodeName as string + "_" +  vari) + @"\ill\")
	
	Defaultpath = (rootPath + "\\" + (FumeNodeName as string + "_" +  vari) + @"\def\" + vari + ".fxd") 
	Waveletpath = (rootPath + "\\" + (FumeNodeName as string + "_" +  vari) + @"\wav\" + vari + ".fxd")
	Retimerpath = (rootPath + "\\" + (FumeNodeName as string + "_" +  vari) + @"\ret\" + vari + ".fxd")
	illummappath =(rootPath + "\\" + (FumeNodeName as string + "_" +  vari) + @"\ill\" + vari + ".fim")
	
	MyFumeNode.SetPath (Defaultpath)  #("default","nocheck")
	MyFumeNode.SetPath (Waveletpath)  #("wavelet","nocheck")
	MyFumeNode.SetPath (Retimerpath)  #("retimer","nocheck")
	MyFumeNode.SetPath (illummappath) #("illummap","nocheck")
) 

fn maxrobocopy fromPath toPath =(
	Robocopycommand = ""
	mycmd = @"C:\Windows\System32\cmd.exe"
	Robocopycommand = "/K \"robocopy " + fromPath + " " + toPath + " " +  " /E /MT:8 \""
	shelllaunch mycmd Robocopycommand
)

fn CreateFumeLightRig GridName GridPos =(
		RigTransform = point()
		RigTransform.name = "FFXLgt_pos_" + GridName + "_" 
		RigTransform.pos = GridPos
		RigTransform.Box = on
		RigTransform.size = 100
		RigTransform.wireColor = (color 100 150 100)
		
		RedSpot = targetSpot castShadows:on 
		RedSpot.name = "FFXSpot_R_" + GridName + "_" 
		RedSpot.rgb = (color 255 0 0) 
		RedSpot.shadowColor = (color 0 0 0) 
		RedSpot.multiplier = 1  
		RedSpot.pos = RigTransform.pos + [0,0,50]  
		RedSpot.target = (Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] RigTransform.pos))
		RedSpot.wirecolor = (color 255 0 0)
		RedSpot.castShadows = on
		RedSpot.raytracedShadows = off
		RedSpot.atmosShadows = on		
		RedSpot.hotspot = 90
		RedSpot.falloff = 92
		RedSpot.parent = RigTransform
		RedSpot.target.parent = RigTransform

		BlueSpot = targetSpot castShadows:on 
		BlueSpot.name = "FFXSpot_B_" + GridName + "_" 
		BlueSpot.rgb = (color 0 0 255) 
		BlueSpot.shadowColor = (color 0 0 0) 
		BlueSpot.multiplier = 1  
		BlueSpot.pos = RigTransform.pos + [0,50,50]  
		BlueSpot.target = (Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] RigTransform.pos))
		BlueSpot.wirecolor = (color 0 0 255)
		BlueSpot.castShadows = on
		BlueSpot.raytracedShadows = off
		BlueSpot.atmosShadows = on		
		BlueSpot.hotspot = 90
		BlueSpot.falloff = 92
		BlueSpot.parent = RigTransform
		BlueSpot.target.parent = RigTransform		
			
		GreenSpot = targetSpot castShadows:on 
		GreenSpot.name = "FFXSpot_G_" + GridName + "_" 
		GreenSpot.rgb = (color 0 255 0 ) 
		GreenSpot.shadowColor = (color 0 0 0) 
		GreenSpot.multiplier = 1  
		GreenSpot.pos = RigTransform.pos + [0,-50,50]  
		GreenSpot.target = (Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] RigTransform.pos))
		GreenSpot.wirecolor = (color 0 255 0)
		GreenSpot.castShadows = on
		GreenSpot.raytracedShadows = off
		GreenSpot.atmosShadows = on		
		GreenSpot.hotspot = 90
		GreenSpot.falloff = 92
		GreenSpot.parent = RigTransform
		GreenSpot.target.parent = RigTransform		
		
		MyLightArray = #()
		append MyLightArray RedSpot
		append MyLightArray GreenSpot		
		append MyLightArray BlueSpot
)

fn DeleteCaches FumeNode =(
	
	FumeNodeName = FumeNode.name as string -- Getting Node name
	def = getFilenamePath  (FumeNode.GetPath "default" )  -- Get the path from the "default" caches
	StringArray = filterstring def "\\" --Splitting up the String were def files are stored
	DeleteDir = "" --Declaring string from wich robocopy will take it's source
	
	--Assembling String to folder thats going to be Deleted
	for i=1 to StringArray.count-1 do(
		if i==1 then DeleteDir = DeleteDir + StringArray[i] else DeleteDir = DeleteDir + "\\" + StringArray[i] 
		)
			DelCommand = "rd " + "\"" + DeleteDir + "\"" + " /s /q"
			HiddenDOSCommand  DelCommand downwait:true startpath:"c:\\"	
)

fn RoboCopyCachesToLocation MyFumeNode NetworkPath DoOverride =(
	
	FumeNodeName = MyFumeNode.name as string -- Getting Node name
	def = getFilenamePath  (MyFumeNode.GetPath "default" )  -- Get the path from the "default" caches
	StringArray = filterstring def "\\" --Splitting up the String were def files are stored
	MyFromString = "" --Declaring string from wich robocopy will take it's source
	
	--Assembling String to copy from
	for i=1 to StringArray.count-1 do(
		if i==1 then MyFromString = MyFromString + StringArray[i] else MyFromString = MyFromString + "\\" + StringArray[i] 
		)

	--Adding grid name to the destination DIR
	FumegridName =""
	FumegridName = StringArray[StringArray.count-1] 
	MyToString = NetworkPath +"\\"+ FumegridName
		
	--checking for File Override
		if (DoOverride==true) do (
			DirToRemove = MyToString
			DelCommand = "rd " + "\"" +DirToRemove + "\"" + " /s /q"
			HiddenDOSCommand  DelCommand downwait:true startpath:"c:\\"
			)
		
		maxrobocopy MyFromString MyToString
)

fn CopyCachesToLocation MyFumeNode NetworkPath DoOverride =(
	
	FumeNodeName = MyFumeNode.name as string
	
	def = getFilenamePath  (MyFumeNode.GetPath "default" ) 
	wav = getFilenamePath  (MyFumeNode.GetPath "wavelet")
	ret = getFilenamePath  (MyFumeNode.GetPath "retimer")
	ill = getFilenamePath  (MyFumeNode.GetPath "illummap")	
	
	DefFiles  = getFiles (def + "*.*")
	WafFiles  = getFiles (wav + "*.*")
	RetFiles  = getFiles (ret + "*.*")
	IllFiles  = getFiles (ill + "*.*")
	 
	--copy Default Files
	for i = 1 to DefFiles.count do (
	try(
			windows.processPostedMessages()
			DefFilesNameArray = (filterstring DefFiles[i] "\\")
			PartPathAndFilename = "\\" + DefFilesNameArray[DefFilesNameArray.count-2] + "\\" + DefFilesNameArray[DefFilesNameArray.count-1] + "\\" +DefFilesNameArray[DefFilesNameArray.count]
			FullFileNamePath = NetworkPath + PartPathAndFilename
			makedir (getFilenamePath  FullFileNamePath)

			if (doesfileexist FullFileNamePath == false) then 
				(
				copyFile DefFiles[i]  FullFileNamePath
				print ("Done: " + FullFileNamePath)
				)
				else (
					if (DoOverride == true) do
					(
						print ("File Exists, overriding: " + FullFileNamePath)
						deleteFile FullFileNamePath
						copyFile DefFiles[i]  FullFileNamePath
						print ("Done: " + FullFileNamePath)
					)
				)
		)catch()	 
	)
	
	--copy Wavelet Files
	for i = 1 to WafFiles.count do 
		(
		try(
			windows.processPostedMessages()
			WavFilesNameArray = (filterstring WafFiles[i] "\\")
			PartPathAndFilename = "\\" + WavFilesNameArray[WavFilesNameArray.count-2] + "\\" + WavFilesNameArray[WavFilesNameArray.count-1] + "\\" +WavFilesNameArray[WavFilesNameArray.count]
			FullFileNamePath = NetworkPath + PartPathAndFilename
			makedir (getFilenamePath  FullFileNamePath)
			
			if (doesfileexist FullFileNamePath == false) then 
				(
				copyFile WafFiles[i]  FullFileNamePath
				print ("Done: " + FullFileNamePath)
				)
				else (
					if (DoOverride == true) do
					(
						print ("File Exists, overriding: " + FullFileNamePath)
						deleteFile FullFileNamePath
						print "---------------------"
						print ("DefFiles[I] : " + DefFiles[i] as string)
						print ("FullFileNamePath : " + FullFileNamePath as string)
						print (doesfileexist FullFileNamePath)
						print "---------------------"
						copyFile DefFiles[i]  FullFileNamePath
						print ("Done: " + FullFileNamePath)
					)
				)
			)catch()
		)
		
	--copy Retimer Files
	for i = 1 to RetFiles.count do 
		(
		try(
			windows.processPostedMessages()
			RetFilesNameArray = (filterstring RetFiles[i] "\\")
			PartPathAndFilename = "\\" + RetFilesNameArray[RetFilesNameArray.count-2] + "\\" + RetFilesNameArray[RetFilesNameArray.count-1] + "\\" +RetFilesNameArray[RetFilesNameArray.count]
			FullFileNamePath = NetworkPath + PartPathAndFilename
			makedir (getFilenamePath  FullFileNamePath)
			
			if (doesfileexist FullFileNamePath == false) then 
				(
				copyFile RetFiles[i]  FullFileNamePath
				print ("Done: " + FullFileNamePath)
				)
				else (
					if (DoOverride == true) do
					(
						print ("File Exists, overriding: " + FullFileNamePath)
						deleteFile FullFileNamePath
						copyFile DefFiles[i]  FullFileNamePath
						print ("Done: " + FullFileNamePath)
					)
			)
		)catch()	
		)
	--copy IllFiles Files
	for i = 1 to IllFiles.count-1 do 
		(
		try(
			windows.processPostedMessages()
			IllFilesNameArray = (filterstring IllFiles[i] "\\")
			PartPathAndFilename = "\\" + IllFilesNameArray[IllFilesNameArray.count-2] + "\\" + IllFilesNameArray[IllFilesNameArray.count-1] + "\\" +IllFilesNameArray[IllFilesNameArray.count]
			FullFileNamePath = NetworkPath + PartPathAndFilename
			makedir (getFilenamePath  FullFileNamePath)
			
			if (doesfileexist FullFileNamePath == false) then 
				(
				copyFile IllFiles[i]  FullFileNamePath
				print ("Done: " + FullFileNamePath)
				)
				else (
					if (DoOverride == true) do
					(
						print ("File Exists, overriding: " + FullFileNamePath)
						deleteFile FullFileNamePath
						copyFile DefFiles[i]  FullFileNamePath
						print ("Done: " + FullFileNamePath)
					)
				)
			)catch()
		)
		
)

fn SimDefault MyFumeNode SetToCache = (
		MyFumeNode.SelectedCache = 0
		MyFumeNode.SimMode = 0
		MyFumeNode.RunSimulation 0	
		if (SetToCache == true) do ( MyFumeNode.SelectedCache = 0 )
)

fn SimWavelet MyFumeNode SetToCache = (
		MyFumeNode.SelectedCache = 0
		MyFumeNode.SimMode = 2
		MyFumeNode.RunSimulation 2	
		if (SetToCache == true) do ( MyFumeNode.SelectedCache = 1 )
)

fn KillAllCmdShells = (
	--Kill All CMD processes
	KillCommand  = ""
	mycmd = @"C:\Windows\System32\cmd.exe"
	KillCommand = "/K taskkill /F /IM cmd.exe"
	shelllaunch mycmd KillCommand
)

if classOf ::rloMain == RolloutClass do DestroyDialog ::rloMain
rollout roSubRollA "Batch Simulate"
(
	
	groupBox grpCopy "Cache file management" pos:[8,304] width:944 height:232
	groupBox grpStuffToBatch "Stuff To Batch" pos:[7,8] width:177 height:280
	groupBox grpRangeReset "Reset Range Before Sim" pos:[192,8] width:288 height:136
	groupBox grpActiveCacheAfterSimming "Active Cache After Simming" pos:[488,8] width:224 height:72
	groupBox grpSpeedup "Speedup" pos:[488,88] width:224 height:136
	groupBox grpViewportPropertiesAfterSimming "Viewport Properties After Simming" pos:[720,8] width:232 height:216
	groupBox grpSimFromInitialState "Sim From Initial State" pos:[192,224] width:760 height:72
	groupBox grpCopyMethod "Copy Method" pos:[192,152] width:288 height:72
	
	editText edtLocalCacheFiles "" pos:[104,330] width:752 height:18
	editText edtOnlineCacheFiles "" pos:[104,432] width:752 height:18
	editText edtLocalCacheFilesWavelet "" pos:[136,376] width:720 height:18 enabled:false
	editText edtLocalCacheFilesDefault "" pos:[136,352] width:720 height:18 enabled:false
	editText edtOnlineCacheFilesDefault "" pos:[136,456] width:720 height:18 enabled:false
	editText edtOnlineCacheFilesWavelet "" pos:[136,480] width:720 height:18 enabled:false
	editText edtLocalCacheFilesRetimer "" pos:[136,400] width:720 height:18 enabled:false	
	editText edtOnlineCacheFilesRetimer "" pos:[136,504] width:720 height:18 enabled:false
	editText edtInitialState "" pos:[296,256] width:648 height:18

	label lblLocalCaches "Local Cache Files" pos:[18,330] width:88 height:16
	label lbl2 "Online Cache Files" pos:[16,432] width:88 height:16
	label lblReduce "Reduce:" pos:[792,56] width:56 height:16
	label lblLocalCacheFilesDefault "Default Cache" pos:[64,352] width:72 height:16
	label lblLocalCacheFilesWavelet "Wavelet Cache" pos:[56,376] width:80 height:16
	label lblLocalCacheFilesRetimer "Retimer Cache" pos:[64,400] width:72 height:16
	label lblOnlineCacheFilesDefault "Default Cache" pos:[64,456] width:72 height:16
	label lblOnlineCacheFilesWavelet "Wavelet Cache" pos:[56,480] width:80 height:16
	label lblOnlineCacheFilesRetimer "Retimer Cache" pos:[64,504] width:72 height:16
	label lblStartFrame "Start Frame" pos:[272,24] width:64 height:16
	label lblEndFrame "End Frame" pos:[280,40] width:56 height:16
	label lblPlayFrom "Play From" pos:[288,64] width:48 height:16
	label lblPlayTo "Play To" pos:[296,80] width:40 height:16
	label lblPlayStart "Play Start" pos:[288,96] width:48 height:16
	label lblViewportUpdate "Viewport Update" pos:[256,120] width:80 height:16
	
	radioButtons rdoCopyMode "Copy Mode" pos:[256,168] columns:1 width:180 height:46 labels:#("Robocopy (Fast,Reccomended)", "Max Copy (Slow,Secure)")
	radioButtons rdoSetCacheAfterSim "" pos:[600,24] width:69 height:48 columns:1 labels:#("Default", "Wavelet", "Post")
	
	button btnGetLocalCachePath "Get Current" pos:[864,328] width:80 height:24
	button btnSim "SIM" pos:[8,548] width:944 height:56
	
	spinner spnReduce "" pos:[856,56] width:80 height:16

	checkButton ckbEnableCopyMethod "Enable" pos:[200,168] width:48 height:48
	checkButton ckbEnableResetRange "Enable" pos:[200,24] width:48 height:112
	checkButton ckbEnableInitialState "Enable" pos:[200,240] width:48 height:48
	checkButton ckbActiveCacheAfterSimming "Enable" pos:[496,24] width:48 height:48
	checkButton ckbEnableSpeedup "Enable" pos:[496,104] width:48 height:112
	checkButton ckbEnableViewportProperties "Enable" pos:[728,24] width:48 height:192
	checkButton ckbEnableViewportDisplay "Enable Viewport Display" pos:[784,24] width:128 height:24
	checkButton ckbEnableViewportDisplayPlus "+" pos:[912,24] width:24 height:24

	checkbox chkFuel "Fuel" pos:[792,80] width:64 height:16
	checkbox chkFire "Fire" pos:[792,96] width:64 height:16
	checkbox chkSmoke "Smoke" pos:[792,112] width:64 height:16
	checkbox chkVelo "Velocities" pos:[792,128] width:64 height:16
	checkbox chkForces "Forces" pos:[792,144] width:64 height:16
	checkbox chkTurbulence "Turbulence" pos:[792,160] width:88 height:16
	checkbox chkTemperature "Temperature" pos:[792,176] width:80 height:16
	checkbox chkActiveGrid "Adaptive Grid" pos:[792,192] width:88 height:16
	checkbox chkDisableUndoRecording "Disable Undo Recording" pos:[552,104] width:152 height:16
	checkbox chkDisableViewportRedraw "Disable Viewport Redraw" pos:[552,120] width:152 height:16
	checkbox chkPerformGarbageCollection "Perform Garbage Collection" pos:[552,136] width:152 height:16
	checkbox chkDontShowPreviewWindow "Don't show Preview Window" pos:[552,152] width:152 height:16
	checkbox chkSetLocalCaches "Set Local caches before sim" pos:[12,128] width:168 height:16
	checkbox chkSetOnlineCaches "Set online caches after sim" pos:[12,191] width:168 height:16
	checkbox chkCopyCaches "Copy Caches After Simming" pos:[12,160] width:168 height:16
	checkbox chkSimDefault "Simulate Default Caches" pos:[12,31] width:168 height:16 checked:true
	checkbox chkSimWavelet "Simulate Wavelet Caches" pos:[12,63] width:168 height:16 checked:true
	checkbox chkSimPost "Simulate Post Caches" pos:[12,95] width:168 height:16

	button btnGetInitialState "..." pos:[256,256] width:32 height:16
	button btnGetRange "Get" pos:[448,24] width:24 height:112
	button btnGetViewportProperties "Get" pos:[912,80] width:24 height:128

	spinner spnStartFrame "" pos:[350,24] width:90 height:16
	spinner spnEndFrame "" pos:[350,40] width:90 height:16 range:[0,99999,240]
	spinner spnPlayFrom "" pos:[350,64] width:90 height:16 range:[0,99999,240]
	spinner spnPlayTo "" pos:[350,80] width:90 height:16 range:[0,99999,240]
	spinner spnPlayStart "" pos:[350,96] width:90 height:16 range:[0,99999,240]
	spinner spnViewportUpdate "" pos:[350,120] width:90 height:16 range:[0,99999,240]

	on btnSim Pressed do(
		
		UsersSelection = #()
		UsersSelection = selection as array
		
		--Selecting Fume Grids That are selected in MultiListbox
			selection = #()
			GridNamesToSim = #()
			GridNamesToSim = for i in rloMain.lbxFumeGrids.selection collect rloMain.lbxFumeGrids.items[i]
			FFXNodes = for i in GridNamesToSim collect (getnodebyname i)

			--Looping through Nodes
				for i=1 to FFXNodes.count do (
				select FFXNodes[i]	
					
				if chkSimDefault.checked do
					(
						rloMain.PushInfo ($.name as string + ":: Simming Default caches....")
						(SimDefault $ true) 
					)
				if chkSimWavelet.checked do 
					(
						rloMain.PushInfo ($.name as string + ":: Simming Wavelet caches....")
						(SimWavelet $ true) 
					)
				if chkSimPost.checked do
				(
					rloMain.PushInfo ($.name as string + ":: POST CACHES NOT IMPLEMENTED YET")
				)
			)
		)
)
 
rollout roSubRollB "Group B"
(
	label lblB "Label B" pos:[20,5]
	button btnB "BBBBBB" pos:[20,33]
	spinner spnB "Spinner B:" range:[0,300,30] pos:[20,63]
)
 
rollout rloMain "Fume Manager"
(

		
	local ButtonDelta = 300
	checkButton chbShowA "batch Sim" checked:on across:5 pos:[ButtonDelta + 5,5]
	checkButton chbShowB "sim" checked:off pos:[ButtonDelta + 75,5]
	checkButton chbShowC "wtp" checked:off pos:[ButtonDelta + 110,5]
	checkButton chbShowD "rend" checked:off pos:[ButtonDelta + 148,5]	
	checkButton chbShowE "illum" checked:off pos:[ButtonDelta + 190,5]	
	checkButton chbShowF "obj/src" checked:off pos:[ButtonDelta + 230,5]	
	checkButton chbShowG "LightRigger" checked:off pos:[ButtonDelta + 285,5]	
	checkButton chbShowH "Cache Management" checked:off pos:[ButtonDelta + 360,5]
	
	button btnRefreshGrids "Get Grids" pos:[10,5] width:52 height:20
	
	MultiListBox lbxFumeGrids "Fume Grids" pos:[10,30] width:280 height:45
	listBox lbxInfo "Info" pos:[8,664] width:1264 height:8
	
	subRollout roSubA "" height:640 width:970 pos:[300,30]
	subRollout roSubB "" height:640 width:970 visible:false pos:[300,30]
	
	fn PushInfo infoString =(
	lbxInfo.items = append lbxInfo.items (infoString as string)
	)
	
	on btnRefreshGrids pressed do(
		FumeGridNames =#()
		for obj in objects do (if (classof obj == FumeFX) do append FumeGridNames obj.name) 
		lbxFumeGrids.items = FumeGridNames 
		)
	
	on rloMain open do (
		AddSubRollout rloMain.roSubA roSubRollA 
		AddSubRollout rloMain.roSubB roSubRollB
		
		rloMain.btnRefreshGrids.pressed()
	)
 
	on chbShowA changed state do 
	(
		chbShowB.state = not state
		rloMain.roSubA.visible = state
		rloMain.roSubB.visible = not state
	)
 
	on chbShowB changed state do 
	(
		chbShowA.state = not state
		rloMain.roSubA.visible = not state
		rloMain.roSubB.visible = state
	)
)



createDialog rloMain 1280 800