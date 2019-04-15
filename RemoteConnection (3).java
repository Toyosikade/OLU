package pass.com.pass;

//sis.c4qasmekrjaw.us-east-2.rds.amazonaws.com

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
//import java.sql.DriverManager;
//import java.sql.ResultSet;
//import java.sql.Statement;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.Toast;

public class RemoteConnection extends AsyncTask<Void, Void, List<Map<String, Object>>>  {
    private Context ctx;
    private String sqlStatement;
    String  driver = "com.mysql.jdbc.Driver";
    String  dbname = "DEV_SIS_ADMIN";
    String  username = "DEV_SIS_ADMIN";
    String  password = "DEV_SIS_ADMIN99";
    String  serverip = "jdbc:mysql://sis.c4qasmekrjaw.us-east-2.rds.amazonaws.com:3600/"+dbname;
    private Connection con;


    public RemoteConnection(Context ctx, String sql)
    {
        this.ctx=ctx;
        this.sqlStatement = sql;
    }

    @Override
    protected List<Map<String, Object>> doInBackground(Void... params) {
        List<Map<String, Object>> res = null;

        try{
            /*Class.forName();
            String jdbcUrl = "jdbc:mysql://"+serverip+"/"+dbname;
            con = DriverManager.getConnection(jdbcUrl,username,password);*/
            con = startConnection(driver,serverip,username,password);
            res = selectQuery(con, sqlStatement, Collections.EMPTY_LIST);
        } catch (Exception e) {
            rollbackConnection(con);
            Log.e("SQLite Parser", "Error parsing data " + e.toString());
        } catch (NoClassDefFoundError e){
            rollbackConnection(con);
            Log.e("Exception", "Error parsing data " + e.toString());
        }
        endConnection(con);
        return res;
    }

    @Override
    protected void onPostExecute(List<Map<String, Object>> result) {
        super.onPostExecute(result);

        if(result == null){
            Toast.makeText(ctx, "Failed to connect to Database",Toast.LENGTH_LONG).show();
        }
        else{
            Toast.makeText(ctx, "Connected", Toast.LENGTH_LONG).show();
        }
    }
public static Connection startConnection(String driver, String jdbcUrl, String username, String password) throws ClassNotFoundException, SQLException
{
    Class.forName(driver);

    if ((username == null) || (password == null) || (username.trim().length() == 0) || (password.trim().length() == 0))
    {
        return DriverManager.getConnection(jdbcUrl);
    }
    else
    {
        return DriverManager.getConnection(jdbcUrl, username, password);
    }
}



    public static void endConnection(Connection connection)
    {
        try
        {
            if (connection != null)
            {
                connection.close();
            }
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
    }


    public static void closeStatement(Statement st)
    {
        try
        {
            if (st != null)
            {
                st.close();
            }
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
    }

    public static void closeResultSet(ResultSet rs)
    {
        try
        {
            if (rs != null)
            {
                rs.close();
            }
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
    }

    public static void rollbackConnection(Connection connection)
    {
        try
        {
            if (connection != null)
            {
                connection.rollback();
            }
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
    }

    public static List<Map<String, Object>> getResultSet(ResultSet rs) throws SQLException
    {
        List<Map<String, Object>> results = new ArrayList<Map<String, Object>>();
        try
        {
            if (rs != null)
            {
                ResultSetMetaData meta = rs.getMetaData();
                int numColumns = meta.getColumnCount();
                while (rs.next())
                {
                    Map<String, Object> row = new HashMap<String, Object>();
                    for (int i = 1; i <= numColumns; ++i)
                    {
                        String name = meta.getColumnName(i);
                        Object value = rs.getObject(i);
                        row.put(name, value);
                    }
                    results.add(row);
                }
            }
        }
        finally
        {
            closeResultSet(rs);
        }
        return results;
    }

    public static List<Map<String, Object>> selectQuery(Connection connection, String sql, List<Object> parameters) throws SQLException
    {
        List<Map<String, Object>> results = null;
        PreparedStatement sts = null;
        ResultSet rs = null;
        try
        {
            sts = connection.prepareStatement(sql);
            int i = 0;
            for (Object parameter : parameters)
                sts.setObject(++i, parameter);

            rs = sts.executeQuery();
            results = getResultSet(rs);
        }
        finally
        {
            closeResultSet(rs);
            closeStatement(sts);
        }
        return results;
    }

    public static int updateQuery(Connection connection, String sql, List<Object> parameters) throws SQLException
    {
        int numRowsUpdated = 0;
        PreparedStatement ps = null;
        try
        {
            ps = connection.prepareStatement(sql);
            int i = 0;
            for (Object parameter : parameters)
                ps.setObject(++i, parameter);

            numRowsUpdated = ps.executeUpdate();
        }
        finally
        {
            closeStatement(ps);
        }

        return numRowsUpdated;
    }
}

