/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package TablasBD;

import com.sun.istack.Nullable;
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
    @NamedQuery(name = "FicheroCaudal.findFicheroRepetida",
            query = "SELECT f FROM FicheroCaudal f "
            + "WHERE f.nombre = :nombre AND f.tipo = :tipo AND f.listaCaudales = :listaCaudales AND f.localizacion = :localizacion"),
})
public class FicheroCaudal implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;
    
    @Column(nullable = false)
    private String nombre;
    
    @Column(nullable = false)
    private int tipo;
    
    @Column(nullable = false)
    private String listaCaudales;
    
    @ManyToOne
    Localizacion localizacion;

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getTipo() {
        return tipo;
    }

    public void setTipo(int tipo) {
        this.tipo = tipo;
    }

    public String getListaCaudales() {
        return listaCaudales;
    }

    public void setListaCaudales(String listaCaudales) {
        this.listaCaudales = listaCaudales;
    }

    public Localizacion getLocalizacion() {
        return localizacion;
    }

    public void setLocalizacion(Localizacion localizacion) {
        this.localizacion = localizacion;
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
        if (!(object instanceof FicheroCaudal)) {
            return false;
        }
        FicheroCaudal other = (FicheroCaudal) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "TablasBD.FicheroCaudal[ id=" + id + " ]";
    }
    
}
