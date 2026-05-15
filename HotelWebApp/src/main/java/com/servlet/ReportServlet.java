package com.servlet;

import com.dao.ReservationDAO;
import com.model.Reservation;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {
    private ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            
            // Validation
            if(startDateStr == null || startDateStr.trim().isEmpty() || 
               endDateStr == null || endDateStr.trim().isEmpty()) {
                response.sendRedirect("report_form.jsp?error=Please select both start and end dates");
                return;
            }
            
            Date startDate = sdf.parse(startDateStr);
            Date endDate = sdf.parse(endDateStr);
            
            // Check if end date is after start date
            if(endDate.before(startDate)) {
                response.sendRedirect("report_form.jsp?error=End date must be after start date");
                return;
            }

            // Get data from DAO
            List<Reservation> reservations = reservationDAO.getReservationsByDateRange(startDate, endDate);
            double revenue = reservationDAO.getRevenueByDateRange(startDate, endDate);
            List<Object[]> mostBooked = reservationDAO.getMostBookedRooms();

            // Set attributes for JSP
            request.setAttribute("reservations", reservations);
            request.setAttribute("revenue", revenue);
            request.setAttribute("mostBooked", mostBooked);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("reservationCount", reservations.size());

            // Forward to result page
            request.getRequestDispatcher("report_result.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("report_form.jsp?error=Invalid date format: " + e.getMessage());
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("report_form.jsp");
    }
}