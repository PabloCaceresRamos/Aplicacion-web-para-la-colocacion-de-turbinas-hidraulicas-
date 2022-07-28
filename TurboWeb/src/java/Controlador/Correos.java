/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controlador;

import TablasBD.Usuario;
import java.security.NoSuchAlgorithmException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 *
 * @author pablo
 */
public class Correos {
    public static void enviarCorreoVerificacion(String correo) {
        Properties propiedad = new Properties();
        propiedad.setProperty("mail.smtp.host", "smtp.gmail.com");//propiedad host
        propiedad.setProperty("mail.smtp.starttls.enable", "true");//propiedad TLS
        propiedad.setProperty("mail.smtp.port", "587");//puerto
        propiedad.setProperty("mail.smtp.auth", "true");//autenticacion

        Session sesion = Session.getDefaultInstance(propiedad);

        String correoWeb = "tuhiweb@gmail.com";
        String contrasena = "webtuhi888";

        MimeMessage mail = new MimeMessage(sesion);
        try {
            mail.setFrom(new InternetAddress(correoWeb));
            mail.addRecipient(Message.RecipientType.TO, new InternetAddress(/*"pablocaceres1999@gmail.com"*/correo));
            mail.setSubject("Verificación de TuhiWeb");
            mail.setText("Entra en el siguiente enlace para verificar su cuenta:\n"
                    + "http://localhost:8080/TurboWeb/Controlador/Verificar?correo=" + correo);

            Transport transport = sesion.getTransport("smtp");
            transport.connect(correoWeb, contrasena);
            transport.sendMessage(mail, mail.getRecipients(Message.RecipientType.TO));
            transport.close();
        } catch (MessagingException ex) {
            Logger.getLogger(Controlador.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public static void enviarCorreoRecuperarContrasena(String correo, Usuario u) throws NoSuchAlgorithmException {
        Properties propiedad = new Properties();
        propiedad.setProperty("mail.smtp.host", "smtp.gmail.com");//propiedad host
        propiedad.setProperty("mail.smtp.starttls.enable", "true");//propiedad TLS
        propiedad.setProperty("mail.smtp.port", "587");//puerto
        propiedad.setProperty("mail.smtp.auth", "true");//autenticacion

        Session sesion = Session.getDefaultInstance(propiedad);

        String correoWeb = "tuhiweb@gmail.com";
        String contrasena = "webtuhi888";

        MimeMessage mail = new MimeMessage(sesion);
        try {
            mail.setFrom(new InternetAddress(correoWeb));
            mail.addRecipient(Message.RecipientType.TO, new InternetAddress(/*"pablocaceres1999@gmail.com"*/correo));
            mail.setSubject("Recuperación contraseña de TuhiWeb");
            mail.setText("Entra en el siguiente enlace para cambiar su contraseña:\n"
                    + "http://localhost:8080/TurboWeb/Controlador/RecuperarContrasenaPerdida?correo=" + Encriptado.encriptarDatosRecuperarContrasena(u));

            Transport transport = sesion.getTransport("smtp");
            transport.connect(correoWeb, contrasena);
            transport.sendMessage(mail, mail.getRecipients(Message.RecipientType.TO));
            transport.close();
        } catch (MessagingException ex) {
            Logger.getLogger(Controlador.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
