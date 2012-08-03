# encoding: utf-8

require "lunar_calendar/lunar_date"

describe LunarCalendar::LunarDate do
  it 'create Example' do
    #params: year, month, day, isLeap
    LunarCalendar::LunarDate.new(1990)
    LunarCalendar::LunarDate.new(1999, 1)
    LunarCalendar::LunarDate.new(2012, 2, 10)
    LunarCalendar::LunarDate.new(2030, 6, 20, false)
  end

  it 'get date number' do
    args = [2012, 1, 20, false]
    ld = LunarCalendar::LunarDate.new(*args)
    test_get_date(ld, *args)
  end

  it 'update lunarDate object' do
    args = [2012, 1, 20, false]
    ld = LunarCalendar::LunarDate.new(1900, 1, 1, false)
    ld.update(*args)
    test_get_date(ld, *args)
  end

  it "lunar date to string" do
    args = [2012, 1, 2, false]
    ld = LunarCalendar::LunarDate.new(*args)
    ld.to_s.should eq("二零一二年正月初二")

    ld.update(2012, 4, 10, true)
    ld.to_s.should eq("二零一二年闰四月初十")

    ld.update(2012, 4, 20, true)
    ld.to_s.should eq("二零一二年闰四月廿十")

    ld.update(2012, 2, 15, false)
    ld.to_s.should eq("二零一二年二月十五")

    ld.update(2012, 2, 30, false)
    ld.to_s.should eq("二零一二年二月卅十")
  end

  it 'year number to chinese text' do
    ld = LunarCalendar::LunarDate.new
    ld.send('year_to_chinese', 2012).should eq('二零一二年')
    ld.send('year_to_chinese', 1900).should eq('一九零零年')
    ld.send('year_to_chinese', 2000).should eq('二零零零年')
    ld.send('year_to_chinese', 2500).should eq('二五零零年')
  end

  it 'day number to chinese text' do
    ld = LunarCalendar::LunarDate.new
    ld.send('day_to_chinese', 1).should eq('初一')
    ld.send('day_to_chinese', 10).should eq('初十')
    ld.send('day_to_chinese', 11).should eq('十一')
    ld.send('day_to_chinese', 20).should eq('廿十')
    ld.send('day_to_chinese', 22).should eq('廿二')
  end

  # === ==== === === == ====
  private

  def test_get_date(ld, y, m, d, l)
    ld.year.should eq(y)
    ld.mon.should eq(m)
    ld.day.should eq(d)
    ld.leap?.should eq(l)
  end
end