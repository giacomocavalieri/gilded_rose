import birdie
import gilded_rose.{
  type GildedRose, type InventoryItem, AgedBrie, BackstagePass, Conjured,
  ForSaleItem, GildedRose, LegendaryItem, Regular, quality_new,
}
import gleam/int
import gleam/list
import gleam/string
import gleeunit

pub fn main() {
  gleeunit.main()
}

// --- SNAPSHOT TESTS ----------------------------------------------------------

fn starting_inn() {
  GildedRose(inventory: [
    ForSaleItem(Regular("+5 Dexterity Vest"), quality_new(20), 10),
    ForSaleItem(AgedBrie, quality_new(0), 2),
    ForSaleItem(Regular("Elixir of the Mongoose"), quality_new(7), 5),
    LegendaryItem("Sulfuras, Hand of Ragnaros", quality_new(80)),
    LegendaryItem("Sulfuras, Hand of Ragnaros", quality_new(80)),
    ForSaleItem(BackstagePass("TAFKAL80ETC"), quality_new(20), 15),
    ForSaleItem(BackstagePass("TAFKAL80ETC"), quality_new(49), 10),
    ForSaleItem(BackstagePass("TAFKAL80ETC"), quality_new(49), 5),
  ])
}

pub fn after_1_day_test() {
  starting_inn()
  |> after_n_days(1)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 1 day")
}

pub fn after_2_days_test() {
  starting_inn()
  |> after_n_days(2)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 2 days")
}

pub fn after_3_days_test() {
  starting_inn()
  |> after_n_days(3)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 3 days")
}

pub fn after_4_days_test() {
  starting_inn()
  |> after_n_days(4)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 4 days")
}

pub fn after_5_days_test() {
  starting_inn()
  |> after_n_days(5)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 5 days")
}

pub fn after_6_days_test() {
  starting_inn()
  |> after_n_days(6)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 6 days")
}

pub fn after_7_days_test() {
  starting_inn()
  |> after_n_days(7)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 7 days")
}

pub fn after_8_days_test() {
  starting_inn()
  |> after_n_days(8)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 8 days")
}

pub fn after_9_days_test() {
  starting_inn()
  |> after_n_days(9)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 9 days")
}

pub fn after_10_days_test() {
  starting_inn()
  |> after_n_days(10)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 10 days")
}

pub fn after_11_days_test() {
  starting_inn()
  |> after_n_days(11)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 11 days")
}

pub fn after_12_days_test() {
  starting_inn()
  |> after_n_days(12)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 12 days")
}

pub fn after_13_days_test() {
  starting_inn()
  |> after_n_days(13)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 13 days")
}

pub fn after_14_days_test() {
  starting_inn()
  |> after_n_days(14)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 14 days")
}

pub fn after_15_days_test() {
  starting_inn()
  |> after_n_days(15)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 15 days")
}

pub fn after_31_days_test() {
  starting_inn()
  |> after_n_days(31)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 31 days")
}

pub fn after_100_days_test() {
  starting_inn()
  |> after_n_days(100)
  |> inventory_to_string
  |> birdie.snap(title: "inn after 100 days")
}

// --- SNAPSHOT TESTING UTILITIES ----------------------------------------------

fn after_n_days(inn: GildedRose, days: Int) -> GildedRose {
  use inn, _day <- list.fold(over: list.range(1, days), from: inn)
  gilded_rose.update_inventory_at_end_of_day(inn)
}

fn inventory_to_string(inn: GildedRose) -> String {
  let GildedRose(inventory:) = inn

  list.map(inventory, item_to_string)
  |> string.join(with: "\n")
  |> string.append("name, sell_in, quality\n", _)
}

fn item_to_string(item: InventoryItem) -> String {
  let quality =
    item.quality
    |> gilded_rose.quality_value
    |> int.to_string

  case item {
    LegendaryItem(name:, quality: _) -> name <> ", 0, " <> quality
    ForSaleItem(item:, quality: _, sell_in:) -> {
      let sell_in = int.to_string(sell_in)
      let name = case item {
        Conjured(name:) -> "Conjured " <> name
        AgedBrie -> "Aged Brie"
        Regular(name:) -> name
        BackstagePass(concert:) ->
          "Backstage passes to a " <> concert <> " concert"
      }

      name <> ", " <> sell_in <> ", " <> quality
    }
  }
}
