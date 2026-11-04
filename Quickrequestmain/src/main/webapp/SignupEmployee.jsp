
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>Employee Sign Up</title>
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
      padding: 20px;
    }

    .login-box {
      background-color: rgba(255, 255, 255, 0.9);
      padding: 30px;
      height: 800px;
      border-radius: 15px;
      width: 500px;
      max-width: 100%;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }

    .login-box h2 {
      margin-bottom: 25px;
      font-weight: bold;
      text-align: center;
    }

    .btn-primary {
      width: 100%;
    }

    .form-text {
      text-align: center;
    }

    @media (max-width: 576px) {
      .login-box {
        padding: 20px;
        width: 100%;
      }

      body {
        padding: 10px;
      }
    }
  </style>
</head>
<body>

  <div class="login-box">
    <h2>Employee Sign Up</h2>
    
    <form onsubmit="return validation()" action="Signup" method="post">
      <div class="mb-4">
        <label for="name" class="form-label">Full Name</label>
        <input type="text" class="form-control" id="name" name="name" placeholder="Enter employee name" required>
      </div>

      <div class="mb-4">
        <label for="email" class="form-label">Email address</label>
        <input type="email" class="form-control" id="email" name="email" placeholder="you@example.com" required>
      </div>

      <div class="mb-4">
        <label for="phone" class="form-label">Phone Number</label>
        <input type="tel" class="form-control" id="phone" name="phone" placeholder="xxxxxxxxxx" required>
      </div>

      <div class="mb-4">
        <label for="dept" class="form-label">Department name</label>
        <input type="text" class="form-control" id="dept" name="dept" placeholder="Enter Department" required>
      </div>

      <div class="mb-4">
        <label for="password" class="form-label">Password</label>
        <input type="password" class="form-control" id="password" name="password" placeholder="Enter Employee password" required>
      </div>

      <div class="mb-5">
        <label for="cpassword" class="form-label">Confirm Password</label>
        <input type="password" class="form-control" id="cpassword" name="cpassword" placeholder="Confirm your password" required>
      </div>

      <div class="mb-3 form-check">
        <input type="checkbox" class="form-check-input" id="terms" name="terms" required>
        <label class="form-check-label" for="terms">
          I agree to the <a href="#">terms & conditions</a>
        </label>
      </div>

      <button type="submit" class="btn btn-primary">Create Account</button>

      <div class="text-center mt-3">
        Already registered? <a href="LoginEmployee.jsp">Login here</a>
      </div>
    </form>

    <script>
      function validation() {
        var name = document.getElementById("name").value;
        var email = document.getElementById("email").value;
        var password = document.getElementById("password").value;
        var cpass = document.getElementById("cpassword").value;
        var dpt = document.getElementById("dept").value;

        if (name === "" || email === "" || password === "" || cpass === "" || dpt === "") {
          alert("All fields are required");
          return false;
        }

        if (password !== cpass) {
          alert("Mismatched password");
          return false;
        }

        return true;
      }
    </script>
  </div>

</body>
</html>