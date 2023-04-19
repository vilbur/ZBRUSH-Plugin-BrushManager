#SingleInstance force

#Include %A_LineFile%\..\ScriptFileGenerator.ahk

/** Generate button for brushes
*/
Class BrushButtonLoader
{
	brushes_path	:= ""
	script_file	:= ""

	plugin_menu := "~BrushManager"

	ScriptFileGenerator	:= new ScriptFileGenerator()
	ButtonGenerator	:= new ButtonGenerator(54, 54)

	__New( $plugin_data_path )
	{
		this.brushes_path := $plugin_data_path "\..\..\Brushes"
		this.script_file  := $plugin_data_path "\..\..\Load-Brushes.txt"
	}

	/**
	 */
	loadBrushes()
	{
		this._createScriptFile()

		if( FileExist(this.brushes_path)  )
			this._getBrushTypeFolders()

		else if( ! FileExist(this.brushes_path) )
			MsgBox,262144, PATH ERROR, % "Brushes folder DOES NOT EXISTS:`n`n" this.brushes_path
	}


	/**
	 */
	_getBrushTypeFolders()
	{
		;MsgBox,262144,variable, Test,3
		Loop, Files, % this.brushes_path "\*.*", D
			this._getBrushes(A_LoopFileName, A_LoopFileFullPath)
	}

	/**
	 */
	_getBrushes( $folder_name, $path )
	{
		;MsgBox,262144, folder_name, %$folder_name%,3

		this._writeSubMenu( $folder_name )

		Loop, Files, % $path "\*.*", F
			this._writeBrushButton( $folder_name, A_LoopFileFullPath)
			;MsgBox,262144,brushes_path, %A_LoopFileFullPath%,3
	}

	/** Create Hardlinks to Zbrush\Zplugs64
	 */
	_createScriptFile()
	{
		;FileDelete, % this.script_file


		;this.ScriptFileGenerator.file := this.plugins_zbrush "\Load-Brushes.txt"
		this.ScriptFileGenerator.file := this.script_file

		this.ScriptFileGenerator.menu	:= this.plugin_menu

		this.ScriptFileGenerator.create()
	}

	/**
	 */
	_writeSubMenu( $submenu )
	{
		;if( $submenu != "" )
		FileAppend, % "`n`n[ISubPalette, """ this.plugin_menu ":" $submenu """]",	% this.script_file
	}

	/**
	 */
	_writeBrushButton( $submenu, $brush_path )
	{
		SplitPath, $brush_path, $brush_name, $brush_dir, $brush_ext, $brush_noext, $brush_drive

		;MsgBox,262144, brush_noext, %$brush_noext%,3

		$set_brush_command .= "`n	[IPress, ""Brush:" $brush_noext """ ]"

		$button := this.ButtonGenerator.create( this.plugin_menu ":" $submenu ":" $brush_noext, $set_brush_command, "Get Brush " $brush_noext )

		FileAppend, %$button%,	% this.script_file
	}


}


$BrushButtonLoader := new BrushButtonLoader( A_LineFile )

$BrushButtonLoader.loadBrushes()