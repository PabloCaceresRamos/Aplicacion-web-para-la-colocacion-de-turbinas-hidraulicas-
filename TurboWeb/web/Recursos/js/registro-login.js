


function contrasenasIguales() {
                let passw1 = document.getElementById("passw1");
                let passw2 = document.getElementById("passw2");
                let error = document.getElementById("error");
                let errorS = document.getElementById("errorServidor");
                if(passw1.value === passw2.value) {
                    if(errorS!==null)error.style.display="none";
                    errorS.style.display="none";
                    return true;
                }
                else{
                    if(errorS!==null)errorS.style.display="none";
                    error.style.display="block";
                    error.innerHTML="Las contrase&ntilde;as deben coincidir";
                    return false;
                }

            }
