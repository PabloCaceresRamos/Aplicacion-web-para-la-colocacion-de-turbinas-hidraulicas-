<%-- 
    Document   : turbinasPropias
    Created on : 24-may-2021, 14:19:22
    Author     : pablo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<!-- se utiliza para actualizar la pantalla de motrar turbinas al eliminar una turbina -->
<c:if test="${requestScope.mensajeError!=null}"><div class="mensajeErrorhome col-lg-12">${requestScope.mensajeError}</div></c:if>
<c:if test="${requestScope.mensajeError==null}">
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
                        <center><input type="button" value="Eliminar turbina" onclick="eliminarTurbina(${turb.id})" style="margin-bottom: 3%"></center>

                    </div>
                </p>
            </div>
        </c:forEach>
    </c:when>
</c:choose>
</c:if>