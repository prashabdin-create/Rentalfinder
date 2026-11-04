package com.SignupServlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/LoginAdmin")
public class LoginAdmin extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/signup?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                    "root", "root")) {

            	String sql = "SELECT name FROM signupadmin WHERE name=? AND password=?";
            	try (PreparedStatement pst = con.prepareStatement(sql)) {
            	    pst.setString(1, name);
            	    pst.setString(2, password);

            	    try (ResultSet rs = pst.executeQuery()) {
            	        if (rs.next()) {
            	            // No adminId in table, you can just use name as session attribute
            	        	HttpSession session = request.getSession();
            	        	 session.setAttribute("adminName", rs.getString("name"));
                             response.sendRedirect("Mainadmin.jsp");
            	        } else {
            	            response.sendRedirect("LoginAdmin.jsp?error=1");
            	        }
            	    }
            	}
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("LoginAdmin.jsp?error=1");
        }
    }
}
