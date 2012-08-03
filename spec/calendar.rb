# encoding: utf-8

require "lunar_calendar"

describe LunarCalendar::Calendar do
  it 'create Example' do
    #params: time object
    LunarCalendar::Calendar.new
    LunarCalendar::Calendar.new(Time.new)
  end

  it 'year days number' do
    lc = LunarCalendar::Calendar.new(Time.new(2012, 1, 17))
    lc.lYearDays.should eq(384)
    lc.lYearDays(2011).should eq(354)
  end

  it 'leap month days number' do
    lc = LunarCalendar::Calendar.new
    lc.leapMonth(2012).should eq(4)
    lc.leapMonth(2011).should eq(0)
  end

  it 'month days number' do
    lc = LunarCalendar::Calendar.new
    lc.monthDays(2011, 12).should eq(29)
    lc.monthDays(2012, 1).should eq(30)
    lc.monthDays(1999, 12).should eq(29)
    lc.monthDays(2010, 12).should eq(30)
  end

  it 'test world date to lunarCalendar' do
    lc = LunarCalendar::Calendar.new
    ld = lc.lunar(Time.new(2000, 1, 1))
    test_lunar_date_obj(ld, 1999, 11, 25)
    ld = lc.lunar(Time.new(2000, 9, 14))
    test_lunar_date_obj(ld, 2000, 8, 17)
    ld = lc.lunar(Time.new(2012, 1, 20))
    test_lunar_date_obj(ld, 2011, 12, 27)
    ld = lc.lunar(Time.new(2015, 12, 11))
    test_lunar_date_obj(ld, 2015, 11, 1)
    ld = lc.lunar(Time.new(2012, 6, 18))
    test_lunar_date_obj(ld, 2012, 4, 29, true)
  end

  it 'lunar calendar year date ,days number(yday)' do
    lc = LunarCalendar::Calendar.new

  end

  it 'to_lc method: to lunarDate obj' do
    lc = LunarCalendar::Calendar.new
    lc.to_lc(Time.new(2000, 1, 1)).should eq(LunarCalendar::LunarDate.new(1999, 11, 25))
    lc.to_lc(Time.new(2000, 9, 14)).should eq(LunarCalendar::LunarDate.new(2000, 8, 17))
    lc.to_lc(Time.new(2012, 1, 20)).should eq(LunarCalendar::LunarDate.new(2011, 12, 27))
    lc.to_lc(Time.new(2012, 6, 18)).should eq(LunarCalendar::LunarDate.new(2012, 4, 29, true))
  end

  it 'base year date' do
    lc = LunarCalendar::Calendar.new
    lc.baseYearDate(1900).should eq(Time.new(1900, 1, 31))
    lc.baseYearDate(2001).should eq(Time.new(2001, 1, 24))
    lc.baseYearDate(2002).should eq(Time.new(2002, 2, 12))
    lc.baseYearDate(2004).should eq(Time.new(2004, 1, 22))
    lc.baseYearDate(2006).should eq(Time.new(2006, 1, 29))
    lc.baseYearDate(2008).should eq(Time.new(2008, 2, 7))
    lc.baseYearDate(2010).should eq(Time.new(2010, 2, 14))
    lc.baseYearDate(2011).should eq(Time.new(2011, 2, 3))
    lc.baseYearDate(2012).should eq(Time.new(2012, 1, 23))
    lc.baseYearDate(2013).should eq(Time.new(2013, 2, 10))
    lc.baseYearDate(2015).should eq(Time.new(2015, 2, 19))
  end

  it 'lunar date to world date' do
    lc = LunarCalendar::Calendar.new
    lc.to_wd(LunarCalendar::LunarDate.new(2011, 12, 27)).should eq(Time.new(2012, 1, 20))
    lc.to_wd(LunarCalendar::LunarDate.new(2012, 4, 1)).should eq(Time.new(2012, 4, 21))
    lc.to_wd(LunarCalendar::LunarDate.new(2012, 4, 30)).should eq(Time.new(2012, 5, 20))
    lc.to_wd(LunarCalendar::LunarDate.new(2012, 4, 1, true)).should eq(Time.new(2012, 5, 21))
    lc.to_wd(LunarCalendar::LunarDate.new(2012, 4, 29, true)).should eq(Time.new(2012, 6, 18))
  end

  it 'solar term' do
    lc = LunarCalendar::Calendar.new
    lc.solarTerm(Time.new(2012, 1, 6)).should eq('小寒')
    lc.solarTerm(Time.new(2012, 1, 21)).should eq('大寒')
    lc.solarTerm(Time.new(2012, 7, 7)).should eq('小暑')
    lc.solarTerm(Time.new(2012, 9, 7)).should eq('白露')
    lc.solarTerm(Time.new(2012, 12, 7)).should eq('大雪')
  end

  it 'Limit test' do
    lc = LunarCalendar::Calendar.new
    wd = Time.new(2000, 1, 1)
    oneDay = 86400

    while wd.year < 2020
      ld = lc.to_lc(wd)
      lc.to_wd(ld).should eq(wd)
      wd += oneDay
    end
  end

  # === ==== === === == ====
  private
  def test_lunar_date_obj(ld, year, month, day, isLeap = false)
    ld[:year].should eq(year)
    ld[:month].should eq(month)
    ld[:day].should eq(day)
    ld[:isLeap].should eq(isLeap)
  end
end