# Trabajo práctico N2 Ejercicio 1
# Script: ejercicio1.ps1
# Integrantes:
# Cabral, David         39757782
# Cela, Pablo           36166867
# Pessolani, Agustin    39670584
# Sullca, Fernando      37841788
# Zabala, Gaston        34614948

Param (
  [Parameter(Position = 1, Mandatory = $false)]
  [String] $pathsalida = ".\procesos.txt ",
  [int] $cantidad = 3
)

$existe = Test-Path $pathsalida
if ($existe -eq $true) {
  $listaproceso = Get-Process
  foreach ($proceso in $listaproceso) {
    $proceso | Format-List -Property Id,Name >> $pathsalida
  }

  for ($i = 0; $i -lt $cantidad ; $i++) {
    Write-Host $listaproceso[$i].Name - $listaproceso[$i].Id
  }
} else {
  Write-Host "El path no existe"
}

#1. ¿Cuál es el objetivo del script?
# El objetivo del script es generar un archivo con los procesos que están corriendo.
# Además, muestra el nombre del proceso y id de tres procesos

#2. ¿Agregaría alguna otra validación a los parámetros?
# Agregariamos la validacion de que $pathsalida exista, ya que Test-Path con un parametro nulo falla.

#3. ¿Qué sucede si se ejecuta el script sin ningún parámetro?
# Si ejecuta Sin nungun parametro el script tratara de encontrar el archivo por defecto declarado en los parametro ".\procesos.txt",
# en caso de encontrarlo continua con su ejecucion , en caso contrario 
# el script arroja el error "El path no existe"
