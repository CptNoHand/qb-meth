# qb-meth
Mobile meth lab using the Journey RV

🔴 Made for the qbcore Framework
- [GitHub](https://github.com/qbcore-framework) / [DISCORD](https://www.discord.gg/qbcore)


Thank you for your interest in my work.
Please consider supporting ❤
- [Buymeacoffee StolK](https://www.buymeacoffee.com/StolK)
- [PayPal me](https://www.paypal.com/paypalme/StolK88)

## Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-inventory](https://github.com/qbcore-framework/qb-inventory)

## Installation
### Manual
1. Place qb-meth in you're server recources folder and add it to the server config.cfg

2. Add these lines below to: qb-core/shared.lua under QBShared.Items
#
	["Aceton"] 				 	 = {["name"] = "Aceton", 			  			["label"] = "Aceton", 					["weight"] = 5000, 		["type"] = "item", 		["image"] = "acetone.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Stuff to cook!"},
	["Methlabor"] 				 	 = {["name"] = "Methlabor", 			  			["label"] = "Methlabor", 						["weight"] = 15000, 	["type"] = "item", 		["image"] = "lab.png", 					["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Stuff to cook!"},
	["Lithium"] 				 	 = {["name"] = "Lithium", 			  			["label"] = "Lithium", 					["weight"] = 1000, 		["type"] = "item", 		["image"] = "lithium.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Stuff to cook!"},

3. Add the images (acetone.png/lithium.png/lab.png) to qb-inventory/html/images

3. start/restart you're server

## Usage
In you're server give yourself the items above:
5x Aceton
2x Lithium
1x Methlabor

And take place on the passengerside of the JOURNEY, then press E and enjoy 😉👍🏼

# Disclaimer
The orginal script is not mine i just made an edit for it to work qbcore an qb-menu
Use at your own risk

With ❤ from StolK


# Licence
2021 StolK

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>
