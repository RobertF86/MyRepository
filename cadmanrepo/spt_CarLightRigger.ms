rollout rloCarLightRigger "Car Light Rigger" width:411 height:291
(
	button btnMerge "CREATE LIGHT RIG!" pos:[6,243] width:398 height:39
	dropDownList ddlVari "Variation" pos:[10,194] width:393 height:40 items:#("Default")
	bitmap bmp1 "Bitmap" pos:[5,7] width:400 height:180 fileName:@"\\srs01\3d\jarvis\CarLightRigger\headlights.jpg"

		
	on btnMerge pressed do(
		mergeMAXFile @"\\SRS01\3d\jarvis\CarLightRigger\Vari_A.max" #AutoRenameDups 
		)
		
)

createdialog rloCarLightRigger