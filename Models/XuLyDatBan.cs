using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace QL_NhaHang_ADO.Models
{
    public class XuLyDatBan
    {
        private static string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["connect1"].ConnectionString;
        public List<PhieuDatBan> LayThongTinPhieuDatBan()
        {
            List<PhieuDatBan> listProduct = new List<PhieuDatBan>();
            SqlConnection con = new SqlConnection(connectionString);
            // Truy vấn SQL để lấy và giải mã TenDangNhap bằng hàm decryptCaesarCipher
            string sql = @"
                        SELECT 
                    MAPHIEU,                         
                    MAKH,
                    NGAYDAT,
                    TENKH,
                    SOLUONG,
                    EMAIL,
                    SDT,
                    GIODAT
                FROM PhieuDatBan
                WHERE CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE)";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.CommandType = CommandType.Text;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                PhieuDatBan Ma = new PhieuDatBan();                    
                Ma.MaPhieu = rdr.GetValue(0).ToString();
                Ma.MaKH = rdr.GetValue(1).ToString();
                Ma.NgayDat = Convert.ToDateTime(rdr.GetValue(2)).ToString("yyyy -MM-dd");
                Ma.TenKH = rdr.GetValue(3).ToString();
                Ma.SoLuong = int.Parse(rdr.GetValue(4).ToString());
                Ma.Email = rdr.GetValue(5).ToString();
                Ma.SDT = rdr.GetValue(6).ToString();
                Ma.GIODAT = rdr.GetValue(7).ToString();
                listProduct.Add(Ma);
            }
            con.Close();
            return listProduct;
        }

    }
}