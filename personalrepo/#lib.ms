(
print "INCLUDING STUFF!"
print "......................................................."
struct Struct_pPaths
			(
				Mari,
				ScriptRepo,
				AssetDir,
				PipelineDir,
				PshopTemplateDir,
				AssetFolderTemplateDir ,
				BitmapLoadersMatLibraryPath,
				GlobalResArray	,
				PhotoshopExecutable,
				IrfanViewExecutable,
				SevenZipCommandline,

				
				fn init =
				(
					-- initialize Values
					ScriptRepo 								= @"Z:\pipeline\Maxscripts\repo"
					AssetDir									= @"Z:\assets"
					PipelineDir								= @"Z:\pipeline"
					PshopTemplateDir 					= PipelineDir + "\\PshopTemplateFiles"
					AssetFolderTemplateDir 			= PipelineDir + "\\#XXX_ASSETFOLDERTEMPLATE"
					BitmapLoadersMatLibraryPath   	= PipelineDir + "\\MatLibs\\BitmapLoaders.mat"
					GlobalResArray							=	#("64","256","512","1K","2K","4K","8K","16K")
					PhotoshopExecutable				= @"C:\Program Files\Adobe\Adobe Photoshop CS6 (64 Bit)\Photoshop.exe"
					Mari										= @"C:\Program Files\Mari2.6v4\Bundle\bin\Mari2.6v4.exe"
					IrfanViewExecutable					= @"C:\Program Files (x86)\IrfanView\i_view32.exe"
					SevenZipCommandline				= @"Z:\pipeline\software\sevenzipcommandline\7za.exe"
				)
			)
global pPaths = Struct_pPaths()
pPaths.init()

struct Struct_pGlobalFunctions
(	-- AssemblePathFromArray reassembles the elements of an array to a "path string" 
	-- Usefull when you used the filterstring() function on a path 
	-- Returns a string with the reassembled path
	fn AssemblePathFromArray arr = (
		try(
			AssembledPath = ""

				for i = 1 to arr.count do(
						AssembledPath += arr[i] + "\\"  
					)
				AssembledPath
			)
			catch(false)
	),

	fn AssemblePathFromArrayDoubleSlashes arr = (
		try(
			AssembledPath = ""

				for i = 1 to arr.count do(
						AssembledPath += arr[i] + "\\\\"  
					)
				AssembledPath
			)
			catch(false)
	),
	
	 fn GetAssetPathFromCurrMaxFile = (
			MaxFilePathAsArr = filterstring maxFilePath "\\"
			AssetPathAsArr = deleteItem MaxFilePathAsArr MaxFilePathAsArr.count
			--AssemblePathFromArray AssetPathAsArr
			AssembledPath = ""

				for i = 1 to AssetPathAsArr.count do(
						AssembledPath += AssetPathAsArr[i] + "\\"  
					)
				AssembledPath
		),

	 fn GetAssetNameFromCurrMaxFile = (
		assetName = (filterstring maxfilename "_")[1] + "_" +(filterstring maxfilename "_")[2] 
		assetName
		),
		
	 fn ConvertTextureSizeString Res = (
		if (Res == "1K") do 		(	Res = pow 2 10 as integer)
		if (Res == "2K") do 		(	Res = pow 2 11 as integer)	
		if (Res == "4K") do 		(	Res = pow 2 12 as integer)
		if (Res == "8K") do 		(	Res = pow 2 13 as integer)
		if (Res == "16K") do 	(	Res = pow 2 14 as integer)
		Res
		),
		
	fn GenMultiResTexture FilePathAndName = (
		greycase = false
		LocalResArray = #()
		BitmapWidth = (getBitmapInfo FilePathAndName)[3] as integer
		
		
		for res in GlobalResArray do (
			if  (BitmapWidth as integer >= (ConvertTextureSizeString res) as integer) do append LocalResArray res
		)
		
			for res in LocalResArray do (
				NewFileName = replace FilePathAndName ( findString FilePathAndName "_os_" ) 4 ("_" + res + "_")
				print newFileName
				
				print ((filterstring newFileName "_")[((filterstring newFileName "_").count - 2)]) -- Getting type value (dif spc bmp ect.)
				if ( ((filterstring newFileName "_")[((filterstring newFileName "_").count - 2)]) == "dif") then (
					
					MyDoscommand = "\"" + IrfanViewExecutable + "\"" + " " + "\"" + FilePathAndName + "\"" + " /resize=(" + (ConvertTextureSizeString res) as string + ",) /aspectratio /convert=" + "\"" + NewFileName + "\"" 
					
					)
					
				else (
					greycase = true
							MyDoscommand = "\"" + IrfanViewExecutable + "\"" + " " + "\"" + FilePathAndName + "\"" + " /resize=(" + (ConvertTextureSizeString res) as string + ",) /aspectratio /gray /convert=" + "\"" + NewFileName + "\"" 
					)
					
				MyDoscommand = MyDoscommand + " "
				print MyDoscommand
				HiddenDOSCommand  MyDoscommand --donotwait:false
			)
			
			if ( greycase = true) do (
				MyDoscommand = "\"" + IrfanViewExecutable + "\"" + " " + "\"" + FilePathAndName + "\"" + " /resize=(" + (BitmapWidth) as string + ",) /aspectratio /gray /convert=" + "\"" + FilePathAndName + "\""
				MyDoscommand = MyDoscommand + " "
				print MyDoscommand
				HiddenDOSCommand MyDoscommand
			)
	),
	
	fn AddFileToArchive ArchiveName FileToAdd = (
		
	SevenZipMode = " a " --Add To Archive
	SevenZipArchiveType = "-tzip " --ArchiveType = zip
	SevenZipArchiveName = "\"" + ArchiveName + "\""  + " "
	SevenZipFileToAdd = "\"" + FileToAdd + "\""
	SevenZipCompressionLevel = " -mx9" --Highest Compression Level --mx0 no compression mx9 hightest compresseion


	FullDosCommand = ("\"" + pPaths.SevenZipCommandline + "\"" + SevenZipMode + SevenZipArchiveType + SevenZipArchiveName + SevenZipFileToAdd + SevenZipCompressionLevel)
	print ("Here Is the Full Dos Command: " + FullDosCommand as string) 

	hiddendoscommand  FullDosCommand downwait:true prompt:("Zipping:: " +  FileToAdd as string)
	
	),
	
	fn DoSanityCheck = (
		--Querying stuff	
		if (querybox "Are you sure you want to export the listed objects? Did you use object namer?") != true do return false
		if (querybox "Did you name all your Layers corretly?") != true do return false
		if (querybox "Did you strip all texture paths?") != true do return false
		if (querybox "Do you have subdivisions applied to all objects?") != true do return false		
		if (querybox "Does the model open in the same pose, angle and framing as the first preview image?") != true do return false		
		if (querybox "Did you add the HDRI image to the txtr directory in order have it in the zip file?") != true do return false
		if (querybox "Did you set the render output to single frame?") != true do return false
		if (querybox "Did you name all materials and maps accordingly to the convention?") != true do return false
		if (querybox "Did you upload the turntable in a COUNTERCLOCKWISE direction without uploading the last frame?") != true do return false
		if (querybox "Did you render wireframe images without the background, just the model?") != true do return false
		if (querybox "Please set the viewport background back to Gradient") != true do return false
		return true
	)
)

global pGlobalFunctions = Struct_pGlobalFunctions

Print "DONE"
)