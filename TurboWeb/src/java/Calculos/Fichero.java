/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Calculos;

import java.util.ArrayList;

/**
 *
 * @author pablo
 */
public class Fichero {

    static int numCaudales[] = {0, 1, 24, 7, 4, 12, 4};//numero de caudales que tiene cada tipo de fichero( el tipo 2 tiene 24 caudales)
    private String nombre;
    private String contenido;
    private Integer tipoFichero;
    private String nombreLocalizacion;
    private Double latitud;
    private Double longitud;
    private ArrayList<Double> caudales;

    public Fichero(String contenido, String nombreFichero) {
        this.contenido = contenido;
        this.nombre = nombreFichero;
    }
    
    public Fichero(){
        
    }

    public boolean contenidoFichero() {
        //Vamos analizando la estructura del fichero devolviendo false si hay algun error
        //Guardamos la informacion del fichero mientras se analiza

        String contenidoPorLineas[] = contenido.split("\\+");//Dividimos el contenido por lineas en el fichero

        //comprobamos la primera linea
        String linea1[] = contenidoPorLineas[0].split(":");
        if (linea1.length > 2 || Integer.parseInt(linea1[1]) > numCaudales.length - 1) {
            return false;
        }

        //comprobamos el numero de lineas que tiene que tener el fichero segun su tipo
        if (contenidoPorLineas.length != 5 + numCaudales[Integer.parseInt(linea1[1])] + 1) {
            return false;
        }

        this.tipoFichero = Integer.parseInt(linea1[1]);

        String linea2[] = contenidoPorLineas[1].split(":");
        if (linea2.length >= 2) {
            nombreLocalizacion = linea2[1];
        }

        //comprobamos las coordenasdas
        String linea3[] = contenidoPorLineas[2].split(":");
        String linea4[] = contenidoPorLineas[3].split(":");
        if (linea3.length > 2 || linea4.length > 2) {
            return false;
        }
        //miramos que 1 coordenada este rellena y la otra vacia
        if (linea3.length == 1 && linea4.length == 2) {
            return false;
        }
        if (linea3.length == 2 && linea4.length == 1) {
            return false;
        }
        //miramos que las coordenadas sean numeros
        try {
            if (linea3.length == 2 && linea4.length == 2) {
                latitud = Double.parseDouble(linea3[1]);
                longitud = Double.parseDouble(linea4[1]);
            }
        } catch (NumberFormatException ex) {//Si hay algun fallo, es que no se ha podido hacer bien la conversion numerica
            return false;
        }
        //comprobamos todos los caudales
        caudales = new ArrayList<>();
        int limitFor = 5 + numCaudales[Integer.parseInt(linea1[1])];
        for (int i = 5; i < limitFor; i++) {
            try {
                caudales.add(Double.parseDouble(contenidoPorLineas[i]));
            } catch (NumberFormatException ex) {//Si hay algun fallo, es que no se ha podido hacer bien la conversion numerica
                return false;
            }
        }

        return true;
    }
    
    public void setCaudales(String c){
        //Cojo el string de caudales solo, y lo paso a caudales
        String[] cS=c.split(";");
        caudales=new ArrayList<>();
        for (String s : cS) {
         caudales.add(Double.parseDouble(s));
        }
    }

    public int getNumCaudales() {
        return numCaudales[tipoFichero];
    }
    
    public int getNumcaudales2(){//Se utiliza cuando la clase solo se le ha insertado los caudales manualmente y no mediante fichero (ver calculo guardado)
        return caudales.size();
    }
    
    public String getContenido() {
        return contenido;
    }

    public Integer getTipoFichero() {
        return tipoFichero;
    }

    public String getNombreLocalizacion() {
        if (nombreLocalizacion != null) {
            return nombreLocalizacion;
        } else {
            return "";
        }
    }

    public Double getLatitud() {
        return latitud;
    }

    public Double getLongitud() {
        return longitud;
    }

    public String getLatitudString() {
        if (latitud != null) {
            return latitud.toString();
        } else {
            return "";
        }
    }

    public String getLongitudString() {
        if (longitud != null) {
            return longitud.toString();
        } else {
            return "";
        }
    }

    public ArrayList<Double> getCaudales() {
        return caudales;
    }

    public double getCaudales(int pos) {
        return caudales.get(pos);
    }

    public double getMediaCaudales() {
        double media = 0;

        for (double c : caudales) {
            media += c;
        }
        return media / caudales.size();
    }
    
    public String getCaudalesString (){
        //Devuelvo los caudales en este formato: 1;2;3;55;5.5
        String c=caudales.get(0).toString();
        
        for (int i = 1; i < caudales.size(); i++) {
            c+=";"+caudales.get(i).toString();
        }
        
        return c;
    }

}
