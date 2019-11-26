# Trabajo práctico N1 Ejercicio 1 ReEntrega
# Script: Ejercicio1.sh
# Integrantes:
# Cabral, David         39757782
# Cela, Pablo           36166867
# Pessolani, Agustin    39670584
# Sullca, Fernando      37841788
# Zabala, Gaston        34614948

# sed -i 's/\r$//' filename
ErrorS()
{
    echo "Error. La sintaxis del script es la siguiente:"
    echo "Obtener número de líneas: $0 nombre_archivo L"
    echo "Obtener número de caracteres: $0 nombre_archivo C"
    echo "Obtener longitud de la línea más larga: $0 nombre_archivo M"
    exit
}
ErrorP()
{
    echo "Error. El archivo ingresado no tiene permisos de lectura"
}

#Valida cantidad de parámetros menor a 2
if test $# -lt 2; then
    ErrorS
fi

# Valida si el primer parámetro tiene permisos de lectura
if ! [ -r "$1" ]; then
 ErrorP $1
 # Valida si el parametro1 es un archivo y el parametro2 es L ó C ó M.
 # Si no cumple la condicion, muestra un mensaje de error
elif test -f $1 && (test "$2" = "L" || test "$2" = "C" || test "$2" = "M"); then
 if test $2 = "L"; then #Cuenta el numero de líneas
    res=` wc -l $1 `
    echo "Numero de líneas: $res"
 elif test $2 = "C"; then 
    res=` wc -m $1 ` #Cuenta el número de caracteres
    echo "Número de caracteres: $res"
elif test $2 = "M"; then
    res=` wc -L $1 ` #Cuenta la longitud mas larga 
    echo "Longitud de la línea más larga: $res"
 fi
else
 ErrorS
fi


#Responda:
#a) ¿Cuál es el objetivo de este script?
# El objetivo del script es informar número de líneas ó número de caracteres ó longitud de la línea más larga de un 
# archivo pasado por parámetro.
# En el caso de que el parámetro ingresado por el correcto no sea válido, arroja un mensaje de error.

#b) ¿Qué parámetros recibe?
    # Recibe nombre del archivo e instrucción a realizar para con el archivo.
#c) Comentar el código según la funcionalidad (no describa los comandos, indique la lógica)
#d) Completar los “echo” con el mensaje correspondiente.
#e) ¿Qué información brinda la variable “$#”? ¿Qué otras variables similares conocen? Explíquelas.
    # $#: Brinda la cantidad de parámetros
    # $0: Brinda el nombre del script.
    # $@: Brinda todos los parámetros.
    # $?: Brinda el valor de retorno del último comando ejecutado.
    # $$: Brinda el id del proceso.
    # $*: Brinda la linea completa de ejecución.

# f) Explique las diferencias entre los distintos tipos de comillas que se pueden utilizar en Shell scripts.

#   `` -->  Si dentro de un script escribo un comando dentro de estas comillas, el bash primero reemplazará dentro de la línea
#   este comando por la salida estándar de la ejecución de éste. Una vez que esto esté terminado recién ejecutará la linea

#   "" --> Interpreta las referencias a variable, las explosiona, poniendo en su lugar su contenido.

#   '' --> El contenido se interpreta de forma literal.
