Rem
bbdoc:
EndRem
Type TCSVWriter
	
	Field separator:String = ";"
	Field enclosure:String = "~q"
	Field newLine:String = "~r~n"
	
	Field rows:TList = CreateList()
	
	Rem
	bbdoc:
	EndRem
	Method New(separator:String=";", enclosure:String="~q", newLine:String="~r~n")
		Self.separator = separator
		Self.enclosure = enclosure
		Self.newLine = newLine
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method AddSep()
		ListAddFirst(rows, ["sep=" + separator])
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method AddRow(row:String[])
		ListAddLast(rows, row)
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method Write(path:String)
		Local file:TStream = WriteFile(path)
		
		For Local row:String[] = EachIn rows
			WriteRow(file, row)
		Next
		
		CloseFile(file)
	EndMethod
	
Private
	Method WriteRow(file:TStream, row:String[])
		For Local i:Int = 0 Until Len(row)
			row[i] = Replace(row[i], "~r~n", "")
			row[i] = Replace(row[i], "~n", "")
			
			If Not Instr(row[i], separator) And Not Instr(row[i], " ")
				Continue
			EndIf
			
			row[i] = enclosure + Replace(row[i], enclosure, enclosure + enclosure) + enclosure
		Next
		
		WriteString(file, JoinStrings(row, separator) + newLine)
	EndMethod
	
EndType