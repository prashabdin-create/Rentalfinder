<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.SignupServlet.Request, java.util.List" %>
<%
    if(session == null || session.getAttribute("adminName") == null){
        response.sendRedirect("LoginAdmin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Requests - Admin</title>
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

    
    @media screen and (max-width: 992px) {
      .half-bg {
        width: 100%;
        height: auto;
        border-radius: 0;
        padding: 40px 20px;
        position: relative;
      }

      #imgg {
        width: 90%;
        margin: 30px auto;
        display: block;
      }
    }

    @media screen and (max-width: 768px) {
      .navbar-brand h3 {
        font-size: 18px;
      }

      .profile-card {
        max-width: 100%;
        margin-top: 15px;
      }

      .user-image {
        height: 50px;
        width: 50px;
      }

      .half-bg h3 {
        font-size: 22px;
      }

      .half-bg p {
        font-size: 14px;
      }

      #imgg {
        width: 100%;
        margin: 20px 0;
      }
    }</style>
</head>
<body>
<nav class="navbar navbar-expand-lg bg-body-tertiary shadow-sm py-3">
    <div class="container-fluid">
      <a class="navbar-brand d-flex align-items-center gap-2" href="#">
        <img src="images/Lgo - Copy.png" alt="Logo" height="45" width="50" id="logo">
        <h3 style="color: black; font-weight: bolder;">QuickRequest</h3>
      </a>

      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMenu">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse justify-content-end" id="navbarMenu">
        <ul class="navbar-nav gap-4">
          <li class="nav-item">
            <a class="nav-link nav-underline " href="Mainadmin.jsp">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link nav-underline active" href="ViewRequestAdmin">View Requests</a>
          </li>
          <li class="nav-item">
            <a class="nav-link nav-underline" href="Settings.jsp">Settings</a>
          </li>
          <li class="nav-item">
            <a class="btn btn-primary rounded-pill px-4 fw-semibold" href="logout.jsp">Log Out</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
<div class="container mt-4">
    <h2 class="mb-3">All Employee Requests</h2>
    <%
        List<Request> requests = (List<Request>) request.getAttribute("requests");
        if (requests != null && !requests.isEmpty()) {
    %>
    <table class="table table-bordered text-center">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Employee</th>
            <th>Type</th>
            <th>Status</th>
            <th>Reason</th> <!-- New column -->
            <th>From</th>
            <th>To</th>
            <th>Total Days</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (Request r : requests) {
        %>
        <tr>
            <td><%= r.getId() %></td>
            <td><%= r.getName() %></td>
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
            <td>
                <% if(r.getStatus() == null || "Pending".equalsIgnoreCase(r.getStatus())) { %>
                    <form action="UpdateRequestStatus" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= r.getId() %>">
                        <input type="hidden" name="status" value="Accepted">
                        <button type="submit" class="btn btn-success btn-sm">Accept</button>
                    </form>
                    <form action="UpdateRequestStatus" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= r.getId() %>">
                        <input type="hidden" name="status" value="Rejected">
                        <button type="submit" class="btn btn-danger btn-sm">Reject</button>
                    </form>
                <% } else { %>
                    <em>No Action Available</em>
                <% } %>
            </td>
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
