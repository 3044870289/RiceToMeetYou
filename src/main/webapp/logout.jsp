<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session.invalidate(); // 销毁 session
    response.sendRedirect("login.jsp"); // 重定向到登录页面
%>