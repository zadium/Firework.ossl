/**
    @name: FireworkShooter
    @description:

    @author:
    @version: 1.1
    @updated: "2022-11-10 02:26:55"
    @revision: 226
    @localfile: ?defaultpath\Firework\?@name.lsl
    @license: ?

    @ref:

    @notice:
*/
//* setting
integer count = 1;

//* variables
key target = NULL_KEY;

drop(key id)
{
    target = id;
    integer i = count;
    while (i--)
        llRezObject("FireworkBall", llGetPos() + <0.0,0.0,0.5>, <0, 0, 3>,  llGetRot() * llEuler2Rot(<0.0,PI,0.0>), i+1);
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
        osMessageObject(id, "fire");
    }

    collision_start( integer num_detected )
    {
        drop(llDetectedKey(0));
    }

    timer()
    {
    }

}
