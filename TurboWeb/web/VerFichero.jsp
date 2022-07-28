<%-- 
    Document   : GenerarFichero
    Created on : 25-mar-2021, 12:35:46
    Author     : pablo
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>TuhiWeb/Generar fichero</title>
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

        <section>  

            <form  id="formFichero"class=" p pf" onsubmit="return crear()">

                <div class="f1">
                    <h2 class="titulof">Ver fichero de caudal</h2>

                    <c:set var="fich" value="${requestScope.fichero}" />
                    <c:set var="localizacion" value="${requestScope.localizacion}" />

                    <div class="importante">

                        <label class="etiqueta">Nombre del Fichero</label>
                        <input required id="nombre" name="nombre" type="text" value="${fich.nombre}"readonly="readonly" />

                        <p class="campoFormulario">
                            <label class="etiqueta">Tipo de fichero</label>
                            <select required id="tipoFich" name="tipoTuberia" readonly="readonly" >
                                <c:set var="tipoFich" value="${fichero.tipo}" />
                                <%
                                    //Se utiliza para poner automaticamente la opcion del fichero
                                    Integer tipo = (Integer) pageContext.getAttribute("tipoFich");
                                    switch (tipo) {
                                        case 1:
                                            out.print("<option value='1'>Caudal constante</option>");
                                            break;
                                        case 2:
                                            out.print("<option value='2'>Caudal por horas</option>");
                                            break;
                                        case 3:
                                            out.print("<option value='3'>Caudal por dias</option>");
                                            break;
                                        case 4:
                                            out.print("<option value='4'>Caudal por semanas</option>");
                                            break;
                                        case 5:
                                            out.print("<option value='5'>Caudal por meses</option>");
                                            break;
                                        case 6:
                                            out.print("<option value='6'>Caudal por trimestres</option>");
                                            break;
                                    }

                                %>

                            </select>
                        </p> 

                        <p class="campoFormulario">
                            <label class="etiqueta">Localización</label>
                            <input id="localizacion" type="text" value="${localizacion.nombre}" readonly="readonly"/>
                        </p> 

                        <p class="campoFormulario">
                            <label class="etiqueta">Coordenadas</label>
                            <input id="latitud" type="text" size="6" pattern="-?[0-9]+(\.[0-9]+)?" value="${localizacion.latitud}" readonly="readonly"/>
                            <input id="longitud" type="text" size="6"  pattern="-?[0-9]+(\.[0-9]+)?" value="${localizacion.longitud}" readonly="readonly"/>
                        </p> 

                    </div>

                    <div id="casillasFormularios">
                        <c:set var="caudales" value="${fichero.listaCaudales}" />
                        <%                            
                            //Se utiliza para remplazar el js que pone todos los campos caudal segun el tipo de fichero y los rellena con los datos del fichero guardado
                            String caudalesString =(String) pageContext.getAttribute("caudales");
                            String [] caudales=caudalesString.split(";");
                            
                            Integer tipo2 = (Integer) pageContext.getAttribute("tipoFich");
                            String[][] casillas = {{},
                            {"Caudal"},
                            {"Caudal a las 00:00", "Caudal a las 01:00", "Caudal a las 02:00", "Caudal a las 03:00", "Caudal a las 04:00", "Caudal a las 05:00",
                                "Caudal a las 06:00", "Caudal a las 07:00", "Caudal a las 08:00", "Caudal a las 09:00", "Caudal a las 10:00", "Caudal a las 11:00",
                                "Caudal a las 12:00", "Caudal a las 13:00", "Caudal a las 14:00", "Caudal a las 15:00", "Caudal a las 16:00", "Caudal a las 17:00",
                                "Caudal a las 18:00", "Caudal a las 19:00", "Caudal a las 20:00", "Caudal a las 21:00", "Caudal a las 22:00", "Caudal a las 23:00"},
                            {"Caudal del lunes", "Caudal del martes", "Caudal del miercoles", "Caudal del jueves", "Caudal del viernes", "Caudal del sabado", "Caudal del domingo"},
                            {"Caudal semana 1", "Caudal semana 2", "Caudal semana 3", "Caudal semana 4"},
                            {"Caudal de enero", "Caudal de febrero", "Caudal de marzo", "Caudal de abril", "Caudal de mayo", "Caudal de junio", "Caudal de julio", "Caudal de agosto", "Caudal de septiembre", "Caudal de octubre ", "Caudal de noviembre", "Caudal de diciembre"},
                            {"Caudal de primavera", "Caudal de verano", "Caudal de otoño", "Caudal de invierno"}};

                            String texto = "";
                            for (int i = 0; i < casillas[tipo2].length; i++) {
                                texto += "<p class=\"campoFormulario\">"
                                        + "<label class=\"etiqueta\">" + casillas[tipo2][i] + " (m³/s)</label>"
                                        + "<input required id=\"f"+ i +"\" class=\"input\" type=\"text\" size=\"5\" pattern=\"[0-9]+(\\.[0-9]+)?\" value=\""+caudales[i]+"\" readonly=\"readonly\"/>"
                                        + "</p>";
                            }

                            out.print(texto);
                        %>



                    </div>

                    <p class="enviar enviarf">
                        <input class="create" type="submit" value="Crear fichero" />
                        <input id="volver" class="enviarf" type="button" value="Volver"/>
                        <a download="${fichero.nombre}" id="downloadlink" style="display: none">Descargar</a>
                        
                    </p>
                    
                    


                </div>
            </form>

            <div class=" zonaMapa row" id="zmapa">
                <div class="mapa col-sm-6"> 
                    <div class="cerrarMapa">
                        <input type="button" value="X" id="botonCerrarMapa" onclick="cerrarMapa()" />
                    </div>
                    <div id="map" style="height: 100%; width: 100%"></div>
                </div><!--Donde aparece el google map-->
                <input type="button" value="X" id="botonCerrarMap" onclick="cerrarMapa()" />
            </div>
        </section>



        <footer>
            <p style="margin-right:1%;">
                Pablo Cáceres Ramos &copy; 2020
            </p>
        </footer>


        <script>
            //esta funcion no pasarla a ningun fichero javascript porque hace que deje de funcinar todas las demas funciones
            document.getElementById("downloadlink").addEventListener("click", function () {
                //Al descargar el fichero nos dirigiremos a la pantalla anterior
                let prevUrl = document.referrer;

                    if (prevUrl.indexOf(window.location.host) !== -1) {
                        // Ir a la página anterior
                        window.history.back();
                    }

            });
            //Si agrupo las dos funciones de volver, al entrar en la pagina inmediatamente vuelve
            document.getElementById("volver").addEventListener("click", function () {
                //boton volver
                let prevUrl = document.referrer;

                    if (prevUrl.indexOf(window.location.host) !== -1) {
                        // Ir a la página anterior
                        window.history.back();
                    }

            });
        </script>


        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>

        <script src="/TurboWeb/Recursos/js/funcionesFormularios.js" type="text/javascript"></script>
        <!-- google map -->
        <script async src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAklefVyatPB48Nnq2WUP4YW6nVTCwAwj0&callback=initMap"></script>

    </body>
</html>
