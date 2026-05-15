package com.servlet;

import com.dao.ReservationDAO;
import com.model.Reservation;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DisplayReservationsServlet")
public class DisplayReservationsServlet extends HttpServlet {
    private ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get all reservations from database
            List<Reservation> reservations = reservationDAO.getAllReservations();
            
            // Store in request attribute
            request.setAttribute("reservations", reservations);
            
            // Forward to JSP for display
            request.getRequestDispatcher("reservationdisplay.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading reservations: " + e.getMessage());
            request.getRequestDispatcher("reservationdisplay.jsp").forward(request, response);
        }
    }
}