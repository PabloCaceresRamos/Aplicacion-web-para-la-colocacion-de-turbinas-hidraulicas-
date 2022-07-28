/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controlador;

import TablasBD.Usuario;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.spec.KeySpec;
import java.util.Base64;
import java.util.List;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

/**
 *
 * @author pablo
 */
public class Encriptado {

    public static String encriptarMensaje(String s) throws NoSuchAlgorithmException{
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(s.getBytes());
        byte[] digest = md.digest();
        StringBuilder sb = new StringBuilder();
        for (byte b : digest) {
            sb.append(String.format("%02x", b & 0xff));
        }
        return sb.toString();
    }
    
    public static boolean comprobarEncriptacion(String enc,String s)throws NoSuchAlgorithmException{
        //mandamos una cadena y una encriptada, y vemos si la cadena es la cadena encriptada
        String sEnc=encriptarMensaje(s);
        if(enc.equals(sEnc)) return true;
        else return false;
    }
    
        public static String encriptarDatosRecuperarContrasena(Usuario u) throws NoSuchAlgorithmException {
        String s;
        String correo = u.getCorreo();

        s = correo + "-*-*-" + Encriptado.encriptarMensaje(u.getFecha_registro());

        return s;

    }

    public static String desencriptarDatosRecuperarContrasena(String datos,EntityManager em) throws NoSuchAlgorithmException {
        String[] s2 = datos.split("-\\*-\\*-");
        String correo = null;
        //miramos si el correo pertenece a algun usuario
        TypedQuery<Usuario> queryUsuario = em.createNamedQuery("Usuario.findByEmail", Usuario.class);
        queryUsuario.setParameter("email", s2[0]);

        List<Usuario> lUsuario;
        lUsuario = queryUsuario.getResultList();
        if (!lUsuario.isEmpty() && s2.length == 2 && Encriptado.comprobarEncriptacion(s2[1], lUsuario.get(0).getFecha_registro())) {
            correo = s2[0];
        }
        //si no hay usuario con ese correo, se devuelve null

        return correo;

    }

}
