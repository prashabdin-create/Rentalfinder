<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.SignupServlet.Request, java.util.List" %>
<%
    if(session == null || session.getAttribute("userId") == null){
        response.sendRedirect("LoginEmployee.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Requests - Employee</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
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
    }</style>
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
            <a class="nav-link nav-underline " href="Editprofile.jsp">Edit Profile</a>
          </li>
          <li class="nav-item">
<a class="nav-link nav-underline active" href="ViewRequest">View Requests</a>
          </li>
          <li class="nav-item">
            <a class="nav-link nav-underline" href="SubmitRequest.jsp">Submit New Requests</a>
          </li>
          <li class="nav-item">
            <a class="btn btn-primary rounded-pill px-4 fw-semibold" href="Logout">Log Out</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
<div class="container mt-4">
    <h2 class="mb-3">My Requests</h2>
    <%
        List<Request> requests = (List<Request>) request.getAttribute("requests");
        if (requests != null && !requests.isEmpty()) {
    %>
    <table class="table table-bordered text-center">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Type</th>
            <th>Status</th>
            <th>Reason</th> <!-- Reason column -->
            <th>From</th>
            <th>To</th>
            <th>Total Days</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (Request r : requests) {
        %>
        <tr>
            <td><%= r.getId() %></td>
            <td><%= r.getRequestType() %></td>
            <td>
                <span class="badge 
                    <%= "Accepted".equalsIgnoreCase(r.getStatus()) ? "bg-success" 
                        : ("Rejected".equalsIgnoreCase(r.getStatus()) ? "bg-danger" : "bg-warning text-dark") %>">
                    <%= (r.getStatus() == null || r.getStatus().trim().isEmpty()) ? "Pending" : r.getStatus() %>
                </span>
            </td>
            <td><%= r.getReason() %></td> <!-- Display reason -->
            <td><%= r.getFromDate() %></td>
            <td><%= r.getToDate() %></td>
            <td><%= r.getTotalDays() %></td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <%
        } else {
    %>
        <p class="text-muted">No requests submitted yet.</p>
    <%
        }
    %>
</div>
</body>
</html>
