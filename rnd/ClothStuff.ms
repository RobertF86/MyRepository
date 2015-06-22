--ClothStuff
for i in selection do(
i.modifiers[#cloth].setObjecttype i 1 true -- CollObject
)


for i in selection do(
i.modifiers[#cloth].setObjecttype i 2 true -- ClothObj
)
	
for i in selection do( --Set Burlap
-- Set Cloth Properties to Burlap
i.modifiers[#cloth].setObjectProperty i "bend" 100
i.modifiers[#cloth].setObjectProperty i "bCurve" 0.3
i.modifiers[#cloth].setObjectProperty i "stretch" 250
i.modifiers[#cloth].setObjectProperty i "shear" 500
i.modifiers[#cloth].setObjectProperty i "density" 0.01
i.modifiers[#cloth].setObjectProperty i "thickness" 0.5
i.modifiers[#cloth].setObjectProperty i "repulsion" 2.0
i.modifiers[#cloth].setObjectProperty i "damping" 0.2
i.modifiers[#cloth].setObjectProperty i "airres" 0.01
i.modifiers[#cloth].setObjectProperty i "dynFric" 0.4
i.modifiers[#cloth].setObjectProperty i "staticFric" 0.7
i.modifiers[#cloth].setObjectProperty i "selfFric" 0.8
i.modifiers[#cloth].setObjectProperty i "seamForce" 5000
i.modifiers[#cloth].setObjectProperty i "uScale" 1.0
i.modifiers[#cloth].setObjectProperty i "vScale" 1.0
i.modifiers[#cloth].setObjectProperty i "useEdgeSprings" 0
i.modifiers[#cloth].setObjectProperty i "useSolidFriction" 0
i.modifiers[#cloth].setObjectProperty i "depth" 0
i.modifiers[#cloth].setObjectProperty i "offset" 0
i.modifiers[#cloth].setObjectProperty i "enableCollisions" 1
i.modifiers[#cloth].setObjectProperty i "uBend" 150
i.modifiers[#cloth].setObjectProperty i "vBend" 150 
i.modifiers[#cloth].setObjectProperty i "uBCurve" 0.3
i.modifiers[#cloth].setObjectProperty i "vBCurve" 0.3 
i.modifiers[#cloth].setObjectProperty i "uStretch" 250
i.modifiers[#cloth].setObjectProperty i "vStretch" 250
i.modifiers[#cloth].setObjectProperty i "keepShape" 100
i.modifiers[#cloth].setObjectProperty i "plasticity" 0
i.modifiers[#cloth].setObjectProperty i "layer" 0
i.modifiers[#cloth].setObjectProperty i "compress" 250
i.modifiers[#cloth].setObjectProperty i "uCompress" 250 
i.modifiers[#cloth].setObjectProperty i "vCompress" 250
i.modifiers[#cloth].setObjectProperty i "isCutter" 0 
i.modifiers[#cloth].setObjectProperty i "pressure" 0
i.modifiers[#cloth].setObjectProperty i "pressure_damp" 0
i.modifiers[#cloth].setObjectProperty i "keep_shape_bend_strength" 100
i.modifiers[#cloth].setObjectProperty i "keep_shape_stretch_strength" 100
i.modifiers[#cloth].setObjectProperty i "track_volume" 0 
i.modifiers[#cloth].setObjectProperty i "cap_holes" 0
i.modifiers[#cloth].setObjectProperty i "inherit_velocity" 0
)

for i in selection do( --SetCollision
--CollisionObjects
i.modifiers[#cloth].setObjectProperty i "depth" 0.5
i.modifiers[#cloth].setObjectProperty i "offset" 0.5
i.modifiers[#cloth].setObjectProperty i "dynFric" 1
i.modifiers[#cloth].setObjectProperty i "staticFric" 1
)

$.modifiers[#cloth].getObjectProperty $ "depth" 

print ($.modifiers[#cloth].showobjectproperties())

	
--Add Wind Force to all
AllSelection = #()
AllSelection  =  Selection as array
for i=1 to AllSelection.count do(
	select AllSelection[i]
	$.modifiers[#cloth].addForceField  $Wind001
)



-- Making Groups and constraints
$.modifiers[#Cloth].selectVertices #{14,15,16,17,18,19} $Shape404


for i in selection do(
i.modifiers[#Cloth].makePointGroup #{14,15,16,17,18,19} i "MyGroup"
i.modifiers[#Cloth].makeConstraint "MyGroup" "drag" i  --  if you want to preseve, use the "Preserved" string instead of  "Preserve"
)

--Sim Loop
AllSelection = #()
AllSelection  =  Selection as array
for i=1 to AllSelection.count do(
	print i
	select AllSelection[i]
	max tool zoomextents
	completeRedraw() 
	--disableSceneRedraw()
	$.modifiers[#cloth].simulate true
	------------------PointCacheStuff
	--addmodifier $ (Point_Cache())
	--$.modifiers[#Point_Cache].filename = @"\\inferno2\projects\vulcan\scenes\OA_026_0170\cache\banners\" + ($.name as string) + ".pc2"
	--$.modifiers[#Point_Cache].filename = @"C:\cloth" + ($.name as string) + ".pc2"
	--cacheops.Recordcache ($.modifiers[#Point_Cache])
	--$.modifiers[#cloth].resetState $
	--$.modifiers[#cloth].enabled = false
	--enableSceneRedraw()
	gc()
)

for i in selection do i.modifiers[#cloth].resetState $