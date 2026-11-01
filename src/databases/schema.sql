-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema thy_cargo
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema thy_cargo
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `thy_cargo` ;
USE `thy_cargo` ;

-- -----------------------------------------------------
-- Table `thy_cargo`.`Region`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `thy_cargo`.`Region` (
  `region_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`region_id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `thy_cargo`.`Country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `thy_cargo`.`Country` (
  `country_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `region_id` INT NOT NULL,
  PRIMARY KEY (`country_id`),
  INDEX `fk_Country_Region_idx` (`region_id` ASC) VISIBLE,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  CONSTRAINT `fk_Country_Region`
    FOREIGN KEY (`region_id`)
    REFERENCES `thy_cargo`.`Region` (`region_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `thy_cargo`.`Airport_Rate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `thy_cargo`.`Airport_Rate` (
  `iata_code` VARCHAR(3) NOT NULL,
  `country_id` INT NOT NULL,
  `city_name` VARCHAR(25) NOT NULL,
  `rate_45_minus` DECIMAL(10,2) NULL,
  `rate_45_plus` DECIMAL(10,2) NULL,
  `rate_100_plus` DECIMAL(10,2) NULL,
  `rate_300_plus` DECIMAL(10,2) NULL,
  `rate_500_plus` DECIMAL(10,2) NULL,
  `rate_1000_plus` DECIMAL(10,2) NULL,
  `fixed_min_fee` DECIMAL(10,2) NOT NULL DEFAULT 50.00,
  PRIMARY KEY (`iata_code`),
  INDEX `fk_Airport_Country1_idx` (`country_id` ASC) VISIBLE,
  CONSTRAINT `fk_Airport_Country1`
    FOREIGN KEY (`country_id`)
    REFERENCES `thy_cargo`.`Country` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `thy_cargo`.`Cargo_Category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `thy_cargo`.`Cargo_Category` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(45) NOT NULL,
  `rate_multiplier` DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (`category_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `thy_cargo`.`Shipment_Quote`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `thy_cargo`.`Shipment_Quote` (
  `quote_id` INT NOT NULL AUTO_INCREMENT,
  `weight_kg` DECIMAL(10,2) NOT NULL,
  `applied_fix_fee` DECIMAL(10,2) NOT NULL,
  `applied_kg_rate` DECIMAL(10,2) NOT NULL,
  `total_cost` DECIMAL(10,2) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `iata_code` VARCHAR(3) NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`quote_id`),
  INDEX `fk_Shipment_Quote_Airport_Rate1_idx` (`iata_code` ASC) VISIBLE,
  INDEX `fk_Shipment_Quote_Cargo_Category1_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `fk_Shipment_Quote_Airport_Rate1`
    FOREIGN KEY (`iata_code`)
    REFERENCES `thy_cargo`.`Airport_Rate` (`iata_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Shipment_Quote_Cargo_Category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `thy_cargo`.`Cargo_Category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `thy_cargo`.`Handling_Service`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `thy_cargo`.`Handling_Service` (
  `service_id` INT NOT NULL AUTO_INCREMENT,
  `service_name` VARCHAR(100) NOT NULL,
  `fee` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`service_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `thy_cargo`.`Quote_Services`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `thy_cargo`.`Quote_Services` (
  `quote_id` INT NOT NULL,
  `service_id` INT NOT NULL,
  `applied_fee` DECIMAL(10,2) NOT NULL,
  INDEX `fk_Quote_Services_Shipment_Quote1_idx` (`quote_id` ASC) VISIBLE,
  PRIMARY KEY (`quote_id`, `service_id`),
  INDEX `fk_Quote_Services_Handling_Service1_idx` (`service_id` ASC) VISIBLE,
  CONSTRAINT `fk_Quote_Services_Shipment_Quote1`
    FOREIGN KEY (`quote_id`)
    REFERENCES `thy_cargo`.`Shipment_Quote` (`quote_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Quote_Services_Handling_Service1`
    FOREIGN KEY (`service_id`)
    REFERENCES `thy_cargo`.`Handling_Service` (`service_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;