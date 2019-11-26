# Trabajo práctico N1 Ejercicio 6
# Script: Ejercicio6.sh
# Integrantes:
# Cabral, David         39757782
# Cela, Pablo           36166857
# Pessolani, Agustin		39670584
# Sullca, Fernando      37841788
# Zabala, Gaston        34614948
##################################
declare -a files=()
declare -a count=()
declare -a sizes=()

leerDirectorio () {
  dirs=`find "$1" -type d -print 2>/dev/null`
  for dir in $dirs ; do
    dirs_count=$((`(find "$dir" -type d -print 2>/dev/null | wc -l)` -1))
    if [[ $dirs_count -eq 0 && -r $dir ]] ; then
      count=`find "$dir" -maxdepth 1 -type f -print 2>/dev/null | wc -l`
      size=`find "$dir" -maxdepth 1 -type f -print 2>/dev/null | wc -c`
      agregarDirectorio "$dir" $count $size
    fi
  done
}

reemplazarVectores () {
  menor=${sizes[0]}
  new_index=0

  for i in {1..9} ; do
    if [[ ${sizes[$i]} -lt $menor ]]; then
      menor=${sizes[$i]}
      new_index=$i
    fi
  done

  if [[ $3 -gt $menor ]] ; then
    files[$new_index]=$1
    counts[$new_index]=$2
    sizes[$new_index]=$3
  fi
}

agregarDirectorio () {
  if [[ ${#files[@]} == 10 ]]; then
    reemplazarVectores $1 $2 $3
  else
    files[$index]=$1
    counts[$index]=$2
    sizes[$index]=$3
    ((index++))
  fi
}

ayuda () {
  echo "Uso: ./Ejercicio6.sh directorio_a_recorrer"
  echo "Programa informa: "
  echo "Una lista con los 10 subdirectorios con mayor peso."
  echo -e " Parametros"
  echo -e "   directorio_a_recorrer: directorio donde se buscan los subdirectorios"
  exit 4
}

errorParametros () {
  echo "Parametro Incorrecto: Utilizar Ejercicio6.sh -h"
  exit 1
}

validarDirectorio () {
  path=$1
  if ! test -d $path ; then
    echo "Directorio no encontrado."
    exit 1
  fi
}

validarParametros () {
  if [ "$1" == "-h" ] || [ "$1" == "-?" ] || [ "$1" == "--help" ]; then
    ayuda
  fi

  if test $# -ne 1 ; then
    errorParametros
  fi

  validarDirectorio $1
}

calcularBytes () {
  b=${1:-0};
  d='';
  s=0;
  S=(Bytes {K,M,G,T,P,E,Z,Y}iB)
  while ((b > 1024)); do
    d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
    b=$((b / 1024))
    let s++
  done
  echo "$b$d ${S[$s]}"
}

########## MAIN ##########
IFS='
'
validarParametros $1
base_path=$(pwd)
base_path=$(realpath "$1")
leerDirectorio $base_path

for i in {0..9} ; do
  if [ ${files[$i]} ]; then
    echo "${files[$i]} | `calcularBytes ${sizes[$i]}` | ${counts[$i]} files"
  fi
done

exit 0
