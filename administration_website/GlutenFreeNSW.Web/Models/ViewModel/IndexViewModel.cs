using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace GlutenFreeNSW.Web.Models
{
    public class IndexViewModel
    {
        public IndexViewModel(IList<State> states)
        {
            var state = new State();
            state.Id = 0;
            state.Name = "";
            states.Insert(0, state);
            States = new SelectList(states, "Id", "Name");
        }

        public SelectList States { get; set; }
    }
}