
from PySide.QtGui import QFileDialog
import os
import mari

# ------------------------------------------------------------------------------
def createBasic():
    "This creates a project with a set of default options."
    mari.projects.close()
    obj_name = "Z:\\assets\\CHR_BeetleBug\\out\ForSale\\CHR_BeetleBug_v0001__Alembic_.abc"
    if type(obj_name) is tuple and len(obj_name)>0:
        #PySide's getOpenFileName returns a tuple of file name and the used filter
        obj_name = obj_name[0]
    if os.path.exists(obj_name):
        mari.projects.create("CHR_BeetleBug",
                             obj_name,       # you can supply a list or a string (function overloads don't work in docs yet)
                             [mari.ChannelInfo('color'),                                                   # default settings
                              mari.ChannelInfo('blue', 512, 512, 16, False, mari.Color(0, 0, 0.5))]) # small blue RGBA

#Actual Create Project
createBasic();

#open Project
mari.projects.open('your_project_name')


#create channel
mygeo = mari.geo.current()
size = 8192
mygeo.createChannel("dif", size, size,8)
mygeo.createChannel("spc", size, size,8)
mygeo.createChannel("gls", size, size,8)
mygeo.createChannel("bmp", size, size,8)



# ------------------------------------------------------------------------------

# Register new actions with the action manager, and add them to a Python menu
#mari.menus.addAction(mari.actions.create('Create Project', 'mari.examples.create_project.createBasic()'), "MainWindow/P&ython/&Examples")
#mari.menus.addAction(mari.actions.create('Create Project And Import', 'mari.examples.create_project.createAndImport()'), "MainWindow/P&ython/&Examples")


