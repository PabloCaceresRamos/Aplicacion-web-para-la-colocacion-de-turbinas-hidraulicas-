/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Calculos;

/**
 *
 * @author pablo
 */
public class Punto {
    private double x;
    private double y;
    
    public Punto(double x,double y){
        this.x=x;
        this.y=y;
    }
    
    public double getX(){
        return x;
    }

    public double getY() {
        return y;
    }

    public void setY(double y) {
        this.y = y;
    }
    
    public void setX(double x) {
        this.x = x;
    }
    
    static public double menor(double x1,double x2){
        if(x1<x2) return x1;
        else return x2;
    }
    
    static public double mayor(double x1,double x2){
        if(x1>x2) return x1;
        else return x2;
    }    
}
