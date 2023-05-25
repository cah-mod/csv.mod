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
Type TCSVReader
	
	Field csv:TCsvParser
	
	Rem
	bbdoc:
	EndRem
	Method New(path:String, delimiter:String=",", quotes:Int=True, header:Int=True)
		Local opts:TCsvOptions = New TCsvOptions()
		opts.delimiter = delimiter
		
		If Not quotes
			opts.noQuotes = True
		EndIf
		
		If Not header
			opts.insertHeaderRow = GenerateHeader(path, delimiter, quotes)
		EndIf
		
		Local file:TStream = ReadFile(path)
		csv = TCsvParser.Parse(file, opts)
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Function Load:TList(path:String, delimiter:String, quotes:Int=True, header:Int=True)
		Local csv:TCSVReader = New TCSVReader(path, delimiter, quotes, header)
		
		Local list:TList = CreateList()
		
		For Local row:TCSVReaderRow = EachIn csv
			ListAddLast(list, row)
		Next
		
		Return list
	EndFunction
	
Private
	Function GenerateHeader:String(path:String, delimiter:String, quotes:Int)
		Local opts:TCsvOptions = New TCsvOptions()
		opts.delimiter = delimiter
		
		If Not quotes
			opts.noQuotes = True
		EndIf
		
		opts.insertHeaderRow = "0"
		
		Local file:TStream = ReadFile(path)
		
		Try
			Local csv:TCsvParser = TCsvParser.Parse(file, opts)
			
			Local status:ECSVStatus = csv.NextRow()
			
			If status <> ECsvStatus.row
				Return Null
			EndIf
			
			Local row:TCSVRow = csv.GetRow()
			
			If Not row
				Return Null
			EndIf
			
			Local count:Int = row.ColumnCount()
			
			Local str:String = ""
			
			For Local i:Int = 0 Until count
				str :+ i + delimiter
			Next
			
			Return Left(str, Len(str)-1)
		Catch e:Object
			Return Null
		Finally
			CloseFile(file)
		EndTry
	EndFunction
	
	Method NextRow:TCSVReaderRow()
		Local status:ECSVStatus = csv.NextRow()
		
		If status <> ECsvStatus.row
			Return Null
		EndIf
		
		Local row:TCSVRow = csv.GetRow()
		
		If Not row
			Return Null
		EndIf
		
		Local header:TCsvHeader = row.GetHeader()
		
		If Abs(header.ColumnCount() - row.ColumnCount()) > 0
			Local sb:TStringBuilder = New TStringBuilder()
			
			sb.AppendLine("Header <> Column mismatch")
			sb.AppendLine(header.ColumnCount() + " <> " + row.ColumnCount())
			
			For Local i:Int = 0 Until row.ColumnCount()
				sb.AppendLine(row.GetColumn(i).GetValue())
			Next
			
			Throw sb.ToString()
		EndIf
		
		Return New TCSVReaderRow(row)
	EndMethod
	
	Method ObjectEnumerator:TCSVReaderIterator()
		Local i:TCSVReaderIterator = New TCSVReaderIterator()
		i.reader = Self
		Return i
	EndMethod
	
EndType