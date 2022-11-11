/**
    @name: FireworkShooter
    @description:

    @author:
    @version: 1.7
    @updated: "2022-11-11 16:21:17"
    @revision: 287
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

        ### Config ###

        ### Sounds  ###

        Thanks to freesound

	        https://freesound.org/people/soundscalpel.com/sounds/110391/

    	    https://freesound.org/people/Rudmer_Rotteveel/sounds/336008/
*/
//* setting
integer count = 3;
float power = 3;
float time = 1;

//* variables
integer current = 0;

shoot()
{
    float randPower = 1;
    llRezObject("FireworkBall", llGetPos() + <0.0,0.0,0.5>, <llFrand(randPower)-randPower/2, llFrand(randPower)-randPower/2, power + llFrand(1)>,  llGetRot() * llEuler2Rot(<0.0, PI, 0.0>), current);
}

start()
{
	current = current + count;
	llSetTimerEvent(0.2+llFrand(0.2));
}

default
{
    state_entry()
    {
    }

    on_rez(integer number)
    {
        llResetScript();
    }

    touch_start(integer num_detected)
    {
        start();
    }

    object_rez(key id)
    {
    	vector color = <1,1,1>;
        osMessageObject(id, "fire;"+(string)time+";"+(string)color);
    }

    timer()
    {
	   	shoot();
        llSetTimerEvent(0.2+llFrand(0.2));
    	current--;
        if (current <= 0)
        	llSetTimerEvent(0);
    }

}
