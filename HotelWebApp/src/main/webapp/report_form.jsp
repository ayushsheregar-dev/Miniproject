<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Generate Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-image: url('images/hotel.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            background-repeat: no-repeat;
            min-height: 100vh;
        }
        
        body::before {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: -1;
        }
        
        .container {
            margin-top: 50px;
            margin-bottom: 50px;
        }
        
        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(5px);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            border: none;
        }
        
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 20px;
            font-size: 1.5rem;
            font-weight: bold;
        }
        
        .btn-generate {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
            font-size: 1.1rem;
        }
        
        .alert {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(5px);
            border-radius: 15px;
        }
        
        .form-label {
            font-weight: 600;
            color: #333;
        }
    </style>
    <script>
        function validateDates() {
            var startDate = document.getElementById("startDate").value;
            var endDate = document.getElementById("endDate").value;
            
            if(startDate === "" || endDate === "") {
                alert("Please select both start and end dates");
                return false;
            }
            
            if(new Date(startDate) > new Date(endDate)) {
                alert("End date must be after or equal to start date");
                return false;
            }
            
            return true;
        }
        
        window.onload = function() {
            var today = new Date();
            var thirtyDaysAgo = new Date();
            thirtyDaysAgo.setDate(today.getDate() - 30);
            
            document.getElementById("endDate").valueAsDate = today;
            document.getElementById("startDate").valueAsDate = thirtyDaysAgo;
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header text-center">
                        📊 Generate Reports
                    </div>
                    <div class="card-body p-4">
                        <% if(request.getParameter("error") != null) { %>
                            <div class="alert alert-danger"><%= request.getParameter("error") %></div>
                        <% } %>
                        
                        <form action="ReportServlet" method="post" onsubmit="return validateDates()">
                            <div class="mb-4">
                                <label class="form-label fw-bold">📅 Start Date</label>
                                <input type="date" id="startDate" name="startDate" class="form-control form-control-lg" required>
                                <small class="text-muted">Select the beginning of the reporting period</small>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label fw-bold">📅 End Date</label>
                                <input type="date" id="endDate" name="endDate" class="form-control form-control-lg" required>
                                <small class="text-muted">Select the end of the reporting period</small>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-generate">📈 Generate Report</button>
                                <a href="index.jsp" class="btn btn-secondary">↩️ Back to Menu</a>
                            </div>
                        </form>
                        
                        <hr>
                        <div class="text-center text-muted">
                            <small>Reports include: <br>
                            • Reservations in date range<br>
                            • Total revenue generated<br>
                            • Most frequently booked rooms</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>