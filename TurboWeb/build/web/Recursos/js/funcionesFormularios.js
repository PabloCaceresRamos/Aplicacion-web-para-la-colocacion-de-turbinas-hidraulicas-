/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global google, mapOptions, myLatLng, marker, coords, windows */

var ficheroCorrecto = false;

function tipoFichero() {
    //Esta funcion se lanza cuando el select del formulario cambia de valor
    //La funcion va a ajustar el numero de inputs segun el tipo de formulario que queremos crear.
    var casillas = [[],
        ['Caudal'],
        ['Caudal a las 00:00', 'Caudal a las 01:00', 'Caudal a las 02:00', 'Caudal a las 03:00', 'Caudal a las 04:00', 'Caudal a las 05:00',
            'Caudal a las 06:00', 'Caudal a las 07:00', 'Caudal a las 08:00', 'Caudal a las 09:00', 'Caudal a las 10:00', 'Caudal a las 11:00',
            'Caudal a las 12:00', 'Caudal a las 13:00', 'Caudal a las 14:00', 'Caudal a las 15:00', 'Caudal a las 16:00', 'Caudal a las 17:00',
            'Caudal a las 18:00', 'Caudal a las 19:00', 'Caudal a las 20:00', 'Caudal a las 21:00', 'Caudal a las 22:00', 'Caudal a las 23:00'],
        ['Caudal del lunes', 'Caudal del martes', 'Caudal del miercoles', 'Caudal del jueves', 'Caudal del viernes', 'Caudal del sabado', 'Caudal del domingo'],
        ['Caudal semana 1', 'Caudal semana 2', 'Caudal semana 3', 'Caudal semana 4'],
        ['Caudal de enero', 'Caudal de febrero', 'Caudal de marzo', 'Caudal de abril', 'Caudal de mayo', 'Caudal de junio', 'Caudal de julio', 'Caudal de agosto', 'Caudal de septiembre', 'Caudal de octubre ', 'Caudal de noviembre', 'Caudal de diciembre'],
        ['Caudal de primavera', 'Caudal de verano', 'Caudal de otoño', 'Caudal de invierno']
    ];

    var tipo = document.getElementById('tipoFich').value;
    var texto = '';
    for (var i = 0, max = casillas[tipo].length; i < max; i++) {//Escribimos cada input en el string
        texto += '<p class="campoFormulario">' +
                '<label class="etiqueta">' + casillas[tipo][i] + ' (m³/s)</label>' +
                '<input required id="f' + i + '" class="input" type="text" size="5" pattern="[0-9]+(\.[0-9]+)?"/>' +
                '</p>';
    }


    document.getElementById('casillasFormularios').innerHTML = texto; //Escribimos el string en la pagina

}

function cambiarNombre(){
    var link = document.getElementById('downloadlink');
    var nombreFichero = document.getElementById('nombre').value;
    link.style.display = 'none';
    link.download=nombreFichero+".twb";
}

var textFile = null,
        makeTextFile = function (text) {
            var data = new Blob([text], {type: 'text/plain'});

            //Revocamos el valor del url para evitar perdidas de informacion
            if (textFile !== null) {
                window.URL.revokeObjectURL(textFile);
            }

            textFile = window.URL.createObjectURL(data);

            return textFile;
        };

function getInformacion() {//Recoge la informacion de la pagina y devuelve el contenido del fichero
    var inf = '';
    var numCaudales = document.getElementsByClassName('input').length;
    inf += 'Tipo de fichero:' + document.getElementById('tipoFich').value + '\n';//Indicamos el tipo de fichero
    inf += '+Localizacion:';
    var localizacion = document.getElementById('localizacion').value;
    if (localizacion !== '') {
        inf += localizacion + '\n';

    } else {
        inf += '' + '\n';
    }
    var latitud = document.getElementById('latitud').value;
    var longitud = document.getElementById('longitud').value;
    if (latitud !== '' && longitud !== '') {
        inf += '+Latitud:' + latitud + '\n';
        inf += '+Longitud:' + longitud + '\n';
    } else {
        inf += '+Latitud:' + '' + '\n';
        inf += '+Longitud:' + '' + '\n';
    }
    inf += '+Caudales:\n+';
    for (var i = 0, max = numCaudales; i < max; i++) {
        inf += document.getElementById('f' + i).value + '\n+';
    }
    inf += 'Fin';
    return inf;
}
 //Codigo inspirado de https://jsfiddle.net/UselessCode/qm5AG/
function crear() {
    var link = document.getElementById('downloadlink');
    var tipoFich = document.getElementById('tipoFich').value;
    var informacion = getInformacion();//generamos la informacion del archivo
    link.href = makeTextFile(informacion);//cambiamos el enlace de descarga
    link.style.display = 'block';//ponemos el enlace en visible
    return false;//este false es para que el form no se complete y se recargue la pagina
}
;


//Codigo inspirado de https://developers.google.com/maps/documentation

var map;
var lat = 40.418288;
var lng = -3.702259;
function initMap() {
    map = new google.maps.Map(document.getElementById("map"), {
        center: {lat: lat, lng: lng},
        zoom: 6,
        streetViewControl: false
    });

    marker = new google.maps.Marker({
        map: map,
        draggable: true,
        animation: google.maps.Animation.DROP,
        position: new google.maps.LatLng(lat, lng)

    });

    marker.addListener('click', function () {//cuando hacemos click en el marcador se cierra el mapa guardando las coordenadas
        var latMarker = document.getElementById('latitud');
        var lngMarker = document.getElementById('longitud');
        latMarker.value = this.getPosition().lat();//this hace referencia al marker, ya que es el objeto que llama a la funcion
        lngMarker.value = this.getPosition().lng();
        var mapa = document.getElementById('zmapa');
        mapa.style.display = 'none';
    });
}



function abrirMapa() {
    var mapa = document.getElementById('zmapa');
    mapa.style.display = 'block';
}

function cerrarMapa() {
    var mapa = document.getElementById('zmapa');
    mapa.style.display = 'none';
}


function controlFichero() {
    //Controlamos si se ha dejado vacio el fichero de salto neto o bruto
    let fichBien = true;
    if (document.getElementById('subirFichero').value === "") {
        let info = document.getElementById('info');
        info.innerHTML = "Se necesita seleccionar un fichero";
        info.style = "color: #ff0000";
        fichBien = false;
    } else {
        //Vamos a ver la variable que se midifica al analizar el fichero al ser subido
        fichBien = ficheroCorrecto;
    }



    return fichBien;

}

function controlRango() {
    //Controla el rango del salto neto
    let saltoAux = document.getElementById('saltoNeto').value;
    let saltoNeto = parseFloat(saltoAux);
    if (saltoNeto < 1 || saltoNeto > 1000) {
        let e2 = document.getElementById('e2');
        e2.style = "color: #ff0000";
        return false;
    } else {
        let e2 = document.getElementById('e2');
        e2.style = "color: black";
    }
    return true;
}

function controlNeto() {
    /*Control necesario para el formulario de salto bruto
     * si se controlan de forma separada, primero da un fallo y una vez
     * corregido evalua el otro.
     * De esta manera muestra todos los fallos a la vez.
     */
    let cf = controlFichero();
    let cr = controlRango();

    return (cr && cf);

}

document.getElementById("subirFichero").addEventListener("change", function (e) {
    //Vamos a comprobar el contenido del fichero cuando se suba
    let fichValor = this.value;
    //vamos a ver si el fichero es .twb
    //Para ello vamos a separar el fichero segun los . que se encuentren y vemos si la ultima 
    //division es distinta de twb
    let info = document.getElementById('info');//para colocar el mensaje de error
    let separado = fichValor.split(".");
    if (separado[separado.length - 1] !== "twb") {
        ficheroCorrecto = false;
        info.innerHTML = "Tipo de fichero incorrecto";
        info.style = "color: #ff0000";
    } else {
        let file = e.target.files[0];
        let reader = new FileReader();

        reader.addEventListener('load', function (e) {
            let contenido = e.target.result;
            let divisionContenido = contenido.split("\n+");
            //Con esta funcion veremos si el contenido del fichero es valido
            ficheroCorrecto = comprobarContenido(divisionContenido);
            if (!ficheroCorrecto) {

                info.innerHTML = "Fichero dañado";
                info.style = "color: #ff0000";
            }else{
                //añadimos al input el contenido del fichero
                let fc= document.getElementById('fc');
                fc.value=contenido;
                //añadimos al input el nombre del fichero
                let nfc= document.getElementById('nfc');
                let aux = fichValor.split("\\");
                nfc.value=aux[aux.length-1];
            }
        });

        reader.readAsText(file);
    }
});


function comprobarContenido(cont) {
    let numCaudales = [0, 1, 24, 7, 4, 12, 4];

    let linea1 = cont[0].split(":");
    if (linea1.length > 2 || linea1[1] > 6) {
        return false;
    }

    //miro que el fichero tenga el numero de lineas que deberia

    if (cont.length !== 5 + numCaudales[linea1[1]] + 1) {
        return false;
    }

    let linea3 = cont[2].split(":");
    let linea4 = cont[3].split(":");
    if (linea3.length > 2 || linea4.length > 2) {
        return false;
    }
    //miramos que una coordenada no este vacia y la otra rellena
    if (linea3[1] === "" && linea4[1] !== "") {
        return false;
    }
    if (linea4[1] === "" && linea3[1] !== "") {
        return false;
    }
    //miramos que las dos coordenadas sean numeros
    if (isNaN(linea3[1]) || isNaN(linea4[1])) {
        return false;
    }
    //comprobamos todos los caudales
    for (var i = 5, max = 5 + numCaudales[linea1[1]]; i < max; i++) {
        if (isNaN(cont[i])) {
            return false;
        }

    }

    return true;
}

            