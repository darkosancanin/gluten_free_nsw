using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using GlutenFreeNSW.Web.Models;
using GlutenFreeNSW.Web.Repositories;
using System.Web.Hosting;
using System.Web.Security;

namespace GlutenFreeNSW.Web.Controllers
{
    [HandleError]
    public class RestaurantsController : Controller
    {
        private IRepository _repository;

        public RestaurantsController(IRepository repository)
        {
            _repository = repository;
        }

        public RestaurantsController() 
        {
            var pathToDB = System.Configuration.ConfigurationManager.AppSettings["database_path"];
            _repository = new Repository(pathToDB);
        }

        [Authorize]
        public ActionResult GridData(string sidx, string sord, int page, int rows, string searchText, string stateId)
        {
            var stateIdValue = 0;
            if (!String.IsNullOrEmpty(stateId))
                stateIdValue = Convert.ToInt32(stateId);
            var restaurants = _repository.GetRestaurants(sidx, sord, page, rows, searchText, stateIdValue);
            return Json(restaurants, JsonRequestBehavior.AllowGet);
        }

        [AcceptVerbs(HttpVerbs.Get)]
        [Authorize]
        public ActionResult Add()
        {
            return View("Edit", new RestaurantViewModel(new Restaurant(), _repository.GetAllStates()));
        }

        [AcceptVerbs(HttpVerbs.Get)]
        [Authorize]
        public ActionResult Edit(string id)
        {
            return View("Edit", new RestaurantViewModel(_repository.GetRestaurantById(Convert.ToInt32(id)), _repository.GetAllStates()));
        }

        [Authorize]
        public ActionResult Delete(string id)
        {
            _repository.DeleteRestaurantById(Convert.ToInt32(id));
            return RedirectToAction("Index");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Authorize]
        public ActionResult Edit(Restaurant restaurant, string stateId)
        {
            var states = _repository.GetAllStates();
            restaurant.State = states.Where(x => x.Id == Convert.ToInt32(stateId)).First();

            if(String.IsNullOrEmpty(restaurant.Description)) restaurant.Description = String.Empty;

            if (String.IsNullOrEmpty(restaurant.Name))
                ModelState.AddModelError("Name", "Name is required.");
            if (String.IsNullOrEmpty(restaurant.Address))
                ModelState.AddModelError("Address", "Address is required.");
            if (String.IsNullOrEmpty(restaurant.Suburb))
                ModelState.AddModelError("Suburb", "Suburb is required.");
            if (String.IsNullOrEmpty(restaurant.Postcode))
                ModelState.AddModelError("Postcode", "Postcode is required.");
            if (String.IsNullOrEmpty(restaurant.PhoneNumber))
                ModelState.AddModelError("PhoneNumber", "Phone number is required.");
            if (String.IsNullOrEmpty(restaurant.Website))
                ModelState.AddModelError("Website", "Website is required.");

            if (!ModelState.IsValid)
                return View(new RestaurantViewModel(restaurant, states));

            _repository.SaveRestaurant(restaurant);
            
            return RedirectToAction("Index");
        }
        
        [Authorize]
        public ActionResult Index()
        {
            return View(new IndexViewModel(_repository.GetAllStates()));
        }

        public ActionResult GenerateSql()
        {
            return Content(_repository.GenerateSql());
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Login()
        {
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Login(string password)
        {
            if(password == "DELETED")
            { 
                FormsAuthentication.SetAuthCookie("GlutenFreeNSW", true);
                return RedirectToAction("Index");
            }
            return View();
        }

        public ActionResult Logout()
        {
            FormsAuthentication.SignOut();
            return RedirectToAction("Index");
        }
    }
}
