package com.model;

import java.util.Date;

public class Reservation {
    private int reservationID;
    private String customerName;
    private String roomNumber;
    private Date checkIn;
    private Date checkOut;
    private double totalAmount;

    // Constructors
    public Reservation() {}

    public Reservation(int reservationID, String customerName, String roomNumber, 
                       Date checkIn, Date checkOut, double totalAmount) {
        this.reservationID = reservationID;
        this.customerName = customerName;
        this.roomNumber = roomNumber;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.totalAmount = totalAmount;
    }

    // Getters
    public int getReservationID() { return reservationID; }
    public String getCustomerName() { return customerName; }
    public String getRoomNumber() { return roomNumber; }
    public Date getCheckIn() { return checkIn; }
    public Date getCheckOut() { return checkOut; }
    public double getTotalAmount() { return totalAmount; }

    // Setters
    public void setReservationID(int reservationID) { this.reservationID = reservationID; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }
    public void setCheckIn(Date checkIn) { this.checkIn = checkIn; }
    public void setCheckOut(Date checkOut) { this.checkOut = checkOut; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
}