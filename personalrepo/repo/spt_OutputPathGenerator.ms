if (viewport.getType() == #view_camera) then
	(
		--getting nessesary data for new output path
		ArrPath = (filterstring maxfilepath "\\")
		ArrPath[ArrPath.count] = "out"
		append ArrPath "img"
	
		--Output image filename based on active Camera name
		cameraname = getActiveCamera()
		cameraname = cameraname.name
	
		--setting image file name
		ImageFilename = (pGlobalFunctions.GetAssetNameFromCurrMaxFile() + "_" + cameraname + "..exr")
		Outputpath = (pGlobalFunctions.AssemblePathFromArray ArrPath)
	
		OutputPathAndFilename = Outputpath + ImageFilename
		
		wasopen = false
		if (renderSceneDialog.isOpen() == true) do	
		(
		renderSceneDialog.close() 
		wasopen = true
		)
		rendOutputFilename = OutputPathAndFilename
		if (wasopen == true) do	renderSceneDialog.open() 
	)
	else  (messagebox "Viewport is no camera")