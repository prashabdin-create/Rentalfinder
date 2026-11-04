<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Main Page</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
  <style>
    body, html {
      margin: 0;
      padding: 0;
      height: 100%;
      font-family: Arial, sans-serif;
    }

    .half-bg {
      position: absolute;
      top:0;
      width: 50%;
      height: 100%;
      background: rgb(178, 237, 237);
      border-top-right-radius: 550px;
      border-bottom-right-radius: 500px;
      text-align: center;
      padding-top: 250px;
    }

    .half-bg h3 {
      color: rgb(29, 104, 106);
      font-weight: bold;
    }

    .insta, .face, .twe {
      border-radius: 50%;
    }

    .navbar-brand h3 {
      font-weight: bolder;
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

    .profile-card {
      border: 1px solid #e0e0e0;
      border-radius: 10px;
      padding: 15px;
      background: #fff;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      max-width: 140px;
    }

    .user-image {
      border-radius: 50%;
      border: 2px solid #101217;
      transition: transform 0.3s ease;
    }

    .user-image:hover {
      transform: scale(1.1);
    }

    .imgg {
      position: absolute;
      right: 0;
      top: 300px;
      width: 45%;
      max-width: 600px;
    }

    .imgg img {
      width: 100%;
    }

    @media (max-width: 992px) {
      .half-bg {
        width: 100%;
        height: auto;
        position: relative;
        border-radius: 0;
      }

      .imgg {
        position: relative;
        width: 90%;
        margin: 20px auto;
        top: 500px;
        right: 0;
      }

      .imgg img {
        width: 100%;
        height: auto;
      }

      .navbar-brand h3 {
        font-size: 1.3rem;
      }

      .profile-card {
        margin-top: 15px;
      }
    }

    @media (max-width: 576px) {
      .half-bg h3 {
        font-size: 1.2rem;
        margin-top: 300px;
      }

      .half-bg p {
        font-size: 0.9rem;
      }

      .btn {
        width: 100%;
      }

      .profile-card {
        max-width: 100%;
        text-align: center;
      }

      .navbar-nav {
        gap: 0.5rem;
      }

      .insta, .face, .twe {
        width: 40px;
        height: 40px;
      }
    }
  </style>
</head>
<body>

<%
    HttpSession sessionUser = request.getSession(false);
    String name = (sessionUser != null && sessionUser.getAttribute("name") != null)
                    ? (String) sessionUser.getAttribute("name") : "Guest";
    String department = (sessionUser != null && sessionUser.getAttribute("dept") != null)
                    ? (String) sessionUser.getAttribute("dept") : "N/A";
    String phone = (sessionUser != null && sessionUser.getAttribute("phone") != null)
                    ? (String) sessionUser.getAttribute("phone") : "N/A";
    String email = (sessionUser != null && sessionUser.getAttribute("email") != null)
                    ? (String) sessionUser.getAttribute("email") : "N/A";
%>

  <!-- Left section with welcome -->
  <div class="half-bg">
    <h3>👋 Welcome, <%= name %>!</h3><br>
    <p>
      Glad to have you on QuickRequest.<br>
      Here you can create new requests, view their<br>
      status, and stay updated with company news.<br>
      Our website is more than just a digital presence — it's<br>
      a gateway to ideas, solutions, and meaningful connections.
    </p>
    <br>
    <a href="SubmitRequest.jsp">
      <button class="btn btn-dark" >Create Request</button>
    </a>
    <br><br>
    <p>
      <img src="images/insta1.png" width="50px" height="50px" class="insta">&nbsp;&nbsp;
      <img src="images/facebook.jpg" width="55px" height="50px" class="face">&nbsp;&nbsp;
      <img src="images/twe3.jpg" width="55px" height="50px" class="twe">
    </p>
  </div>

  <!-- Navbar -->
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
            <a class="nav-link nav-underline active" href="Main.jsp">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link nav-underline" href="Editprofile.jsp">Edit Profile</a>
          </li>
          <li class="nav-item">
<a class="nav-link nav-underline" href="ViewRequest">View Requests</a>
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

  <!-- Profile card (top right) -->
  <a href="Editprofile.jsp">
    <div class="container mt-4">
      <div class="row justify-content-end">
        <div class="col-auto">
          <div class="profile-card text-center">
            <img src="images/user1.jpg" height="60" width="60" alt="User" class="user-image">
            <div class="profile-name"><%= name %></div>
          </div>
        </div>
      </div>
    </div>
  </a>

  <!-- Right-side illustration -->
  <div class="imgg">
    <img src="images/img6.png" alt="Illustration">
  </div>

</body>
</html>