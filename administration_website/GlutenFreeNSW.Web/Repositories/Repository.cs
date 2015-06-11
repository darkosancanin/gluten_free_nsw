using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Dynamic;
using System.Web;
using NHibernate;
using NHibernate.Linq;
using FluentNHibernate.Cfg;
using FluentNHibernate.Cfg.Db;
using GlutenFreeNSW.Web.Models;

namespace GlutenFreeNSW.Web.Repositories
{
    public interface IRepository
    {
        IList<State> GetAllStates();
        string GenerateSql();
        void SaveRestaurant(Restaurant restaurant);
        JqGridData GetRestaurants(string sidx, string sord, int page, int rows, string searchText, int stateId);
        Restaurant GetRestaurantById(int id);
        void DeleteRestaurantById(int id);
    }

    public class Repository:IRepository
    {
        private string _pathToDatabase;
        
        public Repository(string pathToDatabase){
            _pathToDatabase = pathToDatabase;
        }

        public JqGridData GetRestaurants(string sidx, string sord, int page, int rows, string searchText, int stateId)
        {
            using (var session = CreateSessionFactory().OpenSession())
            {
                var restaurants = session.Linq<Restaurant>().OrderBy(sidx + " " + sord).ToList();
                if (stateId > 0)
                {
                    restaurants = restaurants.Where(x => x.State.Id == stateId).ToList(); 
                }
                var count = restaurants.ToList();

                if (!String.IsNullOrEmpty(searchText))
                {
                    searchText = searchText.ToLower();
                    restaurants = restaurants.Where(x => x.Name.ToLower().Contains(searchText)
                                                || x.Address.ToLower().Contains(searchText)
                                                || x.Suburb.ToLower().Contains(searchText)).ToList();
                }

                count = restaurants.ToList();

                int totalRecords = restaurants.Count();
                int pageIndex = Convert.ToInt32(page) - 1;
                int pageSize = rows;
                int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);
                restaurants = restaurants.Skip(pageIndex * pageSize)
                                 .Take(pageSize).ToList();

                var gridDataItems = new List<JqGridDataItem>();
                foreach (var restaurant in restaurants)
                {
                    var dataItem = new JqGridDataItem(restaurant.Id, restaurant.Name, restaurant.Address, restaurant.Suburb, restaurant.State.Name);
                    gridDataItems.Add(dataItem);
                }

                return new JqGridData(totalPages, page, totalRecords, gridDataItems);
            }
        }

        public ISessionFactory CreateSessionFactory()
        {
            ISessionFactory sessionFactory;

            try
            {
                sessionFactory = Fluently.Configure()
                  .Database(SQLiteConfiguration.Standard.UsingFile(_pathToDatabase))
                  .Mappings(m =>
                    m.FluentMappings.AddFromAssemblyOf<Restaurant>())
                  .BuildSessionFactory();
            }
            catch (Exception ex)
            {
                var message = "Unable to create the session factory. ";
                if (ex.InnerException != null)
                    message += "Reason: " + ex.InnerException.Message;
                if (ex.InnerException.InnerException != null)
                    message += "Inner Exception: " + ex.InnerException.InnerException.Message;
                throw new ApplicationException(message, ex);
            }

            return sessionFactory;
        }

        public IList<State> GetAllStates()
        {
            using (var session = CreateSessionFactory().OpenSession())
            {
                return session.CreateCriteria(typeof(State)).List<State>();
            }
        }

        public Restaurant GetRestaurantById(int id)
        {
            using (var session = CreateSessionFactory().OpenSession())
            {
                return session.Linq<Restaurant>().Where(x => x.Id == id).First();
            }
        }

        public void DeleteRestaurantById(int id)
        {
            using (var session = CreateSessionFactory().OpenSession())
            {
                session.Delete(session.Linq<Restaurant>().Where(x => x.Id == id).First());
                session.Flush();
            }
        }

        public void SaveRestaurant(Restaurant restaurant)
        {
            using (var session = CreateSessionFactory().OpenSession())
            {
                session.SaveOrUpdate(restaurant);
                session.Flush();
            }
        }

        public string GenerateSql()
        {
            using (var session = CreateSessionFactory().OpenSession())
            {
                var restaurants = session.CreateCriteria(typeof(Restaurant)).List<Restaurant>();
                var sql = String.Empty;
                foreach (var restaurant in restaurants)
                    sql += restaurant.InsertSQL + "\r\n";

                return sql;
            }
        }
    }
}