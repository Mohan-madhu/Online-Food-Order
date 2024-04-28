<%@ WebHandler Language="C#" Class="Handler" %>
using System.Data;
using System.IO;
using System.Web;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.Collections;
using System.Data.SqlClient;
using Newtonsoft.Json;


public class Handler : IHttpHandler
{
    public static string dbstring = "server =61.12.70.125\\DEV,1433;  database = MOHAN; UID = sa; password = GATEWAY_12345";
    string response = "";
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";


        if (context.Request.HttpMethod == "POST")
        {
            string json;
            using (var reader = new StreamReader(context.Request.InputStream))
            {
                json = reader.ReadToEnd();
            }
            dynamic mapData = Newtonsoft.Json.JsonConvert.DeserializeObject(json);
            Dictionary<string, object> myDictionary = new Dictionary<string, object>();

            foreach (var item in mapData)
            {
                string key = ((JProperty)item).Name;
                object value = ((JProperty)item).Value;
                myDictionary.Add(key, value);
            }

            if (myDictionary.ContainsKey("FOR"))
            {
                if (myDictionary["FOR"].ToString() == "uploadsms")
                {
                    string Data = myDictionary["DATA"].ToString();
                    dynamic data = JsonConvert.DeserializeObject(Data);
                    SqlConnection sqlConnection = new SqlConnection(dbstring);
                    sqlConnection.Open();
                    SqlParameter msgout = new SqlParameter("@msg", SqlDbType.VarChar, -1);
                    foreach (var msg in data)
                    {
                        string number = msg["number"]?.ToString();
                        string message = msg["message"]?.ToString();
                        string amt = (msg["amt"] != null) ? msg["amt"].ToString() : "111";
                        string querry = "sp_ins_message";
                        SqlCommand sqlCommand = new SqlCommand(querry, sqlConnection);
                        sqlCommand.CommandType = CommandType.StoredProcedure;
                        sqlCommand.Parameters.AddWithValue("@number", number);
                        sqlCommand.Parameters.AddWithValue("@amt", amt);
                        sqlCommand.Parameters.AddWithValue("@message", message);
                        msgout.Direction = ParameterDirection.Output;
                        sqlCommand.Parameters.Add(msgout);
                        sqlCommand.ExecuteNonQuery();
                    }
                    sqlConnection.Close();
                    context.Response.Write(msgout.SqlValue);
                }

                else if (myDictionary["FOR"].ToString() == "confirmorder")
                {
                    SqlConnection sqlConnection = new SqlConnection(dbstring);
                    sqlConnection.Open();
                    string querry = "sp_confirm_order";
                    SqlCommand sqlCommand = new SqlCommand(querry, sqlConnection);
                    sqlCommand.CommandType = CommandType.StoredProcedure;
                    sqlCommand.Parameters.AddWithValue("@deviceid", myDictionary["deviceid"].ToString());
                    sqlCommand.Parameters.AddWithValue("@orderid", myDictionary["orderid"].ToString());
                    sqlCommand.Parameters.AddWithValue("@deliveredby", myDictionary["deliveredby"].ToString());
                    SqlParameter msg = new SqlParameter("@msg", SqlDbType.VarChar, -1);
                    msg.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(msg);
                    SqlDataAdapter adapter = new SqlDataAdapter(sqlCommand);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    sqlConnection.Close();
                    if (dt.Rows.Count > 0)
                    {
                        string data = JsonConvert.SerializeObject(dt);
                        context.Response.Write(data);
                    }
                    else
                    {
                        context.Response.Write(msg.SqlValue);
                    }
                }

                else if (myDictionary["FOR"].ToString() == "registeradmindevice")
                {
                    SqlConnection sqlConnection = new SqlConnection(dbstring);
                    sqlConnection.Open();
                    string querry = "sp_ins_tbl_admindevices";
                    SqlCommand sqlCommand = new SqlCommand(querry, sqlConnection);
                    sqlCommand.CommandType = CommandType.StoredProcedure;
                    sqlCommand.Parameters.AddWithValue("@deviceid", myDictionary["deviceid"].ToString());
                    sqlCommand.Parameters.AddWithValue("@devicename", myDictionary["devicename"].ToString());
                    sqlCommand.Parameters.AddWithValue("@username", myDictionary["username"].ToString());
                    SqlParameter msg = new SqlParameter("@msg", SqlDbType.VarChar, -1);
                    msg.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(msg);
                    sqlCommand.ExecuteNonQuery();
                    sqlConnection.Close();
                    context.Response.Write(msg.SqlValue);
                }
            }
        }
        else
        {

            context.Response.Write("Hello World");
            // Handle unsupported HTTP methods (e.g., GET)
            context.Response.StatusCode = 405; // Method Not Allowed
            context.Response.End();
        }


    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }


}