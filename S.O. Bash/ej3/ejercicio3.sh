#!/bin/bash

# Trabajo práctico N1 Ejercicio 3
# Script: Ejercicio3.sh
# Integrantes:
# Cabral, David         39757782
# Cela, Pablo           36166867
# Pessolani, Agustin    39670584
# Sullca, Fernando      37841788
# Zabala, Gaston        34614948

get_help(){
    echo "Ejercicio 3"
    echo "Ayuda: "
    echo "start: Inicia la ejecución del demonio, debe solicitar por parámetro el directorio a salvar, el directorio donde guardar el backup y el intervalo de tiempo entre backups (expresado en segundos). Ejm: -start /home/usuario(origen) /home/usuario(destino) 100(intervalo)"
    echo "stop: Finalizar el demonio. Ejm -stop"
    echo "count: Indica la cantidad de archivos de backup hay en el directorio. Param: -count"
    echo "clear: Limpia el directorio de backup, recibe por parámetro la cantidad de backup que mantiene en la carpeta, siendo estos los últimos generados. Si no se recibe ningún parámetro se toma el valor cero. Ejm -clear 10(Opcional)"
    echo "play: El demonio crea el backup, en ese instante. Ejm: -play"
}

comenzar(){

    SRCDIR=$1
    DESTDIR=$2
    INTERVAL=$3

    salida()
    {
        rm /tmp/DESTDIR.txt
        rm /tmp/SRCDIR.txt
        exit 0
    }
    ##################
    iteracion()
    {
        FILENAME=bkp-$(date +%-Y%-m%-d)-$(date +%-T).tgz
        #creo bkp
        tar -czvf $DESTDIR"/"$FILENAME $SRCDIR 2> /dev/null > /dev/null
        #ejecutamos sleep en un fork de este programa
        sleep $INTERVAL &
        # En bash, $! significa el pid del último proceso lanzado
        SLEEP_PID=$!
        # Esperamos a que el último proceso lanzado acabe.
        # Wait en bash sí que admite señales asíncronas.
        wait $SLEEP_PID

    }
    ##################
    trap salida SIGTERM SIGKILL

    echo $DESTDIR > /tmp/DESTDIR.txt
    echo $SRCDIR > /tmp/SRCDIR.txt

    while true
    do
        # esperar
        iteracion
    done
}

ES_NUMERO='^-?[0-9]+([.][0-9]+)?$'

if [ $# == 0 ]; then
    echo "Debe ingresar algun parametro."
    exit 0
fi;

#Mostra ayuda
if [ $1 == -h ] || [ $1 == --help ] || [ $1 == -? ] || [ $1 == -help ]; then
    get_help
    exit 0
fi;

#Creacion del servicio de Bkp
if [ $# == 4 ] && [ $1 == -start ] && [ -d $2 ] && [ -d $3 ] && [[ $4 =~ $ES_NUMERO ]]; then

    if [[ ! -f /tmp/DESTDIR.txt ]]; then
        echo "Comienza el bkp"
        echo "Directorio de bkp: "$3
        comenzar $2 $3 $4 &
        exit 0
    else
        echo "Ya existe un servicio de backup en ejecucion. Finalice el existente y vuelva a intentar."
        exit 0
    fi;
elif [ $# == 1 ] && [ $1 == -stop ]; then
    #Validar si existe el servicio en ejecucion
    if [[ -f /tmp/DESTDIR.txt ]]; then
        #Elimino archivos temporales
        rm /tmp/DESTDIR.txt
        rm /tmp/SRCDIR.txt
        #Kill Service
        pd=$(ps u | awk '$12 == "./ejercicio3.sh" {print $2}')
        pids=(${pd// / })
        menor=${pids[0]}
        for p in ${pids[*]}; do
          if [[ $p -lt $menor ]] ; then
            menor=$p
          fi
        done
        kill -9 $menor
        echo "BKP Service eliminado."
        exit 0
    else
        echo "No hay un servicio en ejecucion."
        exit 0
    fi;
elif [ $# == 1 ] && [ $1 == -play ]; then
    #Validar si existe el servicio en ejecucion
    if [[ -f /tmp/DESTDIR.txt ]]; then
        #Variables necesarias para realizar el bkp
        DESTDIR=`cat /tmp/DESTDIR.txt`
        SRCDIR=`cat /tmp/SRCDIR.txt`
        FILENAME=bkp-$(date +%-Y%-m%-d)-$(date +%-T).tgz
        tar -czvf $DESTDIR"/"$FILENAME $SRCDIR 2> /dev/null > /dev/null
        echo "Backup creado."
        exit 0
    else
        echo "No hay un servicio en ejecucion."
        exit 0
    fi;
elif [ $# == 1 ] && [ $1 == -count ]; then
    if [[ -f /tmp/DESTDIR.txt ]]; then
        #Cantidad de bkp en el directorio asignado
        DESTDIR=`cat /tmp/DESTDIR.txt`
        echo "Cantidad de archivos en el directorio: "
        ls $DESTDIR | grep .tgz | wc -l
        exit 0
    else
        echo "No hay un servicio en ejecucion."
        exit 0
    fi;
elif [ $1 == -clear ]; then
    #La validacion del archivo es para asegurarse dle servicio en ejecucion
    if [[ -f /tmp/DESTDIR.txt ]]; then
        #Validar parametro de cantidad a mantener
        if [ -z $2 ]; then
            CANT_BKP=0
        elif [[ $2 =~ $ES_NUMERO ]]; then
            CANT_BKP=$2
        else
            echo "No se validaron los parametros."
            exit 0;
        fi;
        ##Cantidad de archivos a limpiar
        I=0
        DESTDIR=`cat /tmp/DESTDIR.txt`
        while read LINE
        do
            rm $DESTDIR"/"$LINE
            (( I++ ))
        done < <(ls -lt $DESTDIR| grep tgz | awk 'NR > '$CANT_BKP'{ print $9 }')
        echo "Se eliminaron "$I" bkp."
        exit 0
    else
        echo "No hay un servicio en ejecucion."
        exit 0
    fi;
else
    echo "No se validaron los parametros."
    exit 0;
fi;
