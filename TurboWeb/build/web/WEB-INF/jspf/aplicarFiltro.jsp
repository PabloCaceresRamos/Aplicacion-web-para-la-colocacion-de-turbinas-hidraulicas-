
<%@page import="java.util.Calendar"%>
<%@page import="TablasBD.Turbinas"%>
<%@page import="java.util.ArrayList"%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<c:if test="${requestScope.mensajeError!=null}"><div class="mensajeErrorhome col-lg-12">${requestScope.mensajeError}</div></c:if>
<c:if test="${requestScope.mensajeError==null}">
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
</c:if> 