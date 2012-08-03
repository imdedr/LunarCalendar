# encoding: utf-8

module LunarCalendar
	class LunarDate
		attr :year, :mon, :day, :leap

		@@locaStr = {
			:dayNum => [
					'零', '一', '二', '三', '四', 
					'五', '六', '七', '八', '九', '十'
			],
			:dayText => ['初', '十', '廿', '卅'],
			:monthName => [
				'正', '二', '三', '四',
				'五', '六', '七', '八',
				'九', '十', '冬', '腊'
			],
			:ymName => ['年', '月', '闰']
		}

		def initialize(year = 1900, mon = 1, day = 1, isLeap = false)
			update(year, mon, day, isLeap)
		end

		def year=(y)
			@year = y.to_i
		end

		def mon=(m)
			@mon = m.to_i
		end

		def day=(d)
			@day = d.to_i
		end

		def update(year, mon, day, isLeap)
			@year, @mon, @day, @leap = year, mon, day, isLeap
			self
		end

		def leap?
			@leap
		end

		def to_s
			str = year_to_chinese(@year)
			str += @@locaStr[:ymName][2] if @leap
			str += @@locaStr[:monthName][@mon - 1] + @@locaStr[:ymName][1]
			str + day_to_chinese(@day)
		end

		def set_loca_text(texts)
			@@locaStr.merge(texts)
		end

		def ==(ld)
			@year == ld.year and @mon == ld.mon and @day == ld.day and @leap == ld.leap
		end

		def <(ld)
			[:@year, :@mon, :@day].each do |name|
				if self.instance_variable_get(name) != ld.instance_variable_get(name)
					return self.instance_variable_get(name) < ld.instance_variable_get(name)
				elsif name == :@day
					return false
				end
			end
		end

		def >(ld)
			[:@year, :@mon, :@day].each do |name|
				if self.instance_variable_get(name) != ld.instance_variable_get(name)
					return self.instance_variable_get(name) > ld.instance_variable_get(name)
				elsif name == :@day
					return false
				end
			end
		end

		# ============== private ===================
		private

		def year_to_chinese(year)
			cstr = ''
			temp = year.to_s
			temp.length.times do |i|
				cstr << @@locaStr[:dayNum][temp[i].to_i]
			end
			cstr + @@locaStr[:ymName][0]
		end

		def day_to_chinese(day)
			return @@locaStr[:dayText][0] + @@locaStr[:dayNum][day] if day <= 10
			cstr = @@locaStr[:dayText][day / 10] + @@locaStr[:dayNum][day % 10 == 0 ? 10 : day % 10]
		end
	end
end