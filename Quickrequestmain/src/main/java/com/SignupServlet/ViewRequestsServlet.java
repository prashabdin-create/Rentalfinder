package com.SignupServlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ViewRequest")
public class ViewRequestsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            response.sendRedirect("LoginEmployee.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        List<Request> requests = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/signup?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                    "root", "root")) {

                String sql = "SELECT id, request_type, from_date, to_date, total_days, " +
                             "COALESCE(status,'Pending') AS status, reason " +
                             "FROM submitreq WHERE user_id=? ORDER BY id DESC";

                try (PreparedStatement pst = con.prepareStatement(sql)) {
                    pst.setInt(1, userId);
                    try (ResultSet rs = pst.executeQuery()) {
                        while(rs.next()){
                            requests.add(new Request(
                                rs.getInt("id"),
                                userId,
                                "", // name not needed for employee view
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
            }

        } catch(Exception e){ 
            e.printStackTrace(); 
        }

        request.setAttribute("requests", requests);
        request.getRequestDispatcher("ViewEmp.jsp").forward(request, response);
    }
}
