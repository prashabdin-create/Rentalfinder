package com.SignupServlet;

public class Request {
    private int id;
    private int userId;
    private String name;
    private String requestType;
    private String fromDate;
    private String toDate;
    private int totalDays;
    private String status;
    private String reason;

    public Request(int id, int userId, String name, String requestType,
                   String fromDate, String toDate, int totalDays, String status, String reason) {
        this.id = id;
        this.userId = userId;
        this.name = name;
        this.requestType = requestType;
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.totalDays = totalDays;
        this.status = status;
        this.reason = reason;
    }

    // Getters
    public int getId() { return id; }
    public int getUserId() { return userId; }
    public String getName() { return name; }
    public String getRequestType() { return requestType; }
    public String getFromDate() { return fromDate; }
    public String getToDate() { return toDate; }
    public int getTotalDays() { return totalDays; }
    public String getStatus() { return status; }
    public String getReason() { return reason; }
}
