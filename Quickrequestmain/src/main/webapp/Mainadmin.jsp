<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if session exists and admin is logged in
    if (session == null || session.getAttribute("adminName") == null) {
        response.sendRedirect("LoginAdmin.jsp");
        return; // stop executing page
    }
    String adminName = (String) session.getAttribute("adminName");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Admin Dashboard</title>
  
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body, html {
      margin: 0;
      height: 100%;
      overflow-x: hidden;
    }

    .user-image {
      border-radius: 50%;
      border: 2px solid #101217;
      transition: transform 0.3s ease;
    }

    .profile-card {
      border: 1px solid #e0e0e0;
      border-radius: 10px;
      padding: 15px;
      background: #fff;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      max-width: 140px;
    }

    .user-image:hover {
      transform: scale(1.1);
    }

    .half-bg {
      position: absolute;
      top: 0;
      width: 50%;
      height: 100%;
      background-color: rgb(128, 174, 195);
      border-top-right-radius: 550px;
      border-bottom-right-radius: 500px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      text-align: center;
      padding: 20px;
    }

    #imgg {
      margin-left: 900px;
      width: 600px;
      margin-top: 50px;
    }

    #logo {
      border-radius: 100px;
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

  <div class="half-bg">
    <center>
      <h3 style="color:rgb(29, 104, 106);"><b>Welcome, <%= adminName %>!</b></h3>
      <p>Manage your system, employees,<br> and keep everything running smoothly.</p><br><br>
      <a href="ViewRequestAdmin" class="btn btn-dark">View Requests</a>
    </center>
  </div>

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
            <a class="nav-link nav-underline active" href="Mainadmin.jsp">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link nav-underline" href="ViewRequestAdmin">View Requests</a>
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
    <div class="row justify-content-end">
      <div class="col-auto">
        <div class="profile-card text-center">
          <img src="images/user1.jpg" height="60" width="60" alt="User" class="user-image">
          <div class="profile-name"><%= adminName %></div>
        </div>
      </div>
    </div>
  </div>

  <img src="images/admin.jpg" id="imgg" height="400px">
</body>
</html>
