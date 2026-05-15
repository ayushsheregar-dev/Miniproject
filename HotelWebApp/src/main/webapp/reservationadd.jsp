<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.ReservationDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Reservation</title>
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
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
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
        
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 10px 30px;
            font-size: 1.1rem;
        }
        
        .form-label {
            font-weight: 600;
            color: #333;
        }
        
        .auto-id-box {
            background: linear-gradient(135deg, #667eea20 0%, #764ba220 100%);
            border: 2px dashed #667eea;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            margin-bottom: 20px;
        }
        
        .auto-id-label {
            font-size: 0.9rem;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 2px;
        }
        
        .auto-id-value {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
            font-family: monospace;
        }
        
        .info-text {
            font-size: 0.85rem;
            color: #28a745;
            margin-top: 5px;
        }
    </style>
    <script>
        function validateForm() {
            var name = document.forms["reservationForm"]["customerName"].value;
            var room = document.forms["reservationForm"]["roomNumber"].value;
            var checkIn = document.forms["reservationForm"]["checkIn"].value;
            var checkOut = document.forms["reservationForm"]["checkOut"].value;
            var amount = document.forms["reservationForm"]["totalAmount"].value;
            
            if(name == "" || name.trim() == "") {
                alert("Customer name is required");
                return false;
            }
            if(room == "" || room.trim() == "") {
                alert("Room number is required");
                return false;
            }
            if(checkIn == "") {
                alert("Please select check-in date");
                return false;
            }
            if(checkOut == "") {
                alert("Please select check-out date");
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
        
        // Set minimum date to today
        window.onload = function() {
            var today = new Date().toISOString().split('T')[0];
            document.getElementById("checkIn").min = today;
            document.getElementById("checkOut").min = today;
        }
        
        function updateCheckOutMin() {
            var checkIn = document.getElementById("checkIn").value;
            document.getElementById("checkOut").min = checkIn;
        }
        
        // Calculate total amount automatically based on nights
        function calculateAmount() {
            var checkIn = document.getElementById("checkIn").value;
            var checkOut = document.getElementById("checkOut").value;
            var roomRate = {
                '101': 150, '102': 150, '103': 180, '104': 180, '105': 200, '106': 200,
                '201': 250, '202': 250, '203': 280, '204': 280, '205': 300, '206': 300,
                '301': 350, '302': 350, '303': 400, '304': 400, '305': 450, '306': 450
            };
            
            if(checkIn && checkOut) {
                var start = new Date(checkIn);
                var end = new Date(checkOut);
                var nights = (end - start) / (1000 * 60 * 60 * 24);
                
                if(nights > 0) {
                    var room = document.getElementById("roomNumber").value;
                    var rate = roomRate[room] || 200; // Default rate $200
                    var total = nights * rate;
                    document.getElementById("totalAmount").value = total.toFixed(2);
                    document.getElementById("nightsInfo").innerHTML = "<small class='text-success'>💰 " + nights + " night(s) × $" + rate + " = $" + total.toFixed(2) + "</small>";
                }
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header text-center">
                        🏨 Add New Reservation
                    </div>
                    <div class="card-body p-4">
                        <% if(request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <%= request.getAttribute("error") %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>
                        
                        <!-- Auto-increment Display Box -->
                        <div class="auto-id-box">
                            <div class="auto-id-label">🔢 Reservation ID (Auto-Generated)</div>
                            <div class="auto-id-value">
                                <% 
                                    ReservationDAO dao = new ReservationDAO();
                                    int nextId = dao.getAllReservations().size() + 1;
                                %>
                                #<%= nextId %>
                            </div>
                            <div class="info-text">
                                <i class="bi bi-info-circle"></i> ID will be automatically assigned by the system
                            </div>
                        </div>
                        
                        <form name="reservationForm" action="AddReservationServlet" method="post" onsubmit="return validateForm()">
                            <div class="mb-3">
                                <label class="form-label">👤 Customer Name *</label>
                                <input type="text" name="customerName" class="form-control" placeholder="Enter customer full name" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">🚪 Room Number *</label>
                                <select name="roomNumber" id="roomNumber" class="form-control" required onchange="calculateAmount()">
                                    <option value="">Select Room Number</option>
                                    <option value="101">101 - Standard Room (₹150/night)</option>
                                    <option value="102">102 - Standard Room (₹150/night)</option>
                                    <option value="103">103 - Deluxe Room (₹180/night)</option>
                                    <option value="104">104 - Deluxe Room (₹180/night)</option>
                                    <option value="105">105 - Superior Room (₹200/night)</option>
                                    <option value="106">106 - Superior Room (₹200/night)</option>
                                    <option value="201">201 - Premium Room (₹250/night)</option>
                                    <option value="202">202 - Premium Room (₹250/night)</option>
                                    <option value="203">203 - Executive Room (₹280/night)</option>
                                    <option value="204">204 - Executive Room (₹280/night)</option>
                                    <option value="205">205 - Suite Room (₹300/night)</option>
                                    <option value="206">206 - Suite Room (₹300/night)</option>
                                    <option value="301">301 - Presidential Suite (₹350/night)</option>
                                    <option value="302">302 - Presidential Suite (₹350/night)</option>
                                    <option value="303">303 - Royal Suite (₹400/night)</option>
                                    <option value="304">304 - Royal Suite (₹400/night)</option>
                                    <option value="305">305 - Luxury Suite (₹450/night)</option>
                                    <option value="306">306 - Luxury Suite (₹450/night)</option>
                                </select>
                                <small class="text-muted">Select available room</small>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">📅 Check-in Date *</label>
                                <input type="date" id="checkIn" name="checkIn" class="form-control" required onchange="calculateAmount()">
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">📅 Check-out Date *</label>
                                <input type="date" id="checkOut" name="checkOut" class="form-control" required onchange="calculateAmount()">
                                <div id="nightsInfo" class="info-text"></div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">💰 Total Amount ($) *</label>
                                <input type="number" id="totalAmount" name="totalAmount" step="0.01" class="form-control" placeholder="0.00" required readonly style="background-color: #f0f0f0;">
                                <small class="text-muted">Amount calculated automatically based on room rate and nights</small>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-center">
                                <button type="submit" class="btn btn-primary btn-submit">➕ Add Reservation</button>
                                <a href="index.jsp" class="btn btn-secondary">↩️ Back to Menu</a>
                            </div>
                        </form>
                        
                        <hr>
                        <div class="text-center text-muted">
                            <small>✅ Reservation ID is auto-incremented automatically by the database</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>