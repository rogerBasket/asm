archivos=$(ls)
codigo=$1

if [[ $codigo != '' ]];
then
	let posfijo=${#codigo}-3
	nombre=${codigo:0:posfijo-1}
	echo ${nombre}

	for i in $archivos
	do
		if [[ $i =~ ${codigo:0:posfijo-1}\.[^a][^s][^m] ]];
		then
			echo 'eliminando archivo:' $i
			rm $i
		fi
	done

	echo 'compilar:' ${codigo}

	avra ${codigo}

	echo 'cargando codigo en arduino'

	avrdude -p m328p -c stk500v1 -b 115200 -P /dev/ttyACM0 \
	-U flash:w:${nombre}.hex -F

	echo 'Done.'
else
	echo 'ingresa nombre de codigo asm'
fi



#rm hello.[^asm]