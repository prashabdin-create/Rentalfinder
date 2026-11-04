<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Manage Request Types</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  
 
  
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

  <style>
    body { background-color: #f8f9fa; }
    .card-header { font-weight: 500; background-color: #e9ecef; }
    .table td, .table th { vertical-align: middle; }
    .nav-underline { position: relative; display: inline-block; color: #333; text-decoration: none; padding-bottom: 4px; }
    .nav-underline::after { content: ""; position: absolute; width: 0; height: 2px; left: 0; bottom: 0; background-color: #007bff; transition: width 0.3s ease; }
    .nav-underline:hover::after, .nav-underline.active::after { width: 100%; }
    .nav-underline.active, .nav-underline:hover { color: #007bff; }
    
    
    
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
<body>
  <!-- NAVBAR -->
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
    <div class="mb-4 text-center">
      <h2 class="fw-bold">Manage Request Types</h2>
      <p class="text-muted">Add, update, or remove request types used in the system</p>
    </div>

    <!-- Add Request Type -->
    <div class="card shadow-sm mb-4">
      <div class="card-header">Add New Request Type</div>
      <div class="card-body">
        <form action="Settings3" method="post">
          <input type="hidden" name="action" value="add">
          <div class="row g-2">
            <div class="col-md-9">
              <input type="text" name="requestTypeName" class="form-control" placeholder="e.g. Hardware Request" required>
            </div>
            <div class="col-md-3">
              <button type="submit" class="btn btn-success w-100">
                <i class="bi bi-plus-circle me-1"></i> Add Request Type
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>

    <!-- Existing Request Types -->
    <div class="card shadow-sm">
      <div class="card-header">Existing Request Types</div>
      <div class="card-body p-0">
        <table class="table table-bordered table-hover mb-0">
          <thead class="table-light text-center">
            <tr>
              <th style="width: 5%;">#</th>
              <th>Request Type</th>
              <th style="width: 30%;">Actions</th>
            </tr>
          </thead>
          <tbody class="text-center">
            <%
              try {
                  Class.forName("com.mysql.cj.jdbc.Driver");
                  Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/signup", "root", "root");
                  Statement stmt = conn.createStatement();
                  ResultSet rs = stmt.executeQuery("SELECT * FROM request_types ORDER BY id ASC");
                  int count = 1;
                  while(rs.next()){
            %>
                  <tr>
                    <td><%= count++ %></td>
                    <td><%= rs.getString("name") %></td>
                    <td>
                      <div class="d-flex justify-content-center gap-2">
                        <!-- Edit -->
                        <form action="Settings3" method="post">
                          <input type="hidden" name="action" value="edit">
                          <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                          <input type="text" name="newName" placeholder="New Name" required>
                          <button type="submit" class="btn btn-warning btn-sm">
                            <i class="bi bi-pencil-square"></i> Edit
                          </button>
                        </form>
                        <!-- Delete -->
                        <form action="Settings3" method="post">
                          <input type="hidden" name="action" value="delete">
                          <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                          <button type="submit" class="btn btn-danger btn-sm">
                            <i class="bi bi-trash"></i> Delete
                          </button>
                        </form>
                      </div>
                    </td>
                  </tr>
            <%
                  }
                  rs.close();
                  stmt.close();
                  conn.close();
              } catch(Exception e){
                  e.printStackTrace();
              }
            %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</body>
</html>
