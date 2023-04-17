' Copyright (c) 2023 Carl A Husberg
' 
' This software is provided 'as-is', without any express or implied
' warranty. In no event will the authors be held liable for any damages
' arising from the use of this software.
' 
' Permission is granted to anyone to use this software for any purpose,
' including commercial applications, and to alter it and redistribute it
' freely, subject to the following restrictions:
' 
' 1. The origin of this software must not be misrepresented; you must not
'    claim that you wrote the original software. If you use this software
'    in a product, an acknowledgment in the product documentation would be
'    appreciated but is not required.
' 2. Altered source versions must be plainly marked as such, and must not be
'    misrepresented as being the original software.
' 3. This notice may not be removed or altered from any source distribution.

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