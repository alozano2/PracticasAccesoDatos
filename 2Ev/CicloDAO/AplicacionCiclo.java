
package accesoadatos.CicloDAO;


public class AplicacionCiclo {
    public static void main(String[] args) {

        CicloInterface objetoDAO = FactoriaCiclos.getCicloDao();

        CicloInterface ciclo1 = objetoDAO.getNuevoCiclo("566734", "DESARROLLO DE APLICACIONES MULTIPLATAFORMA", "SUPERIOR");
    }
}