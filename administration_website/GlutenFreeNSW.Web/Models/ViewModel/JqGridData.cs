using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GlutenFreeNSW.Web.Models
{
    public class JqGridData
    {
        public JqGridData(int total, int page, int records, IList<JqGridDataItem> rows)
        {
            this.total = total;
            this.page = page;
            this.records = records;
            this.rows = rows;
        }

        public int total { get; set; }
        public int page { get; set; }
        public int records { get; set; }
        public IList<JqGridDataItem> rows { get; set; }
    }

    public class JqGridDataItem
    {
        public JqGridDataItem(int id, string name, string address, string suburb, string state)
        {
            this.id = id;
            this.cell = new []{id.ToString(), name, address, suburb, state};
        }

        public int id { get; set; }
        public IList<string> cell { get; set; }
    }
}