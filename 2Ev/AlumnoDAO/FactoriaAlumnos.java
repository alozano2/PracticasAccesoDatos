
package accesoadatos.AlumnoDAO;

public class FactoriaAlumnos {
    public static AlumnoInterface getAlumnoDao() {
        return new AlumnoBean();
    }
}

