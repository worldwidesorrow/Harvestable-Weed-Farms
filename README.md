Harvestable Weed Farms for Dayz Epoch 1.0.6+
==============

This script will add marked hemp plant locations to the map that players can harvest. Harvesting plants is built into DayZ Epoch. A player will need to have a hunting knife on his/her toolbelt. Stand next to a hemp plant, open gear, right click on the hunting knife, and select "Harvest Plant." Harvesting a group of hemp plants will add a kilo of hemp to the player's inventory.

Credit to the original author Halv.

### Install Instructions

1. Click ***[Clone or Download](https://github.com/worldwidesorrow/Harvestable-Weed-Farms/archive/master.zip)*** the green button on the right side of the Github page.

2. This mod is dependent on the Client Side Marker Manager. Download it ***[here](https://github.com/worldwidesorrow/Client-Side-Marker-Manager/)*** and install it according to the instructions.

3. This mod is dependent on the Epoch community stringtable. Download the stringtable ***[here](https://github.com/oiad/communityLocalizations/)*** and place file stringTable.xml in the root of your mission folder.
	
4. Unpack your server PBO and place file ***weedfarm.sqf*** in directory ***dayz_server\modules***

5. Repack your server PBO.

6. Unpack your mission PBO and edit file ***init.sqf*** with text editor.

Find this line

  ```sqf
  execVM "\z\addons\dayz_server\traders\chernarus11.sqf"; //Add trader agents
  ```
  add this line below it:
  
  ```sqf
  execVM "\z\addons\dayz_server\modules\weedfarm.sqf"; // Add weed farms
  ```

7. Save the file and repack your mission PBO

### Configurables

You can edit the defines at the top of the file to customize your weed farms

  ```sqf
  #define LOCATIONS	5			// number of concurrent farm locations
#define NUM_PLANTS	[5,10]		// random number of plants per location [minimum,maximum]
#define SPACING		5			// number of meters between plant groupings, no not use less than 5
#define ALLOW_NEW	true		// allow new farms to spawn when existing ones are cleared
#define DEBUG		true		// turning this to true will turn on rpt entries
#define MARKER		"Select"	// list of different marker types: https://community.bistudio.com/wiki/cfgMarkers
#define COLOR		"ColorGreen"// list of marker colors: https://community.bistudio.com/wiki/CfgMarkerColors_Arma_3
```


