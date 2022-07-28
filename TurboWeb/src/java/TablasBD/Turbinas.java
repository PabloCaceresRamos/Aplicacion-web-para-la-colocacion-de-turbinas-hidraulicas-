/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package TablasBD;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;

/**
 *
 * @author pablo
 */
@Entity
@NamedQueries({
    // Sintaxis  JPQL
    @NamedQuery(name = "Turbinas.findNuevas",
            query = "SELECT t FROM Turbinas t "
            + "WHERE t.nueva = :nueva"),
    @NamedQuery(name = "Turbinas.findPorDNI",
            query = "SELECT t FROM Turbinas t "
            + "WHERE t.usuarios = :usuario"),
    @NamedQuery(name = "Turbinas.findParaEliminar",
            query = "SELECT t FROM Turbinas t "
            + "WHERE t.usuarios = :usuario AND t.id=:id AND t.nueva=:nueva")
})
public class Turbinas implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
     Integer id;
    
    @Column(nullable = false)
    private String nombre;
    
    private String tipo;
    
    @Column(nullable = false)
    private boolean grafica;
    
    @Column(nullable = false)
    private boolean foto;
    
    @Column(nullable = false)
    private String puntos;
    
    @Column(nullable = false)
    private boolean nueva;//indica si es de las graficas predeterminadas, o de las nuevas que se han insertado mas tarde.
    
    @Column(nullable = false)
    private double eficiencia;
    
    @ManyToOne
    private Usuario usuarios;
    
    public Usuario getUsuarios() {
        return usuarios;
    }

    public void setUsuarios(Usuario usuarios) {
        this.usuarios = usuarios;
    }


    public double getEficiencia() {
        return eficiencia;
    }

    public void setEficiencia(double eficiencia) {
        this.eficiencia = eficiencia;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public boolean isGrafica() {
        return grafica;
    }

    public void setGrafica(boolean grafica) {
        this.grafica = grafica;
    }

    public boolean isFoto() {
        return foto;
    }

    public void setFoto(boolean foto) {
        this.foto = foto;
    }

    public String getPuntos() {
        return puntos;
    }

    public void setPuntos(String puntos) {
        this.puntos = puntos;
    }

    public boolean isNueva() {
        return nueva;
    }

    public void setNueva(boolean nueva) {
        this.nueva = nueva;
    }
    
    

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Turbinas)) {
            return false;
        }
        Turbinas other = (Turbinas) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "TablasBD.Turbinas[ id=" + id + " ]";
    }
    
}
