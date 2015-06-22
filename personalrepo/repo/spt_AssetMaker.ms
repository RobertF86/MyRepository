rollout AssetCreator "Asset Creator" width:448 height:278
(
	editText edtAssetName "" pos:[98,26] width:335 height:17 text:"RND"
	editText edtMessageWindow "" pos:[8,80] width:432 height:190 enabled:true readOnly:true
	label lblAssetName "Asset Name" pos:[103,6] width:110 height:15
	checkbox chkOpenOnCreation "Open Asset on creation" pos:[102,55] width:150 height:17
	--checkbox chkLeaveAssetCreatorOpen "Keep Asset Creator Open" pos:[300,55] width:200 height:17
	button btnCreate "Create" pos:[7,52] width:89 height:22
	dropDownList ddlAssetType "Asset type" pos:[5,6] width:88 height:40 items:#("BLD","PLT","PRP","VEH","CHR","ENV","EFX","GEN","DEV","SET","TTB","SCN")
	global AssetPathAndName = ""
	global AssetName = ""
	
	on AssetCreator open do
	(
	edtMessageWindow.text 	=  "Library initialized..... \n"
	edtMessageWindow.text +=   "Asset Directory found : " + pPaths.assetDir + "\n"	
	edtMessageWindow.text +=  "Welcome to asset creator.....\n"
	edtMessageWindow.text +=	"Please enter type and name of the asset\n"
	)

	on btnCreate pressed do
	(
		AssetPathAndName = pPaths.assetDir + "\\" + ddlAssetType.selected + "_" + edtAssetName.text as string
		AssetName= ddlAssetType.selected + "_" + edtAssetName.text as string
		
			if (edtAssetName.text != "" AND (doesFileExist (AssetPathAndName + "\\mdl\\" + AssetName + "_v0001.max" )) == false) then(
				
				edtMessageWindow.text +=	"Path of new asset is : " + AssetPathAndName + "\n"
				edtMessageWindow.text +=	"Creating Folders...\n"
				
				--Copy folder structure
				HiddenDOSCommand  ("xcopy " +	"\"" + pPaths.AssetFolderTemplateDir +	"\"" + " " +  "\"" + AssetPathAndName + "\"" +  "/E" + "/I") startpath:"C:\\"	donotwait:false
				edtMessageWindow.text +=	"Done...\n"
					
				--Create initial Max file
				edtMessageWindow.text +=	"Creating initial max file...\n"
				copyFile (pPaths.PipelineDir + "\\Maxstart\\maxstart_2014.max") (AssetPathAndName + "\\mdl\\" + AssetName + "_v0001.max" )
				--miau = (AssetPathAndName + "\\mdl\\" + AssetName + "_v0001.max" )
				
				edtMessageWindow.text +=	"Done...\n"
				edtMessageWindow.text +=	"Path to max file is : "	+ (AssetPathAndName + "\\mdl\\" + AssetName + "_v0001.max" ) as string
					
				if (edtAssetName.text != "") do edtAssetName.text = ""
				if (chkOpenOnCreation.checked == true) do loadMaxFile (AssetPathAndName + "\\mdl\\" + AssetName + "_v0001.max" ) as string
			)
			else (
				 if (edtAssetName.text == "" ) do messagebox "Please provide an asset name"
				 if (doesFileExist (AssetPathAndName + "\\mdl\\" + AssetName + "_v0001.max" ) == true) do messagebox "Asset Already Created"
			)
		
	)
)

Createdialog AssetCreator