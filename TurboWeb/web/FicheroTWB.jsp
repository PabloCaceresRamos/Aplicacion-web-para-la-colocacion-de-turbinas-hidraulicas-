<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<html>
    <head>
        <title>TuhiWeb/Informaci�n fichero</title>
        <link rel="shortcut icon" href="/TurboWeb/Recursos/Imagenes/favicon.ico">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.0/font/bootstrap-icons.css">

        <link href="/TurboWeb/Recursos/Css/General.css" rel="stylesheet" type="text/css"/>
        <link href="/TurboWeb/Recursos/Css/Formularios.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>

         <nav class="navbar navbar-light bg-light sticky-top">

            <div class="nav-item dropdown dropright" >
                <a  href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <span class="botonNav">Men�</span>
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
                            <a class="dropdown-item" href="/TurboWeb/Controlador/VerCalculos">Historial de c�lculos</a>
                            <a class="dropdown-item" href="/TurboWeb/Controlador/resultado">�ltimo resultado</a>
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
                            <span class="botonNav">Sesi�n</span>
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
                            <a class="dropdown-item" href="/TurboWeb/Controlador/login">Iniciar sesi�n</a>
                        </c:when>
                        <c:otherwise> 
                            <a class="dropdown-item" href="/TurboWeb/Controlador/CambiarContrasenaBoton">Cambiar contrase�a</a>
                            <a class="dropdown-item" href="/TurboWeb/Controlador/PantallaCambiarCorreo">Cambiar correo</a>
                            <a class="dropdown-item" href="/TurboWeb/Controlador/CerrarSesion">Cerrar sesion</a>
                            <a class="dropdown-item" href="/TurboWeb/Controlador/EliminarCuentaVista">Eliminar cuenta</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </nav>


        <section class="row" style="margin-top: 0%;">
            
            <div class=" col-lg-7 col-md-8 pPortada" style="background: rgba(224,255,255,0.8);">
                <div class="f">
                    <h2 class="titulo">Fichero .twb</h2>
                    
                    <p class="textoPortada">Para realizar los c�lculos en la aplicaci�n web, hemos dise�ado un fichero de texto plano propio con la extensi�n &quot.twb&quot, el cual contendr� toda la informaci�n sobre los caudales y la ubicaci�n de donde se ha tomado la muestra.</p>
                    <p class="textoPortada" style="margin-top: 50px;">Est� fichero es creado en la pantalla de <a href="/TurboWeb/Controlador/Fichero" target="_blank">Generac�on de ficheros</a> rellenando todos los campos solicitados y ayud�ndose de un mapa para facilitar la selecci�n de las coordenadas en el caso que queramos a�adirle una ubicaci�n.</p>
                    <p class="textoPortada" style="margin-top: 50px;">La estructura interna del fichero se basa en 5 campos: Tipo de fichero, Localizac�on, Latitud, Longitud y Caudales. Solo los campos &quotTipo de fichero &quot y &quotCaudales&quot son estrictamente obligatorios. Aunque, en el caso de rellenar el campo &quotLatitud&quot o &quotLongitud&quot los dos se vuelven obligatorios.</p>

                </div>
            </div>
            <div class=" col-lg-5 col-md-4 divImagen ">
                <img src="/TurboWeb/Recursos/Imagenes/ficheroPruebas.png" alt=""width="auto" height="70%"/>
            </div >
        </section>



    </section>

    <footer>
        <p style="margin-right:1%;">
            Pablo C�ceres Ramos &copy; 2020
        </p>
    </footer>


    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>
</body>
</html>