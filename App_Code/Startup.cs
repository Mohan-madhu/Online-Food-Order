using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Online_Food_Order_System.Startup))]
namespace Online_Food_Order_System
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
