/**
    @name: FireworkShooter
    @description:

    @author:
    @version: 1.6
    @updated: "2022-11-11 04:10:54"
    @revision: 263
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

//* variables
key target = NULL_KEY;

shoot(key id)
{
    target = id;
    integer i = count;
    while (i--)
    {
        float randPower = 1;
        llRezObject("FireworkBall", llGetPos() + <0.0,0.0,0.5>, <llFrand(randPower)-randPower/2, llFrand(randPower)-randPower/2, power + llFrand(1)>,  llGetRot() * llEuler2Rot(<0.0, PI, 0.0>), i+1);
        llSleep(0.5);
    }
}

default
{
    state_entry()
    {
//        llVolumeDetect(TRUE);
    }

    touch_start(integer num_detected)
    {
        shoot(llDetectedKey(0));
    }

    object_rez(key id)
    {
        //osMessageObject(id, "fire");
    }

    timer()
    {
    }

}
