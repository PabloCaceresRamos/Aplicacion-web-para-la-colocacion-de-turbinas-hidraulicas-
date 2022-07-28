<%-- 
    Document   : resultados
    Created on : 29-mar-2021, 21:08:14
    Author     : pablo
--%>
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
            <h1 class="titulo">Turbinas disponibles</h1>
            <div id="tpropia" class="row">

                <c:choose>
                    <c:when test="${!empty requestScope.turbinasPropias}">
                        <div class="marcador col-lg-12">
                            <h3>Turbinas del usuario </h3>
                        </div>
                        <c:set var="i" value="-1" />
                        <c:forEach var="turb" items="${requestScope.turbinasPropias}">
                            <c:set var="i" value="${i + 1}" scope="page"/>
                            <div class="col-md-4 col-sm-6 col-zm-12 centrado" style="margin-top: 30px">
                                <p>
                                <center>  <div  id="carouselExampleIndicators${i}propia" class="carousel slide" data-ride="carousel" data-interval="false" style="margin: 1% 5% 5% 5%;">

                                        <div class="carousel-inner">
                                            <div class="carousel-item active">
                                                <img class="img" src="/TurboWeb/Recursos/TurbinasImagenes/${turb.id}.png" alt=""/>
                                            </div>
                                            <c:choose>
                                                <c:when test="${turb.grafica}">
                                                    <div class="carousel-item">
                                                        <img class="img" src="/TurboWeb/Recursos/TurbinasGraficas/${turb.id}.png" alt=""/>
                                                    </div>
                                                </c:when>
                                            </c:choose>

                                        </div>
                                        <a class="carousel-control-prev" href="#carouselExampleIndicators${i}propia" role="button" data-slide="prev">
                                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                            <span class="sr-only">Previous</span>
                                        </a>
                                        <a class="carousel-control-next" href="#carouselExampleIndicators${i}propia" role="button" data-slide="next">
                                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                            <span class="sr-only">Next</span>
                                        </a>
                                    </div></center>
                                <div style="background-color: rgba(210,255,255,1); color: black; margin: 0% 10% 0% 10%;">
                                    <center><label style="margin-top: 10px"><h5>Nombre: ${turb.nombre}</h5></label></center>
                                    <center><label><h5>Tipo: ${turb.tipo}</h5></label></center>
                                    <center><label><h5>Eficiencia: ${turb.eficiencia} %</h5></label></center>
                                                <c:choose>
                                                    <c:when test="${sessionScope.nombre!=null}">
                                            <div id="check${turb.id}">
                                                <c:set var="idAux" value="${turb.id}" />         
                                                <%
                                                    //Miramos si las turbinas estan bloqueadas o disponibles y lo marcamos en el chech
                                                    ArrayList<Integer> listaBloqueos = (ArrayList<Integer>) session.getAttribute("turbinasBloqueadas");
                                                    boolean encontrado = false;
                                                    Integer idT = (Integer) pageContext.getAttribute("idAux");
                                                    if (listaBloqueos != null) {
                                                        for (Integer idB : listaBloqueos) {
                                                            if (idB.intValue() == idT.intValue()) {
                                                                encontrado = true;
                                                            }
                                                        }
                                                    }
                                                    if (encontrado) {
                                                        out.println("<center><p style=\"padding-bottom: 3%;\">Disponible <input type=\"checkbox\" onchange=\"quitarBloqueo(" + idT + ")\"/></p></center>");
                                                    } else {
                                                        out.println("<center><p style=\"padding-bottom: 3%;\">Disponible <input type=\"checkbox\" checked=\"true\" onchange=\"ponerBloqueo(" + idT + ")\"/></p></center>");
                                                    }
                                                %>
                                            </div>
                                        </c:when>
                                    </c:choose>
                                    <center><input type="button" value="Eliminar turbina" onclick="eliminarTurbina(${turb.id})" style="margin-bottom: 3%"></center>

                                </div>
                                </p>
                            </div>
                        </c:forEach>
                    </c:when>
                </c:choose>

            </div>
            <div class="row">
                <div class="marcador col-lg-12">
                    <h3>Turbinas predeterminadas </h3>
                </div>
                <c:choose>
                    <c:when test="${!empty requestScope.turbinasPredeterminadas}">
                        <c:set var="i" value="-1" />
                        <c:forEach var="turb" items="${requestScope.turbinasPredeterminadas}">
                            <c:set var="i" value="${i + 1}" scope="page"/>
                            <div class="col-md-4 col-sm-6 col-zm-12 centrado" style="margin-top: 30px">
                                <p>
                                <center>  <div  id="carouselExampleIndicators${i}p" class="carousel slide" data-ride="carousel" data-interval="false" style="margin: 1% 5% 5% 5%;">

                                        <div class="carousel-inner">
                                            <div class="carousel-item active">
                                                <img class="img" src="/TurboWeb/Recursos/TurbinasImagenes/${turb.id}.png" alt=""/>
                                            </div>
                                            <c:choose>
                                                <c:when test="${turb.grafica}">
                                                    <div class="carousel-item">
                                                        <img class="img" src="/TurboWeb/Recursos/TurbinasGraficas/${turb.id}.png" alt=""/>
                                                    </div>
                                                </c:when>
                                            </c:choose>

                                        </div>
                                        <a class="carousel-control-prev" href="#carouselExampleIndicators${i}p" role="button" data-slide="prev">
                                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                            <span class="sr-only">Previous</span>
                                        </a>
                                        <a class="carousel-control-next" href="#carouselExampleIndicators${i}p" role="button" data-slide="next">
                                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                            <span class="sr-only">Next</span>
                                        </a>
                                    </div></center>
                                <div style="background-color: rgba(210,255,255,1); color: black; margin: 0% 10% 0% 10%;">
                                    <center><label style="margin-top: 10px"><h5>Nombre: ${turb.nombre}</h5></label></center>
                                    <center><label><h5>Tipo: ${turb.tipo}</h5></label></center>
                                    <center><label><h5>Eficiencia: ${turb.eficiencia} %</h5></label></center>
                                                <c:choose>
                                                    <c:when test="${sessionScope.nombre!=null}">
                                            <div id="check${turb.id}">
                                                <c:set var="idAux" value="${turb.id}" />                
                                                <%
                                                    //Miramos si las turbinas estan bloqueadas o disponibles y lo marcamos en el chech
                                                    ArrayList<Integer> listaBloqueos2 = (ArrayList<Integer>) session.getAttribute("turbinasBloqueadas");
                                                    boolean encontrado2 = false;
                                                    Integer idT2 = (Integer) pageContext.getAttribute("idAux");
                                                    if (listaBloqueos2 != null) {
                                                        for (Integer idB : listaBloqueos2) {
                                                            if (idB.intValue() == idT2.intValue()) {
                                                                encontrado2 = true;
                                                            }
                                                        }
                                                    }
                                                    if (encontrado2) {
                                                        out.println("<center><p style=\"padding-bottom: 3%;\">Disponible <input type=\"checkbox\" onchange=\"quitarBloqueo(" + idT2 + ")\"/></p></center>");
                                                    } else {
                                                        out.println("<center><p style=\"padding-bottom: 3%;\">Disponible <input type=\"checkbox\" checked=\"true\" onchange=\"ponerBloqueo(" + idT2 + ")\"/></p></center>");
                                                    }
                                                %>
                                            </div>
                                        </c:when>
                                    </c:choose>
                                </div>
                                </p>
                            </div>
                        </c:forEach>
                    </c:when>
                </c:choose>

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
        <script src="/TurboWeb/Recursos/ajax/ajaxMostrarTurbina.js" type="text/javascript"></script>
    </body>
</html>