/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package accesoadatos.CicloDAO;

public interface CicloInterface {
    public CicloInterface getNuevoCiclo(String codciclo,String descripcion,String  grado);
    
    public String getCodCiclo();
    public String getDescripcion();
    public String getGrado();
    
    public void  setDescripcion(String descripcion);
    public void  setGrado(String grado);
}
