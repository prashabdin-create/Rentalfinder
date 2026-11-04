<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*, java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Submit New Request</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <style>
        body {
      background: linear-gradient(135deg, #f0f4ff, #e4efff);
      font-family: 'Segoe UI', sans-serif;
      min-height: 100vh;
    }

    .navbar-brand h3 {
      margin: 0;
      font-weight: 700;
      color: #0d6efd;
    }

    #logo {
      border-radius: 100px;
    }

    .profile-card {
      border: 1px solid #e0e0e0;
      border-radius: 10px;
      padding: 15px;
      background: #fff;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      max-width: 140px;
      cursor: pointer;
      text-decoration: none;
      color: inherit;
    }

    .user-image {
      border-radius: 50%;
      border: 2px solid #0d6efd;
      transition: transform 0.3s ease;
    }

    .user-image:hover {
      transform: scale(1.1);
    }

    .profile-name {
      margin-top: 10px;
      font-weight: 600;
      font-size: 0.9rem;
      color: #333;
    }

    .form-container {
      max-width: 800px;
      background: #fff;
      padding: 40px;
      border-radius: 15px;
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
      margin: 60px auto;
    }

    .form-container h2 {
      font-weight: 700;
      color: #0d6efd;
    }

    .btn-primary {
      background: #0d6efd;
      border: none;
      transition: background 0.3s ease;
    }

    .btn-primary:hover {
      background: #084dbf;
    }

    .nav-underline {
      position: relative;
      display: inline-block;
      color: #333;
      text-decoration: none;
      transition: color 0.3s ease;
      padding-bottom: 4px;
    }

    .nav-underline::after {
      content: "";
      position: absolute;
      width: 0;
      height: 2px;
      left: 0;
      bottom: 0;
      background-color: #007bff;
      transition: width 0.3s ease;
    }

    .nav-underline:hover::after,
    .nav-underline.active::after {
      width: 100%;
    }

    .nav-underline.active {
      color: #007bff;
    }

    .nav-underline:hover {
      color: #007bff;
    }

   
    @media (max-width: 768px) {
      .form-container {
        padding: 25px;
        margin: 30px 15px;
      }

      .form-container h2 {
        font-size: 1.5rem;
      }

      .profile-card {
        max-width: 120px;
        padding: 10px;
      }

      .user-image {
        height: 50px;
        width: 50px;
      }

      .profile-name {
        font-size: 0.8rem;
      }

      .navbar-brand h3 {
        font-size: 1.3rem;
      }
    }

    @media (max-width: 480px) {
      .form-container {
        padding: 20px 15px;
        margin: 20px 10px;
      }

      .form-container h2 {
        font-size: 1.3rem;
      }

      .profile-card {
        max-width: 100px;
      }

      .user-image {
        height: 45px;
        width: 45px;
      }

      .profile-name {
        font-size: 0.75rem;
      }

      .navbar-brand h3 {
        font-size: 1.1rem;
      }

      .btn-primary {
        width: 100%;
        padding: 10px;
      }

      .row.g-3 > .col-md-4 {
        flex: 0 0 100%;
        max-width: 100%;
      }
    }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg bg-body-tertiary shadow-sm py-3">
    <div class="container-fluid">
      <a class="navbar-brand d-flex align-items-center gap-2" href="#">
        <img src="images/Lgo - Copy.png" alt="Logo" height="45" width="50" id="logo">
        <h3>QuickRequest</h3>
      </a>

      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMenu">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse justify-content-end" id="navbarMenu">
        <ul class="navbar-nav gap-4">
          <li class="nav-item">
            <a class="nav-link nav-underline " href="Main.jsp">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link nav-underline" href="Editprofile.jsp">Edit Profile</a>
          </li>
          <li class="nav-item">
<a class="nav-link nav-underline" href="ViewRequest">View Requests</a>
          </li>
          <li class="nav-item">
            <a class="nav-link nav-underline active" href="SubmitRequest.jsp">Submit New Requests</a>
          </li>
          <li class="nav-item">
            <a class="btn btn-primary rounded-pill px-4 fw-semibold" href="Logout.jsp">Log Out</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>

<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("LoginEmployee.jsp");
        return;
    }

    int userId = (int) session.getAttribute("userId");
    String name = "", email = "", department = "", mobile = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/signup?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
            "root", "root");

        PreparedStatement pst = con.prepareStatement("SELECT name, email, phone, dept FROM signuptb WHERE id = ?");
        pst.setInt(1, userId);
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            department = rs.getString("dept");
            mobile = rs.getString("phone");
        }

        rs.close();
        pst.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<div class="container">
    <div class="form-container">
        <h2 class="mb-4 text-center">Submit New Request</h2>
        <form method="post" action="SubmitRequest" enctype="multipart/form-data">
            <div class="mb-3">
                <label for="name" class="form-label">Name:</label>
                <input type="text" class="form-control" id="name" name="name" value="<%= name %>" readonly>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email:</label>
                <input type="email" class="form-control" id="email" name="email" value="<%= email %>" readonly>
            </div>

            <div class="mb-3">
                <label for="mobile" class="form-label">Mobile No:</label>
                <input type="tel" class="form-control" id="mobile" name="phone" value="<%= mobile %>" readonly>
            </div>

            <div class="mb-3">
                <label for="department" class="form-label">Department:</label>
                <input type="text" class="form-control" id="dept" name="dept" value="<%= department %>" readonly>
            </div>

            <div class="mb-3">
                <label for="requestType" class="form-label">Request Type:</label>
                <select name="requestType" class="form-control" required>
    <%
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/signup","root","root");
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM request_types");
        while(rs.next()) {
    %>
        <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %></option>
    <%
        }
        rs.close();
        st.close();
        conn.close();
    %>
</select>

            </div>

            <div class="row g-3">
                <div class="col-md-4">
                    <label for="fromDate" class="form-label">From Date:</label>
                    <input type="date" class="form-control" id="fromDate" name="fromDate" required>
                </div>
                <div class="col-md-4">
                    <label for="toDate" class="form-label">To Date:</label>
                    <input type="date" class="form-control" id="toDate" name="toDate" required>
                </div>
                <div class="col-md-4">
                    <label for="totalDays" class="form-label">Total Days:</label>
                    <input type="number" class="form-control" id="totalDays" name="totalDays" min="1" readonly required>
                </div>
            </div>

            <div class="mb-3 mt-3">
                <label for="reason" class="form-label">Reason:</label>
                <textarea class="form-control" id="reason" name="reason" rows="5" required></textarea>
            </div>

            <div class="mb-3">
                <label for="attachment" class="form-label">Attachment (optional):</label>
                <input type="file" class="form-control" id="attachment" name="attachment">
            </div>

            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary px-5">Submit</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.getElementById("fromDate").addEventListener("change", calculateDays);
    document.getElementById("toDate").addEventListener("change", calculateDays);

    function calculateDays() {
        const from = new Date(document.getElementById("fromDate").value);
        const to = new Date(document.getElementById("toDate").value);
        
        if (from && to && !isNaN(from) && !isNaN(to) && to >= from) {
            const timeDiff = Math.abs(to - from);
            const totalDays = Math.ceil(timeDiff / (1000 * 60 * 60 * 24)) + 1;
            document.getElementById("totalDays").value = totalDays;
        } else {
            document.getElementById("totalDays").value = '';
        }
    }

    <% if ("1".equals(request.getParameter("success"))) { %>
        alert("Request submitted successfully!");
    <% } else if ("1".equals(request.getParameter("error"))) { %>
        alert("Failed to submit request. Please try again.");
    <% } %>
</script>

</body>
</html>
