package com.SignupServlet;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/Settings3")
public class Settings3 extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String url = "jdbc:mysql://localhost:3306/signup";
        String user = "root";
        String pass = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, pass);

            if ("add".equals(action)) {
                String requestTypeName = request.getParameter("requestTypeName");
                PreparedStatement pst = conn.prepareStatement(
                    "INSERT INTO request_types (name) VALUES (?)"
                );
                pst.setString(1, requestTypeName);
                pst.executeUpdate();
                pst.close();

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String newName = request.getParameter("newName");
                PreparedStatement pst = conn.prepareStatement(
                    "UPDATE request_types SET name=? WHERE id=?"
                );
                pst.setString(1, newName);
                pst.setInt(2, id);
                pst.executeUpdate();
                pst.close();

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PreparedStatement pst = conn.prepareStatement(
                    "DELETE FROM request_types WHERE id=?"
                );
                pst.setInt(1, id);
                pst.executeUpdate();
                pst.close();
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect back to JSP after action
        response.sendRedirect("Settings3.jsp");
    }
}
