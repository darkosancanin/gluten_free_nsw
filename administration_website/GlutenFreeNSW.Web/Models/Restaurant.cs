using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GlutenFreeNSW.Web.Models
{
    public class Restaurant
    {
        public Restaurant()
        {
            Description = String.Empty;
            Source = String.Empty;
            PhoneNumber = String.Empty;
            Latitude = 0;
            Longitude = 0;
            Suburb = String.Empty;
            Address = String.Empty;
            Name = String.Empty;
            Website = String.Empty;
        }
        
        public virtual int Id { get; set; }
        public virtual State State { get; set; }
        public virtual string Name { get; set; }
        public virtual string Address { get; set; }
        public virtual string Suburb { get; set; }
        public virtual string Description { get; set; }
        public virtual string PhoneNumber { get; set; }
        public virtual float Latitude { get; set; }
        public virtual float Longitude { get; set; }
        public virtual string Source { get; set; }
        public virtual string Website { get; set; }
        public virtual string Postcode { get; set; }

        public virtual string InsertSQL
        {
            get 
            {
                var sql = String.Format(@"INSERT INTO restaurants (stateId,name, address,suburb, description, phone_number, latitude, longitude, source, website, postcode) VALUES ({0}, '{1}', '{2}','{3}','{4}','{5}',{6},{7},'{8}','{9}','{10}');",
                                        State.Id,
                                        Name.Replace("'","''"),
                                        Address.Replace("'", "''"),
                                        Suburb.Replace("'", "''"),
                                        Description.Replace("'", "''"),
                                        PhoneNumber,
                                        Latitude,
                                        Longitude,
                                        Source.Replace("'", "''"),
                                        Website,
                                        Postcode);   
                return sql; 
            }
        }
    }
}