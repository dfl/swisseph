require 'swisseph'

#############################
# CONFIGURATION
#############################

# Date Information
year = 2012
month = 5
day = 14
hour = 10.15

# Geographic Location
longitude = -112.183333
latitidue = 45.45
altitude = 1468

#############################
# MAIN
#############################

# Get the Julian day number
jd = Sweph::swe_julday(year, month, day, hour)

# Set the geographic location for topocentric positions
Sweph::swe_set_topo(longitude, latitidue, altitude)

# Set the sidereal mode for sidereal positions
Sweph::swe_set_sid_mode(Sweph::SE_SIDM_LAHIRI, 0, 0)

# Get the ayanamsha (the distance of the tropical vernal point from the sidereal zero point of the zodiac)
ayanamsha = Sweph::swe_get_ayanamsa_ut(jd)

# Calculate the position of the Sun
# Use the Moshier Ephemeris (does not require ephemeris files)
# Get high precision speed and sidereal/topocentric positions
body = Sweph::swe_calc_ut(jd, Sweph::SE_SUN, Sweph::SEFLG_MOSEPH|Sweph::SEFLG_SPEED|Sweph::SEFLG_TOPOCTR|Sweph::SEFLG_SIDEREAL)

# Print the results
puts "Longitude: #{body[0]}"
puts "Latitude: #{body[1]}"
puts "Distance in AU: #{body[2]}"
puts "Speed in longitude (deg/day): #{body[3]}"
puts "Speed in latitude (deg/day): #{body[4]}"
puts "Speed in distance (AU/day): #{body[5]}"
puts "Ayanamsha: #{ayanamsha}"

