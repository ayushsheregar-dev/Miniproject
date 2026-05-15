package com.servlet;

import com.dao.ReservationDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DeleteReservationServlet")
public class DeleteReservationServlet extends HttpServlet {
    private ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("reservationdelete.jsp?error=Reservation ID is required");
            return;
        }
        
        try {
            int reservationID = Integer.parseInt(idParam);
            
            // Delete from database
            boolean success = reservationDAO.deleteReservation(reservationID);

            if (success) {
                response.sendRedirect("DisplayReservationsServlet?message=Reservation cancelled successfully!");
            } else {
                response.sendRedirect("reservationdelete.jsp?error=Reservation ID " + reservationID + " not found");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("reservationdelete.jsp?error=Invalid Reservation ID format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("reservationdelete.jsp?error=Database error: " + e.getMessage());
        }
    }
}