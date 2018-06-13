require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

# context "the store has inventory" do
#   let(:items) { [Item.new("foo", 0, 0)] }

  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    it "does not lower quantity below 0" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq(0)
    end

    it "sell_in can be lowered below 0" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].sell_in).to eq(-1)
    end

    it "decreases quality by 1" do
      items = [Item.new("foo", 0, 1)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq(0)
    end

    it "decreases sell_in by 1" do
      items = [Item.new("foo", 1, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].sell_in).to eq(0)
    end

    it "lowers quality twice as fast if sell_in date is below 0" do
      items = [Item.new("foo", -1, 20)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq(18)
    end

    it "increases the quality by 1 if item is Aged Brie" do
      items = [Item.new("Aged Brie", 20, 20)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq(21)
    end


    it "does not increase the quality over 50" do
      items = [Item.new("Aged Brie", 20, 50)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq(50)
    end

    it "does not change quality or sell_in of Sulfuras" do
      items = [Item.new("Sulfuras, Hand of Ragnaros", 20, 80)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq(80)
      expect(items[0].sell_in).to eq(20)
    end

    it "increases the quality by 1 for backstage passes when concert is in 10+ days" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 20, 20)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq(21)
    end

    it "increases the quality by 2 for backstage passes when concert is in 6-10 days" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 20)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq(22)
    end

    it "increases the quality by 3 for backstage passes when concert is in 1-5 days" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 1, 20)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq(23)
    end

    it "drops the quality to 0 after the concert occurs" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 20)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq(0)
    end

    it "drops the quality twice as fast if the item is Conjured" do
      items = [Item.new("conjured item", 5, 20)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq(18)
    end
  end
end


## - At the end of each day our system lowers both values for every item

## - Once the sell by date has passed, Quality degrades twice as fast
## - The Quality of an item is never negative
## - "Aged Brie" actually increases in Quality the older it gets
# - The Quality of an item is never more than 50
## - "Sulfuras", being a legendary item, never has to be sold or decreases in Quality
## - "Backstage passes", like aged brie, increases in Quality as its SellIn value approaches;
##      Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but
##     Quality drops to 0 after the concert
## Just for clarification, an item can never have its Quality increase above 50, however "Sulfuras" is a
## legendary item and as such its Quality is 80 and it never alters.

## We have recently signed a supplier of conjured items. This requires an update to our system:
##
##	- "Conjured" items degrade in Quality twice as fast as normal items
