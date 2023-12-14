
package accesoadatos;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AccesoADatos {

    public static void main(String[] args) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            // Establecer la conexión con la base de datos
            String url = "jdbc:mysql://localhost:3306/AccesoADatos"; 
            String user = "root";
            String password = "";
            connection = DriverManager.getConnection(url, user, password);
            
            // Consulta SQL para obtener los empleados del departamento 30
            String sql = "SELECT e.employee_id, e.first_name, j.job_id, j.function " +
                     "FROM employee e " +
                     "JOIN job j ON e.job_id = j.job_id " +
                     "WHERE e.department_id = 30";

            preparedStatement = connection.prepareStatement(sql); // Aquí se crea el PreparedStatement con la consulta

            // Ejecutar la consulta
            resultSet = preparedStatement.executeQuery();
            
            // Mostrar los resultados
            while (resultSet.next()) {
                int id = resultSet.getInt("employee_id");
                String nombre = resultSet.getString("first_name");
                String funcion = resultSet.getString("function");
                // Continuar con los campos adicionales que tengas en la tabla
                
                System.out.println("ID: " + id + ", Nombre: " + nombre + ", Funcion: " + funcion);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Cerrar conexiones y recursos
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
