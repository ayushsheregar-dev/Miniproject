<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.model.Reservation" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Reservations</title>
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
            margin-top: 30px;
            margin-bottom: 50px;
        }
        
        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(5px);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 20px;
            font-size: 1.5rem;
            font-weight: bold;
        }
        
        .table {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 10px;
            overflow: hidden;
        }
        
        .btn-edit {
            margin-right: 5px;
        }
        
        .btn-delete {
            margin-right: 5px;
        }
        
        .alert {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(5px);
            border-radius: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="card-header text-center">
                📋 All Reservations
            </div>
            <div class="card-body">
                <% if(request.getParameter("message") != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <%= request.getParameter("message") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                <% if(request.getParameter("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <%= request.getParameter("error") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                
                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Customer Name</th>
                                <th>Room Number</th>
                                <th>Check-in Date</th>
                                <th>Check-out Date</th>
                                <th>Total Amount</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
                                if(reservations != null && !reservations.isEmpty()) {
                                    for(Reservation r : reservations) {
                            %>
                                <tr>
                                    <td><strong>#<%= r.getReservationID() %></strong></td>
                                    <td><%= r.getCustomerName() %></td>
                                    <td><span class="badge bg-primary">Room <%= r.getRoomNumber() %></span></td>
                                    <td><%= r.getCheckIn() %></td>
                                    <td><%= r.getCheckOut() %></td>
                                    <td class="text-success fw-bold">$<%= String.format("%.2f", r.getTotalAmount()) %></td>
                                    <td>
                                        <a href="reservationupdate.jsp?id=<%= r.getReservationID() %>" class="btn btn-sm btn-warning btn-edit">✏️ Edit</a>
                                        <a href="DeleteReservationServlet?id=<%= r.getReservationID() %>" class="btn btn-sm btn-danger btn-delete" onclick="return confirm('Are you sure you want to delete this reservation?')">🗑️ Cancel</a>
                                    </td>
                                </tr>
                            <%
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="7" class="text-center text-muted">
                                        <br>📭 No reservations found<br><br>
                                        <a href="reservationadd.jsp" class="btn btn-primary btn-sm">➕ Add New Reservation</a>
                                        <br><br>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <div class="text-center mt-3">
                    <a href="index.jsp" class="btn btn-primary">🏠 Back to Menu</a>
                    <button onclick="window.print()" class="btn btn-secondary">🖨️ Print</button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>