
/*
Partes del codigo de la aplicación inspiradas en las practicas realizadas 
en la asignatura DAW del grado de Ingeniería Informatica en la Universidad 
de Huelva.
*/
package Controlador;

import Calculos.Fichero;
import Calculos.Figura;
import Calculos.Operaciones;
import Calculos.Punto;
import TablasBD.Calculos;
import TablasBD.FicheroCaudal;
import TablasBD.Localizacion;
import TablasBD.Turbinas;
import TablasBD.Usuario;
import java.io.File;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.annotation.Resource;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author pablo
 */
@MultipartConfig //para podre trabajar con los ficheros
@WebServlet(name = "Controlador", urlPatterns = {"/Controlador/*"})
public class Controlador extends HttpServlet {

    @PersistenceContext(unitName = "TurboWebPU")
    private EntityManager em;
    @Resource
    private javax.transaction.UserTransaction utx;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String accion = request.getPathInfo();//leemos el url al que queremos ir
            String vista;
            Calendar fechaSistema = new GregorianCalendar();
            HttpSession session = request.getSession();

            switch (accion) {
                case "/home":
                    //Pantalla principal
                    vista = "/home.jsp";
                    break;
                case "/SaltoNeto": {
                    //Pantalla calcular con salto neto 
                    vista = "/SaltoNeto.jsp";
                    break;
                }
                case "/SaltoBruto":
                    //Pantalla calcular con salto bruto
                    vista = "/SaltoBruto.jsp";
                    break;
                case "/Fichero":
                    //Pantalla generar fichero
                    vista = "/GenerarFichero.jsp";
                    break;
                case "/FicheroAuto":
                    //Pantalla generar fichero con vuelta automatica
                    vista = "/GenerarFichero.jsp?p=n";
                    break;
                case "/InformacionFichero":
                    vista = "/FicheroTWB.jsp";
                    break;
                case "/resultado":
                    vista = "/resultados.jsp";
                    break;
                case "/CalculoConSaltoNeto": {
                    try {
                        //Regogemos los datos del formulario
                        String nombre = request.getParameter("nombre");
                        String saltoNeto = request.getParameter("saltoNeto");
                        double numSaltoNeto = Double.parseDouble(saltoNeto);
                        String ficheroCaudal = request.getParameter("ficheroCaudal");
                        String nombreFichero = request.getParameter("nombreFichero");
                        Fichero classFichCaudal = new Fichero(ficheroCaudal, nombreFichero);

                        //Comprobamos los datos introducidos
                        if (ficheroCaudal.equals("") || saltoNeto.equals("") || nombreFichero.equals("")) {
                            throw new Exception("Campos vacios");
                        }

                        if (numSaltoNeto < 1 || numSaltoNeto > 1000) {
                            throw new Exception("Salto neto fuera del rango definido");
                        }
                        if (!classFichCaudal.contenidoFichero()) {
                            throw new Exception("Fichero dañado");
                        }

                        //Buscamos al usuario de la sesion
                        Usuario usuario = null;
                        String correo = (String) session.getAttribute("correo");
                        if (correo != null && !correo.equals("")) {
                            TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
                            queryUsuario.setParameter("email", correo);

                            List<Usuario> lUsuario;
                            lUsuario = queryUsuario.getResultList();
                            if (!lUsuario.isEmpty()) {
                                usuario = lUsuario.get(0);
                            }
                        }

                        //Buscamos las turbinas disponibles
                        List<Turbinas> turbinasDisponibles = buscarTurbinasDisponibles(usuario, session);

                        //calculamos las turbinas disponibles y las añadimos a la sesión directamente
                        List<Turbinas> resultadoTurbinas = this.realizarCalculosTurbinasSaltoNeto(turbinasDisponibles, session, numSaltoNeto, classFichCaudal);

                        vista = "/resultados.jsp";
                        //guardo los calculos si la sesión esta iniciada
                        if (usuario != null) {
                            this.guardarDatosCalculo(classFichCaudal.getNombreLocalizacion(), classFichCaudal.getLongitudString(), classFichCaudal.getLatitudString(), nombreFichero, classFichCaudal.getTipoFichero(), classFichCaudal.getCaudalesString(),
                                    nombre, saltoNeto.toString(), true, resultadoTurbinas, fechaSistema, usuario, null, null, null);
                        }
                    } catch (Exception ex) {
                        System.out.println("Error en calculo con salto neto: " + ex.getMessage());
                        vista = "/SaltoNeto.jsp";
                    }
                    break;
                }
                case "/CalculoConSaltoBruto": {
                    try {
                        String nombre = request.getParameter("nombre");
                        String ficheroCaudal = request.getParameter("ficheroCaudal");
                        String nombreFichero = request.getParameter("nombreFichero");
                        Fichero classFichCaudal = new Fichero(ficheroCaudal, nombreFichero);
                        String saltoBruto = request.getParameter("saltoBruto");
                        double numSaltoBruto = Double.parseDouble(saltoBruto);
                        String diametro = request.getParameter("diametro");
                        double numDiametro = Double.parseDouble(diametro);
                        String longitud = request.getParameter("longitud");
                        double numLongitud = Double.parseDouble(longitud);
                        String tipoTuberia = request.getParameter("tipoTuberia");
                        double numTipoTuberia = Double.parseDouble(tipoTuberia);

                        //Comprobamos los datos introducidos
                        if (ficheroCaudal.equals("") || nombreFichero.equals("")) {
                            throw new Exception("Campos vacios");
                        }

                        if (!classFichCaudal.contenidoFichero()) {
                            throw new Exception("Fichero dañado");
                        }
                        //Voy a calcular cada salto neto segun el caudal y se van a guardar en una lista
                        double[] listSaltoNeto = new double[classFichCaudal.getNumCaudales()];
                        for (int i = 0; i < classFichCaudal.getNumCaudales(); i++) {
                            listSaltoNeto[i] = Operaciones.calcularSaltoNeto(numSaltoBruto, classFichCaudal.getCaudales(i), numDiametro, numLongitud, numTipoTuberia);

                        }

                        //Buscamos al usuario de la sesion
                        Usuario usuario = null;
                        String correo = (String) session.getAttribute("correo");
                        if (correo != null && !correo.equals("")) {
                            TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
                            queryUsuario.setParameter("email", correo);

                            List<Usuario> lUsuario;
                            lUsuario = queryUsuario.getResultList();
                            if (!lUsuario.isEmpty()) {
                                usuario = lUsuario.get(0);
                            }
                        }

                        //Buscamos las trubinas disponibles
                        List<Turbinas> turbinasDisponibles = buscarTurbinasDisponibles(usuario, session);

                        //calculamos las turbinas disponibles y las añadimos a la sesión directamente
                        List<Turbinas> resultadoTurbinas = this.realizarCalculosTurbinasSaltoBruto(turbinasDisponibles, session, listSaltoNeto, classFichCaudal);

                        vista = "/resultados.jsp";

                        //guardo los calculos si la sesión esta iniciada
                        if (usuario != null) {
                            this.guardarDatosCalculo(classFichCaudal.getNombreLocalizacion(), classFichCaudal.getLongitudString(), classFichCaudal.getLatitudString(), nombreFichero, classFichCaudal.getTipoFichero(), classFichCaudal.getCaudalesString(),
                                    nombre, saltoBruto, false, resultadoTurbinas, fechaSistema, usuario, diametro, longitud, tipoTuberia);
                        }

                    } catch (Exception ex) {
                        System.out.println("Error en calculo con salto neto: " + ex.getMessage());
                        vista = "/SaltoNeto.jsp";
                    }
                    break;
                }
                case "/login":
                    //Pantalla inicio sesion
                    vista = "/Login.jsp";
                    break;
                case "/Registrarse":
                    //Pantalla inicio sesion
                    vista = "/Registrarse.jsp";
                    break;

                case "/GuardarRegistro": {
                    boolean correcto = true;//indica si todos los datos son correctos
                    String nombre = request.getParameter("nombre");
                    String apellidos = request.getParameter("apellidos");
                    String correo = request.getParameter("correo");
                    String dni = request.getParameter("dni");
                    String tlf = request.getParameter("tlf");
                    String passw1 = request.getParameter("passw1");
                    String passw2 = request.getParameter("passw2");
                    String fechaActual = fechaSistema.get(Calendar.DAY_OF_MONTH) + "-" + fechaSistema.get(Calendar.MONTH) + 1 + "-" + fechaSistema.get(Calendar.YEAR);
                    String mensajeError = null;
                    if (!passw1.equals("") && !nombre.equals("") && !apellidos.equals("") && !correo.equals("") && !dni.equals("") && !tlf.equals("") && !passw2.equals("")) {

                        if (!passw1.equals(passw2)) {
                            mensajeError = "Las contraseñas no coinciden";
                            correcto = false;
                        } else {
                            //mirar si correo o dni estan en la base de datos
                            TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByDniOREmail", Usuario.class);
                            queryUsuario.setParameter("email", correo);
                            queryUsuario.setParameter("dni", dni);

                            List<Usuario> lUsuario;
                            lUsuario = queryUsuario.getResultList();
                            if (!lUsuario.isEmpty()) {
                                correcto = false;
                                mensajeError = "Correo o DNI utilizado anteriormente";
                            } else {

                                try {
                                    String passwE = Encriptado.encriptarMensaje(passw1); //Contraseña enciptada
                                    Usuario u = new Usuario();
                                    u.setContrasena(passwE);
                                    u.setCorreo(correo);
                                    u.setDni(dni);
                                    u.setNombre(nombre);
                                    u.setApellidos(apellidos);
                                    u.setTlf(tlf);
                                    u.setVerificado(false);
                                    u.setFecha_registro(fechaActual);
                                    persist(u);
                                } catch (Exception e) {
                                    correcto = false;
                                    System.out.println("Error al añadir Usuario");
                                }

                            }
                        }

                    } else {
                        correcto = false;
                        mensajeError = "DatosIncorrectos";
                    }

                    if (correcto) {
                        Correos.enviarCorreoVerificacion(correo);
                        request.setAttribute("mensaje", "Se ha enviado el correo de verificación");
                        vista = "/home.jsp";
                    } else {
                        request.setAttribute("mensajeError", mensajeError);
                        vista = "/Registrarse.jsp";
                    }

                    break;
                }
                case "/Verificar": {
                    try {
                        String correo = request.getParameter("correo");
                        if (!correo.isEmpty()) {
                            TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
                            queryUsuario.setParameter("email", correo);

                            List<Usuario> lUsuario;
                            lUsuario = queryUsuario.getResultList();
                            if (!lUsuario.isEmpty()) {

                                Usuario u = lUsuario.get(0);
                                u.setVerificado(true);
                                merge(u);

                            }

                        }
                    } catch (Exception ex) {
                        request.setAttribute("mensajeError", "Error, intentelo más tarde");
                    }
                    vista = "/Login.jsp";
                    break;
                }
                case "/IniciarSesion": {
                    boolean correcto = true;

                    String correo = request.getParameter("correo");
                    String passw = request.getParameter("passw");
                    String mensajeError = null;

                    if (!passw.equals("") && !correo.equals("")) {
                        String passwE;
                        try {
                            passwE = Encriptado.encriptarMensaje(passw); //Contraseña enciptada

                            TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmailANDPassword", Usuario.class);
                            queryUsuario.setParameter("email", correo);
                            queryUsuario.setParameter("passw", passwE);

                            List<Usuario> lUsuario;
                            lUsuario = queryUsuario.getResultList();
                            if (lUsuario.isEmpty()) {
                                correcto = false;
                                mensajeError = "Revisa el correo o la contraseñas";
                            } else {
                                Usuario u = lUsuario.get(0);
                                if (u.getVerificado()) {
                                    session.setAttribute("dni", u.getDni());
                                    session.setAttribute("correo", u.getCorreo());
                                    session.setAttribute("nombre", u.getNombre());
                                } else {
                                    correcto = false;
                                    mensajeError = "Debes verificar el correo";
                                    Correos.enviarCorreoVerificacion(u.getCorreo());
                                }
                            }
                        } catch (NoSuchAlgorithmException ex) {
                            correcto = false;
                            mensajeError = "Error, intentelo más tarde";
                            Logger.getLogger(Controlador.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }

                    if (correcto) {
                        vista = "/home.jsp";
                    } else {
                        request.setAttribute("mensajeError", mensajeError);
                        vista = "/Login.jsp";
                    }
                    break;
                }
                case "/CerrarSesion":
                    session.invalidate();
                    vista = "/home.jsp";
                    break;

                case "/EnlaceOlvidadoContraseña":
                    vista = "/CorreoRContrasena.jsp";
                    break;

                case "/EnviarCorreoContrasena": {//Coge el correo y manda un mensaje, vamos a la pantalla donde hay que esperar para mandar otro mensaje
                    boolean correcto = true;
                    String mensajeError = null;

                    String correo = request.getParameter("correo");
                    if (!correo.equals("")) {
                        TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
                        queryUsuario.setParameter("email", correo);

                        List<Usuario> lUsuario;
                        lUsuario = queryUsuario.getResultList();
                        if (lUsuario.isEmpty()) {
                            correcto = false;
                            mensajeError = "Revisa el correo";
                        } else {
                            request.setAttribute("correo", correo);
                            Correos.enviarCorreoRecuperarContrasena(correo, lUsuario.get(0));
                        }
                    } else {
                        correcto = false;
                        mensajeError = "Correo invalido";
                    }

                    if (correcto) {
                        vista = "/CorreoRContrasena2.jsp";
                    } else {
                        request.setAttribute("mensajeError", mensajeError);
                        vista = "/CorreoRContrasena.jsp";
                    }
                    break;
                }
                case "/RecuperarContrasenaPerdida": {
                    //Entramos mediante el enlace de recuperacion de contrasena
                    //Desencriptamos los datos y buscamos a quien pertenece esos datos
                    //vamos a la pagina para cambiar contrasena
                    boolean correcto = true;
                    String datosGet = request.getParameter("correo");
                    String correo = null;
                    if (!datosGet.equals("")) {
                        correo = Encriptado.desencriptarDatosRecuperarContrasena(datosGet, em);
                        if (correo == null) {
                            correcto = false;
                        }
                    } else {
                        correcto = false;
                    }

                    if (!correcto) {
                        vista = "/home.jsp";
                    } else {
                        request.setAttribute("correo", correo);
                        vista = "/RecuperarContrasenaPerdida.jsp";
                    }
                    break;
                }
                case "/CambiarContrasenaBoton": {
                    //Cogemos el correo de la sesión, enviamos el correo de recuperación de contraseña.
                    boolean correcto = true;
                    String correo = (String) session.getAttribute("correo");
                    if (correo == null && correo.equals("")) {
                        correcto = false;
                    } else {
                        TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
                        queryUsuario.setParameter("email", correo);

                        List<Usuario> lUsuario;
                        lUsuario = queryUsuario.getResultList();
                        if (lUsuario.isEmpty()) {
                            correcto = false;
                        } else {
                            request.setAttribute("correo", correo);
                            Correos.enviarCorreoRecuperarContrasena(correo, lUsuario.get(0));
                        }
                    }

                    if (!correcto) {
                        vista = "/home.jsp";
                    } else {
                        request.setAttribute("correo", correo);
                        vista = "/CorreoRContrasena2.jsp";
                    }
                    break;
                }
                case "/CambiarContrasenaOlvidada": {
                    //Recibimos la contraseña nueva y la cambiamos
                    String correo = request.getParameter("correo");
                    String passw1 = request.getParameter("passw1");
                    String passw2 = request.getParameter("passw2");
                    String mensajeError = null;
                    if (!passw1.equals("") && !correo.equals("") && !passw2.equals("")) {

                        if (!passw1.equals(passw2)) {
                            mensajeError = "Las contraseñas no coinciden";
                        } else {
                            //mirar si correo o dni estan en la base de datos
                            TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
                            queryUsuario.setParameter("email", correo);

                            List<Usuario> lUsuario;
                            lUsuario = queryUsuario.getResultList();
                            if (lUsuario.isEmpty()) {
                                mensajeError = "Error, intentelo mas tarde";
                            } else {

                                try {
                                    String passwE = Encriptado.encriptarMensaje(passw1); //Contraseña enciptada
                                    Usuario u = lUsuario.get(0);
                                    if (!u.getContrasena().equals(passwE)) {//Si la contraseña es la misma del servidor no hacemos el cambio
                                        u.setContrasena(passwE);
                                        merge(u);
                                        mensajeError = "Contraseña cambiada";
                                    } else {
                                        mensajeError = "No puedes utilizar una contraseña antigua";
                                    }

                                } catch (Exception e) {
                                    mensajeError = "Error al cambiar la contrasena";
                                }

                            }
                        }

                    } else {
                        mensajeError = "DatosIncorrectos";
                    }

                    request.setAttribute("mensajeError", mensajeError);
                    vista = "/Login.jsp";

                    break;
                }
                case "/PantallaCambiarCorreo":
                    vista = "/CambiarCorreo.jsp";
                    break;
                case "/CambiarCorreo": {
                    try {
                        String correo = (String) session.getAttribute("correo");
                        String nuevoCorreo = request.getParameter("nuevoCorreo");
                        String passw = request.getParameter("passw");

                        if (passw.equals("") || nuevoCorreo.equals("")) {
                            throw new Exception("Error en los datos introducidos");
                        }
                        if (correo == null && correo.equals("")) {
                            throw new Exception("Debes iniciar sesión");
                        }
                        //Miramos que el nuevo correo no este en la base de datos

                        TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
                        queryUsuario.setParameter("email", nuevoCorreo);

                        List<Usuario> lUsuario;
                        lUsuario = queryUsuario.getResultList();
                        if (!lUsuario.isEmpty()) {//si hay alguna cuenta con el nuevo correo, no se hace el cambio
                            throw new Exception("Correo no valido");
                        }

                        //Miramos si la contraseña es correcta
                        String passwE;
                        passwE = Encriptado.encriptarMensaje(passw); //Contraseña enciptada

                        TypedQuery<Usuario> queryUsuario2 = em.createNamedQuery("Usuario.findByEmailANDPassword", Usuario.class);
                        queryUsuario2.setParameter("email", correo);
                        queryUsuario2.setParameter("passw", passwE);

                        List<Usuario> lUsuario2;
                        lUsuario2 = queryUsuario2.getResultList();
                        if (lUsuario2.isEmpty()) {
                            throw new Exception("Contraseña incorrecta");
                        }
                        //actualizamos el correo y el estado de verificado
                        Usuario u = lUsuario2.get(0);
                        u.setCorreo(nuevoCorreo);
                        u.setVerificado(false);
                        merge(u);
                        //cerramos la sesion y mandamos el correo de valización
                        session.invalidate();
                        Correos.enviarCorreoVerificacion(u.getCorreo());

                        request.setAttribute("mensajeError", "necesitas verificar el correo");
                        vista = "/Login.jsp";

                    } catch (NoSuchAlgorithmException ex) {
                        request.setAttribute("mensajeError", "Error, intentelo más tarde");
                        vista = "/CambiarCorreo.jsp";
                    } catch (Exception ex) {
                        request.setAttribute("mensajeError", ex.getMessage());
                        vista = "/CambiarCorreo.jsp";
                    }
                    break;
                }

                case "/EliminarCuentaVista":
                    vista = "/EliminarCuenta.jsp";
                    break;

                case "/EliminarCuenta": {
                    try {
                        String correo = (String) session.getAttribute("correo");
                        String passw = request.getParameter("passw");

                        if (passw.equals("")) {
                            throw new Exception("Error en la contraseña");
                        }
                        if (correo == null && correo.equals("")) {
                            throw new Exception("Debes iniciar sesión");
                        }

                        //Miramos si la contraseña es correcta
                        String passwE;
                        passwE = Encriptado.encriptarMensaje(passw); //Contraseña enciptada

                        TypedQuery<Usuario> queryUsuario2 = em.createNamedQuery("Usuario.findByEmailANDPassword", Usuario.class);
                        queryUsuario2.setParameter("email", correo);
                        queryUsuario2.setParameter("passw", passwE);

                        //Buscamos el usuario
                        List<Usuario> lUsuario;
                        lUsuario = queryUsuario2.getResultList();
                        if (lUsuario.isEmpty()) {
                            throw new Exception("Contraseña incorrecta");
                        }
                         //Eliminamos los cálculos asociados al usuario
                        TypedQuery<Calculos> queryCalculos = em.createNamedQuery("Calculos.calculosUsuario", Calculos.class);
                        queryCalculos.setParameter("usuario", lUsuario.get(0));
                        List<Calculos> lCalculosEliminar = queryCalculos.getResultList();
                        for (Calculos calculo : lCalculosEliminar) {
                            remove(calculo);
                        }
                        //Eliminamos las turbinas asociadas al usuario
                        TypedQuery<Turbinas> queryTurbinas = em.createNamedQuery("Turbinas.findPorDNI", Turbinas.class);
                        queryTurbinas.setParameter("usuario", lUsuario.get(0));
                        List<Turbinas> lTurbinasEliminar = queryTurbinas.getResultList();
                        for (Turbinas turbina : lTurbinasEliminar) {
                            remove(turbina);
                        }
                       
                        //Eliminamos la cuenta de la base de datos
                        remove(lUsuario.get(0));
                        //cerramos la sesion y mandamos el correo de valización
                        session.invalidate();

                        request.setAttribute("mensaje", "Cuenta eliminada");
                        vista = "/home.jsp";

                    } catch (NoSuchAlgorithmException ex) {
                        request.setAttribute("mensajeError", "Error, intentelo más tarde");
                        vista = "/EliminarCuenta.jsp";
                    } catch (RuntimeException ex) {
                        request.setAttribute("mensajeError", "Error, intentelo más tarde");
                        vista = "/EliminarCuenta.jsp";
                    } catch (Exception ex) {
                        request.setAttribute("mensajeError", ex.getMessage());
                        vista = "/EliminarCuenta.jsp";
                    }
                    break;
                }

                case "/CrearTurbinaPantalla":
                    vista = "/CrearTurbina.jsp";
                    break;

                case "/CrearTurbina": {
                    try {
                        String nombre = request.getParameter("nombre");
                        String tipo = request.getParameter("tipo");
                        String vertices = request.getParameter("cadenaPuntos");
                        String correo = (String) session.getAttribute("correo");
                        String r = request.getParameter("rendimiento");

                        if (correo == null || correo.equals("")) {
                            throw new Exception("Comprueba la sesión");
                        }

                        TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
                        queryUsuario.setParameter("email", correo);

                        List<Usuario> lUsuario;
                        lUsuario = queryUsuario.getResultList();
                        if (lUsuario.isEmpty()) {//si hay alguna cuenta con el nuevo correo, no se hace el cambio
                            throw new Exception("Compruebe la sesión");
                        }

                        //Comprobamos los datos introducidos
                        if (nombre.equals("") || tipo.equals("") || vertices.equals("") || r.equals("")) {
                            throw new Exception("Campos vacios");
                        }

                        Double rendimiento = Double.parseDouble(r);
                        if (rendimiento < 1 || rendimiento > 100) {
                            throw new Exception("Rendimiento no válido");
                        }

                        if (!Figura.comprobarPuntos(vertices)) {
                            throw new Exception("Vertices inválidos");
                        }

                        //Leemos las imagenes
                        Part imagenTurbina = request.getPart("imagen");
                        Part funcionTurbina = request.getPart("funcion");
                        if (imagenTurbina == null || imagenTurbina.getSize() < 1) {
                            throw new Exception("Fallo al cargar la imagen");
                        }

                        boolean funcionInsertada = false;
                        if (funcionTurbina != null && funcionTurbina.getSize() > 1) {
                            funcionInsertada = true;
                        }

                        ///////////////////////// Reescalar las imagenes
                        //Insertamos en la base de datos
                        Turbinas t = new Turbinas();
                        t.setNombre(nombre);
                        t.setTipo(tipo);
                        t.setFoto(true);
                        t.setGrafica(funcionInsertada);
                        t.setNueva(true);
                        t.setPuntos(vertices);
                        t.setEficiencia(rendimiento);
                        t.setUsuarios(lUsuario.get(0));
                        persist(t);
                        ///////////////////////////Añadimos las imagenes a las carpetas
                        String rutaRelativa = "Recursos/TurbinasImagenes";
                        String rutaAbsoluta = getServletContext().getRealPath(rutaRelativa);
                        File imagen = new File(rutaAbsoluta + File.separator + t.getId() + ".png");
                        Imagenes.guardarImagen(imagen, imagenTurbina);
                        Imagenes.resize(rutaAbsoluta + File.separator + t.getId() + ".png", rutaAbsoluta + File.separator + t.getId() + ".png", 1460, 1080);

                        if (funcionInsertada) {
                            rutaRelativa = "Recursos/TurbinasGraficas";
                            rutaAbsoluta = getServletContext().getRealPath(rutaRelativa);
                            File grafica = new File(rutaAbsoluta + File.separator + t.getId() + ".png");
                            Imagenes.guardarImagen(grafica, funcionTurbina);
                            Imagenes.resize(rutaAbsoluta + File.separator + t.getId() + ".png", rutaAbsoluta + File.separator + t.getId() + ".png", 1460, 1080);
                        }
                    } catch (RuntimeException ex) {
                        request.setAttribute("mensajeError", "Error, intentelo más tarde");
                    } catch (Exception ex) {
                        request.setAttribute("mensajeError", ex.getMessage());
                    } finally {
                        vista = "/CrearTurbina.jsp";
                    }

                    break;
                }
                case "/mostrarTurbinas": {
                    try {
                        List<Turbinas> lTurbinasPropias = new ArrayList<>();
                        List<Turbinas> lTurbinasPredeterminadas = new ArrayList<>();

                        //Buscamos las turbinas prederminadas
                        TypedQuery<Turbinas> queryTurbinas = em.createNamedQuery("Turbinas.findNuevas", Turbinas.class);
                        queryTurbinas.setParameter("nueva", false);

                        lTurbinasPredeterminadas = queryTurbinas.getResultList();

                        //Buscamos las turbinas del usuario
                        String correo = (String) session.getAttribute("correo");
                        if (correo != null && !correo.equals("")) {
                            //buscamos el usuario de la sesión
                            TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
                            queryUsuario.setParameter("email", correo);
                            List<Usuario> lUsuario;
                            lUsuario = queryUsuario.getResultList();
                            //buscamos las turbinas de ese usuario
                            queryTurbinas = em.createNamedQuery("Turbinas.findPorDNI", Turbinas.class);
                            if (!lUsuario.isEmpty()) {
                                queryTurbinas.setParameter("usuario", lUsuario.get(0));
                                lTurbinasPropias = queryTurbinas.getResultList();
                            }

                        }

                        request.setAttribute("turbinasPredeterminadas", lTurbinasPredeterminadas);
                        request.setAttribute("turbinasPropias", lTurbinasPropias);
                        vista = "/MostrarTurbinas.jsp";

                    } catch (Exception ex) {
                        request.setAttribute("mensajeError", "Error en la base de datos");
                        vista = "/home.jsp";
                    }
                    break;
                }
                case "/EliminarTurbina":

                    try {
                        String correo = (String) session.getAttribute("correo");
                        String idTurbina = (String) request.getParameter("id");
                        if (correo == null && correo.equals("")) {
                            throw new Exception("Error con la sesión");
                        }

                        Integer idT = Integer.parseInt(idTurbina);

                        //buscamos el usuario de la sesión
                        TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
                        queryUsuario.setParameter("email", correo);
                        List<Usuario> lUsuario;
                        lUsuario = queryUsuario.getResultList();
                        if (lUsuario.isEmpty()) {
                            throw new Exception("Error con la sesión");
                        }
                        //buscamos la turbina a eliminar y la eliminamos
                        TypedQuery<Turbinas> queryTurbinas = em.createNamedQuery("Turbinas.findParaEliminar", Turbinas.class);
                        queryTurbinas.setParameter("usuario", lUsuario.get(0));
                        queryTurbinas.setParameter("id", idT);
                        queryTurbinas.setParameter("nueva", true);
                        List<Turbinas> lTurbinasEliminar = queryTurbinas.getResultList();
                        if (lTurbinasEliminar.isEmpty()) {
                            throw new Exception("Error con la turbina");
                        }
                        //Quitamos la turbina de todos los calculos
                        TypedQuery<Calculos> queryCalculo = em.createQuery("SELECT c FROM Calculos c", Calculos.class);
                        List<Calculos> lCalculos = queryCalculo.getResultList();
                        for (Calculos Calculo : lCalculos) {
                            List<Turbinas> turbCalculos=Calculo.getTurbinas();
                            turbCalculos.remove(lTurbinasEliminar.get(0));
                            Calculo.setTurbinas(turbCalculos);
                            merge(Calculo);
                        }
                        
                        remove(lTurbinasEliminar.get(0));

                        //buscamos las turbinas de ese usuario restantes
                        queryTurbinas = em.createNamedQuery("Turbinas.findPorDNI", Turbinas.class);
                        queryTurbinas.setParameter("usuario", lUsuario.get(0));
                        List<Turbinas> lTurbinasPropias = queryTurbinas.getResultList();

                        request.setAttribute("turbinasPropias", lTurbinasPropias);
                       // vista = "/WEB-INF/jspf/turbinasPropias.jsp";
                    } catch (NumberFormatException ne) {
                        request.setAttribute("mensajeError", "Error al eliminar la turbina");
                        //vista = "/home.jsp";
                    } catch (RuntimeException ex) {
                        request.setAttribute("mensajeError", "Error, intentelo más tarde");
                       // vista = "/home.jsp";
                    } catch (Exception ex) {
                        request.setAttribute("mensajeError", "Error");
                        //vista = "/home.jsp";
                    }
                    vista = "/WEB-INF/jspf/turbinasPropias.jsp";

                    break;
                case "/BloquearTurbina":
                    try {
                        String idTurbina = (String) request.getParameter("id");

                        Integer idT = Integer.parseInt(idTurbina);

                        ArrayList<Integer> listaBloqueos = (ArrayList<Integer>) session.getAttribute("turbinasBloqueadas");
                        if (listaBloqueos == null) {
                            listaBloqueos = new ArrayList<>();
                            listaBloqueos.add(idT);
                        } else {
                            listaBloqueos.add(idT);
                        }
                        session.setAttribute("turbinasBloqueadas", listaBloqueos);

                        request.setAttribute("idTurbina", idTurbina);
                        //vista = "/WEB-INF/jspf/bloquearTurbina.jsp";

                    } catch (NumberFormatException ne) {
                        request.setAttribute("mensajeError", "Error al bloquear la turbina");
                        //vista = "/home.jsp";
                    } catch (Exception ex) {
                        request.setAttribute("mensajeError", "Error");
                       // vista = "/home.jsp";
                    }
                    vista = "/WEB-INF/jspf/bloquearTurbina.jsp";
                    break;
                case "/DesbloquearTurbina":
                    try {
                        String idTurbina = (String) request.getParameter("id");

                        Integer idT = Integer.parseInt(idTurbina);

                        ArrayList<Integer> listaBloqueos = (ArrayList<Integer>) session.getAttribute("turbinasBloqueadas");
                        if (listaBloqueos == null) {
                            listaBloqueos = new ArrayList<>();
                        } else {
                            listaBloqueos.remove(idT);
                        }
                        session.setAttribute("turbinasBloqueadas", listaBloqueos);

                        request.setAttribute("idTurbina", idTurbina);
                        //vista = "/WEB-INF/jspf/bloquearTurbina.jsp";

                    } catch (NumberFormatException ne) {
                        request.setAttribute("mensajeError", "Error al desbloquear la turbina");
                        //vista = "/home.jsp";
                    } catch (Exception ex) {
                        request.setAttribute("mensajeError", "Error");
                        //vista = "/home.jsp";
                    }
                    vista = "/WEB-INF/jspf/bloquearTurbina.jsp";
                    break;

                case "/VerCalculos": {
                    try {
                        String correo = (String) session.getAttribute("correo");
                        //buscamos el usuario de la sesión
                        TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
                        queryUsuario.setParameter("email", correo);
                        List<Usuario> lUsuario;
                        lUsuario = queryUsuario.getResultList();
                        if (lUsuario.isEmpty()) {
                            throw new Exception("Error con la sesión");
                        }
                        //Buscamos los calculos asociados al usuario

                        TypedQuery<Calculos> queryCalculos = em.createNamedQuery("Calculos.calculosUsuarioySaltoNeto", Calculos.class);
                        queryCalculos.setParameter("usuario", lUsuario.get(0));
                        queryCalculos.setParameter("SaltoNeto", true);
                        List<Calculos> lCalculosSaltoNeto;
                        lCalculosSaltoNeto = queryCalculos.getResultList();
                        queryCalculos.setParameter("SaltoNeto", false);
                        List<Calculos> lCalculosSaltoBruto;
                        lCalculosSaltoBruto = queryCalculos.getResultList();
                        request.setAttribute("calculosSN", lCalculosSaltoNeto);
                        request.setAttribute("calculosSB", lCalculosSaltoBruto);
                        vista = "/VerCalculos.jsp";
                    } catch (Exception ex) {
                        request.setAttribute("mensajeError", ex.getMessage());
                        vista = "/home.jsp";
                    }
                }
                break;

                case "/VerFichero":
                    try {
                        Integer idCalculo = Integer.parseInt(request.getParameter("n"));
                        String correo = (String) session.getAttribute("correo");
                        //buscamos el usuario de la sesión
                        TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
                        queryUsuario.setParameter("email", correo);
                        List<Usuario> lUsuario;
                        lUsuario = queryUsuario.getResultList();
                        if (lUsuario.isEmpty()) {
                            throw new Exception("Error con la sesión");
                        }
                        //Buscamos el calculo con el id y el usuario de la sesión por seguridad
                        TypedQuery<Calculos> queryCalculos = em.createNamedQuery("Calculos.calculosUsuarioYId", Calculos.class);
                        queryCalculos.setParameter("usuario", lUsuario.get(0));
                        queryCalculos.setParameter("id", idCalculo);
                        List<Calculos> lCalculos;
                        lCalculos = queryCalculos.getResultList();

                        if (lCalculos.isEmpty()) {
                            throw new Exception("Error con la base de datos");
                        }

                        FicheroCaudal f = lCalculos.get(0).getFicheroCaudal();
                        Localizacion l = f.getLocalizacion();

                        request.setAttribute("fichero", f);
                        request.setAttribute("localizacion", l);

                        vista = "/VerFichero.jsp?p=n";
                    } catch (NumberFormatException ne) {
                        request.setAttribute("mensajeError", "Error en el fichero");
                        vista = "/home.jsp";
                    } catch (Exception ex) {
                        vista = "/home.jsp";
                        request.setAttribute("mensajeError", ex.getMessage());
                    }
                    break;

                case "/EliminarCalculo":
                    try {

                        String correo = (String) session.getAttribute("correo");
                        String idCalculo = (String) request.getParameter("id");
                        if (correo == null && correo.equals("")) {
                            throw new Exception("Error con la sesión");
                        }

                        Integer idC = Integer.parseInt(idCalculo);

                        //buscamos el usuario de la sesión
                        TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
                        queryUsuario.setParameter("email", correo);
                        List<Usuario> lUsuario;
                        lUsuario = queryUsuario.getResultList();
                        if (lUsuario.isEmpty()) {
                            throw new Exception("Error con la sesión");
                        }
                        //buscamos el calculo a eliminar y lo eliminamos
                        TypedQuery<Calculos> queryCalculos = em.createNamedQuery("Calculos.calculosUsuarioYId", Calculos.class);
                        queryCalculos.setParameter("usuario", lUsuario.get(0));
                        queryCalculos.setParameter("id", idC);
                        List<Calculos> lCalculos;
                        lCalculos = queryCalculos.getResultList();

                        if (lCalculos.isEmpty()) {
                            throw new Exception("Error con el cálculo");
                        }

                        remove(lCalculos.get(0));

                        //vista = "/WEB-INF/jspf/eliminarCalculos.jsp";
                    } catch (NumberFormatException ne) {
                        request.setAttribute("mensajeError", "Error en el fichero");
                        //vista = "/home.jsp";
                    } catch (Exception ex) {
                        //vista = "/home.jsp";
                        request.setAttribute("mensajeError", ex.getMessage());
                    }
                    vista = "/WEB-INF/jspf/eliminarCalculos.jsp";
                    break;

                case "/VerCalculoGuardado":
                    try {

                        String correo = (String) session.getAttribute("correo");
                        String idCalculo = (String) request.getParameter("n");
                        if (correo == null && correo.equals("")) {
                            throw new Exception("Error con la sesión");
                        }

                        Integer idC = Integer.parseInt(idCalculo);

                        //buscamos el usuario de la sesión
                        TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
                        queryUsuario.setParameter("email", correo);
                        List<Usuario> lUsuario;
                        lUsuario = queryUsuario.getResultList();
                        if (lUsuario.isEmpty()) {
                            throw new Exception("Error con la sesión");
                        }
                        //buscamos el calculo y busco sus turbinas
                        TypedQuery<Calculos> queryCalculos = em.createNamedQuery("Calculos.calculosUsuarioYId", Calculos.class);
                        queryCalculos.setParameter("usuario", lUsuario.get(0));
                        queryCalculos.setParameter("id", idC);
                        List<Calculos> lCalculos;
                        lCalculos = queryCalculos.getResultList();

                        if (lCalculos.isEmpty()) {
                            throw new Exception("Error con el cálculo");
                        }
                        //Creo una clase fichero auxiliar. Este fichero solo contendra los caudales, que es lo único necesario en la función
                        Fichero aux = new Fichero();
                        aux.setCaudales(lCalculos.get(0).getFicheroCaudal().getListaCaudales());
                        if (lCalculos.get(0).isSaltoNeto()) {//Miro si es salto neto o no para saber a que funcíon llamar
                            realizarCalculosTurbinasSaltoNeto(lCalculos.get(0).getTurbinas(), session, Double.parseDouble(lCalculos.get(0).getSalto()), aux);
                        } else {
                            //Voy a calcular cada salto neto segun el caudal y se van a guardar en una lista
                            double[] listSaltoNeto = new double[aux.getNumcaudales2()];
                            for (int i = 0; i < aux.getNumcaudales2(); i++) {
                                listSaltoNeto[i] = Operaciones.calcularSaltoNeto(Double.parseDouble(lCalculos.get(0).getSalto()), aux.getCaudales(i), Double.parseDouble(lCalculos.get(0).getDiametro()), Double.parseDouble(lCalculos.get(0).getLongitud()), Integer.parseInt(lCalculos.get(0).getTipoTurberia()));

                            }
                            realizarCalculosTurbinasSaltoBruto(lCalculos.get(0).getTurbinas(), session, listSaltoNeto, aux);
                        }

                        vista = "/resultados.jsp";
                    } catch (NumberFormatException ne) {
                        request.setAttribute("mensajeError", "Error");
                        vista = "/home.jsp";
                    } catch (Exception ex) {
                        vista = "/home.jsp";
                        request.setAttribute("mensajeError", ex.getMessage());
                    }
                    break;

                case "/VerCalculoFiltro": {
                    try {
                        String correo = (String) session.getAttribute("correo");
                        String n = request.getParameter("nombreFiltro");
                        String o = request.getParameter("orden");
                        
                        String ordenar="";
                        if(o.equals("1")){
                            ordenar="ORDER BY c.fecha ASC";
                        }else if(o.equals("2")){
                            ordenar="ORDER BY c.fecha DESC";
                        }
                        
                        String nombre=null;
                        if(!n.isEmpty()){
                            nombre="AND c.nombre LIKE \""+n+"%\"";
                        }
                        
                        //buscamos el usuario de la sesión
                        TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
                        queryUsuario.setParameter("email", correo);
                        List<Usuario> lUsuario;
                        lUsuario = queryUsuario.getResultList();
                        if (lUsuario.isEmpty()) {
                            throw new Exception("Error con la sesión");
                        }
                        //Buscamos los calculos asociados al usuario

                        TypedQuery<Calculos> queryCalculos = em.createQuery("SELECT c FROM Calculos c WHERE c.usuario = :usuario AND c.saltoNeto = :SaltoNeto "+(nombre != null ? nombre : "")+ordenar, Calculos.class);
                        queryCalculos.setParameter("usuario", lUsuario.get(0));
                        queryCalculos.setParameter("SaltoNeto", true);
                        List<Calculos> lCalculosSaltoNeto;
                        lCalculosSaltoNeto = queryCalculos.getResultList();
                        queryCalculos.setParameter("SaltoNeto", false);
                        List<Calculos> lCalculosSaltoBruto;
                        lCalculosSaltoBruto = queryCalculos.getResultList();
                        request.setAttribute("calculosSN", lCalculosSaltoNeto);
                        request.setAttribute("calculosSB", lCalculosSaltoBruto);

                        //vista = "/WEB-INF/jspf/aplicarFiltro.jsp";
                    } catch (Exception ex) {
                        request.setAttribute("mensajeError", ex.getMessage());
                       // vista = "/home.jsp";
                    }
                    vista = "/WEB-INF/jspf/aplicarFiltro.jsp";
                }
                break;
                default:
                    //Pantalla predeterminada
                    vista = "/home.jsp";
                    break;
            }
            RequestDispatcher rD = request.getRequestDispatcher(vista);
            rD.forward(request, response);
        } catch (Exception ex) {
            Logger.getLogger(Controlador.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    public void persist(Object object) {
        try {
            utx.begin();
            em.persist(object);
            utx.commit();
        } catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", e);
            throw new RuntimeException(e);
        }
    }

    public void merge(Object object) {//Busca la endiad por la plave primaria y la acutaliza con los nuevos datos
        try {
            utx.begin();
            em.merge(object);
            utx.commit();
        } catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", e);
            throw new RuntimeException(e);
        }
    }

    public void remove(Object object) {//Busca la endiad por la plave primaria y la acutaliza con los nuevos datos
        try {
            utx.begin();
            em.remove(em.merge(object));
            utx.commit();
        } catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", e);
            throw new RuntimeException(e);
        }
    }

    private List<Turbinas> realizarCalculosTurbinasSaltoNeto(List<Turbinas> lTurbinasPredeterminadas, HttpSession session, double numSaltoNeto, Fichero classFichCaudal) {//Funcion comun para el salto neto y salto bruto

        if (!lTurbinasPredeterminadas.isEmpty()) {

            //ordenamos mediante quicksort y la solucion es pasada por referencia en la propia tabla
            Operaciones.ordenarTurbinasPorEficiencia(lTurbinasPredeterminadas, 0, lTurbinasPredeterminadas.size() - 1);

            //Inicializamos las figuras de cada turbina recibida
            ArrayList<Figura> figurasTurbinas = new ArrayList<>();
            for (int i = 0; i < lTurbinasPredeterminadas.size(); i++) {
                figurasTurbinas.add(new Figura(lTurbinasPredeterminadas.get(i).getPuntos()));
            }

            //Calcular figuras disponibles
            ArrayList<Integer> posTurbinasDisponibles = Operaciones.calcularTurbinasDisponibles(figurasTurbinas, numSaltoNeto, classFichCaudal);
            ArrayList<Turbinas> turbinasDisponibles = new ArrayList<>();
            for (int pos : posTurbinasDisponibles) {
                turbinasDisponibles.add(lTurbinasPredeterminadas.get(pos));
            }
            //Calculamos la potencia
            ArrayList<Float> potenciasTurbinas = new ArrayList<>();
            for (int pos : posTurbinasDisponibles) {//Visitamos toas las turbinas disponibles
                double mediaCaudal = figurasTurbinas.get(pos).caudalMedioAceptado();//sacamos su caudal medio aceptado
                float pAux = Operaciones.calcularPotencia(new Punto(mediaCaudal, numSaltoNeto), lTurbinasPredeterminadas.get(pos).getEficiencia() / 100);
                potenciasTurbinas.add(pAux);
            }
            session.setAttribute("resultado", turbinasDisponibles);
            session.setAttribute("potencias", potenciasTurbinas);
            session.setAttribute("calculoRealizado", "s");//Lo vamos a utilizar para cuando vayamos a ultimo resultado y no hay ninguno

            //Devolvemos las turbinas disponibles
            return (List<Turbinas>) turbinasDisponibles.clone();
        }
        return new ArrayList<>();
    }

    private List<Turbinas> realizarCalculosTurbinasSaltoBruto(List<Turbinas> lTurbinasPredeterminadas, HttpSession session, double[] listSaltoNeto, Fichero classFichCaudal) {//Funcion comun para el salto neto y salto bruto

        if (!lTurbinasPredeterminadas.isEmpty()) {

            //ordenamos mediante quicksort y la solucion es pasada por referencia en la propia tabla
            Operaciones.ordenarTurbinasPorEficiencia(lTurbinasPredeterminadas, 0, lTurbinasPredeterminadas.size() - 1);

            //Inicializamos las figuras de cada turbina recibida
            ArrayList<Figura> figurasTurbinas = new ArrayList<>();
            for (int i = 0; i < lTurbinasPredeterminadas.size(); i++) {
                figurasTurbinas.add(new Figura(lTurbinasPredeterminadas.get(i).getPuntos()));
            }

            //Calcular figuras disponibles
            ArrayList<Integer> posTurbinasDisponibles = Operaciones.calcularTurbinasDisponibles(figurasTurbinas, listSaltoNeto, classFichCaudal);
            ArrayList<Turbinas> turbinasDisponibles = new ArrayList<>();
            for (int pos : posTurbinasDisponibles) {
                turbinasDisponibles.add(lTurbinasPredeterminadas.get(pos));
            }
            //Calculamos la potencia
            ArrayList<Float> potenciasTurbinas = new ArrayList<>();
            //calculo la media de los salto neto
            double mediaSN = 0.0;
            for (int i = 0; i < listSaltoNeto.length; i++) {
                mediaSN += listSaltoNeto[i];
            }
            mediaSN = mediaSN / listSaltoNeto.length;
            for (int pos : posTurbinasDisponibles) {//Visitamos toas las turbinas disponibles
                double mediaCaudal = figurasTurbinas.get(pos).caudalMedioAceptado();//sacamos su caudal medio aceptado
                float pAux = Operaciones.calcularPotencia(new Punto(mediaCaudal, mediaSN), lTurbinasPredeterminadas.get(pos).getEficiencia() / 100);
                potenciasTurbinas.add(pAux);
            }

            session.setAttribute("resultado", turbinasDisponibles);
            session.setAttribute("potencias", potenciasTurbinas);
            session.setAttribute("calculoRealizado", "s");//Lo vamos a utilizar para cuando vayamos a ultimo resultado y no hay ninguno

            //Devolvemos las turbinas disponibles
            return (List<Turbinas>) turbinasDisponibles.clone();
        }
        return new ArrayList<>();
    }

    private void guardarDatosCalculo(String nombreLocalizacion, String longitud, String latitud, String nombreFichero, int tipo, String listaCaudales,
            String nombre, String salto, boolean saltoNeto, List<Turbinas> turbinas, Calendar fechaHora, Usuario usuario, String diametro, String longitudSN, String tipoTuberia) {

        //Guardamos la localización
        Localizacion l = guardarDatosLocalización(nombreLocalizacion, longitud, latitud);
        //Guardamos el fichero de caudal
        FicheroCaudal fc = guardarDatosFicheroCaudal(l, nombreFichero, tipo, listaCaudales);
        //Guardamos el calculo
        guardarCalculo(nombre, salto, saltoNeto, fc, turbinas, fechaHora, usuario, diametro, longitudSN, tipoTuberia);
    }

    private Localizacion guardarDatosLocalización(String nombreLocalizacion, String longitud, String latitud) {
        Localizacion l;
        //Buscamos si hay ya una localizacion con los mismos valores

        TypedQuery<Localizacion> queryLocalizacion = em.createNamedQuery("Localizacion.findLocalizacionRepetida", Localizacion.class);
        queryLocalizacion.setParameter("nombre", nombreLocalizacion);
        queryLocalizacion.setParameter("latitud", latitud);
        queryLocalizacion.setParameter("longitud", longitud);
        List<Localizacion> lLocalizacions;
        lLocalizacions = queryLocalizacion.getResultList();
        if (!lLocalizacions.isEmpty()) {
            l = lLocalizacions.get(0);
        } else {
            //Si no encontramos la localizacion en la base de datos, la creamos.
            l = new Localizacion();
            l.setNombre(nombreLocalizacion);
            l.setLatitud(latitud);
            l.setLongitud(longitud);
            persist(l);
        }

        return l;
    }

    private FicheroCaudal guardarDatosFicheroCaudal(Localizacion l, String nombreFichero, int tipo, String listaCaudales) {
        FicheroCaudal fc;
        //Fuscamos si el fichero ya se encuentra repetido
        TypedQuery<FicheroCaudal> queryFichero = em.createNamedQuery("FicheroCaudal.findFicheroRepetida", FicheroCaudal.class);
        queryFichero.setParameter("nombre", nombreFichero);
        queryFichero.setParameter("tipo", tipo);
        queryFichero.setParameter("listaCaudales", listaCaudales);
        queryFichero.setParameter("localizacion", l);
        List<FicheroCaudal> lFichero;
        lFichero = queryFichero.getResultList();
        if (!lFichero.isEmpty()) {
            fc = lFichero.get(0);
        } else {
            //Si no encontramos el fichero, lo creamos.
            fc = new FicheroCaudal();
            fc.setListaCaudales(listaCaudales);
            fc.setLocalizacion(l);
            fc.setNombre(nombreFichero);
            fc.setTipo(tipo);
            persist(fc);
        }

        return fc;
    }

    private void guardarCalculo(String nombre, String salto, boolean saltoNeto, FicheroCaudal fich, List<Turbinas> turbinas, Calendar fechaHora, Usuario usuario,
            String diametro, String longitud, String tipoTuberia) {
        Calculos calculo = new Calculos();
        calculo.setNombre(nombre);
        calculo.setSalto(salto);
        calculo.setSaltoNeto(saltoNeto);
        calculo.setFicheroCaudal(fich);
        if (!turbinas.isEmpty()) {
            calculo.setTurbinas(turbinas);
        }
        calculo.setUsuario(usuario);
        calculo.setFecha(fechaHora);
        if (!saltoNeto) {
            calculo.setDiametro(diametro);
            calculo.setLongitud(longitud);
            calculo.setTipoTurberia(tipoTuberia);
        }
        persist(calculo);
    }

    private List<Turbinas> buscarTurbinasDisponibles(Usuario u, HttpSession session) {

        //Buscamos las turbinas predeterminadas
        TypedQuery<Turbinas> queryTurbinas = em.createNamedQuery("Turbinas.findNuevas", Turbinas.class);
        queryTurbinas.setParameter("nueva", false);
        List<Turbinas> lTurbinasPredeterminadas;
        lTurbinasPredeterminadas = queryTurbinas.getResultList();

        //Buscamos las turbinas del usuario
        List<Turbinas> lTurbinasPropias = new ArrayList<>();
        if (u != null) {
            queryTurbinas = em.createNamedQuery("Turbinas.findPorDNI", Turbinas.class);
            queryTurbinas.setParameter("usuario", u);
            lTurbinasPropias = queryTurbinas.getResultList();
        }

        //Agrupamos las trubinas encontradas
        List<Turbinas> todasEncontradas = lTurbinasPredeterminadas;

        for (Turbinas turbina : lTurbinasPropias) {
            todasEncontradas.add(turbina);
        }

        //Buscamos la lista de turbinas bloqueadas para quitarlas de la lista
        ArrayList<Integer> listaBloqueos = (ArrayList<Integer>) session.getAttribute("turbinasBloqueadas");
        if (listaBloqueos != null) {
            for (Integer listaBloqueo : listaBloqueos) {
                for (int i = 0; i < todasEncontradas.size(); i++) {
                    if (todasEncontradas.get(i).getId().intValue() == listaBloqueo.intValue()) {
                        todasEncontradas.remove(todasEncontradas.get(i));
                        i--;//como elimino uno, todo se mueve a la izquierda, por lo que resto 1 para que se coja la misma posicion.
                    }
                }
            }

        }

        //Devolvemos todas las turbinas disponibles
        return todasEncontradas;
    }
}
