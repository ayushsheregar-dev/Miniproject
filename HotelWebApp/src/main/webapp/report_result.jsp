<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.model.Reservation, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report Results</title>
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
        
        .report-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        
        .summary-card {
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .revenue-card {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
        }
        
        .count-card {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        
        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(5px);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            margin-bottom: 20px;
        }
        
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0;
        }
        
        .table {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 10px;
            overflow: hidden;
        }
        
        .table-dark {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="report-header">
            <h2 class="text-center">📊 Hotel Management Report</h2>
            <p class="text-center mb-0">Report Period: <%= request.getAttribute("startDate") %> to <%= request.getAttribute("endDate") %></p>
        </div>
        
        <!-- Summary Cards -->
        <div class="row">
            <div class="col-md-6">
                <div class="card summary-card count-card">
                    <div class="card-body text-center">
                        <h1><%= request.getAttribute("reservationCount") != null ? request.getAttribute("reservationCount") : "0" %></h1>
                        <p>Total Reservations</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card summary-card revenue-card">
                    <div class="card-body text-center">
                        <h1>$<%= String.format("%.2f", request.getAttribute("revenue") != null ? request.getAttribute("revenue") : 0.0) %></h1>
                        <p>Total Revenue Generated</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Most Booked Rooms -->
        <div class="card">
            <div class="card-header">
                <h4 class="mb-0">🏆 Most Booked Rooms (Top 5)</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <thead class="table-dark">
                            <tr>
                                <th>Rank</th>
                                <th>Room Number</th>
                                <th>Times Booked</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Object[]> mostBooked = (List<Object[]>) request.getAttribute("mostBooked");
                                if(mostBooked != null && !mostBooked.isEmpty()) {
                                    int rank = 1;
                                    for(Object[] room : mostBooked) {
                            %>
                                <tr>
                                    <td><strong>#<%= rank++ %></strong></td>
                                    <td><span class="badge bg-primary">Room <%= room[0] %></span></td>
                                    <td><strong><%= room[1] %></strong> bookings</td>
                                </tr>
                            <%
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="3" class="text-center text-muted">No booking data available</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <!-- Reservations List -->
        <div class="card">
            <div class="card-header">
                <h4 class="mb-0">📋 Reservations List</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Customer</th>
                                <th>Room</th>
                                <th>Check-in</th>
                                <th>Check-out</th>
                                <th>Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
                                if(reservations != null && !reservations.isEmpty()) {
                                    double grandTotal = 0;
                                    for(Reservation r : reservations) {
                                        grandTotal += r.getTotalAmount();
                            %>
                                <tr>
                                    <td><%= r.getReservationID() %></td>
                                    <td><%= r.getCustomerName() %></td>
                                    <td><%= r.getRoomNumber() %></td>
                                    <td><%= r.getCheckIn() %></td>
                                    <td><%= r.getCheckOut() %></td>
                                    <td class="text-success fw-bold">$<%= String.format("%.2f", r.getTotalAmount()) %></td>
                                </tr>
                            <%
                                    }
                            %>
                                <tr class="table-success fw-bold">
                                    <td colspan="5" class="text-end">Grand Total:</td>
                                    <td>$<%= String.format("%.2f", grandTotal) %></td>
                                </tr>
                            <%
                                } else {
                            %>
                                <tr>
                                    <td colspan="6" class="text-center text-muted">No reservations found in this date range</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <div class="text-center mt-4">
            <a href="report_form.jsp" class="btn btn-primary">🔄 New Report</a>
            <a href="index.jsp" class="btn btn-secondary">🏠 Back to Menu</a>
            <button onclick="window.print()" class="btn btn-info">🖨️ Print Report</button>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>