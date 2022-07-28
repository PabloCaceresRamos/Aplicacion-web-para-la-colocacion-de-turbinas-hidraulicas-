<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<html>
    <head>
        <title>TuhiWeb/Inicio</title>
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


        <section class="row">
             <c:if test="${requestScope.mensajeError!=null}"><div class="mensajeErrorhome col-lg-12">${requestScope.mensajeError}</div></c:if>
             <c:if test="${requestScope.mensaje!=null}"><div class="mensajehome col-lg-12">${requestScope.mensaje}</div></c:if>
            <div class=" col-lg-12 logo"> <img src="/TurboWeb/Recursos/Imagenes/logo.png" alt="" style="max-width: 20%; height: auto; padding: 20px 0px 20px 0px"/></div>
            
            <div class=" col-lg-5 col-md-6 pPortada">
                <!--enctype="multipart/form-data"-->
                <img src="/TurboWeb/Recursos/Imagenes/celesteDegradado.png" alt="" width="100%" height="100%" style="z-index: -1; position: absolute"/>
                <div class="f">
                    <h2 class="titulo">Bienvenido</h2>
                    
                    <p class="textoPortada"> La energía hidráulica es una fuente de producción de energía "natural" que debe considerarse 
                        como una fuente óptima de energía para producir energía eléctrica.  El ahorro potencial de energía y el impacto de 
                        estas alternativas sobre la eficiencia energética de los sistemas de suministro de agua son muy variables (Vilanova 2014),
                        dependiendo de su ubicación, ya que en cada una de ellas nos encontramos con un caudal y un salto neto diferente.</p>
                  
                </div>
            </div>
            
            <div class=" col-lg-7 col-md-6 divImagen ">
                <div  id="carouselExampleIndicators" class="carousel slide" data-ride="carousel" data-interval="false" style="margin: 1% 5% 5% 5%;">
                    <ol class="carousel-indicators">
                        <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
                        <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
                        <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
                    </ol>
                    <div class="carousel-inner">
                        <div class="carousel-item active">
                            <img src="/TurboWeb/Recursos/ImagenesGraficas/pats.png" alt=""width="100%" height="100%"/>
                        </div>
                        <div class="carousel-item">
                            <img src="/TurboWeb/Recursos/ImagenesGraficas/BankiFrancias.png" alt=""width="100%" height="100%"/>
                        </div>
                        <div class="carousel-item">
                            <img src="/TurboWeb/Recursos/ImagenesGraficas/peltonkaplan.png" alt=""width="100%" height="100%"/>
                        </div>
                        <div class="carousel-item">
                            <img src="/TurboWeb/Recursos/ImagenesGraficas/turgogimp.png" alt=""width="100%" height="100%"/>
                        </div>

                    </div>
                    <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="sr-only">Previous</span>
                    </a>
                    <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="sr-only">Next</span>
                    </a>
                </div>
            </div >


            
            
            <div class="bloquetextoP2">
                <h2 class="titulo2p">¿Qué es TuhiWeb?</h2>
                
                <p class="textoPortada2">TuhiWeb es una aplicación web encargada de seleccionar
                    turbinas hidráulicas según los condicionantes hidráulicos de un sistema de distribución 
                    de agua específico. Incluye una base de datos para almacenar la información relativa a las caracteresticas de las turbinas comerciales
                    y los cálculos realizados por los usuarios registrados.</p>
            </div>
            <p style="margin: 20px"> Referencia: Nogueira-Vilanova, M.R.; Perrella-Balestieri, J.A. Energy and hydraulic efficiency in conventional water supply systems. Renewable and Sustainable Energy Reviews 2014, 30, 701-714.
</p>
        </section>



    </section>

    <footer>
        <p style="margin-right:1%;">
            Pablo Cáceres Ramos &copy; 2020
        </p>
    </footer>


    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>
</body>
</html>