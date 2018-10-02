Harvestable Weed Farms for Dayz Epoch 1.0.6+
==============

This script will add marked hemp plant locations to the map that players can harvest. Harvesting a group of hemp plants will add a kilo of hemp to the player's inventory.

Credit to the original author Halv.

### Install Instructions

1. Click ***[Clone or Download](https://github.com/worldwidesorrow/Harvestable-Weed-Farms/archive/master.zip)*** the green button on the right side of the Github page.

	> Recommended PBO tool for all "pack", "repack", or "unpack" steps: ***[PBO Manager](http://www.armaholic.com/page.php?id=16369)***
	
2. Unpack your server PBO and place file ***weedfarm.sqf*** in directory ***dayz_server\modules***

3. Repack your server PBO.

4. Unpack your mission PBO and edit file ***init.sqf*** with text editor.

Find this line

  ```sqf
  execVM "\z\addons\dayz_server\traders\chernarus11.sqf"; //Add trader agents
  ```
  add this line below it:
  
  ```sqf
  execVM "\z\addons\dayz_server\modules\weedfarm.sqf"; // Add weed farms
  ```

5. Save the file and repack your mission PBO

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


