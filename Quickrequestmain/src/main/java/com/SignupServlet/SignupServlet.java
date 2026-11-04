package com.SignupServlet;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/Signup")
public class SignupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String dept = request.getParameter("dept");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Debug: Log inputs
        System.out.println("Inserting data: " + name + ", " + dept + ", " + phone + ", " + email);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/signup?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                    "root", "root");
                 PreparedStatement pst = con.prepareStatement(
                         "INSERT INTO signuptb(name, dept, phone, email, password) VALUES(?,?,?,?,?)",
                         Statement.RETURN_GENERATED_KEYS)) {

                pst.setString(1, name);
                pst.setString(2, dept);
                pst.setString(3, phone);
                pst.setString(4, email);
                pst.setString(5, password);

                int rows = pst.executeUpdate();
                System.out.println("Rows affected: " + rows);

                // Check if the row was inserted successfully
                if (rows > 0) {
                    ResultSet rs = pst.getGeneratedKeys();
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        System.out.println("Generated userId: " + id);

                        HttpSession session = request.getSession();
                        session.setAttribute("userId", id);
                        session.setAttribute("name", name);
                        session.setAttribute("email", email);

                        response.sendRedirect("Main.jsp");
                    }
                } else {
                    System.out.println("Signup failed.");
                    request.setAttribute("errorMessage", "Signup failed. Try again.");
                    request.getRequestDispatcher("SignupEmployee.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("SignupEmployee.jsp").forward(request, response);
        }
    }
}
