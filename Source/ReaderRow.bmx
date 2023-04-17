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
Type TCSVReaderRow
	
	Field cols:TStringMap = New TStringMap()
	
	Method New(row:TCSVRow)
		For Local i:Int = 0 Until row.ColumnCount()
			Local col:SCsvColumn = row.GetColumn(i)
			Local header:TCsvHeader = row.GetHeader()
			
			cols[header.GetHeader(Size_T(i))] = col.GetValue()
		Next
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method Get:String(name:String)
		Return String(cols[name])
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method Get:String(name:String, _trim:Int)
		Local val:String = Get(name)
		
		If _trim
			val = val.Trim()
		EndIf
		
		Return val
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method GetInt:Int(name:String)
		Return Int(Get(name, True))
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method GetUInt:UInt(name:String)
		Return UInt(Get(name, True))
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method GetLong:Long(name:String)
		Return Long(Get(name, True))
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method GetULong:ULong(name:String)
		Return ULong(Get(name, True))
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method GetFloat:Float(name:String)
		Return Float(Get(name, True))
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method GetDouble:Double(name:String)
		Return Double(Get(name, True))
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method ToString:String()
		Local sb:TStringBuilder = New TStringBuilder()
		
		For Local key:String = EachIn cols.Keys()
			sb.AppendLine(key + ": " + String(cols[key]))
		Next
		
		Return sb.ToString()
	EndMethod
	
EndType