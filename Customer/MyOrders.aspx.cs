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

public partial class Customer_MyOrders : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string getorderlist()
    {
        SqlConnection connection = new SqlConnection(Database.dbstring);
        connection.Open();
        SqlCommand command = new SqlCommand("select  * from tbl_orderlist", connection);
        SqlDataAdapter ad = new SqlDataAdapter(command);
        DataTable dt = new DataTable();
        ad.Fill(dt);
        connection.Close();
        string data = JsonConvert.SerializeObject(dt);
        return data;
    }
    [WebMethod]
    public static string getorderdetails(string orderid)
    {
        SqlConnection connection = new SqlConnection(Database.dbstring);
        connection.Open();
        SqlCommand command = new SqlCommand("select b.*,paymentid,userid,name,cost,ordertype from tbl_orderlist a inner join tbl_orderdetails b on a.transid = b.orderid where b.orderid='" + orderid + "'", connection);
        SqlDataAdapter ad = new SqlDataAdapter(command);
        DataTable dt = new DataTable();
        ad.Fill(dt);
        connection.Close();
        string data = JsonConvert.SerializeObject(dt);
        return data;
    }
    [WebMethod]
    public static string checkdelivered(string orderid)
    {
        SqlConnection connection = new SqlConnection(Database.dbstring);
        connection.Open();
        SqlCommand command = new SqlCommand("select ordersts from tbl_orderlist where transid = '" + orderid + "' and ordersts=1", connection);
        SqlDataAdapter ad = new SqlDataAdapter(command);
        DataTable dt = new DataTable();
        ad.Fill(dt);
        connection.Close();
        if (dt.Rows.Count > 0)
        {
            return "1";
        }
        else
        {
            return "0";
        }
    }

}