<%-- 
    Document   : resultados
    Created on : 29-mar-2021, 21:08:14
    Author     : pablo
--%>
<%@page import="java.util.Calendar"%>
<%@page import="TablasBD.Turbinas"%>
<%@page import="java.util.ArrayList"%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<html>
    <head>
        <title>TuhiWeb/Mostrar turbinas</title>
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
            <h1 class="titulo">Historial de cálculos</h1>

            <div class="row" style=" background: rgba(224,255,255,0.8); margin-top: 5%; margin-bottom: 2%">
                <h3 class="titulo col-sm-12" style="margin-bottom: 20px">Filtro</h3>
                <div class="col-sm-6 col-zm-12">

                    <table style="margin-left: auto; margin-right: auto;margin-bottom: 2%;">
                        <tr>
                            <td>Nombre:</td>
                            <td><input id="nombreFiltro" type="text" size="20" style="margin-left: 20px" onchange="AplicarFiltro()"/></td>
                        </tr>
                    </table>

                </div>

                <div class="col-sm-6 col-zm-12">
                    <table style="margin-left: auto; margin-right: auto; margin-bottom: 5%;">
                        <tr>
                            <td>Ordenar:</td>
                            <td>
                                <select id="ordenFiltro" style="margin-left: 20px" onchange="AplicarFiltro()" >
                                    <option value='0'></option>
                                    <option value='1'>Fecha ascendente</option>
                                    <option value='2'>Fecha descendente</option>
                                </select>
                        </tr>
                    </table>
                </div>
            </div>
            <div id="resultado">
                <div class="row" >
                <div class="marcador col-lg-12">
                    <h3>Cálculos con salto neto </h3>
                </div>
                <c:choose>
                    <c:when test="${!empty requestScope.calculosSN}">
                        <c:set var="i" value="-1" />
                        <c:forEach var="calculo" items="${requestScope.calculosSN}">
                            <c:set var="i" value="${i + 1}" scope="page"/>
                            <div id="c${calculo.id}" class="col-lg-4 col-sm-6 col-zm-12 centrado" style="margin-top: 30px">
                                <p>
                                <div style="background-color: rgba(210,255,255,1); color: black; margin: 0% 10% 0% 10%;">
                                    <center> <table>
                                            <tr><td><h5>Nombre:</h5></td> <td><h4>${calculo.nombre}</h4></td></tr>
                                            <tr><td><h5>Salto Neto:  </h5></td><td><h5>${calculo.salto} m</h5></td></tr>
                                            <tr><td><h5 style="margin-right: 20px;">Fichero utilizado:</h5></td><td><h5><a href="/TurboWeb/Controlador/VerFichero?n=${calculo.id}">${calculo.ficheroCaudal.nombre}</a></h5></td></tr>
                                                        <c:set var="fechaAux" value="${calculo.fecha}" />
                                                        <%
                                                            Calendar fecha = (Calendar) pageContext.getAttribute("fechaAux");
                                                            out.println(" <tr><td><h5>Fecha:  </h5></td><td><h5>" + fecha.get(Calendar.DAY_OF_MONTH) + "/" + fecha.get(Calendar.MONTH) + "/" + fecha.get(Calendar.YEAR) + "</h5></td></tr>");
                                                            out.println(" <tr><td><h5>Hora:  </h5></td><td><h5>" + fecha.get(Calendar.HOUR_OF_DAY) + ":" + fecha.get(Calendar.MINUTE) + "</h5></td></tr>");
                                                        %>
                                        </table></center>
                                    <center>
                                        <input type="button" value="Ver resultado" onclick="location.href = '/TurboWeb/Controlador/VerCalculoGuardado?n=${calculo.id}'" style="margin-bottom: 3%">
                                        <input type="button" value="Eliminar calculo" onclick="eliminarCalculo(${calculo.id})" style="margin-bottom: 3%">
                                    </center>
                                </div>
                                </p>
                            </div>
                        </c:forEach>
                    </c:when>
                </c:choose>

            </div>
            <div class="row" style="margin-top: 50px">
                <div class="marcador col-lg-12">
                    <h3>Cálculos con salto bruto</h3>
                </div>



                <c:choose>
                    <c:when test="${!empty requestScope.calculosSB}">

                        <c:set var="i" value="-1" />
                        <c:forEach var="calculo" items="${requestScope.calculosSB}">
                            <c:set var="i" value="${i + 1}" scope="page"/>
                            <div id="c${calculo.id}" class="col-lg-4 col-sm-6 col-zm-12 centrado" style="margin-top: 30px">
                                <p>
                                <div  style="background-color: rgba(210,255,255,1); color: black; margin: 0% 10% 0% 10%;">
                                    <center> <table>
                                            <tr><td><h5>Nombre:</h5></td> <td><h4>${calculo.nombre}</h4></td></tr>
                                            <tr><td><h5>Salto Bruto:  </h5></td><td><h5>${calculo.salto} m</h5></td></tr>
                                            <tr><td><h5>Longitud tubería: </h5></td><td><h5>${calculo.longitud} m</h5></td></tr>
                                            <tr><td><h5>Diámetro tubería:  </h5></td><td><h5>${calculo.diametro} m</h5></td></tr>
                                            <tr><td><h5>Coeficiente tubería:</h5></td><td><h5>${calculo.tipoTurberia}</h5></td></tr>
                                            <tr><td><h5 style="margin-right: 20px;">Fichero utilizado:</h5></td><td><h5><a href="/TurboWeb/Controlador/VerFichero?n=${calculo.id}">${calculo.ficheroCaudal.nombre}</a></h5></td></tr>
                                                        <c:set var="fechaAux" value="${calculo.fecha}" />
                                                        <%
                                                            Calendar fecha2 = (Calendar) pageContext.getAttribute("fechaAux");
                                                            out.println(" <tr><td><h5>Fecha:  </h5></td><td><h5>" + fecha2.get(Calendar.DAY_OF_MONTH) + "/" + fecha2.get(Calendar.MONTH) + "/" + fecha2.get(Calendar.YEAR) + "</h5></td></tr>");
                                                            out.println(" <tr><td><h5>Hora:  </h5></td><td><h5>" + fecha2.get(Calendar.HOUR_OF_DAY) + ":" + fecha2.get(Calendar.MINUTE) + "</h5></td></tr>");
                                                        %>
                                        </table></center>
                                    <center>
                                        <input type="button" value="Ver resultado" onclick="location.href = '/TurboWeb/Controlador/VerCalculoGuardado?n=${calculo.id}'" style="margin-bottom: 3%">
                                        <input type="button" value="Eliminar calculo" onclick="eliminarCalculo(${calculo.id})" style="margin-bottom: 3%">
                                    </center>
                                </div>
                                </p>
                            </div>
                        </c:forEach>
                    </c:when>
                </c:choose>

            </div>
            </div>
        </section>

        <footer>
            <p style="margin-right:1%;">
                Pablo Cáceres Ramos &copy; 2020
            </p>
        </footer>


        <script src="/TurboWeb/Recursos/js/resultado.js" type="text/javascript"></script>
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>
        <script src="/TurboWeb/Recursos/ajax/ajaxVerCalculos.js" type="text/javascript"></script>
    </body>
</html>