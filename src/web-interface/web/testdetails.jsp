<%-- 
 * @file    testdetails.jsp
 * @brief   Display the details of a single test case result.
 * @author  Kimberly Begley
 * @author  Michael Hucka
 * @date    Created Jul 30, 2008, 9:25:21 AM
 *
 * ----------------------------------------------------------------------------
 * This file is part of the SBML Test Suite.  Please visit http://sbml.org for
 * more information about SBML, and the latest version of the SBML Test Suite.
 *
 * Copyright (C) 2010-2015 jointly by the following organizations: 
 *     1. California Institute of Technology, Pasadena, CA, USA
 *     2. EMBL European Bioinformatics Institute (EBML-EBI), Hinxton, UK.
 *     3. University of Heidelberg, Heidelberg, Germany
 *
 * Copyright (C) 2008-2009 California Institute of Technology (USA).
 *
 * Copyright (C) 2004-2007 jointly by the following organizations:
 *     1. California Institute of Technology (USA) and
 *     2. University of Hertfordshire (UK).
 * 
 * The SBML Test Suite is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation.  A copy of the license
 * agreement is provided in the file named "LICENSE.txt" included with
 * this software distribution and also available on the Web at
 * http://sbml.org/Software/SBML_Test_Suite/License
 * ----------------------------------------------------------------------------
--%>

<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.math.*" %>

<%@ page import="sbml.test.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<%@ include file="sbml-head.html"%>
<%@ include file="sbml-top.html"%>

<%
// Log that we've been invoked.

OnlineSTS.init();
OnlineSTS.logInvocation(request);

// We get a number of things via the URL handed to us in the link that the
// user clicked.  The rest we get from the context.  The following pulls
// out the different pieces we need to get started.  If they're missing,
// we assume it's either due to session timeout or an invalid URL.

// Each square in the summary map generated by showresults.jsp is a link to
// this page (testdetails.jsp).  'resultsID' and 'testname' are handed as
// parameters in the URL of the link (and hence are request parameters, not
// session variables).  'sessionResults' is in the session, not the request.

boolean missingData    = false;
boolean sessionExpired = false;
boolean badResultsID   = false;

String testName = (String) request.getParameter("testName");
if (testName == null)
{
    OnlineSTS.logError("Null testName.");
    missingData = true;
}

String resultsID = (String) request.getParameter("resultsID");
if (resultsID == null)
{
    OnlineSTS.logError("Null resultsID.");
    missingData = true;
}
else
    OnlineSTS.logInfo(request, "Showing details for case #" + testName
                               + ", results ID " + resultsID); 

HashMap sessionResults = (HashMap) session.getAttribute("sessionResults");
if (sessionResults == null)
{
    OnlineSTS.logError(request, "Null sessionResults; assuming timeout.");
    sessionExpired = true;
}

HashMap testResultsMap = null;
if (sessionResults != null)
{
    testResultsMap = (HashMap) sessionResults.get(resultsID);
}

if (testResultsMap == null)
{
    OnlineSTS.logError("Null testResultsMap; resultsID is probably bad.");
    badResultsID = true;
}

if (missingData || sessionExpired | badResultsID)
{
    // In case of session timeouts, can't rely on OnlineSTS being able to
    // pull values from the request, so we have to go really low-level.

    String rootURL  = request.getScheme() + "://"
        + request.getServerName() + ":" + request.getServerPort()
        + request.getContextPath();

    String imageURL = rootURL + "/web/images";

    String homeURL  = "http://sbml.org/Facilities/Online_SBML_Test_Suite";
%>

   <div id='pagetitle'><h1 class='pagetitle'><font color="darkred">
        SBML Test Suite session error</font></h1></div><!-- id='pagetitle' -->
        <div style="float: right; margin: 0 0 1em 2em; padding: 0 0 0 5px">
        <img src="<%=imageURL%>/Icon-online-test-suite-64px.jpg">
    </div>
<%
    if (sessionExpired)
    {
%>
        <p>
        We regret that your session appears to have expired.  For
        performance reasons, the duration of sessions is limited to
        <%= session.getMaxInactiveInterval()/60 %> minutes.  Please
        re-upload your results and proceed.
<%
    }
    else if (missingData || badResultsID)
    {
%>
        <p>
        We regret that this page's URL is missing important data, or
        else something has happened to the data in this session.  (It
        is possible that the session has expired; for performance reasons,
        the duration of sessions is limited to
        <%= session.getMaxInactiveInterval()/60 %> minutes.)  Please
        use the link below to go back to the results upload page.
<%
    }
%>
    <p>	
    <center>
        <a href="<%=homeURL%>">
        <img border="0" align="center" src="<%=imageURL%>/Icon-red-left-arrow.jpg">
        Return to the Online SBML Test Suite front page.
        </a>
    </center>
    </p>
<%
    return;
}

//
// Finally, onward with the real work.
//

TreeMap<Integer, UserTestResult> results
    = (TreeMap<Integer, UserTestResult>)testResultsMap.get("testResults");

// Get the test *reference* data for this case, but don't get it via
// thisResult because that might be null if this case wasn't in the
// set uploaded by the user.  Also, here we need the physical path
// as it exists on the server, not what is presented to the world.

String testdir    = getServletContext().getRealPath("/test-cases");
TestCase thisCase = new TestCase(testdir, testName);
%>
    <style type='text/css'>
    table { margin: 1em auto; width: 75% !important}
    table td, th { font-size: 9pt; padding: 0.25em; }
    h2 { display: block; border-bottom: 1px solid #ccc; padding: 4px 0px; width: 100%; }
    </style>

    <div id='pagetitle'>
    <div style="float: right; margin: 0 0 1em 2em; padding: 0 0 0 5px">
      <img src="<%=OnlineSTS.getImageURL(request)%>/Icon-online-test-suite-64px.jpg" border="0">
    </div>
    <h1 class='pagetitle'>Details for SBML Test Case #<%=testName%></h1>
    </div><!-- id='pagetitle' -->
    
<%

// Get the user's results, if there were any.

UserTestResult thisResult = results.get(Integer.parseInt(testName));
if (thisResult == null)
{
%>
    <p><b><font color="GoldenRod">
    Note: Results for this case were <i>not</i> part of your uploaded
    test results.</font></b></p>
<%
}
else
{
    UserTestCase theCase = thisResult.getUserTestCase();
    int numRows          = theCase.getTestNumRows();
    int numVars          = theCase.getTestNumVars();
    int points           = numRows * numVars;
%>
    <p style="margin-top: 1em"><em>Result</em>:
<%
    if (thisResult.getNumDifferences() > 0)
    {
%>
        <b><font color="darkred">Failed at
        <%=thisResult.getNumDifferences()%> of <%=points%> data points</font></b>.
        Details are <a href="#results">presented below</a>.
<%
    }
    else if (thisResult.hasError())
    {
%>
        <b><font color="darkred">Skipped due to the following reason:</font></b><br>
        <table>
        <tr><td style="border: 1px solid darkred !important"><%=thisResult.getErrorMessage()%></td></tr>
        </table>
<%
    }
    else
    {
%>
        <b><font color="green">Passed!</font></b><BR>
<%
    }
}
%>

    <h2>Case description</h2>

    <p><c:import url="<%="file://" + thisCase.getHTMLFile().getPath()%>" /></p>

    The following is a plot of the <b>expected</b> results:</p>

    <center>
      <c:import url="<%="file://" + thisCase.getPlotFile().getPath()%>" /></p>
    </center>

    <p> Component tags involved in test case: 
    <em><%=thisCase.getComponentTagsAsString()%>.</em><BR></p>

    <p> Test tags involved in test case: 
    <em><%=thisCase.getTestTagsAsString()%>.</em><BR></p>

<%
if (thisResult != null)
{
%>
    <h2><a name="results"></a>Outcome of analyzing result uploaded for test case #<%=testName%></h2>
<%

    if (thisResult.getNumDifferences() > 0)
    {
        UserTestCase theCase       = thisResult.getUserTestCase();
        ResultDifference[][] diffs = thisResult.getDifferences();
        double[][] expected        = theCase.getExpectedData();
        double[][] userData        = theCase.getUserData();
        Vector<String> varNames    = theCase.getTestVars();
        int numRows                = theCase.getTestNumRows();
        int numVars                = theCase.getTestNumVars();
        int points                 = numRows * numVars;
%>
        <p>
        <font color="darkred"><b><font color="darkred">Failed</font></b> at
        <%=thisResult.getNumDifferences()%> of <%=points%> data points</font><BR></p>

	<p>The table below indicates which data points
	did not come close enough to the expected values.  Green
        values are the expected data values; red values appeared in the
        uploaded results but do not match the expected value within the
        error tolerances. The tolerances for this test case (#<%=testName%>) are:

        <table class="borderless-table" style="margin-left: 2em">
        <tr>
            <td width="150px">Absolute tolerance (T<sub>a</sub>)</td>
            <td width="14px">=</td>
            <td><%=theCase.getTestAbsoluteTol()%></td>
        </tr><tr>
            <td>Relative tolerance (T<sub>r</sub>)</td>
            <td>=</td>
            <td><%=theCase.getTestRelativeTol()%></td>
        </tr>
        </table>

        The following is how the errors are determined.  
        Let C<sub>ij</sub> stand for the expected (correct) values for this 
        test, and let U<sub>ij</sub> stand for the the uploaded result values.
        A data point is <i>within tolerances</i> if and only if
	<blockquote style="margin-left: 2em">
            <font color="#777" size="+1">|</font>C<sub>ij</sub> &minus; U<sub>ij</sub><font color="#777" size="+1">|</font>
             &le;
            <font color="#777" size="+1">(</font> T<sub>a</sub> + T<sub>r</sub> &times; |C<sub>ij</sub>| <font color="#777" size="+1">)</font>
        </blockquote>

        <p>You can hover the mouse pointer over a table entry to be shown
        the difference in the values.

        <p><table class="sm-padding">
	<tr>
            <th>Time</th>
<%
	for (String name : varNames)
	    out.println("<th>" + name + "</th>");
%>
        </tr>
<%
	for (int r = 0; r < numRows; r++)
        {
            out.println("<tr>");
	    for (int c = 0; c < expected[0].length; c++)
            {
                ResultDifference thisDiff = diffs[r][c];
                double refVal             = expected[r][c];
                double userVal            = userData[r][c];

                if (thisDiff != null)
                {
                    if (thisDiff.isNumerical())
                        out.println("<td title=\"Difference: "
                                    + thisDiff.getValue() + "\">");
                    else
                        out.println("<td title=\"Expected " + refVal +
                                    " but found " + userVal + "\">");
                }
                else
                    out.println("<td>");

                out.println("<span style=\"font-size: 7pt; color: green\">"
                            + expected[r][c] + "</span>");

                if (thisDiff != null)
                    out.println("<br><span style=\"font-size: 7pt; color: red\">" 
                                + userData[r][c] + "</span>");

                out.println("</td>");
            }
            out.println("</tr>");            
        }
%>
        </table>
<%
    }
    else if (thisResult.hasError())
    {
%>
        <b><font color="darkred">Skipped due to the following reason:</font></b><br>
        <table>
        <tr><td style="border: 1px solid darkred !important"><%=thisResult.getErrorMessage()%></td></tr>
        </table>
<%
    }
    else
    {
%>
        <b><font color="green">Passed!</font></b><BR>
<%
    }
}
%>



<p style="margin-top: 3em">	
<center>
  <a href="http://sbml.org/Facilities/Online_SBML_Test_Suite">
    <img border="0" align="center" 
         src="<%=OnlineSTS.getImageURL(request)%>/Icon-red-left-arrow.jpg">
    Return to the Online SBML Test Suite front page.
  </a>
</center>
</p>


<%@ include file="sbml-bottom.html"%>
