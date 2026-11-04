package com.SignupServlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;

@WebServlet("/SubmitRequest")
@MultipartConfig
public class SubmitRequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("Session is null or user not logged in!");
            response.sendRedirect("LoginEmployee.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String requestType = request.getParameter("requestType");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String totalDaysStr = request.getParameter("totalDays");
        int totalDays = (totalDaysStr != null && !totalDaysStr.isEmpty()) ? Integer.parseInt(totalDaysStr) : 0;
        String reason = request.getParameter("reason");

        Part filePart = request.getPart("attachment");
        InputStream attachmentStream = null;
        if (filePart != null && filePart.getSize() > 0) {
            attachmentStream = filePart.getInputStream();
        }

        System.out.println("Submitting request for userId: " + userId);
        System.out.println("RequestType: " + requestType + ", From: " + fromDate + ", To: " + toDate + ", TotalDays: " + totalDays);
        System.out.println("Reason: " + reason + ", Attachment present: " + (attachmentStream != null));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/signup?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                    "root", "root")) {

                String sql = "INSERT INTO submitreq (user_id, request_type, from_date, to_date, total_days, reason, attachment) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?)";

                try (PreparedStatement pst = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    pst.setInt(1, userId);
                    pst.setString(2, requestType);
                    pst.setDate(3, Date.valueOf(fromDate));
                    pst.setDate(4, Date.valueOf(toDate));
                    pst.setInt(5, totalDays);
                    pst.setString(6, reason);

                    if (attachmentStream != null) {
                        pst.setBlob(7, attachmentStream);
                    } else {
                        pst.setNull(7, Types.BLOB);
                    }

                    int rows = pst.executeUpdate();
                    System.out.println("Rows inserted: " + rows);

                    if (rows > 0) {
                        try (ResultSet generatedKeys = pst.getGeneratedKeys()) {
                            if (generatedKeys.next()) {
                                int requestId = generatedKeys.getInt(1);
                                System.out.println("Request submitted successfully with ID: " + requestId);
                            }
                        }
                        response.sendRedirect("ViewRequest"); // Redirect to employee view
                    } else {
                        System.out.println("Failed to insert request.");
                        response.sendRedirect("SubmitRequest.jsp?error=1");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("SubmitRequest.jsp?error=1");
        }
    }
}
