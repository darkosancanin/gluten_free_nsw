<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<GlutenFreeNSW.Web.Models.RestaurantViewModel>" %>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

<%= Html.ValidationSummary() %>

<form action="<%=Url.Content("~/restaurants/edit/")%>" method="post">

<div class="fieldheading">Name</div>
<div class="fieldcontent">
<input type="text" name="name" value="<%=Model.Restaurant.Name %>" />
<%= Html.ValidationMessage("Name", "*") %>
</div>

<div class="fieldheading">State</div>
<div class="fieldcontent">
<%= Html.DropDownList("stateId", Model.States)  %>
</div>

<div class="fieldheading">Address</div>
<div class="fieldcontent">
<textarea name="address" id="address" cols="60" rows="2"><%=Model.Restaurant.Address %></textarea>
<%= Html.ValidationMessage("Address", "*") %>
</div>

<div class="fieldheading">Suburb</div>
<div class="fieldcontent">
<input type="text" id="suburb" name="suburb" value="<%=Model.Restaurant.Suburb %>" />
<%= Html.ValidationMessage("Suburb", "*") %>
</div>

<div class="fieldheading">Postcode</div>
<div class="fieldcontent">
<input type="text" id="postcode" name="postcode" value="<%=Model.Restaurant.Postcode %>" />
<%= Html.ValidationMessage("Postcode", "*") %>
</div>

<div class="fieldheading">Description</div>
<div class="fieldcontent">
<textarea name="description" cols="60" rows="5"><%=Model.Restaurant.Description %></textarea>
</div>

<div class="fieldheading">Phone Number</div>
<div class="fieldcontent">
<input type="text" name="phoneNumber" value="<%=Model.Restaurant.PhoneNumber %>" />
<%= Html.ValidationMessage("PhoneNumber", "*") %>
</div>

<div class="fieldheading">Website</div>
<div class="fieldcontent">
<input type="text" name="website" value="<%=Model.Restaurant.Website %>" />
<%= Html.ValidationMessage("Website", "*") %>
</div>

<div class="fieldheading">Source</div>
<div class="fieldcontent">
<input type="text" name="source" value="<%=Model.Restaurant.Source %>" />
</div>

<div class="fieldheading">Latitude / Longitude</div>
<div class="fieldcontent">
<input type="text" id="latitude" name="latitude" value="<%=Model.Restaurant.Latitude %>" style="width:240px" />
<input type="text" id="longitude" name="longitude" value="<%=Model.Restaurant.Longitude %>" style="width:240px" />
</div>

<div class="fieldcontent">
<input type="hidden" name="id" value="<%=Model.Restaurant.Id %>" />
<input type="submit" value="save" style="width:140px" />
<input type="button" value="delete" style="width:140px" onclick="if(!confirm('Are you sure you would like to delete this restaurant?')) return false; javascript:window.location='<%=Url.Content("~/restaurants/delete/")%><%=Model.Restaurant.Id %>'" />
<input type="button" value="retrieve coordinates" style="width:200px" onclick="retrieveCoordinates()" />
</div>

</form>


<div id="map_canvas" style="width:700px; height:500px"></div>
<script type="text/javascript">
    var geocoder;
    var map;
    function initializeMap() {
        geocoder = new google.maps.Geocoder();
        var latlng = new google.maps.LatLng(<%=Model.Restaurant.Latitude %>, <%=Model.Restaurant.Longitude %>);
        var myOptions = {
            zoom: 15,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        }
        map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
        
        var marker = new google.maps.Marker({
                        map: map,
                        position: latlng
                    });
    }

    function retrieveCoordinates() {
        var address = jQuery("#address").val() + ", " + jQuery("#suburb").val() + " " + jQuery("#postcode").val() + ' Australia';
        if (geocoder) {
            geocoder.geocode({ 'address': address }, function(results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    map.setCenter(results[0].geometry.location);
                    jQuery("#latitude").val(results[0].geometry.location.lat());
                    jQuery("#longitude").val(results[0].geometry.location.lng());
                    var marker = new google.maps.Marker({
                        map: map,
                        position: results[0].geometry.location
                    });
                } else {
                    alert("Geocode was not successful for the following reason: " + status);
                }
            });
        }
    }
    
     jQuery(document).ready(initializeMap);
</script>


</asp:Content>
