##########################################################################
# Trabajo práctico N2 Ejercicio 6
# Script: Ejercicio6.ps1
#
# Integrantes:
# Cabral, David         39757782
# Cela, Pablo           36166857
# Pessolani, Agustin	  39670584
# Sullca, Fernando      37841788
# Zabala, Gaston        34614948
##########################################################################

<#
        .SYNOPSIS
              
                El script se encarga de Sumar dos matrices o realizar un Producto entre una matriz y un escalar.

        .DESCRIPTION

                El script recibe una matriz en un archivo de texto y una palabra clave.
                Si la palabra clave es -Producto, recibe un numero entero, con el cual va a realizar el producto escolar.
                Si la palabra clave es -Suma, debe ingresar un archivo con otra matriz a sumar.
                Luego guarda la matriz en un nuevo archivo de texto.
        
        .EXAMPLE
                ./Ejercicio6.ps1 Entrada.txt -Suma matSuma.txt
        .EXAMPLE
                ./Ejercicio6.ps1 Entrada2.txt -Producto -15
        .EXAMPLE
                ./Ejercicio6.ps1 "entr ada3.txt" -Suma "mat suma.txt"

#>

#Validación de los parámetros
Param(
        [Parameter(Mandatory=$true,Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$Entrada,
        [Parameter(ParameterSetName="Producto",Position = 2)]
        [int]$Producto,
        [Parameter(ParameterSetName="Suma",Position = 2)]
        [ValidateNotNullOrEmpty()]
        [string]$Suma
)

function Validar-Entrada {
#Valida que $Entrada sea un archivo existente
        if(-not(Test-Path $Entrada)){
                Write-Host "Debe ingresar un archivo de Entrada valido. "
                Write-Host "Use el comnado Get-Help para recibir más ayuda."
                exit 1
        }
#Valida que $Entrada no sea un archivo vacío
        if((Get-ItemProperty -Path $Entrada).Length -eq 0){
                Write-Host "El archivo " $Entrada " está vacío. Debe ingresar un archivo con una matriz valida."
                Write-Host "Use el comnado Get-Help para recibir más ayuda."
                exit 2
        }
}
function Validar-Suma {
#Valida que $Suma sea un archivo existente
        if(-not(Test-Path $Suma)){
                Write-Host "Debe ingresar un archivo de Entrada valido. "
                Write-Host "Use el comnado Get-Help para recibir más ayuda."
        exit 3
}
#Valida que $Suma no sea un archivo vacío
        if((Get-ItemProperty -Path $Suma).Length -eq 0){
                Write-Host "El archivo " $Suma " está vacío. Debe ingresar un archivo con una matriz valida."
                Write-Host "Use el comnado Get-Help para recibir más ayuda."
        exit 4
}

}
function Es-Suma {
        #Función que indica si la operacion es Suma o Producto Escalar.
        if ($Suma) {
                return $true #Suma entre matrices.
        }
        else{
                return $false #Producto escalar.
        }
}
function Crear-Matriz {
        #Función que se encarga de generar una matriz de tipo Double.
        Param(
                [string]$arch
        )
        #Obtengo la matriz desde un archivo.
        $arch = Resolve-Path -Path $arch
        $matriz = @()
        foreach($i in [System.IO.File]::ReadLines($arch)){
                $new = $i.split("|")
                $matriz += ,$new
        }
        #Se cambie el tipo a Double.
        $matrizDoble = @()
        for ($i = 0; $i -lt $matriz.Length; $i++) {
                $matAux = @(
                        for ($j = 0; $j -lt $matriz[$i].Length; $j++) {
                        [convert]::ToDouble($matriz[$i][$j])
                        }
                )
                $matrizDoble += ,$matAux
        }
        return $matrizDoble
}
function Sumar-Matrices {
        #Suma dos matrices. Solo funciona con -Suma.
        $matrizSuma = Crear-Matriz $Suma
        for($i=0;$i -lt $matrizD.Length; $i++){
                for($j=0; $j -lt $matrizD[$i].Length; $j++){
                        $matrizD[$i][$j] += $matrizSuma[$i][$j]
                }
        }
        return $matrizD
}
function Producto-Escalar {
        #Multiplica la matriz con un escalar pasado por parametro. Solo funciona con -Producto
        for($i=0;$i -lt $matrizD.Length; $i++){
                for($j=0; $j -lt $matrizD[$i].Length; $j++){
                        $matrizD[$i][$j] *= $Producto
                }
        }
        return $matrizD
}
function Crear-Salida {
        #Crea el nombre del archivo de salida.
        $aux = $Entrada.Split("/")[-1]
        $Salida= "salida."+ $aux
        #Busca al archivo de salida, si existe lo elimina
        if (Test-Path $Salida){
                Remove-Item $Salida
                }
        Return $Salida
}
function Guardar-Matriz {
        param (
                $matriz,
                $Salida
        )
        #Guarda la matriz en el archivo $Salida.
        for($i=0;$i -lt $matriz.Length; $i++){
                for($j=0; $j -lt $matriz[$i].Length; $j++){
                        if($j -eq 0){
                                $matriz[$i][$j] | Out-File $Salida -Append -NoNewline
                        }
                        else {
                                "|"+$matriz[$i][$j] | Out-File $Salida -Append -NoNewline
                        }
                }
                "" | Out-File $Salida -Append
        }
}
function Mostrar-Matriz {
        Param(
                $matriz
        )
        #Función que muestra la $matriz en la consola.
        for($i=0;$i -lt $matriz.Length; $i++){
                Write-Host $matriz[$i]
        }
}

Validar-Entrada
$matrizD = Crear-Matriz $Entrada
$operacion = Es-Suma
if($operacion -eq $true) {
        Validar-Suma
        $matrizD = Sumar-Matrices $Suma
}
else{
        $matrizD = Producto-Escalar $Producto
}
Mostrar-Matriz $matrizD
$Salida = Crear-Salida
Guardar-Matriz $matrizD $Salida

exit 0
#Final del script
