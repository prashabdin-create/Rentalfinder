package com.SignupServlet;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/EmployeeServlet")
public class Settings2 extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/signup";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            if ("addEmployee".equals(action)) {
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String dept = request.getParameter("dept");

                PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO signuptb(name, email, dept) VALUES (?, ?, ?)");
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, dept);
                ps.executeUpdate();
                ps.close();

                // Success message
                request.setAttribute("errorMsg", "✅ Employee added successfully!");
                request.getRequestDispatcher("Settings2.jsp").forward(request, response);
                return;

            } else if ("deleteEmployee".equals(action)) {
                int idToDelete = Integer.parseInt(request.getParameter("idToDelete"));

                // 1️⃣ Delete linked requests first (if any)
                PreparedStatement delReq = con.prepareStatement(
                        "DELETE FROM submitreq WHERE user_id=?");
                delReq.setInt(1, idToDelete);
                delReq.executeUpdate();
                delReq.close();

                // 2️⃣ Then delete the employee
                PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM signuptb WHERE id=?");
                ps.setInt(1, idToDelete);
                ps.executeUpdate();
                ps.close();

                // Success message
                request.setAttribute("errorMsg", "✅ Employee deleted successfully!");
                request.getRequestDispatcher("Settings2.jsp").forward(request, response);
                return;
            }

            con.close();
            response.sendRedirect("Settings2.jsp"); // fallback reload page

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
