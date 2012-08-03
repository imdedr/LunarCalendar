# encoding: utf-8

require "lunar_calendar/version"
require "lunar_calendar/lunar_date"

module LunarCalendar
	class Calendar
	  attr :lDate

	  @@lunarInfo = [
	    0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,
	    0x055d2,0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,
	    0x095b0,0x14977,0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,
	    0x09570,0x052f2,0x04970,0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,
	    0x186e3,0x092e0,0x1c8d7,0x0c950,0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,
	    0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,0x06ca0,0x0b550,0x15355,0x04da0,
	    0x0a5b0,0x14573,0x052b0,0x0a9a8,0x0e950,0x06aa0,0x0aea6,0x0ab50,0x04b60,
	    0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,0x096d0,0x04dd5,
	    0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b6a0,0x195a6,0x095b0,
	    0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,
	    0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,
	    0x092e0,0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,
	    0x092d0,0x0cab5,0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,
	    0x15176,0x052b0,0x0a930,0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,
	    0x0a4e0,0x0d260,0x0ea65,0x0d530,0x05aa0,0x076a3,0x096d0,0x04bd7,0x04ad0,
	    0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,0x0b5a0,0x056d0,0x055b2,0x049b0,
	    0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0,0x14b63
	  ]
	  @@solarTerms = [
	    "小寒","大寒","立春","雨水","驚蟄","春分",
	    "清明","谷雨","立夏","小滿","芒種","夏至",
	    "小暑","大暑","立秋", "處暑","白露","秋分",
	    "寒露","霜降","立冬","小雪","大雪","冬至"
	  ]
	  @@solarTermBase = [
	    4,19,3,18,4,19,
	    4,19,4,20,4,20,
	    6,22,6,22,6,22,
	    7,22,6,21,6,21
	  ]
	  @@solarTermIdx = '0123415341536789:;<9:=<>:=1>?012@015@015@015AB78CDE8CD=1FD01GH01GH01IH01IJ0KLMN;LMBEOPDQRST0RUH0RVH0RWH0RWM0XYMNZ[MB\\]PT^_ST`_WH`_WH`_WM`_WM`aYMbc[Mde]Sfe]gfh_gih_Wih_WjhaWjka[jkl[jmn]ope]qph_qrh_sth_W'
	  @@solarTermOS = '211122112122112121222211221122122222212222222221222122222232222222222222222233223232223232222222322222112122112121222211222122222222222222222222322222112122112121222111211122122222212221222221221122122222222222222222222223222232222232222222222222112122112121122111211122122122212221222221221122122222222222222221211122112122212221222211222122222232222232222222222222112122112121111111222222112121112121111111222222111121112121111111211122112122112121122111222212111121111121111111111122112122112121122111211122112122212221222221222211111121111121111111222111111121111111111111111122112121112121111111222111111111111111111111111122111121112121111111221122122222212221222221222111011111111111111111111122111121111121111111211122112122112121122211221111011111101111111111111112111121111121111111211122112122112221222211221111011111101111111110111111111121111111111111111122112121112121122111111011111121111111111111111011111111112111111111111011111111111111111111221111011111101110111110111011011111111111111111221111011011101110111110111011011111101111111111211111001011101110111110110011011111101111111111211111001011001010111110110011011111101111111110211111001011001010111100110011011011101110111110211111001011001010011100110011001011101110111110211111001010001010011000100011001011001010111110111111001010001010011000111111111111111111111111100011001011001010111100111111001010001010000000111111000010000010000000100011001011001010011100110011001011001110111110100011001010001010011000110011001011001010111110111100000010000000000000000011001010001010011000111100000000000000000000000011001010001010000000111000000000000000000000000011001010000010000000'
	  @@lBase = Time.new(1900, 1, 31)
	  @@oneDay = 86400
	  @@baseYearDate = {
	    @@lBase.year => @@lBase
	  }

	  def initialize(wDate = Time.new)
	    @wDate = wDate
	    @lDate = LunarDate.new
	    initBaseYear
	  end

	  #year days number
	  def lYearDays(year = @wDate.year)
	    sum = 348; i = 0x8000
	    while i > 0x8
	      sum += (@@lunarInfo[year - @@lBase.year] & i) != 0 ? 1 : 0
	      i >>= 1
	    end
	    sum + leapDays(year)
	  end

	  #leap month of year
	  #return 0 no leap month
	  def leapMonth(year = @wDate.year)
	    @@lunarInfo[year - @@lBase.year] & 0xf
	  end

	  #leap month days number
	  #return 0 no leap month
	  def leapDays(year = @wDate.year)
	    if leapMonth(year) == 0 then 0
	    else 
	      (@@lunarInfo[year - @@lBase.year] & 0x10000) != 0 ? 30 : 29
	    end
	  end

	  #return month days number
	  def monthDays(year, month)
	    (@@lunarInfo[year - @@lBase.year] & (0x10000 >> month)) != 0 ? 30 : 29
	  end

	  def baseYearDate(year)
	    @@baseYearDate[year]
	  end

	  def yday(lDate)
	    days  = lDate.day
	    leap  = leapMonth(lDate.year)
	    month = lDate.mon - ((leap == lDate.mon && lDate.leap) ? 0 : 1)

	    1.upto(month) {|mon| days += monthDays(lDate.year, mon) }
	    
	    if leap != 0 && leap < lDate.mon
	      days + leapDays(lDate.year)
	    else
	      days
	    end
	  end

	  #return lunar object
	  def lunar(wDate = @wDate)
	    i = 0; leap = 0; temp = 0
	    offset = (wDate - @@lBase).floor / @@oneDay
	    lunarObj = {
	      :dayCyl => offset + 40,
	      :monCyl => 14
	    }
	    setData = Proc.new do |a, b, c = 1|
	      offset += a
	      lunarObj[:monCyl] += b
	      i += c
	    end

	    i = @@lBase.year
	    while i < 2050 && offset > 0
	      temp = lYearDays(i)
	      setData.call(-temp, 12)
	    end
	    setData.call(temp, -12, -1) if offset < 0
	    
	    lunarObj.merge!(:year => i, :yearCyl => i - 1864, :isLeap => false)
	    leap = leapMonth(i)

	    i = 1
	    while i < 13 and offset > 0
	      if leap > 0 and i == (leap + 1) and lunarObj[:isLeap] == false
	        i -= 1
	        lunarObj[:isLeap] = true
	        temp = leapDays(lunarObj[:year])
	      else
	        temp = monthDays(lunarObj[:year], i)
	      end
	 
	      lunarObj[:isLeap] = false if lunarObj[:isLeap] == true and i == (leap + 1)
	      lunarObj[:monCyl] += 1 if lunarObj[:isLeap] == false
	      offset -= temp
	      i += 1
	    end

	    if offset == 0 and leap > 0 and i == leap + 1
	      setData.call(0, -1, -1) unless lunarObj[:isLeap]
	      lunarObj[:isLeap] ^= true
	    end
	    setData.call(temp, -1, -1) if offset < 0

	    lunarObj.merge :month => i, :day => offset + 1
	  end

	  def to_lc(wDate = @wDate)
	    oLunar = lunar(wDate) 
	    LunarDate.new(oLunar[:year], oLunar[:month], oLunar[:day], oLunar[:isLeap])
	  end

	  def to_wd(lDate = @lDate)
	    days = yday(lDate) - 1
	    baseYearDate(lDate.year) + days * @@oneDay
	  end

	  def solarTerm(wDate = @wDate)
	    tD = wDate.day
	    tY = wDate.year
	    tM = wDate.mon - 1

	    if tD == sTerm(tY, tM * 2)
	      @@solarTerms[tM * 2]
	    else
	      tD == sTerm(tY, tM * 2 + 1) ? @@solarTerms[tM*2+1] : ''
	    end
	  end

	  # ========== ================= ========================
	  private

	  def sTerm(y, n)
	    @@solarTermBase[n] + (
	      @@solarTermOS[
	        (@@solarTermIdx[y - @@lBase.year].ord - 48) * 24 + n  
	      ].to_i
	    )
	  end

	  def initBaseYear
	    @@baseYearDate ||= {}
	    time = @@lBase.dup
	    @@lBase.year.upto(2050) do |year|
	      time += lYearDays(year) * @@oneDay
	      time = Time.new(time.year, time.mon, time.day) + 86400 if time.hour > 20
	      @@baseYearDate[year + 1] = time.dup
	    end
	  end

	end
end
