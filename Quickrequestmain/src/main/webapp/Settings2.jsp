<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>⚙️ Employee Settings</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #74ebd5, #9face6);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            margin-top: 60px;
            max-width: 1000px;
        }
        .card {
            border-radius: 20px;
            box-shadow: 0px 6px 20px rgba(0,0,0,0.15);
            background: #fff;
            padding: 25px;
        }
        h2 {
            font-weight: bold;
            margin-bottom: 25px;
            text-align: center;
            color: #007bff;
        }
        .form-label {
            font-weight: 500;
            color: #444;
        }
        .btn-custom {
            border-radius: 25px;
            padding: 8px 18px;
            transition: 0.3s;
        }
        .btn-custom:hover {
            transform: scale(1.05);
        }
        .table {
            border-radius: 12px;
            overflow: hidden;
        }
        .table th {
            background: #007bff;
            color: white;
            text-align: center;
        }
        .table td {
            text-align: center;
            vertical-align: middle;
        }
        .table-hover tbody tr:hover {
            background-color: #f1f7ff;
        }
        .error-msg {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            padding: 12px;
            border-radius: 12px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 500;
        }
        
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
<div class="container">
    <div class="card">
        <h2>⚙️ Employee Settings</h2>

        <!-- Error Message -->
        <%
           String errorMsg = (String) request.getAttribute("errorMsg");
           if (errorMsg != null) {
        %>
           <div class="error-msg"><%= errorMsg %></div>
        <% } %>

        <!-- Add Employee Form -->
        <form action="EmployeeServlet" method="post" class="mb-4">
            <input type="hidden" name="action" value="addEmployee">

            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">👤 Name</label>
                    <input type="text" name="name" class="form-control shadow-sm" placeholder="Enter full name" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">📧 Email</label>
                    <input type="email" name="email" class="form-control shadow-sm" placeholder="Enter email" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">🏢 Department</label>
                    <input type="text" name="dept" class="form-control shadow-sm" placeholder="Enter department" required>
                </div>
            </div>

            <div class="text-center mt-4">
                <button type="submit" class="btn btn-success btn-custom shadow">
                    <i class="bi bi-person-plus"></i> Add Employee
                </button>
            </div>
        </form>

        <!-- Employee Table -->
        <div class="table-responsive">
            <table class="table table-striped table-bordered table-hover align-middle shadow-sm">
                <thead>
                    <tr>
                        <th>#️⃣ ID</th>
                        <th>👤 Name</th>
                        <th>📧 Email</th>
                        <th>🏢 Department</th>
                        <th>⚡ Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/signup", "root", "root");
                        Statement st = conn.createStatement();
                        ResultSet rs = st.executeQuery("SELECT * FROM signuptb");

                        while (rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getInt("id") %></td>
                        <td><%= rs.getString("name") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td><%= rs.getString("dept") %></td>
                        <td>
                            <form action="EmployeeServlet" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="deleteEmployee">
                                <input type="hidden" name="idToDelete" value="<%= rs.getInt("id") %>">
                                <button type="submit" class="btn btn-danger btn-sm btn-custom shadow-sm"
                                        onclick="return confirm('❗ Are you sure you want to delete this employee?');">
                                    <i class="bi bi-trash"></i> Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                <%
                        }
                        rs.close();
                        st.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
