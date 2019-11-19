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
$timer = New-Object  -type System.Timers.Timer
$timer.Interval = 10000
$timer.AutoReset = $true

if($Procesos -And !$Peso -And !$Directorio)  {

    $msj=(Get-Process).count
    Write-Host $msj

    Register-ObjectEvent -InputObject $timer -EventName Elapsed -SourceIdentifier eventoProceso -Action {

        $msj=(Get-Process).count
        Write-Host $msj
    }   

}elseif(!$Procesos -And $Peso -And $Directorio){

    $msj=(Get-ChildItem -path "$Directorio" -File -recurse | Measure-Object -Property Length -sum).Sum
    Write-Host $msj

    Register-ObjectEvent -InputObject $timer -MessageData $Directorio -EventName Elapsed -SourceIdentifier eventoDirectorio -Action {

        $Directorio = $event.MessageData
        $msj=(Get-ChildItem -path "$Directorio" -File -recurse | Measure-Object -Property Length -sum).Sum
        Write-Host $msj
    
    }

}else {
    Write-Output "No se validaron los parametros."
    return;
}

$timer.Enabled = $True
