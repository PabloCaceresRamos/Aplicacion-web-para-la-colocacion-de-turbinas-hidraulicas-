
<%@page import="java.util.ArrayList"%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<c:if test="${requestScope.mensajeError!=null}"><div class="mensajeErrorhome col-lg-12">${requestScope.mensajeError}</div></c:if>
<c:if test="${requestScope.mensajeError==null}">
<c:set var="idAux" value="${requestScope.idTurbina}" /> 
<%
    //Miramos si las turbinas estan bloqueadas o disponibles y lo marcamos en el check
    //idAux es el id de la turbina que estamos tratando mandado por post
    ArrayList<Integer> listaBloqueos = (ArrayList<Integer>) session.getAttribute("turbinasBloqueadas");
    boolean encontrado = false;
    String a=(String) pageContext.getAttribute("idAux");
    Integer idT = Integer.parseInt(a);
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
</c:if>