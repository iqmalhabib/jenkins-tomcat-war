<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Spring Boot WAR Demo</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f0f4f8;
        }
        .box {
            background: white;
            padding: 40px 60px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            text-align: center;
        }
        h1 {
            color: #2d6a4f;
            font-size: 2rem;
        }
        p {
            color: #555;
            font-size: 1rem;
        }
    </style>
</head>
<body>
    <div class="box">
        <h1>${message}</h1>
        <p>Deployed successfully as a WAR on Apache Tomcat 🎉 - test using jenkins berjaya 2</p>
    </div>
</body>
</html>
