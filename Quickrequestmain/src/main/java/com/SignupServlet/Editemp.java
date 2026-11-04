package com.SignupServlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/EditProfile")
public class Editemp extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String dept = request.getParameter("dept");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/signup", "root", "root")) {

                PreparedStatement pst = con.prepareStatement(
                        "UPDATE signuptb SET name=?, dept=?, phone=?, email=? WHERE id=?");

                pst.setString(1, name);
                pst.setString(2, dept);
                pst.setString(3, phone);
                pst.setString(4, email);
                pst.setInt(5, Integer.parseInt(id));

                int rows = pst.executeUpdate();

                if (rows > 0) {
                    // Update session values
                    HttpSession session = request.getSession();
                    session.setAttribute("name", name);
                    session.setAttribute("dept", dept);
                    session.setAttribute("phone", phone);
                    session.setAttribute("email", email);

                    // Redirect with success param
                    response.sendRedirect("Editprofile.jsp?success=true");
                } else {
                    response.sendRedirect("Editprofile.jsp?success=false");
                }
            }
        } catch (Exception e) {
            throw new ServletException("Edit profile failed", e);
        }
    }
}
