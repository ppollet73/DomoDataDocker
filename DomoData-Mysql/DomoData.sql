SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données :  `domodata`
--
DROP DATABASE `domodata`;
CREATE DATABASE IF NOT EXISTS `domodata` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `domodata`;

-- --------------------------------------------------------

--
-- Structure de la table `devices`
--

DROP TABLE IF EXISTS `devices`;
CREATE TABLE IF NOT EXISTS `devices` (
  `idDevices` int(11) NOT NULL COMMENT 'ApiId du device Eedomus ou ID manuel dans le cas des anciens devices',
  `Deleted` tinyint(1) NOT NULL DEFAULT '0',
  `DevicesLastUpdated` datetime DEFAULT NULL,
  `DevicesSynchro` tinyint(1) DEFAULT '0',
  `DevicesType` varchar(45) DEFAULT NULL,
  `DevicesEedomusLabel` varchar(100) DEFAULT NULL,
  `DevicesPrivateLabel` varchar(45) DEFAULT NULL,
  `Rooms_idRooms` int(11) NOT NULL,
  `Usages_idUsages` int(11) NOT NULL,
  `DevicesHistoryImported` tinyint(1) NOT NULL DEFAULT '0',
  `DevicesFirstKnownHistory` datetime DEFAULT NULL,
  `DevicesLastUpdatedCharacteristics` datetime DEFAULT NULL,
  PRIMARY KEY (`idDevices`),
  UNIQUE KEY `idDevices_UNIQUE` (`idDevices`),
  KEY `fk_Devices_Rooms_idx` (`Rooms_idRooms`),
  KEY `fk_Devices_Usages_idx` (`Usages_idUsages`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `devicescurrent`
--

DROP TABLE IF EXISTS `devicescurrent`;
CREATE TABLE IF NOT EXISTS `devicescurrent` (
  `DevicesRawApiId` int(11) NOT NULL DEFAULT '0',
  `DevicesRawDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `DevicesRawValue` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`DevicesRawApiId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `devicesraw`
--

DROP TABLE IF EXISTS `devicesraw`;
CREATE TABLE IF NOT EXISTS `devicesraw` (
  `DevicesRawApiId` int(11) NOT NULL DEFAULT '0',
  `DevicesRawDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `DevicesRawValue` varchar(45) DEFAULT NULL,
  `DevicesRawDuration` varchar(15) DEFAULT NULL,
  KEY `ApiId` (`DevicesRawApiId`),
  KEY `Date` (`DevicesRawDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `devicestype`
--

DROP TABLE IF EXISTS `devicestype`;
CREATE TABLE IF NOT EXISTS `devicestype` (
  `idDevicesType` int(11) NOT NULL AUTO_INCREMENT,
  `DevicesTypeName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idDevicesType`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Structure de la table `parameters`
--

DROP TABLE IF EXISTS `parameters`;
CREATE TABLE IF NOT EXISTS `parameters` (
  `idParam` varchar(40) NOT NULL,
  `ParamValue` varchar(200) NOT NULL,
  `LastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idParam`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
CREATE TABLE IF NOT EXISTS `rooms` (
  `idRooms` int(11) NOT NULL,
  `RoomsEedomusLabel` varchar(100) DEFAULT NULL,
  `RoomsPersonalLabel` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idRooms`),
  UNIQUE KEY `idRooms_UNIQUE` (`idRooms`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `usages`
--

DROP TABLE IF EXISTS `usages`;
CREATE TABLE IF NOT EXISTS `usages` (
  `idUsages` int(11) NOT NULL,
  `UsagesName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idUsages`),
  UNIQUE KEY `idUsage_UNIQUE` (`idUsages`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_devices`
--
DROP VIEW IF EXISTS `v_devices`;
CREATE TABLE IF NOT EXISTS `v_devices` (
`RoomsEedomusLabel` varchar(100)
,`idDevices` int(11)
,`DevicesEedomusLabel` varchar(100)
,`UsagesName` varchar(45)
);
-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_devicessynchro`
--
DROP VIEW IF EXISTS `v_devicessynchro`;
CREATE TABLE IF NOT EXISTS `v_devicessynchro` (
`idDevices` int(11)
,`DevicesLastUpdated` datetime
,`DevicesEedomusLabel` varchar(100)
,`DevicesHistoryImported` tinyint(1)
,`DevicesFirstKnownHistory` datetime
);
-- --------------------------------------------------------

--
-- Structure de la vue `v_devices`
--
DROP TABLE IF EXISTS `v_devices`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_devices` AS select `rooms`.`RoomsEedomusLabel` AS `RoomsEedomusLabel`,`devices`.`idDevices` AS `idDevices`,`devices`.`DevicesEedomusLabel` AS `DevicesEedomusLabel`,`usages`.`UsagesName` AS `UsagesName` from (`devices` join (`rooms` join `usages`) on(((`devices`.`Rooms_idRooms` = `rooms`.`idRooms`) and (`devices`.`Usages_idUsages` = `usages`.`idUsages`)))) order by `rooms`.`RoomsEedomusLabel` WITH CASCADED CHECK OPTION;

-- --------------------------------------------------------

--
-- Structure de la vue `v_devicessynchro`
--
DROP TABLE IF EXISTS `v_devicessynchro`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_devicessynchro` AS select `devices`.`idDevices` AS `idDevices`,`devices`.`DevicesLastUpdated` AS `DevicesLastUpdated`,`devices`.`DevicesEedomusLabel` AS `DevicesEedomusLabel`,`devices`.`DevicesHistoryImported` AS `DevicesHistoryImported`,`devices`.`DevicesFirstKnownHistory` AS `DevicesFirstKnownHistory` from `devices` where (`devices`.`DevicesSynchro` = 1) order by `devices`.`idDevices`;

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `devices`
--
ALTER TABLE `devices`
  ADD CONSTRAINT `fk_Devices_Rooms1` FOREIGN KEY (`Rooms_idRooms`) REFERENCES `rooms` (`idRooms`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Devices_Usages1` FOREIGN KEY (`Usages_idUsages`) REFERENCES `usages` (`idUsages`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
