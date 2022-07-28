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
        <title>TuhiWeb/Crear turbina</title>
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

            <form  id="formFichero"class=" p pf" action="/TurboWeb/Controlador/CrearTurbina" method="POST" enctype="multipart/form-data" onsubmit="return comprobarDatos()" >

                <div class="f1">
                    <h2 class="titulof">Crear nueva turbina</h2>

                    <c:if test="${requestScope.mensajeError!=null}"><p id="errorServidor">${requestScope.mensajeError}</p></c:if>

                    <div class="importante">

                        <label class="etiqueta">Modelo de la turbina</label>
                        <input required id="nombre" name="nombre" type="text" />

                        <p class="campoFormulario">
                            <label class="etiqueta">Tipo de turbina </label>
                            <input required id="tipo" name="tipo" type="text" />
                        </p> 

                        <p class="campoFormulario">
                            <label class="etiqueta">Rendimiento </label>
                            <input required id="rendimiento" value="100" name="rendimiento" type="range" min="1" max="100" step="1" oninput="cambiarValorRangoRendimiento()"/>
                            <span id="valorRangoRendimiento"></span>
                        </p> 

                        <p class="campoFormulario">
                            <label class="etiqueta">Imagen</label>
                            <label for="subirImagen" class="subir">
                                <i class="fas fa-could-upload-alt"></i> Añadir imagen
                            </label>
                            <input id="subirImagen" name="imagen" type="file" value="" accept=".png" onchange="cambioi()" />
                            <label id="e2i" class="etiqueta2">Formato .png</label>
                        <div class="centrado" id="infoi"></div>
                        </p>

                        <p class="campoFormulario">
                            <label class="etiqueta">Función (Opcional)</label>
                            <label for="subirFuncion" class="subir">
                                <i class="fas fa-could-upload-alt"></i> Añadir función
                            </label>
                            <input id="subirFuncion" name="funcion" type="file" accept=".png" value="" onchange="cambiof()" />
                            <label id="e2f" class="etiqueta2">Formato .png</label>
                        <div class="centrado" id="infof"></div>
                        </p>


                        <p class="campoFormulario">
                            <label class="etiqueta">Numero de vertices </label>
                            <input required id="numVertices" value="3" type="range" min="3" max="25" step="1" oninput="cambiarValorRango()" onchange="mostrarPuntos(this.value)"/>
                            <span id="valorRango"></span>
                        </p> 

                    </div>

                    <div id="vertices">



                    </div>

                    <input style="display: none;" id="cadenaPuntos" name="cadenaPuntos" type="text"/><!-- Los puntos los paso a este campo unidos por , y ; para mandarlos al servidor -->
                    <p class="enviar enviarf">
                        <input class="create" type="submit" value="Crear turbina" />
                    </p>


                </div>
            </form>

        </section>



        <footer>
            <p style="margin-right:1%;">
                Pablo Cáceres Ramos &copy; 2020
            </p>
        </footer>

        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>

        <script src="/TurboWeb/Recursos/js/CrearTurbina.js" type="text/javascript"></script>

    </body>
</html>
