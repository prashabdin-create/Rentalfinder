<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>Login Page For Employee</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
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
  <div class="login-box">
    <h2>Login Page</h2>

    <% if ("1".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger">Invalid username or password!</div>
    <% } else if ("2".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger">Something went wrong. Please try again.</div>
    <% } %>

    <form action="Login1" method="post">
      <div class="mb-4">
        <label for="username" class="form-label">User Name</label>
        <input type="text" class="form-control" id="name" name="name" placeholder="Name" required>
      </div>

      <div class="mb-4">
        <label for="password" class="form-label">Password</label>
        <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
      </div>

      <div class="mb-3 form-check">
        <input type="checkbox" class="form-check-input" id="terms" required>
        <label class="form-check-label" for="terms">
          I agree to the <a href="#">terms & conditions</a>
        </label>
      </div>

      <button type="submit" class="btn btn-primary w-100">Log In</button>
    </form>
  </div>
</body>
</html>