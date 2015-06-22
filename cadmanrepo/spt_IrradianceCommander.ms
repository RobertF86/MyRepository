rollout rloIrradianceCommander "IrradianaceCommander" width:1185 height:505
(
	------------------------Prepass

	label lblirradianceMapPathPrepass "Irradiance Map Path" pos:[14,26] width:133 height:15
	label lbllightCacheMapPathPrepass "Light Cache Path" pos:[13,69] width:133 height:15
	
	editText edtirradianceMapPrepassPath "" pos:[7,45] width:527 height:18 readOnly:true
	editText edtLightCachePrepassPath "" pos:[6,88] width:527 height:18 readOnly:true
	
	button btnSetPrepass "SET VRAY TO IRRADIANCE MAP PREPASS" pos:[8,188] width:521 height:33
	bitmap bmpBitmap "Bitmap" pos:[540,2] width:642 height:500 fileName:@"\\srs01\3d\jarvis\cats\CommanderShopped.jpg"

	groupBox grpPrepass "Prepass Settings" pos:[4,5] width:533 height:226

	checkbox chkDontRenderFinalImage "Dont Render Final Image" pos:[11,113] width:141 height:18 checked:true 
	checkbox chkUseCameraPathPrepass "Use camera path" pos:[165,163] width:102 height:18 checked:true

	spinner spnSphSubdiv "HSph. Subdivs:" pos:[100,133] width:50 height:16 range:[0,100,50]	type:#integer

	dropDownList ddlIrradianceMapPreset "Render Preset" pos:[162,118] width:120 height:40 items:#("Very Low", "Low", "Medium", "Medium-Animation", "High", "High-Animation", "Very High") selection:4
	
	button btnRefreshPathPrepass "Refresh Paths from render dialog" pos:[353,112] width:178 height:21
	
	------------------------Render
	button btnSetRender "SET VRAY TO IRRADIANCE MAP RENDER" pos:[9,456] width:521 height:33

	editText edtirradianceMapRenderPath "" pos:[8,313] width:527 height:18 readOnly:true
	editText edtLightCacheRenderPath "" pos:[7,356] width:527 height:18 readOnly:true

	label lblirradianceMapPathRender "Irradiance Map Path" pos:[15,294] width:133 height:15
	label lbllightCacheMapPathRender "Light Cache Path" pos:[14,337] width:133 height:15
	
	button btnRefreshPathRender "Refresh Paths from GI Dialog" pos:[354,380] width:178 height:21
	groupBox grpRender "Render Settings" pos:[5,273] width:533 height:226

	spinner spnIntSamples "Int Samples: " pos:[100,383] width:50 height:16 range:[0,100,15] type:#integer
	spinner spnIntFrames "Int Frames: " pos:[100,405] width:50 height:16 range:[0,100,2] type:#integer

	--checkbox chkUseCameraPathRender "Use camera path" pos:[166,382] width:111 height:18 checked:true

	fn SetRenderPaths=(
	getFilenamePath rendOutputFilename
	--Prepass Irradiance Map
	IrrMapDir = (getFilenamePath rendOutputFilename) + "_IrrMap\\"
	makeDir IrrMapDir
	IrrMapFilename = IrrMapDir + "_" + (getFilenameFile rendOutputFilename) + ".vrmap"
	--Prepass LightCache
	LightCacheDir = (getFilenamePath rendOutputFilename) + "_LightCache\\"
	makeDir LightCacheDir
	LightCacheFileName = LightCacheDir + "_" + (getFilenameFile rendOutputFilename) + ".vrlmap"
	--Set Textfields
	edtirradianceMapRenderPath.text  = IrrMapFilename
	edtLightCacheRenderPath.text = LightCacheFileName
	)

	fn SetPrepassPaths=(
	getFilenamePath rendOutputFilename
	--Prepass Irradiance Map
	IrrMapDir = (getFilenamePath rendOutputFilename) + "_IrrMap\\"
	makeDir IrrMapDir
	IrrMapFilename = IrrMapDir + "_" + (getFilenameFile rendOutputFilename) + ".vrmap"
	--Prepass LightCache
	LightCacheDir = (getFilenamePath rendOutputFilename) + "_LightCache\\"
	makeDir LightCacheDir
	LightCacheFileName = LightCacheDir + "_" + (getFilenameFile rendOutputFilename) + ".vrlmap"
	--Set Textfields
	edtirradianceMapPrepassPath.text  = IrrMapFilename
	edtLightCachePrepassPath.text = LightCacheFileName
	)

	on rloIrradianceCommander open do(
		renderSceneDialog.close()
		SetPrepassPaths()
		SetPrepassPaths()
		SetRenderPaths()
		renderSceneDialog.open()
		)
	
	on btnRefreshPathPrepass pressed  do(
		SetPrepassPaths()
		)

	on btnSetPrepass pressed  do(
		renderSceneDialog.close()
		--Set Preset from dialog
		renderers.current.gi_irradmap_preset = ddlIrradianceMapPreset.selection
		--Set Dont Render Final Image from Dialog
		renderers.current.options_dontRenderImage =  chkDontRenderFinalImage.checked
		--Set Use Camera Path
		renderers.current.lightcache_multipleViews = chkUseCameraPathPrepass.checked
		renderers.current.gi_irradmap_multipleViews = chkUseCameraPathPrepass.checked
		--Set subdivs
		renderers.current.gi_irradmap_subdivs = spnSphSubdiv.value
		--Set mode to prepass
		renderers.current.adv_irradmap_mode = 6
		renderers.current.lightcache_mode = 0
		--Set Filenames
		renderers.current.adv_irradmap_dontDelete = true
		renderers.current.adv_irradmap_autoSave = true
		renderers.current.lightcache_autoSave = true
		--Set Paths
		renderers.current.adv_irradmap_autoSaveFileName = edtirradianceMapPrepassPath.text
		renderers.current.lightcache_autoSaveFileName = edtLightCachePrepassPath.text
		renderers.current.adv_irradmap_loadFileName = edtirradianceMapPrepassPath.text
		renderers.current.lightcache_loadFileName = edtLightCachePrepassPath.text
		renderSceneDialog.open()
		)

	on btnSetRender pressed  do(
		renderSceneDialog.close()
		--Set Preset from dialog
		--renderers.current.gi_irradmap_preset = ddlIrradianceMapPreset.selection
		--Set Dont Render Final Image from Dialog
		renderers.current.options_dontRenderImage =  false
		--Set Use Camera Path
		--renderers.current.lightcache_multipleViews = chkUseCameraPathPrepass.checked
		--renderers.current.gi_irradmap_multipleViews = chkUseCameraPathPrepass.checked
		--Set subdivs
		--renderers.current.gi_irradmap_subdivs = spnSphSubdiv.value
		--Set mode to prepass
		renderers.current.adv_irradmap_mode = 7
		renderers.current.lightcache_mode = 2
		--Set Interpolation Samples
		renderers.current.gi_irradmap_interpSamples = spnIntSamples.value
		renderers.current.gi_irradmap_interpFrames = spnIntFrames.value
		--Set Filenames
		--renderers.current.adv_irradmap_dontDelete = true
		--renderers.current.adv_irradmap_autoSave = true
		--Set Paths
		--renderers.current.adv_irradmap_autoSaveFileName = edtirradianceMapPrepassPath.text
		--renderers.current.lightcache_autoSaveFileName = edtLightCachePrepassPath.text
		--renderers.current.adv_irradmap_loadFileName = edtirradianceMapPrepassPath.text
		--renderers.current.lightcache_loadFileName = edtLightCachePrepassPath.text
		renderSceneDialog.open()	
		)

	on chkDontRenderFinalImage changed state do()

	on spnSphSubdiv changed val do()

	on ddlIrradianceMapPreset selected sel do()

	on chkUseCameraPathPrepass changed state do()
	
	on btnRefreshPathRender pressed  do()
	
	on spnIntSamples changed val do()
	
	on spnIntFrames changed val do()
	
)

createdialog rloIrradianceCommander 