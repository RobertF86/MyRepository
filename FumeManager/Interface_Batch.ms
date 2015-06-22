rollout unnamedRollout "Untitled" width:970 height:640
(
	groupBox grpCopy "Cache file management" pos:[8,304] width:944 height:232
	editText edtLocalCacheFiles "" pos:[104,330] width:752 height:18
	editText edtOnlineCacheFiles "" pos:[104,432] width:752 height:18
	label lblLocalCaches "Local Cache Files" pos:[18,330] width:88 height:16
	label lbl2 "Online Cache Files" pos:[16,432] width:88 height:16
	radioButtons rdoCopyMode "Copy Mode" pos:[256,168] width:180 height:46 labels:#(Robocopy (Fast,Reccomended), Max Copy (Slow,Secure))
	button btnGetLocalCachePath "Get Current" pos:[864,328] width:80 height:24
	checkbox chkSimDefault "Simulate Default Caches" pos:[12,31] width:168 height:16
	checkbox chkSimWavelet "Simulate Wavelet Caches" pos:[12,63] width:168 height:16
	checkbox chkSimPost "Simulate Post Caches" pos:[12,95] width:168 height:16
	radioButtons rdoSetCacheAfterSim "" pos:[600,24] width:69 height:48 labels:#(Default, Wavelet, Post)
	checkbox chkCopyCaches "Copy Caches After Simming" pos:[12,160] width:168 height:16
	groupBox grpStuffToBatch "Stuff To Batch" pos:[7,8] width:177 height:280
	groupBox grpRangeReset "Reset Range Before Sim" pos:[192,8] width:288 height:136
	button btnSim "SIM" pos:[8,576] width:944 height:56
	checkbox chkSetLocalCaches "Set Local caches before sim" pos:[12,128] width:168 height:16
	checkbox chkSetOnlineCaches "Set online caches after sim" pos:[12,191] width:168 height:16
	groupBox grpActiveCacheAfterSimming "Active Cache After Simming" pos:[488,8] width:224 height:72
	groupBox grpSpeedup "Speedup" pos:[488,88] width:224 height:136
	checkButton ckbActiveCacheAfterSimming "Enable" pos:[496,24] width:48 height:48
	checkButton ckbEnableSpeedup "Enable" pos:[496,104] width:48 height:112
	checkbox chkDisableUndoRecording "Disable Undo Recording" pos:[552,104] width:152 height:16
	checkbox chkDisableViewportRedraw "Disable Viewport Redraw" pos:[552,120] width:152 height:16
	checkbox chkPerformGarbageCollection "Perform Garbage Collection" pos:[552,136] width:152 height:16
	checkbox chkDontShowPreviewWindow "Don't show Preview Window" pos:[552,152] width:152 height:16
	groupBox grpViewportPropertiesAfterSimming "Viewport Properties After Simming" pos:[720,8] width:232 height:216
	groupBox grpSimFromInitialState "Sim From Initial State" pos:[192,224] width:760 height:72
	checkButton ckbEnableViewportProperties "Enable" pos:[728,24] width:48 height:192
	checkButton ckbEnableViewportDisplay "Enable Viewport Display" pos:[784,24] width:128 height:24
	checkButton ckbEnableViewportDisplayPlus "+" pos:[912,24] width:24 height:24
	spinner spnReduce "" pos:[856,56] width:80 height:16
	label lblReduce "Reduce:" pos:[792,56] width:56 height:16
	checkbox chkFuel "Fuel" pos:[792,80] width:64 height:16
	checkbox chkFire "Fire" pos:[792,96] width:64 height:16
	checkbox chkSmoke "Smoke" pos:[792,112] width:64 height:16
	checkbox chkVelo "Velocities" pos:[792,128] width:64 height:16
	checkbox chkForces "Forces" pos:[792,144] width:64 height:16
	checkbox chkTurbulence "Turbulence" pos:[792,160] width:88 height:16
	checkbox chkTemperature "Temperature" pos:[792,176] width:80 height:16
	checkbox chkActiveGrid "Adaptive Grid" pos:[792,192] width:88 height:16
	editText edtLocalCacheFilesWavelet "" pos:[136,376] width:720 height:18 enabled:false
	editText edtLocalCacheFilesDefault "" pos:[136,352] width:720 height:18 enabled:false
	editText edtOnlineCacheFilesDefault "" pos:[136,456] width:720 height:18 enabled:false
	editText edtOnlineCacheFilesWavelet "" pos:[136,480] width:720 height:18 enabled:false
	editText edtLocalCacheFilesRetimer "" pos:[136,400] width:720 height:18 enabled:false
	groupBox grpCopyMethod "Copy Method" pos:[192,152] width:288 height:72
	checkButton ckbEnableCopyMethod "Enable" pos:[200,168] width:48 height:48
	checkButton ckbEnableResetRange "Enable" pos:[200,24] width:48 height:112
	checkButton ckbEnableInitialState "Enable" pos:[200,240] width:48 height:48
	editText edtInitialState "" pos:[296,256] width:648 height:18
	button btnGetInitialState "..." pos:[256,256] width:32 height:16
	editText edtOnlineCacheFilesRetimer "" pos:[136,504] width:720 height:18 enabled:false
	label lblLocalCacheFilesDefault "Default Cache" pos:[64,352] width:72 height:16
	label lblLocalCacheFilesWavelet "Wavelet Cache" pos:[56,376] width:80 height:16
	label lblLocalCacheFilesRetimer "Retimer Cache" pos:[64,400] width:72 height:16
	label lblOnlineCacheFilesDefault "Default Cache" pos:[64,456] width:72 height:16
	label lblOnlineCacheFilesWavelet "Wavelet Cache" pos:[56,480] width:80 height:16
	label lblOnlineCacheFilesRetimer "Retimer Cache" pos:[64,504] width:72 height:16
	spinner spnStartFrame "" pos:[350,24] width:90 height:16
	label lblStartFrame "Start Frame" pos:[272,24] width:64 height:16
	label lblEndFrame "End Frame" pos:[280,40] width:56 height:16
	label lblPlayFrom "Play From" pos:[288,64] width:48 height:16
	label lblPlayTo "Play To" pos:[296,80] width:40 height:16
	label lblPlayStart "Play Start" pos:[288,96] width:48 height:16
	label lblViewportUpdate "Viewport Update" pos:[256,120] width:80 height:16
	spinner spnEndFrame "" pos:[350,40] width:90 height:16 range:????
	spinner spnPlayFrom "" pos:[350,64] width:90 height:16 range:????
	spinner spnPlayTo "" pos:[350,80] width:90 height:16 range:????
	spinner spnPlayStart "" pos:[350,96] width:90 height:16 range:????
	spinner spnViewportUpdate "" pos:[350,120] width:90 height:16 range:????
	button btnGetRange "Get" pos:[448,24] width:24 height:112
	button btnGetViewportProperties "Get" pos:[912,80] width:24 height:128
)