using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using FluentNHibernate.Mapping;

namespace GlutenFreeNSW.Web.Models.Mappings
{
    public class StateMap : ClassMap<State>
    {
        public StateMap()
        {
            Table("States");
            Id(x => x.Id);
            Map(x => x.Name);
        }
    }
}