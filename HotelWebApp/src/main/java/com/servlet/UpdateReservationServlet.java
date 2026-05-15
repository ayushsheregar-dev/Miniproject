package com.servlet;

import com.dao.ReservationDAO;
import com.model.Reservation;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateReservationServlet")
public class UpdateReservationServlet extends HttpServlet {
    private ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get form data
            int reservationID = Integer.parseInt(request.getParameter("reservationID"));
            String customerName = request.getParameter("customerName");
            String roomNumber = request.getParameter("roomNumber");
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date checkIn = sdf.parse(request.getParameter("checkIn"));
            Date checkOut = sdf.parse(request.getParameter("checkOut"));
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));

            // Validation
            if (customerName == null || customerName.trim().isEmpty()) {
                response.sendRedirect("reservationupdate.jsp?id=" + reservationID + "&error=Customer name required");
                return;
            }
            
            if (checkOut.before(checkIn) || checkOut.equals(checkIn)) {
                response.sendRedirect("reservationupdate.jsp?id=" + reservationID + "&error=Check-out must be after check-in");
                return;
            }

            // Create Reservation object
            Reservation reservation = new Reservation();
            reservation.setReservationID(reservationID);
            reservation.setCustomerName(customerName);
            reservation.setRoomNumber(roomNumber);
            reservation.setCheckIn(checkIn);
            reservation.setCheckOut(checkOut);
            reservation.setTotalAmount(totalAmount);

            // Update in database
            boolean success = reservationDAO.updateReservation(reservation);

            if (success) {
                response.sendRedirect("DisplayReservationsServlet?message=Reservation updated successfully!");
            } else {
                response.sendRedirect("reservationupdate.jsp?id=" + reservationID + "&error=Update failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("reservationupdate.jsp?error=Invalid input: " + e.getMessage());
        }
    }
}