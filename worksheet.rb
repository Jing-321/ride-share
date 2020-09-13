require 'csv'
table = CSV.parse(File.read("rides.csv"), headers: true)

ride_share = {}

table.each do |row|
  drive_id = row["DRIVER_ID"]
  if !ride_share.has_key?(drive_id)
    ride_share[drive_id] = []
  end
  ride_share[drive_id] << {date: row["DATE"], cost: row["COST"].to_i, rider_id: row["RIDER_ID"], rating: row["RATING"].to_i}
end
########################################################

# - the number of rides each driver has given
puts "Number of rides:"
ride_share.each_pair { |id, rides| puts "Driver: #{id} ==> #{rides.length} rides"  }
driver_earning = {}

# - the total amount of money each driver has made
puts "\nDrivers' earning:"
ride_share.each_pair do |id, rides|
  earning = 0
  rides.each {|ride| earning += ride[:cost]}
  puts "Driver: #{id} ==> $ #{earning}"
  driver_earning[id] = earning
end

# - Which driver made the most money?
max_earning = driver_earning.max_by {|id, earning| earning}
puts "#{max_earning[0]} made the most. The earning is $#{max_earning[1]}."

# - the average rating for each driver
puts "\nDrivers' average rating:"
driver_rate = {}
ride_share.each_pair do |id, rides|
  rate_sum = 0
  rides.each {|ride| rate_sum += ride[:rating]}
  rate_avg = '%.2f' %(rate_sum/rides.length.to_f)
  puts "Driver: #{id} ==> #{rate_avg}"
  driver_rate[id] = rate_avg
end

# - Which driver has the highest average rating?
max_rate = driver_rate.max_by {|id, rate| rate}
puts "#{max_rate[0]} has the highest rating #{max_rate[1]}."

# - For each driver, on which day did they make the most money?
ride_share.each_pair do |id, rides|
  driver_earning_perday = {}

  rides.each do |ride|
    if driver_earning_perday.has_key? ride[:date]
      driver_earning_perday[ride[:date]] += ride[:cost]
    else
      driver_earning_perday[ride[:date]] = ride[:cost]
    end
  end

  max_date = driver_earning_perday.max_by {|date, earning| earning}
  puts "#{id} made the most($#{max_date[1]}) on #{max_date[0]}."
end
