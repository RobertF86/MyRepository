loadMaterialLibrary pPaths.BitmapLoadersMatLibraryPath

	--Variables
		TexturePathAsArray = (filterstring Maxfilepath "\\")
		TexturePathAsArray[TexturePathAsArray.count] = "txtr"
		TexturePathAsArray
		TexturePath = pGlobalFunctions.AssemblePathFromArray TexturePathAsArray

--functions

-- Returns an array of filenames 
-- If you give a parameter to the function  like "dif" "spc" "bmp" ect ect.... you will get an array containing the list of all versions for the specific type for that asset. 
fn GetMapArray type = (
	FileArr = #()
	if (selection.count != 0) do(
		for a = 0 to 9 do(
			for b = 0 to 9 do(
				for c = 0 to 9 do(
					for d = 0 to 9 do(			
								if doesfileexist (TexturePath + (filterstring Maxfilename "_")[1] + "_" + (filterstring Maxfilename "_")[2] + "_txtr_" + (filterstring $.name "_")[3] as string + "_" + type as string +"_os_v" + (a as string + b as string + c as string + d as string) + ".tga")  do
										(
											append FileArr ((filterstring Maxfilename "_")[1] + "_" + (filterstring Maxfilename "_")[2] + "_txtr_" + (filterstring $.name "_")[3]  as string + "_" + type as string +"_os_v" + (a as string + b as string + c as string + d as string) + ".tga") 
										)		
								)
						)
				)
		)
	)
	FileArr

	)

-- Same as GetMapArray but returns ony versions
fn GetVersionArray type= (
		FileArr = #()
		VersionArr = #()
	if (selection.count != 0) do(

			for a = 0 to 9 do(
				for b = 0 to 9 do(
					for c = 0 to 9 do(
						for d = 0 to 9 do(			
									if doesfileexist (TexturePath + (filterstring Maxfilename "_")[1] + "_" + (filterstring Maxfilename "_")[2] + "_txtr_" + (filterstring $.name "_")[3]  as string + "_" + type as string +"_os_v" + (a as string + b as string + c as string + d as string) + ".tga")  do
											(
												append FileArr ((filterstring Maxfilename "_")[1] + "_" + (filterstring Maxfilename "_")[2] + "_txtr_" + (filterstring $.name "_")[3]  as string + "_" + type as string +"_os_v" + (a as string + b as string + c as string + d as string) + ".tga") 
											)		
									)
							)
					)
			)
			--FileArr
			VersionArr[1] = "latest" 
			for i = 1 to FileArr.count do(
				append VersionArr ((filterstring (filterstring FileArr[i] "_")[(filterstring FileArr[i] "_").count] ".")[1])
				)
			)		
		VersionArr	
	)

-- Assignments
	
	
fn AssignDifMap MyMaterial = (
	
	
loadMaterialLibrary pPaths.BitmapLoadersMatLibraryPath	
FileArr = #()
FileArr = GetMapArray "dif"
	
	if (FileArr.count != 0) do(
		
		if ((renderers.current as string)[1] + (renderers.current as string)[2] + (renderers.current as string)[3] + (renderers.current as string)[4] + (renderers.current as string)[5] == "V_Ray") do(
		MyMaterial.texmap_diffuse = copy currentMaterialLibrary[6]
		MyMaterial.texmap_diffuse.name = MyMaterial.name + "_dif"
		MyMaterial.texmap_diffuse.filename = TexturePath + FileArr[FileArr.count]
		MyMaterial.texmap_diffuse.filtering = 1
		MyMaterial.texmap_diffuse.coords.blur = 0.2
		showTextureMap MyMaterial MyMaterial.texmap_diffuse true
		)
		
		if (renderers.current as string == "finalRender_stage_1:finalRender_stage_1") do(
		MyMaterial.diffuseMap = copy currentMaterialLibrary[3]
		MyMaterial.diffuseMap.name = MyMaterial.name + "_dif"
		MyMaterial.diffuseMap.filename = TexturePath + FileArr[FileArr.count]
		MyMaterial.diffuseMap.filtering = 2
		MyMaterial.diffuseMap.coords.blur = 0.2
		showTextureMap MyMaterial MyMaterial.diffuseMap true			
		)
		
		
	)
)

fn AssignSpcMap MyMaterial = (
loadMaterialLibrary pPaths.BitmapLoadersMatLibraryPath
FileArr = #()
FileArr = GetMapArray "spc"

	if (FileArr.count != 0) do(
	
		if ((renderers.current as string)[1] + (renderers.current as string)[2] + (renderers.current as string)[3] + (renderers.current as string)[4] + (renderers.current as string)[5] == "V_Ray") do(
		MyMaterial.texmap_reflection = copy currentMaterialLibrary[5]
		MyMaterial.texmap_reflection.name = MyMaterial.name + "_spc"
		MyMaterial.texmap_reflection.filename = TexturePath + FileArr[FileArr.count]
		MyMaterial.texmap_reflection.filtering = 1
		MyMaterial.texmap_reflection.coords.blur = 0.2
		)
		
		if (renderers.current as string == "finalRender_stage_1:finalRender_stage_1") do(
		MyMaterial.reflectMap = copy currentMaterialLibrary[2]
		MyMaterial.reflectMap.name = MyMaterial.name + "_spc"
		MyMaterial.reflectMap.filename = TexturePath + FileArr[FileArr.count]
		MyMaterial.reflectMap.filtering = 2
		MyMaterial.reflectMap.coords.blur = 0.2	
		)
	)
)

fn AssignBmpMap MyMaterial = (
loadMaterialLibrary pPaths.BitmapLoadersMatLibraryPath	
FileArr = #()
FileArr = GetMapArray "bmp"

	if (FileArr.count != 0) do(
		
		if ((renderers.current as string)[1] + (renderers.current as string)[2] + (renderers.current as string)[3] + (renderers.current as string)[4] + (renderers.current as string)[5] == "V_Ray") do(
		MyMaterial.texmap_bump= copy currentMaterialLibrary[5]
		MyMaterial.texmap_bump.name = MyMaterial.name + "_bmp"
		MyMaterial.texmap_bump.filename = TexturePath + FileArr[FileArr.count]
		MyMaterial.texmap_bump.filtering = 1
		MyMaterial.texmap_bump.coords.blur = 0.2
		)
		
		if (renderers.current as string == "finalRender_stage_1:finalRender_stage_1") do(
		MyMaterial.bumpMap = copy currentMaterialLibrary[2]
		MyMaterial.bumpMap.name = MyMaterial.name + "_bmp"
		MyMaterial.bumpMap.filename = TexturePath + FileArr[FileArr.count]
		MyMaterial.bumpMap.filtering = 2
		MyMaterial.bumpMap.coords.blur = 0.2	
		)
		
		
	)
)

fn AssignGlsMap MyMaterial = (
loadMaterialLibrary pPaths.BitmapLoadersMatLibraryPath	
FileArr = #()
FileArr = GetMapArray "gls"

	if (FileArr.count != 0) do(
		
		if ((renderers.current as string)[1] + (renderers.current as string)[2] + (renderers.current as string)[3] + (renderers.current as string)[4] + (renderers.current as string)[5] == "V_Ray") do(
		MyMaterial.texmap_reflectionGlossiness= copy currentMaterialLibrary[5]
		MyMaterial.texmap_reflectionGlossiness.name = MyMaterial.name + "_gls"
		MyMaterial.texmap_reflectionGlossiness.filename = TexturePath + FileArr[FileArr.count]
		MyMaterial.texmap_reflectionGlossiness.filtering = 1
		MyMaterial.texmap_reflectionGlossiness.coords.blur = 0.2
		)
		
		if (renderers.current as string == "finalRender_stage_1:finalRender_stage_1") do(
		MyMaterial.reflectBlurryMap = copy currentMaterialLibrary[2]
		MyMaterial.reflectBlurryMap.name = MyMaterial.name + "_gls"
		MyMaterial.reflectBlurryMap.filename = TexturePath + FileArr[FileArr.count]
		MyMaterial.reflectBlurryMap.filtering = 2
		MyMaterial.reflectBlurryMap.coords.blur = 0.2	
		)
		
	)
)

fn AssignRfrMap MyMaterial = (
loadMaterialLibrary pPaths.BitmapLoadersMatLibraryPath	
FileArr = #()
FileArr = GetMapArray "rfr"

	if (FileArr.count != 0) do(
		
		if ((renderers.current as string)[1] + (renderers.current as string)[2] + (renderers.current as string)[3] + (renderers.current as string)[4] + (renderers.current as string)[5] == "V_Ray") do(		
		MyMaterial.texmap_refraction= copy currentMaterialLibrary[5]
		MyMaterial.texmap_refraction.name = MyMaterial.name + "_rfr"
		MyMaterial.texmap_refraction.filename = TexturePath + FileArr[FileArr.count]
		MyMaterial.texmap_refraction.filtering = 1
		MyMaterial.texmap_refraction.coords.blur = 0.2
		)
		
		
		if (renderers.current as string == "finalRender_stage_1:finalRender_stage_1") do(
		MyMaterial.refractMap = copy currentMaterialLibrary[2]
		MyMaterial.refractMap.name = MyMaterial.name + "_rfr"
		MyMaterial.refractMap.filename = TexturePath + FileArr[FileArr.count]
		MyMaterial.refractMap.filtering = 2
		MyMaterial.refractMap.coords.blur = 0.2	
		)		
		
	)
)

fn AssignDspMap MyMaterial = (
loadMaterialLibrary pPaths.BitmapLoadersMatLibraryPath	
FileArr = #()
FileArr = GetMapArray "dsp"

	if (FileArr.count != 0) do(
		
		if ((renderers.current as string)[1] + (renderers.current as string)[2] + (renderers.current as string)[3] + (renderers.current as string)[4] + (renderers.current as string)[5] == "V_Ray") do(		
		$.material.texmap_displacement= copy currentMaterialLibrary[5]
		$.material.texmap_displacement.name = MyMaterial.name + "_dsp"
		$.material.texmap_displacement.filename = TexturePath + FileArr[FileArr.count]
		$.material.texmap_displacement.filtering = 1
		$.material.texmap_displacement.coords.blur = 0.2
		)
		
		if (renderers.current as string == "finalRender_stage_1:finalRender_stage_1") do(
		MyMaterial.MTDMap = copy currentMaterialLibrary[2]
		MyMaterial.MTDMap.name = MyMaterial.name + "_dsp"
		MyMaterial.MTDMap.filename = TexturePath + FileArr[FileArr.count]
		MyMaterial.MTDMap.filtering = 2
		MyMaterial.MTDMap.coords.blur = 0.2	
		)	
		
	)
)

fn AssignMskMap MyMaterial = (
loadMaterialLibrary pPaths.BitmapLoadersMatLibraryPath	
FileArr = #()
FileArr = GetMapArray "msk"

	if (FileArr.count != 0) do(
		
		if ((renderers.current as string)[1] + (renderers.current as string)[2] + (renderers.current as string)[3] + (renderers.current as string)[4] + (renderers.current as string)[5] == "V_Ray") do(
		MyMaterial.texmap_opacity= copy currentMaterialLibrary[5]
		MyMaterial.texmap_opacity.name = MyMaterial.name + "_msk"
		MyMaterial.texmap_opacity.filename = TexturePath + FileArr[FileArr.count]
		MyMaterial.texmap_opacity.filtering = 1
		MyMaterial.texmap_opacity.coords.blur = 0.2
		)
		
		if (renderers.current as string == "finalRender_stage_1:finalRender_stage_1") do(
		MyMaterial.opacityMap = copy currentMaterialLibrary[2]
		MyMaterial.opacityMap.name = MyMaterial.name + "_msk"
		MyMaterial.opacityMap.filename = TexturePath + FileArr[FileArr.count]
		MyMaterial.opacityMap.filtering = 2
		MyMaterial.opacityMap.coords.blur = 0.2	
		)	
		
	)
)

fn AssignSpecificVersionOfMap map version  =(
	NewFileNameAsString = ""
	OldFileNameAsString = map.filename
	NewFileNameAsString =  (replace OldFileNameAsString (OldFileNameAsString.count - 8)  5 version)
	map.filename = NewFileNameAsString
	)

fn UpdateMaps MaterialToUpdate version= (	
	
		if (version == "latest") then(
			
			
			-- If Renderer Vray
			if ((renderers.current as string)[1] + (renderers.current as string)[2] + (renderers.current as string)[3] + (renderers.current as string)[4] + (renderers.current as string)[5] == "V_Ray") do(
				try( 
					MaterialToUpdate.texmap_diffuse.filename =TexturePath + (GetMapArray "dif")[(GetMapArray "dif").count]
					showTextureMap MaterialToUpdate MaterialToUpdate.texmap_diffuse true
				)catch()
				
				try( 	
				MaterialToUpdate.texmap_reflection.filename =TexturePath +  (GetMapArray "spc")[(GetMapArray "spc").count]
				)catch()
				
				try( 		
				MaterialToUpdate.texmap_bump.filename =TexturePath +  (GetMapArray "bmp")[(GetMapArray "bmp").count]
				)catch()
				
				try( 	
				MaterialToUpdate.texmap_reflectionGlossiness.filename =TexturePath +  (GetMapArray "gls")[(GetMapArray "gls").count]
				)catch()
				
				try( 	
				MaterialToUpdate.texmap_refraction.filename =TexturePath +  (GetMapArray "rfr")[(GetMapArray "rfr").count]
				)catch()
				
				try(
				MaterialToUpdate.texmap_displacement.filename =TexturePath +  (GetMapArray "dsp")[(GetMapArray "dsp").count]
				)catch()	
				
				try(
				MaterialToUpdate.texmap_opacity.filename =TexturePath +  (GetMapArray "dif")[(GetMapArray "msk").count]
				) catch()
			)
			-- If Renderer fR
			if (renderers.current as string == "finalRender_stage_1:finalRender_stage_1") do(
				try( 
				MaterialToUpdate.DiffuseMap.filename =TexturePath + (GetMapArray "dif")[(GetMapArray "dif").count]
				showTextureMap MaterialToUpdate MaterialToUpdate.DiffuseMap true
				)catch()
				
				try( 	
				MaterialToUpdate.ReflectionMap.filename =TexturePath +  (GetMapArray "spc")[(GetMapArray "spc").count]
				)catch()
				
				try( 		
				MaterialToUpdate.BumpMap.filename =TexturePath +  (GetMapArray "bmp")[(GetMapArray "bmp").count]
				)catch()
				
				try( 	
				MaterialToUpdate.reflectBlurryMap.filename =TexturePath +  (GetMapArray "gls")[(GetMapArray "gls").count]
				)catch()
				
				try( 	
				MaterialToUpdate.refractMap.filename =TexturePath +  (GetMapArray "rfr")[(GetMapArray "rfr").count]
				)catch()
				
				try(
				MaterialToUpdate.MTDMap.filename =TexturePath +  (GetMapArray "dsp")[(GetMapArray "dsp").count]
				)catch()	
				
				try(
				MaterialToUpdate.opacityMap.filename =TexturePath +  (GetMapArray "dif")[(GetMapArray "msk").count]
				) catch()
			)
		)
		else(
			
			--If Renderer Vray
			if ((renderers.current as string)[1] + (renderers.current as string)[2] + (renderers.current as string)[3] + (renderers.current as string)[4] + (renderers.current as string)[5] == "V_Ray") do(
			try AssignSpecificVersionOfMap MaterialToUpdate.texmap_diffuse version					catch ()
			try AssignSpecificVersionOfMap MaterialToUpdate.texmap_reflection	version				catch ()
			try AssignSpecificVersionOfMap MaterialToUpdate.texmap_bump	version					catch ()
			try AssignSpecificVersionOfMap MaterialToUpdate.texmap_reflectionGlossiness version	catch ()
			try AssignSpecificVersionOfMap MaterialToUpdate.texmap_refraction	version				catch ()
			try AssignSpecificVersionOfMap MaterialToUpdate.texmap_displacement version			catch ()
			try AssignSpecificVersionOfMap MaterialToUpdate.texmap_opacity version					catch ()
			)
			
			--If Renderer fR
			if (renderers.current as string == "finalRender_stage_1:finalRender_stage_1") do(
			try AssignSpecificVersionOfMap MaterialToUpdate.diffuseMap version						catch ()
			try AssignSpecificVersionOfMap MaterialToUpdate.reflectionMap	version					catch ()
			try AssignSpecificVersionOfMap MaterialToUpdate.bumpMap	version						catch ()
			try AssignSpecificVersionOfMap MaterialToUpdate.reflectBlurryMap version					catch ()
			try AssignSpecificVersionOfMap MaterialToUpdate.refractMap	version						catch ()
			try AssignSpecificVersionOfMap MaterialToUpdate.MTDMap version							catch ()
			try AssignSpecificVersionOfMap MaterialToUpdate.opacityMap version						catch ()				
			)
			
			
			)
	)
	
fn AssignAvailableMaps MaterialToUpdate = (
	try AssignDifMap MaterialToUpdate catch()
	try AssignSpcMap MaterialToUpdate catch()
	try AssignBmpMap MaterialToUpdate catch()
	try AssignGlsMap MaterialToUpdate catch()
	try AssignRfrMap MaterialToUpdate catch()
	try AssignDspMap MaterialToUpdate catch()
	try AssignMskMap MaterialToUpdate catch()
	print "done"
	)
	
fn CreateShaderWithLatestMaps MyObject = (
	
		if (renderers.current as string != "Default_Scanline_Renderer:Default_Scanline_Renderer") then(
			-- Checking if the renderer is finalRender or Vray, if not -> Messagebox
		 
				if ((renderers.current as string)[1] + (renderers.current as string)[2] + (renderers.current as string)[3] + (renderers.current as string)[4] + (renderers.current as string)[5] == "V_Ray") do(
				MyMaterial = VRayMtl ()	
				)
				
				if (renderers.current as string == "finalRender_stage_1:finalRender_stage_1") do(
				MyMaterial = fR_Advanced()
				Mymaterial.diffuseColor = (color 0 0 0)
				)
				
				
			
				MyMaterial.name = selection[1].name
				loadMaterialLibrary pPaths.BitmapLoadersMatLibraryPath
				
				AssignAvailableMaps MyMaterial
				
				MyObject.material =  MyMaterial
		)
		else (MessageBox "Please chose A renderer like finalRender or Vray")
	)
	
	

rollout ShaderMaker "Shader Maker" width:161 height:171
(
	button btnCreateShadersForSelection "Create shaders for selection" pos:[7,10] width:143 height:21
	button btnAssignAvailableMaps "Assign Available Maps" pos:[7,35] width:143 height:21
	button btnDoVersion "Assign Version" pos:[8,141] width:110 height:21
	button btnDoRefresh "Refresh" pos:[120,114] width:40 height:21
	dropDownList ddlVersions "Version" pos:[9,96] width:110 height:40 items:(GetVersionArray "dif")

		
	on btnDoRefresh pressed do(
		ddlVersions.items = GetVersionArray "dif"
		)
		
		
	on btnCreateShadersForSelection pressed do(
		disableSceneRedraw();
				--try(
						if (Superclassof selection[1] == GeometryClass ) do CreateShaderWithLatestMaps selection[1]
				--	)
				--	catch(messagebox "Error on shader creation, please check if parameters are correct. (Objectname and location of maps)")
		enableSceneRedraw();										
		)
	
	on btnAssignAvailableMaps pressed do(
		disableSceneRedraw();
				try(
						if (Superclassof selection[1] == GeometryClass ) do AssignAvailableMaps selection[1].material
					)
					catch(messagebox "Error on assigning maps, please check if parameters are correct. (Objectname and location of maps)")
		enableSceneRedraw();	
		)
		
	on btnDoVersion pressed do(
		disableSceneRedraw();
				try(
						if (Superclassof selection[1] == GeometryClass ) do UpdateMaps selection[1].material ddlVersions.selected
					)
					catch(messagebox "Error on assigning maps, please check if parameters are correct. (Objectname and location of maps)")
		enableSceneRedraw();	
		)	
)


createdialog ShaderMaker