using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Database
/// </summary>
public static class Database
{
    public static string dbstring = ConfigurationManager.ConnectionStrings["OFOS"].ConnectionString;
}