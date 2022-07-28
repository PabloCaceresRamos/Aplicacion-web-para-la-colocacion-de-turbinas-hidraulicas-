

var xhr;



function init_ajax(){
    if (window.XMLHttpRequest) {
        xhr = new XMLHttpRequest();
    } else if (window.ActiveXObject) {
        xhr = new ActiveXObject("Microsoft.XMLHTTP");
    }   
    
}

//Ajax para eliminar calculo
function eliminarCalculo(id){
    //Solicitamos una confirmacion para eliminar el calculo
                if(window.confirm("Se va a eliminar el calculo de la base de datos"))
                {
                    document.getElementById("c"+id).style.display="none";
                    eliminar(id);
                }
            }

function eliminar(id) {

    init_ajax();
    
    var url = "EliminarCalculo";
    xhr.open("POST", url, true);
    xhr.onreadystatechange = calculosrestantes;

    var datos = "id=" + encodeURIComponent(id);
            
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.send(datos);

}

function calculosrestantes() {
    if (xhr.readyState === 4) {
        if (xhr.status === 200) {
            //document.getElementById("error").innerHTML = xhr.responseText;
        }
    }

}

function AplicarFiltro() {

    init_ajax();
    
    var url = "VerCalculoFiltro";
    xhr.open("POST", url, true);
    xhr.onreadystatechange = mostrarResultadoFiltro;

    var nombre = document.getElementById("nombreFiltro");
    var orden = document.getElementById("ordenFiltro");
    
    var datos = "nombreFiltro=" + encodeURIComponent(nombre.value) +
            "&orden=" + encodeURIComponent(orden.value);
    
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.send(datos);

}

function mostrarResultadoFiltro() {
    if (xhr.readyState === 4) {
        if (xhr.status === 200) {
            document.getElementById("resultado").innerHTML = xhr.responseText;
        }
    }

}