using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Providers.Entities;
using System.Activities.Expressions;
using System.Xml.Linq;
using Microsoft.Ajax.Utilities;
using Newtonsoft.Json.Linq;

public partial class Customer_Order : System.Web.UI.Page
{

    string connectionstring = Database.dbstring;
    protected void Page_Load(object sender, EventArgs e)
    {

    }


    public static void messagebox(Page webPageInstance, string message)
    {
        webPageInstance.ClientScript.RegisterStartupScript(webPageInstance.GetType(), "Pop", "<script language=JavaScript>  alert('" + message + "') </script> ");
    }

    [WebMethod]
    public static string getfooditems()
    {
        SqlConnection connection = new SqlConnection(Database.dbstring);
        connection.Open();
        SqlCommand command = new SqlCommand("select  *, 0 as quantity from FoodItems", connection);
        SqlDataAdapter ad = new SqlDataAdapter(command);
        DataTable dt = new DataTable();
        ad.Fill(dt);
        connection.Close();
        string data = JsonConvert.SerializeObject(dt);
        return data;
    }

    [WebMethod]
    public static string checktransaction(string utrno)
    {

        string orderid = "";
        if (utrno != "")
        {
            SqlConnection connection = new SqlConnection(Database.dbstring);
            connection.Open();
            SqlCommand command = new SqlCommand("sp_checktransaction", connection);
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue("@utr", utrno);
            SqlParameter msgout = new SqlParameter("@sts", SqlDbType.VarChar, -1);
            msgout.Direction = ParameterDirection.Output;
            command.Parameters.Add(msgout);
            command.ExecuteNonQuery();
            connection.Close();
            orderid = msgout.SqlValue.ToString();
        }
        return orderid;
    }

    [WebMethod]
    public static string ins_order(string paymentid, string userid, string name, string cost, string ordertype, string orderdata)
    {
        string message = "";
        SqlConnection sqlConnection = new SqlConnection(Database.dbstring);
        sqlConnection.Open();
        string querry = "sp_ins_tbl_orderlist";
        SqlCommand sqlCommand = new SqlCommand(querry, sqlConnection);
        sqlCommand.CommandType = CommandType.StoredProcedure;
        sqlCommand.Parameters.AddWithValue("@paymentid", paymentid);
        sqlCommand.Parameters.AddWithValue("@userid", userid);
        sqlCommand.Parameters.AddWithValue("@name", name);
        sqlCommand.Parameters.AddWithValue("@cost", cost);
        sqlCommand.Parameters.AddWithValue("@ordertype", ordertype );
        SqlParameter msg = new SqlParameter("@msg", SqlDbType.VarChar, -1);
        msg.Direction = ParameterDirection.Output;
        sqlCommand.Parameters.Add(msg);
        sqlCommand.ExecuteNonQuery();

        string orderliststs = msg.SqlValue.ToString();
        message = orderliststs;
        if (orderliststs.Contains("already"))
        {          
            return message;
        }
        else
        {
            dynamic mapData = Newtonsoft.Json.JsonConvert.DeserializeObject(orderdata);
            Dictionary<string, object> myDictionary = new Dictionary<string, object>();
            querry = "sp_ins_tbl_orderdetails";
            foreach (var item in mapData)
            {
                sqlCommand = new SqlCommand(querry, sqlConnection);
                sqlCommand.CommandType = CommandType.StoredProcedure;
                sqlCommand.Parameters.AddWithValue("@orderid", orderliststs);
                sqlCommand.Parameters.AddWithValue("@foodid", item.transid.ToString());
                sqlCommand.Parameters.AddWithValue("@foodname", item.foodname.ToString());
                sqlCommand.Parameters.AddWithValue("@foodcost", item.cost.ToString());
                sqlCommand.Parameters.AddWithValue("@foodtype", item.foodtype.ToString());
                sqlCommand.Parameters.AddWithValue("@quantity", item.quantity.ToString());
                sqlCommand.Parameters.AddWithValue("@total", (  Convert.ToDecimal(item.quantity.ToString()) * Convert.ToDecimal(item.cost.ToString())).ToString());
                msg = new SqlParameter("@msg", SqlDbType.VarChar, -1);
                msg.Direction = ParameterDirection.Output;
                sqlCommand.Parameters.Add(msg);
                sqlCommand.ExecuteNonQuery();
            }
        }
        sqlConnection.Close();
        return message;
    }
}