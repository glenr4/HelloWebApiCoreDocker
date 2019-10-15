using Microsoft.AspNetCore.Mvc;

namespace HelloWebApiCoreDocker.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HelloController : ControllerBase
    {
        [HttpGet]
        public ActionResult<string> Get()
        {
            return "Hello Again!";
        }
    }
}