<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">


<div style="height:400px"></div>
<div id="login" class="login">
    <form action="<%=Url.Content("~/restaurants/login")%>" method="post">
    <div class="logincontent">
    <input type="password" name="password" class="loginpassword" />
    <input type="hidden" name="returnUrl" value="<%=Request["ReturnUrl"] %>" />
    </div>
    <input class="loginbutton" type="submit" value="login" />
    </form>
</div>

<script type="text/javascript">
$(document).ready(function() {
    $('#login').dialog({ title: 'Enter your password', modal:true, resizable:false });
});
</script>

</asp:Content>
