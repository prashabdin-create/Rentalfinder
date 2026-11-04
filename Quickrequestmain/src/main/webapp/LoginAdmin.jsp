
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-card {
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            width: 350px;
        }
        .login-card h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 10px;
        }
        body {
      background-image: url("images/screenn.png");
      background-position: center;
      background-size: cover;
      height: 100vh;
      margin: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      backdrop-filter: blur(3px);
      padding: 10px;
    }
    .login-box {
      background-color: rgba(255, 255, 255, 0.9);
      padding: 30px;
      border-radius: 15px;
      width: 100%;
      max-width: 400px;
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    }
    .login-box h2 {
      text-align: center;
      margin-bottom: 20px;
      font-weight: bold;
    }
    @media (max-width: 576px) {
      body { padding: 20px; background-position: top; }
      .login-box { padding: 20px; }
      .login-box h2 { font-size: 1.5rem; }
      .form-label { font-size: 0.9rem; }
      .btn { font-size: 0.95rem; padding: 10px; }
    }
    @media (max-width: 768px) {
      .login-box { max-width: 90%; }
    }
    </style>
</head>
<body>

<div class="login-card">
    <h2>Admin Login</h2>
    
    <% if(request.getParameter("error") != null) { %>
        <div class="error-message">Invalid Name or Password!</div>
    <% } %>

    <form action="LoginAdmin" method="post">
        <div class="mb-3">
            <label for="name" class="form-label">Name</label>
            <input type="text" class="form-control" id="name" name="name" placeholder="Enter admin name" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" class="form-control" id="password" name="password" placeholder="Enter password" required>
        </div>
        <button type="submit" class="btn btn-primary w-100">Login</button>
    </form>
</div>

</body>
</html>
