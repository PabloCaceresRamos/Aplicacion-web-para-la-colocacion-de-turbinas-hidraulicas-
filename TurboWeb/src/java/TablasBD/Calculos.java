/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package TablasBD;

import java.io.Serializable;
import java.util.Calendar;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author pablo
 */
@Entity
@Table(name="calculos")
@NamedQueries({
    @NamedQuery(name = "Calculos.calculosUsuarioySaltoNeto",
            query = "SELECT c FROM Calculos c "
            + "WHERE c.usuario = :usuario AND c.saltoNeto = :SaltoNeto"),
    @NamedQuery(name = "Calculos.calculosUsuarioYId",
            query = "SELECT c FROM Calculos c "
            + "WHERE c.usuario = :usuario AND c.id= :id"),
    @NamedQuery(name = "Calculos.calculosUsuario",
            query = "SELECT c FROM Calculos c "
            + "WHERE c.usuario = :usuario")
})
public class Calculos implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    @Column(nullable = false)
    private String nombre;
    @Column(nullable = false)
    private String salto;
    @Column(nullable = false)
    private boolean saltoNeto;
    
    private String diametro;
    private String longitud;
    private String tipoTurberia;
    
    @ManyToOne
    @JoinColumn(nullable = false)
    private FicheroCaudal ficheroCaudal;
    @ManyToOne
    @JoinColumn(nullable = false)
    private Usuario usuario;
    @ManyToMany
    private List<Turbinas> turbinas;
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(nullable = false)
    private Calendar fecha;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getSalto() {
        return salto;
    }

    public void setSalto(String salto) {
        this.salto = salto;
    }

    public boolean isSaltoNeto() {
        return saltoNeto;
    }

    public void setSaltoNeto(boolean saltoNeto) {
        this.saltoNeto = saltoNeto;
    }

    public FicheroCaudal getFicheroCaudal() {
        return ficheroCaudal;
    }

    public void setFicheroCaudal(FicheroCaudal ficheroCaudal) {
        this.ficheroCaudal = ficheroCaudal;
    }

    public List<Turbinas> getTurbinas() {
        return turbinas;
    }

    public void setTurbinas(List<Turbinas> turbinas) {
        this.turbinas = turbinas;
    }

    public Calendar getFecha() {
        return fecha;
    }

    public void setFecha(Calendar fecha) {
        this.fecha = fecha;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public String getDiametro() {
        return diametro;
    }

    public void setDiametro(String diametro) {
        this.diametro = diametro;
    }

    public String getLongitud() {
        return longitud;
    }

    public void setLongitud(String longitud) {
        this.longitud = longitud;
    }

    public String getTipoTurberia() {
        return tipoTurberia;
    }

    public void setTipoTurberia(String tipoTurberia) {
        this.tipoTurberia = tipoTurberia;
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
        if (!(object instanceof Calculos)) {
            return false;
        }
        Calculos other = (Calculos) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "TablasBD.Calculos[ id=" + id + " ]";
    }

}
