# Trabajo práctico N1 Ejercicio 4
# Script: Ejercicio4.sh
# Integrantes:
# Cabral, David         39757782
# Cela, Pablo           36166857
# Pessolani, Agustin		39670584
# Sullca, Fernando      37841788
# Zabala, Gaston        34614948

##################### FUNCIONES ######################
#Función con la ayuda del script.
function ayuda(){
	echo ""
  echo "Uso: ./Ejercicio4.sh directorio_recorrer extension"
  echo "Programa que informa: "
  echo "Cantidad de archivos analizados."
  echo "Cantidad de líneas de código totales, como su porcentaje contra el total de líneas de los archivos analizados."
  echo "Cantidad de líneas de comentarios"
  echo -e "Parametros"
	echo -e "\directorio_recorrer : directorio donde se buscan los archivos"
	echo -e "extension: extension de los archivos a analizar "
	exit 1
}

function mostrarMensajeErrorParametros(){
    echo "La cantidad de parámetros ingresados es incorrecta."
    echo "Utilizar Ejercicio4.sh -h para verificar funcionamiento del comando"
}

#Función que valida el directorio recibido.
function validarDirectorio(){
	path=$1
   	if ! test -e $path
	then
		echo "Parametro Incorrecto: Ruta ingresada no existente"
		exit 2
	fi

	if ! test -d $path
	then
		echo "Parametro Incorrecto: Ruta ingresada no es directorio"
		exit 3
	fi
}

#Función que valida el primer parámetro recibido.
function validarPrimerParametro(){
	if [ "$1" == "-h" ] || [ "$1" == "-?" ] || [ "$1" == "--help" ]
	then
		ayuda
        exit 4
	fi
	validarDirectorio $1
}

#Función para obtener la cantidad de líneas.
function obtenerCantLineas(){
    _AuxcantLineasTotales=$(awk '
    BEGIN{
        cantLineas=0;
    }
    {
        cantLineas++;
    }
    END{
        print cantLineas;
    }' $j)
    cantLineasTotales=`expr $_AuxcantLineasTotales + $cantLineasTotales`
}

#Función para obtener la cantidad de líneas de código.
function obtenerCantLineasCodigo(){
    _AuxcantLineasCodigo=$(awk '
    BEGIN{
        cantLineasCodigo = 0;
        flagComentarioMulti = 0;
        flagYaConte = 0;
    }
    $0 != NULL && !($0 ~ /^\/\//) && !($0 ~ /^\/\*/) && flagComentarioMulti == 0{
        cantLineasCodigo++;
        flagYaConte = 1;
    }
    $0 ~ /\/\*/{
        flagComentarioMulti = 1;
    }
    $0 ~ /\*\//{
        flagComentarioMulti = 0;
    }
    !($0 ~ /\*\/$/) && !($0 ~ /^\/\//) && flagComentarioMulti == 0 && flagYaConte == 0 && $0 != NULL{
        cantLineasCodigo++;
    }
    {
        flagYaConte = 0;
    }
    END{
        print cantLineasCodigo;
    }' $j)
    cantLineasCodigo=`expr $cantLineasCodigo + $_AuxcantLineasCodigo`
}

#Función para obtener la cantidad de líneas comentadas.
function obtenerCantLineasComentadas(){
    _AuxcantLineasComentadas=$(awk '
    BEGIN{
        cantLineasComentadas = 0;
        flagComentarioMulti = 0;
        flagYaConte = 0;
    }
    $0 ~ /\/\// || flagComentarioMulti == 1{
        cantLineasComentadas++;
        flagYaConte = 1;
    }
    $0 ~ /\/\*/ {
        if(flagYaConte == 0)
            cantLineasComentadas++;
        flagComentarioMulti = 1;
    }
    $0 ~ /\*\//{
        flagComentarioMulti = 0;
    }
    {
        flagYaConte = 0;
    }
    END{
        print cantLineasComentadas;
    }' $j)
    cantLineasComentadas=`expr $cantLineasComentadas + $_AuxcantLineasComentadas`
}

#Función para obtener el porcentaje de líneas de código.
function obtenerPorcentajeLineasCodigo(){
    porcentajeLineasCodigo=$(awk -v cantLineasCodigo="$cantLineasCodigo" -v cantLineasTotales="$cantLineasTotales" '
    BEGIN{
        print ((cantLineasCodigo / cantLineasTotales) * 100)
    }')
}

#Función para obtener el porcentaje de líneas comentadas.
function obtenerPorcentajeLineasComentadas(){
    porcentajeLineasComentadas=$(awk -v cantLineasComentadas="$cantLineasComentadas" -v cantLineasTotales="$cantLineasTotales" '
    BEGIN{
        print ((cantLineasComentadas / cantLineasTotales) * 100)
    }')
}

##################### INICIO DEL SCRIPT ##############
#Asignación para que el script pueda trabajar con rutas con espacios.
IFS='
'
#Validaciones de los parámetros.
validarPrimerParametro $1
if test $# -ne 2
then
    mostrarMensajeErrorParametros
    exit 5
fi

#Inicialización de variables
path=$1
aBuscar=$2 #Extensión de archivos a buscar

cantArchivos=0
cantLineasTotales=0
cantLineasCodigo=0
cantLineasComentadas=0

for j in `find $path -type f -name "*$aBuscar"`
do
    #Auxiliares que guardaran las líneas correspondientes al archivo actual.
    _AuxcantLineasComentadas=0
    _AuxcantLineasCodigo=0


    obtenerCantLineas $j
    obtenerCantLineasComentadas
    obtenerCantLineasCodigo

    cantArchivos=`expr $cantArchivos + 1`
done
#Muestro los resultados
echo "Cantidad de archivos analizados:          "$cantArchivos"."
echo ""
#Condición para el caso en que los archivos estén vacíos.
if [ $cantLineasTotales -gt 0 ]
then
    porcentajeLineasCodigo=0
    porcentajeLineasComentadas=0
    obtenerPorcentajeLineasCodigo
    obtenerPorcentajeLineasComentadas
    echo "Cantidad de líneas de Código totales:     "$cantLineasCodigo"."
    echo "Porcentaje de líneas de Código:           "$porcentajeLineasCodigo"%."
    echo ""
    echo "Cantidad de líneas Comentadas totales:    "$cantLineasComentadas"."
    echo "Porcentaje de líneas Comentadas:          "$porcentajeLineasComentadas"%."
else
    echo "La cantidad de líneas analizadas es de cero."
fi

exit 0
##################### FIN DEL SCRIPT #################
