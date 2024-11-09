-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema habitsaga
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema habitsaga
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `habitsaga` DEFAULT CHARACTER SET utf8 ;
USE `habitsaga` ;

-- -----------------------------------------------------
-- Table `habitsaga`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `habitsaga`.`users` (
  `id` INT NOT NULL,
  `username` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `exp_points` INT NOT NULL DEFAULT 0,
  `coins` INT NOT NULL DEFAULT 0,
  `level` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `habitsaga`.`task_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `habitsaga`.`task_category` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `habitsaga`.`eisenhower_tasks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `habitsaga`.`eisenhower_tasks` (
  `id` INT NOT NULL,
  `users_id` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` LONGTEXT NULL,
  `is_completed` TINYINT(1) NOT NULL,
  `priority` TINYINT(2) NOT NULL,
  `due_datetime` DATETIME NOT NULL,
  `task_category_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_tasks_users_idx` (`users_id` ASC),
  INDEX `fk_tasks_task_category1_idx` (`task_category_id` ASC),
  CONSTRAINT `fk_tasks_users`
    FOREIGN KEY (`users_id`)
    REFERENCES `habitsaga`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tasks_task_category1`
    FOREIGN KEY (`task_category_id`)
    REFERENCES `habitsaga`.`task_category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `habitsaga`.`item_categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `habitsaga`.`item_categories` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `habitsaga`.`shop_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `habitsaga`.`shop_items` (
  `id` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `description` LONGTEXT NOT NULL,
  `price` INT NOT NULL,
  `required_level` INT NOT NULL,
  `img` LONGTEXT NOT NULL,
  `item_categories_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_shop_items_item_categories1_idx` (`item_categories_id` ASC),
  CONSTRAINT `fk_shop_items_item_categories1`
    FOREIGN KEY (`item_categories_id`)
    REFERENCES `habitsaga`.`item_categories` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `habitsaga`.`user_inventories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `habitsaga`.`user_inventories` (
  `users_id` INT NOT NULL,
  `shop_items_id` INT NOT NULL,
  PRIMARY KEY (`users_id`, `shop_items_id`),
  INDEX `fk_users_has_shop_items_shop_items1_idx` (`shop_items_id` ASC),
  INDEX `fk_users_has_shop_items_users1_idx` (`users_id` ASC),
  CONSTRAINT `fk_users_has_shop_items_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `habitsaga`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_shop_items_shop_items1`
    FOREIGN KEY (`shop_items_id`)
    REFERENCES `habitsaga`.`shop_items` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `habitsaga`.`equipped_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `habitsaga`.`equipped_items` (
  `user_inventories_users_id` INT NOT NULL,
  `user_inventories_shop_items_id` INT NOT NULL,
  PRIMARY KEY (`user_inventories_users_id`, `user_inventories_shop_items_id`),
  CONSTRAINT `fk_equipped_items_user_inventories1`
    FOREIGN KEY (`user_inventories_users_id` , `user_inventories_shop_items_id`)
    REFERENCES `habitsaga`.`user_inventories` (`users_id` , `shop_items_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
