Type TCSVReaderIterator
	
	Field reader:TCSVReader
	Field row:TCSVReaderRow
	
	Method HasNext:Int()
		row = reader.NextRow()
		
		If Not row
			Return False
		EndIf
		
		Return True
	EndMethod
	
	Method NextObject:Object()
		Return row
	EndMethod
	
EndType