# Swisseph

**Swiss Ephemeris for Ruby**

[![Gem Version](https://badge.fury.io/rb/swisseph.svg)](https://badge.fury.io/rb/swisseph)

Native Ruby bindings for the [Swiss Ephemeris](http://www.astro.com/swisseph/) library (v2.10.3a), providing high-precision astronomical calculations for astrological applications.

## History & Motivation

This gem is a modernized fork of the original [aakara/swe4r](https://github.com/aakara/swe4r). Since the original project has been abandoned, this version was created to:

-   Ensure compatibility with modern Ruby versions.
-   Automate the build process using CMake.
-   Provide more idiomatic Ruby aliases and convenience methods.
-   Maintain active support for the latest Swiss Ephemeris releases.

## Convenience Features

### Shorthand Methods
All `swe_*` methods are also available without the `swe_` prefix:

```ruby
# Traditional way:
Swisseph.swe_julday(2024, 1, 1, 12.0)

# Modern shorthand:
Swisseph.julday(2024, 1, 1, 12.0)
```

### Module Aliases
For even shorter code, you can use the `Sweph` alias:

```ruby
Sweph.julday(2024, 1, 1, 12.0)
```

---

## Installation

```bash
gem install swisseph
```

Or add to your Gemfile:

```ruby
gem 'swisseph'
```

### Build Requirements

This gem requires **CMake 3.14 or later** to build from source. CMake is used to automatically download the Swiss Ephemeris library from GitHub during installation.

**Installing CMake:**
- **macOS:** `brew install cmake`
- **Ubuntu/Debian:** `sudo apt-get install cmake`
- **Windows:** Download from [cmake.org](https://cmake.org/download/)

---

## Quick Examples

### Calculate Planetary Position
```ruby
require 'swisseph'

# Get Julian day for May 14, 2012 at 10:15
jd = Sweph.julday(2012, 5, 14, 10.25)

# Calculate Sun position using Moshier ephemeris
sun = Sweph.calc_ut(jd, Sweph::SE_SUN, Sweph::SEFLG_MOSEPH | Sweph::SEFLG_SPEED)

puts "Sun longitude: #{sun[0]}°"
puts "Sun latitude: #{sun[1]}°"
```

### Calculate House Cusps
```ruby
require 'swisseph'

jd = Sweph.julday(2012, 5, 14, 10.25)
lat, lon = 45.45, -112.18

# Calculate Placidus houses
cusps, angles = Sweph.houses(jd, lat, lon, 'P')

puts "Ascendant: #{angles[0]}°"
puts "House 1: #{cusps[1]}°"
```

---

## Supported Functions

The gem provides full coverage of the Swiss Ephemeris API. All functions are available in both `swe_prefix` and `shorthand` forms.

| Category | Key Functions |
| :--- | :--- |
| **Planets** | `calc_ut`, `calc`, `get_orbital_elements`, `pheno_ut` |
| **Fixed Stars** | `fixstar_ut`, `fixstar2_ut`, `fixstar_mag` |
| **Houses** | `houses`, `houses_ex`, `house_pos`, `house_name` |
| **Eclipses** | `sol_eclipse_when_glob`, `lun_eclipse_when`, `sol_eclipse_where` |
| **Transits** | `solcross_ut`, `mooncross_ut`, `rise_trans` |
| **Time** | `julday`, `revjul`, `utc_to_jd`, `deltat`, `sidtime` |
| **Utilities** | `set_ephe_path`, `set_topo`, `get_planet_name`, `split_deg` |

---

## Constants

The gem provides constants for planets, calculation flags, and more:

```ruby
# Bodies
Swisseph::SE_SUN, SE_MOON, SE_MERCURY, SE_VENUS, SE_MARS...
# Flags
Swisseph::SEFLG_MOSEPH, SEFLG_SWIEPH, SEFLG_SPEED, SEFLG_SIDEREAL...
# Houses
'P' (Placidus), 'K' (Koch), 'E' (Equal), 'C' (Campanus)...
```

---

## Ephemeris Files

The **Moshier ephemeris** (`SEFLG_MOSEPH`) is built-in and requires no files.

For high-precision calculations, a minimal set of Swiss Ephemeris data files is **automatically included** during installation. For extended time ranges or asteroid files, download them from [astro.com](https://www.astro.com/ftp/swisseph/ephe/) and configure:

```ruby
Sweph.set_ephe_path('/path/to/ephemeris/files')
```

## Documentation

- [Swiss Ephemeris Programmer's Documentation](https://www.astro.com/swisseph/swephprg.htm)
- [Official Library Homepage](http://www.astro.com/swisseph/)

## License

GPL-2.0-or-later. See [LICENSE](LICENSE) for details.
Swiss Ephemeris library is (C) Astrodienst AG.
