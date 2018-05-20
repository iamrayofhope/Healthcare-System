<%-- 
    Document   : records
    Created on : 5 May, 2018, 6:16:31 PM
    Author     : Himanshu
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css">
        <title>Counsel To Success | Moderation</title>        
        <%@include file="include/head.jsp" %>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.2.61/jspdf.min.js"></script>
        <script>
            function demoFromHTML() {
            var pdf = new jsPDF('p', 'pt', 'letter');
            // source can be HTML-formatted string, or a reference
            // to an actual DOM element from which the text will be scraped.
            source = $('#records-table')[0];

                // we support special element handlers. Register them with jQuery-style 
                // ID selector for either ID or node name. ("#iAmID", "div", "span" etc.)
                // There is no support for any other type of selectors 
                // (class, of compound) at this time.
                specialElementHandlers = {
                    // element with id of "bypass" - jQuery style selector
                    '#bypassme': function (element, renderer) {
                        // true = "handled elsewhere, bypass text extraction"
                        return true
                    }
                };
                margins = {
                    top: 20,
                    bottom: 60,
                    left: 10,
                    width: 700
                };
                // all coords and widths are in jsPDF instance's declared units
                // 'inches' in this case
                pdf.fromHTML(
                        source, // HTML string or DOM elem ref.
                        margins.left, // x coord
                        margins.top, {// y coord
                            'width': margins.width, // max width of content on PDF
                            'elementHandlers': specialElementHandlers
                        },
                        function (dispose) {
                            // dispose: object with X, Y of the last line add to the PDF 
                            //          this allow the insertion of new lines after html
                            pdf.save('Record.pdf');
                        }, margins);
            }
        </script>
    </head>
    
    <body id="target">
    
    <%
        Connection con = null;
        ResultSet res =  null;
        PreparedStatement stm = null;
        try {
            //Class.forName("org.apache.derby.jdbc.EmbeddedDriver", true, getClass().getClassLoader());
            Class.forName("org.apache.derby.jdbc.EmbeddedDriver").newInstance();
        if(request.getParameter("date1")!=null && !request.getParameter("date1").isEmpty())
        {
            String date1 = request.getParameter("date1")+" 00:00:00.000";
            String date2 = request.getParameter("date2")+" 00:00:00.000";
            con = DriverManager.getConnection("jdbc:derby://localhost:1527/students_forum", "students_forum", "password");
            String query = "SELECT * FROM \"post\" WHERE post_date >='"+date1+"' AND post_date <= '"+date2+"'";
            stm = con.prepareStatement(query); 
            res = stm.executeQuery();
        }
  

    %>
        <div id="records-page" data-role="page">
            <div data-role="header">
                <a href="#panel" data-icon="bars">Menu</a>
                <h2>Healthcare System | Records</h2>
            </div>
            <div data-role="content">   
            <form action="#" method="post" data-ajax="false">
                <table class="table-width">
                    <td class="firstCol"><a id="requiredMessage" class="right">Enter Dates From</a></td>
                    <td>
                    	<input type="date" name="date1" class="datepicker check" placeholder="Enter Dates From">	
                    </td>
                    <td class="firstCol"><a id="requiredMessage" class="right">To</a></td>
                    <td>
                        <input type="date" name="date2" class="datepicker check" placeholder="To">	
                    </td>
                    <td style="text-align: right; width: 6em">
                        <button type="submit" name="submit" value="submit" data-mini="true" data-icon="submit" data-inline="true" data-theme="a">Submit</button>
                    </td>
                </table>
            <table id="records-table">
                <button value="submit" data-mini="true" data-icon="submit" data-inline="true" data-theme="a" onclick="javascript:demoFromHTML();">Generate PDF</button>
                <thead>
                   <th>Id</th>
                   <th>User Id</th>
                   <th>Group Id</th>
                   <th>Post Text</th>
                   <th>Date</th>
                </thead>  
                <tbody>
                <%
                while(res.next())
                {
                %>
                <tr>
                    <td  style="width: 3em"><%=res.getInt(1)%></td>
                    <td style="width: 3em"><%=res.getInt(2)%></td>
                    <td style="width: 3em"><%=res.getInt(3)%></td>
                    <td><%=res.getString(4)%></td>
                    <td  style="width: 3em"><%=res.getString(5)%></td>   
                </tr>
                <%
                }
                %>
                </tbody>
                <%
                    } catch (Exception ex) {
                    //out.print(ex);
                    }
                %>
                </table></form>
                <script>
                    $("#records-table").dataTable();
                    $("#moderation-table_wrapper").find("select, input").attr("data-role", "none");
                </script>
                <%@include file="include/panel.jsp" %>
                
            </div>
        </div>
    </body>
</html>