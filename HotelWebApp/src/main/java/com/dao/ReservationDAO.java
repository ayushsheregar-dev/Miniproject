package com.dao;

import com.model.Reservation;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

public class ReservationDAO {
    
    // Database connection parameters - UPDATE THESE WITH YOUR CREDENTIALS
    private String jdbcURL = "jdbc:mysql://localhost:3306/HotelDB?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private String jdbcUsername = "root";
    private String jdbcPassword = "root123";  // CHANGE THIS to your MySQL password
    
    // SQL Queries
    private static final String INSERT_RESERVATION = 
        "INSERT INTO Reservations (CustomerName, RoomNumber, CheckIn, CheckOut, TotalAmount) VALUES (?, ?, ?, ?, ?)";
    
    private static final String INSERT_RESERVATION_RETURN_ID = 
        "INSERT INTO Reservations (CustomerName, RoomNumber, CheckIn, CheckOut, TotalAmount) VALUES (?, ?, ?, ?, ?)";
    
    private static final String UPDATE_RESERVATION = 
        "UPDATE Reservations SET CustomerName=?, RoomNumber=?, CheckIn=?, CheckOut=?, TotalAmount=? WHERE ReservationID=?";
    
    private static final String DELETE_RESERVATION = 
        "DELETE FROM Reservations WHERE ReservationID=?";
    
    private static final String SELECT_ALL_RESERVATIONS = 
        "SELECT * FROM Reservations ORDER BY ReservationID DESC";
    
    private static final String SELECT_RESERVATION_BY_ID = 
        "SELECT * FROM Reservations WHERE ReservationID=?";
    
    private static final String SELECT_BY_DATE_RANGE = 
        "SELECT * FROM Reservations WHERE CheckIn >= ? AND CheckOut <= ? ORDER BY CheckIn";
    
    private static final String GET_REVENUE_BY_DATE_RANGE = 
        "SELECT COALESCE(SUM(TotalAmount), 0) as Revenue FROM Reservations WHERE CheckIn >= ? AND CheckOut <= ?";
    
    private static final String GET_MOST_BOOKED_ROOMS = 
        "SELECT RoomNumber, COUNT(*) as BookingCount FROM Reservations GROUP BY RoomNumber ORDER BY BookingCount DESC LIMIT 5";
    
    private static final String GET_TOTAL_RESERVATIONS = 
        "SELECT COUNT(*) as Total FROM Reservations";
    
    private static final String GET_TOTAL_REVENUE = 
        "SELECT COALESCE(SUM(TotalAmount), 0) as TotalRevenue FROM Reservations";
    
    private static final String CHECK_ROOM_AVAILABILITY = 
        "SELECT COUNT(*) FROM Reservations WHERE RoomNumber = ? AND ((CheckIn <= ? AND CheckOut >= ?) OR (CheckIn >= ? AND CheckIn < ?))";
    
    private static final String GET_RESERVATIONS_BY_CUSTOMER = 
        "SELECT * FROM Reservations WHERE CustomerName LIKE ? ORDER BY CheckIn DESC";
    
    private static final String GET_RESERVATIONS_BY_ROOM = 
        "SELECT * FROM Reservations WHERE RoomNumber = ? ORDER BY CheckIn DESC";
    
    private static final String DELETE_OLD_RESERVATIONS = 
        "DELETE FROM Reservations WHERE CheckOut < ?";
    
    // Database connection method
    protected Connection getConnection() {
        Connection connection = null;
        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Establish connection
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database connection failed!");
            e.printStackTrace();
        }
        return connection;
    }
    
    // ==================== CREATE (Add Reservation) ====================
    
    // Method 1: Add reservation without returning ID
    public boolean addReservation(Reservation reservation) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_RESERVATION)) {
            
            ps.setString(1, reservation.getCustomerName());
            ps.setString(2, reservation.getRoomNumber());
            ps.setDate(3, new java.sql.Date(reservation.getCheckIn().getTime()));
            ps.setDate(4, new java.sql.Date(reservation.getCheckOut().getTime()));
            ps.setDouble(5, reservation.getTotalAmount());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding reservation: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Method 2: Add reservation and return auto-generated ID (Recommended)
    public int addReservationAndGetId(Reservation reservation) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_RESERVATION_RETURN_ID, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, reservation.getCustomerName());
            ps.setString(2, reservation.getRoomNumber());
            ps.setDate(3, new java.sql.Date(reservation.getCheckIn().getTime()));
            ps.setDate(4, new java.sql.Date(reservation.getCheckOut().getTime()));
            ps.setDouble(5, reservation.getTotalAmount());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
            return 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding reservation with ID: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    
    // Method 3: Get last inserted ID (alternative method)
    public int getLastInsertedId() {
        String query = "SELECT LAST_INSERT_ID()";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // ==================== READ (Get Reservations) ====================
    
    // Get all reservations
    public List<Reservation> getAllReservations() {
        List<Reservation> reservations = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL_RESERVATIONS);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all reservations: " + e.getMessage());
            e.printStackTrace();
        }
        return reservations;
    }
    
    // Get reservation by ID
    public Reservation getReservationById(int reservationID) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_RESERVATION_BY_ID)) {
            
            ps.setInt(1, reservationID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToReservation(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting reservation by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    // Get reservations by date range
    public List<Reservation> getReservationsByDateRange(Date startDate, Date endDate) {
        List<Reservation> reservations = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_DATE_RANGE)) {
            
            ps.setDate(1, new java.sql.Date(startDate.getTime()));
            ps.setDate(2, new java.sql.Date(endDate.getTime()));
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting reservations by date range: " + e.getMessage());
            e.printStackTrace();
        }
        return reservations;
    }
    
    // Get reservations by customer name (search)
    public List<Reservation> getReservationsByCustomer(String customerName) {
        List<Reservation> reservations = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_RESERVATIONS_BY_CUSTOMER)) {
            
            ps.setString(1, "%" + customerName + "%");
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting reservations by customer: " + e.getMessage());
            e.printStackTrace();
        }
        return reservations;
    }
    
    // Get reservations by room number
    public List<Reservation> getReservationsByRoom(String roomNumber) {
        List<Reservation> reservations = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_RESERVATIONS_BY_ROOM)) {
            
            ps.setString(1, roomNumber);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting reservations by room: " + e.getMessage());
            e.printStackTrace();
        }
        return reservations;
    }
    
    // ==================== UPDATE (Modify Reservation) ====================
    
    // Update existing reservation
    public boolean updateReservation(Reservation reservation) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_RESERVATION)) {
            
            ps.setString(1, reservation.getCustomerName());
            ps.setString(2, reservation.getRoomNumber());
            ps.setDate(3, new java.sql.Date(reservation.getCheckIn().getTime()));
            ps.setDate(4, new java.sql.Date(reservation.getCheckOut().getTime()));
            ps.setDouble(5, reservation.getTotalAmount());
            ps.setInt(6, reservation.getReservationID());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating reservation: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // ==================== DELETE (Cancel Reservation) ====================
    
    // Delete reservation by ID
    public boolean deleteReservation(int reservationID) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_RESERVATION)) {
            
            ps.setInt(1, reservationID);
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting reservation: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete old reservations (checkout date before given date)
    public int deleteOldReservations(Date date) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_OLD_RESERVATIONS)) {
            
            ps.setDate(1, new java.sql.Date(date.getTime()));
            return ps.executeUpdate();
            
        } catch (SQLException e) {
            System.err.println("Error deleting old reservations: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    
    // ==================== REPORTS & ANALYTICS ====================
    
    // Get revenue by date range
    public double getRevenueByDateRange(Date startDate, Date endDate) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_REVENUE_BY_DATE_RANGE)) {
            
            ps.setDate(1, new java.sql.Date(startDate.getTime()));
            ps.setDate(2, new java.sql.Date(endDate.getTime()));
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("Revenue");
            }
        } catch (SQLException e) {
            System.err.println("Error getting revenue by date range: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }
    
    // Get most booked rooms (top 5)
    public List<Object[]> getMostBookedRooms() {
        List<Object[]> roomStats = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_MOST_BOOKED_ROOMS);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Object[] row = new Object[2];
                row[0] = rs.getString("RoomNumber");
                row[1] = rs.getInt("BookingCount");
                roomStats.add(row);
            }
        } catch (SQLException e) {
            System.err.println("Error getting most booked rooms: " + e.getMessage());
            e.printStackTrace();
        }
        return roomStats;
    }
    
    // Get total number of reservations
    public int getTotalReservations() {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_TOTAL_RESERVATIONS);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("Total");
            }
        } catch (SQLException e) {
            System.err.println("Error getting total reservations: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get total revenue from all reservations
    public double getTotalRevenue() {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_TOTAL_REVENUE);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble("TotalRevenue");
            }
        } catch (SQLException e) {
            System.err.println("Error getting total revenue: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }
    
    // ==================== UTILITY METHODS ====================
    
    // Check if room is available for given dates
    public boolean isRoomAvailable(String roomNumber, Date checkIn, Date checkOut) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(CHECK_ROOM_AVAILABILITY)) {
            
            ps.setString(1, roomNumber);
            ps.setDate(2, new java.sql.Date(checkOut.getTime()));
            ps.setDate(3, new java.sql.Date(checkIn.getTime()));
            ps.setDate(4, new java.sql.Date(checkIn.getTime()));
            ps.setDate(5, new java.sql.Date(checkOut.getTime()));
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking room availability: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Get next available reservation ID (for preview)
    public int getNextReservationId() {
        return getTotalReservations() + 1;
    }
    
    // Calculate number of nights between two dates
    public int calculateNights(Date checkIn, Date checkOut) {
        long diffInMillies = checkOut.getTime() - checkIn.getTime();
        return (int) (diffInMillies / (1000 * 60 * 60 * 24));
    }
    
    // Calculate total amount based on room rate and nights
    public double calculateTotalAmount(String roomNumber, Date checkIn, Date checkOut) {
        int nights = calculateNights(checkIn, checkOut);
        double roomRate = getRoomRate(roomNumber);
        return nights * roomRate;
    }
    
    // Get room rate based on room number
    public double getRoomRate(String roomNumber) {
        // Room rates mapping
        switch(roomNumber) {
            case "101": case "102": return 150;
            case "103": case "104": return 180;
            case "105": case "106": return 200;
            case "201": case "202": return 250;
            case "203": case "204": return 280;
            case "205": case "206": return 300;
            case "301": case "302": return 350;
            case "303": case "304": return 400;
            case "305": case "306": return 450;
            default: return 200;
        }
    }
    
    // Get all unique room numbers
    public List<String> getAllRoomNumbers() {
        List<String> rooms = new ArrayList<>();
        String query = "SELECT DISTINCT RoomNumber FROM Reservations ORDER BY RoomNumber";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                rooms.add(rs.getString("RoomNumber"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // Add default rooms if no reservations exist
        if (rooms.isEmpty()) {
            for (int i = 101; i <= 106; i++) rooms.add(String.valueOf(i));
            for (int i = 201; i <= 206; i++) rooms.add(String.valueOf(i));
            for (int i = 301; i <= 306; i++) rooms.add(String.valueOf(i));
        }
        return rooms;
    }
    
    // Map ResultSet to Reservation object
    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Reservation reservation = new Reservation();
        reservation.setReservationID(rs.getInt("ReservationID"));
        reservation.setCustomerName(rs.getString("CustomerName"));
        reservation.setRoomNumber(rs.getString("RoomNumber"));
        reservation.setCheckIn(rs.getDate("CheckIn"));
        reservation.setCheckOut(rs.getDate("CheckOut"));
        reservation.setTotalAmount(rs.getDouble("TotalAmount"));
        return reservation;
    }
    
    // Test database connection
    public boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Close all resources (optional - for manual management)
    public void closeConnection(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}