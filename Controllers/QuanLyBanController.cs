using QL_NhaHang_ADO.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QL_NhaHang_ADO.Controllers
{
    public class QuanLyBanController : Controller
    {
        // GET: QuanLyBan
        public ActionResult ShowBan()
        {
            ConnectBan ban = new ConnectBan();
            List<Ban> banList = ban.GetBans();
            return View(banList);
        }

        public ActionResult ShowBanTrong()
        {
            ConnectBan ban = new ConnectBan();
            List<Ban> banList = ban.LoadBanTrong();
            return View(banList);
        }
        public ActionResult ChangeTrangThai(string maBan, string newTrangThai)
        {
            ConnectBan connectBan = new ConnectBan();
            bool isUpdated = connectBan.UpdateTrangThai(maBan, newTrangThai);

            if (isUpdated)
            {
                TempData["SuccessMessage"] = "Cập nhật trạng thái bàn thành công!";
            }
            else
            {
                TempData["ErrorMessage"] = "Cập nhật trạng thái bàn thất bại!";
            }

            return RedirectToAction("ShowBan");
        }
        public ActionResult ChangeTrangThaiTrong(string maBan, string newTrangThai)
        {
            ConnectBan connectBan = new ConnectBan();
            bool isUpdated = connectBan.UpdateTrangThai(maBan, newTrangThai);

            if (isUpdated)
            {
                TempData["SuccessMessage"] = "Cập nhật trạng thái bàn thành công!";
            }
            else
            {
                TempData["ErrorMessage"] = "Cập nhật trạng thái bàn thất bại!";
            }

            return RedirectToAction("ShowBanTrong");
        }
    }
}