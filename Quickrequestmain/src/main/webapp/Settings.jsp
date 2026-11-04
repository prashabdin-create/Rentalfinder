<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta charset="UTF-8">
  <title>Admin Settings - QuickRequest</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  
  <!-- Font Awesome Icons -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

  <style>
    body {
      background-color: #f8f9fa;
    }

    #logo {
      border-radius: 50%;
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

    .nav-underline.active,
    .nav-underline:hover {
      color: #007bff;
    }

    .settings-card {
      transition: all 0.3s ease-in-out;
      cursor: pointer;
      min-height: 230px;
      border: none;
      border-radius: 16px;
      box-shadow: 0 0.5rem 1.5rem rgba(0, 0, 0, 0.08);
    }

    .settings-card:hover {
      transform: translateY(-6px);
      box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.12);
    }

    .card-icon {
      font-size: 2.5rem;
      color: #007bff;
    }

    .card-title {
      font-size: 1.2rem;
      font-weight: 600;
    }

    h3.section-heading {
      font-weight: 700;
      margin-top: 40px;
      color: #333;
    }

    a.card-link {
      text-decoration: none;
      color: inherit;
    }

    @media (max-width: 576px) {
      .card-icon {
        font-size: 2rem;
      }
    }
  </style>
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
          <li class="nav-item"><a class="nav-link nav-underline" href="mainadmin.jsp">Home</a></li>
<a class="nav-link" href="ViewRequestAdmin">View Requests</a>
          <li class="nav-item"><a class="nav-link nav-underline active" href="Settings.html">Settings</a></li>
          <li class="nav-item"><a class="btn btn-primary rounded-pill px-4 fw-semibold" href="logout">Log Out</a></li>
        </ul>
      </div>
    </div>
  </nav>
  <!-- Page Heading -->
  <div class="container">
    <h3 class="text-center section-heading">ADMIN SETTINGS</h3>

    <!-- Settings Cards -->
    <div class="row justify-content-center g-4 mt-4">
      
      <!-- Admin Profile Settings -->
      <div class="col-lg-4 col-md-6 col-sm-10">
        <a href="Settings1.jsp" class="card-link">
          <div class="card settings-card p-4 text-center">
            <div class="card-body">
              <div class="card-icon mb-3"><i class="fas fa-user-cog"></i></div>
              <h5 class="card-title">Admin Profile Settings</h5>
              <p class="text-muted">Update your name, email, or password.</p>
            </div>
          </div>
        </a>
      </div>

      <!-- Manage Employees -->
      <div class="col-lg-4 col-md-6 col-sm-10">
        <a href="Settings2.jsp" class="card-link">
          <div class="card settings-card p-4 text-center">
            <div class="card-body">
              <div class="card-icon mb-3"><i class="fas fa-users"></i></div>
              <h5 class="card-title">Manage Employees</h5>
              <p class="text-muted">Add or remove employees from the system.</p>
            </div>
          </div>
        </a>
      </div>

      <!-- Manage Request Types -->
      <div class="col-lg-4 col-md-6 col-sm-10">
        <a href="Settings3.jsp" class="card-link">
          <div class="card settings-card p-4 text-center">
            <div class="card-body">
              <div class="card-icon mb-3"><i class="fas fa-tasks"></i></div>
              <h5 class="card-title">Manage Request Types</h5>
              <p class="text-muted">Add or edit available request categories.</p>
            </div>
          </div>
        </a>
      </div>

    </div>
  </div>

  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>