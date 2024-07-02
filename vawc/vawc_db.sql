-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 02, 2024 at 11:19 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `vawc_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `account_account`
--

CREATE TABLE `account_account` (
  `user_id` bigint(20) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(50) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `verified` varchar(3) DEFAULT NULL,
  `type` varchar(5) NOT NULL,
  `barangay` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `passkey` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account_account`
--

INSERT INTO `account_account` (`user_id`, `first_name`, `middle_name`, `last_name`, `verified`, `type`, `barangay`, `city`, `province`, `region`, `status`, `passkey`) VALUES
(1, 'asd', 'asdasd', 'asd', 'No', 'staff', 'asd', NULL, NULL, NULL, 'Active', NULL),
(2, 'vawc', 'vawc', 'vawc', 'No', 'admin', NULL, NULL, NULL, NULL, 'Active', NULL),
(3, 'staff', 'staff', 'staff', 'No', 'staff', 'Sto. Ni±o', NULL, NULL, NULL, 'Active', NULL),
(5, 'Peter', 'Benjamin', 'Parker', 'No', 'staff', 'Sto. Ni±o', 'Zamboanga City', 'Zamboanga del Sur', 'region-IX', 'Active', NULL),
(6, 'Peter', 'Benjamin', 'Igneel', 'No', 'staff', 'Sto. Ni±o', 'Zamboanga City', 'Zamboanga del Sur', 'region-IX', 'Active', 'tEmzFtcFWoOA'),
(9, 'ben', 'parker', 'reily', 'No', 'staff', 'Cawit', 'Zamboanga City', 'Zamboanga del Sur', 'region-IX', 'Not Active', NULL),
(11, 'Gene', 'Mazo', 'Braga', 'No', 'admin', NULL, NULL, NULL, NULL, NULL, NULL),
(14, 'Temp', 'Tokiyo', 'Test', 'No', 'staff', 'Tumaga', 'Zamboanga City', 'Zamboanga del Sur', 'region-IX', 'Active', 'pass123');

-- --------------------------------------------------------

--
-- Table structure for table `account_customuser`
--

CREATE TABLE `account_customuser` (
  `id` bigint(20) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `email` varchar(254) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account_customuser`
--

INSERT INTO `account_customuser` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `is_staff`, `is_active`, `date_joined`, `email`) VALUES
(1, 'pbkdf2_sha256$720000$aWLRSxZQPyDOniWvfTyVZq$oyTs0U7ILEehpMxHZofSDa0FF+voJfaKgfQyQ01KpAA=', '2024-04-07 20:21:50.290000', 1, 'admin', '', '', 1, 1, '2024-03-12 18:52:25.000000', 'admin@gmail.com'),
(2, 'pbkdf2_sha256$720000$WlWdDQ49dUrpBEFTv828Xk$BnIJR8px1TG+CrAv8ScnQWgXE+Py5hoErtLukuozhec=', '2024-04-07 20:24:05.357000', 0, 'vawcbarangay', '', '', 0, 1, '2024-03-12 18:53:16.000000', 'vawcdilg@gmail.com'),
(3, 'pbkdf2_sha256$720000$RrCRf5ODYWMAoJEbADPYni$yLM2abDrFNErA5trG25OFYbzPLOf0EF1zdPeHk6Ypmk=', '2024-03-25 05:46:47.944000', 0, 'staff', '', '', 0, 1, '2024-03-12 18:53:45.000000', 'staff@gmail.com'),
(5, 'pbkdf2_sha256$720000$CMw8eVJi0cyLB03nzpZnCH$pE91Mp+WcmD1GObBCgfWKxXtCueih/azNYiXZ8MgCAs=', '2024-03-25 01:10:59.328000', 0, 'wil', '', '', 0, 1, '2024-03-24 23:36:56.000000', 'staff2@gmail.com'),
(6, 'pbkdf2_sha256$720000$XarxCP9Zu9si7QoMvsiMh0$yzO82Ef1h0YJB8Ci4e8eWWWopyfXSgKdSniczABZyhk=', '2024-04-07 20:23:45.382000', 0, 'lastudragneel', '', '', 0, 1, '2024-03-26 12:46:24.366000', 'lastudragneel@gmail.com'),
(9, 'pbkdf2_sha256$720000$0DCmwTiy4CRcr6CViQSUcY$a23I5hXS0nPii/iUCpl+UhuN3jN3fHf0R930rxvsRw4=', '2024-03-28 23:52:54.598000', 0, 'test2', '', '', 0, 1, '2024-03-28 23:36:13.278000', 'test2@gmail.com'),
(11, 'pbkdf2_sha256$720000$XmdTuqsMP5AYPYWTgGbz2k$iFiaWfp60x4DgdxcNd3QA0WXE0qYrTLjU9f6u76fLJQ=', '2024-07-01 18:04:59.390000', 1, 'genesan', '', '', 1, 1, '2024-05-31 18:19:40.000000', 'genealprincebraga@gmail.com'),
(14, 'pbkdf2_sha256$720000$Yp0VrZnrA8lG3LWfLlzIxB$4nrDkh4DNcReqXc4+ibUoUYSCi1waJpXqVbvzNOmi/Y=', '2024-07-01 17:51:43.983000', 0, 'Temptest', '', '', 0, 1, '2024-06-19 20:34:07.000000', 'temptest4testing@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `account_customuser_groups`
--

CREATE TABLE `account_customuser_groups` (
  `id` bigint(20) NOT NULL,
  `customuser_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `account_customuser_user_permissions`
--

CREATE TABLE `account_customuser_user_permissions` (
  `id` bigint(20) NOT NULL,
  `customuser_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `account_email`
--

CREATE TABLE `account_email` (
  `id` bigint(20) NOT NULL,
  `email` varchar(254) NOT NULL,
  `host` varchar(250) NOT NULL,
  `port` bigint(20) UNSIGNED NOT NULL CHECK (`port` >= 0),
  `password` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account_email`
--

INSERT INTO `account_email` (`id`, `email`, `host`, `port`, `password`) VALUES
(4, 'genealprincebraga@gmail.com', 'smtp.gmail.com', 587, 'psoz jbgp cedo zfkb');

-- --------------------------------------------------------

--
-- Table structure for table `account_passkey_reset`
--

CREATE TABLE `account_passkey_reset` (
  `id` bigint(20) NOT NULL,
  `email` varchar(250) DEFAULT NULL,
  `status` varchar(250) DEFAULT NULL,
  `date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account_passkey_reset`
--

INSERT INTO `account_passkey_reset` (`id`, `email`, `status`, `date`) VALUES
(1, 'lastudragneel@gmail.com', 'approved', '2024-03-26 18:21:34.481000'),
(2, 'lastudragneel@gmail.com', 'approved', '2024-03-29 00:15:48.012000'),
(3, 'lastudragneel@gmail.com', 'approved', '2024-03-29 00:19:21.987000'),
(4, 'lastudragneel@gmail.com', 'approved', '2024-03-29 00:21:08.713000'),
(5, 'lastudragneel@gmail.com', 'approved', '2024-03-29 00:45:57.864000'),
(6, 'lastudragneel@gmail.com', 'approved', '2024-03-29 00:47:11.200000'),
(7, 'lastudragneel@gmail.com', 'approved', '2024-03-29 00:50:21.924000'),
(8, 'lastudragneel@gmail.com', 'approved', '2024-03-29 00:53:04.250000'),
(9, 'lastudragneel@gmail.com', 'approved', '2024-03-29 00:54:19.148000'),
(10, 'lastudragneel@gmail.com', 'approved', '2024-03-29 00:58:56.897000');

-- --------------------------------------------------------

--
-- Table structure for table `account_recaptcha`
--

CREATE TABLE `account_recaptcha` (
  `id` bigint(20) NOT NULL,
  `site_key` varchar(150) NOT NULL,
  `secret_key` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account_recaptcha`
--

INSERT INTO `account_recaptcha` (`id`, `site_key`, `secret_key`) VALUES
(1, '6LcYtu8pAAAAABJM4y3HjYufrTfDAzcub2Ra8z48', '6LcYtu8pAAAAAPs1y3wqD27hsN_c-Ws26uqBw13_');

-- --------------------------------------------------------

--
-- Table structure for table `account_twilio`
--

CREATE TABLE `account_twilio` (
  `id` bigint(20) NOT NULL,
  `account_sid` varchar(50) NOT NULL,
  `auth_token` varchar(50) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add user', 1, 'add_customuser'),
(2, 'Can change user', 1, 'change_customuser'),
(3, 'Can delete user', 1, 'delete_customuser'),
(4, 'Can view user', 1, 'view_customuser'),
(5, 'Can add account', 2, 'add_account'),
(6, 'Can change account', 2, 'change_account'),
(7, 'Can delete account', 2, 'delete_account'),
(8, 'Can view account', 2, 'view_account'),
(9, 'Can add log entry', 3, 'add_logentry'),
(10, 'Can change log entry', 3, 'change_logentry'),
(11, 'Can delete log entry', 3, 'delete_logentry'),
(12, 'Can view log entry', 3, 'view_logentry'),
(13, 'Can add permission', 4, 'add_permission'),
(14, 'Can change permission', 4, 'change_permission'),
(15, 'Can delete permission', 4, 'delete_permission'),
(16, 'Can view permission', 4, 'view_permission'),
(17, 'Can add group', 5, 'add_group'),
(18, 'Can change group', 5, 'change_group'),
(19, 'Can delete group', 5, 'delete_group'),
(20, 'Can view group', 5, 'view_group'),
(21, 'Can add content type', 6, 'add_contenttype'),
(22, 'Can change content type', 6, 'change_contenttype'),
(23, 'Can delete content type', 6, 'delete_contenttype'),
(24, 'Can view content type', 6, 'view_contenttype'),
(25, 'Can add session', 7, 'add_session'),
(26, 'Can change session', 7, 'change_session'),
(27, 'Can delete session', 7, 'delete_session'),
(28, 'Can view session', 7, 'view_session'),
(29, 'Can add case', 8, 'add_case'),
(30, 'Can change case', 8, 'change_case'),
(31, 'Can delete case', 8, 'delete_case'),
(32, 'Can view case', 8, 'view_case'),
(33, 'Can add contact_ person', 9, 'add_contact_person'),
(34, 'Can change contact_ person', 9, 'change_contact_person'),
(35, 'Can delete contact_ person', 9, 'delete_contact_person'),
(36, 'Can view contact_ person', 9, 'view_contact_person'),
(37, 'Can add evidence', 10, 'add_evidence'),
(38, 'Can change evidence', 10, 'change_evidence'),
(39, 'Can delete evidence', 10, 'delete_evidence'),
(40, 'Can view evidence', 10, 'view_evidence'),
(41, 'Can add perpetrator', 11, 'add_perpetrator'),
(42, 'Can change perpetrator', 11, 'change_perpetrator'),
(43, 'Can delete perpetrator', 11, 'delete_perpetrator'),
(44, 'Can view perpetrator', 11, 'view_perpetrator'),
(45, 'Can add parent_ perpetrator', 12, 'add_parent_perpetrator'),
(46, 'Can change parent_ perpetrator', 12, 'change_parent_perpetrator'),
(47, 'Can delete parent_ perpetrator', 12, 'delete_parent_perpetrator'),
(48, 'Can view parent_ perpetrator', 12, 'view_parent_perpetrator'),
(49, 'Can add status_ history', 13, 'add_status_history'),
(50, 'Can change status_ history', 13, 'change_status_history'),
(51, 'Can delete status_ history', 13, 'delete_status_history'),
(52, 'Can view status_ history', 13, 'view_status_history'),
(53, 'Can add victim', 14, 'add_victim'),
(54, 'Can change victim', 14, 'change_victim'),
(55, 'Can delete victim', 14, 'delete_victim'),
(56, 'Can view victim', 14, 'view_victim'),
(57, 'Can add parent', 15, 'add_parent'),
(58, 'Can change parent', 15, 'change_parent'),
(59, 'Can delete parent', 15, 'delete_parent'),
(60, 'Can view parent', 15, 'view_parent'),
(61, 'Can add witness', 16, 'add_witness'),
(62, 'Can change witness', 16, 'change_witness'),
(63, 'Can delete witness', 16, 'delete_witness'),
(64, 'Can view witness', 16, 'view_witness'),
(65, 'Can add notification', 17, 'add_notification'),
(66, 'Can change notification', 17, 'change_notification'),
(67, 'Can delete notification', 17, 'delete_notification'),
(68, 'Can view notification', 17, 'view_notification'),
(69, 'Can add passkey_ reset', 18, 'add_passkey_reset'),
(70, 'Can change passkey_ reset', 18, 'change_passkey_reset'),
(71, 'Can delete passkey_ reset', 18, 'delete_passkey_reset'),
(72, 'Can view passkey_ reset', 18, 'view_passkey_reset'),
(73, 'Can add email', 19, 'add_email'),
(74, 'Can change email', 19, 'change_email'),
(75, 'Can delete email', 19, 'delete_email'),
(76, 'Can view email', 19, 'view_email'),
(77, 'Can add recaptcha', 20, 'add_recaptcha'),
(78, 'Can change recaptcha', 20, 'change_recaptcha'),
(79, 'Can delete recaptcha', 20, 'delete_recaptcha'),
(80, 'Can view recaptcha', 20, 'view_recaptcha'),
(81, 'Can add twilio', 21, 'add_twilio'),
(82, 'Can change twilio', 21, 'change_twilio'),
(83, 'Can delete twilio', 21, 'delete_twilio'),
(84, 'Can view twilio', 21, 'view_twilio');

-- --------------------------------------------------------

--
-- Table structure for table `case_case`
--

CREATE TABLE `case_case` (
  `id` bigint(20) NOT NULL,
  `case_number` int(11) DEFAULT NULL,
  `email` varchar(254) DEFAULT NULL,
  `type_of_case` varchar(30) DEFAULT NULL,
  `service_information` varchar(20) DEFAULT NULL,
  `date_latest_incident` varchar(150) DEFAULT NULL,
  `incomplete_date` tinyint(1) DEFAULT NULL,
  `place_of_incident` varchar(150) DEFAULT NULL,
  `street` varchar(150) DEFAULT NULL,
  `barangay` varchar(150) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `region` varchar(250) DEFAULT NULL,
  `description_of_incident` longtext DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `date_added` date DEFAULT NULL,
  `checkbox_ra_9262` tinyint(1) NOT NULL,
  `checkbox_sexual_abuse` tinyint(1) NOT NULL,
  `checkbox_psychological_abuse` tinyint(1) NOT NULL,
  `checkbox_physical_abuse` tinyint(1) NOT NULL,
  `checkbox_economic_abuse` tinyint(1) NOT NULL,
  `checkbox_others` tinyint(1) NOT NULL,
  `others_input` varchar(100) DEFAULT NULL,
  `checkbox_ra_8353` tinyint(1) NOT NULL,
  `checkbox_rape_by_sexual_intercourse` tinyint(1) NOT NULL,
  `checkbox_rape_by_sexual_assault` tinyint(1) NOT NULL,
  `checkbox_art_336` tinyint(1) NOT NULL,
  `checkbox_acts_of_lasciviousness` tinyint(1) NOT NULL,
  `checkbox_ra_7877` tinyint(1) NOT NULL,
  `checkbox_verbal` tinyint(1) NOT NULL,
  `checkbox_physical` tinyint(1) NOT NULL,
  `checkbox_use_of_objects` tinyint(1) NOT NULL,
  `checkbox_a_7610` tinyint(1) NOT NULL,
  `checkbox_engage_prostitution` tinyint(1) NOT NULL,
  `checkbox_sexual_lascivious_conduct` tinyint(1) NOT NULL,
  `checkbox_ra_9775` tinyint(1) NOT NULL,
  `economic_assistance` tinyint(1) NOT NULL,
  `emergency_shelter` tinyint(1) NOT NULL,
  `enforcement_of_protection_order` tinyint(1) NOT NULL,
  `forensic_interview_and_investigation` tinyint(1) NOT NULL,
  `healthcare_provider_name` varchar(250) NOT NULL,
  `issuance_of_medical_certificate` tinyint(1) NOT NULL,
  `law_enforcement_agency_name` varchar(250) NOT NULL,
  `medico_legal_exam` tinyint(1) NOT NULL,
  `other_service_provider_name` varchar(250) NOT NULL,
  `provision_of_appropriate_medical_treatment` tinyint(1) NOT NULL,
  `psychosocial_services` tinyint(1) NOT NULL,
  `receipt_and_recording_of_complaints` tinyint(1) NOT NULL,
  `refers_to_healthcare_provider` tinyint(1) NOT NULL,
  `refers_to_law_enforcement` tinyint(1) NOT NULL,
  `refers_to_other_service_provider` tinyint(1) NOT NULL,
  `refers_to_social_welfare` tinyint(1) NOT NULL,
  `rescue_operations_of_vaw_cases` tinyint(1) NOT NULL,
  `type_of_service` varchar(250) NOT NULL,
  `refer_healthcare_date` date DEFAULT NULL,
  `refer_law_enforcement_date` date DEFAULT NULL,
  `refer_other_service_date` date DEFAULT NULL,
  `refer_social_date` date DEFAULT NULL,
  `date_closed` date DEFAULT NULL,
  `phone` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `case_case`
--

INSERT INTO `case_case` (`id`, `case_number`, `email`, `type_of_case`, `service_information`, `date_latest_incident`, `incomplete_date`, `place_of_incident`, `street`, `barangay`, `province`, `city`, `region`, `description_of_incident`, `status`, `date_added`, `checkbox_ra_9262`, `checkbox_sexual_abuse`, `checkbox_psychological_abuse`, `checkbox_physical_abuse`, `checkbox_economic_abuse`, `checkbox_others`, `others_input`, `checkbox_ra_8353`, `checkbox_rape_by_sexual_intercourse`, `checkbox_rape_by_sexual_assault`, `checkbox_art_336`, `checkbox_acts_of_lasciviousness`, `checkbox_ra_7877`, `checkbox_verbal`, `checkbox_physical`, `checkbox_use_of_objects`, `checkbox_a_7610`, `checkbox_engage_prostitution`, `checkbox_sexual_lascivious_conduct`, `checkbox_ra_9775`, `economic_assistance`, `emergency_shelter`, `enforcement_of_protection_order`, `forensic_interview_and_investigation`, `healthcare_provider_name`, `issuance_of_medical_certificate`, `law_enforcement_agency_name`, `medico_legal_exam`, `other_service_provider_name`, `provision_of_appropriate_medical_treatment`, `psychosocial_services`, `receipt_and_recording_of_complaints`, `refers_to_healthcare_provider`, `refers_to_law_enforcement`, `refers_to_other_service_provider`, `refers_to_social_welfare`, `rescue_operations_of_vaw_cases`, `type_of_service`, `refer_healthcare_date`, `refer_law_enforcement_date`, `refer_other_service_date`, `refer_social_date`, `date_closed`, `phone`) VALUES
(141, 125, 'genealprincebraga@gmail.com', 'Impacted', 'crisis', '2024-07-01', 0, '---Select Place of Incident---', 'sdfsdf', 'Tumaga', 'Zamboanga Del Sur', 'Zamboanga City', 'region-IX', 'asdfasdfasdf', 'Active', '2024-07-01', 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, '', NULL, NULL, NULL, NULL, NULL, NULL),
(142, 126, 'genealprincebraga@gmail.com', 'Behalf', 'issuance', '2024-07-01', 0, '---Select Place of Incident---', 'sdfsdf', 'Tumaga', 'Zamboanga Del Sur', 'Zamboanga City', 'region-IX', 'asdfasda', 'Active', '2024-07-01', 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, '', NULL, NULL, NULL, NULL, NULL, NULL),
(143, 127, 'genealprincebraga@gmail.com', 'Impacted', 'crisis', '2024-07-01', 0, '---Select Place of Incident---', 'erererer', 'Tumaga', 'Zamboanga Del Sur', 'Zamboanga City', 'region-IX', 'ererererererererererere', 'Active', '2024-07-01', 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, '', NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `case_contact_person`
--

CREATE TABLE `case_contact_person` (
  `id` bigint(20) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `suffix` varchar(10) DEFAULT NULL,
  `relationship` varchar(50) DEFAULT NULL,
  `street` varchar(150) DEFAULT NULL,
  `barangay` varchar(150) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `contact_number` varchar(100) DEFAULT NULL,
  `telephone_number` varchar(100) DEFAULT NULL,
  `region` varchar(250) DEFAULT NULL,
  `case_contact_id` bigint(20) DEFAULT NULL,
  `bldg_number` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `case_contact_person`
--

INSERT INTO `case_contact_person` (`id`, `first_name`, `middle_name`, `last_name`, `suffix`, `relationship`, `street`, `barangay`, `city`, `province`, `contact_number`, `telephone_number`, `region`, `case_contact_id`, `bldg_number`) VALUES
(133, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 141, NULL),
(134, 'asdfa', 'sdfas', 'dfasdf', 'none', 'asdfasdf', 'sdfasdf', 'Sto. Ni±o', 'Zamboanga City', 'Zamboanga Del Sur', '0', '0', 'region-IX', 142, 'asdfa'),
(135, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 143, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `case_evidence`
--

CREATE TABLE `case_evidence` (
  `id` bigint(20) NOT NULL,
  `file` varchar(100) NOT NULL,
  `case_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `case_notification`
--

CREATE TABLE `case_notification` (
  `id` bigint(20) NOT NULL,
  `message` varchar(250) DEFAULT NULL,
  `date` datetime(6) NOT NULL,
  `receiver_account` varchar(250) DEFAULT NULL,
  `link` varchar(250) DEFAULT NULL,
  `read` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `case_notification`
--

INSERT INTO `case_notification` (`id`, `message`, `date`, `receiver_account`, `link`, `read`) VALUES
(76, 'Passkey reset request from email: lastudragneel@gmail.com.', '2024-03-29 00:53:04.330000', 'vawcdilg@gmail.com', 'http://127.0.0.1:8000/test/', 1),
(77, 'Passkey reset request from email: lastudragneel@gmail.com.', '2024-03-29 00:54:19.243000', 'vawcdilg@gmail.com', 'http://127.0.0.1:8000/admin-vawc/manage/passkey/', 1),
(78, 'Unfortunately, your request for new passkey is declined', '2024-03-29 00:58:38.446000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/settings/', 1),
(79, 'Passkey reset request from email: lastudragneel@gmail.com.', '2024-03-29 00:58:56.982000', 'vawcdilg@gmail.com', 'http://127.0.0.1:8000/admin-vawc/manage/passkey/', 1),
(80, 'New Passkey is sent to your Email.', '2024-03-29 00:59:00.652000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/settings/', 1),
(81, 'You have a new case (#113awaiting for your attention. The priority is HIGH', '2024-06-08 16:38:14.761000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/119/', 0),
(82, 'You have a new case (#113awaiting for your attention. The priority is HIGH', '2024-06-08 16:38:14.786000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/119/', 0),
(83, 'You have a new case (#113) awaiting for your attention. The priority is HIGH', '2024-06-08 16:38:14.814000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/119/', 0),
(84, 'You have a new case (#114awaiting for your attention. The priority is HIGH', '2024-06-09 08:46:30.956000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/120/', 0),
(85, 'You have a new case (#114awaiting for your attention. The priority is HIGH', '2024-06-09 08:46:31.003000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/120/', 0),
(86, 'You have a new case (#114) awaiting for your attention. The priority is HIGH', '2024-06-09 08:46:31.049000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/120/', 0),
(87, 'You have a new case (#115awaiting for your attention. The priority is LOW', '2024-06-09 16:43:42.394000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/behalf/121/', 0),
(88, 'You have a new case (#115) awaiting for your attention. The priority is LOW', '2024-06-09 16:43:42.410000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/behalf/121/', 0),
(89, 'You have a new case (#115) awaiting for your attention. The priority is LOW', '2024-06-09 16:43:42.431000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/behalf/121/', 0),
(90, 'You have a new case (#116) awaiting for your attention. The priority is HIGH', '2024-06-19 19:11:59.462000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/122/', 0),
(91, 'You have a new case (#116) awaiting for your attention. The priority is HIGH', '2024-06-19 19:11:59.480000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/122/', 0),
(92, 'You have a new case (#116awaiting for your attention. The priority is HIGH', '2024-06-19 19:11:59.600000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/122/', 0),
(93, 'You have a new case (#117) awaiting for your attention. The priority is HIGH', '2024-06-19 19:15:46.135000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/123/', 0),
(94, 'You have a new case (#117) awaiting for your attention. The priority is HIGH', '2024-06-19 19:15:46.362000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/123/', 0),
(95, 'You have a new case (#117awaiting for your attention. The priority is HIGH', '2024-06-19 19:15:46.510000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/123/', 0),
(96, 'You have a new case (#118awaiting for your attention. The priority is HIGH', '2024-06-19 20:37:48.491000', 'temptest4testing@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/124/', 1),
(97, 'You have a new case (#119awaiting for your attention. The priority is HIGH', '2024-06-26 08:29:06.968000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/125/', 0),
(98, 'You have a new case (#119awaiting for your attention. The priority is HIGH', '2024-06-26 08:29:07.006000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/125/', 0),
(99, 'You have a new case (#119) awaiting for your attention. The priority is HIGH', '2024-06-26 08:29:07.028000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/125/', 0),
(100, 'You have a new case (#120) awaiting for your attention. The priority is HIGH', '2024-06-26 08:29:18.766000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/126/', 0),
(101, 'You have a new case (#120awaiting for your attention. The priority is HIGH', '2024-06-26 08:29:18.793000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/126/', 0),
(102, 'You have a new case (#120awaiting for your attention. The priority is HIGH', '2024-06-26 08:29:18.809000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/126/', 0),
(103, 'You have a new case (#121awaiting for your attention. The priority is HIGH', '2024-06-26 08:29:43.448000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/127/', 0),
(104, 'You have a new case (#121) awaiting for your attention. The priority is HIGH', '2024-06-26 08:29:43.466000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/127/', 0),
(105, 'You have a new case (#121) awaiting for your attention. The priority is HIGH', '2024-06-26 08:29:43.480000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/127/', 0),
(106, 'You have a new case (#122) awaiting for your attention. The priority is HIGH', '2024-06-26 17:57:30.178000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/128/', 0),
(107, 'You have a new case (#122awaiting for your attention. The priority is HIGH', '2024-06-26 17:57:30.470000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/128/', 0),
(108, 'You have a new case (#122awaiting for your attention. The priority is HIGH', '2024-06-26 17:57:30.507000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/128/', 0),
(109, 'You have a new case (#123awaiting for your attention. The priority is LOW', '2024-06-27 22:09:27.140000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/129/', 0),
(110, 'You have a new case (#123awaiting for your attention. The priority is LOW', '2024-06-27 22:09:27.164000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/129/', 0),
(111, 'You have a new case (#123) awaiting for your attention. The priority is LOW', '2024-06-27 22:09:27.195000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/129/', 0),
(112, 'You have a new case (#124awaiting for your attention. The priority is HIGH', '2024-06-28 07:19:47.025000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/130/', 0),
(113, 'You have a new case (#124) awaiting for your attention. The priority is HIGH', '2024-06-28 07:19:47.043000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/130/', 0),
(114, 'You have a new case (#124) awaiting for your attention. The priority is HIGH', '2024-06-28 07:19:47.061000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/130/', 0),
(115, 'You have a new case (#117) awaiting for your attention. The priority is HIGH', '2024-06-30 10:26:51.290000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/131/', 0),
(116, 'You have a new case (#117awaiting for your attention. The priority is HIGH', '2024-06-30 10:26:51.314000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/131/', 0),
(117, 'You have a new case (#117awaiting for your attention. The priority is HIGH', '2024-06-30 10:26:51.361000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/131/', 0),
(118, 'You have a new case (#118awaiting for your attention. The priority is HIGH', '2024-06-30 10:34:12.381000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/132/', 0),
(119, 'You have a new case (#118) awaiting for your attention. The priority is HIGH', '2024-06-30 10:34:12.422000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/132/', 0),
(120, 'You have a new case (#118) awaiting for your attention. The priority is HIGH', '2024-06-30 10:34:12.450000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/132/', 0),
(121, 'You have a new case (#119) awaiting for your attention. The priority is LOW', '2024-06-30 10:44:31.659000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/133/', 0),
(122, 'You have a new case (#119) awaiting for your attention. The priority is LOW', '2024-06-30 10:44:31.701000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/133/', 0),
(123, 'You have a new case (#119awaiting for your attention. The priority is LOW', '2024-06-30 10:44:31.732000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/133/', 0),
(124, 'You have a new case (#119awaiting for your attention. The priority is HIGH', '2024-06-30 10:49:52.975000', 'temptest4testing@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/134/', 0),
(125, 'You have a new case (#120) awaiting for your attention. The priority is LOW', '2024-06-30 10:51:48.431000', 'temptest4testing@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/135/', 0),
(126, 'You have a new case (#121awaiting for your attention. The priority is HIGH', '2024-06-30 10:53:57.357000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/136/', 0),
(127, 'You have a new case (#121) awaiting for your attention. The priority is HIGH', '2024-06-30 10:53:57.416000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/136/', 0),
(128, 'You have a new case (#121) awaiting for your attention. The priority is HIGH', '2024-06-30 10:53:57.454000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/136/', 0),
(129, 'You have a new case (#121awaiting for your attention. The priority is LOW', '2024-06-30 11:15:20.186000', 'temptest4testing@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/137/', 0),
(130, 'You have a new case (#122awaiting for your attention. The priority is LOW', '2024-07-01 12:58:05.144000', 'temptest4testing@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/138/', 0),
(131, 'You have a new case (#123) awaiting for your attention. The priority is HIGH', '2024-07-01 13:11:38.401000', 'staff@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/behalf/139/', 0),
(132, 'You have a new case (#123awaiting for your attention. The priority is HIGH', '2024-07-01 13:11:38.421000', 'staff2@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/behalf/139/', 0),
(133, 'You have a new case (#123awaiting for your attention. The priority is HIGH', '2024-07-01 13:11:38.490000', 'lastudragneel@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/behalf/139/', 0),
(134, 'You have a new case (#124) awaiting for your attention. The priority is LOW', '2024-07-01 13:13:56.511000', 'temptest4testing@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/behalf/140/', 0),
(135, 'You have a new case (#125) awaiting for your attention. The priority is HIGH', '2024-07-01 16:33:24.324000', 'temptest4testing@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/141/', 0),
(136, 'You have a new case (#126awaiting for your attention. The priority is LOW', '2024-07-01 17:50:13.014000', 'temptest4testing@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/behalf/142/', 0),
(137, 'You have a new case (#127awaiting for your attention. The priority is HIGH', '2024-07-01 17:59:20.971000', 'temptest4testing@gmail.com', 'http://127.0.0.1:8000/admin-barangay-vawc/view-case/impacted/143/', 0);

-- --------------------------------------------------------

--
-- Table structure for table `case_parent`
--

CREATE TABLE `case_parent` (
  `id` bigint(20) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `suffix` varchar(100) DEFAULT NULL,
  `date_of_birth` varchar(150) DEFAULT NULL,
  `sex` varchar(100) DEFAULT NULL,
  `civil_status` varchar(100) DEFAULT NULL,
  `educational_attainment` varchar(150) DEFAULT NULL,
  `occupation` varchar(150) DEFAULT NULL,
  `type_of_disability` varchar(150) DEFAULT NULL,
  `nationality` varchar(150) DEFAULT NULL,
  `religion` varchar(150) DEFAULT NULL,
  `contact_number` varchar(100) DEFAULT NULL,
  `telephone_number` varchar(100) DEFAULT NULL,
  `house_information` varchar(250) DEFAULT NULL,
  `street` varchar(150) DEFAULT NULL,
  `barangay` varchar(150) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `region` varchar(250) DEFAULT NULL,
  `victim_parent_id` bigint(20) DEFAULT NULL,
  `relationship_to_victim` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `case_parent_perpetrator`
--

CREATE TABLE `case_parent_perpetrator` (
  `id` bigint(20) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `suffix` varchar(100) DEFAULT NULL,
  `date_of_birth` varchar(150) DEFAULT NULL,
  `sex` varchar(100) DEFAULT NULL,
  `civil_status` varchar(100) DEFAULT NULL,
  `educational_attainment` varchar(150) DEFAULT NULL,
  `occupation` varchar(150) DEFAULT NULL,
  `type_of_disability` varchar(150) DEFAULT NULL,
  `nationality` varchar(150) DEFAULT NULL,
  `religion` varchar(150) DEFAULT NULL,
  `contact_number` varchar(100) DEFAULT NULL,
  `telephone_number` varchar(100) DEFAULT NULL,
  `house_information` varchar(250) DEFAULT NULL,
  `street` varchar(150) DEFAULT NULL,
  `barangay` varchar(150) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `region` varchar(250) DEFAULT NULL,
  `perpetrator_parent_id` bigint(20) DEFAULT NULL,
  `relationship_of_guardian` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `case_perpetrator`
--

CREATE TABLE `case_perpetrator` (
  `id` bigint(20) NOT NULL,
  `relationship_to_victim` varchar(100) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `suffix` varchar(150) DEFAULT NULL,
  `identifying_marks` varchar(250) DEFAULT NULL,
  `alias` varchar(100) DEFAULT NULL,
  `sex` varchar(100) DEFAULT NULL,
  `date_of_birth` varchar(150) DEFAULT NULL,
  `educational_attainment` varchar(150) DEFAULT NULL,
  `type_of_disability` varchar(150) DEFAULT NULL,
  `civil_status` varchar(100) DEFAULT NULL,
  `occupation` varchar(150) DEFAULT NULL,
  `contact_number` varchar(100) DEFAULT NULL,
  `telephone_number` varchar(150) DEFAULT NULL,
  `religion` varchar(150) DEFAULT NULL,
  `nationality` varchar(150) DEFAULT NULL,
  `house_information` varchar(250) DEFAULT NULL,
  `street` varchar(150) DEFAULT NULL,
  `barangay` varchar(150) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `city` varchar(150) DEFAULT NULL,
  `region` varchar(250) DEFAULT NULL,
  `case_perpetrator_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `case_perpetrator`
--

INSERT INTO `case_perpetrator` (`id`, `relationship_to_victim`, `first_name`, `middle_name`, `last_name`, `suffix`, `identifying_marks`, `alias`, `sex`, `date_of_birth`, `educational_attainment`, `type_of_disability`, `civil_status`, `occupation`, `contact_number`, `telephone_number`, `religion`, `nationality`, `house_information`, `street`, `barangay`, `province`, `city`, `region`, `case_perpetrator_id`) VALUES
(142, 'currentSpouse', 'asdf', 'asdf', 'sadf', 'none', 'asdf', 'asdf', 'Male', '2024-03-01', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'Filipino', 'asdf', 'sdf', 'Sto. Ni±o', 'Zamboanga Del Sur', 'Zamboanga City', 'region-IX', 141),
(143, 'currentSpouse', 'asdf', 'asdf', 'asdfas', 'none', 'asdfasd', 'asdfsd', 'Male', '2024-03-01', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'Filipino', 'asdf', 'asdf', 'Sto. Ni±o', 'Zamboanga Del Sur', 'Zamboanga City', 'region-IX', 142),
(144, 'currentSpouse', 'erere', 'ererere', 'rerere', 'none', 'erere', 'rerer', 'Male', '2024-03-01', '[data-placeholder]', '[data-placeholder]', '[data-placeholder]', '[data-placeholder]', '[data-placeholder]', '[data-placeholder]', '[data-placeholder]', 'Filipino', 'ere', 'erer', 'Sto. Ni±o', 'Zamboanga Del Sur', 'Zamboanga City', 'region-IX', 143),
(145, 'currentSpouse', 'www', 'www', 'www', 'none', 'www', 'www', 'Male', '2024-03-01', '[data-placeholder]', '[data-placeholder]', '[data-placeholder]', '[data-placeholder]', '[data-placeholder]', '[data-placeholder]', '[data-placeholder]', 'Filipino', 'www', 'www', 'Aplaya', 'Zamboanga Del Sur', 'Zamboanga City', 'region-I', 143);

-- --------------------------------------------------------

--
-- Table structure for table `case_status_history`
--

CREATE TABLE `case_status_history` (
  `id` bigint(20) NOT NULL,
  `status_title` varchar(150) DEFAULT NULL,
  `status_description` longtext DEFAULT NULL,
  `status_event_date` datetime(6) DEFAULT NULL,
  `status_date_added` datetime(6) DEFAULT NULL,
  `case_status_history_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `case_victim`
--

CREATE TABLE `case_victim` (
  `id` bigint(20) NOT NULL,
  `first_name` varchar(150) DEFAULT NULL,
  `middle_name` varchar(150) DEFAULT NULL,
  `last_name` varchar(150) DEFAULT NULL,
  `suffix` varchar(150) DEFAULT NULL,
  `date_of_birth` varchar(150) DEFAULT NULL,
  `sex` varchar(100) DEFAULT NULL,
  `civil_status` varchar(100) DEFAULT NULL,
  `educational_attainment` varchar(150) DEFAULT NULL,
  `occupation` varchar(150) DEFAULT NULL,
  `type_of_disability` varchar(150) DEFAULT NULL,
  `nationality` varchar(150) DEFAULT NULL,
  `religion` varchar(150) DEFAULT NULL,
  `contact_number` varchar(150) DEFAULT NULL,
  `telephone_number` varchar(150) DEFAULT NULL,
  `house_information` varchar(250) DEFAULT NULL,
  `street` varchar(150) DEFAULT NULL,
  `barangay` varchar(150) DEFAULT NULL,
  `province` varchar(150) DEFAULT NULL,
  `city` varchar(150) DEFAULT NULL,
  `region` varchar(250) DEFAULT NULL,
  `case_victim_id` bigint(20) DEFAULT NULL,
  `ages_of_children` varchar(150) DEFAULT NULL,
  `number_of_children` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `case_victim`
--

INSERT INTO `case_victim` (`id`, `first_name`, `middle_name`, `last_name`, `suffix`, `date_of_birth`, `sex`, `civil_status`, `educational_attainment`, `occupation`, `type_of_disability`, `nationality`, `religion`, `contact_number`, `telephone_number`, `house_information`, `street`, `barangay`, `province`, `city`, `region`, `case_victim_id`, `ages_of_children`, `number_of_children`) VALUES
(151, 'asdf', 'asdf', 'asdf', 'none', '2024-03-01', 'Male', 'single', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'Filipino', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'asdf', 'asdf', 'Sto. Ni±o', 'Zamboanga Del Sur', 'Zamboanga City', 'region-IX', 141, 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g=='),
(152, 'dfsdf', 'sdfsd', 'sdfsdf', 'none', '2024-03-01', 'Male', 'single', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'Filipino', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'asdg', 'dgdfgdf', 'Sto. Ni±o', 'Zamboanga Del Sur', 'Zamboanga City', 'region-IX', 142, 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==', 'gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g=='),
(153, 'erererer', 'erererer', 'erererer', 'none', '2024-03-01', 'Male', 'single', '[data-placeholder]', '[data-placeholder]', '[data-placeholder]', 'Filipino', '[data-placeholder]', '[data-placeholder]', '[data-placeholder]', 'erer', 'ererer', 'Sto. Ni±o', 'Zamboanga Del Sur', 'Zamboanga City', 'region-IX', 143, '[data-placeholder]', '[data-placeholder]');

-- --------------------------------------------------------

--
-- Table structure for table `case_witness`
--

CREATE TABLE `case_witness` (
  `id` bigint(20) NOT NULL,
  `name` varchar(250) DEFAULT NULL,
  `address` longtext DEFAULT NULL,
  `contact_number` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `case_witness_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(1, '2024-03-12 18:53:17.008000', '2', 'vawcbarangay', 1, '[{\"added\": {}}, {\"added\": {\"name\": \"account\", \"object\": \"vawcbarangay\"}}]', 1, 1),
(2, '2024-03-12 18:53:27.068000', '2', 'vawcbarangay', 2, '[{\"changed\": {\"fields\": [\"Email\"]}}]', 1, 1),
(3, '2024-03-12 18:53:46.048000', '3', 'staff', 1, '[{\"added\": {}}, {\"added\": {\"name\": \"account\", \"object\": \"staff\"}}]', 1, 1),
(4, '2024-03-12 18:53:55.727000', '3', 'staff', 2, '[{\"changed\": {\"fields\": [\"Email\"]}}]', 1, 1),
(5, '2024-03-12 19:24:20.261000', '3', 'Status_History object (3)', 3, '', 13, 1),
(6, '2024-03-14 20:42:03.204000', '32', 'Witness object (32)', 1, '[{\"added\": {}}]', 16, 1),
(7, '2024-03-19 15:32:34.078000', '4', 'Perpetrator object (4)', 2, '[{\"changed\": {\"fields\": [\"Educational attainment\", \"Type of disability\", \"Civil status\", \"Occupation\", \"Contact number\", \"Telephone number\", \"Religion\", \"Province\", \"City\"]}}]', 11, 1),
(8, '2024-03-19 15:32:34.080000', '3', 'Perpetrator object (3)', 2, '[{\"changed\": {\"fields\": [\"Province\"]}}]', 11, 1),
(9, '2024-03-19 15:32:34.081000', '2', 'Perpetrator object (2)', 2, '[{\"changed\": {\"fields\": [\"Occupation\", \"Province\", \"City\"]}}]', 11, 1),
(10, '2024-03-19 15:32:34.082000', '1', 'Perpetrator object (1)', 2, '[{\"changed\": {\"fields\": [\"Province\"]}}]', 11, 1),
(11, '2024-03-19 15:33:08.925000', '7', 'Victim ID: 7', 2, '[{\"changed\": {\"fields\": [\"Educational attainment\", \"Occupation\", \"Type of disability\", \"Religion\"]}}]', 14, 1),
(12, '2024-03-19 15:33:08.927000', '2', 'Victim ID: 2', 2, '[{\"changed\": {\"fields\": [\"Occupation\"]}}]', 14, 1),
(13, '2024-03-19 15:53:16.667000', '12', 'Victim ID: 12', 2, '[{\"changed\": {\"fields\": [\"Religion\"]}}]', 14, 1),
(14, '2024-03-19 16:55:56.202000', '11', 'Case ID: 11, Case Number: 11', 3, '', 8, 1),
(15, '2024-03-19 16:55:56.271000', '10', 'Case ID: 10, Case Number: 10', 3, '', 8, 1),
(16, '2024-03-19 16:55:56.330000', '9', 'Case ID: 9, Case Number: 9', 3, '', 8, 1),
(17, '2024-03-19 16:55:56.413000', '8', 'Case ID: 8, Case Number: 8', 3, '', 8, 1),
(18, '2024-03-19 16:55:56.480000', '7', 'Case ID: 7, Case Number: 7', 3, '', 8, 1),
(19, '2024-03-19 16:55:56.546000', '6', 'Case ID: 6, Case Number: 6', 3, '', 8, 1),
(20, '2024-03-19 16:55:56.613000', '5', 'Case ID: 5, Case Number: 5', 3, '', 8, 1),
(21, '2024-03-19 16:55:56.704000', '4', 'Case ID: 4, Case Number: 4', 3, '', 8, 1),
(22, '2024-03-19 16:55:56.772000', '3', 'Case ID: 3, Case Number: 3', 3, '', 8, 1),
(23, '2024-03-19 16:55:56.838000', '2', 'Case ID: 2, Case Number: 2', 3, '', 8, 1),
(24, '2024-03-19 16:55:56.913000', '1', 'Case ID: 1, Case Number: 1', 3, '', 8, 1),
(25, '2024-03-19 17:10:49.145000', '2', 'Parent object (2)', 3, '', 15, 1),
(26, '2024-03-19 17:13:09.285000', '3', 'Parent object (3)', 3, '', 15, 1),
(27, '2024-03-19 17:14:58.129000', '1', 'Parent_Perpetrator object (1)', 3, '', 12, 1),
(28, '2024-03-19 18:26:17.632000', '2', 'vawcbarangay', 2, '[{\"changed\": {\"name\": \"account\", \"object\": \"vawcbarangay\", \"fields\": [\"Barangay\"]}}]', 1, 1),
(29, '2024-03-19 19:00:48.442000', '2', 'vawcbarangay', 2, '[{\"changed\": {\"name\": \"account\", \"object\": \"vawcbarangay\", \"fields\": [\"Barangay\"]}}]', 1, 1),
(30, '2024-03-23 17:17:16.088000', '1', 'Notification object (1)', 1, '[{\"added\": {}}]', 17, 1),
(31, '2024-03-23 17:18:31.479000', '2', 'Notification object (2)', 1, '[{\"added\": {}}]', 17, 1),
(32, '2024-03-23 17:37:42.441000', '2', 'Notification object (2)', 2, '[{\"changed\": {\"fields\": [\"Link\"]}}]', 17, 1),
(33, '2024-03-23 17:37:42.442000', '1', 'Notification object (1)', 2, '[{\"changed\": {\"fields\": [\"Link\"]}}]', 17, 1),
(34, '2024-03-23 18:46:11.979000', '3', 'staff', 2, '[{\"changed\": {\"name\": \"account\", \"object\": \"staff\", \"fields\": [\"Barangay\"]}}]', 1, 1),
(35, '2024-03-23 18:46:25.893000', '1', 'admin', 2, '[{\"added\": {\"name\": \"account\", \"object\": \"admin\"}}]', 1, 1),
(36, '2024-03-23 19:40:49.135000', '8', 'Notification object (8)', 3, '', 17, 1),
(37, '2024-03-23 19:40:49.142000', '7', 'Notification object (7)', 3, '', 17, 1),
(38, '2024-03-23 19:40:49.147000', '6', 'Notification object (6)', 3, '', 17, 1),
(39, '2024-03-23 19:40:49.152000', '5', 'Notification object (5)', 3, '', 17, 1),
(40, '2024-03-23 19:40:49.158000', '4', 'Notification object (4)', 3, '', 17, 1),
(41, '2024-03-23 19:40:49.164000', '3', 'Notification object (3)', 3, '', 17, 1),
(42, '2024-03-23 19:54:07.864000', '11', 'Notification object (11)', 2, '[{\"changed\": {\"fields\": [\"Message\"]}}]', 17, 1),
(43, '2024-03-23 19:54:22.662000', '11', 'Notification object (11)', 3, '', 17, 1),
(44, '2024-03-23 19:54:22.669000', '10', 'Notification object (10)', 3, '', 17, 1),
(45, '2024-03-23 19:54:22.675000', '9', 'Notification object (9)', 3, '', 17, 1),
(46, '2024-03-23 19:54:22.681000', '2', 'Notification object (2)', 3, '', 17, 1),
(47, '2024-03-23 19:54:22.688000', '1', 'Notification object (1)', 3, '', 17, 1),
(48, '2024-03-23 21:14:01.866000', '13', 'Notification object (13)', 1, '[{\"added\": {}}]', 17, 1),
(49, '2024-03-23 21:19:56.511000', '13', 'Notification object (13)', 2, '[{\"changed\": {\"fields\": [\"Read\"]}}]', 17, 1),
(50, '2024-03-23 21:20:09.595000', '13', 'Notification object (13)', 2, '[{\"changed\": {\"fields\": [\"Read\"]}}]', 17, 1),
(51, '2024-03-23 23:45:13.323000', '61', 'Case ID: 61, Case Number: 61', 3, '', 8, 1),
(52, '2024-03-23 23:55:55.418000', '62', 'Case ID: 62, Case Number: 61', 3, '', 8, 1),
(53, '2024-03-24 00:08:14.386000', '63', 'Case ID: 63, Case Number: 61', 3, '', 8, 1),
(54, '2024-03-24 00:13:37.267000', '64', 'Case ID: 64, Case Number: 61', 3, '', 8, 1),
(55, '2024-03-24 00:15:50.482000', '66', 'Case ID: 66, Case Number: 62', 3, '', 8, 1),
(56, '2024-03-24 19:32:13.776000', '2', 'vawcbarangay', 2, '[{\"changed\": {\"name\": \"account\", \"object\": \"vawcbarangay\", \"fields\": [\"Type\"]}}]', 1, 1),
(57, '2024-03-24 19:32:54.438000', '3', 'staff', 2, '[{\"changed\": {\"name\": \"account\", \"object\": \"staff\", \"fields\": [\"Barangay\"]}}]', 1, 1),
(58, '2024-03-24 23:03:15.369000', '4', 'test', 3, '', 1, 1),
(59, '2024-03-25 00:51:59.745000', '5', 'wil', 2, '[{\"changed\": {\"name\": \"account\", \"object\": \"wil\", \"fields\": [\"Barangay\"]}}]', 1, 1),
(60, '2024-03-26 13:25:09.411000', '28', 'Notification object (28)', 1, '[{\"added\": {}}]', 17, 1),
(61, '2024-03-26 13:45:47.035000', '36', 'Notification object (36)', 3, '', 17, 1),
(62, '2024-03-26 13:45:47.132000', '35', 'Notification object (35)', 3, '', 17, 1),
(63, '2024-03-26 13:45:47.218000', '34', 'Notification object (34)', 3, '', 17, 1),
(64, '2024-03-26 13:45:47.335000', '33', 'Notification object (33)', 3, '', 17, 1),
(65, '2024-03-26 13:45:47.458000', '32', 'Notification object (32)', 3, '', 17, 1),
(66, '2024-03-26 13:45:47.560000', '31', 'Notification object (31)', 3, '', 17, 1),
(67, '2024-03-26 13:45:47.661000', '30', 'Notification object (30)', 3, '', 17, 1),
(68, '2024-03-26 13:45:47.760000', '29', 'Notification object (29)', 3, '', 17, 1),
(69, '2024-03-26 13:45:47.866000', '28', 'Notification object (28)', 3, '', 17, 1),
(70, '2024-03-26 13:45:47.952000', '27', 'Notification object (27)', 3, '', 17, 1),
(71, '2024-03-26 13:45:48.058000', '26', 'Notification object (26)', 3, '', 17, 1),
(72, '2024-03-26 13:45:48.144000', '25', 'Notification object (25)', 3, '', 17, 1),
(73, '2024-03-26 13:45:48.275000', '24', 'Notification object (24)', 3, '', 17, 1),
(74, '2024-03-26 13:45:48.377000', '23', 'Notification object (23)', 3, '', 17, 1),
(75, '2024-03-26 13:45:48.483000', '22', 'Notification object (22)', 3, '', 17, 1),
(76, '2024-03-26 13:45:48.569000', '21', 'Notification object (21)', 3, '', 17, 1),
(77, '2024-03-26 13:45:48.683000', '20', 'Notification object (20)', 3, '', 17, 1),
(78, '2024-03-26 13:45:48.769000', '19', 'Notification object (19)', 3, '', 17, 1),
(79, '2024-03-26 13:45:48.877000', '18', 'Notification object (18)', 3, '', 17, 1),
(80, '2024-03-26 13:45:48.952000', '17', 'Notification object (17)', 3, '', 17, 1),
(81, '2024-03-26 13:45:49.027000', '16', 'Notification object (16)', 3, '', 17, 1),
(82, '2024-03-26 13:45:49.109000', '15', 'Notification object (15)', 3, '', 17, 1),
(83, '2024-03-26 13:45:49.242000', '14', 'Notification object (14)', 3, '', 17, 1),
(84, '2024-03-26 13:45:49.311000', '13', 'Notification object (13)', 3, '', 17, 1),
(85, '2024-03-26 13:45:49.386000', '12', 'Notification object (12)', 3, '', 17, 1),
(86, '2024-03-28 21:07:31.344000', '67', 'Notification object (67)', 3, '', 17, 1),
(87, '2024-03-28 21:07:31.436000', '66', 'Notification object (66)', 3, '', 17, 1),
(88, '2024-03-28 21:07:31.520000', '65', 'Notification object (65)', 3, '', 17, 1),
(89, '2024-03-28 21:07:31.594000', '64', 'Notification object (64)', 3, '', 17, 1),
(90, '2024-03-28 21:07:31.678000', '63', 'Notification object (63)', 3, '', 17, 1),
(91, '2024-03-28 21:07:31.753000', '62', 'Notification object (62)', 3, '', 17, 1),
(92, '2024-03-28 21:07:31.836000', '61', 'Notification object (61)', 3, '', 17, 1),
(93, '2024-03-28 21:07:31.928000', '60', 'Notification object (60)', 3, '', 17, 1),
(94, '2024-03-28 21:07:32.009000', '59', 'Notification object (59)', 3, '', 17, 1),
(95, '2024-03-28 21:07:32.078000', '58', 'Notification object (58)', 3, '', 17, 1),
(96, '2024-03-28 21:07:32.176000', '57', 'Notification object (57)', 3, '', 17, 1),
(97, '2024-03-28 21:07:32.253000', '56', 'Notification object (56)', 3, '', 17, 1),
(98, '2024-03-28 21:07:32.334000', '55', 'Notification object (55)', 3, '', 17, 1),
(99, '2024-03-28 21:07:32.411000', '54', 'Notification object (54)', 3, '', 17, 1),
(100, '2024-03-28 21:07:32.501000', '53', 'Notification object (53)', 3, '', 17, 1),
(101, '2024-03-28 21:07:32.603000', '52', 'Notification object (52)', 3, '', 17, 1),
(102, '2024-03-28 21:07:32.693000', '51', 'Notification object (51)', 3, '', 17, 1),
(103, '2024-03-28 21:07:32.800000', '50', 'Notification object (50)', 3, '', 17, 1),
(104, '2024-03-28 21:07:32.926000', '49', 'Notification object (49)', 3, '', 17, 1),
(105, '2024-03-28 21:07:33.052000', '48', 'Notification object (48)', 3, '', 17, 1),
(106, '2024-03-28 21:07:33.151000', '47', 'Notification object (47)', 3, '', 17, 1),
(107, '2024-03-28 21:07:33.301000', '46', 'Notification object (46)', 3, '', 17, 1),
(108, '2024-03-28 21:07:33.434000', '45', 'Notification object (45)', 3, '', 17, 1),
(109, '2024-03-28 21:07:33.601000', '44', 'Notification object (44)', 3, '', 17, 1),
(110, '2024-03-28 21:07:33.793000', '43', 'Notification object (43)', 3, '', 17, 1),
(111, '2024-03-28 21:07:33.876000', '42', 'Notification object (42)', 3, '', 17, 1),
(112, '2024-03-28 21:07:33.967000', '41', 'Notification object (41)', 3, '', 17, 1),
(113, '2024-03-28 21:07:34.118000', '40', 'Notification object (40)', 3, '', 17, 1),
(114, '2024-03-28 21:07:34.209000', '39', 'Notification object (39)', 3, '', 17, 1),
(115, '2024-03-28 21:07:34.343000', '38', 'Notification object (38)', 3, '', 17, 1),
(116, '2024-03-28 21:07:34.534000', '37', 'Notification object (37)', 3, '', 17, 1),
(117, '2024-03-28 21:08:36.899000', '68', 'Notification object (68)', 1, '[{\"added\": {}}]', 17, 1),
(118, '2024-03-28 21:34:24.069000', '72', 'Notification object (72)', 2, '[{\"changed\": {\"fields\": [\"Read\"]}}]', 17, 1),
(119, '2024-03-28 21:39:18.635000', '72', 'Notification object (72)', 2, '[{\"changed\": {\"fields\": [\"Read\"]}}]', 17, 1),
(120, '2024-03-28 21:41:09.147000', '72', 'Notification object (72)', 2, '[]', 17, 1),
(121, '2024-03-28 21:41:24.558000', '72', 'Notification object (72)', 2, '[{\"changed\": {\"fields\": [\"Read\"]}}]', 17, 1),
(122, '2024-03-28 21:41:44.815000', '72', 'Notification object (72)', 2, '[{\"changed\": {\"fields\": [\"Read\"]}}]', 17, 1),
(123, '2024-03-28 21:42:00.374000', '68', 'Notification object (68)', 3, '', 17, 1),
(124, '2024-03-28 22:04:38.347000', '72', 'Notification object (72)', 2, '[{\"changed\": {\"fields\": [\"Read\"]}}]', 17, 1),
(125, '2024-03-29 00:23:54.472000', '73', 'Notification object (73)', 1, '[{\"added\": {}}]', 17, 1),
(126, '2024-03-29 00:30:18.617000', '69', 'Notification object (69)', 3, '', 17, 1),
(127, '2024-03-29 00:35:08.810000', '73', 'Notification object (73)', 2, '[{\"changed\": {\"fields\": [\"Read\"]}}]', 17, 1),
(128, '2024-03-29 00:49:51.209000', '74', 'Notification object (74)', 3, '', 17, 1),
(129, '2024-03-29 00:49:51.297000', '73', 'Notification object (73)', 3, '', 17, 1),
(130, '2024-03-29 00:49:51.414000', '72', 'Notification object (72)', 3, '', 17, 1),
(131, '2024-03-29 00:49:51.489000', '71', 'Notification object (71)', 3, '', 17, 1),
(132, '2024-03-29 00:49:51.605000', '70', 'Notification object (70)', 3, '', 17, 1),
(133, '2024-03-29 00:51:39.857000', '2', 'vawcbarangay', 2, '[{\"changed\": {\"name\": \"account\", \"object\": \"vawcbarangay\", \"fields\": [\"Barangay\"]}}]', 1, 1),
(134, '2024-03-29 00:53:22.339000', '75', 'Notification object (75)', 3, '', 17, 1),
(135, '2024-05-31 18:23:01.492000', '10', 'temp', 3, '', 1, 11),
(136, '2024-05-31 19:51:34.100000', '12', 'temp', 1, '[{\"added\": {}}, {\"added\": {\"name\": \"account\", \"object\": \"temp\"}}]', 1, 11),
(137, '2024-05-31 19:53:41.084000', '12', 'temp', 3, '', 1, 11),
(138, '2024-05-31 19:55:02.623000', '11', 'genesan', 2, '[{\"added\": {\"name\": \"account\", \"object\": \"genesan\"}}]', 1, 11),
(139, '2024-05-31 20:04:02.643000', '11', 'genesan', 2, '[{\"changed\": {\"name\": \"account\", \"object\": \"genesan\", \"fields\": [\"Verified\", \"Status\", \"Region\", \"Passkey\"]}}]', 1, 11),
(141, '2024-05-31 20:37:21.559000', '13', 'temp', 3, '', 1, 11),
(142, '2024-06-02 10:38:47.523000', '1', 'Email object (1)', 1, '[{\"added\": {}}]', 19, 11),
(143, '2024-06-02 11:13:13.248000', '1', 'Email: temptest2000x@gmail.com - Host: smtp.gmail.com - Port: 578', 2, '[{\"changed\": {\"fields\": [\"Email\", \"Password\"]}}]', 19, 11),
(144, '2024-06-02 11:32:36.552000', '1', 'Email: temptest2000x@gmail.com - Host: smtp.gmail.com - Port: 578', 3, '', 19, 11),
(145, '2024-06-02 11:45:08.328000', '2', 'Email: genealprincebraga@gmail.com - Host: smtp.gmail.com - Port: 587', 1, '[{\"added\": {}}]', 19, 11),
(146, '2024-06-02 13:13:56.606000', '2', 'Email: genealprincebraga@gmail.com - Host: smtp.gmail.com - Port: 587', 3, '', 19, 11),
(147, '2024-06-02 15:10:53.664000', '3', 'Email: genealprincebraga@gmail.com - Host: smtp.gmail.com - Port: 587', 1, '[{\"added\": {}}]', 19, 11),
(148, '2024-06-02 15:31:12.249000', '3', 'Email: genealprincebraga@gmail.com - Host: smtp.gmail.com - Port: 587', 3, '', 19, 11),
(149, '2024-06-02 16:05:11.661000', '4', 'Email: genealprincebraga@gmail.com - Host: smtp.gmail.com - Port: 587', 1, '[{\"added\": {}}]', 19, 11),
(150, '2024-06-02 16:14:38.275000', '4', 'Email: vawcdilg@gmail.com - Host: smtp.gmail.com - Port: 587', 2, '[{\"changed\": {\"fields\": [\"Email\", \"Password\"]}}]', 19, 11),
(151, '2024-06-04 19:14:24.019000', '1', 'Site key: 6LcYtu8pAAAAABJM4y3HjYufrTfDAzcub2Ra8z48 - Secret key: 6LcYtu8pAAAAAPs1y3wqD27hsN_c-Ws26uqBw13_', 1, '[{\"added\": {}}]', 20, 11),
(152, '2024-06-12 11:12:45.415000', '1', 'Account SID: AC06a7acaa1a7c4703b148ef8b417f5b16 - From contact: +13642047153', 1, '[{\"added\": {}}]', 21, 11),
(153, '2024-06-12 12:03:00.873000', '1', 'Account SID: AC06a7acaa1a7c4703b148ef8b417f5b16 - From contact: +13642047153', 3, '', 21, 11),
(154, '2024-06-13 09:22:32.963000', '11', 'genesan', 2, '[{\"changed\": {\"name\": \"account\", \"object\": \"genesan\", \"fields\": [\"Type\"]}}]', 1, 11),
(155, '2024-06-19 20:43:12.234000', '14', 'Temptest', 2, '[{\"changed\": {\"name\": \"account\", \"object\": \"Temptest\", \"fields\": [\"Middle name\", \"Passkey\"]}}]', 1, 11),
(156, '2024-06-29 19:28:23.585000', '130', 'Case ID: 130, Case Number: 124', 3, '', 8, 11),
(157, '2024-06-29 19:30:15.844000', '127', 'Case ID: 127, Case Number: 121', 3, '', 8, 11),
(158, '2024-06-29 19:32:39.180000', '126', 'Case ID: 126, Case Number: 120', 3, '', 8, 11),
(159, '2024-06-29 19:32:39.197000', '125', 'Case ID: 125, Case Number: 119', 3, '', 8, 11),
(160, '2024-06-29 19:32:39.215000', '119', 'Case ID: 119, Case Number: 113', 3, '', 8, 11),
(161, '2024-06-30 08:33:31.593000', '121', 'Case ID: 121, Case Number: 115', 3, '', 8, 11),
(162, '2024-06-30 08:33:31.621000', '120', 'Case ID: 120, Case Number: 114', 3, '', 8, 11),
(163, '2024-06-30 08:55:55.041000', '129', 'Case ID: 129, Case Number: 123', 3, '', 8, 11),
(164, '2024-06-30 08:55:55.062000', '128', 'Case ID: 128, Case Number: 122', 3, '', 8, 11),
(165, '2024-06-30 08:55:55.079000', '124', 'Case ID: 124, Case Number: 118', 3, '', 8, 11),
(166, '2024-06-30 08:55:55.097000', '123', 'Case ID: 123, Case Number: 117', 3, '', 8, 11),
(167, '2024-06-30 10:45:59.282000', '133', 'Case ID: 133, Case Number: 119', 3, '', 8, 11),
(168, '2024-06-30 10:48:01.802000', '4', 'Email: genealprincebraga@gmail.com - Host: smtp.gmail.com - Port: 587', 2, '[{\"changed\": {\"fields\": [\"Email\", \"Password\"]}}]', 19, 11),
(169, '2024-06-30 11:04:10.452000', '136', 'Case ID: 136, Case Number: 121', 3, '', 8, 11),
(170, '2024-07-01 16:42:20.552000', '140', 'Case ID: 140, Case Number: 124', 3, '', 8, 11),
(171, '2024-07-01 16:42:20.562000', '139', 'Case ID: 139, Case Number: 123', 3, '', 8, 11),
(172, '2024-07-01 16:42:20.586000', '138', 'Case ID: 138, Case Number: 122', 3, '', 8, 11),
(173, '2024-07-01 16:42:20.602000', '137', 'Case ID: 137, Case Number: 121', 3, '', 8, 11),
(174, '2024-07-01 16:42:20.611000', '135', 'Case ID: 135, Case Number: 120', 3, '', 8, 11),
(175, '2024-07-01 16:42:20.635000', '134', 'Case ID: 134, Case Number: 119', 3, '', 8, 11),
(176, '2024-07-01 16:42:20.644000', '132', 'Case ID: 132, Case Number: 118', 3, '', 8, 11),
(177, '2024-07-01 16:42:20.668000', '131', 'Case ID: 131, Case Number: 117', 3, '', 8, 11),
(178, '2024-07-01 16:42:20.678000', '122', 'Case ID: 122, Case Number: 116', 3, '', 8, 11),
(179, '2024-07-01 16:42:20.695000', '118', 'Case ID: 118, Case Number: 112', 3, '', 8, 11),
(180, '2024-07-01 16:42:20.717000', '117', 'Case ID: 117, Case Number: 111', 3, '', 8, 11),
(181, '2024-07-01 16:42:20.735000', '116', 'Case ID: 116, Case Number: 110', 3, '', 8, 11),
(182, '2024-07-01 16:42:20.751000', '115', 'Case ID: 115, Case Number: 109', 3, '', 8, 11),
(183, '2024-07-01 16:42:20.768000', '114', 'Case ID: 114, Case Number: 108', 3, '', 8, 11),
(184, '2024-07-01 16:42:20.784000', '113', 'Case ID: 113, Case Number: 107', 3, '', 8, 11),
(185, '2024-07-01 16:42:20.810000', '112', 'Case ID: 112, Case Number: 106', 3, '', 8, 11),
(186, '2024-07-01 16:42:20.826000', '111', 'Case ID: 111, Case Number: 105', 3, '', 8, 11),
(187, '2024-07-01 16:42:20.842000', '110', 'Case ID: 110, Case Number: 104', 3, '', 8, 11),
(188, '2024-07-01 16:42:20.858000', '108', 'Case ID: 108, Case Number: 103', 3, '', 8, 11),
(189, '2024-07-01 16:42:20.881000', '106', 'Case ID: 106, Case Number: 101', 3, '', 8, 11),
(190, '2024-07-01 16:42:20.893000', '105', 'Case ID: 105, Case Number: 100', 3, '', 8, 11),
(191, '2024-07-01 16:42:20.915000', '104', 'Case ID: 104, Case Number: 99', 3, '', 8, 11),
(192, '2024-07-01 16:42:20.937000', '103', 'Case ID: 103, Case Number: 98', 3, '', 8, 11),
(193, '2024-07-01 16:42:20.954000', '102', 'Case ID: 102, Case Number: 97', 3, '', 8, 11),
(194, '2024-07-01 16:42:20.980000', '101', 'Case ID: 101, Case Number: 96', 3, '', 8, 11),
(195, '2024-07-01 16:42:20.996000', '100', 'Case ID: 100, Case Number: 95', 3, '', 8, 11),
(196, '2024-07-01 16:42:21.020000', '99', 'Case ID: 99, Case Number: 94', 3, '', 8, 11),
(197, '2024-07-01 16:42:21.038000', '98', 'Case ID: 98, Case Number: 93', 3, '', 8, 11),
(198, '2024-07-01 16:42:21.057000', '97', 'Case ID: 97, Case Number: 92', 3, '', 8, 11),
(199, '2024-07-01 16:42:21.077000', '96', 'Case ID: 96, Case Number: 91', 3, '', 8, 11),
(200, '2024-07-01 16:42:21.093000', '95', 'Case ID: 95, Case Number: 90', 3, '', 8, 11),
(201, '2024-07-01 16:42:21.109000', '94', 'Case ID: 94, Case Number: 89', 3, '', 8, 11),
(202, '2024-07-01 16:42:21.125000', '93', 'Case ID: 93, Case Number: 88', 3, '', 8, 11),
(203, '2024-07-01 16:42:21.143000', '92', 'Case ID: 92, Case Number: 87', 3, '', 8, 11),
(204, '2024-07-01 16:42:21.159000', '91', 'Case ID: 91, Case Number: 86', 3, '', 8, 11),
(205, '2024-07-01 16:42:21.175000', '90', 'Case ID: 90, Case Number: 85', 3, '', 8, 11),
(206, '2024-07-01 16:42:21.191000', '89', 'Case ID: 89, Case Number: 84', 3, '', 8, 11),
(207, '2024-07-01 16:42:21.207000', '88', 'Case ID: 88, Case Number: 83', 3, '', 8, 11),
(208, '2024-07-01 16:42:21.223000', '87', 'Case ID: 87, Case Number: 82', 3, '', 8, 11),
(209, '2024-07-01 16:42:21.239000', '86', 'Case ID: 86, Case Number: 81', 3, '', 8, 11),
(210, '2024-07-01 16:42:21.255000', '85', 'Case ID: 85, Case Number: 80', 3, '', 8, 11),
(211, '2024-07-01 16:42:21.271000', '84', 'Case ID: 84, Case Number: 79', 3, '', 8, 11),
(212, '2024-07-01 16:42:21.292000', '83', 'Case ID: 83, Case Number: 78', 3, '', 8, 11),
(213, '2024-07-01 16:42:21.312000', '82', 'Case ID: 82, Case Number: 77', 3, '', 8, 11),
(214, '2024-07-01 16:42:21.335000', '81', 'Case ID: 81, Case Number: 76', 3, '', 8, 11),
(215, '2024-07-01 16:42:21.351000', '80', 'Case ID: 80, Case Number: 75', 3, '', 8, 11),
(216, '2024-07-01 16:42:21.378000', '79', 'Case ID: 79, Case Number: 74', 3, '', 8, 11),
(217, '2024-07-01 16:42:21.413000', '78', 'Case ID: 78, Case Number: 73', 3, '', 8, 11),
(218, '2024-07-01 16:42:21.430000', '77', 'Case ID: 77, Case Number: 72', 3, '', 8, 11),
(219, '2024-07-01 16:42:21.449000', '76', 'Case ID: 76, Case Number: 71', 3, '', 8, 11),
(220, '2024-07-01 16:42:21.466000', '75', 'Case ID: 75, Case Number: 70', 3, '', 8, 11),
(221, '2024-07-01 16:42:21.487000', '74', 'Case ID: 74, Case Number: 69', 3, '', 8, 11),
(222, '2024-07-01 16:42:21.509000', '73', 'Case ID: 73, Case Number: 68', 3, '', 8, 11),
(223, '2024-07-01 16:42:21.527000', '72', 'Case ID: 72, Case Number: 67', 3, '', 8, 11),
(224, '2024-07-01 16:42:21.545000', '71', 'Case ID: 71, Case Number: 66', 3, '', 8, 11),
(225, '2024-07-01 16:42:49.685000', '70', 'Case ID: 70, Case Number: 65', 3, '', 8, 11),
(226, '2024-07-01 16:42:49.712000', '69', 'Case ID: 69, Case Number: 64', 3, '', 8, 11),
(227, '2024-07-01 16:42:49.729000', '68', 'Case ID: 68, Case Number: 63', 3, '', 8, 11),
(228, '2024-07-01 16:42:49.752000', '67', 'Case ID: 67, Case Number: 62', 3, '', 8, 11),
(229, '2024-07-01 16:42:49.778000', '65', 'Case ID: 65, Case Number: 61', 3, '', 8, 11),
(230, '2024-07-01 16:42:49.795000', '60', 'Case ID: 60, Case Number: 60', 3, '', 8, 11),
(231, '2024-07-01 16:42:49.817000', '59', 'Case ID: 59, Case Number: 59', 3, '', 8, 11),
(232, '2024-07-01 16:42:49.836000', '58', 'Case ID: 58, Case Number: 58', 3, '', 8, 11),
(233, '2024-07-01 16:42:49.853000', '57', 'Case ID: 57, Case Number: 57', 3, '', 8, 11),
(234, '2024-07-01 16:42:49.874000', '56', 'Case ID: 56, Case Number: 56', 3, '', 8, 11),
(235, '2024-07-01 16:42:49.894000', '55', 'Case ID: 55, Case Number: 55', 3, '', 8, 11),
(236, '2024-07-01 16:42:49.919000', '54', 'Case ID: 54, Case Number: 54', 3, '', 8, 11),
(237, '2024-07-01 16:42:49.940000', '53', 'Case ID: 53, Case Number: 53', 3, '', 8, 11),
(238, '2024-07-01 16:42:49.959000', '52', 'Case ID: 52, Case Number: 52', 3, '', 8, 11),
(239, '2024-07-01 16:42:49.978000', '51', 'Case ID: 51, Case Number: 51', 3, '', 8, 11),
(240, '2024-07-01 16:42:49.991000', '50', 'Case ID: 50, Case Number: 50', 3, '', 8, 11),
(241, '2024-07-01 16:42:50.008000', '49', 'Case ID: 49, Case Number: 49', 3, '', 8, 11),
(242, '2024-07-01 16:42:50.028000', '48', 'Case ID: 48, Case Number: 48', 3, '', 8, 11),
(243, '2024-07-01 16:42:50.053000', '47', 'Case ID: 47, Case Number: 47', 3, '', 8, 11),
(244, '2024-07-01 16:42:50.074000', '46', 'Case ID: 46, Case Number: 46', 3, '', 8, 11),
(245, '2024-07-01 16:42:50.094000', '45', 'Case ID: 45, Case Number: 45', 3, '', 8, 11),
(246, '2024-07-01 16:42:50.112000', '44', 'Case ID: 44, Case Number: 44', 3, '', 8, 11),
(247, '2024-07-01 16:42:50.136000', '43', 'Case ID: 43, Case Number: 43', 3, '', 8, 11),
(248, '2024-07-01 16:42:50.157000', '42', 'Case ID: 42, Case Number: 42', 3, '', 8, 11),
(249, '2024-07-01 16:42:50.178000', '41', 'Case ID: 41, Case Number: 41', 3, '', 8, 11),
(250, '2024-07-01 16:42:50.194000', '40', 'Case ID: 40, Case Number: 40', 3, '', 8, 11),
(251, '2024-07-01 16:42:50.216000', '39', 'Case ID: 39, Case Number: 39', 3, '', 8, 11),
(252, '2024-07-01 16:42:50.238000', '38', 'Case ID: 38, Case Number: 38', 3, '', 8, 11),
(253, '2024-07-01 16:42:50.257000', '37', 'Case ID: 37, Case Number: 37', 3, '', 8, 11),
(254, '2024-07-01 16:42:50.274000', '36', 'Case ID: 36, Case Number: 36', 3, '', 8, 11),
(255, '2024-07-01 16:42:50.298000', '35', 'Case ID: 35, Case Number: 35', 3, '', 8, 11),
(256, '2024-07-01 16:42:50.314000', '34', 'Case ID: 34, Case Number: 34', 3, '', 8, 11),
(257, '2024-07-01 16:42:50.338000', '33', 'Case ID: 33, Case Number: 33', 3, '', 8, 11),
(258, '2024-07-01 16:42:50.357000', '32', 'Case ID: 32, Case Number: 32', 3, '', 8, 11),
(259, '2024-07-01 16:42:50.373000', '31', 'Case ID: 31, Case Number: 31', 3, '', 8, 11),
(260, '2024-07-01 16:42:50.391000', '30', 'Case ID: 30, Case Number: 30', 3, '', 8, 11),
(261, '2024-07-01 16:42:50.407000', '29', 'Case ID: 29, Case Number: 29', 3, '', 8, 11),
(262, '2024-07-01 16:42:50.432000', '28', 'Case ID: 28, Case Number: 28', 3, '', 8, 11),
(263, '2024-07-01 16:42:50.452000', '27', 'Case ID: 27, Case Number: 27', 3, '', 8, 11),
(264, '2024-07-01 16:42:50.466000', '26', 'Case ID: 26, Case Number: 26', 3, '', 8, 11),
(265, '2024-07-01 16:42:50.482000', '25', 'Case ID: 25, Case Number: 25', 3, '', 8, 11),
(266, '2024-07-01 16:42:50.502000', '24', 'Case ID: 24, Case Number: 24', 3, '', 8, 11),
(267, '2024-07-01 16:42:50.519000', '23', 'Case ID: 23, Case Number: 23', 3, '', 8, 11),
(268, '2024-07-01 16:42:50.531000', '22', 'Case ID: 22, Case Number: 22', 3, '', 8, 11),
(269, '2024-07-01 16:42:50.555000', '21', 'Case ID: 21, Case Number: 21', 3, '', 8, 11),
(270, '2024-07-01 16:42:50.571000', '20', 'Case ID: 20, Case Number: 20', 3, '', 8, 11),
(271, '2024-07-01 16:42:50.595000', '19', 'Case ID: 19, Case Number: 19', 3, '', 8, 11),
(272, '2024-07-01 16:42:50.615000', '18', 'Case ID: 18, Case Number: 18', 3, '', 8, 11),
(273, '2024-07-01 16:42:50.632000', '17', 'Case ID: 17, Case Number: 17', 3, '', 8, 11),
(274, '2024-07-01 16:42:50.658000', '16', 'Case ID: 16, Case Number: 16', 3, '', 8, 11),
(275, '2024-07-01 16:42:50.675000', '15', 'Case ID: 15, Case Number: 15', 3, '', 8, 11),
(276, '2024-07-01 16:42:50.691000', '14', 'Case ID: 14, Case Number: 14', 3, '', 8, 11),
(277, '2024-07-01 16:42:50.711000', '13', 'Case ID: 13, Case Number: 13', 3, '', 8, 11),
(278, '2024-07-01 16:42:50.732000', '12', 'Case ID: 12, Case Number: 12', 3, '', 8, 11);

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(2, 'account', 'account'),
(1, 'account', 'customuser'),
(19, 'account', 'email'),
(18, 'account', 'passkey_reset'),
(20, 'account', 'recaptcha'),
(21, 'account', 'twilio'),
(3, 'admin', 'logentry'),
(5, 'auth', 'group'),
(4, 'auth', 'permission'),
(8, 'case', 'case'),
(9, 'case', 'contact_person'),
(10, 'case', 'evidence'),
(17, 'case', 'notification'),
(15, 'case', 'parent'),
(12, 'case', 'parent_perpetrator'),
(11, 'case', 'perpetrator'),
(13, 'case', 'status_history'),
(14, 'case', 'victim'),
(16, 'case', 'witness'),
(6, 'contenttypes', 'contenttype'),
(7, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2024-07-02 15:45:00.848297'),
(2, 'contenttypes', '0002_remove_content_type_name', '2024-07-02 15:45:01.017648'),
(3, 'auth', '0001_initial', '2024-07-02 15:45:01.671633'),
(4, 'auth', '0002_alter_permission_name_max_length', '2024-07-02 15:45:01.810316'),
(5, 'auth', '0003_alter_user_email_max_length', '2024-07-02 15:45:01.901234'),
(6, 'auth', '0004_alter_user_username_opts', '2024-07-02 15:45:01.909477'),
(7, 'auth', '0005_alter_user_last_login_null', '2024-07-02 15:45:01.925916'),
(8, 'auth', '0006_require_contenttypes_0002', '2024-07-02 15:45:01.949895'),
(9, 'auth', '0007_alter_validators_add_error_messages', '2024-07-02 15:45:01.976767'),
(10, 'auth', '0008_alter_user_username_max_length', '2024-07-02 15:45:02.001310'),
(11, 'auth', '0009_alter_user_last_name_max_length', '2024-07-02 15:45:02.019042'),
(12, 'auth', '0010_alter_group_name_max_length', '2024-07-02 15:45:02.065612'),
(13, 'auth', '0011_update_proxy_permissions', '2024-07-02 15:45:02.090787'),
(14, 'auth', '0012_alter_user_first_name_max_length', '2024-07-02 15:45:02.107743'),
(15, 'account', '0001_initial', '2024-07-02 15:45:02.952736'),
(16, 'account', '0002_account_barangay', '2024-07-02 15:45:03.008710'),
(17, 'account', '0003_account_city_account_province_account_region', '2024-07-02 15:45:03.122750'),
(18, 'account', '0004_account_status', '2024-07-02 15:45:03.162732'),
(19, 'account', '0003_passkey_reset', '2024-07-02 15:45:03.194730'),
(20, 'account', '0005_merge_0003_passkey_reset_0004_account_status', '2024-07-02 15:45:03.202750'),
(21, 'account', '0006_account_passkey', '2024-07-02 15:45:03.253827'),
(22, 'account', '0007_email', '2024-07-02 15:45:03.295268'),
(23, 'account', '0008_alter_email_port', '2024-07-02 15:45:03.303264'),
(24, 'account', '0009_recaptcha', '2024-07-02 15:45:03.351687'),
(25, 'account', '0010_twilio', '2024-07-02 15:45:03.464814'),
(26, 'admin', '0001_initial', '2024-07-02 15:45:03.835506'),
(27, 'admin', '0002_logentry_remove_auto_add', '2024-07-02 15:45:03.867955'),
(28, 'admin', '0003_logentry_add_action_flag_choices', '2024-07-02 15:45:03.892400'),
(29, 'case', '0001_initial', '2024-07-02 15:45:05.442878'),
(30, 'case', '0002_contact_person_bldg_number', '2024-07-02 15:45:05.485974'),
(31, 'case', '0003_alter_perpetrator_city_and_more', '2024-07-02 15:45:07.503456'),
(32, 'case', '0004_notification', '2024-07-02 15:45:07.689015'),
(33, 'case', '0005_notification_link', '2024-07-02 15:45:07.722931'),
(34, 'case', '0006_alter_notification_receiver_account', '2024-07-02 15:45:08.723484'),
(35, 'case', '0007_notification_read', '2024-07-02 15:45:08.764936'),
(36, 'case', '0003_case_economic_assistance_case_emergency_shelter_and_more', '2024-07-02 15:45:09.721911'),
(37, 'case', '0004_remove_case_none_type_of_service', '2024-07-02 15:45:09.755311'),
(38, 'case', '0005_parent_relationship_to_victim_and_more', '2024-07-02 15:45:09.860131'),
(39, 'case', '0006_parent_perpetrator_relationship_of_guardian', '2024-07-02 15:45:09.892911'),
(40, 'case', '0008_merge_20240324_2035', '2024-07-02 15:45:09.900912'),
(41, 'case', '0008_merge_20240324_1839', '2024-07-02 15:45:09.909132'),
(42, 'case', '0009_merge_20240324_2350', '2024-07-02 15:45:09.917248'),
(43, 'case', '0010_alter_witness_email', '2024-07-02 15:45:10.061259'),
(44, 'case', '0011_case_refer_healthcare_date_and_more', '2024-07-02 15:45:10.192465'),
(45, 'case', '0012_case_date_closed', '2024-07-02 15:45:10.225082'),
(46, 'case', '0013_case_phone', '2024-07-02 15:45:10.274428'),
(47, 'sessions', '0001_initial', '2024-07-02 15:45:10.349631');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('03l4ud72daenxeair13ujs9s7qlbzi24', 'e30:1sGEBc:FgT8BEVTiT2Xidvv_WBofulNC2F8YcviOvXF_7KNjz4', '2024-06-09 17:16:00.547000'),
('1dbs8g1h82r7gvzimrtaf5zajapdak6p', 'e30:1sOZeL:MYh7c1vvmgvunC6nddD5eQrzIYaXzUQ2fKXeXk-RNP0', '2024-07-02 17:48:09.472316'),
('1l4kb435891pkbz3kvn4usw4ruve3rlz', 'e30:1rmUOe:yZ1OQWJsuv1U58_tqxf-m93QnNw9Es3v66vASnUiq5I', '2024-03-19 16:30:32.596000'),
('1tgbvpx9whjw36g3fe6nbla9bhbjofoi', '.eJxVjrkSwiAURf-FWpk8wprS3s6eeRCyaCaMASrHfzeMKbS9y7n3RSyWPNmSwmbnnnQEgJx-RYf-Edbq9Hdcx0h9XPM2O1oj9HATvcY-LJcj-weYME21rYwRoFuFQgvvhVE6BIla-0E7Bt44rzmI3vl2QMckct44bgYVlESGcod-D1R0tEscY8l2wZTtFp4lpLyPsIbxcyPPwG4AHYgOGJVK8taQ9weXvEuN:1sHES8:PnqVGjZwOnxJdjFrRgo0FljOPanfaSRP0PyyL8u0OuI', '2024-06-12 11:45:12.678000'),
('1ywa3dok8fqm6x25gjydzxh5wx3njg1m', '.eJxVjrkSwiAURf-FWplAWB4p7e3smQchi2bCGKBy_HfDmELbu5x7X8RiyZMtKWx27klHGCOnX9Ghf4S1Ov0d1zFSH9e8zY7WCD3cRK-xD8vlyP4BJkxTbWtjJINWowTpvTQaQlAI4AdwnHnjPAgme-fbAR1XKETjhBl00Ao5qh36PVDR0S5xjCXbBVO2W3iWkPI-whsuzo08t-zGoOOyE0CFAmCGvD-Yl0uf:1sCzSG:64IJa63EpzuO--p7ApAA6vuONoE8GRQnyzXx189TU_A', '2024-05-31 18:55:48.473000'),
('24i874t6cagyzlvgynj29wut9f1ytphr', 'e30:1royob:QonutzPsCXNrUV3vXcd68xbkvnSKiZAWw82dd644QiA', '2024-03-26 13:23:37.196000'),
('28bh04y2pdvff37iwf687st141v2kl93', '.eJxVjrsSwiAQRf-FWhlYSEhS2tvZM8tCHpoJY4DK8d9NxhTa3se598UsljzaksJqJ886JtnpV3NIj7Dshr_jMkROccnr5Pge4Yeb-DX6MF-O7B9gxDRubZSk-rZyQta-qoKB1rgeHOqadOibFsEAEaLDpoJegqbakDZOOYLWE2zQ74EdHe0ch1iynTFlu4ZnCSlvIyBAn4U6g76B6rToBHBjtJCKvT-U9Uu2:1roPx4:vKCa8iFU-c-kO4Zx7hLRUrammzmlh4UyjHMEmdud284', '2024-03-25 00:10:02.787000'),
('2wwov8zr5fc1mxhqx51oc1rn0y14n96b', '.eJxVjrkOwjAQRP_FNVg-1ldKejp6a-04B0SxiJ0K8e8kIgW0c7yZF_G41sGvJS1-bElDOCenXzFgfKR5d9o7zn2mMc91GQPdI_RwC73mNk2XI_sHGLAMe9s4p7iVBpVVMSpnbEoarY2dDYJHF6IFrtoQZYdBaARgAVxnktEoUG_Q74Ednf2U-7xWP2GpfknPNZW6jQgm4Mz0mcsbFw2HhknKQABI8v4Al2ZLfA:1sHbqd:wePT8ZVti-eJ_TBT8fNwgwtU9YrXWo2E9rmQWkcdQdk', '2024-06-13 12:44:03.089000'),
('2ym9yyjoavahfevp0n8r529fyc7azj1b', 'e30:1rnzzZ:Q1ezHeWS9cuW83qv8by-Xs5Lnjpqb81A46GkALDNa2s', '2024-03-23 20:26:53.631000'),
('38bi93q9zw6g9grizwhiui75b4coqg2t', '.eJxVT7tuwzAQ-xfNjSDrXY_Zu3UXTtIldmtYrXQagiD_XgvN0AKcSB7Ju7MAnZbQG9awZjYzyV7-chHSJ-5DyB-wXwtPZae6Rj4s_Kk2_lYybuen91_AAm05ro3xGG1yCeFi9EXJCb0TGJ3NymbjwfkImHy0GIXOViNOSisrAeWUXuEIbZh6XekWGgH1NiZhqrcvwlH5O28Ul7CVa-kUNmgUKn53bDQ-E1KfhDpJ_S7VbNw8WS6MO8AeP7EzVwM:1roQDk:1r0i7fsxc0dPMjyC7dLENBxJlB6LOzTvWAxIIyKfOTQ', '2024-03-25 00:27:16.058000'),
('39oslhbzw4a9xc6m4ndrq7xpk7hxb0du', '.eJxVjrtOxDAQRf_FNWvFjp8p6em2t8aTySYQxeBHsVrx78RiC2jnnnvuPFiAVtfQCuWwzWxiQrCXv8cI-EFHT-Z3OG6JYzpq3iLvCH-mhb-lmfbXJ_tPsEJZe9t6r4UbLWinEbW3jsiAc7i4KAX6iE4JPUccF4jSgFJDVH6xZA1IMKe0ELa81XsoFWorp5QOzPfPSn3y970-nMKebqnVsEOpIdNXo1JPWg5SXQZzEeNV2EnKSVs-GiWMYN8_nuhWxA:1sHgfZ:8hGyOXVHn2UjxujB3VfzDmrXpzWa6QEROnnGwoHWFFo', '2024-06-13 17:52:57.372000'),
('3aktfapjxhen3xb17vuuyb7d2jvch7wq', 'e30:1sMPQl:teXJpySFb6TkcPA4iN44uHXWHGaiQp1i0b5yQNIIrww', '2024-06-26 18:29:11.754000'),
('3h1v4kx4zanmrr0p4xu5prwkozdvo3z1', 'eyJvdHAiOiIzMzMxNzMiLCJ1c2VyX3Bob25lIjoiOTA3ODY0NjI3MyIsIm90cF9leHBpcnkiOiIyMDI0LTA2LTExVDIxOjEzOjM2LjA4ODYwMSJ9:1sH1KP:6foa6ccY5-p9WCs0cQhzW7hyIYPLgCNmNoKt8Eo-xR0', '2024-06-11 21:44:21.880000'),
('3j2lt6p4j0nzi01e95hcnjemt0xl8gy3', 'eyJvdHAiOiIxMTk3MzEiLCJ1c2VyX3Bob25lIjoiOTA3ODY0NjI3MyIsIm90cF9leHBpcnkiOiIyMDI0LTA2LTEwVDA2OjU3OjIxLjM3NTgxOSJ9:1sGRSr:TLSnjRCpXEkqpZZhdIUlwasf9djPwikKL2Z2FuJ3EZE', '2024-06-10 07:26:41.665000'),
('4lmvab9yg9w90jw35qg1b4wmy3wxrfd5', 'e30:1rpprj:syWtXrD9THKhj99P4IDsKrJf4mfilN5AbIZSwF_quJU', '2024-03-28 22:02:23.289000'),
('4ogsqqosr5e2n9sri9owpnxlwn8eflpt', '.eJxVjrtuwzAMRf9FcyNYsp4Zu3frLlA0HTsxrFaPISj677XQDAnAiffwXP6wAK0uoRXKYZ3YmQnB3p6XEfBGe0-mK-yXxDHtNa-Rd4Q_0sI_0kTb-4N9ESxQln5tvdfCjRa004jaW0dkwDmcXZQCfUSnhJ4ijjNEaUCpISo_W7IGJJhDWghbXus9lAq1lUNKO-b7V6Ve-f9eL05hS5fUatig1JDpu1GpBy0HqU6DOYnxU_jzMcpw4UdlBPv9A59OVs0:1sHiUc:eZAAIabDG_66OPmFdIKjlfMJ1VHX8gCo0Bucy-EuKhI', '2024-06-13 19:49:46.202000'),
('52wtb2no8xsza108bhy5ubtcglkycuth', 'eyJvdHAiOiI2NjUyMDIiLCJ1c2VyX2VtYWlsIjoic3RhZmZAZ21haWwuY29tIiwib3RwX2V4cGlyeSI6IjIwMjQtMDMtMjVUMDU6NDY6MzEuMzgyMTY4In0:1roVf0:9ZpO47V-otdubTqZRtnQG1-4u0hM_IsPV69wMc8QA1Q', '2024-03-25 06:15:46.526000'),
('5f0y0x38vqf2bxoxx68ji33uq84yizcz', '.eJxVjrlywyAURf-F2mbEIrSU6dO5Zx7wsJRoRAKPwuPJv0eMXdjtvecud2ah0mJrwWzXwGZm2OlVc-C_cW9G-IL9mrhPO-XV8Ybwp1v4Zwq4fTzZt4IFynKkEQNijCPIsZ_ATGoQIE2UyjvUvdGqN-ijwNgFOTjZj8bpKBR4EH4Ixh-lBX3NK91sIaBa2iX0-fZD2CYf99pwslu6pkp2g0I242_FQgctO6nPnTpLcxHjrKdZCa7FpM3A_v4B0EFXQg:1rp4N1:OHVKcoJezwk6InwByS0VvOwWK6N50Mi6PEjT5JFFiPc', '2024-03-26 19:19:31.420000'),
('5keig0f39mi1z52nth2cd4mibhjuewnk', '.eJxVjrsSwiAQRf-FWhlYSAgp7e3smWUhD82EMZDK8d9NxhTa3se598UcrmVwa46LGwNrmWSnX80jPeK8G-GOc584pbkso-d7hB9u5tcU4nQ5sn-AAfOwtVGS6mzlhaxDVUUD1vgOPOqadOwai2CACNFjU0EnQVNtSBuvPIENBBv0e2BHJzelPq3FTZiLW-JzjblsIyBAn4U6Q32TulW2VYI3ILS07P0BlYFLww:1rp0T5:cZGARUIoJRoWftju2MrSB3YBMVWVr0D1Q6FiDk80p1U', '2024-03-26 15:09:31.705000'),
('5yqtbmqykjmupcv0zf59n9wjt2unksv5', '.eJxVjrkSwiAYhN-FWhnuI6W9nT3zQ8ihmTAGqBzf3TCm0HaPb_eFHNQyuZrj5uYedYhSdPoVPYRHXJvT32EdEw5pLdvscYvgw834mvq4XI7sH2CCPLW2tlZSwzVII0OQVpsYFRgTBuMZDdYHI6jsfeADeKZACOKFHXTUChioHfo90NDJLWlMtbgFcnFbfNaYyz7CCBNnos6E3xjtuO2IwIYxLgl6fwCX4kuG:1sE7tw:ayh_n7dSY6SaliSaVPmvRyWa1wZXoNaHi78XOq6W66o', '2024-06-03 22:09:04.826000'),
('651r29ur16al64rk5w77u5ovmpqip7gj', '.eJxVjrtOxDAQRf8lNWvFbzslPd321ngy2QSiGPwoViv-nVhsAe3cc8-dxxCg1TW0Qjls8zANnA8vf48R8IOOnszvcNwSw3TUvEXWEfZMC3tLM-2vT_afYIWy9rb1XnMnLWinEbW3jsiAc7i4KDj6iE5xPUeUC0RhQKkxKr9YsgYEmFNaCFve6j2UCrWVU0oH5vtnpT75-14fTmFPt9Rq2KHUkOmrUaknLUahLqO5CHflclJukpJ5a6XSw_cPn55W1g:1sN4TK:MJ7PKSBNxWC9iHOEgtjBw2E6FY8A3bBy_szNxCK-0UI', '2024-06-28 14:18:34.018000'),
('691tjtdmdd8w1xhonj3ianr2eu4xou8f', '.eJwVi0sKgCAQQO8y64oZUylXHaK9WAwiWIkVFNHds-37PLAdCQxI0go1VHDunC0vLsRCPa_sYsphnXnKzrvB_6aZt6Wk5bR8pZDvkgoUskZdYzcSGVJG9g21HQmE9wNtbh6E:1sFmXc:r7iJMFejl6Z2MXVxRnKxkBtV2rsV9MecbkXyAwomIiw', '2024-06-08 11:44:52.717000'),
('6ne88fvpfnes82ge1ovxxkvbdxvyqkvx', '.eJxVT7tuwyAU_RfmBJmnscfu3bKjC9zEbi3TwmWIov57g5IhWc_73JiHRotvFYtfE5uZZIdXLED8xr0T6Qv2S-Yx71TWwLuEP9nKP3PC7eOpfQtYoC53tzEOg41jRDgbfVZSoBsHDKNNyibjYHQBMLpgMQw6WY0olFZWAkoRJ7iHVoytrHT1lYBa7ZMwlusPYa98zOvF2W_5khv5DSr5gr8NK_Vng9THQR2FO4lplno2ijvhzCTZ3z-xu1cP:1rmB6r:KidSKcNP4_ntcN0eTg6D6D2rK4QuRI_H95OmqAJrXUo', '2024-03-18 19:54:53.822000'),
('6wwg6gohghj4vp2r3v2rxz0ahqr3phvu', '.eJxVjrkSwiAYhN-FWhnuI6W9nT3zQ8ihmTAGqBzf3TCm0HaPb_eFHNQyuZrj5uYedYhSdPoVPYRHXJvT32EdEw5pLdvscYvgw834mvq4XI7sH2CCPLW2tlZSwzVII0OQVpsYFRgTBuMZDdYHI6jsfeADeKZACOKFHXTUChioHfo90NDJLWlMtbgFcnFbfNaYyz7CCBNnos5E3BjpKO-owJJbKQh6fwCXpUuF:1sET2Q:UYKrXw9n-SRv5w2c2mOxTaufnj7geY-bN1M3JXMBWmA', '2024-06-04 20:43:14.555000'),
('6zez60hp8tglczl7cx2br7a4eik5x2ty', 'eyJvdHAiOiI2MTYyMDkiLCJ1c2VyX2VtYWlsIjoic3RhZmZAZ21haWwuY29tIiwib3RwX2V4cGlyeSI6IjIwMjQtMDMtMjVUMDU6NDc6MDIuMTg1MjU1In0:1roVfQ:RTpe-l3-8TOE-9J6yx8W2-6CR9UGNB1Y0E33AdUTMCM', '2024-03-25 06:16:12.247000'),
('70s0ss6y90hy8tg2iv2ckr5cza643irh', '.eJwVi0sKgCAQQO8y65RxLClXHaK9WAwi9BErKKK7Z9v3eWA7ElhAbRS1UMG5c3a8-DgXGnhlP6cc14nH7IPvw2_ktC0lLafjK8V8l5SQaoFGKBxUazVaaiSS0qaD9wNsMR5_:1sGcJu:fFZ6UnswoZusnNyHv9pERClc1GOu1MfSQ6ChpeI0V9M', '2024-06-10 19:02:10.187000'),
('7k4cmawycvfy1t9mb5vy2py1py9ins53', '.eJxVjrsSwiAQRf-FWpmwQAgp7e3smWUhD82EMZDK8d9NxhTa3se598UcrmVwa46LGwNrmWCnX80jPeK8G-GOc584pbkso-d7hB9u5tcU4nQ5sn-AAfOwtVGQ7Kz2laiD1tGANb4Dj6omFbvGIhggQvTYaOgEKKoNKeOlJ7CBYIN-D-zo5KbUp7W4CXNxS3yuMZdtBCpQ50qeobkBtNC0suZam0pY9v4AlcxLyw:1rpqk8:qvgfVcqlSFzCWTWom2hq5FWBeKKiZuSh7SMp9sclTyc', '2024-03-28 22:58:36.572000'),
('7pzcihsg7wntph0jyzys5zbs15m2l6k3', 'e30:1rmAHq:GRwWJfMHnX3F7p5W2Zpp58eQZMm2SnDWDLQlqrPtDLM', '2024-03-18 19:02:10.185000'),
('7u5kc00ter2j48d014baoweivxz17ay5', '.eJxVjrsSwiAQRf-FWhlYSAgp7e3smWUhD82EMZDK8d9NxhTa3se598UcrmVwa46LGwNrmWSnX80jPeK8G-GOc584pbkso-d7hB9u5tcU4nQ5sn-AAfOwtVGS6mzlhaxDVUUD1vgOPOqadOwai2CACNFjU0EnQVNtSBuvPIENBBv0e2BHJzelPq3FTZiLW-JzjblsIyBAn4U6S3uTthWi1Q03WqjasvcHlcdLzA:1rmXD6:6OIj5-rzH-yb8_agdpVOnAefz7t0P_6FUlyYq9-7yaE', '2024-03-19 19:30:48.741000'),
('83ea9e5ir3ggod6kdhahgvg5ghopj06x', '.eJxVjrkSwiAYhN-FWhnuI6W9nT3zQ8ihmTAGqBzf3TCm0HaPb_eFHNQyuZrj5uYedYhSdPoVPYRHXJvT32EdEw5pLdvscYvgw834mvq4XI7sH2CCPLW2tlZSwzVII0OQVpsYFRgTBuMZDdYHI6jsfeADeKZACOKFHXTUChioHfo90NDJLWlMtbgFcnFbfNaYyz7CCBNnos6U3SjrCO8IxURxZTh6fwCXUkuA:1sHFCP:_kWsR-q7DXeSpgOM11udM3yj2d3Ot9Fv304mnU9ydag', '2024-06-12 12:33:01.070000'),
('868p39xrtjckuiieiw9k3p4nslfd986p', '.eJwVi0kKgCAUQO_y1yWmaeaqQ7QXi48IOWAFRXT3bPuGB9KRQYPgQlEBDZw7FoPB-q1ShxHtlouPKy7FOju535A1hZrW0-CVfblryijrWypbyudOaj7onpOxk0IxeD9vIR6W:1sE3Bx:9-90OiuibWZ4_BwFhCuFsfAmNhSdFgxwvkgTW9CAiLU', '2024-06-03 17:07:21.634000'),
('8ftsqrnn43lpuieioudje8iukhc2a3yu', 'e30:1rk041:6CljEDhmdtX9NgWPntCKIB9n-mOrBGOZNxAo45Zalmo', '2024-03-26 19:12:57.895000'),
('9ju2h153vwmjdyrwfo891hj1jvkfzwks', '.eJxVjztTwzAQhP-LaqKRT09cpqej15ykS2zwWKBHkcnkv2MNKaDd3ft278489rb4Xqn4NbGZAXv5qwWMn7QPI33gfs085r2VNfAR4U-38recaDs_s_8AC9bluNbaUTDRRsKLVhcJEzkrKFiTpEnaoXUBKbpgKAiVjCKapJIGkGCKr3hAK8Ve1nbztWHr9YDSHsvtq9Go_J03irPf8jX35jeszRf67lTb-EyAOgl5Av0uzAxuhokrC0ZZ9vgBtBVXDw:1roWKD:d3-pNY5_daBIuZd0pZrmYgK2gVseQseK4xtrHiRU8ls', '2024-03-25 06:58:21.486000'),
('9m3twlg0tupwu514tqsq160w0sp90gub', '.eJxVjrtOxDAQRf_FNWvFjp8p6em2t8aTySYQxeBHsVrx78RiC2jnnnvuPFiAVtfQCuWwzWxiQrCXv8cI-EFHT-Z3OG6JYzpq3iLvCH-mhb-lmfbXJ_tPsEJZe9t6r4UbLWinEbW3jsiAc7i4KAX6iE4JPUccF4jSgFJDVH6xZA1IMKe0ELa81XsoFWorp5QOzPfPSn3y970-nMKebqnVsEOpIdNXo1JPWg5SXQZzEfIq3DTaSRruRqGEZd8_nxdWyQ:1sHLM6:mEmN5L7zTKp9evzyhSObQ_wVvc1OL3TOKbAI3YeYSRE', '2024-06-12 19:07:26.855000'),
('a1r1q4zq5080p5lf6t2i3yigpr1am7sv', '.eJw1zMEOwiAQBNB_2bNt2F2EysmP8N5gs0GSFgjVRGP8d9eD15k384Z6bxCAib1HOMBjlz7LFvOqaZIicW09l0WuPaZ4Tr9mXOqmVJezPFvuL6VkyA7GDYgXpMAu8DSiZTzS_7TdahGVJ-MnZx15hs8X79AlvA:1sGtER:3NdYL1S4MujIIxrdifSnyfAClSQu5vh3YqnZgPMcB1g', '2024-06-11 13:05:39.691000'),
('aacgw2x66h3mnqlp7ofcdk1zfojhybtn', '.eJxVjrsSwiAQRf-FWhmyQCAp7e3smWUhD82EMZDK8d9NxhTa3se598UcrmVwa46LGwNrWcVOv5pHesR5N8Id5z5xSnNZRs_3CD_czK8pxOlyZP8AA-Zha2NFsmu0F1UdtI4GGuM78KhqUrGzDYIBIkSPVkNXgaLakDJeeoImEGzQ74EdndyU-rQWN2EubonPNeayjYAAdRbyDPomdCtsKyQXRlth2fsDlUFLwg:1roV4V:2tnf7pSkFyNNLg7hE9oNa3K2nuxXMmKo2d85LWxpcdI', '2024-03-25 05:38:03.077000'),
('ake70cfjkj8muqxvv3w4pm4519yzpr5b', '.eJxVjrtSxDAMRf_FNeuxLTuvkp6O3qOVlU0gE4MtFzsM_04ybAGt7rnn6ktFbLLEVrnENalJBfX093ZFeuf9DNIb7resKe9S1qs-Ef1Iq37JibfnB_tPsGBdjjaS6y32xicYKLlAKXQMzoMhIh4cIFnA3hEDphT8HMaRuRsgzDx7bw9pZWpllXusgtLqIeWdyv1D-Jz8fe8cznHLt9wkblglFv5sXOWgnXH-YuDiwquxk7WTMXpwXQ-j-v4Bj_FWyA:1roRN6:9zMA0zNy-bGGy7kQperukDEyouqtW9frX-I1PznPZTg', '2024-03-25 01:41:00.827000'),
('b2rwnq8r1iiskx0tg5v2jkmjhgy49wb2', '.eJxVjr0SwiAQhN-FWhk4IEhKezt75jhIombCGEjl-O4mYwpt9-fbfTGPSx38UtLsb5G1TLLDrxaQHmnajHjHqc-c8lTnW-BbhO9u4Zcc03jes3-AAcuwtlGS6pwJQjbRmGTB2dBBQN2QTt3JIVggQgx4MtBJ0NRY0jaoQOAiwQr9HtjQ2Y-5z0v1I5bq5_RcUqnrCAjQR6GO4K5CtVK02nFhdCMUe38AlU5LvQ:1rpv9F:N8t0VRShCULdNFKBZiKr0nsmb9UeFD1ajqg5fRZn1ik', '2024-03-29 03:40:49.063000'),
('b60vk3vtca2gc2uo2fr3y5p4yjuduvrq', '.eJxVjr0SwiAQhN-FWhm4QPBS2tvZM8dBjJoJYyCV47ubjBba7s-3-xSeljr4paTZX6PohBa7Xy0Q39O0GfFG0yVLzlOdr0FuEfl1izzlmMbjN_sHGKgMa5s0Nz3aoHQbrU0O0IUeApmWTeoPSOCAmSjQwUKvwXDr2LjQBAaMDCv0c2BDZz_mS16qH6lUP6fHkkpdR0CB2atmr_Gs206pzqBEVNageL0BldZL0Q:1rmUOv:cNOXbN25EM9ckyOS98OYL0e_0JtgAhpA5OZMlDUoWzg', '2024-03-19 16:30:49.992000'),
('blcgkyiufa6d5wm0q6pf0enn9m2nkgjt', '.eJxVjrluwzAQRP-FdUzwPlSmT-eeWFIrS4kgJjwKw8i_R0RcJO3Omzf7IAF6W0OvWMI2k4lwTl7-HiOkDzxGMr_Dccs05aOVLdKB0Gda6VuecX99sv8EK9R1tK33mjtpQTudkvbWIRpwLi0uCp58TE5xPcckF4jCgFIsKr9YtAYEmFNaMfWytXuoDVqvpxSPVO6fDcfk73tjOIc933JvYYfaQsGvjrWdtGBCXZi5cHnlbGJy4o4a5RyT5PsHnnpWwQ:1sHZo6:H6Q2ZNbAFkr_WnCIS1ngQwiPubMt6rkvl7igGwDHOW0', '2024-06-13 10:33:18.656000'),
('c1hifz7a4vqpndr8lypv9g4c0msbyre0', '.eJxVT7tuwyAU_RfmBvE29ti9W3Z0gZvYrWVauAxR1H9vUDO063mfOwvQaQ29YQ1bZgtT7OUvFiF94DGI_A7HtfBUDqpb5EPCn2zjbyXj_vrU_gtYoa0Pt7Ueo0tTQrhYc9FKop8Exsll7bL1MPkImHx0GIXJziBKbbRTgEqmGR6hDVOvG91CI6DexiRM9fZJOCp_543iEvZyLZ3CDo1Cxa-OjcYzocxJ6JOcz0osZl6s5N44LyX7_gGxjVcI:1rmYud:999fnqNOsmbsRC3okFUMyZ6pgKQcdnmU8zDg8M8PMRc', '2024-03-19 21:19:51.853000'),
('c9aipziej1c5l9gf8oqip68fbybxso0g', '.eJxVjrtOxDAQRf_FNWs5YzuOU9LT0VvjyewmEMXgR7FC_Dux2ALae899fImAra6hFc5hW8QstHj6q0Wkdz66sbzhcUuS0lHzFmVH5MMt8iUtvD8_2H8FK5b1TCNFZDdYMiNPTKTZj4Nz5D1OYI266nHSzsTJej0AOWZAhmiu1mltwZ-lhanlrd5DqVhb6ZeY8v2jcp_8vdeHU9jTLbUadiw1ZP5sXOpJgwJzUfoC5hWGWcGsvDQerDPi-wc-1FXz:1roNUH:hUj-rwx7ElFRQDdgqbejy4PhI5gSS3VlxZn_PHuulxU', '2024-03-24 21:32:09.493000'),
('ckzjbistpm49dmfhwpo55b3c8ntbydy4', '.eJw1jcEKwjAQRP9lz7YsybJxc_IjvJdYlhhokxAtKKX_bnrwOvPezA7lXcGDCIm1cIHtpW3SNaSlp1GzhqW2lGd9tBDDLZ7NOJe1o92c9FNT-3bUoKEBeUC5G_ToPPFo2Qnxf7Q-S9bzCt2ViY2zcPwA-Tol4A:1sGHKS:FhJzHfJx6qBOuJTb92yr9oQ7T1VhP0_svQ6SgiS1z0o', '2024-06-09 20:37:20.877000'),
('cshuzaj0tvlysu7w5vipcc36hu7hxgur', '.eJxVjrkOwjAQRP_FNVi2s75S0tPRW-sjB0SxiJ0K8e8kIgW0c7yZF3G41sGtJS1ujKQlnJPTr-gxPNK8O_GOc59pyHNdRk_3CD3cQq85pulyZP8AA5Zhb2trJTeNRmlkCNJqk5JCY0JnvODB-mCAy-hD06EXCgGYB9vppBUKVBv0e2BHZzflPq_VTViqW9JzTaVuI4IJODN1ZvbGRQtNK4AqCQCKvD-YTUuS:1sGAOq:arUdG6rr1n3PivrZRqHR2BrI1YfvaZ0THK_JIpG02hE', '2024-06-09 13:13:24.662000'),
('cy1caf847csck76ykqvcdkp5g9x36heg', 'e30:1sMprc:eX4zD0vfQIiillWt3QnJjD1hT_NXG-83qj34vt7yH9g', '2024-06-27 22:42:40.522000'),
('d5fpda0ff4vkia0z68gd744487c2iqyz', '.eJxVjr0SwiAQhN-FWhk4CEhKezt75jhIombCGEjl-O4mYwpt9-fbfTGPSx38UtLsb5G1TLLDrxaQHmnajHjHqc-c8lTnW-BbhO9u4Zcc03jes3-AAcuwtlGS6lwThDSxaZIFZ0MHAbUhnbqTQ7BAhBjw1EAnQZOxpG1QgcBFghX6PbChsx9zn5fqRyzVz-m5pFLXERCgj0IdQV1BtiBa4bgxCqxi7w-U-Uu9:1ro1I9:sNkCw41NLfLWzjEz2jmRlri2OiIDa2ubBzyN1oy0B4w', '2024-03-23 21:50:09.664000'),
('dse4yean8u7wqnuf7uc54eyhi70j3ybr', '.eJxVjrtSxDAMRf_FNeuxZTuOU9LT0XtkRbsJZGLwo9hh-HeSYQtodc89V18iYm9L7JVLXGcxCSOe_t4S0jvvZzC_4X7LkvLeyprkichHWuVLnnl7frD_BAvW5WgjJWSvHdmBRyYyHAbtPYWAIzirrmYYjbdpdMFoIM8MyJDs1XljHIRDWpl6Wds91oat10PKO5X7R-Nz8ve9czjHLd9yb3HD2mLhz861HTQosBdlLmBfQU_OT9pLryA4Jb5_AEIGVf4:1roOLd:mOESjl9jELh17sMazpPmVv_CW9l-teMfevaQWkToEQs', '2024-03-24 22:27:17.703000'),
('eb721pkhobsca1ukw8idyys34m2oekri', '.eJwVi0sKgCAQQO8y65JxjERXHaK9WAwilIkVFNHds-37PLAdGSwY1FobaODcuThefVwqDZzYL7nENPNUfPBD-I2Yt7Wm9XR85VjumhJS12LfYjdKsqStQoGSeqng_QBy1B6J:1sELkn:8WAiHDUGVzC1PrFU7v877CCDtFdMDBgMtbbq73nKxTA', '2024-06-04 12:56:33.698000'),
('ee0wxuima4hvs3c4a8m9a3yaxhwkrfqr', '.eJxVjrsSwiAQRf-FWhnY8Agp7e3smWUhRs2EMZDK8d9NxhTa3se598U8LnXwS0mzv0XWMckOv1pAeqRpM-Idp2vmlKc63wLfInx3Cz_nmMbTnv0DDFiGtY2Smt7pIKSJWicLzoYeAipDKvWtQ7BAhBiw1dBLUGQsKRuaQOAiwQr9HtjQ2Y_5mpfqRyzVz-m5pFLXERCgjqI5grsI0WnVgeStgsYY9v4AlWNLww:1rpt1B:JZ7ByFjtSV1ggajISS89IuLzGrwEbVuY48kK4p7uLJM', '2024-03-29 01:24:21.843000'),
('fiiga33tmpxqieix31d98k48qft5tn29', '.eJxlUMtOxSAQ_ZeuvU2hQKEr496dezLQaYv2lsojsTH-u-C9C43LOa85M5-NhpxWnSMG7aZmbAhpHn6DBuwb7pWZXmFffGv9noIzbZW0dza2z37C7emu_ROwQlyre1CKE9kPwCW3lqtBIgqQ0s7SUGKVsZIRPhnbz2CoAMY6w9Q84CCAgiihtwI12uvNLz4nvUFMOuB7xpjKEtpRdunEpaMvpB-pGHvVEtFTxos9os3BpVPHBCnHIsfdhvNIWBv7dNTre8IJLeNPdbyC2wq64I6wHcHtFk2ABR6XypRXXG9OjR-HC-e_BoSPbGgJ4VzR5usbG790cg:1sDdjr:rN8ZPz7PWuvxdcv11TP0aaJqFoJwjInDbfELTKhYfaY', '2024-06-02 13:56:39.448000'),
('fmjilwbzs5l8lfsoweaakhophei682yr', '.eJwVi0sKgCAQQO8y6xKdJitXHaJ9mAwi9BErKKK7Z9v3eWA7IhhQ2LVYQwHnzmnkxYY5U88r2zmmsDqekvW2978Rbltyms-RrxjSnVOUSKXUpaRBSUO1wUZUpFrS8H5u-h6O:1sEKnR:Snkd3JMtbh9_4AmOI_WnwXNbKxWPQRTGu8eapeuzn3Y', '2024-06-04 11:55:13.546000'),
('fshtyjbjzwo3e9fv3qrvdut053t8mf1f', '.eJxVjrlSxDAQRP_FMavSLa1DcjJy1Wg0XhtcFugItij-HavYANLu18fXFKC3NfRKJWxpmiehp6e_YgR8p2M46Q2OW2aYj1a2yAbCHm5lLznR_vxg_xWsUNczvbirMl5ryz1yiOYaJdcLJCE5yeQ4gtECgRanbTLOqugwSedF8gmRzFlaCXvZ2j3UBq3XcYmw3D8ajcnfe2M4hz3fcm9hh9pCoc9OtZ205FJfuL0o_irkLNWsPVPWGWun7x-Eo1ai:1sNm6O:8JYLwL8olyHaleeiDQa4lINgiRleeIYr0K3B6N3ocaQ', '2024-06-30 12:53:48.377000'),
('fti79ihsfgb6tgf9jr75i50qfppk4jga', 'e30:1roLMt:cx9vae_HdOLm8KhGEc-Imj1Edt_g5giiAQI7IVcA_-0', '2024-03-24 19:16:23.232000'),
('gc1sfmdw6d8q1858rq0vb4rol1fruufo', 'eyJvdHAiOiI0ODY0MTkiLCJ1c2VyX2VtYWlsIjoidGVtcHRlc3Q0dGVzdGluZ0BnbWFpbC5jb20iLCJvdHBfZXhwaXJ5IjoiMjAyNC0wNi0zMFQxMToxOTozNC4yMzg4NTgifQ:1sNl5K:SaemjSY0GmDulgjylkYMH3lGlYsua3JxVHNBHXa4MzU', '2024-06-30 11:48:38.535000'),
('gny7829n9g587p5dck154kyfab81apjx', '.eJw1izsKgDAQBe-ytZHN5rfmHPbBIqDgJ0QFRby721jOmzcPbEeBCCE4zQQNnHuuKS_DNMsqLDrlq0z1FiYkq9Ar5F67qCk6bg1r4_Evy7itWZ4dBvbWUzDwfohfGyw:1sFqF6:nprN65Hw1ZVA9ozolHfk8OJn5zp6jS7c-xd3KTxXzSo', '2024-06-08 15:42:00.320000'),
('h7ogm2kouvetxddyqzxdwcg5i4j07lsh', '.eJxVjj0PgyAQhv8LcyVwokjH7t26k-MAtTWSCk5N_3s1dWiTm96P594Xs7iWwa45LHb07MwkO_1qDukR5t3wd5z7xCnNZRkd3yP8cDO_Jh-my5H9AwyYh62NkupoGidk65smaDDaRXCoWlIhdgZBAxGiw66BKEFRq0lpVzsC4wk26HfAjk52Sn1ai50wF7uE5xpy2Z6AAFWJupLmJtV5OyW5NJ2oW_b-AJVyS8M:1rmSkD:QjoFcsMGskNq6IB9vlN6qsxvuMwFKamNqGr_Oxck63c', '2024-03-19 14:44:41.200000'),
('hssqe5e3oegkgqqrskn0hns93w8xc0hr', '.eJwVi0sKgCAQQO8y64rR1NJVh2gfJoMIlWIFRXT3bPs-D8QjgQEle4kSKjh3yhOtNiyFetrILimHzdGcrbeD_03j4lrSck50pZDvknLkokZVMz6y3iAaLpquFVozeD9v0B6S:1sHKlO:YKBtVcsSHsk-gVeSCsutSSaOOx_NEMZlw6EjtoBdR2w', '2024-06-12 18:29:30.762000'),
('i5hvpu98y7owshcdcfocsxzm0o16lkvb', '.eJxVj71ywyAQhN-FOmaAQ4iodJ8uPXPA2VKiETY_hcfjd7cYu0ja3b1v9-7MYauza4WyWyKbmGIffzWP4Ze2bsQf3M6Jh7TVvHjeI_ztFv6VIq3Hd_YfYMYy79fDYMmbMAbC06BPoCTZUZAfTQQTB4uj9UjBekNe6Gg0kQQNRiEpGT5xhxYKLS_15krF2soOpS3k26VSr3zN68XJremcWnUrluoyXRuV2j8TSh8EHBR8KzkpMQFwqQGsZo8ns0lW_g:1ro1IX:ikNc_ogpsUu7Dve4JL0POql4JaTnfThCVmSvP_STlgI', '2024-03-23 21:50:33.144000'),
('iidgmy75b547u7pf2s38lcdbccb5g1q2', '.eJxVT7tSxCAU_RdqlyE8bjDl9nb2zAXubqKZoHApdhz_3WXcQtvzPl8iYOc19EY1bFksQounv1jE9E7HIPIbHtciUzm4blEOiXywTb6UTPv5of0XsGJb727nPEVIcyK8OHsxeiI_K4ozZAPZeZx9REo-AkVlM1iiyVgDGklP6RnvoY1SrxvfQmPk3sYkSvX2wTQqf-eN4hL2ci2dw46NQ6XPTo3HM6XtSZmTtq9KLRMsykljwAGI7x-wpVb8:1ro42P:lPjkLne69Xhv4P-xXLKH-ZpqhMNqBJ4qeSe1pIaSumA', '2024-03-24 00:46:05.337000'),
('iitvo61ojrnsn8j2widgtk0aqtlpeo0o', 'eyJvdHAiOiI1MDU2MDIiLCJ1c2VyX3Bob25lIjoiOTA3ODY0NjI3MyIsIm90cF9leHBpcnkiOiIyMDI0LTA2LTEwVDIzOjI2OjM0LjM1ODY4OSJ9:1sGhH9:Ck1cFfZGDeRfpfNWRfYZkfonJimRpqi9GTXkuLsecRk', '2024-06-11 00:19:39.737000'),
('ixewyvvco43cw3bffbeiclo5oer32cep', '.eJxVjrsSwiAQRf-FWpmwgRBS2tvZM8tCHpoJY4DK8d9NxhTa3se598UsljzaksJqJ886JtjpV3NIj7Dshr_jMkROccnr5Pge4Yeb-DX6MF-O7B9gxDRubRRU90a5SjReqaDBaNeDQ9mQDH1rEDQQITpsFfQCJDWapHa1IzCeYIN-D-zoaOc4xJLtjCnbNTxLSHkbgQrkuarPwtyE7oTsVMulNpUU7P0BlfhLzA:1rmVYg:XkUyfnj8FLPfie-UM-Knh4kaFOcnwUPrU2RndIqwr9U', '2024-03-19 17:44:58.482000'),
('j737khu3x8zkkfkz7k32uc0dvwasgihx', '.eJwVi0sKgCAQQO8y64zRJM1Vh2gvFoMIpWIFRXT3bPs-D6QjgwE9YIccGjh3KpY2F9ZKPUVyay4hLjQX593of9MuaatpPS1dOZS7pgKFZNgzVBPvjZRGqJZ3SnIN7wdtgR6O:1sFVCB:gehjI_YTWl0TvBhftoWzDUjmFyKUnlHN7OEM1eyNj2Y', '2024-06-07 17:13:35.310000'),
('k9c55pkgjwjxj7xe9sul6v7zl9bev032', '.eJwVi0sKgCAQQO8y6xKdTNNVh2gfFoMIVmIFRXT3bPs-D2xHAgvcCDQdVHDulEdaXIiFelrJxZTDOtOUnXe9_w2bt6Wk5RzpSiHfJUWOsuaq5noQykppG2RGt0IhvB9wPx6Y:1sFVCE:vzUkKG_Rk2fo9K4aGPI1Ype7e8FuEcePPR6HIt6GDmg', '2024-06-07 17:13:38.911000'),
('ka8yf3cm6anyg4890o9qh9iw4l5lfdgs', 'e30:1sG8vd:rVfS8wohaov8UcsKoEZBzks15da11gBUUkSvgESSk2Q', '2024-06-09 11:39:09.959000'),
('kl6y7yocrrdo9hly0gbc7b9a809xb5bo', '.eJwVi0sKgCAQQO8y6xJnMitXHaJ9WAwiWIkVFNHds-37PLAdEQwgqlojFHDunEZerA-ZOl7Zhpj8OvOUrLO9-42YtyWn-Rz5ij7dOSVJqpS6pHaQjVGNQRJKYkcVvB9sXR6G:1sMyqk:UuxfukaosXmUOuvd-owmQGfyN_bPTqrcA-4DDwCC28A', '2024-06-28 08:18:22.612000'),
('ksew4c6mw39axkkzqo4y1s8syh7j1vnt', 'e30:1rmXm5:7l0S_m1dYgLGvWGNA48bym4k2uGNA9IKq67bR6I3Mw4', '2024-03-19 20:06:57.311000'),
('lwwl2b13iwoogz34c6l02bl1rd12lnk1', 'e30:1roPfn:q6WAb98PqszJ-IC5Rpd6DmeANrfwD5N0V3_Ua5QALRw', '2024-03-24 23:52:11.719000'),
('mg96b7k5450wozvx2ve3wdzr734yr7wj', '.eJxVjztvAyEQhP8LdYx4Q650ny49WmDtu-R02DwKy_J_9yG7SNqZ2W9m78RDb7PvFYtfEpmIIB9_tQDxF7dhpB_YzpnGvLWyBDoi9O1W-pUTrsd39h9ghjrv11o7DCbaiHDS6iQFR2cZBmuSNEk7sC4ARhcMBqaSUYhcKmkEoODxE3ZoxdjL0m6-Nmi97lDcYrldGo7K17xRnP2az7k3v0JtvuC1Y23jMybUgcmDMN9cTUJMTFNjuJCWPJ6zyFcG:1rp0CD:SkOlXqRIwuxpbqd8Z2IVizj79l3PKtXJEbQt46hjDmQ', '2024-03-26 14:52:05.684000'),
('mohrvx4h8dclxaws9mnoim1nrawetgde', '.eJxVjrkSwiAYhN-FWhkgnCnt7eyZnyOHZsIYoHJ8d8OYQts9vt0XslDLZGuOm50D6hGl6PQrOvCPuDYn3GEdE_ZpLdvscIvgw834mkJcLkf2DzBBnlpbGSOo7hQILbwXRukYJWjtB-0Y9cZ5zakIzncDOCaBc-K4GVRUEhjIHfo90NDJLmlMtdgFcrFbfNaYyz7CCONnIs_U3KjpqeqJxJJwziV6fwCYtkuW:1sJtJL:zUHF3D1KZ_aXzg-tfKJ8B9YnXsieDow0w5fw8wytTt0', '2024-06-19 19:47:07.098000'),
('mun4b6r44o0wbdnis76ndra7725yhn3i', '.eJxVjrsSwiAQRf-FWpmwQAgp7e3smWUhD82EMZDK8d9NxhTa3se598UcrmVwa46LGwNrmWCnX80jPeK8G-GOc584pbkso-d7hB9u5tcU4nQ5sn-AAfOwtVGQ7Kz2laiD1tGANb4Dj6omFbvGIhggQvTYaOgEKKoNKeOlJ7CBYIN-D-zo5KbUp7W4CXNxS3yuMZdtBCpQ50qeQd2EbSW0WvFG1Lax7P0BleBL1g:1roM5u:LE53NK3kDw-QjGQQ7NTdprIKRymFmelDTTgN-Sne9f4', '2024-03-24 20:02:54.817000'),
('o13wd1rmgv9nru81my6x6dlamgty1bam', '.eJxVjMsOwiAQRf-FtSEy5VFcuu83kJkBpGogKe3K-O_apAvd3nPOfYmA21rC1tMS5iguQonT70bIj1R3EO9Yb01yq-syk9wVedAupxbT83q4fwcFe_nWqHjI3tBZ2WhMcuAdZSDUlnXKo0dwwIxIOBrICjRbx9rRQAw-Moj3B_V3OIc:1rjzkN:FB616ApfjkjpV5uekoHpwLmFRZp6NhVMiNwSLNiCgNM', '2024-03-26 18:52:39.406000'),
('pahayq4gm8chmy78w6xxga275xn3q1nq', '.eJxVjrkSwiAYhN-FWhkgnCnt7eyZnyOHZsIYoHJ8d8OYQts9vt0XslDLZGuOm50D6hGl6PQrOvCPuDYn3GEdE_ZpLdvscIvgw834mkJcLkf2DzBBnlpbGSOo7hQILbwXRukYJWjtB-0Y9cZ5zakIzncDOCaBc-K4GVRUEhjIHfo90NDJLmlMtdgFcrFbfNaYyz7CCONnIs-E34jqKe2ZxIIpoQl6fwCX9UuM:1sEGpq:RFKXfZK2xhuN5tNkSFcvhOMF7apbuSD4VjGHqrT8IVY', '2024-06-04 07:41:26.545000'),
('pq7uvop551rewda3q18nb0ucvmq0b7nw', '.eJxVjztvAyEQhP8LdYx4Q650ny49WmDtu-R02DwKy_J_9yG7SNqZ2W9m78RDb7PvFYtfEpmIIB9_tQDxF7dhpB_YzpnGvLWyBDoi9O1W-pUTrsd39h9ghjrv11o7DCbaiHDS6iQFR2cZBmuSNEk7sC4ARhcMBqaSUYhcKmkEoODxE3ZoxdjL0m6-Nmi97lDcYrldGo7K17xRnP2az7k3v0JtvuC1Y23jMybUgckD19_MTppNzFBrLVeMPJ6z91cJ:1rkupq:mAkfstUqVP7WZgJEySQkI8bPiOQZk98RQANZPRxGZ_I', '2024-03-15 08:20:06.780000'),
('pxuntaz5avh4hvi849982c4xry3zcu9y', 'e30:1roLW0:y1Dh6Hrb3B5w37IDGuvtsAGXmcrJXhhbzaDkXemwOX0', '2024-03-24 19:25:48.119000'),
('pyckjw8qa0uyevxm06kzzuccv1nrn8um', '.eJxVjrtuxCAQRf-FOotgePhRpk-3PRpgWDuxTGKgWK3y7zHKFkk799xz58Ectrq4Vuhwa2Qzs-zl781j-KC9B_Ed91vmIe_1WD3vCH-mhb_lSNvrk_0nWLAsZ5soEqU0IoxmQjupQSLYBCp40sZqZSyFJCmJCIMHM1qvk1QYUIYh2nBKC4V2rPXuSsXaSpfu4bh_VuqTv-_14ey2fMutug1LdQd9NSr1pEGAvgh1AXuVMBs9i5HDpBQI9v0D0ohXOg:1royp6:HLtdDPyVwhjTiV_S0irTe5jfZd83lbgkVBVb7cQDwEg', '2024-03-26 13:24:08.293000'),
('q2vno4f3x2hx492toanc6l6xnahtb1fq', '.eJxVjztzwjAQhP-L6qDRy2fFJX269JqTdGAnHgv0KBiG_441UCTt7t63e3fmsNXZtULZLZFNTLGPv5rH8EtbN-IPbufEQ9pqXjzvEf52C_9KkdbjO_sPMGOZ9-thsOQhjIHwNJiTVpLsKMiPEDXEweJoPVKwHsgLE8EQSW00KCQlwyfu0EKh5aXeXKlYW9mhtIV8u1Tqla95vTi5NZ1Tq27FUl2ma6NS-2dCmYPQBwXfSk5CTlJzAwasZY8ns6RXCw:1rp6QT:VFlamreS_BraISoNgFA6Ku7iXcBXCFebpfUuwwWfy0s', '2024-03-26 21:31:13.624000'),
('qmn6fqubw97sq7zrg8ud8t32n9ln55t7', '.eJxVjrsSwiAQRf-FWpmwQAgp7e3smWUhD82EMZDK8d9NxhTa3se598UcrmVwa46LGwNrmWCnX80jPeK8G-GOc584pbkso-d7hB9u5tcU4nQ5sn-AAfOwtVGQ7Kz2laiD1tGANb4Dj6omFbvGIhggQvTYaOgEKKoNKeOlJ7CBYIN-D-zo5KbUp7W4CXNxS3yuMZdtBCpQ50qehb0J1WpoheYSrBSWvT-VjEvG:1rmTKZ:NuCMQRx6WG-e7OkCBFpLyl6W6ECVAWRXsX4Y5P4IZsM', '2024-03-19 15:22:15.330000'),
('qp79e6w96ln5bxyjwcen51u0elvuaqon', '.eJxVjz1TxCAQhv9Lao8BAoFLaW9nzyzL5hLNBIWluHH874bxCm33ffb9-BoCNF5Dq1TCloZ5UGZ4-nuMgO90dCW9wXHLAvPBZYuiI-KhVvGSE-3PD_afwQp1Pb8Xdx2tN2aSHiVEe41amgWS0pJ0chLBGoVAizNTsm4ao8OknVfJJ0Syp2klbGXje6gM3GqvRFjuH0w98rdeD85hz7fcOOxQORT6bFT5pLXU5iLdRapX5WY5zloJa60_J3__AIRaVpY:1sOCwT:jUUtjZ-lN7ZATc4-Vo60oybcH946ktYaca9PVrF4sWM', '2024-07-01 17:33:21.555000'),
('rmt1vgodfdyutei7mzoqi0e9n64rmgf8', '.eJxVjrkSwiAURf-FWhl2Hint7eyZByGLZsIYSOX47yZjCm3vcu59EY9rHfxa0uLHljSEc3L6FQPGR5p3p73j3Gca81yXMdA9Qg-30Gtu03Q5sn-AAcuwt61zmoO0qEHHqJ2FlAwCxA6C4NGFCIrrNkTZYRAGlWJBuc4ma1Cg2aDfAzs6-yn3ea1-wlL9kp5rKnUbEUyoMzNn5m7MNRwaaak0Sigg7w-Y10uc:1sG7Ch:OFOGv7QWUD-u5H7KNQeEdW0I6hIEqBqGhYM5acbtTI4', '2024-06-09 09:48:39.955000'),
('sjk0qczbztbiqxcirbjn5ytg3symn8yi', '.eJxVjrtOxDAQRf_FNWvFjp8p6em2t8aTySYQxeBHsVrx78RiC2jnnnvuPFiAVtfQCuWwzWxiQrCXv8cI-EFHT-Z3OG6JYzpq3iLvCH-mhb-lmfbXJ_tPsEJZe9t6r4UbLWinEbW3jsiAc7i4KAX6iE4JPUccF4jSgFJDVH6xZA1IMKe0ELa81XsoFWorp5QOzPfPSn3y970-nMKebqnVsEOpIdNXo1JPWg5SXQZzEeNVuEmMk1bcSj8Yy75_AJ8IVsw:1sHhSs:jPYGBunbP7D0bvEmvlplLe_txOKco1Ykt2V0JQxRUdA', '2024-06-13 18:43:54.735000'),
('sky3ncsuex04kw6rf75yrbv7fs7bwg4v', '.eJxVjrtOxDAQRf8lNWvZ3nHspKSno7fG48kmEMXgR7FC_Dux2ALae899fA0eW119K5z9Fod5UDA8_RUD0jsf3YlveNySoHTUvAXREfFwi3hJkffnB_uvYMWynunFTlfjAEbpSGIwU9ASFoxKS9bRSkIDipAXC2M0drwGS1Fbp6KLRGzO0sLU8lbvvlSsrfRLTPn-UblP_t7rw8nv6ZZa9TuW6jN_Ni71pLXUcJHjRU2vWs0AMxhhwDmrh-8fhUFWqg:1sJvcD:u2_vIeRCBoDsEmv23lTA75F0fYP9aKptJ8OZAeDZ94o', '2024-06-19 22:14:45.548000'),
('sz28el9ca6liraxwii4spbdzufex8dvd', 'e30:1sGCI5:UNEj02aK782edMttAaKrUmQSAMhXXGJdigY3Z3CbYj4', '2024-06-09 15:14:33.885000'),
('u6j08xey11jw71yz6esfx1nt6jpdvlc8', 'eyJvdHAiOiI3ODY1OTkiLCJ1c2VyX2VtYWlsIjoiZ2VuZWFscHJpbmNlYnJhZ2FAZ21haWwuY29tIiwib3RwX2V4cGlyeSI6IjIwMjQtMDYtMzBUMTE6NTQ6NTAuMDczOTkxIn0:1sNldc:itfu32A-k04yFFh6yH1EIZWmcarvv0fSNy8GUikBKG8', '2024-06-30 12:24:04.522000'),
('u7n89qisigy3vcnrq68yctepklyvtgtu', '.eJwVi0kKgCAUQO_y1ynOmKsO0V5MPiI0iBUU0d2z7Rse2I4CDji3xmro4NyxelxCnhtNuGKYS81rxKmGFIb0Gxq3paXt9HiVXO-WCiYUYYZINjLrpHC6p1oqozm8H3AKHpU:1sNiU7:43PM_dkpVBdM2FxLNAQTYRAUDbYuHnqmDEFaKBGDdJA', '2024-06-30 09:02:03.187000'),
('uh3kxjepq5ricqnfhj2riwt7zm2uzblp', '.eJxVjrsSwiAQRf-FWhmyQEhS2tvZM8tCHpoJYyCV479LxhTa3se598Usbnm0WwqrnTzrWMVOv5pDeoRlN_wdlyFyikteJ8f3CD_cxK_Rh_lyZP8AI6axtLEi2bfaiar2WgcDrXE9OFQ1qdA3LYIBIkSHjYa-AkW1IWWcdAStJyjQ74EdHe0ch7hlO2PKdg3PLaRcRkCAOgt5BnkD0UndiZqXQakUe38AlNVLtg:1ro0aY:qQn1joxkHfWnx0ic5NreY3heNWuBhXqTh4idkFlFOrg', '2024-03-23 21:05:06.023000'),
('v0tjr3f6mi8uzigsjo53adjmvn3qm0cx', 'eyJvdHAiOiI3NTQwNzQiLCJ1c2VyX3Bob25lIjoiOTA3ODY0NjI3MyIsIm90cF9leHBpcnkiOiIyMDI0LTA2LTExVDAxOjU2OjEwLjMxNzI5NyJ9:1sGjG8:_WyqPwCFqv1NORK8yi6dfNo-z0oSghuyURLPyuMKmic', '2024-06-11 02:26:44.241000'),
('v1lk13jm8sw90oqa6e5gn9cg2s4tc8yy', '.eJxVjrtOxDAQRf_FNWvFjp8p6em2t8aTySYQxeBHsVrx78RiC2jnnnvuPFiAVtfQCuWwzWxiQrCXv8cI-EFHT-Z3OG6JYzpq3iLvCH-mhb-lmfbXJ_tPsEJZe9t6r4UbLWinEbW3jsiAc7i4KAX6iE4JPUccF4jSgFJDVH6xZA1IMKe0ELa81XsoFWorp5QOzPfPSn3y970-nMKebqnVsEOpIdNXo1JPWg5SXQZ9GcVVikmN02C4UN5Zzb5_AJ6gVsg:1sD2XC:PLJA6SGVn64nPKcFLjeirUJozZpszVeqK_kWEPY144Y', '2024-05-31 22:13:06.159000'),
('v4rpkoygm71g0u2yhxd7ami189b5m7ej', '.eJxVjrtywyAQRf-F2mbEU0hl-nTumQUWS4lGJDwKjyf_HjF2Ybd7zz1378RCq4ttBbNdA5mJJqfXmwP_jXsPwhfs10R92mteHe0IfaaFfqaA28eTfRMsUJajjRgQYzTAjZpAT2JkwHXkwjuUSkuhNPrIMA6Bj44ro52MTIAH5seg_SEt6Fte682WCrWVLt19vv1U7JOP9_pwslu6plbtBqXajL8NSz1oPnB5HsSZ6wuTs5hmoehgJqMl-fsH0xJXTw:1rp0T9:BuIhGZ-Oz9jSAQpJ9rPkSoVEHIoOS1t4kojX-82qnw0', '2024-03-26 15:09:35.090000'),
('vt61ymt9oljy3oh10v9z59ukhno3792v', '.eJxVjMsOwiAQRf-FtSEy5VFcuu83kJkBpGogKe3K-O_apAvd3nPOfYmA21rC1tMS5iguQonT70bIj1R3EO9Yb01yq-syk9wVedAupxbT83q4fwcFe_nWqHjI3tBZ2WhMcuAdZSDUlnXKo0dwwIxIOBrICjRbx9rRQAw-Moj3B_V3OIc:1rkkP2:BG73KiddW03sQYknszASzzCunaS-mgx7kWIoLMKfnlY', '2024-03-28 20:41:44.645000'),
('w8xxxjtdtoxbpwrdgv1ko9a35bwmjpfn', '.eJxVjrlyxCAQRP-F2EvBgNAROne2OTXAsJKtEjZHsLXlf7cob2Cn3a-PB7PY6mpboWy3wBZm2MtfzaH_oKMb4R2PW-I-HTVvjneEP93C31Kg_fXJ_itYsaxnmigQxTghTMOMZlajRDARlHekB6PVYMhHSVEEGB0Mk3E6SoUepR-D8WdpId_yVu-2VKyt9Evk8_2zUp_8vdeHk93TLbVqdyzVZvpqVOpJgwB9EeoC5gpigWkRmut5NlKy7x_Pwlc3:1rp5uO:i_I1uPFOL9W-lrJ9HNPSDcUXW1vGt-KIPeRDy1c_X58', '2024-03-26 20:58:04.500000'),
('w9gecfoudvv9zl299jd51j318r5fwwax', '.eJxVj71OxDAQhN_FNWcl_ndKejp6a23vXQJRDPa6OCHenVhcAe3M7DezXyxApzX0hjVsmS1MsKe_WoT0jscw8hsct8JTOahukY8If7iNv5SM-_Mj-w-wQlvPa60dRpNsQrhqdZViRmcnjNZkabJ2YF0ETC4ajJPKRiHOUkkjAMWcPJzQhqnXje6hEVBvJxSPVO8fhKPyd94oLmEvt9Ip7NAoVPzs2Gh8Ngl1meRFmNfZL9ouynOlvPWWff8AtRpXKg:1rp5R7:giEjpFSuKffdvNOEZMaA75J4p5-xQ32-yrNCQog8MVI', '2024-03-26 20:27:49.465000'),
('wgagw2d76gab65uy9z3gsagfpip259ol', '.eJw1zEEOgyAQheG7zFrNMCAoqx6ie0PNBEkUCG2TGtO7Fxbdvv_LuyC9MligSY5CQgfvJ5clbylyXWc0k1aaTCsVLvzJoZzNI6kedS_EHWdLyiINhNKM-v_Bhwt7lZ4juz2XEFd-FOfdzbcyrOmA7w_cqSW8:1sGqE3:WcN30zPAGZnfzTukcXWeGaq9z1d7FSFaEzV6keRsqyU', '2024-06-11 09:53:03.756000'),
('wim7ut6yvvey58awdje7zegczo38njml', '.eJxVjrtuxCAQRf-FOovGAxjsMn267RGPYe3EMgmPYrXKv8dWtkjaueeeOw9mXW-L7ZWKXSOb2che_t68Cx-0n0F8d_st85D3VlbPT4Q_08rfcqTt9cn-EyyuLkc7xckjKtQDGdQmBUhjCKC1TBoMoIhSiCnK0TkfpMEkUJLUoAYTtFH-kFYKvaztbmtzrddDSnso989G5-Tve-dwtlu-5d7s5mqzhb461XbQCCgvIC44XWGYAWYYOQilUbHvH_x_VYY:1rpt6k:AMcX5KwUF5x3SdrMh7-pZyy4ViU09-wEypNwBsW8R3Q', '2024-03-29 01:30:06.037000'),
('wozh80bzp2nzdm4bfhbf1b6qwvr6s5ne', '.eJxVjrtOxDAQRf_FNWvZXj9T0tPRW-PJZBOIYvCjWCH-nVhsAe3cM-feLxahtzX2SiVuM5uYlOzp7zEBvtMxkvkNjlvmmI9WtsQHwh9p5S95pv35wf4TrFDX8e1CMNJfHRhvEE1wnsiC97j4pCSGhF5LMye8LpCUBa1F0mFx5CwosKe0EvaytXusDVqvp5QOLPePRqPyd94oznHPt9xb3KG2WOizU20nrYTSF2EvQr0KPyk5ac2tPWc59v0DnvZW0g:1sDYym:Fbuv0eQJxMpZnRh-MDlJH5AH5Z8AKn-Gg3bFTconfcw', '2024-06-02 08:51:44.672000'),
('wwl3rf1avoh0hg4i9hfmnnnbtm34yzxh', '.eJxVjrsSwiAQRf-FWhnYQAgp7e3smWUhD82EMZDK8d9NxhTa3se598UcrmVwa46LGwNrmWSnX80jPeK8G-GOc584pbkso-d7hB9u5tcU4nQ5sn-AAfOwtVFS1VnthayD1tGANb4Dj6omFbvGIhggQvTYaOgkKKoNKeMrT2ADwQb9HtjRyU2pT2txE-bilvhcYy7bCAhQZ1GdQd-EbKVtRc2l0FpZ9v4AlRVLvw:1roRUw:_DNpLg3fiyHoV_3hPjUJHaxByOHYyxJs1xXLU9Qskak', '2024-03-25 01:49:06.108000'),
('x20gkgx5fy6a7bsunwojuwyr12ihra11', '.eJxVjrsSwiAQRf-FWhnYQAgp7e3smWUhD82EMZDK8d9NxhTa3se598UcrmVwa46LGwNrmWSnX80jPeK8G-GOc584pbkso-d7hB9u5tcU4nQ5sn-AAfOwtVFS1VnthayD1tGANb4Dj6omFbvGIhggQvTYaOgkKKoNKeMrT2ADwQb9HtjRyU2pT2txE-bilvhcYy7bCAhQZ1GdQd2EaKVuteC2Vo2R7P0BlSBLww:1ro42A:7701B0eb1hXLzQGlPDwXKGSwP3ZA08FaizMxznQ9P-Y', '2024-03-24 00:45:50.966000'),
('xyorokv07pakvrrupb8ip2ukj7wpfuum', 'e30:1rkMvg:1zIH8Z2KGp0tBdtyuZmHzIHw28W7ud_28tIp17DBzm0', '2024-03-27 19:37:52.186000'),
('xz2z37l0cjf6ak9ebf7zz6j44r1s8xmz', '.eJxVj72OAjEMhN8lNUSbn00CJf1110dOYtg9VhtInAKd7t3ZCApOcuUZfzP-ZR4aTb5VLH5O7Mgk233uAsQrrl1IP7BeMo95pTIH3i38rVb-lRMup7f3H2CCOm3X4-gwmGgjwnnUZyUFOjtgsCYpk0YH1gXA6ILBMOhkNKJQWhkJKEU8wAatGFuZ6eErAbW6QXGN5XEj7JGvej04-yVfciO_QCVf8N6wUv9skHo_qL1U38Idt1GaW2GF0OzvCbQZVwo:1rnySQ:or4N8Exy_KCBjKu_d-qm-PRh2ZPCKT4SezdD4ZWZeBo', '2024-03-23 18:48:34.740000'),
('yfk8g6q6oj1yewuvpvbduycbdhkjlhsv', '.eJwVi0sKgCAQQO8y65JJzcxVh2gvFoMIZWIFRXT3bPs-D2xHAgMauZAKKjh3ypZWF5ZCPUVyS8ohzjRl593gf8PmbS1pOS1dKeS7pBy5rFHVqEfsDVem6ZnoULYdvB9uXx6W:1sFkzK:pssSjTDz0MbsnBHJTv1ipGZbjCOMDCYde1F1MtRVEnE', '2024-06-08 10:05:22.148000'),
('yiqngl30pep3zji8gdua5nrdl3fc9tl9', '.eJxVjjtvwzAMhP-L5lTQI5Rlj9m7dRdoiYrdGlaixxAU_e-V0QwpwIHgfby7b-aw1cW1QtmtgU3MsNPrbUb_RfshhE_cr4n7tNe8zvxA-FMt_D0F2i5P9p_BgmXp31JF8jGOIDxhADmcBWmrNfkhaIhCWEUQpTSzNcqgUgCmL7NGkoPBsZsW8i2v9eFKxdpKN6Xd58et0hH5V-8ITm5L19Sq27BUl-neqNROK6HOb6KP_JB2AjNpyxWMYAb28ws0GlX0:1rrFLC:btxe90CuoPDCJDkCfw5EwDcFUsL0GF7ArgNNnD01jXM', '2024-04-01 19:26:38.261000'),
('yn28qgv2h0v9fofzyeyopmtfh16ccen0', '.eJxVjrsSwiAQRf-FWhlYXialvZ09sywkUTNhDKRy_HeTMYW293HufTGPSx38UtLsb5G1TLLDrxaQHmnajHjHqc-c8lTnW-BbhO9u4Zcc03jes3-AAcuwtlGS6hoThLTRmOSgcaGDgNqSTt2pQXBAhBjwZKCToMk60i6oQNBEghX6PbChsx9zn5fqRyzVz-m5pFLXERCgj0IdQV1BtAJaabmzQoFh7w-UwUu2:1ro04m:ugmq2Bc2-f7NSsrNT2hC8OEqoASHMjsMm5twmqR_pyk', '2024-03-23 20:32:16.763000'),
('yslks2cad7twyfxquwtct990wc157rb7', '.eJxVjrsSwiAQRf-FWhlYICQp7e3smWUhD82EMZDK8d9NxhTa3se598UcrmVwa46LGwNrmWSnX80jPeK8G-GOc584pbkso-d7hB9u5tcU4nQ5sn-AAfOwtVGS6hrjhayCMdFCY30HHnVFOnZ1g2CBCNFjbaCToKmypK1XnqAJBBv0e2BHJzelPq3FTZiLW-JzjblsIyBAn4U6Q30D1RrZGuCmFsJq9v4AlY1Lww:1rps2i:ErALAZ6xyh-Ybg4UxwYqPZwVDiO-VWbldaqlF-JXlvE', '2024-03-29 00:21:52.594000'),
('yvd48r8ib1rcgmja4etwjcz60lr2e27h', 'e30:1sEQ1Y:RW25YfK3Nne8hnLQx1hJlQzRDZfKlbsDZ-7Kf4cvpEY', '2024-06-04 17:30:08.521000'),
('yx6i9wk96inv5es0phymwn7n2a0yivym', '.eJxVjrkSwiAURf-FWhkgLI-U9nb2zGPJopkwBlI5_rvJmELbu5x7X8ThWge3lrS4MZKWcE5Ov6LH8Ejz7sQ7zn2mIc91GT3dI_RwC73mmKbLkf0DDFiGvW2sVRwagwpUCMoaSEkjQOjACx6sDyC5ij40HXqhUUrmpe1MMhoF6g36PbCjs5tyn9fqJizVLem5plK3EcGEPDN9ZnDjum1sK4AqbpVR5P0BmOpLoQ:1sFrbk:Jn2602D3idyuanl8NWM_7tNJ6KUXb4fjcjdEenJcXzA', '2024-06-08 17:09:28.779000'),
('yx8zzmiim89mpznjdaf9bk5zqw58z4br', '.eJwVi0sKgCAQQO8y64rJX-KqQ7QXi0GEUrGCIrp7tn2fB9KRwYAYtEaEBs6diqXNhbVST5HcmkuIC83FeTf633RL2mpaT0tXDuWuKUMmWlQtion1hqORutNKSsXh_QBvUx6V:1sEUEn:aJ-k7jqtv40cqGIKcfsdcMeHn8d_ZdCKDcJ8pw9XYpI', '2024-06-04 22:00:05.709000'),
('z3tygywokv1sroeopvj6v2o6pxgzjw1d', '.eJxVjrtOxDAQRf_FNWvFjp8p6em2t8aTySYQxeBHsVrx78RiC2jnnnvuPFiAVtfQCuWwzWxiQrCXv8cI-EFHT-Z3OG6JYzpq3iLvCH-mhb-lmfbXJ_tPsEJZe9t6r4UbLWinEbW3jsiAc7i4KAX6iE4JPUccF4jSgFJDVH6xZA1IMKe0ELa81XsoFWorp5QOzPfPSn3y970-nMKebqnVsEOpIdNXo1JPWg5SXQZzkf4q_DTqSWqu_SCkZ98_n6NW0Q:1sNWMX:pYkzfE4i7-m0o3JKeD_VnVbSXSliMke8FgCLn0msEVM', '2024-06-29 20:05:25.872000'),
('zied2qdntp7vt89u8d8kc0aywww46rw4', '.eJxVjrkSwiAYhN-FWhkgnCnt7eyZnyOHZsIYoHJ8d8OYQts9vt0XslDLZGuOm50D6hGl6PQrOvCPuDYn3GEdE_ZpLdvscIvgw834mkJcLkf2DzBBnlpbGSOo7hQILbwXRukYJWjtB-0Y9cZ5zakIzncDOCaBc-K4GVRUEhjIHfo90NDJLmlMtdgFcrFbfNaYyz7CCONnIs_E3IjqieipwIZpzgh6fwCYbkuQ:1sG57b:3bpFYG2nTLX3xaL-0sQnI8hV70FBfdRdZfN7JcKgDUY', '2024-06-09 07:35:15.948000'),
('zs1oyvrey0yqp38qkd65t1gl7p6fo4xn', '.eJxVjrtuwzAMRf_FcyNQsmTJHrt3yy5QFB27NaxWjyEI-u-10QztynvuuXx0HltdfCuc_Rq7qZO6e_l7DEgfvJ9JfMf9lgSlveY1iBMRz7SItxR5e32y_wQLluVoz3bsjdN6AEeAwYxBgZ4xSgWsogVCoyUhz1YP0dihD5aisk5GF4nYHNLC1PJa775UrK0cUt4p3z8rn5O_753DyW_pllr1G5bqM381LvWgFSh9AXsBeZX91MOkR2GdGsB03z-HZlam:1sO9cn:A512VErvRN2aquBlbwocuExwAmb3crSKF_I1ZudD4r4', '2024-07-01 14:00:49.782000'),
('zv0994p466a1yjye9nnm158vb3nvfpeh', '.eJxVjrtSxDAMRf8lNetxJCeOU9LT0XtkRbsJZGLwo9hh-HecYQtodc89V1-dp1pWX7Mkvy3d3GH39PcWiN_lOIPljY5bVByPkragTkQ90qxe4iL784P9J1gpr61NHEhsP7AZZRJmFDf21rJzNMFg9BXHCa0J0-CwB7YiQALBXAeLOIBr0ixc01buPhcqNTepHJzuH0XOyd_3zuHo93iLtfidcvFJPqvk0mjQYC4aL2BeAWfUMzgF2pom__4BQbpV-w:1roPnp:9PVEKwGomqwTMqg8azihEZ98asRNdDUacWZ59KGfJPI', '2024-03-25 00:00:29.207000');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account_account`
--
ALTER TABLE `account_account`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `account_customuser`
--
ALTER TABLE `account_customuser`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `account_customuser_groups`
--
ALTER TABLE `account_customuser_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `account_customuser_groups_customuser_id_group_id_7e51db7b_uniq` (`customuser_id`,`group_id`),
  ADD KEY `account_customuser_groups_group_id_2be9f6d7_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `account_customuser_user_permissions`
--
ALTER TABLE `account_customuser_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `account_customuser_user__customuser_id_permission_650e378f_uniq` (`customuser_id`,`permission_id`),
  ADD KEY `account_customuser_u_permission_id_f4aec423_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `account_email`
--
ALTER TABLE `account_email`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `account_passkey_reset`
--
ALTER TABLE `account_passkey_reset`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `account_recaptcha`
--
ALTER TABLE `account_recaptcha`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `account_twilio`
--
ALTER TABLE `account_twilio`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `case_case`
--
ALTER TABLE `case_case`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `case_contact_person`
--
ALTER TABLE `case_contact_person`
  ADD PRIMARY KEY (`id`),
  ADD KEY `case_contact_person_case_contact_id_8c487925_fk_case_case_id` (`case_contact_id`);

--
-- Indexes for table `case_evidence`
--
ALTER TABLE `case_evidence`
  ADD PRIMARY KEY (`id`),
  ADD KEY `case_evidence_case_id_e7d75253_fk_case_case_id` (`case_id`);

--
-- Indexes for table `case_notification`
--
ALTER TABLE `case_notification`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `case_parent`
--
ALTER TABLE `case_parent`
  ADD PRIMARY KEY (`id`),
  ADD KEY `case_parent_victim_parent_id_9e465c18_fk_case_victim_id` (`victim_parent_id`);

--
-- Indexes for table `case_parent_perpetrator`
--
ALTER TABLE `case_parent_perpetrator`
  ADD PRIMARY KEY (`id`),
  ADD KEY `case_parent_perpetra_perpetrator_parent_i_ab3ae442_fk_case_perp` (`perpetrator_parent_id`);

--
-- Indexes for table `case_perpetrator`
--
ALTER TABLE `case_perpetrator`
  ADD PRIMARY KEY (`id`),
  ADD KEY `case_perpetrator_case_perpetrator_id_08ff760a_fk_case_case_id` (`case_perpetrator_id`);

--
-- Indexes for table `case_status_history`
--
ALTER TABLE `case_status_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `case_status_history_case_status_history__de24daf4_fk_case_case` (`case_status_history_id`);

--
-- Indexes for table `case_victim`
--
ALTER TABLE `case_victim`
  ADD PRIMARY KEY (`id`),
  ADD KEY `case_victim_case_victim_id_edbc67e2_fk_case_case_id` (`case_victim_id`);

--
-- Indexes for table `case_witness`
--
ALTER TABLE `case_witness`
  ADD PRIMARY KEY (`id`),
  ADD KEY `case_witness_case_witness_id_7aeee1b7_fk_case_case_id` (`case_witness_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_account_customuser_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account_customuser`
--
ALTER TABLE `account_customuser`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `account_customuser_groups`
--
ALTER TABLE `account_customuser_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `account_customuser_user_permissions`
--
ALTER TABLE `account_customuser_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `account_email`
--
ALTER TABLE `account_email`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `account_passkey_reset`
--
ALTER TABLE `account_passkey_reset`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `account_recaptcha`
--
ALTER TABLE `account_recaptcha`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `account_twilio`
--
ALTER TABLE `account_twilio`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `case_case`
--
ALTER TABLE `case_case`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=144;

--
-- AUTO_INCREMENT for table `case_contact_person`
--
ALTER TABLE `case_contact_person`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=136;

--
-- AUTO_INCREMENT for table `case_evidence`
--
ALTER TABLE `case_evidence`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `case_notification`
--
ALTER TABLE `case_notification`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=138;

--
-- AUTO_INCREMENT for table `case_parent`
--
ALTER TABLE `case_parent`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `case_parent_perpetrator`
--
ALTER TABLE `case_parent_perpetrator`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `case_perpetrator`
--
ALTER TABLE `case_perpetrator`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=146;

--
-- AUTO_INCREMENT for table `case_status_history`
--
ALTER TABLE `case_status_history`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `case_victim`
--
ALTER TABLE `case_victim`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=154;

--
-- AUTO_INCREMENT for table `case_witness`
--
ALTER TABLE `case_witness`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=279;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `account_account`
--
ALTER TABLE `account_account`
  ADD CONSTRAINT `account_account_user_id_8d4f4816_fk_account_customuser_id` FOREIGN KEY (`user_id`) REFERENCES `account_customuser` (`id`);

--
-- Constraints for table `account_customuser_groups`
--
ALTER TABLE `account_customuser_groups`
  ADD CONSTRAINT `account_customuser_g_customuser_id_b6c60904_fk_account_c` FOREIGN KEY (`customuser_id`) REFERENCES `account_customuser` (`id`),
  ADD CONSTRAINT `account_customuser_groups_group_id_2be9f6d7_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `account_customuser_user_permissions`
--
ALTER TABLE `account_customuser_user_permissions`
  ADD CONSTRAINT `account_customuser_u_customuser_id_03bcc114_fk_account_c` FOREIGN KEY (`customuser_id`) REFERENCES `account_customuser` (`id`),
  ADD CONSTRAINT `account_customuser_u_permission_id_f4aec423_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`);

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `case_contact_person`
--
ALTER TABLE `case_contact_person`
  ADD CONSTRAINT `case_contact_person_case_contact_id_8c487925_fk_case_case_id` FOREIGN KEY (`case_contact_id`) REFERENCES `case_case` (`id`);

--
-- Constraints for table `case_evidence`
--
ALTER TABLE `case_evidence`
  ADD CONSTRAINT `case_evidence_case_id_e7d75253_fk_case_case_id` FOREIGN KEY (`case_id`) REFERENCES `case_case` (`id`);

--
-- Constraints for table `case_parent`
--
ALTER TABLE `case_parent`
  ADD CONSTRAINT `case_parent_victim_parent_id_9e465c18_fk_case_victim_id` FOREIGN KEY (`victim_parent_id`) REFERENCES `case_victim` (`id`);

--
-- Constraints for table `case_parent_perpetrator`
--
ALTER TABLE `case_parent_perpetrator`
  ADD CONSTRAINT `case_parent_perpetra_perpetrator_parent_i_ab3ae442_fk_case_perp` FOREIGN KEY (`perpetrator_parent_id`) REFERENCES `case_perpetrator` (`id`);

--
-- Constraints for table `case_perpetrator`
--
ALTER TABLE `case_perpetrator`
  ADD CONSTRAINT `case_perpetrator_case_perpetrator_id_08ff760a_fk_case_case_id` FOREIGN KEY (`case_perpetrator_id`) REFERENCES `case_case` (`id`);

--
-- Constraints for table `case_status_history`
--
ALTER TABLE `case_status_history`
  ADD CONSTRAINT `case_status_history_case_status_history__de24daf4_fk_case_case` FOREIGN KEY (`case_status_history_id`) REFERENCES `case_case` (`id`);

--
-- Constraints for table `case_victim`
--
ALTER TABLE `case_victim`
  ADD CONSTRAINT `case_victim_case_victim_id_edbc67e2_fk_case_case_id` FOREIGN KEY (`case_victim_id`) REFERENCES `case_case` (`id`);

--
-- Constraints for table `case_witness`
--
ALTER TABLE `case_witness`
  ADD CONSTRAINT `case_witness_case_witness_id_7aeee1b7_fk_case_case_id` FOREIGN KEY (`case_witness_id`) REFERENCES `case_case` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_account_customuser_id` FOREIGN KEY (`user_id`) REFERENCES `account_customuser` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
