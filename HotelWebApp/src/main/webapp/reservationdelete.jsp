<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.ReservationDAO, com.model.Reservation, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cancel Reservation</title>
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
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 20px;
            font-size: 1.5rem;
            font-weight: bold;
        }
        
        .btn-delete {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            border: none;
            padding: 10px 30px;
        }
        
        .alert {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(5px);
            border-radius: 15px;
        }
    </style>
    <script>
        function confirmDelete() {
            return confirm("⚠️ Are you sure you want to cancel this reservation?\n\nThis action cannot be undone!");
        }
        
        function validateId() {
            var id = document.getElementById("reservationId").value;
            if(id == "" || id <= 0) {
                alert("Please enter a valid Reservation ID");
                return false;
            }
            return confirmDelete();
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header text-center">
                        ❌ Cancel Reservation
                    </div>
                    <div class="card-body p-4">
                        <% if(request.getParameter("message") != null) { %>
                            <div class="alert alert-success"><%= request.getParameter("message") %></div>
                        <% } %>
                        <% if(request.getParameter("error") != null) { %>
                            <div class="alert alert-danger"><%= request.getParameter("error") %></div>
                        <% } %>
                        
                        <div class="alert alert-warning">
                            <strong>⚠️ Warning:</strong> This action will permanently delete the reservation from the database.
                        </div>
                        
                        <form action="DeleteReservationServlet" method="get" onsubmit="return validateId()">
                            <div class="mb-3">
                                <label class="form-label">Enter Reservation ID to Cancel</label>
                                <input type="number" id="reservationId" name="id" class="form-control form-control-lg" required placeholder="Reservation ID">
                                <small class="text-muted">You can find reservation ID in "View All Reservations"</small>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-center">
                                <button type="submit" class="btn btn-danger btn-delete">🗑️ Cancel Reservation</button>
                                <a href="index.jsp" class="btn btn-secondary">↩️ Back to Menu</a>
                            </div>
                        </form>
                        
                        <hr>
                        <div class="text-center">
                            <a href="DisplayReservationsServlet" class="btn btn-info btn-sm">📋 View All Reservations First</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>