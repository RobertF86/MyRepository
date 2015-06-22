/*
script loops through multiple max files and takes viewport screenshots of the scenes, 
it does so by going through all cameras in the scene first, 
then take a "whole scene" screenshot via zoom extends.

The intention is to get an overview of whats in a big bunch of max files in a directory structure

Define "dirroot" as the root of the structure you want to archive
Define "imgoutput" as the directory where you want to output the screenshots

*/

dirroot =  @"e:\#006_Models_Private\#FromScanline\"
imgoutput = @"e:\#006_Models_Private\#FromScanline\#preview\"

escapeEnable =  true

--recursively loop through supplied dirs and collect in array
fn getDirTree dir &array =
(
     if not matchPattern dir pattern:"*\\" do dir += "\\"
     subdirs = getDirectories ( dir + "*" )
     for sub in subdirs do
     (
          append array sub
          getDirTree sub array
     )
)

--get the max files of inside the dir list
fn getMaxFiles &dirs &maxfiles =
(
	for dir in dirs do
	(	
		subDirFiles = #()
		subDirFiles = (getFiles (dir + "*.max"))
		for f in subDirFiles do append maxfiles f
	)
)

--get custom file types inside the dir list
fn getCustFiles &dirs &files fileformat=
(
	for dir in dirs do
	(	
		subDirFiles = #()
		subDirFiles = (getFiles (dir + "*." + fileformat))
		for f in subDirFiles do append files f
	)
)

--Make "realistic" view look like shaded view
fn enforceShadedMode =
	(
	vs = nitrousgraphicsmanager.GetActiveViewportSetting()
		vs.visualstylemode =  #Shaded 	-- POSSIBLE VALUES: #Realistic | #Shaded | #Facets | #ConsistentColors | #HiddenLine | #Wireframe | #BoundingBox | #Clay | #Ink | #ColorInk | #Acrylic | #Tech | #Graphite | #ColorPencil | #Pastel
		vs.defaultLightMode = #TwoLights 	-- POSSIBLE VALUES:  #OneLight | #TwoLights 
		vs.DefaultLightsFollowCamera = true
		vs.ShadowsEnabled  = false	
		vs.AmbientOcclusionEnabled = false
		vs.ShowHighlightEnabled=true
)

--save a bitmap
fn saveViewportBitmap bitmappath filename fileformat gamma =(
		img = viewport.getViewportDib() 
		img.filename = (bitmappath + filename + "." + fileformat)
		save img gamma:1.0
	)

--switches to "superexpertmode" which turns command panel, timeline etc. off
fn switchSuperExpertMode TurnState:undefined =
	(	
		--get the inverse of the curren visibility state of the time slider:
		state = not TurnState
		if (TurnState == undefined) do (state = not(timeslider.isVisible())) 
		--set the trackbar visiblity to the new value:
		trackbar.visible = state
		--set the time slider visiblity to the new value:
		timeSlider.setVisible state
		--if true, exit the expert mode, if false, engage it:
		if state then cui.expertModeOff() else cui.expertModeOn()
		--finally, set the status panel visibility:
		statusPanel.visible = state
	)


	/*

--BEGIN GEN TEXT FILE BEGIN GEN TEXT FILE BEGIN GEN TEXT FILE BEGIN GEN TEXT FILE BEGIN GEN TEXT FILE BEGIN GEN TEXT FILE 

setVRaySilentMode() --prevents Vray from popping up dialogs
dirs = #()
getDirTree dirroot dirs -- get all directories and subdirectories, fill dir array
theFiles = #()

-- WRITING THE INITIAL TEXT FILE CONTAINING ALL MAX FILE PATH'S AND MAX FILENAMES PROVIDED IN "DIRROOT" 

--debugging, writing the file containing all max files in the dir structure
getMaxFiles dirs theFiles -- get all max files inside the dirs


	nextFile =  createFile (imgoutput + "debugging" + ".txt")
	format (maxfilepath+maxfilename) to:nextFile
	format ("\n") to:nextFile	
	format ("----------------") to:nextFile
	format ("\n") to:nextFile	
	for i in thefiles do(
		format(i) to:nextFile
		format ("\n") to:nextFile
		)
	close nextFile
		
--END GEN TEXT FILE END GEN TEXT FILE END GEN TEXT FILE END GEN TEXT FILE END GEN TEXT FILE END GEN TEXT FILE END GEN TEXT FILE

*/

--read all maxfiles from debugging file in order to loop through them.
filearray = #()
debugFilestream = openFile (imgoutput + "debugging.txt") mode:"r+"
append filearray (readline debugFilestream)  
append filearray (readline debugFilestream)  
while ((eof debugFilestream) == false) do 
(
append filearray (readline debugFilestream)  
)
close debugFilestream

-- delete first two entrys in "filearray" because they are for debugging purpose only
deleteItem filearray 1 
deleteItem filearray 1 
--done deleting

theFiles = filearray as array
filecounter = 0

-- LOOP THROUGH ALL MAX FILES	
for f in theFiles do -- go through all of them
  (	
	filecounter += 1
	print ("Processing file " + filecounter as string  + " of " + theFiles.count as string ) 
	
	gc() 
	freescenebitmaps()
	  
	  
	--continue Loading file
    loadMaxFile f quiet:true--load the next file
	enforceShadedMode()
	viewport.setLayout #layout_1 --Set max to single viewport
	switchSuperExpertMode TurnState:true -- Set "superExpertMode"
	viewport.setGridVisibility #all false

	try(	  
		camArray = #()
		
		for cam in cameras do ( --collect all cameras
				if (classof cam != Targetobject) do 
				(
					append camArray cam
				)
			)
			print ("Camera Array::::::::::::::::::::::::::::::::::::")
			print camArray
		)
		catch()
		
		--Write Text file with various Infos
		try(
			myFile = createFile (imgoutput + maxfilename + ".txt")
			format (maxfilepath+maxfilename) to:myFile
			format ("\n") to:myFile
			format ("geometry objects 	: " + geometry.count as string) to:myFile
			format ("\n") to:myFile
			format ("camera cbjects   		: " + cameras.count as string) to:myFile
			format ("\n") to:myFile			
			format ("light objects			: " + lights.count as string) to:myFile
			format ("\n") to:myFile			
			format ("shape objects			: " + shapes.count as string) to:myFile
			format ("\n") to:myFile			
			format ("helper objects			: " + helpers.count as string) to:myFile
			format ("\n") to:myFile		
			format ("\n") to:myFile		
			format ("\n") to:myFile					
			format ("::::::::::POLYCOUNTS::::::::::") to:myFile
			format ("\n") to:myFile		
			
			for i in geometry do (
					format (i.name + " : " + getPolygonCount i as string) to:myFile
					format ("\n") to:myFile
				)
			
			close myFile
				
			format (maxfilepath + maxfilename)
			format ("\n")
			)
		catch()
			
		
		try(
			--Loop through all Cameras, set them as active viewport, cycle through shading modes and save files
			for cam in camArray do(
					viewport.setCamera cam --set camera
					enforceShadedMode()
					actionMan.executeAction 0 "550" -- switch to shaded view
					viewport.SetShowEdgeFaces false
					completeRedraw() 
					saveViewportBitmap imgoutput (maxfilename+ "_" + cam.name as string + "_materials") "png" 1.0
					displayColor.shaded = #object
					actionMan.executeAction 0 "550" -- switch to shaded view
					completeRedraw() 
					saveViewportBitmap imgoutput (maxfilename+ "_" + cam.name as string + "_object") "png" 1.0
					viewport.SetShowEdgeFaces true
					actionMan.executeAction 0 "550" -- switch to shaded view
					completeRedraw() 
					saveViewportBitmap imgoutput (maxfilename+ "_" + cam.name as string + "_edged") "png" 1.0
				)
				
			--shoot perspective "zoom extends all"
					hide cameras
					hide lights
					viewport.setType #view_persp_user
					viewport.setTM (matrix3 [0.707107,0.353553,-0.612372] [-0.707107,0.353553,-0.612372] [0,0.866025,0.5] [0,0,-250])
					max zoomext sel all
					max zoomext sel all
					actionMan.executeAction 0 "550" -- switch to shaded view
					completeRedraw() 
					saveViewportBitmap imgoutput (maxfilename+ "_" + "Perspective") "png" 1.0
					viewport.SetShowEdgeFaces true
					completeRedraw() 
					saveViewportBitmap imgoutput (maxfilename+ "_" + "Perspective_edged") "png" 1.0
				
			--shoot top "zoom extends all"
					hide cameras
					hide lights
					viewport.setType #view_top
					max zoomext sel all
					max zoomext sel all
					actionMan.executeAction 0 "550" -- switch to shaded view
					completeRedraw() 
					saveViewportBitmap imgoutput (maxfilename+ "_" + "Top") "png" 1.0
				

			)
			catch() 
 

--read all maxfiles from debugging file, skip the line of the max file thats going to open
--rewrite the list file with the collection array without that one line (delete line mechanism)
filearray = #()
debugFilestream = openFile (imgoutput + "debugging.txt") mode:"r+"
append filearray (readline debugFilestream)  
append filearray (readline debugFilestream)  
filetoopen = readline debugFilestream          -- skip one line in order to delete it!
while ((eof debugFilestream) == false) do 
(
append filearray (readline debugFilestream)  
)
close debugFilestream

--rewrite the debugging file without that one line
nextFile =  createFile (imgoutput + "debugging" + ".txt")
for i in filearray do
(
format i to:nextFile
format "\n" to:nextFile
)
close nextfile
--done writing files
) 
 
 
 /*
 
 --LOOP THROUGH ALL OBJS
 objs = #()
 getCustFiles dirs objs "obj"
filecounter = 0
for o in objs do (
	filecounter += 1
	print ("Processing file " + filecounter as string  + " of " + theFiles.count as string ) 
	format ("\n")
	format (filenameFromPath o)
	format ("\n")
resetMaxFile #noPrompt
importFile  o #noPrompt

clearSelection()
	
		try(
			--shoot perspective "zoom extends all"
					hide cameras
					hide lights
					viewport.setType #view_persp_user
					viewport.setTM (matrix3 [0.707107,0.353553,-0.612372] [-0.707107,0.353553,-0.612372] [0,0.866025,0.5] [0,0,-250])
					max zoomext sel all
					actionMan.executeAction 0 "550" -- switch to shaded view
					viewport.SetShowEdgeFaces false
					completeRedraw() 
					saveViewportBitmap imgoutput ((filenameFromPath o)+ "_" + "Perspective") "png" 1.0
					viewport.SetShowEdgeFaces true
					completeRedraw() 
					saveViewportBitmap imgoutput ((filenameFromPath o)+ "_" + "Perspective_edged") "png" 1.0
				
			--shoot top "zoom extends all"
					hide cameras
					hide lights
					viewport.setType #view_top
					max zoomext sel all
					max zoomext sel all
					actionMan.executeAction 0 "550" -- switch to shaded view
					completeRedraw() 
					saveViewportBitmap imgoutput ((filenameFromPath o)+ "_" + "Top") "png" 1.0
				)
		catch()


				
		--Write Text file with various Infos
		try(
			myFile = createFile (imgoutput + (filenameFromPath o) + ".txt")
			format (o) to:myFile
			format ("\n") to:myFile
			format ("geometry objects 	: " + geometry.count as string) to:myFile
			format ("\n") to:myFile
			format ("camera cbjects   		: " + cameras.count as string) to:myFile
			format ("\n") to:myFile			
			format ("light objects			: " + lights.count as string) to:myFile
			format ("\n") to:myFile			
			format ("shape objects			: " + shapes.count as string) to:myFile
			format ("\n") to:myFile			
			format ("helper objects			: " + helpers.count as string) to:myFile
			format ("\n") to:myFile		
			format ("\n") to:myFile		
			format ("\n") to:myFile					
			format ("::::::::::POLYCOUNTS::::::::::") to:myFile
			format ("\n") to:myFile		
			
			for i in geometry do (
					format (i.name + " : " + getPolygonCount i as string) to:myFile
					format ("\n") to:myFile
				)
			
			close myFile
			)
		catch()

)