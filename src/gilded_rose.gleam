import gleam/int
import gleam/list

// --- INVENTORY ---------------------------------------------------------------

pub type GildedRose {
  GildedRose(inventory: List(InventoryItem))
}

/// The Gilded Rose Inn has an inventory comprised of both for sale items and
/// legendary items that should never be sold.
///
pub type InventoryItem {
  ForSaleItem(item: ForSaleItem, quality: Quality, sell_in: Int)
  LegendaryItem(name: String, quality: Quality)
}

/// The items that the Gilded Rose Inn has on sale.
///
pub type ForSaleItem {
  AgedBrie
  BackstagePass(concert: String)
  Conjured(name: String)
  Regular(name: String)
}

/// Updates the inventory of the Gilded Rose inn by advancing the `sell_in`
/// expiration date of all items for sale and updating their quality
/// accordingly.
///
pub fn update_inventory_at_end_of_day(inn: GildedRose) -> GildedRose {
  let GildedRose(inventory:) = inn
  let inventory = list.map(inventory, day_passed_for_inventory_item)

  GildedRose(inventory:)
}

fn day_passed_for_inventory_item(inventory_item: InventoryItem) -> InventoryItem {
  case inventory_item {
    // Legendary items are not meant to be for sale and their quality never
    // changes.
    LegendaryItem(..) -> inventory_item

    ForSaleItem(item:, sell_in:, quality:) -> {
      let quality = update_quality_at_end_of_day(item, sell_in, quality)
      let sell_in = sell_in - 1
      ForSaleItem(..inventory_item, sell_in:, quality:)
    }
  }
}

fn update_quality_at_end_of_day(
  kind: ForSaleItem,
  sell_in: Int,
  quality: Quality,
) -> Quality {
  case kind {
    // Aged Brie gets better as it ages, and it improves twice as fast after the
    // sell_in date expired!
    AgedBrie if sell_in <= 0 -> quality_add(quality, 2)
    AgedBrie -> quality_add(quality, 1)

    // Backstage passes get more precious the closer to the concert, but their
    // quality drops to zero after the concert date.
    BackstagePass(_) if sell_in <= 0 -> quality_new(0)
    BackstagePass(_) if sell_in <= 5 -> quality_add(quality, 3)
    BackstagePass(_) if sell_in <= 10 -> quality_add(quality, 2)
    BackstagePass(_) -> quality_add(quality, 1)

    // Regular items decrease in quality the closer to the sell_in date and
    // degrade twice as fast after it.
    Regular(_) if sell_in <= 0 -> quality_add(quality, -2)
    Regular(_) -> quality_add(quality, -1)

    // Conjured items degrade twice as fast as regular items.
    Conjured(_) if sell_in <= 0 -> quality_add(quality, -4)
    Conjured(_) -> quality_add(quality, -2)
  }
}

// --- QUALITY -----------------------------------------------------------------

pub opaque type Quality {
  Quality(value: Int)
}

pub fn quality_value(quality: Quality) -> Int {
  quality.value
}

pub fn quality_new(value: Int) -> Quality {
  // A quality can never go below zero.
  Quality(int.max(0, value))
}

fn quality_add(quality: Quality, n: Int) -> Quality {
  // A quality can never be increased over 50, nor go below zero.
  // However a quality could have a value over 50; in that case we allow
  // decreasing it but it cannot increase further.
  let max_quality = int.max(quality.value, 50)

  { quality.value + n }
  |> int.clamp(min: 0, max: max_quality)
  |> Quality
}
