package com.SignupServlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ViewRequestAdmin")
public class ViewRequestAdminServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("adminName") == null){
            response.sendRedirect("LoginAdmin.jsp");
            return;
        }

        List<Request> requests = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/signup?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                    "root", "root")) {

                String sql = "SELECT s.id, s.user_id, u.name, s.request_type, s.from_date, s.to_date, s.total_days, " +
                             "COALESCE(s.status,'Pending') AS status, s.reason " +
                             "FROM submitreq s JOIN signuptb u ON s.user_id = u.id ORDER BY s.id DESC";

                try (PreparedStatement pst = con.prepareStatement(sql);
                     ResultSet rs = pst.executeQuery()) {

                    while(rs.next()){
                        requests.add(new Request(
                                rs.getInt("id"),
                                rs.getInt("user_id"),
                                rs.getString("name"),
                                rs.getString("request_type"),
                                rs.getString("from_date"),
                                rs.getString("to_date"),
                                rs.getInt("total_days"),
                                rs.getString("status"),
                                rs.getString("reason") != null ? rs.getString("reason") : ""
                        ));
                    }
                }
            }

        } catch(Exception e){
            e.printStackTrace();
        }

        request.setAttribute("requests", requests);
        request.getRequestDispatcher("Viewadmin.jsp").forward(request, response);
    }
}
