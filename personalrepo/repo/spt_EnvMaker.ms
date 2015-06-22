rollout ENVMaker "Environment Maker" width:224 height:380
(
	listBox lbxMaps "Environment Maps" pos:[8,5] width:117 height:12 items:#("Airstrip01")
	listBox lbxGeo "Environment Geometry" pos:[9,191] width:117 height:12
	button btnmakeLight "Make Light" pos:[128,158] width:89 height:26
	button btnImportEnv "Import Env" pos:[131,344] width:89 height:26
	checkbox chkDomeVisible "Dome Visible" pos:[132,25] width:76 height:18 checked:true
	checkbox chkFullDome "Full Dome" pos:[132,42] width:76 height:18 checked:true
	checkbox chkMapToMedit "MapToMedit" pos:[133,125] width:76 height:18
	--checkbox chkNoSun "NoSun" pos:[133,140] width:76 height:18
	spinner spnMultiplier "" pos:[131,76] width:72 height:16 range:[0,99999,1] type:#float
	spinner spnSubdivs "" pos:[131,109] width:72 height:16 range:[0,99999,128]type:#integer
	label lbl1 "Multiplier" pos:[133,60] width:63 height:14
	label lbl2 "Subdivs" pos:[131,94] width:63 height:14


on btnmakeLight pressed do
	(
		EnvMapDir = pPaths.PipelineDir + "\\#ENVMaps\\"
		
		if (lbxMaps.selected == "Airstrip01") do 
		(
			--diffuseMap
			AirfieldMapDiffusePathHigh = (EnvMapDir + "hdr_sets_airstrip_01_high\\109_ENV_DOMELIGHT.exr")
			AirfieldMapDiffusePathLow = (EnvMapDir + "hdr_sets_airstrip_01_low\\109_ENV_DOMELIGHT.exr")
			
			--reflectionMap
			AirfieldMapReflectionPathHigh = (EnvMapDir + "hdr_sets_airstrip_01_high\\109_ENV_REFLECTION.exr")
			AirfieldMapReflectionPathLow = (EnvMapDir + "hdr_sets_airstrip_01_low\\109_ENV_REFLECTION.exr")
			
			--MakeDiffuseLight
			myVrayLightDiffuse = VRayLight on:on  name:"DomelightDif" 
			myVrayHDRIDiffuse = VRayHDRI name:"EnvMapDif" maptype:2 HDRIMapName:AirfieldMapDiffusePathHigh
			myVrayLightDiffuse.type = 1
			myVrayLightDiffuse.multiplier = spnMultiplier.value
			myVrayLightDiffuse.subdivs = spnSubdivs.value
			myVrayLightDiffuse.texmap = myVrayHDRIDiffuse
			myVrayLightDiffuse.dome_spherical = chkFullDome.checked
			myVrayLightDiffuse.dome_targetRadius = 0
			myVrayLightDiffuse.dome_emitRadius = 0
			myVrayLightDiffuse.invisible = chkDomeVisible.checked
			myVrayLightDiffuse.affect_diffuse = true
			myVrayLightDiffuse.affect_specualr = false
			myVrayLightDiffuse.affect_reflections = false
			
			--MakeReflectionLight
			myVrayLightReflection = VRayLight on:on  name:"DomelightRef" 
			myVrayHDRIReflection = VRayHDRI name:"EnvMapRef" maptype:2 HDRIMapName:AirfieldMapReflectionPathHigh
			myVrayLightReflection.type = 1
			myVrayLightReflection.multiplier = spnMultiplier.value
			myVrayLightReflection.subdivs = 1
			myVrayLightReflection.texmap = myVrayHDRIReflection
			myVrayLightReflection.dome_spherical = chkFullDome.checked
			myVrayLightReflection.dome_targetRadius = 0
			myVrayLightReflection.dome_emitRadius = 0
			myVrayLightReflection.invisible = chkDomeVisible.checked
			myVrayLightReflection.pos.x = myVrayLightDiffuse.pos.x + 10
			myVrayLightReflection.affect_diffuse = false
			myVrayLightReflection.affect_specualr = true
			myVrayLightReflection.affect_reflections = true
			
			--Copy Stuff to texture Path
			doscommand ("copy " + AirfieldMapDiffusePathLow + " " + (pGlobalFunctions.GetAssetPathFromCurrMaxFile() + "txtr\\109_ENV_DOMELIGHT.exr"))
			doscommand ("copy " + AirfieldMapReflectionPathLow + " " + (pGlobalFunctions.GetAssetPathFromCurrMaxFile() + "txtr\\109_ENV_REFLECTION.exr"))			
			/*
				if (chkNoSun.checked == true) do
				(
				tempLib = loadTempMaterialLibrary @"Z:\pipeline\#ENVMaps\AirstripNoSunCompositeMap.mat"
				mat = tempLib[1]
				myVrayLight.texmap = mat
			*/
				--MapToMedit
				
				if (chkMapToMedit.checked == true) do 
				(
					if (queryBox "You want to put the Domelight maps into the first two material slots, are you sure? The slots will be overwritten." == true ) do
					(
					meditmaterials[1] = myVrayHDRIDiffuse
					meditmaterials[2] = myVrayHDRIReflection
					)
				)
				
			select #(myVrayLightDiffuse,myVrayLightReflection)
		)
	)
	
	
)

createdialog ENVMaker