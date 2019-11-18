##########################################################################
# NOMBRE DEL SCRIPT:Ejercicio2.ps1
# Trabajo Practico Nº 2 - Primer Entrega
#
# Integrantes:
# Cabral, David         39757782
# Cela, Pablo           36166867
# Pessolani, Agustin    39670584
# Sullca, Fernando      37841788
# Zabala, Gaston        34614948
#
# FECHA DE CREACIÓN: 02/10/2019
##########################################################################


<#
    .SYNOPSIS
    
        Este script informa cuáles de los procesos que se encuentran corriendo en el sistema tiene más de una determinada 
        cantidad de instancias.  
    
    .DESCRIPTION
    
        Este script se encarga de informar cuáles de los procesos que se encuentran corriendo en el sistema tiene más de 
        una determinada cantidad de instancias. El script debe recibir un parámetro llamado “-Cantidad”, en el cual se 
        indicará la cantidad mínima de instancias que debe tener un proceso para ser reportado. 
        Este parámetro debe ser obligatorio y mayor a 1.
        La salida del script debe ser únicamente un listado de los nombres de los procesos que tienen más de “-Cantidad” 
        instancias, sin encabezados ni otro texto adicional.
    
    .EXAMPLE
    
        Opcion 1) <DIRECTORIO_SCRIPT>\Ejercicio2.ps1 2

    .PARAMETER cantidad
    
        Parametro obligatorio. Cantidad mínima de instancias que debe tener un proceso para ser reportado
#>


[CmdletBinding()]

#--------------------------Declaracion de parametros-------------------------
Param(
    [Parameter(Position = 1, Mandatory = $True)]
    [int] $cantidad
)

#--------------------------Validación de parametros-------------------------
if($cantidad -lt 1)
{ 
    Write-Output "El parámetro cantidad debe ser mayor ó igual a 1" 
    exit
}

#--- Guardo la lista de todos los procesos activos

$items =  Get-Process | Select-Object Name
$procesos = $items |
  ForEach-Object { $_.Name }

<#
    Recorro cada uno y voy guardandolo en un hash-table. En caso de que el nombre del proceso ya exista en
    el hash-table, le sumo 1. 
#>
$hash = @{}

foreach ($arch in $procesos){
    $name = $arch
	
    if($hash.ContainsKey($name)){
        $hash[$name] += 1
    }else{
        $hash += @{$name = 1}
    }
}


#Valido que se hayan cargado bien los datos en el hashtable
	
#	foreach ($key in $hash.GetEnumerator()) {
#		"La clave de $($key.Name) es $($key.Value)"
#	}

#--- Recorro el hash-table, y me quedo con cada uno que tenga valor >= cantidad ---

foreach($item in $hash.GetEnumerator())
{  
	if ($item.Value -ge $cantidad){
        Write-Host $item.Key
    }
}


###################################### FIN ##################################################333
