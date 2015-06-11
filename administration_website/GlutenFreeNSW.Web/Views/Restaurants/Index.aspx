<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<GlutenFreeNSW.Web.Models.IndexViewModel>" %>

<asp:Content ID="indexContent" ContentPlaceHolderID="MainContent" runat="server">
    
<form action="<%=Url.Content("~/restaurants/Index/")%>" method="post">
    <div class="search">
        <input type="text" id="searchText" class="searchbox" name="searchText" value="" />
        <%= Html.DropDownList("stateId", Model.States)  %>
        <input type="submit" class="searchbutton" value="search" style="width:140px" onclick="gridReload();return false;" />
    </div>
    
    <table id="restaurantGrid" class="scroll" cellpadding="0" cellspacing="0"></table>
    <div id="pager" class="scroll" style="text-align:center;"></div>
    
    <script type="text/javascript">
        jQuery(document).ready(function() {
            jQuery("#restaurantGrid").jqGrid({
                url: '<%=Url.Content("~/Restaurants/GridData/")%>',
                datatype: 'json',
                mtype: 'GET',
                colNames: ['Id', 'Name', 'Address', 'Suburb', 'State'],
                colModel: [
                              { name: 'Id', index: 'Id', width:100, align: 'center' },
                              { name: 'Name', index: 'Name', align: 'left' },
                              { name: 'Address', index: 'Address', align: 'left' },
                              { name: 'Suburb', index: 'Suburb', align: 'left' },
                              { name: 'State', index: 'State', align: 'center'}],
                pager: jQuery('#pager'), 
                autowidth: true,
                height: 'auto',
                rowNum: 20,
                rowList: [5, 10, 20, 50],
                sortname: 'Id',
                sortorder: "desc",
                viewrecords: true,
                caption: '',
                imgpath: '<%=Url.Content("~/Scripts/themes/smoothness/images")%>',
                onSelectRow: function(id) {
                    window.location = '<%=Url.Content("~/restaurants/edit/")%>' + id;
                }
            });
        });

        function gridReload() {
            var searchText = jQuery("#searchText").val();
            var stateId = jQuery("#stateId").val();
            jQuery("#restaurantGrid").setGridParam({ url: '<%=Url.Content("~/restaurants/griddata/")%>' + '?searchText=' + searchText + '&stateId=' + stateId, page: 1 }).trigger("reloadGrid");
        }
    </script>
</form>
</asp:Content>
