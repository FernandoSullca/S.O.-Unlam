# Trabajo práctico N1 Ejercicio 2
# Script: Ejercicio2.sh
# Integrantes:
# Cabral, David         39757782
# Cela, Pablo           36166867
# Pessolani, Agustin    39670584
# Sullca, Fernando      37841788
# Zabala, Gaston        34614948

# sed -i 's/\r$//' filename
# mkdir carpeta1
# cd carpeta1
# touch "ejercicio     .txt"
# touch "ejercicio   .txt"
# cd ..
# chmod 777 Ejercicio2.sh
# ./Ejercicio2.sh ./carpeta1 -r

# Funciones
function ayuda(){
	echo ""
	echo "Uso: ./Ejercicio2.sh directorio_recorrer -r[Opcional]"
	echo "Reemplaza espacios en blanco por un guión bajo, en el nombre de los archivos"
	echo -e "   Parametros"
	echo -e "   \directorio_recorrer : directorio donde se buscan los archivos"
	echo -e "   -r [Opcional], permite recorrer el directorio recursivamente "
	exit
}

function func_MostrarMensajeErrorParametros
{
	echo "Parametro Incorrecto: Utilizar Ejercicio2.sh -h para verificar funcionamiento del comando"
}

function func_esRecursiva
{
	if [ $# == 2 ] && [ "$rec" != "-r" ]
	then
		func_MostrarMensajeErrorParametros
		exit
	fi
}

function func_ValidarDirectorio
{
	path=$1

   	if ! test -e $path
	then
		echo "Parametro Incorrecto: Ruta ingresada no existente"
		echo "Para más información utilizar Ejercicio2.sh -h para verificar funcionamiento del comando"
		exit
	fi

	if ! test -d $path
	then
		echo "Parametro Incorrecto: Ruta ingresada no es directorio"
		echo "Para más información utilizar Ejercicio2.sh -h para verificar funcionamiento del comando"
		exit
	fi
}

function func_validarParametros
{
	if [ "$1" == "-h" ] || [ "$1" == "-?" ] || [ "$1" == "--help" ]
	then
		ayuda
		exit
	fi

    if test $# -gt 2 ; then
        func_MostrarMensajeErrorParametros
        exit
    fi

    if test $# -eq 0; then
		path='.'
    fi

	if [ "$1" == "-r" ] && test $# -eq 1
	then
    path='.'
		rec='-r'
	fi

	func_ValidarDirectorio $path
	func_esRecursiva $path $rec
}

#Agregamos para que los directorios funcionen con espacios
function func_ConfiguracionDirectorio
{
	IFS=$'\n'
}

############################################MAIN##########################################################

path=$1
rec=$2
func_ConfiguracionDirectorio
func_validarParametros $path $rec

aBuscar=' '
aReemplazar='_'

cModificados=0

for j in `find $path -type f -name "*$aBuscar*"`
do

  pathNuevo=$j;
  dname=`dirname $j`


	if ([ $# == 2 ] || ( test $# -lt 2 && [ "$path" == "$dname" ]) || ( test $# -lt 2 && [ "$rec" == "-r" ]) || ( test $# -lt 2 && [ "$path" == "$dname/" ]))

	then
		pathNuevo=$(echo $j | awk -F'/' 'BEGIN{
			ruta=""
        	pos=0
        	nombre=""
			}
   			{
        		split($NF,name," ")
        		#Obtengo la cantidad de posiciones
        		for (x in name){
            			pos++
        		}
        		#recorro hasta la ante ultima posicion
        		for (n=0;n<pos-1;n++){
            			nombre=nombre name[n+1] "_"
        		}
        		#Le concateno la ultima parte
        		nombre=nombre name[pos]
        		#Rearmo la ruta
        		for(i=1;i<NF;i++){
            			ruta=ruta $i "/"
        		}
    		print ruta""nombre}')

		add=0
		pAux=$pathNuevo
		# Valido que el archivo no exista
		# Si existe, le agrego un numero al nombre del archivo, antes de la extension (si tiene),
		# o al final del archivo
		while [ -f $pathNuevo ]
		do
			add=`expr $add + 1`

			_dir=${pAux%/*}"/"
			_arch=${pAux##*/}

			if [[ $_arch =~ "." ]]
				then
				_sinExt=${_arch%%.*}
				_ext="."${_arch##*.}
				_dirOk=$_sinExt"("$add")"$_ext
			else
				_dirOk=$_arch"("$add")"
			fi

			pathNuevo=$_dir""$_dirOk
		done

		mv $j $pathNuevo
		echo "Viejo: " $j
    	echo "Nuevo: " $pathNuevo
		cModificados=`expr $cModificados + 1`
	fi
done

echo "Cantidad de modificados: "$cModificados
##################################################
