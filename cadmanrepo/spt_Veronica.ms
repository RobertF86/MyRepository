--StuffToKnow
/*
smtdsettings
smtdfunctions.submitJob()
*/
if classOf ::rloVeronica == RolloutClass do DestroyDialog ::rloVeronica
rollout rloVeronica "Veronica" width:1200 height:714
(
	listBox lbxCameraList "Cameras" pos:[9,4] width:141 height:13
	radioButtons rdoRenderDepth "Render Depth" pos:[155,4] width:75 height:62 enabled:true labels:#("8 Bit TGA", "16 Bit EXR", "32 Bit EXR") columns:1 default:1
	dropDownList ddlRenderElementSets "Render Element Sets" pos:[236,4] width:202 height:40 items:#("Normal","Fume")
	label lblRenderRange "Render Range" pos:[162,149] width:115 height:15
	label lblFrom "From" pos:[162,164] width:54 height:12
	label lblTo "To" pos:[255,165] width:54 height:12
	dropDownList ddlRenderMode "Render Mode" pos:[235,48] width:201 height:40 items:#("Single Frame","Irradiance Animation", "Prerendered Lightmap", "Frame By Frame","No GI Animation")
	spinner spnFrom "" pos:[161,178] width:89 height:16 range:[0,9999999,1000] type:#integer
	spinner spnTo "" pos:[254,178] width:81 height:16 range:[0,9999999,1000] type:#integer
	button btnGetFromTimeline "Get From Timeline" pos:[339,177] width:92 height:18
	editText edtRenderOutputPath "" pos:[4,224] width:1006 height:17
	label lblRendOutput "Render Output Path" pos:[10,207] width:99 height:11
	listBox lbxRenderElements "Render Elements" pos:[10,260] width:890 height:12
	listBox lbxPossbleProblems "Possible Problems" pos:[10,455] width:890 height:15
	checkbox chkExpCamera "Export Camera with Rendering" pos:[439,24] width:172 height:18 checked:true
	spinner spnSingleFrame "" pos:[163,126] width:76 height:16 range:[0,9999999,0] type:#integer
	spinner spnRenderPrio "Rendering Priority" pos:[520,70] width:76 height:16 range:[0,100,50] type:#integer
	spinner spnRenderPrioPlus "Preview +" pos:[520,90] width:76 height:16 range:[0,100,20] type:#integer
	label lblSingleFrame "Single Frame" pos:[165,110] width:72 height:15
	bitmap bmpVeronica "Bitmap" pos:[995,6] width:200 height:200 fileName:@"\\srs01\3d\jarvis\cats\Veronica.jpg"
	button btnSubmit "Submit" pos:[420,682] width:480 height:26
	button btnCheckForProblems "CheckForProblems" pos:[11,682] width:400 height:26
	radioButtons rdoPath "Paths" pos:[155,64] width:75 height:62 enabled:true labels:#("Auto", "Manu") columns:1 default:2

	groupbox grpRenderSettings "Render Settings" pos:[905,255] width:290 height:450
	
	-- Rendersettings
	--GI
	dropDownList ddlIrradianceMapPreset "GI Preset" pos:[910,400] width:120 height:40 items:#("Very Low", "Low", "Medium", "Medium-Animation", "High", "High-Animation", "Very High") selection:4
	spinner spnSphSubdiv "HSph. Subdivs:" pos:[985,450] width:50 height:16 range:[0,50000,50]	type:#integer
	spinner spnIntSamples "Int Samples: " pos:[985,470] width:50 height:16 range:[0,100,15] type:#integer
	spinner spnIntFrames "Int Frames: " pos:[985,490] width:50 height:16 range:[0,100,2] type:#integer	
	spinner LightCacheSamples "LgtCacheSubdiv"  pos:[985,510] width:50 height:16 range:[0,10000,1000] type:#integer
	
	--Anti Aliasing
	dropDownList ddlAntiAliasing "AA Engine" pos:[910,270] width:120 height:40 items:#("Adaptive DMC") selection:1
	spinner spnMinSamples "Min Samples" pos:[985,320] width:50 height:16 range:[0,5,1]	type:#integer
	spinner spnMaxSamples "Max Samples" pos:[985,340] width:50 height:16 range:[0,10,3] type:#integer
	spinner spnCtrlThresh "Ctrl Threshold " pos:[985,360] width:50 height:16 range:[0,100,0.03] type:#float	
	checkbox chkCustomControlThres "Use DMC Sm. Thresh." pos:[915,380] width:150 height:16 range:[0,100,0.03] type:#float checked:true
	
	--AA Filtering 
	dropDownList ddlAAFilter "AA Filtering" pos:[1040,270] width:120 height:40 items:#("Area","Mitchel-Netravali","Catmull-Rom","Soften") selection:1
	spinner spnSize "FilterSize" pos:[1120,320] width:50 height:16 range:[0,10,1.5]	type:#float
	spinner spnRinging "FilterRinging" pos:[1120,340] width:50 height:16 range:[0,10,0.333]	type:#float
	spinner spnBlur "Blur" pos:[1120,360] width:50 height:16 range:[0,10,0.333]	type:#float
	
	--DMC Settings
	label lblDMCSettings "DMC Settings" pos:[1050,405] width:99 height:11
	spinner spnNoiseThreshold "NoiseThreshold" pos:[1120,425] width:50 height:16 range:[0,10,0.01]	type:#float
	spinner spnDMCMinSamples "DMC Min Samples" pos:[1120,445] width:50 height:16 range:[0,10,8]	type:#integer
	spinner GlobSubdivMult "Glo. Subd. Mult." pos:[1120,465] width:50 height:16 range:[0,10,1.0]	type:#float

	
		local lListItems
		local lPickList
		local nEnabledSuns
		local nNestedXrefs

-----------------------AE RELATED FUNCTIONS
fn SelectionFilter = 
(
	Sel = getCurrentSelection() as array
			
			for f = 1 to Sel.count do 
			(
			Selname = Sel [f].name
				if superclassof Sel[f] == camera do
				(		
					Sk_CameraExport_Main.Cameralist.items = append Sk_CameraExport_Main.Cameralist.items Selname
				)
					if superclassof Sel[f] == Light do
						(		
					Sk_CameraExport_Main.LightList.items = append Sk_CameraExport_Main.LightList.items Selname
				)
				
				if superclassof Sel[f] != Light and superclassof Sel[f] != Camera and classof Sel[f] != Targetobject do
				(		
					if classof Sel[f] != DaylightAssemblyHead do 
					(
					Sk_CameraExport_Main.ObjectList.items = append Sk_CameraExport_Main.ObjectList.items Selname
					)
				)
			)
)	
fn AnimationCheckfn =
(

AnimationCheck =	
(	try
	FirstKeyframe = (at time -1 trackbar.getNextKeyTime() as integer/TicksPerFrame)

catch ())

	MyRange == on
if MyRange == on then
			(
				StartAnimation =animationrange.start as integer/TicksPerFrame
				EndAnimation = animationrange.end as integer/TicksPerFrame
				Duration =  animationrange.end as integer/TicksPerFrame+1
				)
else
				(
				if AnimationCheck != undefined  then 
					(
						PlayrangeEnd = animationrange.end as integer/TicksPerFrame
						Print "Animation Found"
						StartAnimation = FirstKeyframe
						EndAnimation = (at time 9999999999999999999999 trackbar.getPreviousKeyTime() as integer/TicksPerFrame)
						Duration = EndAnimation+1
					)
					else 
					(
						Print "No Animation Found"
						StartAnimation =0
						EndAnimation = 0
						Duration =  animationrange.end as integer/TicksPerFrame+1
					
					)
				)	
	#(StartAnimation, EndAnimation, Duration)
)
fn AeExport Exportname AEItems =
(
	
-- Make Array and it's info
	
ItemArray= AEItems as array
Newarray = append ItemArray ItemCount
ItemCount = Newarray.count-1
	
	
--Check Duration
	
for n = 1 to ItemCount do
(
ItemNo = Newarray[n]
Item = Execute  ("$'"+ItemNo+"'")
selectmore Item
)

AnimationCheckArray = AnimationCheckfn ()
CompDuration = AnimationCheckArray[3]
if (CompDuration < animationrange.end as integer/TicksPerFrame) then (CompDuration = animationrange.end as integer/TicksPerFrame)

	--Start Write File
Scriptfile = openFile exportname  mode:"w+"	
-- Comp creation	

Format ("//Camera Export Max to AE by Sk-Films \n\n" as string) to: Scriptfile
Format  "var NewComp = app.project.items.addComp(\"%\", %, %, 1, (%/%), %) //Make comp \n" (getFilenamefile exportname) renderwidth renderheight CompDuration framerate framerate    to: Scriptfile


	
for n = 1 to ItemCount do
(
--Vars
RadiusState = 0
RollState = 1 -- (on)	
RotationState = 1
ScaleState = 0
	
--Rotation states:
--0 = None
-- 1 = Normal
--2 = Target
--3 = Fake Target

	
ItemNo = Newarray[n]
Item = Execute  ("$'"+ItemNo+"'")
select Item

--Animation Check
AnimationCheckArray = AnimationCheckfn ()
StartAnimation = AnimationCheckArray[1]
EndAnimation = AnimationCheckArray[2]
Duration = AnimationCheckArray[3]

--If Duration< CompDuration then (Duration = CompDuration)
	
	Print StartAnimation
	Print EndAnimation
	Print Duration

	

-- if camera - Camerea Creation
if superclassof Item == camera do		

	(
	RotationState = 2
		
	JsxItem = "NewCamera"
	Format "var NewCamera% = NewComp.layers.addCamera(\"%\",[0,0]);\n" n Item.name to: Scriptfile
	Format "NewCamera%.inPoint = %/%;\n" n StartAnimation framerate to: Scriptfile
	Format "NewCamera%.outPoint = %/%;\n" n Duration framerate to: Scriptfile
	--Set Frame Marker	
	Format "var StartMark = new MarkerValue(\"MaxFrame:%\")\n" StartAnimation to: Scriptfile
	Format "NewCamera%.property(\"Marker\").setValueAtTime((%/%),(StartMark))\n " n StartAnimation framerate to: Scriptfile
	
	
		if Item.target == undefined do
		(
			Print "Free Camera (No Target)"
			
			RotationState = 1
			Format "NewCamera%.autoOrient = AutoOrientType.NO_AUTO_ORIENT;\n" n to: Scriptfile
			
			)
	)
-- if Object  - Null Creation

if superclassof Item != Light and superclassof Item != Camera and classof Item != Targetobject do		
	(
	RotationState = 1
	ScaleState = 1
	JsxItem = "NewObj"
	Format "var NewObj% = NewComp.layers.addNull(NewComp.duration)\n" n to: Scriptfile
	Format "NewObj%.name = \"%\"\n" n Item.name to: Scriptfile
	Format "NewObj%.threeDLayer = true\n" n to: Scriptfile

	Format "NewObj%.transform.position.setValue([-498.134,-301.333,-1.31717e-005])\n" n to: Scriptfile
	Format "NewObj%.inPoint = %/%;\n" n StartAnimation framerate to: Scriptfile
	Format "NewObj%.outPoint = %/%;\n\n" n Duration framerate to: Scriptfile
	)
	
-- If Light - Light Creation
	
if superclassof Item == Light do		

	(
	RotationState = 0 
	JsxItem = "NewLight"
	Format "NewLight% = NewComp.layers.addLight(\"%\",[0,0])\n" n item.name to: Scriptfile
	Format "NewLight%.property(\"Color\").setValue([%,%,%])\n" n (Item.color.r/255.) (Item.color.g/255.) (Item.color.b/255.) to: Scriptfile
	Format "NewLight%.inPoint = %/%;\n" n StartAnimation framerate to: Scriptfile
	Format "NewLight%.outPoint = %/%;\n\n" n Duration framerate to: Scriptfile
		
case of
	
(
(classof Item == TargetDirectionallight): (Format "NewLight%.lightType = LightType.PARALLEL;\n" n to: Scriptfile
			RotationState = 2
			RollState = 0
			RadiusState = 0)
(classof Item == Directionallight): (Format "NewLight%.lightType = LightType.PARALLEL;\n" n to: Scriptfile 
			RotationState = 3
			RollState = 0
			RadiusState = 0)
(classof Item == targetSpot): (Format "NewLight%.lightType = LightType.SPOT;\n" n to: Scriptfile
			RotationState = 2
			RadiusState = 1)
(classof Item == freeSpot): (Format "NewLight%.lightType = LightType.SPOT;\n" n to: Scriptfile
			RotationState = 3
			RadiusState = 1)
(classof Item == Omnilight): 	(Format "NewLight%.lightType = LightType.POINT;\n" n to: Scriptfile)
default: 	(Format "NewLight%.lightType = LightType.POINT;\n" n to: Scriptfile
	RotationState = 0)
)		
		
		)


--Check Animation
for i = StartAnimation to EndAnimation do 
	
(

--Scale
if ScaleState == 1  do		
(
Scale = (at time i Item.scale)*100
format "%%.property(\"Scale\").setValueAtTime((%/%),[%,%,%])\n" JsxItem n i framerate Scale.x Scale.y Scale.z to:Scriptfile
)
--Position 
	
Position = at time i Item.transform.row4

format "%%.property(\"Position\").setValueAtTime((%/%),[%,%,%])\n" JsxItem n i framerate Position.x -Position.z Position.y to:Scriptfile

--Rotation
case of
		(
		(RotationState == 0):  Print "No Rotation"
		(RotationState == 1): 
			(
				ItemRotation = at time i in coordsys World Item.rotation  as eulerAngles 
					Print "nice"
					Print ItemRotation
						Format "%%.transform.orientation.setValue([270.0,0.0,0.0])\n"  JsxItem n to: Scriptfile
				
 						format "%%.property(\"X Rotation\").setValueAtTime((%/%),[%])\n" JsxItem n i framerate -ItemRotation.x to:Scriptfile
 						format "%%.property(\"Y Rotation\").setValueAtTime((%/%),[%])\n" JsxItem n i framerate ItemRotation.y to:Scriptfile
 						format "%%.property(\"Z Rotation\").setValueAtTime((%/%),[%])\n" JsxItem n i framerate ItemRotation.z to:Scriptfile
				--format "%%.transform.orientation.setValueAtTime((%/%),[%,%,%])\n" JsxItem n i framerate  ItemRotation.x ItemRotation.y ItemRotation.z to: Scriptfile
			)
		(RotationState == 2): 
			( 
					Targetpos = at time i  in coordsys World Item.Target.Position
					format "%%.property(\"Point of Interest\").setValueAtTime((%/%),[%,%,%])\n" JsxItem n i framerate Targetpos.x -Targetpos.z Targetpos.y to:Scriptfile
				if RollState != 0 do
				(format "%%.property(\"Z Rotation\").setValueAtTime((%/%),[%])\n" JsxItem n i framerate -Item.controller.roll_angle to:Scriptfile)
				
			)
		(RotationState == 3): 
			(
				GettingTarget = at time i  in coordsys World Item.transform
				preTranslate GettingTarget [0,0,-50] 
				Targetpos = GettingTarget.translation
				format "%%.property(\"Point of Interest\").setValueAtTime((%/%),[%,%,%])\n" JsxItem n i framerate Targetpos.x -Targetpos.z Targetpos.y to:Scriptfile
		
			)
		default: Print "No Rotation/Or object not included by Author"
		)
--Zoom
if superclassof Item == camera do	
	(
		CameraLens = at time i (renderWidth/2.0 ) / ( tan (Item.fov/2))
		format "%%.property(\"Zoom\").setValueAtTime((%/%),[%])\n" JsxItem n i framerate CameraLens to:Scriptfile
	)
	
--Light Radius
	If RadiusState == 1 do
	(
		
		AEHotspot = Item.falloff 
		AEFalloff = ($.falloff-$.hotspot)/($.falloff/100)
		
		format "%%.property(\"coneAngle\").setValueAtTime((%/%),[%])\n" JsxItem n i framerate AEHotspot to:Scriptfile
		format "%%.property(\"coneFeather\").setValueAtTime((%/%),[%])\n" JsxItem n i framerate AEFalloff to:Scriptfile
	)
	
)
)
close Scriptfile

--messageBox "Export Done" title:"Sk-Films: Camera Export"
)
----------------------END AE RELATED FUNCTIONS
----------------------CAMERA RANGE SELECTION RELATED STUFF
			fn getCamRange sa lKeys:unsupplied = 
			(
				local bInitCall = lKeys == unsupplied
				if bInitCall then 
				(
					lKeys = #()
					
					if sa.target != undefined then getCamRange sa.target lKeys:lKeys
					if sa.parent != undefined then getCamRange sa.parent lKeys:lKeys
				)
				
				for nSub = 1 to sa.numSubs do
				(
					local sub = sa[nSub]
					
					if sub.keys != undefined then
						for nKey = 1 to sub.keys.count do append lKeys (sub.keys[nKey].time as integer / ticksperframe)
					
					getCamRange sub lKeys:lKeys
				)
				
				if bInitCall then
				(
					lKeys = makeUniqueArray lKeys
					sort lKeys
					if lKeys.count < 2
						then return interval 0 animationrange.end
						else return interval lKeys[1] lKeys[lKeys.count]
				)
			)
----------------------END CAMERA RANGE SELECTION RELATED STUFF
----------------------PROBLEM CHECKING RELATED STUFF
			fn isGeometry obj =
			(
				--return
				(
					(superclassof obj == shape and obj.render_renderable) \
					or \
					(superclassof obj == geometryclass and (try (obj.mesh.verts; true) catch false))
				)
			)
			
			fn getExampleNames l =
			(
				-- .filename
				if classof l[1] == texturemap then
				(
					local t = getFilenameFile l[1].filename + getFilenameType l[1].filename
					for n = 2 to 3 where n <= l.count do t += ", "+ getFilenameFile l[n].filename + getFilenameType l[n].filename
					if l.count > 3 then t += ", ..."
					return t
				)
				-- .name
				else try
				(
					local t = l[1].name
					for n = 2 to 3 where n <= l.count do t += ", "+ l[n].name
					if l.count > 3 then t += ", ..."
					return t
				)
				catch return (l[1] as string)
			)
			
			fn checkForProblems lObjs tSourceFile root xref =
			(
				local lProblemItems = #()
				local lProblemObjs = #()
				local bIsSceneFile = xref == undefined
				
				local l1 = #() -- 1: objects without material
				local l2 = #() -- 2: objects with standardmaterial
				local l3 = #() -- 3: only vray cams in scene
				local l4 = #() -- 4: camera vignetting off
				local l5 = #() -- 5: max2ae helper layer
				local l6 = #() -- 6: color correct gammma 2.2
				local l7 = #() -- 7: object is hidden
				local l8 = #() -- 8: missing textures
				local l9 = #() -- 9: all textures located on server
				local l10 = #() -- 10: vray color gammma 2.2
				local l11 = #() -- 11: biped set to renderable
				
				-- number of enabled suns
					
					for compassInst in getclassinstances compass target:root do
					(
						for refObj_compass in refs.dependents compassInst do
						(
							if classof refObj_compass == compass and isproperty refObj_compass "handle" then 
							(
								for refObj_dlSys in refs.dependents refObj_compass do
								(
									if classof refObj_dlSys == DaylightAssemblyHead and isproperty refObj_dlSys "handle" then
									(
										try if refObj_dlSys.sun.enabled then nEnabledSuns += 1 catch ()
									)
								)
							)
						)
					)
					
					-- xrefs in xref
					if not bIsSceneFile then
					(
						local nXrefs = xrefs.getXRefFileCount root:xref
						if nXrefs > 0 then
						(
							append lProblemItems (nXrefs as string +" nested xrefs in xref")
							nNestedXrefs += nXrefs
						)
					)
				
				-- scene
					
					-- 8: all textures found
					-- 9: all textures located on server
					for bmap in (getclassinstances bitmaptexture target:root) where bmap.filename != undefined do
					(
						if not doesFileExist bmap.filename then
						(
							appendIfUnique l8 bmap
						)
						if not matchpattern bmap.filename pattern:"\\\\srs*" then
						(
							appendIfUnique l9 bmap
						)
					)
					
					-- 6: color correct gammma 2.2
					for tvp in (getclassinstances ColorCorrect asTrackViewPick:true target:root) do
					(
						local mat = tvp.client
						local cc = tvp.anim
						local bIsTexMap = try mat.texmap_diffuse == cc catch false
						
						if bIsTexMap and cc.gamma != 2.2 then
						(
							for obj in (refs.dependents mat) where classof (superclassof obj) == node do appendIfUnique l6 obj
						)
					)
					
					-- 10: vray color gammma 2.2
					for tvp in (getclassinstances VRayColor asTrackViewPick:true target:root) do
					(
						local mat = tvp.client
						local vc = tvp.anim
						local bIsTexMap = try mat.texmap_diffuse == vc catch false
						
						if bIsTexMap and vc.gamma_value != 2.2 then
						(
							local l =#()
							for obj in (refs.dependents mat) where classof (superclassof obj) == node do appendIfUnique l10 obj
						)
					)
				
				-- objects
				for obj in lObjs do
				(
					local bIsGeometry = isGeometry obj
					
					-- 1: objects without material
					l = #()
					if bIsGeometry and obj.mat == undefined and classof obj != Biped_Object do append l1 obj
					
					-- 2: objects with standardmaterial
					l = #()
					if bIsGeometry and classof obj.mat == Standardmaterial do append l2 obj
					
					-- 3: only vray cams in scene
					if classof obj == camera and classof obj != VRayPhysicalCamera do append l3 obj
					
					-- 4: camera vignetting off
					if classof obj == VRayPhysicalCamera and obj.vignetting do append l4 obj
					
					-- 5: max2ae helper layer
					if classof obj == Helper_Layer do append l5 obj
					
					-- 7: object is hidden
					if bIsGeometry and obj.isHidden do append l7 obj
					
					-- 11: biped set to renderable
					if classof obj == Biped_Object and obj.renderable then append l11 obj
				)
				
				-- 1: objects without material
				if l1.count > 0 do
				(
					append lProblemItems (l1.count as string +" objects without material ("+ getExampleNames l1 +")")
					append lProblemObjs l1
				)
				
				-- 2: objects with standardmaterial
				if l2.count > 0 do
				(
					append lProblemItems (l2.count as string +" objects have standardmaterial ("+ getExampleNames l2 + ")")
					append lProblemObjs l2
				)
				
				-- 3: only vray cams in scene
				if l3.count > 0 do
				(
					append lProblemItems (l3.count as string +" cameras are not vray cameras ("+ getExampleNames l3 + ")")
					append lProblemObjs l3
				)
				
				-- 4: camera vignetting off
				if l4.count > 0 do
				(
					append lProblemItems (l4.count as string +" vray-cameras got vignetting enabled ("+ getExampleNames l4 + ")")
					append lProblemObjs l4
				)
				
				-- 5: max2ae helper layer
				if l5.count > 0 do
				(
					append lProblemItems (l5.count as string +" max2ae helperlayer in scene ("+ getExampleNames l5 + ")")
					append lProblemObjs l5
				)
				
				-- 6: color correct gammma 2.2
				if l6.count > 0 do
				(
					append lProblemItems (l6.count as string +" objects have material with no colorcorrect gamma 2.2 ("+ getExampleNames l6 + ")")
					append lProblemObjs l6
				)
				
				-- 7: object is hidden
				if l7.count > 0 do
				(
					append lProblemItems (l7.count as string +" geometry objects are hidden ("+ getExampleNames l7 + ")")
					append lProblemObjs l7
				)
				
				-- 8: missing textures
				if l8.count > 0 do
				(
					append lProblemItems (l8.count as string +" missing textures ("+ getExampleNames l8 + ")")
					append lProblemObjs l8
				)
				
				-- 9: all textures located on server
				if l9.count > 0 do
				(
					append lProblemItems (l9.count as string +" textures not saved on server ("+ getExampleNames l9 + ")")
					append lProblemObjs l9
				)
				-- 10: vray color gamma 2.2
				if l10.count > 0 do
				(
					append lProblemItems (l10.count as string +" objects have material with no vraycolor gamma 2.2 ("+ getExampleNames l10 + ")")
					append lProblemObjs l10
				)
				
				-- 11: biped set to renderable
				if l11.count > 0 do
				(
					append lProblemItems (l11.count as string +" biped objects are set to renderable ("+ getExampleNames l11 + ")")
					append lProblemObjs l11
				)
				
				-- return
				if lProblemItems.count != 0 then
				(
					if bIsSceneFile
						then append lListItems ("___SCENE___ "+ tSourceFile)
						else append lListItems ("___XREFS___ "+ tSourceFile)
					
					if bIsSceneFile then lPickList = lProblemObjs
					
					join lListItems lProblemItems
					append lListItems ""
				)
				local nProblems = 0
				for l in lProblemObjs do nProblems += l.count
				return nProblems
			)
----------------------END PROBLEM CHECKING RELATED STUFF	
			

fn GetRenderElementNames =( 
	--Refreshing the Render element Name listbox (just refreshing)
	--Also refreshing the Render Output Name: 	edtRenderOutputPath.text = rendOutputFilename
		theManager = maxOps.GetRenderElementMgr #Production
		theManager.numrenderelements()
			
		MyRenderElementStringArray = #()
	
	for i=0 to (theManager.numrenderelements() -1) do
		(
		append  MyRenderElementStringArray  (theManager.GetRenderElementFilename i)
		print (theManager.GetRenderElementFilename i)
		)
		
		lbxRenderElements.items = MyRenderElementStringArray
		edtRenderOutputPath.text = rendOutputFilename
	)

fn SetRenderElementNames =(	
		theManager = maxOps.GetRenderElementMgr #Production
		theManager.numrenderelements()

		getFilenamePath rendOutputFilename
		filenameFromPath rendOutputFilename

		for i=0 to (theManager.numrenderelements() -1) do
		(
		--Get file extention
			if (rdoRenderDepth.state == 1) do myfileextention = ".tga" 
			if (rdoRenderDepth.state == 2) do 
				(
					fopenexr.setLayerOutputFormat 0 1
					myfileextention = ".exr"
				)
			if (rdoRenderDepth.state == 3) do
				(
					fopenexr.setLayerOutputFormat 0 0
					myfileextention = ".exr"
				)
			
		print myfileextention
		myelementName = ((theManager.GetRenderElement i ).elementname)
		print myelementName
		myFilenameFile = (getFilenameFile(filenameFromPath rendOutputFilename))
		print myFilenameFile
		myFilenamePath = (getFilenamePath rendOutputFilename) + ((theManager.GetRenderElement i ).elementname)
		print myFilenamePath
		
		
		theManager.SetRenderElementFilename i (myFilenamePath +"\\" + myFilenameFile + "_" + MyFileExtention )
		print (theManager.GetRenderElementFilename i)
		)
	)

fn CreateRenderElementsFume = (

	RenderPath = rendOutputFilename
	
	re = maxOps.GetCurRenderElementMgr() -- get the current render element manager
	re.numrenderelements() -- get number of render elements

	elem = FumeFX_Smoke elementName:"FumeFX_Smoke"
	elem.elementName 
	re.addrenderelement elem 
	elem = FumeFX_Fire elementName:"FumeFX_Fire"
	re.addrenderelement elem 
	elem = FusionWorks_Velocity elementName:"FusionWorks_Velocity"
	re.addrenderelement elem
	elem.maxVel = 10
	elem = FusionWorks_Z_Depth elementName:"FusionWorks_Z_Depth"
	elem.minDist = 0
	elem.maxDist = 5000
	re.addrenderelement elem 	

	)
fn DeleteRenderElementsFume = (
	re = maxOps.GetCurRenderElementMgr() -- get the current render element manager
	RenderElementsToDelete = #()
	
	for i=0 to (re.numrenderelements()-1) do
		(
			
			local MyElementName = (re.GetRenderElement i).elementname
			case  of
			(
			(MyElementName == "FumeFX_Smoke"): (append RenderElementsToDelete (re.GetRenderElement i) ) --re.RemoveRenderElement i
			(MyElementName == "FumeFX_Fire"): (append RenderElementsToDelete (re.GetRenderElement i) ) --re.RemoveRenderElement i
			( MyElementName == "FusionWorks_Velocity"): (append RenderElementsToDelete (re.GetRenderElement i))
			( MyElementName ==  "FusionWorks_Z_Depth"): (append RenderElementsToDelete (re.GetRenderElement i))
			)		
	)
	
	for i in RenderElementsToDelete do re.RemoveRenderElement i
)	
fn CreateRenderElementsNormal = (
	
	RenderPath = rendOutputFilename
	
	re = maxOps.GetCurRenderElementMgr() -- get the current render element manager
	re.numrenderelements() -- get number of render elements

	elem = VRayReflection elementName:"VRayReflection"
	elem.elementName 
	re.addrenderelement elem 
	elem = VRayRefraction elementName:"VRayRefraction"
	re.addrenderelement elem 
	elem = VrayWireColor elementName:"VRayWireColor"
	re.addrenderelement elem 
	elem = VrayRenderID elementName:"VRayRenderID"
	re.addrenderelement elem 
	elem = VrayNormals elementName:"VRayNormals"
	re.addrenderelement elem 
	elem = VrayZdepth elementName:"VrayZdepth_30000"	
	elem.zdepth_max = 30000
	re.addrenderelement elem 
	elem = VrayZdepth elementName:"VrayZdepth_2500"	
	elem.zdepth_max = 2500
	re.addrenderelement elem 
	elem = VrayZdepth elementName:"VrayZdepth_500"	
	elem.zdepth_max = 500
	re.addrenderelement elem 
	elem = VRayVelocity elementName:"VrayVelocity_150"	
	elem.max_velocity = 150
	re.addrenderelement elem 
	elem = VRayVelocity elementName:"VrayVelocity_75"	
	elem.max_velocity = 75
	re.addrenderelement elem 
	elem = VRayVelocity elementName:"VrayVelocity_25"	
	elem.max_velocity = 25
	re.addrenderelement elem 	
	)

fn DeleteRenderElementsNormal = (
	re = maxOps.GetCurRenderElementMgr() -- get the current render element manager
	RenderElementsToDelete = #()
	
	for i=0 to (re.numrenderelements()-1) do
		(
			
			local MyElementName = (re.GetRenderElement i).elementname
			case  of
			(
			(MyElementName == "VRayReflection"): (append RenderElementsToDelete (re.GetRenderElement i) ) --re.RemoveRenderElement i
			(MyElementName == "VRayRefraction"): (append RenderElementsToDelete (re.GetRenderElement i) ) --re.RemoveRenderElement i
			( MyElementName == "VRayWireColor"): (append RenderElementsToDelete (re.GetRenderElement i))
			( MyElementName ==  "VRayRenderID"): (append RenderElementsToDelete (re.GetRenderElement i))
			( MyElementName == "VRayNormals" ): (append RenderElementsToDelete (re.GetRenderElement i))
			( MyElementName == "VrayZdepth_30000" ):(append RenderElementsToDelete (re.GetRenderElement i))
			( MyElementName == "VrayZdepth_2500" ):(append RenderElementsToDelete (re.GetRenderElement i))
			( MyElementName == "VrayZdepth_500" ):(append RenderElementsToDelete (re.GetRenderElement i))
			( MyElementName == "VrayVelocity_150" ):(append RenderElementsToDelete (re.GetRenderElement i))
			( MyElementName == "VrayVelocity_75" ):(append RenderElementsToDelete (re.GetRenderElement i))
			( MyElementName == "VrayVelocity_25" ):(append RenderElementsToDelete (re.GetRenderElement i))
			)		
	)
	
	for i in RenderElementsToDelete do re.RemoveRenderElement i
)
-----------------------------------IRRADIANCE PREPASS FUNCTIONS---------------------
fn SetIrradianceRenderPaths=(
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

)

fn SetIrradiancePrepassPaths=(
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

		renderers.current.adv_irradmap_autoSaveFileName = IrrMapFilename
		renderers.current.lightcache_autoSaveFileName = LightCacheFileName
		renderers.current.adv_irradmap_loadFileName = IrrMapFilename
		renderers.current.lightcache_loadFileName = LightCacheFileName
	
)
-------------------------------------END IRRADIANCE PREPASS SETTING

on rdoRenderDepth changed state do(
	renderSceneDialog.close()
	if (state != 1) then ((rendOutputFilename = (getFilenamePath rendOutputFilename) +  (getFilenameFile rendOutputFilename) + ".exr")) else ((rendOutputFilename = (getFilenamePath rendOutputFilename) +  (getFilenameFile rendOutputFilename) + ".tga"))
	renderSceneDialog.open()
	SetRenderElementNames()
	GetRenderElementNames()
	)
on btnCheckForProblems pressed do(
				lListItems = #()
				nEnabledSuns = 0
				nNestedXrefs = 0
				lPickList = #()
				
				-- scene objects
				local nProblemObjs = checkForProblems (objects as array) (maxFilePath + maxFileName) rootNode undefined
				local nProblemFiles = if nProblemObjs > 0 then 1 else 0
				
				-- xref objects
				for nXref = 1 to xrefs.getXRefFileCount() do
				(
					local xref = xrefs.getXRefFile nXref
					local lChilds = for child in xref.tree.children collect child
					
					if not xref.disabled then
					(					
						local n = checkForProblems lChilds xref.filename xref.tree xref
						if n > 0 then
						(
							nProblemObjs += n
							nProblemFiles += 1
						)
					)
				)
				
				local tShit = ""
				if nEnabledSuns > 1 then tShit += ", "+ nEnabledSuns as string +" suns are enabled"
				if nNestedXrefs > 0 then tShit += ", "+ nNestedXrefs as string +" nested xrefs"
				lbxPossbleProblems.text = "Possible Problems: "+ nProblemObjs as string+" Problems in "+ nProblemFiles as string +" Files" + tShit
				
				if lListItems.count == 0
					then lListItems = #("no problems yaaay!")
					else deleteItem lListItems (lListItems.count)
				
				lbxPossbleProblems.items = lListItems
				
				-- what is this shit
				rollout cShit (substring tShit 2 (tShit.count - 1))
				(
					bitmap cBmap pos:[0,0] width:385 height:294 filename:"\\\\srs01\\3d\\bibliothek\\maps\\wits.jpg"
				)
				if tShit != "" then try createDialog cShit 385 294 catch()

	)
--SUBMISSION
on btnSubmit pressed do(
	--CreateRenderElementsNormal()
	SetRenderElementNames()
	
	--Generate RenderElementDirectories
	theManager = maxOps.GetRenderElementMgr #Production
	theManager.numrenderelements()
	for i=0 to (theManager.numrenderelements() -1) do
		(
		makeDir (getFilenamePath (theManager.GetRenderElementFilename i)) all:true
		)
		
	--Get Anti Aliasing Settings from Veronica Dialog
	renderers.current.imageSampler_type = 1
	renderers.current.adaptiveSubdivision_minRate = spnMinSamples.value
	renderers.current.adaptiveSubdivision_maxRate = spnMaxSamples.value
	renderers.current.adaptiveSubdivision_threshold = spnCtrlThresh.value
	renderers.current.twoLevel_useDMCSamplerThresh =  chkCustomControlThres.checked
	
	--GI Settings
	renderers.current.gi_primary_type = 0
	renderers.current.gi_secondary_type = 3
	renderers.current.gi_irradmap_preset = ddlIrradianceMapPreset.selection
	renderers.current.gi_irradmap_subdivs = spnSphSubdiv.value
	renderers.current.gi_irradmap_interpSamples = spnIntSamples.value
	renderers.current.gi_irradmap_interpFrames = spnIntFrames.value
	renderers.current.lightcache_subdivs = LightCacheSamples.value
		
	--DMC SETTINGS
	renderers.current.dmc_earlyTermination_threshold = spnNoiseThreshold.value
	renderers.current.dmc_subdivs_mult = GlobSubdivMult.value
	renderers.current.dmc_earlyTermination_minSamples = spnDMCMinSamples.value
	
	--AA Filtering
	if (ddlAAFilter.selected == "Area") do 	renderers.current.filter_kernel = Area()
	if (ddlAAFilter.selected == "Mitchel-Netravali") do renderers.current.filter_kernel = Mitchell_Netravali()
	if (ddlAAFilter.selected == "Catmull-Rom") do 	renderers.current.filter_kernel = Catmull_Rom()	
	if (ddlAAFilter.selected == "Soften") do 	renderers.current.filter_kernel = Soften()
	
	--Turn save file on
	rendSaveFile = true
	--Disable Vray Framebuffer	
	local FramebufferWasOn = false
	if (renderers.current.output_on == true) do
	(
	FramebufferWasOn = true
	renderers.current.output_on = false
	)
	
	--Write Renderpreset File
	renderpresets.SaveAll 0 (getfilenamepath rendOutputFilename +"\\_renderpreset.rps")
	
	--Write Render info File
		(
			local Fs = openFile (getfilenamepath rendOutputFilename +"\\_renderinfo.txt") mode:"w+"
			if Fs != undefined then
			(
				format ("maxFile="+ maxFilePath as string + maxFileName as string +"\n") to:Fs
				format ("\n") to:Fs
				
				local cam = getactivecamera()
				if cam != undefined then
				(
					format ("cam="+ cam.name +"\n") to:Fs
					format ("\n") to:Fs
				)
				
				format ("submissionBy="+ sysInfo.computername +"\n") to:Fs
				format ("submissionTimestamp="+ timestamp() as string +"\n") to:Fs
				format ("submissionDate="+ localtime +"\n") to:Fs
				format ("\n") to:Fs
				
				-- xrefs
				for nXref = 1 to xrefs.getXRefFileCount() do
				(
					local xref = xrefs.getXRefFile nXref
					if not xref.disabled then
					(
						format ("xrefFile="+ xref.filename +"\n") to:Fs
					)
					)
				if xrefs.getXRefFileCount() > 0 then format ("\n") to:Fs
		
				-- sun
				try 
				(
					for dlSysTvp in getclassinstances DaylightAssemblyHead astrackviewpick:true do
					(
						local dlSysObj = dlSysTvp.client
						local sunObj = dlSysObj.sun
						
						if sunObj.enabled then
						(
							local compassObj = undefined
							for compassInst in getclassinstances compass do
							(
								for refObj_compass in refs.dependents compassInst do
								(
									if classof refObj_compass == compass and isproperty refObj_compass "handle" then 
									(
										for refObj_dlSys in refs.dependents refObj_compass do
										(
											if classof refObj_dlSys == DaylightAssemblyHead and isproperty refObj_dlSys "handle" then
											(
												if refObj_dlSys.handle == dlSysObj.handle then compassObj = refObj_compass
											)
										)
									)
								)
							)
							
							if compassObj != undefined then
							(
								local nCompassRotZ = -(quattoeuler compassObj.rotation).z
								local nTime = dlSysObj.controller.solar_time.controller.value * 60 * 60
								local nTime_h = int(nTime/3600.0)
								local nTime_m = int((nTime - nTime_h*3600.0)/60.0)
								local nTime_s = int(nTime - nTime_h*3600.0 - nTime_m*60.0 + 0.5)
								
								format ("sun_name="+ dlSysObj.name +"\n") to:Fs
								format ("sun_compassRotationZ="+ nCompassRotZ as string +"\n") to:Fs
								format ("sun_time=%:%:%\n") nTime_h nTime_m nTime_s to:Fs
								format ("\n") to:Fs
							)
						)
					)
				)
				catch()
						
				close Fs
			)
		)
		
	--Write Camera AFX File if selected.
	
	if (chkExpCamera.checked == true) do(
	myarray = #()
	obj = getnodebyname lbxCameraList.selected
	append myarray (obj.name)
	exportfilePathAndName = (getfilenamepath rendOutputFilename +"\\" + lbxCameraList.selected + ".jsx")
	AeExport exportfilePathAndName myarray
	)
	
	---------------------------------------------Begin Submit Procedure------------------------
	
	if (ddlRenderMode.selection == 1) do ( -- Single Frame submission
		renderSceneDialog.close()
		
		
		smtdsettings.Priority = spnRenderPrio.value
		rendTimeType = 4
		rendPickupFrames  = spnSingleFrame.value as string
		smtdsettings.jobname = filenameFromPath rendOutputFilename	
		rendSaveFile = true
		
		-- Set Deadline to NOT FUCK WITH THE RENDER ELEMENT NAMES!
		smtdsettings.RenderElementsUpdatePaths = false
		smtdsettings.RenderElementsUpdateFilenames = false
		smtdsettings.RenderElementsPermanentChanges = false 
		smtdsettings.RebuildRenderElements = false
		
		smtdfunctions.submitJob()
		
		renderSceneDialog.open()
	)
		
	if (ddlRenderMode.selection == 2) do ( -- Irradiance Animation Submission
		
		renderSceneDialog.close()
		
		SetRenderElementNames()
		
		rendTimeType = 3
		rendStart   = abs (spnFrom.value)
		rendEnd 	= abs (spnTo.value)
		
		------------------------------Submit Prepass------------------------------
		local reMgr = maxOps.getCurRenderElementMgr()
		reMgr.SetElementsActive false
		rendSaveFile = false
		
		smtdsettings.SubmitAsDependent=false
		smtdsettings.SubmitAsSuspended=true
		smtdsettings.jobname = ((filenameFromPath rendOutputFilename)+ "_Prepass")
		smtdsettings.Priority = 98
		SetIrradiancePrepassPaths()
		
		renderers.current.options_dontRenderImage =  true
		--Set Preset from dialog
		renderers.current.gi_irradmap_preset = ddlIrradianceMapPreset.selection
		--Set Dont Render Final Image from Dialog
		----renderers.current.options_dontRenderImage =  chkDontRenderFinalImage.checked
		--Set Use Camera Path
		----renderers.current.lightcache_multipleViews = chkUseCameraPathPrepass.checked
		----renderers.current.gi_irradmap_multipleViews = chkUseCameraPathPrepass.checked
		--Set subdivs
		renderers.current.gi_irradmap_subdivs = spnSphSubdiv.value
		--Set mode to prepass
		renderers.current.adv_irradmap_mode = 6
		renderers.current.lightcache_mode = 0
		--Set Filenames
		renderers.current.adv_irradmap_dontDelete = true
		renderers.current.adv_irradmap_autoSave = true
		renderers.current.lightcache_autoSave = true
		
		smtdfunctions.SubmitJob()
		
		-----------------------------Submit Render----------------------------
		
		reMgr.SetElementsActive true
		
		--smtdsettings.SubmitAsDependent=true
		smtdsettings.SubmitAsSuspended=true
		--smtdfunctions.CollectJobs()
		--smtdsettings.DependencyJobItems = #{1}
		--smtdsettings.DependOnPreviousJob =false
		--smtdsettings.DependOnPreviousJobMode = #last
		smtdsettings.jobname = ((filenameFromPath rendOutputFilename)+ "_Render")
		
		rendSaveFile = true
		smtdsettings.Priority = spnRenderPrio.value
		smtdsettings.RenderFramesPreviewJob = true
		smtdsettings.PreviewJobPriorityOffset = spnRenderPrioPlus.value
		smtdsettings.PreviewJobFrameCount = 5
		
		SetIrradianceRenderPaths()
		
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
		
		-- Set Deadline to NOT FUCK WITH THE RENDER ELEMENT NAMES!
		smtdsettings.RenderElementsUpdatePaths = false
		smtdsettings.RenderElementsUpdateFilenames = false
		smtdsettings.RenderElementsPermanentChanges = false 
		smtdsettings.RebuildRenderElements = false
		
		--SubmitJobFromUI
		smtdfunctions.SubmitJobFromUI()
		renderSceneDialog.open()	
	)
	if (ddlRenderMode.selection == 3) do ( -- Prerendered Lightmap	
	
		renderSceneDialog.close()
		rendTimeType = 3
		rendStart   = abs (spnFrom.value)
		rendEnd 	= abs (spnTo.value)
		
		------------------------------Submit Prepass------------------------------
		smtdsettings.SubmitAsDependent=false
		smtdsettings.SubmitAsSuspended=true
		smtdsettings.jobname = ((filenameFromPath rendOutputFilename)+ "_Lightmap")
		smtdsettings.Priority = 100
		SetIrradiancePrepassPaths()
		
		renderers.current.options_dontRenderImage =  true
		--Set Preset from dialog
		renderers.current.gi_irradmap_preset = ddlIrradianceMapPreset.selection
		--Set Dont Render Final Image from Dialog
		----renderers.current.options_dontRenderImage =  chkDontRenderFinalImage.checked
		--Set Use Camera Path
		----renderers.current.lightcache_multipleViews = chkUseCameraPathPrepass.checked
		----renderers.current.gi_irradmap_multipleViews = chkUseCameraPathPrepass.checked
		--Set subdivs
		renderers.current.gi_irradmap_subdivs = spnSphSubdiv.value
		--Set mode to prepass
		renderers.current.adv_irradmap_mode = 1
		renderers.current.lightcache_mode = 1
		--Set Filenames
		renderers.current.adv_irradmap_dontDelete = true
		renderers.current.adv_irradmap_autoSave = true
		renderers.current.lightcache_autoSave = true

		smtdfunctions.submitJob()
		
		-----------------------------Submit Render----------------------------
		--smtdsettings.SubmitAsDependent=true
		smtdsettings.SubmitAsSuspended=true
		--smtdfunctions.CollectJobs()
		--smtdsettings.DependencyJobItems = #{1}
		--smtdsettings.DependOnPreviousJob =false
		--smtdsettings.DependOnPreviousJobMode = #last
		smtdsettings.jobname = ((filenameFromPath rendOutputFilename)+ "_Render")
		rendSaveFile = true
		smtdsettings.Priority = spnRenderPrio.value
		smtdsettings.RenderFramesPreviewJob = true
		smtdsettings.PreviewJobPriorityOffset = spnRenderPrioPlus.value
		smtdsettings.PreviewJobFrameCount = 5
		
		SetIrradianceRenderPaths()
		
		renderers.current.options_dontRenderImage =  false
		--Set Use Camera Path
		--renderers.current.lightcache_multipleViews = chkUseCameraPathPrepass.checked
		--renderers.current.gi_irradmap_multipleViews = chkUseCameraPathPrepass.checked
		--Set subdivs
		--renderers.current.gi_irradmap_subdivs = spnSphSubdiv.value
		--Set mode to prepass
		renderers.current.adv_irradmap_mode = 2
		renderers.current.lightcache_mode = 2
		--Set Interpolation Samples
		renderers.current.gi_irradmap_interpSamples = spnIntSamples.value
		renderers.current.gi_irradmap_interpFrames = spnIntFrames.value
		
		-- Set Deadline to NOT FUCK WITH THE RENDER ELEMENT NAMES!
		smtdsettings.RenderElementsUpdatePaths = false
		smtdsettings.RenderElementsUpdateFilenames = false
		smtdsettings.RenderElementsPermanentChanges = false 
		smtdsettings.RebuildRenderElements = false
		
		--SubmitJobFromUI
		smtdfunctions.SubmitJobFromUI()
		renderSceneDialog.open()	
	)
	
	if (ddlRenderMode.selection == 4) do ( -- Frame By Frame
		
		renderSceneDialog.close()
		rendTimeType = 3
		rendStart   = abs (spnFrom.value)
		rendEnd 	= abs (spnTo.value)
		
				-----------------------------Submit Render----------------------------
		--smtdsettings.SubmitAsDependent=true
		smtdsettings.SubmitAsSuspended=true
		--smtdfunctions.CollectJobs()
		--smtdsettings.DependencyJobItems = #{1}
		--smtdsettings.DependOnPreviousJob =false
		--smtdsettings.DependOnPreviousJobMode = #last
		smtdsettings.jobname = ((filenameFromPath rendOutputFilename)+ "_FrameByFrame")
		rendSaveFile = true
		smtdsettings.Priority = spnRenderPrio.value
		smtdsettings.RenderFramesPreviewJob = true
		smtdsettings.PreviewJobPriorityOffset = spnRenderPrioPlus.value
		smtdsettings.PreviewJobFrameCount = 5
		
		--SetIrradianceStuff
		renderers.current.options_dontRenderImage =  false
		renderers.current.adv_irradmap_mode = 0
		renderers.current.lightcache_mode = 0
		
		--Set Interpolation Samples
		renderers.current.gi_irradmap_interpSamples = spnIntSamples.value
		renderers.current.gi_irradmap_interpFrames = spnIntFrames.value
		
		--Enable Use Camera Paths
		renderers.current.lightcache_multipleViews = true
		renderers.current.gi_irradmap_multipleViews = true
		
		-- Set Deadline to NOT FUCK WITH THE RENDER ELEMENT NAMES!
		smtdsettings.RenderElementsUpdatePaths = false
		smtdsettings.RenderElementsUpdateFilenames = false
		smtdsettings.RenderElementsPermanentChanges = false 
		smtdsettings.RebuildRenderElements = false
		
		--SubmitJobFromUI
		smtdfunctions.SubmitJobFromUI()
		renderSceneDialog.open()	
		
	)
	
	if (ddlRenderMode.selection == 5) do ( -- No GI Animation
		
		renderSceneDialog.close()
		rendTimeType = 3
		rendStart   = abs (spnFrom.value)
		rendEnd 	= abs (spnTo.value)
		
				-----------------------------Submit Render----------------------------
		--smtdsettings.SubmitAsDependent=true
		smtdsettings.SubmitAsSuspended=false
		--smtdfunctions.CollectJobs()
		--smtdsettings.DependencyJobItems = #{1}
		--smtdsettings.DependOnPreviousJob =false
		--smtdsettings.DependOnPreviousJobMode = #last
		smtdsettings.jobname = ((filenameFromPath rendOutputFilename)+ "_NoGIRender")
		rendSaveFile = true
		smtdsettings.Priority = spnRenderPrio.value
		smtdsettings.RenderFramesPreviewJob = true
		smtdsettings.PreviewJobPriorityOffset = spnRenderPrioPlus.value
		smtdsettings.PreviewJobFrameCount = 5
		
		--GI OFF
		renderers.current.gi_on =  false
		
		-- Set Deadline to NOT FUCK WITH THE RENDER ELEMENT NAMES!
		smtdsettings.RenderElementsUpdatePaths = false
		smtdsettings.RenderElementsUpdateFilenames = false
		smtdsettings.RenderElementsPermanentChanges = false 
		smtdsettings.RebuildRenderElements = false
		
		--SubmitJobFromUI
		smtdfunctions.SubmitJobFromUI()
		renderSceneDialog.open()	
		
	)	
	--------------------------------------------Submit Procedure Done---------------------
	)
------
on lbxCameraList selected state do(
	obj = getnodebyname lbxCameraList.selected
	viewport.setcamera obj
	
	animationRange = (getCamRange obj)
	print lbxCameraList.selected
	
	spnFrom.value = (getCamRange obj).start.frame as integer
	spnTo.value = (getCamRange obj).end.frame as integer	
	)
	
  fn ddlRenderElementSets_Selected itm =--we pass the argument passed to the handler
  (
	if  (ddlRenderElementSets.selected == "Normal") do (
	  DeleteRenderElementsNormal()
	  DeleteRenderElementsFume()
	  CreateRenderElementsNormal()
	  SetRenderElementNames()
 	  GetRenderElementNames()
	)
	if  (ddlRenderElementSets.selected == "Fume") do (
	  DeleteRenderElementsNormal()
	  DeleteRenderElementsFume()
	  CreateRenderElementsFume()
	  SetRenderElementNames()
 	  GetRenderElementNames()
	)
  )

on ddlRenderElementSets selected selectionnumber do(
	ddlRenderElementSets_Selected selectionnumber
	)

on edtRenderOutputPath entered MyArg do(
	renderSceneDialog.close()
	rendOutputFilename = edtRenderOutputPath.text
	ddlRenderElementSets_Selected (ddlRenderElementSets.selection)
	renderSceneDialog.open()
	--SetRenderElementNames()
	--GetRenderElementNames()
	)

on lbxCameraList doubleClicked arg do(
	obj = getnodebyname lbxCameraList.selected
	viewport.setcamera obj
	
	animationRange = (getCamRange obj)
	print lbxCameraList.selected
	
	spnFrom.value = (getCamRange obj).start.frame as integer
	spnTo.value = (getCamRange obj).end.frame as integer		
	)
	
on rloVeronica open do(
	
	--Make Camera Array 
	MyCameraStringArray = #()
	for i=1 to cameras.count do ((append MyCameraStringArray (cameras[i].name as string) )) -- Add Cameras to Listbox
	lbxCameraList.items = MyCameraStringArray
	
	-- Get renderfile
	edtRenderOutputPath.text = rendOutputFilename
	
	--Refresh Render Elements
	SetRenderElementNames()
	GetRenderElementNames()
	
	--Assign Current Camera
	viewcam = viewport.getCamera()
	viewcam.name
	
	-- Select currently active Camera from the viewport
	for i = 1 to lbxCameraList.items.count do ( if lbxCameraList.items[i] == viewcam.name  do lbxCameraList.selection = i) 
	lbxCameraList.doubleClicked  lbxCameraList.selected
	
	--Select Normal Render element set by default
	ddlRenderElementSets_Selected (ddlRenderElementSets.selection = 1) 

	--obj = getnodebyname lbxCameraList.selected
	--viewport.setcamera obj
	rdoRenderDepth.changed 1  -- Change Render Depth to 1 so TGA is always default
	
	)
	
)
--getSavepath()
createdialog rloVeronica