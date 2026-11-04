package com.SignupServlet;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AdminServlet")
public class Setting1 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection
    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver"); // or your driver
        return DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/signup", "root", "root"); // change DB info
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Always fetch admin list
        List<String[]> admins = fetchAdmins();
        request.setAttribute("admins", admins);
        request.getRequestDispatcher("Settings1.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String name = request.getParameter("name");

        try (Connection conn = getConnection()) {
            if ("add".equals(action)) {
                String password = request.getParameter("password");
                PreparedStatement ps = conn.prepareStatement("INSERT INTO signupadmin(name,password) VALUES(?,?)");
                ps.setString(1, name);
                ps.setString(2, password);
                ps.executeUpdate();
                request.setAttribute("message", "Admin added successfully!");
            } else if ("delete".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("DELETE FROM signupadmin WHERE name=?");
                ps.setString(1, name);
                ps.executeUpdate();
                request.setAttribute("message", "Admin deleted successfully!");
            } else if ("update".equals(action)) {
                String oldPassword = request.getParameter("oldPassword");
                String newPassword = request.getParameter("newPassword");

                // Check old password
                PreparedStatement check = conn.prepareStatement("SELECT * FROM signupadmin WHERE name=? AND password=?");
                check.setString(1, name);
                check.setString(2, oldPassword);
                ResultSet rs = check.executeQuery();
                if (rs.next()) {
                    PreparedStatement ps = conn.prepareStatement("UPDATE signupadmin SET password=? WHERE name=?");
                    ps.setString(1, newPassword);
                    ps.setString(2, name);
                    ps.executeUpdate();
                    request.setAttribute("message", "Password updated successfully!");
                } else {
                    request.setAttribute("message", "Old password is incorrect!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
        }

        // Fetch updated list and forward to JSP
        List<String[]> admins = fetchAdmins();
        request.setAttribute("admins", admins);
        request.getRequestDispatcher("Settings1.jsp").forward(request, response);
    }

    private List<String[]> fetchAdmins() {
        List<String[]> list = new ArrayList<>();
        try (Connection conn = getConnection()) {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT id, name, password FROM signupadmin");
            while (rs.next()) {
                list.add(new String[]{
                    String.valueOf(rs.getInt("id")),
                    rs.getString("name"),
                    rs.getString("password")
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
