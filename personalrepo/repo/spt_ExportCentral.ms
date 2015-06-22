
rollout ExportCentral "Export Central" width:800 height:600
(
	--Buttons
	button btnExport "Export" pos:[352,552] width:440 height:41	
	button btnGetForSale "Get 'forSale' path" pos:[431,3] width:92 height:16
	button btnGetMaxfilepath "Get maxfilepath" pos:[531,3] width:92 height:16
	button btnSanityCheck "SANITY CHECK!" pos:[352,507] width:440 height:41
	button btnGetTxtrMaps "Get txtr maps" pos:[389,334] width:111 height:18
	--button btnGetTxtrMapsAT "Get txtr maps from asset tracker" pos:[515,334] width:175 height:18
	button btnRefreshSelection "Refresh" pos:[91,3] width:112 height:14
	button btnAddToAll "All" pos:[568,113] width:15 height:16
	
	--Checkboxes
	checkbox chkExportFBX "Export FBX" pos:[353,47] width:100 height:18 checked:true
	checkbox chkExportOBJ "Export OBJ" pos:[353,68] width:100 height:18 checked:true
	checkbox chkExportAlembic "Export Alembic" pos:[353,90] width:100 height:18 checked:true
	checkbox chkExportMaxEleven "Export Max2011" pos:[353,112] width:100 height:18 checked:true
	checkbox chkExportMaxTwelve "Export Max2012" pos:[353,134] width:100 height:18 checked:true
	checkbox chkExportMaxThirteen "Export Max2013" pos:[353,156] width:100 height:18 checked:true
	checkbox chkExportMaxFourteen "Export Max2014" pos:[353,177] width:100 height:18 checked:true

	checkbox chkClearMatEditor "Clear Medit" pos:[510,335] width:72 height:18 checked:true
	checkbox chkClearEnvSlot "Clear Env" pos:[588,335] width:70 height:18 checked:true
	checkbox chkClearEffects "Clear Effects" pos:[660,335] width:80 height:18 checked:true

	checkbox chkZipFBX "Zip It" pos:[586,47] width:55 height:18 checked:false
	checkbox chkZipOBJ "Zip It" pos:[586,68] width:55 height:18 checked:false
	checkbox chkZipAlembic "Zip It" pos:[586,90] width:55 height:18 checked:false
	checkbox chkZipMaxEleven "Zip It" pos:[586,112] width:55 height:18 checked:true
	checkbox chkZipMaxTwelve "Zip It" pos:[586,134] width:55 height:18 checked:true
	checkbox chkZipMaxThirteen "Zip It" pos:[586,156] width:55 height:18 checked:true
	checkbox chkZipMaxFourteen "Zip It" pos:[586,178] width:55 height:18 checked:true
	
	checkbox chkFBXWithTextures "With selected textures" pos:[649,47] width:200 height:18 checked:false
	checkbox chkOBJWithTextures "With selected textures" pos:[649,68] width:200 height:18 checked:false
	checkbox chkAlembicWithTextures "With selected textures" pos:[649,90] width:200 height:18 checked:false
	checkbox chkMaxElevenWithTextures "With selected textures" pos:[649,112] width:200 height:18 checked:true
	checkbox chkMaxTwelveWithTextures "With selected textures" pos:[649,134] width:200 height:18 checked:true
	checkbox chkMaxThirteenWithTextures "With selected textures" pos:[649,156] width:200 height:18 checked:true
	checkbox chkMaxFourteenWithTextures "With selected textures" pos:[650,178] width:200 height:18 checked:true

	--Textboxes
	editText edtExportPath "" pos:[347,23] width:448 height:18
	
	editText edtAddTagFBX "Add Tag" pos:[460,47] width:105 height:18
	editText edtAddTagObj "Add Tag" pos:[460,68] width:105 height:18
	editText edtAddTagAlembic "Add Tag" pos:[460,90] width:105 height:18
	editText edtAddTagMaxEleven "Add Tag" pos:[460,112] width:105 height:18 text:"Vray"
	editText edtAddTagMaxTwelve "Add Tag" pos:[460,134] width:105 height:18 text:"Vray"
	editText edtAddTagMaxThirteen "Add Tag" pos:[460,156] width:105 height:18 text:"Vray"
	editText edtAddTagMaxFourteen "Add Tag" pos:[460,177] width:105 height:18 text:"Vray"	 
	
	--Listboxes
	listBox lbxSelectedObjects "" pos:[2,21] width:341 height:44 items:(for i in selection collect i.name) 
	MultiListBox lbxMaps "" pos:[352,355] width:439 height:11
	
	--Lables
	label lblExportPath "Export Path :" pos:[352,3] width:68 height:17
	label lbl3 "Maps :" pos:[354,335] width:35 height:14
	label lblSelectedObjects "SelectedObjects:" pos:[4,2] width:88 height:15
	
	--functions
	fn OverwriteGWObjConfig =(
		local version = (maxVersion())[1];
		if version == 11000 then( -- max 2009 only
			
			fn fnWriteBinary dataFile data =(
				local d = fopen dataFile "wb"
				for i in data do(
					WriteByte d i
				)
				FClose  d;
			)
			
			local inputCfgPath = ((getDir #plugcfg) + "\\"+"gw_objimp.cfg")
			local outputCfgPath =  ((getDir #plugcfg) + "\\"+"gw_objexp.cfg")
			fnWriteBinary inputCfgPath #(5, 0, 0, 0, 39, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, -128, 63, 2, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 11, 0, 0, 0, 0, 0, 0, 0)
			fnWriteBinary outputCfgPath #(16, 0, 0, 0, 86, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -128, 63, 0, 0, 1, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 46, 47, 109, 97, 112, 115, 47, 0, 1, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 3, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 60, 78, 79, 78, 69, 62)
			
		)else if version >= 12000 then( -- max 2010
			local iniPath_exportSettings = objExp.getIniName()
			setINISetting iniPath_exportSettings "Geometry" "FlipZyAxis" "1"
			setINISetting iniPath_exportSettings "Geometry" "Shapes" "0"
			setINISetting iniPath_exportSettings "Geometry" "ExportHiddenObjects" "0"
			setINISetting iniPath_exportSettings "Geometry" "FaceType" "1"--quads
			setINISetting iniPath_exportSettings "Geometry" "TextureCoords" "1"
			setINISetting iniPath_exportSettings "Geometry" "Normals" "1"
			setINISetting iniPath_exportSettings "Geometry" "SmoothingGroups" "1"
			setINISetting iniPath_exportSettings "Geometry" "ObjScale" "1.000000"
			
			setINISetting iniPath_exportSettings "Output" "RelativeIndex" "1"
			setINISetting iniPath_exportSettings "Output" "Target" "0"
			setINISetting iniPath_exportSettings "Output" "Precision" "6"
			
			--new discovered settings by copypastepixel that are important for roadkill,see:
			--http://boards.polycount.net/showpost.php?p=1115492&postcount=16
			setINISetting iniPath_exportSettings "Optimize" "optVertex" "0"
			setINISetting iniPath_exportSettings "Optimize" "optNormals" "0"
			setINISetting iniPath_exportSettings "Optimize" "optTextureCoords" "0"
		)
	)
	
	--Events
	on btnAddToAll pressed do
		(
		ExtraTag 					= edtAddTagMaxEleven.text	 
		--edtAddTagFBX.text			= ExtraTag
		--edtAddTagObj.text			= ExtraTag
		--edtAddTagAlembic.text 		= ExtraTag
		edtAddTagMaxEleven.text		= ExtraTag
		edtAddTagMaxTwelve.text		= ExtraTag
		edtAddTagMaxThirteen.text	= ExtraTag
		edtAddTagMaxFourteen.text	= ExtraTag
		)
	on btnRefreshSelection pressed do
		(
			lbxSelectedObjects.items = (for i in selection collect i.name)
		)
	on btnGetForSale pressed do
		(
			PathArray = #()
			PathArray = (filterstring maxfilepath "\\")
			
			if ((PathArray[PathArray.count]) == "mdl") do
				(
					PathArray[PathArray.count] = "out"
					append PathArray "ForSale"
				)	
		
		edtExportPath.text = (pGlobalFunctions.AssemblePathFromArray PathArray)
		)
	on btnGetTxtrMaps pressed do 
		(
			PathArray = #()
			TxtrFileNameArray= #()
			PathArray = (filterstring maxfilepath "\\")
			
			if ((PathArray[PathArray.count]) == "mdl") do
				(
					PathArray[PathArray.count] = "txtr"
				)	
			
			TxtrFileNameArray = getFiles ((pGlobalFunctions.AssemblePathFromArray Patharray) + "*.*")
			lbxMaps.items = (for i in TxtrFileNameArray collect (filterstring i "\\")[(filterstring i "\\").count])
		)
	on btnGetMaxfilepath pressed do
		(
			edtExportPath.text = maxfilepath
		)
	on exportCentral open do
		(
		--Fill ExportPath with "for Sale" path
		ExportCentral.btnGetForSale.pressed()
		ExportCentral.btnRefreshSelection.pressed()
		ExportCentral.btnGetTxtrMaps.pressed()
		)
	--SANITY CHECK!
	on btnSanityCheck pressed do
		(
		pGlobalFunctions.DoSanityCheck()
		)
		
	--EXPORT COMMAND
	on btnExport pressed do
	(
	
	--clear medit if wanted
		if chkClearMatEditor.checked == true do(
			for i in 1 to 24 do
				(
				local theName = (if i<10 then "0" else "") + (i as string) + " - Default"
				meditmaterials[i]=standardMaterial name:theName
				)--end for
			)

		--clear env Slot if wanted			
		if chkClearEnvSlot.checked == true do(
			environmentMap = undefined
			viewport.DispBkgImage  = false
			viewport.EnableSolidBackgroundColorMode true
			InvalidateAllBackgrounds() 
			completeredraw()
			)
			
		--clear effects... Deleted for now because or RPmanager needing effets to store data
		--if chkClearEffects.checked == true do(
		--		for i=1 to 10 do(
		--			try deleteEffect 1 catch()
		--		)
		--	)
		
	ArrFileNames = #()
	MapFileNames = #()
	
	--Collecting Selected Maps
		--get "txtr" directory
		PathArray = #()
		PathArray = (filterstring maxfilepath "\\")
		PathArray[PathArray.count] = "txtr"
		txtrPath = pGlobalFunctions.AssemblePathFromArray  PathArray
		
		for map in lbxMaps.selection do 
		(	
			append MapFileNames ((txtrPath) + lbxMaps.items[map])
		)
		
		
	FileNameNoExtention  = (filterstring maxFileName ".")[1]
	MyNodesToExport = (selection as array)

		--Append Filenames to Array and Export to Files
		--max2011
	if (chkExportMaxEleven.checked) 	do 
		(
		--SaveMaxfile
		maxElevenFilename = (edtExportPath.text + FileNameNoExtention as string +"_"+ edtAddTagMaxEleven.text   + "_max2011" + ".max")
		append ArrFileNames maxElevenFilename
		saveNodes MyNodesToExport maxElevenFilename  saveAsVersion:2011 quiet:true
		--Zipping Stuff
		if (chkZipMaxEleven.checked) do
			(	
				--Add Files
				FileNameNoExtention  = (filterstring maxFileName ".")[1]
				ArchiveName = ((edtExportPath.text + FileNameNoExtention as string +"_"+ edtAddTagMaxEleven.text + "_max2011" + ".zip"))
				pGlobalFunctions.AddFileToArchive ArchiveName maxElevenFilename
			)
		--Add Maps
		if (chkMaxElevenWithTextures.checked) do 
			(
				for i in MapFileNames do
				(
					pGlobalFunctions.AddFileToArchive ArchiveName i	
				)
			)
		)
		--max2012
	if (chkExportMaxTwelve.checked) 	do 
		(
		--Save Max file
		maxTwelveFilename = (edtExportPath.text + FileNameNoExtention as string +"_"+ edtAddTagMaxTwelve.text   + "_max2012" + ".max")
		append ArrFileNames maxTwelveFilename
		saveNodes MyNodesToExport maxTwelveFilename  saveAsVersion:2012 quiet:true
		--Zipping Stuff
		if (chkZipMaxTwelve.checked) do
			(	
				--Add Files
				FileNameNoExtention  = (filterstring maxFileName ".")[1]
				ArchiveName = ((edtExportPath.text + FileNameNoExtention as string +"_"+ edtAddTagMaxTwelve.text + "_max2012" + ".zip"))
				pGlobalFunctions.AddFileToArchive ArchiveName maxTwelveFilename
			)
		--Add Maps
		if (chkMaxTwelveWithTextures.checked) do 
			(
				for i in MapFileNames do
				(
					pGlobalFunctions.AddFileToArchive ArchiveName i	
				)
			)
		)
		--max2013
	if (chkExportMaxThirteen.checked) 	do 
		(
		maxThirteenFilename = (edtExportPath.text + FileNameNoExtention as string +"_"+ edtAddTagMaxThirteen.text + "_max2013" + ".max")
		append ArrFileNames maxThirteenFilename
		(saveNodes MyNodesToExport maxThirteenFilename  saveAsVersion:2013 quiet:true)
			
		--Zipping Stuff
		if (chkZipMaxThirteen.checked) do
			(	
				--Add Files
				FileNameNoExtention  = (filterstring maxFileName ".")[1]
				ArchiveName = ((edtExportPath.text + FileNameNoExtention as string +"_"+ edtAddTagMaxThirteen.text + "_max2013" + ".zip"))
				pGlobalFunctions.AddFileToArchive ArchiveName maxThirteenFilename
			)
		--Add Maps
		if (chkMaxThirteenWithTextures.checked) do 
			(
				for i in MapFileNames do
				(
					pGlobalFunctions.AddFileToArchive ArchiveName i	
				)
			)
		)
		--max2014
	if (chkExportMaxFourteen.checked) 	do 
		(
		maxfourteenFilename = (edtExportPath.text + FileNameNoExtention as string +"_"+ edtAddTagMaxFourteen.text + "_max2014" + ".max")
		append ArrFileNames maxfourteenFilename
		(saveNodes MyNodesToExport maxfourteenFilename  quiet:true)
		--Zipping Stuff
		if (chkZipMaxFourteen.checked) do
			(	
				--Add Files
				FileNameNoExtention  = (filterstring maxFileName ".")[1]
				ArchiveName = ((edtExportPath.text + FileNameNoExtention as string +"_"+ edtAddTagMaxFourteen.text + "_max2014" + ".zip"))
				pGlobalFunctions.AddFileToArchive ArchiveName maxfourteenFilename
			)
		--Add Maps
		if (chkMaxFourteenWithTextures.checked) do 
			(
				for i in MapFileNames do
				(
					pGlobalFunctions.AddFileToArchive ArchiveName i	
				)
			)
		)
		--Export non max files
		--FBX
	if (chkExportFBX.checked) 			do 
		(
			FBXFilename = (edtExportPath.text + FileNameNoExtention as string +"_"+ edtAddTagFBX.text + "_FBX_" + ".fbx")
			append ArrFileNames FBXFilename
			(exportFile FBXFilename #noprompt selectedOnly:true using:FBXEXP)
		--Zipping Stuff
		if (chkZipFBX.checked) do
			(	
				--Add Files
				FileNameNoExtention  = (filterstring maxFileName ".")[1]
				ArchiveName = ((edtExportPath.text + FileNameNoExtention as string +"_"+ edtAddTagFBX.text + "_FBX" + ".zip"))
				pGlobalFunctions.AddFileToArchive ArchiveName FBXFilename
			)
		--Add Maps
		if (chkFBXWithTextures.checked) do 
			(
				for i in MapFileNames do
				(
					pGlobalFunctions.AddFileToArchive ArchiveName i	
				)
			)
		)  
		--OBJ
	if (chkExportOBJ.checked) 			do 
		(
		OBJFilename = (edtExportPath.text + FileNameNoExtention as string +"_"+ edtAddTagObj.text 		+ "_OBJ_" + ".obj")
		append ArrFileNames OBJFilename
		OverwriteGWObjConfig()
		(exportFile OBJFilename #noprompt selectedOnly:true using:ObjExp)
		--Zipping Stuff
		if (chkZipOBJ.checked) do
			(	
				--Add Files
				FileNameNoExtention  = (filterstring maxFileName ".")[1]
				ArchiveName = ((edtExportPath.text + FileNameNoExtention as string +"_"+ edtAddTagObj.text + "_OBJ" + ".zip"))
				pGlobalFunctions.AddFileToArchive ArchiveName OBJFilename
			)
		--Add Maps
		if (chkOBJWithTextures.checked) do 
			(
				for i in MapFileNames do
				(
					pGlobalFunctions.AddFileToArchive ArchiveName i	
				)
			)
		)  
		--Alembic
	if (chkExportAlembic.checked) 		do 
		(
		AlembicFilename = (edtExportPath.text + FileNameNoExtention as string +"_"+ edtAddTagAlembic.text 	+ "_Alembic_" + ".abc")
		append ArrFileNames AlembicFilename
		(exportFile AlembicFilename #noprompt selectedOnly:true using:abcexp)
		--Zipping Stuff
		if (chkZipAlembic.checked) do
			(	
				--Add Files
				FileNameNoExtention  = (filterstring maxFileName ".")[1]
				ArchiveName = ((edtExportPath.text + FileNameNoExtention as string +"_"+ edtAddTagAlembic.text + "_Alembic" + ".zip"))
				pGlobalFunctions.AddFileToArchive ArchiveName AlembicFilename
			)
		--Add Maps
		if (chkAlembicWithTextures.checked) do 
			(
				for i in MapFileNames do
				(
					pGlobalFunctions.AddFileToArchive ArchiveName i	
				)
			)
		)		
	) 
)

createdialog ExportCentral