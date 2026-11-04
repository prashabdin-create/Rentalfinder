<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Settings</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
    }
  </style>
</head>
<body class="bg-light">

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
          <li class="nav-item"><a class="nav-link nav-underline" href="Mainadmin.jsp">Home</a></li>
<a class="nav-link" href="ViewRequestAdmin">View Requests</a>
          <li class="nav-item"><a class="nav-link nav-underline active" href="Settings.jsp">Settings</a></li>
          <li class="nav-item"><a class="btn btn-primary rounded-pill px-4 fw-semibold" href="logout">Log Out</a></li>
        </ul>
      </div>
    </div>
  </nav>
<div class="container py-5">
    <h2 class="text-center mb-4">⚙️ Admin Settings</h2>

    <!-- Show messages -->
    <%
        String msg = (String) request.getAttribute("message");
        if (msg != null) {
    %>
        <div class="alert alert-info text-center"><%= msg %></div>
    <% } %>

    <div class="row g-4">
        <!-- Add Admin -->
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header bg-success text-white">➕ Add Admin</div>
                <div class="card-body">
                    <form action="AdminServlet" method="post">
                        <input type="hidden" name="action" value="add">
                        <input type="text" name="name" class="form-control mb-3" placeholder="Enter name" required>
                        <input type="password" name="password" class="form-control mb-3" placeholder="Enter password" required>
                        <button type="submit" class="btn btn-success w-100">Add</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Delete Admin -->
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header bg-danger text-white">🗑️ Delete Admin</div>
                <div class="card-body">
                    <form action="AdminServlet" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="text" name="name" class="form-control mb-3" placeholder="Enter name" required>
                        <button type="submit" class="btn btn-danger w-100">Delete</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Update Password -->
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">🔑 Update Password</div>
                <div class="card-body">
                    <form action="AdminServlet" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="text" name="name" class="form-control mb-3" placeholder="Enter name" required>
                        <input type="password" name="oldPassword" class="form-control mb-3" placeholder="Old password" required>
                        <input type="password" name="newPassword" class="form-control mb-3" placeholder="New password" required>
                        <button type="submit" class="btn btn-primary w-100">Update</button>
                    </form>
                </div>
            </div>
        </div>
        <!-- Total Admins -->
<div class="text-center mt-4">
    <%
        List<String[]> admins = (List<String[]>) request.getAttribute("admins");
        int totalAdmins = (admins != null) ? admins.size() : 0;
    %>
    <h5>Total Admins: <span class="badge bg-info text-dark"><%= totalAdmins %></span></h5>
</div>
    </div>

    <hr class="my-5">

    
</div>

</body>
</html>
