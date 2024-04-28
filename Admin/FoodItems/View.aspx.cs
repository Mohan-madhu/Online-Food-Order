using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Common.CommandTrees.ExpressionBuilder;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using Newtonsoft.Json;
using System.Web.Services;
using Microsoft.Ajax.Utilities;
using Microsoft.Owin;

public partial class AddFoodItem : System.Web.UI.Page
{
    string connectionstring = Database.dbstring;
    protected void Page_Load(object sender, EventArgs e)
    {

      
    }
    [WebMethod]
    public static string getfooditems()
    {
        SqlConnection connection = new SqlConnection(Database.dbstring);
        connection.Open();
        SqlCommand command = new SqlCommand("select  * from FoodItems", connection);
        SqlDataAdapter ad = new SqlDataAdapter(command);
        DataTable dt = new DataTable();
        ad.Fill(dt);
        connection.Close();
        string data = JsonConvert.SerializeObject(dt);

        return data;
    }

}