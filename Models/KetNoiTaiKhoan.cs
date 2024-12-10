using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Net.Mail;
using System.Web;
using System.Data.SqlClient;

namespace QL_NhaHang_ADO.Models
{
    public class KetNoiTaiKhoan
    {
        //==========================================================================================================================================
        //Đăng Ký Tài Khoản
        //==========================================================================================================================================
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["connect1"].ConnectionString;
        public bool DangKy(TaiKhoan taiKhoan)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Tạo token xác thực
                string token = Guid.NewGuid().ToString();

                // Truy vấn SQL để thêm tài khoản với token xác thực
                string query = @"
INSERT INTO TaiKhoan (MaTaiKhoan, MaQuyen, TenDangNhap, MatKhau, Email, IsEmailConfirmed, EmailConfirmationToken) 
VALUES (@MaTaiKhoan, @MaQuyen, @TenDangNhap, @MatKhau, @Email, 0, @EmailConfirmationToken)";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.Add(new SqlParameter("@MaTaiKhoan", GenerateMaTaiKhoan()));
                cmd.Parameters.Add(new SqlParameter("@MaQuyen", "Q001"));
                cmd.Parameters.Add(new SqlParameter("@TenDangNhap", taiKhoan.TenDangNhap));
                cmd.Parameters.Add(new SqlParameter("@MatKhau", taiKhoan.MatKhau));
                cmd.Parameters.Add(new SqlParameter("@Email", taiKhoan.Email));
                cmd.Parameters.Add(new SqlParameter("@EmailConfirmationToken", token));

                conn.Open();
                int result = cmd.ExecuteNonQuery();
                conn.Close();

                if (result > 0)
                {
                    // Gửi email xác nhận
                    string confirmationLink = $"https://localhost:44344//Account/ConfirmEmail?email={taiKhoan.Email}&token={token}";
                    SendConfirmationEmail(taiKhoan.Email, confirmationLink);
                }

                return result > 0;
            }
        }

        //==========================================================================================================================================
        //Gửi mail
        //==========================================================================================================================================
        private void SendConfirmationEmail(string email, string link)
        {
            var smtpClient = new SmtpClient();
            var mailMessage = new MailMessage("khangtuong040@gmail.com", email)
            {
                Subject = "Xác thực email",
                Body = $@"
            <html>
            <body style='text-align: center; font-family: Arial, sans-serif;'>
                <div style='margin: 20px;'>
                    <img src='https://drive.google.com/file/d/1NxbDE8_V-kopOSr2VUuM3PXF8_KMRVX2/view?usp=sharing' alt='Logo' style='width: 100px; height: auto;'/>
                    <h2 style='color: red;'>Chay Tuệ</h2>
                    <p>Vui lòng nhấn vào liên kết sau để xác thực tài khoản của bạn:</p>
                    <a href='{link}' style='color: blue;'>{link}</a>
                </div>
            </body>
            </html>",
                IsBodyHtml = true
            };

            smtpClient.Send(mailMessage);
        }

        //==========================================================================================================================================
        //Gửi mã OTP
        //==========================================================================================================================================
        public void SendOtpEmail(string email, string otp)
        {

            MailMessage mail = new MailMessage();
            mail.To.Add(email);
            mail.From = new MailAddress("khangtuong040@gmail.com");
            mail.Subject = "Mã OTP để tạo lại mật khẩu";
            mail.Body = $"Mã OTP của bạn là: {otp}";
            mail.IsBodyHtml = true;

            SmtpClient smtp = new SmtpClient();
            smtp.Host = "smtp.gmail.com";
            smtp.Port = 587;
            smtp.UseDefaultCredentials = false;
            smtp.Credentials = new System.Net.NetworkCredential("chaytue0203@gmail.com", "kctw ltds teaj luvb");
            smtp.EnableSsl = true;

            smtp.Send(mail);
        }
        //==========================================================================================================================================
        //Tạo Mã Tài Khoản Tự Động
        //==========================================================================================================================================
        public int GetNextNumberFromDatabase()
        {
            int nextNumber = 1; // Giá trị mặc định nếu không có dữ liệu trong bảng
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["connect1"].ConnectionString; // Chuỗi kết nối tới Oracle

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Truy vấn số thứ tự lớn nhất hiện có
                string query = "SELECT MAX(CAST(SUBSTRING(MaTaiKhoan, 3, LEN(MaTaiKhoan) - 2) AS INT)) AS MaxValue FROM TaiKhoan;";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    var result = cmd.ExecuteScalar();

                    if (result != DBNull.Value && result != null)
                    {
                        nextNumber = Convert.ToInt32(result) + 1; // Số tiếp theo
                    }
                }
            }

            return nextNumber;
        }
        public string GenerateMaTaiKhoan()
        {
            string prefix = "TK";
            int nextNumber = GetNextNumberFromDatabase(); // Hàm để lấy số tiếp theo từ CSDL
            string maTaiKhoan = prefix + nextNumber.ToString("D4"); // Format thành 'TK0001'

            return maTaiKhoan;
        }
        //==========================================================================================================================================
        //Đăng Nhập Tài Khoản
        //==========================================================================================================================================
        public List<TaiKhoan> DangNhap()
        {
            List<TaiKhoan> listProduct = new List<TaiKhoan>();
            SqlConnection con = new SqlConnection(connectionString);

            // Truy vấn SQL để lấy và giải mã TenDangNhap bằng hàm decryptCaesarCipher
            string sql = @"
                         SELECT 
                            MaTaiKhoan, 
                            MaQuyen, 
                            TenDangNhap, 
                            MatKhau, 
                            Email,
                            IsEmailConfirmed,
                            EmailConfirmationToken
                         FROM TaiKhoan";

            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.CommandType = CommandType.Text;

            con.Open();

            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                TaiKhoan tk = new TaiKhoan();

                // Lấy kết quả giải mã từ cột TenDangNhapDecrypted
                tk.MaTaiKhoan = rdr.GetValue(0).ToString();

                tk.MaQuyen = rdr.GetValue(1).ToString();

                tk.TenDangNhap = rdr.GetValue(2).ToString();

                // Giải mã mật khẩu trong C#
                tk.MatKhau = rdr.GetValue(3).ToString();

                tk.IsEmailConfirmed = Convert.ToInt32(rdr.GetValue(5).ToString());

                tk.Email = rdr.GetValue(4).ToString();

                listProduct.Add(tk);
            }
            con.Close();
            return listProduct;
        }
    }
}