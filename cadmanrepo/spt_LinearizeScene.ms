fn isCCGammaOnly ccnode =(
	-- The function checks if a color correct node is only gamma related or not. If there is anything else 
	if (ccnode.hsl_on == true) do return false
	if (ccnode.hsl_on == true) do return false	
	if (ccnode.hsv_on == true) do return false
	if (ccnode.rgba_on == true) do return false
	if (ccnode.post_on == true) do return false
	if (ccnode.brightness != 0.0 ) do return false
	if (ccnode.contrast != 100.0 ) do return false
	if (ccnode.pre_invert != false) do return false
	if (ccnode.pre_mono != false) do return false
	if (ccnode.pre_clamp_on != false) do return false
	if (ccnode.pre_unmultiply != false) do return false
		
	return true
	
	)
  
fn VrayHDRIToBmt VrBmt =
	(
	local Bmt = bitmaptexture()
	
	---------------------------------------------------------
	--Setting Values
	---------------------------------------------------------
		Bmt.name = VrBmt.name
	
		Bmt.fileName = VrBmt.HDRIMapName  				-- Set Filename
	
		  Bmt.coords.blur			 	 = VrBmt.UVGen.blur
		  Bmt.coords.mapping 		 	 = VrBmt.UVGen.mapping
		  Bmt.coords.mapChannel 	 	 = VrBmt.UVGen.mapChannel
		  Bmt.coords.mappingType 	 	 = VrBmt.UVGen.mappingType
		  Bmt.coords.UVW_Type  	 	 	 = VrBmt.UVGen.UVW_Type
		  Bmt.coords.U_Mirror 		 	 = VrBmt.UVGen.U_Mirror
		  Bmt.coords.V_Mirror 		 	 = VrBmt.UVGen.V_Mirror
		  Bmt.coords.U_Tile 		 	 = VrBmt.UVGen.U_Tile
		  Bmt.coords.V_Tile 		 	 = VrBmt.UVGen.V_Tile
		  Bmt.coords.showMapOnBack  	 = VrBmt.UVGen.showMapOnBack
		  Bmt.coords.Noise_On 		 	 = VrBmt.UVGen.Noise_On
		  Bmt.coords.Noise_Animate  	 = VrBmt.UVGen.Noise_Animate
		  --Bmt.coords.UVTransform	 	 = VrBmt.UVGen.UVTransform
		  Bmt.coords.realWorldScale 	 = VrBmt.UVGen.realWorldScale
		  Bmt.coords.realWorldHeight	 = VrBmt.UVGen.realWorldHeight
		  Bmt.coords.realWorldWidth 	 = VrBmt.UVGen.realWorldWidth
		  Bmt.coords.phase 		 	 	 = VrBmt.UVGen.phase
		  Bmt.coords.U_Angle 		 	 = VrBmt.UVGen.U_Angle
		  Bmt.coords.V_Angle 		 	 = VrBmt.UVGen.V_Angle
		  Bmt.coords.W_Angle 		 	 = VrBmt.UVGen.W_Angle
		  Bmt.coords.Noise_Amount 	 	 = VrBmt.UVGen.Noise_Amount
		  Bmt.coords.Noise_Size 	 	 = VrBmt.UVGen.Noise_Size
		  Bmt.coords.Noise_Levels 	 	 = VrBmt.UVGen.Noise_Levels
		  Bmt.coords.Blur_Offset 	 	 = VrBmt.UVGen.Blur_Offset
		  Bmt.coords.u_tiling 		 	 = VrBmt.UVGen.u_tiling
		  Bmt.coords.v_tiling 		 	 = VrBmt.UVGen.v_tiling
		  Bmt.coords.u_offset 		 	 = VrBmt.UVGen.u_offset
		  Bmt.coords.v_offset 		 	 = VrBmt.UVGen.v_offset

		  Bmt.apply	 	 	 			 = VrBmt.cropplace_on	
		  Bmt.cropPlace		 	 		 = VrBmt.cropplace_mode
  
		  Bmt.clipu		 	 	 		 = VrBmt.cropplace_u 
		  Bmt.clipv		 	 	 		 = VrBmt.cropplace_v 
		  Bmt.clipw	 	 	 			 = VrBmt.cropplace_width
		  Bmt.cliph	 	 	 			 = VrBmt.cropplace_height
		  
		  Bmt.output.invert  		 	 = VrBmt.output.invert 
		  Bmt.output.clamp  		 	 = VrBmt.output.clamp 
		  Bmt.output.alphaFromRGB  	 	 = VrBmt.output.alphaFromRGB 
		  Bmt.output.output_amount 	 	 = VrBmt.output.output_amount 
		  Bmt.output.rgb_level  	 	 = VrBmt.output.rgb_level 
		  Bmt.output.rgb_offset  	 	 = VrBmt.output.rgb_offset 
		  Bmt.output.Bump_Amount   	 	 = VrBmt.output.Bump_Amount 
		  
		  Bmt.rgbOutput 			 	 = VrBmt.rgbOutput
		  Bmt.monoOutput			 	 = VrBmt.monoOutput
		  Bmt.alphaSource			 	 = VrBmt.alphaSource
		  
		  Bmt.startTime 		 	 	 = VrBmt.iflStartFrame
		  Bmt.endCondition		 	 	 = VrBmt.iflEndCondition
		  Bmt.playBackRate		 	 	 = VrBmt.iflPlaybackRate
		  replaceinstances Bmt.output  VrBmt.output
 
	---------------------------------------------------------
	--Replacing the map
	---------------------------------------------------------
	
		replaceInstances (VrBmt) (Bmt)
	
		--clean up the mess
		VrBmt = undefined
		gc()
	
	)
	--=========================================
	fn BmtToVrayHDRI Bmt = 
	(

	local VrBmt = VrayHDRI()
	
	---------------------------------------------------------
	--Setting Values
	---------------------------------------------------------
		VrBmt.name = Bmt.name
		VrBmt.maptype = 4 -- Set Mapping Type to "3ds Max standard"
	
		VrBmt.HDRIMapName = Bmt.fileName  				-- Set Filename
	
		  VrBmt.UVGen.blur			 = Bmt.coords.blur
		  VrBmt.UVGen.mapping 		 = Bmt.coords.mapping
		  VrBmt.UVGen.mapChannel 	 = Bmt.coords.mapChannel
		  VrBmt.UVGen.mappingType 	 = Bmt.coords.mappingType
		  VrBmt.UVGen.UVW_Type  	 = Bmt.coords.UVW_Type
		  VrBmt.UVGen.U_Mirror 		 = Bmt.coords.U_Mirror
		  VrBmt.UVGen.V_Mirror 		 = Bmt.coords.V_Mirror
		  VrBmt.UVGen.U_Tile 		 = Bmt.coords.U_Tile
		  VrBmt.UVGen.V_Tile 		 = Bmt.coords.V_Tile
		  VrBmt.UVGen.showMapOnBack  = Bmt.coords.showMapOnBack
		  VrBmt.UVGen.Noise_On 		 = Bmt.coords.Noise_On
		  VrBmt.UVGen.Noise_Animate  = Bmt.coords.Noise_Animate
		  --VrBmt.UVGen.UVTransform	 = Bmt.coords.UVTransform
		  VrBmt.UVGen.realWorldScale = Bmt.coords.realWorldScale
		  VrBmt.UVGen.realWorldHeight= Bmt.coords.realWorldHeight
		  VrBmt.UVGen.realWorldWidth = Bmt.coords.realWorldWidth
		  VrBmt.UVGen.phase 		 = Bmt.coords.phase
		  VrBmt.UVGen.U_Angle 		 = Bmt.coords.U_Angle
		  VrBmt.UVGen.V_Angle 		 = Bmt.coords.V_Angle
		  VrBmt.UVGen.W_Angle 		 = Bmt.coords.W_Angle
		  VrBmt.UVGen.Noise_Amount 	 = Bmt.coords.Noise_Amount
		  VrBmt.UVGen.Noise_Size 	 = Bmt.coords.Noise_Size
		  VrBmt.UVGen.Noise_Levels 	 = Bmt.coords.Noise_Levels
		  VrBmt.UVGen.Blur_Offset 	 = Bmt.coords.Blur_Offset
		  VrBmt.UVGen.u_tiling 		 = Bmt.coords.u_tiling
		  VrBmt.UVGen.v_tiling 		 = Bmt.coords.v_tiling
		  VrBmt.UVGen.u_offset 		 = Bmt.coords.u_offset
		  VrBmt.UVGen.v_offset 		 = Bmt.coords.v_offset

		  VrBmt.cropplace_on		 = Bmt.apply
		  VrBmt.cropplace_mode		 = Bmt.cropPlace
  
		  VrBmt.cropplace_u		 	 = Bmt.clipu 
		  VrBmt.cropplace_v		 	 = Bmt.clipv 
		  VrBmt.cropplace_width	 	 = Bmt.clipw
		  VrBmt.cropplace_height	 = Bmt.cliph
		  
		  VrBmt.output.invert  		 = Bmt.output.invert 
		  VrBmt.output.clamp  		 = Bmt.output.clamp 
		  VrBmt.output.alphaFromRGB  = Bmt.output.alphaFromRGB 
		  VrBmt.output.output_amount = Bmt.output.output_amount 
		  VrBmt.output.rgb_level  	 = Bmt.output.rgb_level 
		  VrBmt.output.rgb_offset  	 = Bmt.output.rgb_offset 
		  VrBmt.output.Bump_Amount   = Bmt.output.Bump_Amount 
		  
		  VrBmt.color_space 		 = 3 -- Setting the color space to "from 3ds max" so the bitmap loader gamma stays at whatever the user set it.
		  VrBmt.rgbOutput 			 = Bmt.rgbOutput
		  VrBmt.monoOutput			 = Bmt.monoOutput
		  VrBmt.alphaSource			 = Bmt.alphaSource
		  
		  VrBmt.iflStartFrame 		 = Bmt.startTime
		  VrBmt.iflEndCondition		 = Bmt.endCondition
		  VrBmt.iflPlaybackRate		 = Bmt.playBackRate
		  replaceinstances VrBmt.output  Bmt.output
 
	---------------------------------------------------------
	--Replacing the map
	---------------------------------------------------------
	
		replaceInstances (Bmt) (VrBmt)
		
		--clean up the mess
		Bmt = undefined
		gc()
	)


rollout MapMan "CADMAN Map And Material Manager" width:710 height:113
(
	button btnConvertBitmapLoaders "Convert all bitmap loaders to VRAY HDRI" pos:[487,39] width:218 height:31
	button btnMaxGamma "Set 3Ds max system Gamma to 2.2" pos:[486,4] width:218 height:31 enabled:false
	button btnSetGamma "Set all root color correctors gamma" pos:[488,74] width:173 height:31
	button btnLinearizeAll "LINEARIZE MY SCENE! (If you don't know what the buttons on the right side do, just click here.)" pos:[4,5] width:478 height:98
	dropDownList ddlGamma "" pos:[663,78] width:42 height:21 items:#("1.0", "2.2")

	
	on MapMan open  do ()
		
	on btnConvertBitmapLoaders pressed  do (
		try(
		matarr = getClassInstances vraymtl
		matarr.count
		arr =	getClassInstances bitmaptexture
		arr.count
		counter =1 
		
	
	for i in arr do(
		print ( "Processing " + counter  as string + " of " + arr.count as string)
		print ( "Converting: " + i as string  )
		print ( "Filename: " + i.fileName as string  )
		try (BmtToVrayHDRI i) catch (print "ERROR PROCESSING :" + i as string)
		counter = counter + 1
		--windows.processPostedMessages()
			)
			messagebox ( "DONE converting " + counter as string + " bitmap loaders to HDRI loaders" )
		)catch()
		)
		
	on btnMaxGamma pressed  do ()
		
	on btnSetGamma pressed  do (
		try(
		arr =	getClassInstances ColorCorrect
		arr.count
			for i in arr do(
			 if (isCCGammaOnly i) do(
				 i.gamma = ddlGamma.selected as float 
				 )
			)
			messagebox ("Gamma In " + arr.count as string + " Color Corrector Nodes Set (Only gamma correction color correctors are affected)")
		)catch()
		)
		
	on btnLinearizeAll pressed  do (
		try(
			
		--Set gamma for all maps
		MapMan.btnSetGamma.pressed()
		
		--Correct VrayColor maps.			
		vraycolormaps =	getClassInstances VRayColor
		
			for i in vraycolormaps do i.gamma_correction = 2
			
		if ((queryBox "Do you want to convert bitmap loaders to Vray HDRI loaders as well? (Recommended)") == true) do (
		MapMan.btnConvertBitmapLoaders.pressed()
		)
		
		Messagebox "Ok, all done. remember to turn on Gamma (2.2) in your Customize -> preferences -> Gamma and Lut settings. Also turn on \"Affect Color Selectors\" and \"Affect Material Editor\" this can't be done through maxscript"
		)
		
		
		catch()
		)
		
	on ddlGamma selected sel do ()
		
)

createdialog MapMan
