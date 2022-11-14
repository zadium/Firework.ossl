/**
    @name: FireworkShooter
    @description:

    @author:
    @version: 1.7
    @updated: "2022-11-14 21:18:10"
    @revision: 327
    @localfile: ?defaultpath\Firework\?@name.lsl
    @license: ?

    @ref:

    @notice:

        # Firework.ossl

        Opensim Firework

        ### Instruction ###

        Add 2 prims one for ball/bullet one for shooter

        #### Fireball

        Name Ball/Bullet as `FireworkBall`, make it physic, change `Gravity` to 0.1, make it Glow as you like

        Upload FireworkBall.lsl, Whistle.wav, Explode.wav to FireworkBall prim

        Take copy of Fireball

        #### Shooter

        Upload FireworkShooter.lsl to `Shooter`
        Copy `Fireworkball` into `Shooter`

        Have fun

        ### Usage ###

        Click on prim or say `firework 10` or just `firework`
        ### Config ###

        ### Sounds  ###

        Thanks to freesound

            https://freesound.org/people/soundscalpel.com/sounds/110391/

            https://freesound.org/people/Rudmer_Rotteveel/sounds/336008/
*/
//* setting
integer default_count = 3;
float default_power = 3;

//* variables
integer current_count = 0;
float current_power = 3;


//* max color is exists in ball code
integer max_colors = 3;
integer current_color = 1;

shoot()
{
    float randPower = 1;
    llRezObject("FireworkBall", llGetPos() + <0.0,0.0,0.5>, <llFrand(randPower)-randPower/2, llFrand(randPower)-randPower/2, current_power + llFrand(1)>,  llGetRot() * llEuler2Rot(<0.0, PI, 0.0>), current_color);
    current_color++;
    if (current_color > max_colors)
    	current_color = 1;
}

start(integer count, float power)
{
	if (count == 0)
    	count = default_count;
    if (power == 0)
    	power = default_power;
    current_count = current_count + count;
    current_power = power;
    llSetTimerEvent(0.2+llFrand(0.2));
}

default
{
    state_entry()
    {
    	llListen(0, "", NULL_KEY, "");
    }

    on_rez(integer number)
    {
        llResetScript();
    }

    touch_start(integer num_detected)
    {
        start(0, 0); //* default params
    }

    listen(integer channel, string name, key id, string message)
    {
        if ((channel == 0) || (channel ==1))
        {
        	if (llGetOwner() == id)
            {
                string cmd_firework = "firework";

                if (llGetSubString(llToLower(message), 0, llStringLength(cmd_firework)-1) == cmd_firework)
                {
            	    list params = llParseStringKeepNulls(message,[" "],[""]);
            	    //list params = llGetSubString(message, llStringLength(cmd_firework), -1), STRING_TRIM)
                    integer count = llList2Integer(params, 1);
                    if (count>50)
                	    count = 50; //* protecting you ;)
                    float power = llList2Float(params, 2);
                    start(count, power);
                }
            }
        }
    }


    timer()
    {
    	shoot();
        llSetTimerEvent(0.2+llFrand(0.2));
        current_count--;
        if (current_count <= 0)
            llSetTimerEvent(0);
    }

}
