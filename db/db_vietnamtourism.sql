-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1:3306
-- Thời gian đã tạo: Th4 01, 2022 lúc 08:41 AM
-- Phiên bản máy phục vụ: 5.7.36
-- Phiên bản PHP: 7.4.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `db_vietnamtourism`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bai_viet`
--

DROP TABLE IF EXISTS `bai_viet`;
CREATE TABLE IF NOT EXISTS `bai_viet` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tai_khoan_id` int(11) NOT NULL,
  `dia_danh_id` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `cam_nghi` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `danh_gia` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `hinh_anh` varchar(255) COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `ngay_tao` date DEFAULT NULL,
  `so_luong_view` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `so_luong_like` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `so_luong_unlike` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_tai_khoan_id` (`tai_khoan_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `bai_viet`
--

INSERT INTO `bai_viet` (`id`, `tai_khoan_id`, `dia_danh_id`, `cam_nghi`, `danh_gia`, `hinh_anh`, `ngay_tao`, `so_luong_view`, `so_luong_like`, `so_luong_unlike`) VALUES
(1, 2, '1', 'Noi phat com Cho !!!! Khong co bo di cay lam :((', '4.0', NULL, '2019-12-12', '10', '12', '2'),
(2, 2, '3', 'Dep', '3.5', NULL, '2020-02-12', '5', '7', '1'),
(3, 22, '1', 'Di voi nguoi yeu se tuyet hon la di voi bon ban cua toi', '4', NULL, '2020-03-21', '8', '7', '1'),
(4, 23, '1', 'Da tung toi day va rat hai long', '4.5', NULL, '2021-11-29', '10', '4', '1'),
(5, 23, '3', 'Da o day rat dep', '3', NULL, '2019-04-20', '9', '6', '1'),
(6, 2, '2', 'Mot dia danh rat dang trai nghiem it nhat 1 lan trong doi', '3.5', NULL, '2018-10-09', '12', '13', '2'),
(7, 21, '5', 'Dep,ngon', '3', NULL, '2022-02-13', '0', '0', '0'),
(8, 2, '10', 'dep lam nha', '4.0', NULL, '2022-02-14', '15', '9', '5'),
(9, 24, '1', 'CHIA SE MOI\n', '1.0', NULL, '2022-02-14', '5', '1', '0'),
(10, 24, '3', 'Thac dep qua', '4.0', NULL, '2022-02-15', '4', '2', '0'),
(11, 25, '4', 'CHia se', '4.5', NULL, '2022-02-15', '2', '0', '0'),
(12, 21, '2', 'Ham o day dep qua\nHam hoi toi ti !!!!!', '4.0', NULL, '2022-02-16', '2', '0', '0'),
(13, 26, '11', 'So qua roi ', '1.0', NULL, '2022-02-20', '3', '1', '0'),
(14, 27, '1', 'Xau qua ', '5.0', NULL, '2022-02-21', '1', '0', '1');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `dia_danh`
--

DROP TABLE IF EXISTS `dia_danh`;
CREATE TABLE IF NOT EXISTS `dia_danh` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ten_dia_danh` varchar(255) COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `sao_danh_gia` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `mo_ta` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `kinh_do` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `vi_do` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `hinh_anh` varchar(255) COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `loai_dia_danh_id` int(11) NOT NULL,
  `vung_id` int(11) NOT NULL,
  `mien_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_dia_danh ` (`loai_dia_danh_id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `dia_danh`
--

INSERT INTO `dia_danh` (`id`, `ten_dia_danh`, `sao_danh_gia`, `mo_ta`, `kinh_do`, `vi_do`, `hinh_anh`, `loai_dia_danh_id`, `vung_id`, `mien_id`) VALUES
(1, 'Valley of Love', '5', 'Ban muon to tinh? Hay den day', '11.920071', '108.514857', '', 1, 1, 1),
(2, 'Cu chi Tunel', '4.5', 'Me cung duoi long dat', '11.949444', '108.547665', '', 3, 3, 3),
(3, 'Thac Da ', '5', 'Nhung tienng hot lieu lo lam tam hon them nhe nhang', '11.834490', '108.522943', '', 1, 2, 2),
(4, 'Peaceful Valley', '4.5', 'Yen binh, thanh tinh, hoa hop voi thien nhien cay co, hoa la,ngam nhin nhung ngon doi cao vut', '35.083995', '138.858173', '', 1, 3, 2),
(5, 'Sakatsura Isozakki Shrine', '3', 'Ngoi chua o Nhat hoi xa', '36.382317', '140.623436', '', 3, 3, 3),
(6, 'Pee', '2', '', '36.382317', '140.623436', '', 1, 1, 3),
(7, 'Peat', '2.5', '', '36.382317', '140.623436', '', 3, 2, 2),
(8, 'Penut', '2', '', '36.382317', '140.623436', '', 3, 1, 3),
(9, 'Pemunt', '1', '', '36.382317', '140.623436', '', 3, 2, 1),
(10, 'Peiut', '3', '', '36.382317', '140.623436', '', 2, 1, 2),
(11, 'Hell Kitchen', '3.5', 'Dia nguc nha bep', '11.920071', '108.514857', NULL, 3, 2, 3);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `dia_danh_luu_tru`
--

DROP TABLE IF EXISTS `dia_danh_luu_tru`;
CREATE TABLE IF NOT EXISTS `dia_danh_luu_tru` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ten` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `sao_danh_gia` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `sdt` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `dia_danh_id` int(11) NOT NULL,
  `hinh_anh` varchar(255) COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `kinh_do` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `vi_do` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `dia_danh_luu_tru`
--

INSERT INTO `dia_danh_luu_tru` (`id`, `ten`, `sao_danh_gia`, `sdt`, `dia_danh_id`, `hinh_anh`, `kinh_do`, `vi_do`) VALUES
(1, 'Terracotta Hotel ', '3.5', '0263 3821 448', 1, NULL, '11.920071', '108.514857'),
(2, 'TTC Hotel Premium Ngoc Lan', '4.5', '0963 2544 789', 1, NULL, '11.920071', '108.514857'),
(3, 'Ana Mandara Villas Dalat Resort & Spa', '4', '0912 2458 123', 1, NULL, '11.920071', '108.514857');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `loai_dia_danh`
--

DROP TABLE IF EXISTS `loai_dia_danh`;
CREATE TABLE IF NOT EXISTS `loai_dia_danh` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ten` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `loai_dia_danh`
--

INSERT INTO `loai_dia_danh` (`id`, `ten`) VALUES
(1, 'Phuot'),
(2, 'Nghi duong'),
(3, 'Da ngoai');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `mien`
--

DROP TABLE IF EXISTS `mien`;
CREATE TABLE IF NOT EXISTS `mien` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ten_mien` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `mien`
--

INSERT INTO `mien` (`id`, `ten_mien`) VALUES
(1, 'Bac'),
(2, 'Trung'),
(3, 'Nam');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tai_khoan`
--

DROP TABLE IF EXISTS `tai_khoan`;
CREATE TABLE IF NOT EXISTS `tai_khoan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `mat_khau` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `loai_tai_khoan` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `ten_nguoi_dung` varchar(255) COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `sdt` varchar(255) COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `hinh_dai_dien` varchar(255) COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `trang_thai` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `tai_khoan`
--

INSERT INTO `tai_khoan` (`id`, `email`, `mat_khau`, `loai_tai_khoan`, `ten_nguoi_dung`, `sdt`, `hinh_dai_dien`, `trang_thai`) VALUES
(1, 'admin@gmail.com', '123456', '1', 'Admin', '1235469485', NULL, 1),
(2, 'hoang@gmail.com', '123456', '2', 'hoang', '09690954', NULL, 1),
(3, 'hellBoy@gmail.com', '123456', '2', 'Hell Boy', '097654824', NULL, 1),
(8, 'ghostRider@gmail', '123456', '2', 'Ghost Rider', '023333646', NULL, 1),
(7, 'platiumman@gmail.com', '123456', '2', 'Platium', NULL, NULL, 1),
(24, 'Thor@marvel.com', '123456', '2', 'ThorThunder', '0963689451', NULL, 1),
(26, 'goldman@marvel.com', '123456', '2', 'GoldMan', NULL, NULL, 1),
(23, 'ironman@test.com', '123456', '2', 'IronMan', '0123456789', NULL, 1),
(22, 'daredevil@gmail.com', '123456', '2', 'Dare Devil', '093967582', NULL, 1),
(21, 'spiderman@gmail.com', '123456', '2', 'SpiderMan', '097654824', NULL, 1),
(25, 'Ironman@marvel.com', '123456', '2', 'IronMan', NULL, NULL, 1),
(27, 'thaytien@gmail.com', '123456', '2', 'ThayTien', NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `trang_thai`
--

DROP TABLE IF EXISTS `trang_thai`;
CREATE TABLE IF NOT EXISTS `trang_thai` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tai_khoan_id` int(11) NOT NULL,
  `tt_email` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `tt_ten` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `tt_sdt` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_tai_khoan_id` (`tai_khoan_id`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `trang_thai`
--

INSERT INTO `trang_thai` (`id`, `tai_khoan_id`, `tt_email`, `tt_ten`, `tt_sdt`) VALUES
(1, 1, '1', '1', '2'),
(2, 2, '1', '1', '1'),
(3, 3, '2', '2', '2'),
(4, 8, '1', '1', '1'),
(5, 7, '1', '1', '1'),
(6, 9, '1', '1', '2'),
(10, 21, '2', '2', '2'),
(11, 22, '2', '1', '2'),
(12, 23, '1', '1', '2'),
(13, 24, '1', '1', '2'),
(14, 25, '1', '1', '2'),
(15, 26, '1', '1', '2'),
(16, 27, '1', '1', '2');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tuong_tac`
--

DROP TABLE IF EXISTS `tuong_tac`;
CREATE TABLE IF NOT EXISTS `tuong_tac` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tai_khoan_id` int(11) NOT NULL,
  `bai_viet_id` int(11) NOT NULL,
  `trang_thai_like` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_tai_khoan_id` (`tai_khoan_id`),
  KEY `FK_bai_viet_id` (`bai_viet_id`)
) ENGINE=MyISAM AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `tuong_tac`
--

INSERT INTO `tuong_tac` (`id`, `tai_khoan_id`, `bai_viet_id`, `trang_thai_like`) VALUES
(1, 3, 1, '2'),
(52, 24, 4, '1'),
(3, 22, 1, '1'),
(4, 23, 1, '1'),
(5, 21, 3, '1'),
(49, 2, 8, '2'),
(7, 2, 6, '1'),
(8, 2, 3, '2'),
(54, 24, 9, '1'),
(51, 24, 3, '1'),
(46, 2, 2, '1'),
(18, 23, 4, '1'),
(19, 23, 5, '1'),
(20, 7, 2, '2'),
(22, 23, 6, '2'),
(23, 23, 2, '2'),
(24, 23, 8, '2'),
(32, 7, 1, '2'),
(50, 24, 1, '1'),
(44, 2, 1, '2'),
(45, 2, 4, '1'),
(55, 24, 10, '1'),
(66, 26, 13, '1'),
(62, 2, 10, '1'),
(69, 27, 14, '2');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `vung`
--

DROP TABLE IF EXISTS `vung`;
CREATE TABLE IF NOT EXISTS `vung` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ten_vung` varchar(255) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `vung`
--

INSERT INTO `vung` (`id`, `ten_vung`) VALUES
(1, 'Bien'),
(2, 'Dong bang'),
(3, 'Nui');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
