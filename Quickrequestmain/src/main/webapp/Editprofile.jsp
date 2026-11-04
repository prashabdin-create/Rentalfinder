<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("userId") == null) {
        response.sendRedirect("LoginEmployee.jsp");
        return;
    }

    Integer userId = (Integer) sessionUser.getAttribute("userId");
    String id = userId != null ? userId.toString() : "";
    String name = (String) sessionUser.getAttribute("name");
    String dept = (String) sessionUser.getAttribute("dept");
    String phone = (String) sessionUser.getAttribute("phone");
    String email = (String) sessionUser.getAttribute("email");

%>
<%
    

    if (userId != null) {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/signup", "root", "root");
            PreparedStatement pst = conn.prepareStatement("SELECT * FROM signuptb WHERE id=?");
            pst.setInt(1, userId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
                dept = rs.getString("dept");
                phone = rs.getString("phone");
                email = rs.getString("email");
            }
            rs.close();
            pst.close();
            conn.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <!-- Keep your original style here -->
    <!-- Paste your previous CSS code without change (omitted for brevity) -->
    
    
     <style>
     body {
      font-family: Arial, sans-serif;
      margin: 0;
      background-color: #f4f4f4;
      justify-content: center;
    }
    
     .container {
      width: 1000px;
      background-color: white;
      margin: 50px auto;
      border: 1px solid #ccc;
      border-radius: 5px;
    }
    .header {
      background-color: #3498db;
      color: white;
      padding: 15px;
      font-size: 18px;
      border-top-left-radius: 5px;
      border-top-right-radius: 5px;
    }
    .tabs {
      display: flex;
      border-bottom: 1px solid #ccc;
      justify-content: center;
    }
    .tabs div {
      padding: 10px 20px;
      cursor: pointer;
      justify-content: center;

    }
    .tabs .active {
      border-bottom: 2px solid #3498db;
      font-weight: bold;
      color: #3498db;
      justify-content: center;

    }

    .photo img{
            width: 100px;
            height:100px;
            border-radius: 30px;
            margin: 0 auto 10px;
            display: block;
        
    }

    .photo button
    {
        background-color: #3498db;
        color: white;
        border: none;
        padding: 8px 12px;
        border-radius: 5px;
        margin: 0 auto 10px;
        display: block;
        cursor: pointer;
    }
    .details
    {
        width:60%;
        padding-left: 20px;
        align-items: center;
    }

    .details label
    {
        display: block;
        margin:10px 0 5px;
    }

    .details input
    {
        width: 100%;
        padding: 8px;
        margin-bottom: 10px;
        border: 1px solid;
        border-radius: 3px;

    }

    .actions
    {
        text-align: right;
        padding: 15px 20px;
        border-top: 1px solid #ccc;
    }

    .actions button
    {
        padding:8px 15px;
        border: none;
        border-radius: 3px;
        margin-left: 10px;
        cursor: pointer;
    }

    .cancel-btn
    {
        background-color: #ccc;
        color: #000;
    }

    .save-btn
    {
        background-color: #3498db;
        color: white;
    }
    .form
    {
        text-align: center;
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

#logo
{
  border-radius: 100px;
}


@media (max-width: 991px) {
  .container {
    width: 90%;
    margin: 30px auto;
  }

  .details {
    width: 90%;
    padding: 0 15px;
    margin: auto;
  }

  .photo img {
    width: 80px;
    height: 80px;
  }

  .photo button {
    padding: 6px 10px;
    font-size: 14px;
  }

  .tabs {
    flex-direction: column;
    align-items: center;
  }

  .tabs div {
    width: 100%;
    text-align: center;
    border-bottom: 1px solid #eee;
  }

  .actions {
    text-align: center;
  }

  .actions button {
    width: 45%;
    margin-top: 10px;
  }

  .navbar-nav {
    gap: 1rem;
  }
}

@media (max-width: 576px) {
  .navbar-brand h3 {
    font-size: 18px;
  }

  .photo img {
    width: 60px;
    height: 60px;
    text-align: center;
  }

  .photo button {
  background-color: #007bff;
  color: white;
  border: none;
  padding: 10px 20px;
  font-size: 16px;
  cursor:pointer;



  }

  .details input {
    font-size: 14px;
    padding: 6px;
  }

  .header {
    font-size: 16px;
    padding: 10px;
  }

  .actions button {
    font-size: 14px;
    padding: 6px 10px;
  }

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

       </style>
</head>
<body>
    <!-- Your navbar here (as in your HTML, unchanged) -->
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
            <a class="nav-link nav-underline active" href="Editprofile.jsp">Edit Profile</a>
          </li>
          <li class="nav-item">
<a class="nav-link nav-underline" href="ViewRequest">View Requests</a>
          </li>
          <li class="nav-item">
            <a class="nav-link nav-underline" href="SubmitRequest.jsp">Submit New Requests</a>
          </li>
          <li class="nav-item">
            <a class="btn btn-primary rounded-pill px-4 fw-semibold" href="Logout.jsp">Log Out</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>

    <div class="container">
        <div class="header">Edit Profile</div>
        <br>

        <form method="post" action="EditProfile">
            <div class="photo text-center">
                <img id="profilePreview" src="images/user1.jpg" alt="Profile Photo">
                <br>
                <label for="photoInput" class="btn btn-primary">CHANGE PHOTO</label>
                <input type="file" id="photoInput" accept="image/*" style="display: none;" onchange="previewPhoto(event)">
            </div>

            <div class="details">
                <label>Id:</label>
                <input type="text" value="<%= id %>" name="id" readonly>

                <label>Name:</label>
                <input type="text" value="<%= name %>" name="name" required>

                <label>Department:</label>
                <input type="text" value="<%= dept %>" name="dept" required>

                <label>Phone:</label>
                <input type="text" value="<%= phone %>" name="phone" required>

                <label>Email:</label>
                <input type="email" value="<%= email %>" name="email" required>
            </div>

            <div class="actions">
                <button type="reset" class="cancel-btn">Cancel</button>
                <button type="submit" class="save-btn">Save</button>
            </div>
        </form>
    </div>

    <!-- Success Modal -->
    <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content text-center">
          <div class="modal-header bg-success text-white">
            <h5 class="modal-title" id="successModalLabel">Profile Updated</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            Your profile has been successfully updated.
          </div>
          <div class="modal-footer">
            <a href="Main.jsp" class="btn btn-success">Go to Dashboard</a>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js"></script>




</body>
</html>








