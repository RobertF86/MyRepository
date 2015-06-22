--Some helpful functions
--deleteCharsInString Function not finished yet
fn deleteCharsInString &StringToReplace charToReplace =
(
	for currCharInt = 1 to StringToReplace.count do
	(
		if StringToReplace[currCharInt] == charToReplace do 
			(
				print "inIf"
				print currCharInt
				StringToReplace = (replace StringToReplace currCharInt 1 "")
			)
	)    

	return stringToReplace
)