<#
    .SYNOPSIS
    Muestra la cantidad de procesos activos o el tamaño de un directorio.

    .DESCRIPTION
    Muestra la cantidad de procesos activos o el tamaño de un directorio.

    .EXAMPLE
    .\ejercicio5.ps1 -Procesos
    o
    .\ejercicio5.ps1 -Peso -Directorio ./directorio
	
	.OUTPUTS
	Procesos: Cantidad de procesos activos: XXX o Peso: Tamaño del directorio: XXX

	.NOTES
    Sistemas Operativos
    -------------------
	Trabajo Práctico N°2
	Ejercicio 5
	Script: .\ejercicio5.ps1
    -------------------
	Integrantes:
	    Cabral, David:          39757782
        Cela, Pablo:            36166867
        Pessolani, Agustin:     39670584
        Sullca, Fernando:       37841788
        Zabala, Gaston:         34614948
	
#>

[CmdLetBinding()]
Param (
    [Parameter(ParameterSetName="set1",Position=0)]
    [Switch]$Procesos,
    [Parameter(ParameterSetName="set2",Position=0)]
    [Switch]$Peso,
    [Parameter(ParameterSetName="set2",Position=1)]
    [ValidateScript({
            if(-Not ($_ | Test-Path) ){
                throw "File or folder does not exist" 
            }
            if(-Not ($_ | Test-Path -PathType Container) ){
                throw "The Path argument must be a folder. File paths are not allowed."
            }
            return $true
        })]
    [System.IO.DirectoryInfo]$Directorio
)

if($Procesos -And !$Peso -And !$Directorio)  {
    $m = Get-Process | measure
    $m.Count    
}elseif(!$Procesos -And $Peso -And $Directorio){
    $dir = Get-ChildItem -Path $Directorio -File -Recurse | Measure-Object -Property Length -Sum
    $dir.sum
}
else {
    Write-Output "No se validaron los parametros."
}