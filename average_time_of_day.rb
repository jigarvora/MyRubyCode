require 'time'

def average_time_of_day(times)
	arr = *times
	base = Time.parse("12:00am")
	pmFound = false

	sum = 0
	arr.each do |a|
		t = Time.parse(a)
		pmFound = true if (a =~ /pm/)
		if(pmFound && a =~ /am/)
			t = t+(60*60*24)
		end

		#puts t
		diff = (base-t)
		sum = sum + diff
		#puts diff
	end
	avg = base - (sum/arr.size())
	averageTime = avg.strftime("%I:%M%p")
	puts averageTime
end

	
average_time_of_day(["11:51pm", "11:56pm", "12:01am", "12:06am", "12:11am"])
average_time_of_day(["6:41am", "6:51am", "7:01am"])
average_time_of_day(["6:41pm", "6:51pm", "7:01pm"])
average_time_of_day(["11:51am", "11:56am", "12:01pm", "12:06pm", "12:11pm"])

