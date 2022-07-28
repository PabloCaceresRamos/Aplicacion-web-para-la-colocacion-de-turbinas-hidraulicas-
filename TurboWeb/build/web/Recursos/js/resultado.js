

function controlHoras() {
    //Controla el rango del salto neto
    let horasAux = document.getElementById('horas');
    let horas = parseFloat(horasAux.value);
    let error = document.getElementById('error');
    if (horas < 0 || horas > 24 || horasAux.value==="") {
        error.style.display = "block";
        error.innerHTML = "Horas incorrectas (0-24)h";
    } else {
        error.style.display = "none";
        calcularPotenciaAnual();
    }
}

function calcularPotenciaAnual() {
    let numTurbinas = document.getElementById('numTurbinas').innerHTML;
    let horasAux = document.getElementById('horas');
    let horas = parseFloat(horasAux.value);
    for (let i = 0; i < numTurbinas; i++) {
        let PotenciaAux = document.getElementById('p' + i).innerHTML;
        let numPotenciaAux = parseFloat(PotenciaAux);
        let etiqueta = document.getElementById('pa' + i);
        let potenciaAnual = numPotenciaAux * horas * 365;


        if (potenciaAnual >= 1000)
            etiqueta.innerHTML ="Potencia anual: "+ potenciaAnual / 1000 + " MW";
        else if (potenciaAnual < 1)
            etiqueta.innerHTML ="Potencia anual: "+ potenciaAnual * 1000 + "W";
        else
            etiqueta.innerHTML ="Potencia anual: "+ potenciaAnual + "kW";
    }
}

