package com.SignupServlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/UpdateRequestStatus")
public class UpdateRequestStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String status = request.getParameter("status");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/signup?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                    "root", "root")) {

                String sql = "UPDATE submitreq SET status = ? WHERE id = ? AND (status IS NULL OR status = 'Pending')";
                try (PreparedStatement pst = con.prepareStatement(sql)) {
                    pst.setString(1, status);
                    pst.setInt(2, Integer.parseInt(id));
                    pst.executeUpdate();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("ViewRequestAdmin");
    }
}
