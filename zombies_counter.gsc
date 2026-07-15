#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_utility;

init()
{
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread watchHollowBoxCounter();
    }
}

watchHollowBoxCounter()
{
    self endon("disconnect");

    // --- Corner Alignment & Size Settings ---
    boxWidth = 72;         // Narrow width to fit text perfectly
    boxHeight = 56;        // Compact vertical height
    startX = 2;            // Pushed far into the left corner
    startY = 2;            // Pushed far into the top corner
    borderThickness = 1;   // Clean 1px outline

    // --- DRAWING THE HOLLOW BORDER LINES ---
    
    // 1. Top Line
    self.hud_border_top = createIcon("white", boxWidth, borderThickness);
    self.hud_border_top.alignX = "left";
    self.hud_border_top.alignY = "top";
    self.hud_border_top.horzAlign = "left";
    self.hud_border_top.vertAlign = "top";
    self.hud_border_top.x = startX;
    self.hud_border_top.y = startY;
    self.hud_border_top.color = (1, 1, 1); 
    self.hud_border_top.alpha = 0.8; // Semi-solid white
    self.hud_border_top.sort = 1;
    self.hud_border_top.hideWhenInMenu = 1;
    self.hud_border_top.hideWhenDead = 1;

    // 2. Bottom Line
    self.hud_border_bottom = createIcon("white", boxWidth, borderThickness);
    self.hud_border_bottom.alignX = "left";
    self.hud_border_bottom.alignY = "top";
    self.hud_border_bottom.horzAlign = "left";
    self.hud_border_bottom.vertAlign = "top";
    self.hud_border_bottom.x = startX;
    self.hud_border_bottom.y = startY + boxHeight - borderThickness;
    self.hud_border_bottom.color = (1, 1, 1); 
    self.hud_border_bottom.alpha = 0.8; 
    self.hud_border_bottom.sort = 1;
    self.hud_border_bottom.hideWhenInMenu = 1;
    self.hud_border_bottom.hideWhenDead = 1;

    // 3. Left Line
    self.hud_border_left = createIcon("white", borderThickness, boxHeight);
    self.hud_border_left.alignX = "left";
    self.hud_border_left.alignY = "top";
    self.hud_border_left.horzAlign = "left";
    self.hud_border_left.vertAlign = "top";
    self.hud_border_left.x = startX;
    self.hud_border_left.y = startY;
    self.hud_border_left.color = (1, 1, 1); 
    self.hud_border_left.alpha = 0.8; 
    self.hud_border_left.sort = 1;
    self.hud_border_left.hideWhenInMenu = 1;
    self.hud_border_left.hideWhenDead = 1;

    // 4. Right Line
    self.hud_border_right = createIcon("white", borderThickness, boxHeight);
    self.hud_border_right.alignX = "left";
    self.hud_border_right.alignY = "top";
    self.hud_border_right.horzAlign = "left";
    self.hud_border_right.vertAlign = "top";
    self.hud_border_right.x = startX + boxWidth - borderThickness;
    self.hud_border_right.y = startY;
    self.hud_border_right.color = (1, 1, 1); 
    self.hud_border_right.alpha = 0.8; 
    self.hud_border_right.sort = 1;
    self.hud_border_right.hideWhenInMenu = 1;
    self.hud_border_right.hideWhenDead = 1;

    // --- TEXT STRINGS ---

    // Total Zombies Text
    self.hud_total = self createFontString("small", 1.0);
    self.hud_total.alignX = "left";
    self.hud_total.alignY = "top";
    self.hud_total.horzAlign = "left";
    self.hud_total.vertAlign = "top";
    self.hud_total.x = startX + 5;
    self.hud_total.y = startY + 4; 
    self.hud_total.alpha = 0.9; 
    self.hud_total.sort = 3;
    self.hud_total.hideWhenInMenu = 1;
    self.hud_total.hideWhenDead = 1;
    self.hud_total.label = &"Left: ^1";

    // Active Zombies Text
    self.hud_active = self createFontString("small", 1.0);
    self.hud_active.alignX = "left";
    self.hud_active.alignY = "top";
    self.hud_active.horzAlign = "left";
    self.hud_active.vertAlign = "top";
    self.hud_active.x = startX + 5;
    self.hud_active.y = startY + 20; 
    self.hud_active.alpha = 0.85;
    self.hud_active.sort = 3;
    self.hud_active.hideWhenInMenu = 1;
    self.hud_active.hideWhenDead = 1;
    self.hud_active.label = &"Act: ^2"; 

    // In Queue Text
    self.hud_queue = self createFontString("small", 1.0);
    self.hud_queue.alignX = "left";
    self.hud_queue.alignY = "top";
    self.hud_queue.horzAlign = "left";
    self.hud_queue.vertAlign = "top";
    self.hud_queue.x = startX + 5;
    self.hud_queue.y = startY + 36; 
    self.hud_queue.alpha = 0.85;
    self.hud_queue.sort = 3;
    self.hud_queue.hideWhenInMenu = 1;
    self.hud_queue.hideWhenDead = 1;
    self.hud_queue.label = &"Que: ^3"; 

    for(;;)
    {
        // Fade during afterlife
        if(isDefined(self.afterlife) && self.afterlife)
        {
            alphaScale = 0.15;
            textScale = 0.2;
        }
        else 
        {
            alphaScale = 0.8;
            textScale = 0.85;
        }

        self.hud_border_top.alpha = alphaScale;
        self.hud_border_bottom.alpha = alphaScale;
        self.hud_border_left.alpha = alphaScale;
        self.hud_border_right.alpha = alphaScale;
        
        self.hud_total.alpha = textScale;
        self.hud_active.alpha = textScale;
        self.hud_queue.alpha = textScale;

        active_zombies = get_current_zombie_count(); 
        queue_zombies = level.zombie_total;          
        total_remaining = active_zombies + queue_zombies;

        self.hud_total setValue(total_remaining);
        self.hud_active setValue(active_zombies);
        self.hud_queue setValue(queue_zombies);
        
        wait 0.1;
    }
}
