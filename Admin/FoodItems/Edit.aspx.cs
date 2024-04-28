using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using System.Web.Services;

public partial class Admin_FoodItems_Edit : System.Web.UI.Page
{
    string connectionstring = Database.dbstring;
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void submitBtn_Click(object sender, EventArgs e)
    {
        string filePath = "";
        if (foodImage.HasFile)
        {
            string fileName = Path.GetFileName(foodImage.FileName);
            filePath = Server.MapPath("~/Uploads/FoodItems/" + fileName);
            foodImage.SaveAs(filePath);
            filePath = "~/Uploads/FoodItems/" + fileName;
        }

        SqlConnection connection = new SqlConnection(connectionstring);
        connection.Open();
        SqlCommand command = new SqlCommand("sp_InsertFood", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@transid", txttransid.Text);
        command.Parameters.AddWithValue("@foodname", foodName.Text);
        command.Parameters.AddWithValue("@description", description.Text);
        command.Parameters.AddWithValue("@cost", cost.Text);
        command.Parameters.AddWithValue("@imageurl", filePath);
        command.Parameters.AddWithValue("@foodtype", "MEAL");
        command.Parameters.AddWithValue("@available", available.Text);


        command.Parameters.Add("@msg", SqlDbType.NVarChar, 1000).Direction = ParameterDirection.Output;

        command.ExecuteNonQuery();
        connection.Close();
        string msg = command.Parameters["@msg"].Value.ToString();
        if (msg.Contains("Success"))
        {
            ClearFields();
        }
        ClearFields();
        messagebox(this, msg);

    }



    public static void messagebox(Page webPageInstance, string message)
    {
        webPageInstance.ClientScript.RegisterStartupScript(webPageInstance.GetType(), "Pop", "<script language=JavaScript>  alert('" + message + "') </script> ");
    }



    protected void ClearFields()
    {
        ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "clearform();", true);
    }
    [WebMethod]
    public static string foodlist()
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
    [WebMethod]
    public static string delfooditem(string id)
    {
        SqlConnection connection = new SqlConnection(Database.dbstring);
        connection.Open();
        SqlCommand command = new SqlCommand("delete  from FoodItems where transid='"+id+"'", connection);
        command.ExecuteNonQuery();
        connection.Close();
        return "Deleted Successfully...";
    }
}