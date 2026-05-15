<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hotel Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Background image styling */
        body {
            background-image: url('images/hotel.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            background-repeat: no-repeat;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            position: relative;
        }
        
        /* Dark overlay for better text readability */
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
        
        .navbar-brand {
            font-size: 1.8rem;
            font-weight: bold;
        }
        
        .card {
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            transition: transform 0.3s;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(5px);
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .btn-menu {
            width: 100%;
            margin: 10px 0;
            padding: 15px;
            font-size: 1.1rem;
            font-weight: bold;
            border-radius: 10px;
        }
        
        footer {
            background-color: rgba(0,0,0,0.8);
            color: white;
            padding: 15px;
            position: fixed;
            bottom: 0;
            width: 100%;
            text-align: center;
        }
        
        h1, p {
            color: white;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-dark bg-dark">
        <div class="container">
            <span class="navbar-brand">🏨 Hotel Management System</span>
            <span class="text-white">Admin Dashboard</span>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row">
            <div class="col-md-12 text-center mb-4">
                <h1>Welcome to Hotel Management</h1>
                <p>Manage reservations, rooms, and reports efficiently</p>
            </div>
        </div>

        <div class="row">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body text-center">
                        <h3>➕ Add Reservation</h3>
                        <p>Create new booking</p>
                        <a href="reservationadd.jsp" class="btn btn-primary btn-menu">Go</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body text-center">
                        <h3>✏️ Update Booking</h3>
                        <p>Modify existing reservation</p>
                        <a href="reservationupdate.jsp" class="btn btn-warning btn-menu">Go</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body text-center">
                        <h3>❌ Cancel Reservation</h3>
                        <p>Delete booking</p>
                        <a href="reservationdelete.jsp" class="btn btn-danger btn-menu">Go</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body text-center">
                        <h3>📋 View All Reservations</h3>
                        <p>Display all bookings</p>
                        <a href="DisplayReservationsServlet" class="btn btn-info btn-menu">Go</a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body text-center">
                        <h3>📊 Reports & Analytics</h3>
                        <p>Date range, revenue, most booked rooms</p>
                        <a href="report_form.jsp" class="btn btn-success btn-menu">Go</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 Hotel Management System | All rights reserved</p>
    </footer>
</body>
</html>