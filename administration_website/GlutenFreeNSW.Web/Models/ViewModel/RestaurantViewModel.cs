using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace GlutenFreeNSW.Web.Models
{
    public class RestaurantViewModel
    {
        public RestaurantViewModel(Restaurant restaurant, IList<State> states)
        {
            Restaurant = restaurant;
            var stateId = 2;
            if(restaurant.State != null)
                stateId = restaurant.State.Id;
            States = new SelectList(states, "Id", "Name", stateId);
        }

        public Restaurant Restaurant { get; set; }
        public SelectList States { get; set; }
    }
}