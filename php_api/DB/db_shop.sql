-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 22, 2026 at 12:20 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_shop`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`) VALUES
(1, 'เครื่องใช้ไฟฟ้า'),
(2, 'เสื้อผ้า'),
(3, 'รองเท้า');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customer_id` int(8) UNSIGNED ZEROFILL NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `firstName`, `lastName`, `phone`, `username`, `password`) VALUES
(00000001, 'สมชาย', 'ใจดี', '0812345678', 'somchai', '$2y$10$syREWVkx5mq1GdC3Zu6IcOjs1krhF0NjgzdnBv5C/Bjd2Z1.vsUoi'),
(00000002, 'วิภา', 'สุขสันต์', '0898765432', 'wipa', '$2y$10$syREWVkx5mq1GdC3Zu6IcOjs1krhF0NjgzdnBv5C/Bjd2Z1.vsUoi'),
(00000003, 'John', 'Doe', '0991122334', 'johnd', '$2y$10$syREWVkx5mq1GdC3Zu6IcOjs1krhF0NjgzdnBv5C/Bjd2Z1.vsUoi'),
(00000004, 'pongpat', 'Winter', '0644012944', 'SXN', '$2y$10$syREWVkx5mq1GdC3Zu6IcOjs1krhF0NjgzdnBv5C/Bjd2Z1.vsUoi'),
(00000005, 'pp', 'ss', '0644012945', 'sXnn', '$2y$10$syREWVkx5mq1GdC3Zu6IcOjs1krhF0NjgzdnBv5C/Bjd2Z1.vsUoi'),
(00000007, 'pp', 'ss', '0644012365', 'sun', '$2y$10$YS0R29cV0B7WVxx1XzNpVuatKP3HaFJp.C9XI25GuEsMtkuqrYcsa');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `emp_id` int(10) UNSIGNED ZEROFILL NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `department` varchar(50) NOT NULL,
  `salary` decimal(10,2) NOT NULL,
  `active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `image` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`emp_id`, `full_name`, `department`, `salary`, `active`, `created_at`, `image`) VALUES
(0000000001, 'สมชาย ใจดี', 'IT', '35000.00', 1, '2026-01-18 10:28:08', '1771147097_1771146656_male.png'),
(0000000002, 'สมหญิง ดีงาม', 'บัญชี', '28000.00', 1, '2026-01-18 10:28:08', '1771147091_1771146646_female.png'),
(0000000003, 'อนันต์ สุขใจ', 'การตลาด', '25000.00', 0, '2026-01-18 10:28:08', '1771146861_1771146656_male.png'),
(0000000004, 'สุดา พรมดี', 'ทรัพยากรบุคคล', '32000.00', 1, '2026-01-18 10:28:08', '1771146851_1771146820_female.png'),
(0000000006, 'SXN', 'IT', '150000.00', 1, '2026-02-01 08:48:59', '1771146820_female.png'),
(0000000007, 'Pongpat kunharat', 'CEO', '200000.00', 1, '2026-02-01 09:02:13', '1771146656_male.png');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) UNSIGNED ZEROFILL NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `image` text DEFAULT NULL,
  `stock` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `description`, `price`, `image`, `stock`, `category_id`, `created_at`) VALUES
(00000000001, 'เสื้อยืดคอกลม', 'เสื้อยืดผ้าฝ้าย 100% สวมใส่สบาย', '199.00', '1771145727_P1.jpg', 50, 1, '2026-01-25 10:46:59'),
(00000000002, 'กางเกงยีนส์', 'กางเกงยีนส์ทรงกระบอก สีฟ้าอ่อน', '799.00', '1771145717_P2.jpg', 30, 2, '2026-01-25 10:46:59'),
(00000000003, 'รองเท้าผ้าใบ', 'รองเท้าผ้าใบสีขาว ใส่ได้ทุกโอกาส', '1299.00', '1771145736_P3.jpg', 200, 3, '2026-01-25 10:46:59'),
(00000000004, 'เสื้อยืดฟ้า', 'สวย', '200.00', '1771748537_1771145727_P1.jpg', 5, 2, '2026-02-22 08:22:17');

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `student_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`student_id`, `first_name`, `last_name`, `phone`, `email`) VALUES
(1, 'John', 'Doe', '0812345678', 'john.doe@example.com'),
(2, 'Jane', 'Smith', '0819876543', 'jane.smith@example.com'),
(3, 'Michael', 'Brown', '0823456789', 'michael.brown@example.com'),
(4, 'Emily', 'Johnson', '0834567890', 'emily.johnson@example.com'),
(5, 'Chris', 'Williams', '0845678901', 'chris.williams@example.com'),
(6, 'Pongpat', 'Kunharat', '0644012942', 'pongpat@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `type`
--

CREATE TABLE `type` (
  `type_id` int(11) NOT NULL COMMENT 'รหัสสินค้า',
  `type_name` varchar(30) NOT NULL COMMENT 'ชื่อประเภท'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `type`
--

INSERT INTO `type` (`type_id`, `type_name`) VALUES
(1, 'เครื่องใช้ไฟฟ้า'),
(2, 'เครื่องเขียน');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`emp_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`student_id`);

--
-- Indexes for table `type`
--
ALTER TABLE `type`
  ADD PRIMARY KEY (`type_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int(8) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `emp_id` int(10) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `student`
--
ALTER TABLE `student`
  MODIFY `student_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `type`
--
ALTER TABLE `type`
  MODIFY `type_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'รหัสสินค้า', AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
