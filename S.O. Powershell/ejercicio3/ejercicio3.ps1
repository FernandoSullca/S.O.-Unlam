###############################################
# NOMBRE DEL SCRIPT:Ejercicio3.ps1            #
# Trabajo Practico Nº 2 - Primer Entrega      #
#                                             #
# Integrantes:                                #
# Cabral, David         39757782              #
# Cela, Pablo           36166867              #
# Pessolani, Agustin    39670584              #
# Sullca, Fernando      37841788              #
# Zabala, Gaston        34614948              #
#                                             #
###############################################

<#
  .SYNOPSIS

      El script se encarga de mover archivos indicados en un CSV a otro directorio.

  .DESCRIPTION

      El script toma la ruta de X cantidad de archivos en un CSV, y los mueve hacia un destino indicado.
      El script tambien genera un archivo log donde guarda las transacciones con sus respectivas fechas.

  .EXAMPLE

      ./ejercicio3.ps1 Entrada.csv Salida.csv

#>

########## ----- DECLARACION DE PARAMETROS ----- ##########

Param (
 [Parameter(Mandatory = $true)]
 [ValidateNotNullOrEmpty()]
 [ValidatePattern(".*.csv")] # el parametro tiene que ser un archivo
 [ValidateScript({
            if(!(Test-Path $_)) {
                throw "El archivo csv de entrada no existe"
            }
            return $true
        })]
 [string] $entrada,
 [Parameter(Mandatory = $true)]
 [ValidateNotNullOrEmpty()]
 [ValidatePattern(".*.csv")] # el parametro tiene que ser un archivo
 [string] $salida
)

########## ----- MAIN ----- ##########

$routes = Import-CSV -Delimiter "," -Path $Entrada

$logs = @()

foreach ($route in $routes) {
  if((Test-Path -Path $route.origen) -and (Test-Path -Path $route.destino)) {
    Move-Item -Path $route.origen -Destination $route.destino
    $file = Split-Path $route.origen -leaf
    $logs += @{archivo="$($route.destino)/$($file)";fecha=Get-Date -DisplayHint Date}
  }
}

$logs | Select-Object -Property archivo,fecha | Export-Csv -Path "$Salida" -Append
