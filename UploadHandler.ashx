<%@ WebHandler Language="C#" Class="UploadHandler" %>

using System;
using System.Web;

public class UploadHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Files.Count > 0)
        {
            HttpFileCollection files = context.Request.Files;
            for (int i = 0; i < files.Count; i++)
            {
                HttpPostedFile file = files[i];
                string fname;
                if (HttpContext.Current.Request.Browser.Browser.ToUpper() == "IE" || HttpContext.Current.Request.Browser.Browser.ToUpper() == "INTERNETEXPLORER")
                {
                    string[] testfiles = file.FileName.Split(new char[] { '\\' });
                    fname = testfiles[testfiles.Length - 1];
                }
                else
                {
                    fname = file.FileName;
                }
                string gid = DateTime.Now.ToString("yyyyMMddHHmm");
                string URL = "~/Uploads/" + fname;
                fname = System.IO.Path.Combine(context.Server.MapPath(URL));
                file.SaveAs(fname);
                context.Response.ContentType = "text/plain";
                context.Response.Write("File Uploadetfugyihuojd Successfully!");
            }

        }
        else
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("nakkuuuuuuuuu Successfully!");
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