/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/* global windows */
var fotoSubida = false;
var funcionSubida = false;

document.onload = mostrarPuntos(3);//cargamos por defecto 3 vertices al iniciar la página

function cambiarValorRango() {
    document.getElementById("valorRango").innerHTML = document.getElementById("numVertices").value;
}

function cambiarValorRangoRendimiento() {
    document.getElementById("valorRangoRendimiento").innerHTML = document.getElementById("rendimiento").value+"%";
}

function cambioi() {//Se utiliza para cambiar el boton de subir fotos
    var nombreFichero = document.getElementById('subirImagen').files[0].name;
    let info = document.getElementById('infoi');
    info.innerHTML = nombreFichero;
    info.style = "color: #000000";
    fotoSubida = true;
}

function cambiof() {//Se utiliza para cambiar el boton de subir funcion
    var nombreFichero = document.getElementById('subirFuncion').files[0].name;
    let info = document.getElementById('infof');
    info.innerHTML = nombreFichero;
    info.style = "color: #000000";
    funcionSubida = true;
}

function mostrarPuntos(numVertices) {
    var texto = '';
    for (var i = 1, max = numVertices; i <= max; i++) {//Escribimos cada input en el string
        texto += '<p class="campoFormulario">' +
                '<label class="etiqueta"> Vertice ' + i + '</label>' +
                '<label class="etiqueta2"> Caudal (m³/s) </label>' +
                '<input required id="c' + i + '" class="input" type="text" size="5" pattern="[0-9]+(\.[0-9]+)?"/>' +
                '<label class="etiqueta2"> Salto (m) </label>' +
                '<input required id="s' + i + '" class="input" type="text" size="5" pattern="[0-9]+(\.[0-9]+)?"/>' +
                '</p>';
    }

    document.getElementById('vertices').innerHTML = texto; //Escribimos el string en la pagina
}


function cargarVertices() {
    let contenedor = document.getElementById("cadenaPuntos");
    let cadena = "";
    let numVertices = document.getElementById("numVertices").value;

    for (var i = 1, max = numVertices; i <= max; i++) {
        let c = document.getElementById("c" + i).value;
        let s = document.getElementById("s" + i).value;
        if (isNaN(c) || isNaN(s))
            return false;//si algun valor no es un numero, devolvemos false

        cadena = cadena + c + "," + s;
        if (i < max)
            cadena = cadena + ";";
    }
    contenedor.value = cadena;
    return true;
}

function comprobarDatos() {
    //lanzamos las funciones para que salgan todos los errores a la vez y no solo cada vez que ser compruebe
    let cv = cargarVertices();
    let ci = controlImagen();
    let cf = controlFuncion();

    return (cv && ci && cf);
}


function controlImagen() {
    //Controlamos si se ha dejado vacio la imagen de la trubina
    let fichBien = true;
    let info = document.getElementById('infoi');
    if (document.getElementById('subirImagen').value === "") {
        info.innerHTML = "Se necesita seleccionar un fichero";
        info.style = "color: #ff0000";
        fichBien = false;
    } else {
        //Vamos a ver si la imagen es png
        let fichValor = document.getElementById('subirImagen').files[0].name;
        let separado = fichValor.split(".");
        if (separado[separado.length - 1] !== "png") {
            fichBien = false;
            info.innerHTML = "Tipo de fichero incorrecto";
            info.style = "color: #ff0000";
        }
    }

    if (fichBien) {
        info.innerHTML = "";
    }

    return fichBien;

}

function controlFuncion() {
    //Controlamos si se ha dejado vacio la imagen de la trubina
    let fichBien = true;
    let info = document.getElementById('infof');
    if (document.getElementById('subirFuncion').value !== "") {
        //Vamos a ver si la funcion sea png si se ha subido alguna
        let fichValor = document.getElementById('subirFuncion').files[0].name;
        let separado = fichValor.split(".");
        if (separado[separado.length - 1] !== "png") {
            fichBien = false;
            info.innerHTML = "Tipo de fichero incorrecto";
            info.style = "color: #ff0000";
        }
    }

    if (fichBien) {
        info.innerHTML = "";
    }

    return fichBien;

}


