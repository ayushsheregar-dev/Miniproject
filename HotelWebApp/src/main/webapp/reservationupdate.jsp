<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.ReservationDAO, com.model.Reservation, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Reservation</title>
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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 20px;
            font-size: 1.5rem;
            font-weight: bold;
        }
        
        .btn-update {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            border: none;
            padding: 10px 30px;
        }
        
        .form-label {
            font-weight: 600;
            color: #333;
        }
        
        .alert {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(5px);
            border-radius: 15px;
        }
    </style>
    <script>
        function validateForm() {
            var name = document.forms["updateForm"]["customerName"].value;
            var room = document.forms["updateForm"]["roomNumber"].value;
            var checkIn = document.forms["updateForm"]["checkIn"].value;
            var checkOut = document.forms["updateForm"]["checkOut"].value;
            var amount = document.forms["updateForm"]["totalAmount"].value;
            
            if(name == "" || room == "") {
                alert("Customer name and room number are required");
                return false;
            }
            if(checkIn >= checkOut) {
                alert("Check-out date must be after check-in date");
                return false;
            }
            if(amount <= 0) {
                alert("Total amount must be positive");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header text-center">
                        ✏️ Update Reservation
                    </div>
                    <div class="card-body p-4">
                        <% 
                            String idParam = request.getParameter("id");
                            Reservation reservation = null;
                            if(idParam != null && !idParam.isEmpty()) {
                                ReservationDAO dao = new ReservationDAO();
                                List<Reservation> reservations = dao.getAllReservations();
                                for(Reservation r : reservations) {
                                    if(r.getReservationID() == Integer.parseInt(idParam)) {
                                        reservation = r;
                                        break;
                                    }
                                }
                            }
                        %>
                        
                        <% if(request.getParameter("error") != null) { %>
                            <div class="alert alert-danger"><%= request.getParameter("error") %></div>
                        <% } %>
                        
                        <% if(reservation == null) { %>
                            <form action="reservationupdate.jsp" method="get">
                                <div class="mb-3">
                                    <label class="form-label">Enter Reservation ID to Update</label>
                                    <input type="number" name="id" class="form-control" required placeholder="e.g., 1, 2, 3">
                                </div>
                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">🔍 Load Reservation</button>
                                    <a href="index.jsp" class="btn btn-secondary">↩️ Back to Menu</a>
                                </div>
                            </form>
                        <% } else { %>
                            <form name="updateForm" action="UpdateReservationServlet" method="post" onsubmit="return validateForm()">
                                <input type="hidden" name="reservationID" value="<%= reservation.getReservationID() %>">
                                
                                <div class="mb-3">
                                    <label class="form-label">Reservation ID</label>
                                    <input type="text" class="form-control" value="<%= reservation.getReservationID() %>" disabled>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Customer Name *</label>
                                    <input type="text" name="customerName" class="form-control" value="<%= reservation.getCustomerName() %>" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Room Number *</label>
                                    <input type="text" name="roomNumber" class="form-control" value="<%= reservation.getRoomNumber() %>" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Check-in Date *</label>
                                    <input type="date" name="checkIn" class="form-control" value="<%= reservation.getCheckIn() %>" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Check-out Date *</label>
                                    <input type="date" name="checkOut" class="form-control" value="<%= reservation.getCheckOut() %>" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Total Amount ($) *</label>
                                    <input type="number" name="totalAmount" step="0.01" class="form-control" value="<%= reservation.getTotalAmount() %>" required>
                                </div>
                                
                                <div class="d-grid gap-2 d-md-flex justify-content-md-center">
                                    <button type="submit" class="btn btn-warning btn-update">💾 Update Reservation</button>
                                    <a href="reservationupdate.jsp" class="btn btn-secondary">🔄 New Search</a>
                                    <a href="index.jsp" class="btn btn-secondary">↩️ Back</a>
                                </div>
                            </form>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>