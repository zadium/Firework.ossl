/**
    @name: FireworkBall
    @description:

    @author:
    @version: 1.1
    @updated: "2022-11-10 01:46:19"
    @revision: 203
    @localfile: ?defaultpath\Firework\?@name.lsl
    @license: ?

    @ref:

    @notice:
*/

float particleLife = 2.0;

playsound()
{
    //llPlaySound(llGetInventoryName(INVENTORY_SOUND,0), 1.0);
}

fireworkTo(key target)
{

    playsound();
    integer flags = 0;
    flags = flags | PSYS_PART_EMISSIVE_MASK | PSYS_PART_INTERP_COLOR_MASK;
//    flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
//    flags = flags | PSYS_PART_WIND_MASK;
//    flags = flags | PSYS_PART_BOUNCE_MASK;
    flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if ((target != "") && (target != NULL_KEY))
        flags = flags | PSYS_PART_TARGET_POS_MASK;
    list params = [ PSYS_SRC_MAX_AGE, particleLife,
                    PSYS_SRC_TARGET_KEY, target,
                    PSYS_SRC_BURST_RADIUS, 0.1,
                    PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
                    PSYS_SRC_BURST_RATE, 0.1,
                    PSYS_SRC_ACCEL, <0 ,0 , -0.1>,
                    PSYS_SRC_BURST_PART_COUNT, 10,
                    PSYS_SRC_BURST_SPEED_MIN, 0.2,
                    PSYS_SRC_BURST_SPEED_MAX, 0.5,
                    PSYS_SRC_ANGLE_BEGIN, -PI/2,
                    PSYS_SRC_ANGLE_END, PI/2,
                    PSYS_SRC_OMEGA, <0,0,0>,

                    PSYS_PART_MAX_AGE, 10,
                    PSYS_PART_FLAGS, flags,
                    PSYS_PART_START_GLOW, 0.05,
                    PSYS_PART_END_GLOW, 0.01,
                    PSYS_PART_START_ALPHA, 0.9,
                    PSYS_PART_END_ALPHA, 0.01,
                    PSYS_PART_START_COLOR, <0.8,0.5,0.1>,
                    PSYS_PART_END_COLOR, <0.9,0.9,0.3>,
                    PSYS_PART_START_SCALE, <0.3,0.3,0.0>,
                    PSYS_PART_END_SCALE, <0.5,0.5,0.0>
    ];

    llParticleSystem(params);
    llSetTimerEvent(particleLife + 1);
}

integer isOn = FALSE;

fireworkOn()
{
    fireworkTo("");
    isOn = TRUE;
}

fireworkOff()
{
    llParticleSystem([]);
    isOn = FALSE;
}

default
{
    state_entry()
    {
        fireworkOff();
    }

    on_rez(integer number)
    {
        //llResetScript();
        if (number > 0) {
            llSetStatus(STATUS_PHYSICS, TRUE);
            llSetObjectDesc((string)number);
        }
    }

    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner())
            fireworkOn();
    }

    timer()
    {
        if (isOn)
        {
            if ((integer)llGetObjectDesc()>0)
                llDie();
        }
        else
        {
            fireworkOn();
            llSetTimerEvent(2);
        }
    }

    dataserver( key queryid, string data ){
        if (data == "fire")
            llSetTimerEvent(1);
    }

}
