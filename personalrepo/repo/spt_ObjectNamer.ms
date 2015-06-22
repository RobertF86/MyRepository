rollout assetNamer "AssetNamer... Please enter a name for your object..." width:464 height:96
(
	editText edtName "" pos:[8,12] width:352 height:18
	button btnNameObject "Name Selection" pos:[368,8] width:88 height:24
	editText edtResultingName "" pos:[8,72] width:448 height:18  bold:true readOnly:true 
 	label lblResultingName "Resulting Name:" pos:[16,56] width:120 height:16
	
	on assetNamer open do(
			if (selection.count == 1) then(
				edtResultingName.text = pGlobalFunctions.GetAssetNameFromCurrMaxFile() + "_"
			)
			else (
				messageBox "Please select something before you execute the script"
				DestroyDialog assetNamer
				)
		)
		
		on edtName changed mytext do(
			edtResultingName.text = pGlobalFunctions.GetAssetNameFromCurrMaxFile() + "_" + edtName.text + "_"
			)
		
		on btnNameObject pressed do(
				$.name = edtResultingName.text + "0001"
				messagebox ("Object is now called : " + edtResultingName.text)
			
			)
)

createdialog assetNamer