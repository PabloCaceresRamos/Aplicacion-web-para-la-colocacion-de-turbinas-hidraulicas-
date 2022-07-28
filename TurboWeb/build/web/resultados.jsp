<%-- 
    Document   : resultados
    Created on : 29-mar-2021, 21:08:14
    Author     : pablo
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<html>
    <head>
        <title>TuhiWeb/Resultados</title>
        <link rel="shortcut icon" href="/TurboWeb/Recursos/Imagenes/favicon.ico">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.0/font/bootstrap-icons.css">
        <%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

        <link href="/TurboWeb/Recursos/Css/General.css" rel="stylesheet" type="text/css"/>
        <link href="/TurboWeb/Recursos/Css/resultados.css" rel="stylesheet" type="text/css"/>
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


        <section style="background: rgba(224,255,255,0.5) " >
            <h1 class="titulo">Resultados del cálculo</h1>
            <div class="row">
                <c:choose>
                    <c:when test="${!empty sessionScope.resultado}">
                        <div class="marcador col-lg-12">
                            <h3>Calcular potencia anual generada </h3>
                            <label class="">Horas diarias de funcionamiento: </label>
                            <input required id="horas" type="text" size="5" pattern="[0-9]+(\.[0-9]+)?"/>
                            <label id="error"></label>
                            <input class="botonPotenciaAnual" type="button" value="Calcular potencia anual" onclick="controlHoras()" />

                        </div>
                        <c:set var="i" value="-1" />
                        <c:forEach var="turb" items="${sessionScope.resultado}">
                            <c:set var="i" value="${i + 1}" scope="page"/>
                            <div class="col-md-4 col-sm-6 col-zm-12 centrado" style="margin-top: 30px">
                                <a href="#">
                                    <center><img src="/TurboWeb/Recursos/TurbinasImagenes/${turb.id}.png" class=" img"  alt="No hay imágenes" /></center>
                                    <div style="background-color: rgba(210,255,255,1); color: black; margin: 0% 10% 0% 10%;">
                                        <center><label style="margin-top: 10px"><h5>Nombre: ${turb.nombre}</h5></label></center>
                                        <center><label><h5>Tipo: ${turb.tipo}</h5></label></center>
                                        <center><label><h5>Potencia:
                                                    <c:choose>
                                                        <c:when test="${sessionScope.potencias[i] >= 1000}">${sessionScope.potencias[i]/1000} MW</c:when>
                                                        <c:when test="${sessionScope.potencias[i] < 1}">${sessionScope.potencias[i]*1000} W</c:when>
                                                        <c:otherwise>${sessionScope.potencias[i]} kW</c:otherwise>
                                                    </c:choose>
                                                </h5></label></center>
                                        <center><label><h5 id="pa${i}"></h5></label></center>
                                        <label id="p${i}" style="display:none;">${sessionScope.potencias[i]}</label> <!-- Lo utilizo para saber que potencia en KW tiene la turbina -->
                                    </div>
                                </a>
                            </div>
                        </c:forEach>
                        <label id="numTurbinas" style="display:none;">${i+1}</label><!-- Lo utilizo para saber el numero de turbinas en js -->
                    </c:when>
                </c:choose>

            </div>
            <c:choose>
                <c:when test="${empty sessionScope.calculoRealizado}">
                    <p class="noTurbinas">No hay calculos en la sesión</p>
                    <label id="numTurbinas" style="display:none;">0</label><!-- Lo utilizo para saber el numero de turbinas en js -->
                </c:when>
                <c:otherwise> 
                    <c:choose>
                        <c:when test="${empty sessionScope.resultado}">
                            <p class="noTurbinas">No hay turbinas disponibles</p>
                            <label id="numTurbinas" style="display:none;">0</label><!-- Lo utilizo para saber el numero de turbinas en js -->
                        </c:when>
                    </c:choose>
                </c:otherwise>
            </c:choose>

        </section>

        <footer>
            <p style="margin-right:1%;">
                Pablo Cáceres Ramos &copy; 2020
            </p>
        </footer>

        <script src="/TurboWeb/Recursos/js/resultado.js" type="text/javascript"></script>
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>
    </body>
</html>