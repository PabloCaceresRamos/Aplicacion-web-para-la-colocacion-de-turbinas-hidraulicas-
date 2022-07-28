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
public class Figura {
    static Double porcentajeAceptacion=0.10;//porcentaje con el que aceptamos caudales rechazados(si de 12 caudales rechazamos 1, el 10% de 12 es 1.2 que es mayor que 1, por lo que aceptamos el conjunto)
   
    private final Punto[] F;
    private ArrayList<Double> caudales;
    private ArrayList<Boolean> caudalesDentro;//True si el caudal ha sido aceptado y false si ha sido rechazado
    private int numCaudalesRechazados;

    public Figura(Punto[] F) {
        this.F = F;
    }
    
    public Figura(String puntos) {
        //llegan los puntos en forma de string, hay que dividirlos y pasarlos a un array de puntos
        String [] division=puntos.split(";");
        
        Punto [] P= new Punto [division.length];
        
        for(int i=0;i<division.length;i++){
            String [] puntoAux=division[i].split(",");
            Double [] puntoDouble={Double.parseDouble(puntoAux[0]),Double.parseDouble(puntoAux[1])};
            P[i]=new Punto(puntoDouble[0],puntoDouble[1]);
        }
        
        this.F=P;
    }

    /*
    *El metodo "dentro" es una modificacion y traduccion de un codigo escrito en
    *C que se encuentra en el siguiente blog.
    *https://jsbsan.blogspot.com/2011/01/saber-si-un-punto-esta-dentro-o-fuera.html?m=1
    */

    
    
    
    public boolean dentro(Punto p) {
        Punto vertice1, vertice2;
        int numVertices = F.length;
        double xinters;
        int counter = 0;
        vertice1 = F[0];
        for (int i = 1; i <= numVertices; i++) {
            vertice2 = F[i % numVertices];
            if (vertice1.getY() == p.getY() && vertice1.getX() == p.getX())//esto devuelve true si el punto es un vertice
            {
                return true;
            }
            if (p.getY() > Punto.menor(vertice1.getY(), vertice2.getY())) {
                if (p.getY() <= Punto.mayor(vertice1.getY(), vertice2.getY())) {
                    if (p.getX() <= Punto.mayor(vertice1.getX(), vertice2.getX())) {
                        if (vertice1.getY() != vertice2.getY()) {
                            xinters = ((p.getY() - vertice1.getY()) * (vertice2.getX() - vertice1.getX())
                                    / (vertice2.getY() - vertice1.getY()) + vertice1.getX());
                            if (vertice1.getX() == vertice2.getX() || p.getX() <= xinters) {
                                counter++;
                            }
                        }
                    }
                }

            }
            vertice1 = vertice2;

        }

        if (counter % 2 == 0) {
            return false;
        } else {
            return true;
        }
    }

    public boolean turbinaDisponible(Double saltoNeto,ArrayList<Double> caudales) { //Recibe los caudales y devuelve si la turbina los soporta
        
        caudalesDentro=new ArrayList<>();
        this.caudales=caudales;
        numCaudalesRechazados=0;
        
        for(int i=0;i<caudales.size();i++){//para cada caudal vemos si esta dentro o fuera y el resultado lo añadimos a la lista. Contamos los rechazados
           boolean bAux=this.dentro(new Punto(caudales.get(i), saltoNeto));
           if(!bAux) numCaudalesRechazados++;
           caudalesDentro.add(bAux);    
        }
        
        if(caudales.size()*porcentajeAceptacion>=numCaudalesRechazados){//miramos si superamos el maximo de rechazados permitido por el porcentaje y el numero de caudales
            return true;
        }else{
            return false;
        }
        
    }
    //Busca las turbinas disponibles pero recibiendo una lista de saltos netos
    public boolean turbinaDisponible(double [] saltoNeto,ArrayList<Double> caudales) { //Recibe los caudales y devuelve si la turbina los soporta
        
        caudalesDentro=new ArrayList<>();
        this.caudales=caudales;
        numCaudalesRechazados=0;
        
        for(int i=0;i<caudales.size();i++){//para cada caudal vemos si esta dentro o fuera y el resultado lo añadimos a la lista. Contamos los rechazados
           boolean bAux=this.dentro(new Punto(caudales.get(i), saltoNeto[i]));
           if(!bAux) numCaudalesRechazados++;
           caudalesDentro.add(bAux);    
        }
        
        if(caudales.size()*porcentajeAceptacion>=numCaudalesRechazados){//miramos si superamos el maximo de rechazados permitido por el porcentaje y el numero de caudales
            return true;
        }else{
            return false;
        }
        
    }
    
    public double caudalMedioAceptado(){
        double media=0.0;
        int caudalesAceptados=0;
        
        for(int i=0;i<caudales.size();i++){
            if(caudalesDentro.get(i)) {//si el caudal ha sido aceptado, lo tenemos en cuenta para la media
                media+= caudales.get(i);
                caudalesAceptados++;
            }
        }
        
        media=media/caudalesAceptados;
        
        return media;
    }
    
    static public boolean comprobarPuntos(String puntos) {
        //comprobamos todos los puntos y si no hay fallo significa que esta todo correcto
        try{
        String [] division=puntos.split(";");
        
        Punto [] P= new Punto [division.length];
        
        for(int i=0;i<division.length;i++){
            String [] puntoAux=division[i].split(",");
            Double [] puntoDouble={Double.parseDouble(puntoAux[0]),Double.parseDouble(puntoAux[1])};
            P[i]=new Punto(puntoDouble[0],puntoDouble[1]);
        }
        
        return true;
        }catch(NumberFormatException ex){
            return false;
        }
    }
}
