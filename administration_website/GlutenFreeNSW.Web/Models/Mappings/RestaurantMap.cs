using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using FluentNHibernate.Mapping;

namespace GlutenFreeNSW.Web.Models.Mappings
{
    public class RestaurantMap : ClassMap<Restaurant>
    {
        public RestaurantMap()
        {
            Table("Restaurants");
            Id(x => x.Id, "restaurantId");
            Map(x => x.Name).Not.Nullable();
            Map(x => x.Address).Not.Nullable();
            Map(x => x.Suburb).Not.Nullable();
            Map(x => x.Description).Not.Nullable();
            Map(x => x.PhoneNumber,"phone_number").Not.Nullable();
            Map(x => x.Latitude).Not.Nullable();
            Map(x => x.Longitude).Not.Nullable();
            Map(x => x.Postcode).Not.Nullable();
            Map(x => x.Source).Not.Nullable();
            Map(x => x.Website).Not.Nullable();
            References(x => x.State,"stateId").Not.Nullable();
        }
    }
}