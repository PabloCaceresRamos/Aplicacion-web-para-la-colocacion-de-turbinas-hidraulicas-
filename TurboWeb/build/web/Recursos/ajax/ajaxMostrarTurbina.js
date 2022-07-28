


var xhr;



function init_ajax(){
    if (window.XMLHttpRequest) {
        xhr = new XMLHttpRequest();
    } else if (window.ActiveXObject) {
        xhr = new ActiveXObject("Microsoft.XMLHTTP");
    }   
    
}
//Ajax para eliminar turbina
function eliminarTurbina(id){
    //Solicitamos una confirmacion para eliminar la turbina
                if(window.confirm("Se va a eliminar la turbina de la base de datos"))
                {
                    eliminar(id);
                }
            }

function eliminar(id) {

    init_ajax();
    
    var url = "EliminarTurbina";
    xhr.open("POST", url, true);
    xhr.onreadystatechange = turbinasrestantes;

    var datos = "id=" + encodeURIComponent(id);
            
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.send(datos);

}

function turbinasrestantes() {
    if (xhr.readyState === 4) {
        if (xhr.status === 200) {
            document.getElementById("tpropia").innerHTML = xhr.responseText;
        }
    }

}

//Fin ajax eliminar turbina

//Ajax para bloquear y desbloquear turbina
var idVar;
function ponerBloqueo(id){
     init_ajax();
    idVar=id;
    var url = "BloquearTurbina";
    xhr.open("POST", url, true);
    xhr.onreadystatechange = actualizarTurbinaCambiada;

    var datos = "id=" + encodeURIComponent(id);
            
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.send(datos);
}

function quitarBloqueo(id){
     init_ajax();
    idVar=id;
    var url = "DesbloquearTurbina";
    xhr.open("POST", url, true);
    xhr.onreadystatechange = actualizarTurbinaCambiada;

    var datos = "id=" + encodeURIComponent(id);
            
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.send(datos);
}

function actualizarTurbinaCambiada() {
    if (xhr.readyState === 4) {
        if (xhr.status === 200) {
            document.getElementById("check"+idVar).innerHTML = xhr.responseText;
        }
    }
}