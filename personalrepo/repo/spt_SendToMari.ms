if (selection.count != 0) then
(
	PythonScript = stringStream ""
	AssetPath = ""
	ProjectName = ""
	--if( (doesFileExist @"C:\temp\CreateMariAsset.py") == false) do createFile @"C:\temp\CreateMariAsset.py"
	MyFileStream = openFile @"C:\temp\CreateMariAsset.py" mode:"w"

	--ExportABCFileForMari
	--Generate ExportPath And filename
	ExportFilePathArray = (filterstring (maxfilepath ) "\\")
	ExportFilePathArray[4] = "exp"
	ExportPath = pGlobalFunctions.AssemblePathFromArrayDoubleSlashes ExportFilePathArray
	AlembicFilename = (filterstring maxfilename "_")[1] + "_" + (filterstring maxfilename "_")[2] + "_Alembic_"+(filterstring (filterstring maxfilename "_")[3] ".")[1] +".abc"
	--ActualExport Command
	print (ExportPath + AlembicFilename)
	exportFile (ExportPath + AlembicFilename) #noprompt selectedOnly:true using:abcexp
	
	--Set Variables
	AssetPath = ExportPath + AlembicFilename
	ProjectName = (filterstring maxfilename "_")[1] +"_"+ (filterstring maxfilename "_")[2]
	--AssembleScript
	format "from PySide.QtGui import QFileDialog\n" to:MyFileStream
	format "import os\n" to:MyFileStream
	format "import mari\n" to:MyFileStream
	format "def createBasic():\n" to:MyFileStream
	format "	mari.projects.close()\n" to:MyFileStream
	format ("	obj_name = " + "\"" + AssetPath + "\"\n") to:MyFileStream
	format "	if type(obj_name) is tuple and len(obj_name)>0:\n" to:MyFileStream
	format "		obj_name = obj_name[0]\n" to:MyFileStream
	format "	if os.path.exists(obj_name):\n" to:MyFileStream
	format ("		mari.projects.create(" + "\"" + ProjectName	+ "\"" + "," + "\n") to:MyFileStream
	format "							obj_name,\n" to:MyFileStream
	format "							[mari.ChannelInfo('dif', 4096, 4096, 8, False, mari.Color(0.5, 0.5, 0.5)),\n" to:MyFileStream
	format "							mari.ChannelInfo('spc', 4096, 4096, 8, False, mari.Color(0.5, 0.5, 0.5)),\n" to:MyFileStream
	format "							mari.ChannelInfo('bmp', 4096, 4096, 8, False, mari.Color(0.5, 0.5, 0.5)),\n" to:MyFileStream
	format "							mari.ChannelInfo('gls', 4096, 4096, 8, False, mari.Color(0.5, 0.5, 0.5))])\n" to:MyFileStream
	format "createBasic();\n" to:MyFileStream

	--format PythonScript to:MyFileStream
	close MyFileStream
	--commandstring = ("\"" + pPaths.Mari + "\"" +  " -x \"C:\\temp\\CreateMariAsset.py\"")
	shelllaunch pPaths.Mari  (" -x " + @"C:\\temp\\CreateMariAsset.py")
) else (messageBox "Select an object to export...")
/* HelpfullStuff
#open Project
mari.projects.open('your_project_name')


#create channel
mygeo = mari.geo.current()
size = 8192
mygeo.createChannel("dif", size, size,8)
mygeo.createChannel("spc", size, size,8)
mygeo.createChannel("gls", size, size,8)
mygeo.createChannel("bmp", size, size,8)
*/

/* MoreHelpfullStuff

# mari_button01
# creates a channel & upon doing so also creates 
# a shading module with it attached in your current shader
# commented version
  
import mari
import PythonQt
from PythonQt import QtGui,QtCore
  
#defines each widget and then puts them all together in main_layout
#this makes up the GUI users see upon clicking the button
def nbutt():
    #abbreviations
    curGeo = mari.geo.current()
    channel = curGeo.currentChannel()
    dlg = QtGui.QDialog()
    
    #widget allowing user input to name their channel
    main_name = QtGui.QTextEdit()
    
    #widget listing size choices for channel
    size_box = QtGui.QComboBox()
    size_box.addItem("256");
    size_box.addItem("512");
    size_box.addItem("1024");
    size_box.addItem("2048");
    size_box.addItem("4096");
    size_box.addItem("8192");
    size_box.addItem("16384");
    size_box.addItem("32768");
    size_box.setCurrentIndex(4) #defaults as 4096
    
    #widget listing bit depth choices for channel
    type_box = QtGui.QComboBox()
    type_box.addItem("8");
    type_box.addItem("16");
    type_box.addItem("32");
    depth_indices = {channel.DEPTH_BYTE: 0, channel.DEPTH_HALF: 1, channel.DEPTH_FLOAT: 2}
    
    #widget listing RGB/RGBA choice for channel
    format_box = QtGui.QComboBox()
    format_box.addItem("RGB");
    format_box.addItem("RGBA");
    format_box.setCurrentIndex(1) #defaults as RGBA
    
    #widget listing color space choices
    colorsp_box = QtGui.QComboBox()
    colorsp_box.addItem("Color");
    colorsp_box.addItem("Scalar");
    
    #normally when creating a channel the user can pick a default
    # fill color. I have it defaulting to transparent. I find this 
    # most useful in my work.
  
    #pulls all shaders to list as choices
    allShaders = curGeo.shaderNames()
    pick_shader = QtGui.QComboBox()
    for item in allShaders:
        pick_shader.addItem("%s" %item);
    #defaults to currently selected shader
    for n in range(len(curGeo.shaderNames())):
        if curGeo.shader(curGeo.shaderNames()[n]) == curGeo.currentShader():
             pick_shader.setCurrentIndex(n)
    
    #pulls all available shading modules
    shader = curGeo.shaderList()[1] 
    modules_box = QtGui.QComboBox()
    allModules = shader.availableModules()
    for item in allModules:
        modules_box.addItem("%s" %item);
    modules_box.setCurrentIndex(5) #defaults to 'Diffuse Blend'
    
    #this places all widgets into a main layout and titles them    
    main_layout = QtGui.QFormLayout()
    main_layout.addRow("Name", main_name)
    main_layout.addRow("Size", size_box)
    main_layout.addRow("Depth",type_box) 
    main_layout.addRow("Channels",format_box)
    main_layout.addRow("Color Space", colorsp_box)
    main_layout.addRow("Pick Shader", pick_shader)
    main_layout.addRow("Shading Module", modules_box)
    
    #the "OK" & "Cancel" commands
    pb_ok = QtGui.QPushButton("OK")
    pb_ok.connect("clicked()", dlg.accept)
    pb_cancel = QtGui.QPushButton("Cancel")
    pb_cancel.connect("clicked()", dlg.reject)
    
    main_layout.addRow(pb_ok,pb_cancel);
    
    dlg.setLayout(main_layout)
    dlg.setWindowTitle("Channel & Shader Module");
    
    result = dlg.exec_()
    
    #if the user clicks ok, it takes all of the selections 
    #and passes them to the next module    
    if result == 1:
        nicole(main_name.plainText, size_box.currentText, type_box.currentText, 
                colorsp_box.currentText, format_box.currentText, pick_shader.currentText, 
                modules_box.currentText)
  
#-------------------------------------------------------------------------------------------------
#def that uses the selections frm the GUI and carries out the function we want.
def nicole(myName, size, bitDepth, colorSp, rgba, myshad, shadMod):        
    #abbreviations
    curGeo = mari.geo.current()
    #converting user input data types, str-->int
    size = int(size)  
    bitDepth = int(bitDepth)
    #converting user input, str-->bool
    if colorSp == "Color":
        colorSp = 0
    else:
        colorSp = 1
    
    if rgba == "RGB":
        rgba = 0
    else:
        rgba = 1
    
    #creates a new channel based on user input    
    newch = mari.ChannelInfo(myName, size, size, bitDepth, colorSp, rgba, None) 
    newcol = mari.Color(0,0,0,0) #necessary to create the transp base color
    newch.setFillColor(newcol)   #""
    curGeo.createChannel(newch)
    
    #takes the shader choice and creates a shader module inside it
    shader = curGeo.shader("%s" %myshad)
    shader.addModule("%s" %shadMod, "%s" %myName)
  
    #sets up the shader module with the chosen name and type
    #Since the parm to set the channel changes per module type
    # I need to go in and change the 'Texture.index' based one
    # certain modules.
    shader.setParameter('%s' %myName, 'Texture.index', curGeo.channel('%s' %myName))
    
    #sets the current channel to the one just made
    newch = curGeo.channel('%s' %myName)
    curGeo.setCurrentChannel(newch)
    

*/