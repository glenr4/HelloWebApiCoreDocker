using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;

namespace HelloWebApiCoreDocker
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateWebHostBuilder(args).Build().Run();
        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                // Need to add a certificate to use HTTPS
                // .UseUrls("http://*:5000", "https://*:5001") // Must specify here for use inside Containers
                .UseUrls("http://*:5000")
                .UseStartup<Startup>();
    }
}
