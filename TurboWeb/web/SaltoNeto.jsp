<%-- 
    Document   : SaltoNeto
    Created on : 21-mar-2021, 17:59:55
    Author     : pablo
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>TuhiWeb/Salto Neto</title>
        <link rel="shortcut icon" href="/TurboWeb/Recursos/Imagenes/favicon.ico">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.0/font/bootstrap-icons.css">

        <link href="/TurboWeb/Recursos/Css/Formularios.css" rel="stylesheet" type="text/css"/>
        <link href="/TurboWeb/Recursos/Css/General.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>

          <nav class="navbar navbar-light bg-light sticky-top">

            <div class="nav-item dropdown dropright" >
                <a  href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <span class="botonNav">Menú</span>
                    <span class="bi bi bi-list" style="color:black"></span>
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="/TurboWeb/Controlador/home">Inicio</a>
                    <a class="dropdown-item" href="/TurboWeb/Controlador/SaltoNeto">Calcular con salto neto</a>
                    <a class="dropdown-item" href="/TurboWeb/Controlador/SaltoBruto">Calcular con salto bruto</a>
                    <a class="dropdown-item" href="/TurboWeb/Controlador/Fichero">Generar ficheros de caudal</a>
                    <a class="dropdown-item" href="/TurboWeb/Controlador/mostrarTurbinas">Mostrar turbinas disponibles</a>
                    

                    <c:choose>
                        <c:when test="${sessionScope.nombre!=null}">
                            <a class="dropdown-item" href="/TurboWeb/Controlador/CrearTurbinaPantalla">Crear turbina</a>
                            <a class="dropdown-item" href="/TurboWeb/Controlador/VerCalculos">Historial de cálculos</a>
                            <a class="dropdown-item" href="/TurboWeb/Controlador/resultado">Último resultado</a>
                        </c:when>
                    </c:choose>
                </div>
            </div>

            <a class="navbar-brand" href="#">TuhiWeb</a>

            <div class="nav-item dropdown dropleft">
                <a  href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <span class="bi bi-person-fill" style="color:black"></span>
                    <c:choose>
                        <c:when test="${sessionScope.nombre==null}">
                            <span class="botonNav">Sesión</span>
                        </c:when>
                        <c:otherwise> 
                            <span class="botonNav">${sessionScope.nombre}</span>
                        </c:otherwise>
                    </c:choose>
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">



                    <c:choose>
                        <c:when test="${sessionScope.nombre==null}">
                            <a class="dropdown-item" href="/TurboWeb/Controlador/Registrarse">Registrarse</a>
                            <a class="dropdown-item" href="/TurboWeb/Controlador/login">Iniciar sesión</a>
                        </c:when>
                        <c:otherwise> 
                            <a class="dropdown-item" href="/TurboWeb/Controlador/CambiarContrasenaBoton">Cambiar contraseña</a>
                            <a class="dropdown-item" href="/TurboWeb/Controlador/PantallaCambiarCorreo">Cambiar correo</a>
                            <a class="dropdown-item" href="/TurboWeb/Controlador/CerrarSesion">Cerrar sesion</a>
                            <a class="dropdown-item" href="/TurboWeb/Controlador/EliminarCuentaVista">Eliminar cuenta</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </nav>


        <section class="row" style="margin-top:10px">

            <div class=" col-lg-7 col-md-6 divImagen ">
                <img src="/TurboWeb/Recursos/ImagenesGraficas/TODAS.png" alt="" height="auto" width="95%"/>
            </div >


            <form  class=" col-lg-5 col-md-6 p" action="/TurboWeb/Controlador/CalculoConSaltoNeto" method="POST"  onsubmit="return controlNeto()">
                <div class="f">
                    <h2 class="titulo">Calcular con salto neto</h2>
                    <c:choose>
                        <c:when test="${sessionScope.nombre!=null}">
                            <p class="campoFormulario"><!--Solo sale al tener la sesión iniciada-->
                                <label class="etiqueta">Nombre de la operacion</label>
                                <input required  id="nombre" name="nombre" type="text" />
                            </p>
                        </c:when>
                    </c:choose>
                    <p class="campoFormulario">
                        <label class="etiqueta">Salto neto (m)</label>
                        <input required id="saltoNeto" name="saltoNeto"type="text" size="5" pattern="[0-9]+(\.[0-9]+)?"/>
                        <label id="e2" class="etiqueta2">Rango valido: (1-1000)</label>
                    </p>
                    <p class="campoFormulario">
                        <label class="etiqueta">Caudal</label>
                        <label for="subirFichero" class="subir">
                            <i class="fas fa-could-upload-alt"></i> Añadir fichero
                        </label>
                        <input id="subirFichero" type="file" value="" accept=".twb" onchange="cambio()" />
                        <input id="fc" name="ficheroCaudal" type="text" style="display: none"/><!-- Este input es el encargado de mandar al servidor el contenido del fichero -->
                        <input id="nfc" name="nombreFichero" type="text" style="display: none"/>
                        <a id="e2f" href="/TurboWeb/Controlador/InformacionFichero" target="_blank" class="etiqueta2">Fichero .twb</a>
                    <div class="centrado" id="info"></div>
                    <a class=" enlaceGF centrado" href="/TurboWeb/GenerarFichero.jsp?p=n">¿No tienes fichero .twb?</a>

                    </p>



                    <p class="enviar">
                        <input  type="submit" value="Calcular" />
                    </p>
                </div>
            </form>

        </section>

        <footer>
            <p style="margin-right:1%;">
                Pablo Cáceres Ramos &copy; 2020
            </p>
        </footer>

        <script><!-- funcion para el boton de subir fichero -->

            function cambio() {
                var nombreFichero = document.getElementById('subirFichero').files[0].name;
                let info = document.getElementById('info');
                info.innerHTML = nombreFichero;
                info.style = "color: #000000";
            }



        </script>
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>
        <script src="/TurboWeb/Recursos/js/funcionesFormularios.js" type="text/javascript"></script>
    </body>
</html>
