--BatchClothshit
MyObjects = #()

MyObjects = selection as array

for i in MyObjects do(
select i
max zoomext sel
$.cloth.eraseSimulation()
$.cloth.simulate true
)

