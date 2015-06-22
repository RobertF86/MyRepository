		rollout ViewportSnapshotter "Viewport Snapshotter" width:100 height:50
		(
			button btnSnapshot "Snapshot" pos:[5,5] height:40 width:90
			
			on btnSnapshot pressed do(	
			PathToSaveAsArray = (filterstring MaxFilePath "\\") 
			PathToSaveAsArray[PathToSaveAsArray.count] = "out"
			append PathToSaveAsArray "img"
			PathToSave = pGlobalFunctions.AssemblePathFromArray PathToSaveAsArray

			viewportbitmap = viewport.getViewportDib()

			viewportbitmap.filename = PathToSave + "out_" + (((getFiles (PathToSave + "*.jpg")).count) + 1)  as string+ "_.jpg"
			save viewportbitmap
			)
			
			
		)
		createdialog ViewportSnapshotter