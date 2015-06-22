Global mybitmap = bitmap

fn CreateImagePlaneFromPath MyPath MyScalefactor =(
		--generating Material
		ImagePlaneMaterial = standardmaterial()
		ImagePlaneMaterial.name = (getFilenameFile  MyPath as string)
		
		--Loading MatLib with a Gamma2.2 Bitmaptexture	
		matlib = loadTempMaterialLibrary ppaths.BitmapLoadersMatLibraryPath
		
		--Settings for bitmaptexture
		ImagePlaneMaterial.diffusemap 						= (copy matlib[3])
		ImagePlaneMaterial.diffusemap.name 				= (ImagePlaneMaterial.name + "_diffuse")
		ImagePlaneMaterial.diffusemap.filename 			= MyPath as string
		ImagePlaneMaterial.diffusemap.coords.blur		=	0.2
		ImagePlaneMaterial.diffusemap.filtering				= 1
		ImagePlaneMaterial.diffusemap.coords.W_Angle = 90
		--Getting Height And Width
		MapHight 	= ImagePlaneMaterial.diffusemap.bitmap.height
		MapWidth 	= ImagePlaneMaterial.diffusemap.bitmap.width
		
		--Generate PlaneAnd Assign Material
		ImagePlane = Plane  length:(MapWidth*MyScalefactor) width:(MapHight*MyScalefactor) pos:[0,0,0] isSelected:on 
		ImagePlane.name = (ImagePlaneMaterial.name + "_diffuse")
		ImagePlane.material = ImagePlaneMaterial
		showTextureMap ImagePlaneMaterial true
	
	)
	
rollout ImagePlaneMaker "Image Plane Maker" width:900 height:460
(
		edittext edtPath "ImageFile:" fieldWidth:840 text:"" align:#left pos:[5,410]
		button btnRef "List From References" width:110 pos:[785,5]
		button btnRes "List From Resources" width:110 pos:[785,30]
		button btnCreate "Create" width:890 pos:[5,430]
		listbox lstPickBox pos:[5,5] width:780 height:30
		--checkbox chkCreateAll "Create all from dir" pos:[790,360]
		spinner spnScaleFactor "Scale" pos:[830,380] width:50 range:[0.001,1.0,1] 
	
	
	on ImagePlaneMaker open do(
			ArrPath = filterString  MaxFilePath "\\"
			ArrPath[ArrPath.count] = "ref"
			lstPickBox.items = getFiles ((pGlobalFunctions.AssemblePathFromArray ArrPath)+ "*.*")
			try (lstPickBox.selection = 1) catch()
		)
	
	on lstPickBox selected  itm do (
		edtPath.text = lstPickBox.selected 
		)
		
	on lstPickBox doubleClicked   itm do (
	try unDisplay mybitmap catch()	
	mybitmap = (openBitMap lstPickBox.selected)
	display mybitmap
		)	
		
	on btnCreate pressed do(
		try unDisplay mybitmap catch()	
		
		if (edtPath.text != "") then(
						try (
								CreateImagePlaneFromPath edtPath.text spnScaleFactor.value
								edtPath.text = ""
						)
						catch(messagebox "Error while creating imageplane. Are you sure you are working in an asset file?")
					)
			else (messagebox "Pathfield is empty.")
		
		)
	
	on btnRef pressed do(	
		ArrPath = filterString  MaxFilePath "\\"
		ArrPath[ArrPath.count] = "ref"
		lstPickBox.items = getFiles ((pGlobalFunctions.AssemblePathFromArray ArrPath)+ "*.*")
		)
		
	on btnRes pressed do(	
	ArrPath = filterString  MaxFilePath "\\"
	ArrPath[ArrPath.count] = "res"
	lstPickBox.items = getFiles ((pGlobalFunctions.AssemblePathFromArray ArrPath)+ "*.*")
	)

)

CreateDialog ImagePlaneMaker