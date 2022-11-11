/**
    @name: FireworkShooter
    @description:

    @author:
    @version: 1.6
    @updated: "2022-11-10 20:26:53"
    @revision: 251
    @localfile: ?defaultpath\Firework\?@name.lsl
    @license: ?

    @ref:

    @notice:
*/
//* setting
integer count = 3;
float power = 3;

//* variables
key target = NULL_KEY;

drop(key id)
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
        llVolumeDetect(TRUE);
    }

    touch(integer num_detected)
    {
        drop(llDetectedKey(0));
    }

    object_rez(key id)
    {
        //osMessageObject(id, "fire");
    }

    collision_start( integer num_detected )
    {
        drop(llDetectedKey(0));
    }

    timer()
    {
    }

}
