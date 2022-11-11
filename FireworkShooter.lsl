/**
    @name: FireworkShooter
    @description:

    @author:
    @version: 1.1
    @updated: "2022-11-10 01:46:19"
    @revision: 202
    @localfile: ?defaultpath\Firework\?@name.lsl
    @license: ?

    @ref:

    @notice:
*/
//* setting
integer count = 1;

//* variables
integer isReady = TRUE;
key target = NULL_KEY;

drop(key id)
{
    if (isReady)
    {
        target = id;
        isReady = FALSE;
        integer i = count;
        while (i--)
            llRezObject("FireworkBall", llGetPos() + <0.0,0.0,1.0>, <0, 0, 1>,  llGetRot() * llEuler2Rot(<0.0,PI,0.0>), i+1);
        llSetTimerEvent(5);
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
        osMessageObject(id, "fire");
    }

    collision_start( integer num_detected )
    {
        drop(llDetectedKey(0));
    }

    timer()
    {
        isReady = TRUE;
        target = NULL_KEY;
        llSetTimerEvent(0);
    }

}
