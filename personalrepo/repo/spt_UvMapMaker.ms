
rollout MapMaker "Map Maker" width:216 height:200
(
	button btnDo "DO" pos:[128,170] width:80 height:24
	groupBox grp1 "Generate Maps" pos:[8,8] width:200 height:160
	checkbox chkGenPsd "PSD file" pos:[16,75] width:184 height:18 checked:true	
	checkbox chkUVLayouts "Generate Uv Layouts" pos:[16,100] width:184 height:18 checked:true
	checkbox chkGenAoMap "Ambient Occlusion" pos:[16,145] width:184 height:18 checked:false
	dropdownlist  cbxResW "Resolution Width" items:pPaths.GlobalResArray pos:[16,24] width:88 height:pPaths.GlobalResArray.count selection:5
	dropdownlist  cbxResH "Resolution Height" items:pPaths.GlobalResArray pos:[112,24] width:88 height:pPaths.GlobalResArray.count selection:5
	checkbox chkGenSeamMap "Generate Seams Map" pos:[16,120] width:184 height:18 checked:true
	checkbox chkOepenInPshop "Open In Pshop" pos:[16,175] width:104 height:16 checked:true
	
	on MapMaker open  do(

							 if (querybox "Did you use ObjectNamer to name your object?" == true) then(
						 
								if (superclassof $ != "GeometryClass" AND selection.count == 1)then
								(
									-- If a psd file for that object already exists, grey out PSD generate checkbox because PSD is not nessesary anymore.
												AssetPath = pGlobalFunctions.GetAssetPathFromCurrMaxFile()
												AssetName = (filterstring ((filterstring MaxFileName ".")[1]) "_" )[1] +"_"+ (filterstring ((filterstring MaxFileName ".")[1]) "_" )[2]
												
												print ("Asset Path is: " + AssetPath as string)
												print ("Asset Name is: " + AssetName as string)
												
												ObjectName = (filterstring ($.name) "_")[3]
												print AssetPath
												PsdFileName = AssetPath + "txtr" + "\\" + AssetName + "_txtr_" + ObjectName +"_" + "Master_v0001.psd"
												
									if (doesFileExist PsdFileName) do(
										chkGenPsd.checked = false
										chkGenPsd.enabled = false
										
										chkUVLayouts.enabled = false
										chkUVLayouts.checked = false
										
										chkGenSeamMap.enabled = false
										chkGenSeamMap.checked = false
									)
								)
					 )
					 else(
						messagebox "Please use the Object Namer before creating UV Templates or any other maps"
						DestroyDialog MapMaker
					 )
				
		)
	
	
	on btnDo pressed do(
				if (superclassof $ != "GeometryClass" AND selection.count == 1)then
				(
					
					 if (querybox "Did you use ObjectNamer to name your object?" == true) then(
						 
							AssetName = (filterstring ((filterstring MaxFileName ".")[1]) "_" )[1] +"_"+ (filterstring ((filterstring MaxFileName ".")[1]) "_" )[2]
							AssetPath = pGlobalFunctions.GetAssetPathFromCurrMaxFile()
							ObjectName = (filterstring $.name "_")[3]
							print ("ObjectName : "  + (filterstring $.name "_")[3])
							MyUnwrap = UVWunwrap() 
							FilesToOpen = #()
						 
							modPanel.addModToSelection MyUnwrap
						 
							Targa.setColorDepth 24
							Targa.setCompressed false
							Targa.setAlphaSplit false
						 
						 --Generate PSD file
						 if (chkGenPsd.checked == true) do(
						 PsdFileToCopy = pPaths.PshopTemplateDir + "\\" + (pGlobalFunctions.ConvertTextureSizeString cbxResW.selected) as string + ".psd"
						 NewPsdFile = AssetPath + "txtr" + "\\" + AssetName + "_txtr_" + ObjectName +"_" + "Master_v0001.psd"
						 commandstring = ("copy " + "\"" + PsdFileToCopy + "\"" + " " + "\"" + NewPsdFile + "\"")
						 HiddenDOSCommand  commandstring
						 append FilesToOpen NewPsdFile
						 ) 
						 
						 -- IF PSD file is already there. append it to the "open in Photoshop" array
						 if (chkGenPsd.enabled == false ) do(
								PsdFileName = AssetPath + "txtr" + "\\" + AssetName + "_txtr_" + ObjectName +"_" + "Master_v0001.psd"
								print ("PSDFilename" + PsdFileName)
								append FilesToOpen PsdFileName
							)
							 
							 
						 --Generate UV Layouts
							if (chkUVLayouts.checked == true ) do(
								MyUnwrap.renderuv_invisibleedges = true
								MyUnwrap.renderuv_visibleedges = true
								MyUnwrap.renderuv_seamedges = false

								MyUnwrap.renderuv_width = (pGlobalFunctions.ConvertTextureSizeString cbxResW.selected ) as integer
								MyUnwrap.renderuv_height = (pGlobalFunctions.ConvertTextureSizeString cbxResH.selected ) as integer
								
								append FilesToOpen  (AssetPath + "res" + "\\" +(AssetName + "_" + ObjectName + "_Uvs_" + cbxResW.selected as string  + ".tga"))
								MyUnwrap.unwrap5.renderuv  FilesToOpen[FilesToOpen.count]
								)
								
						 --Generate Seam Map						
							if (chkGenSeamMap.checked == true ) do(
								MyUnwrap.renderuv_invisibleedges = false
								MyUnwrap.renderuv_visibleedges = false
								MyUnwrap.renderuv_seamedges = true

								MyUnwrap.renderuv_width = (pGlobalFunctions.ConvertTextureSizeString cbxResW.selected ) as integer
								MyUnwrap.renderuv_height = (pGlobalFunctions.ConvertTextureSizeString cbxResH.selected ) as integer
								
								append FilesToOpen  (AssetPath + "res" + "\\" +(AssetName + "_" + ObjectName + "_Uvs-Seams_" + cbxResW.selected as string  + ".tga"))
								MyUnwrap.unwrap5.renderuv  FilesToOpen[FilesToOpen.count]
							)
							
							--Open Stuff in Photoshop
							if (chkOepenInPshop.checked == true ) do(
								CommandString ="\"" + pPaths.PhotoshopExecutable + "\" "
								for i = 1 to FilesToOpen.count do(
										CommandString = CommandString + "\"" + FilesToOpen[i] + "\" "
									)
									print commandstring
								HiddenDOSCommand  (CommandString as string) donotwait:true
							)
							
							--try( deleteModifier $ MyUnwrap) catch()
					 )
					 else(
						messagebox "Please use the Object Namer before creating UV Templates or any other maps"
						DestroyDialog MapMaker
					 )
				 )	
				else(
					messagebox "Please select only ONE geometry object to generate UV templates"
				)
		)
)

Createdialog MapMaker