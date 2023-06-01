/**
    @name: FireworkBall
    @description:

    @author:
    @version: 1.10
    @updated: "2023-02-03 01:59:06"
    @revision: 395
    @localfile: ?defaultpath\Firework\?@name.lsl
    @license: ?

    @ref:

    @notice:
*/

list StartColors = [
    <0.8,0.1,0.1>,
    <0.8,0.5,0.1>,
    <0.2,0.5,0.1>
    ];

list EndColors = [
    <0.9,0.2,0.3>,
    <0.9,0.9,0.3>,
    <0.3,0.6,0.3>
    ];

playsoundExplode()
{
    llPlaySound("Explode", 1.0);
}

playsoundWhistle()
{
    llPlaySound("Whistle", 1.0);
}

explode()
{
    integer number = (integer)llGetObjectDesc();
    if (number > 0) //* not for testing, and we need to stop it in the sky before explode
        llSetStatus(STATUS_PHYSICS, FALSE);

    integer color_index = number % llGetListLength(StartColors);
    vector start_color = llList2Vector(StartColors, color_index);
    vector end_color = llList2Vector(EndColors, color_index);

    llSetLinkPrimitiveParams(LINK_THIS, [PRIM_POINT_LIGHT, TRUE, start_color, 1.0, 20, 0, PRIM_GLOW, ALL_SIDES, 1]);

    playsoundExplode();

    integer flags = 0;
    flags = flags | PSYS_PART_EMISSIVE_MASK | PSYS_PART_INTERP_COLOR_MASK;
//    flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
//    flags = flags | PSYS_PART_WIND_MASK;
//    flags = flags | PSYS_PART_BOUNCE_MASK;
    flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    list params = [
                    PSYS_SRC_MAX_AGE, 1,
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

                    PSYS_PART_MAX_AGE, 3,
                    PSYS_PART_FLAGS, flags,
                    PSYS_PART_START_GLOW, 0.03,
                    PSYS_PART_END_GLOW, 0.05,
                    PSYS_PART_START_ALPHA, 0.9,
                    PSYS_PART_END_ALPHA, 0.01,
                    PSYS_PART_START_COLOR, start_color,
                    PSYS_PART_END_COLOR, end_color,
                    PSYS_PART_START_SCALE, <0.2,0.2,0.0>,
                    PSYS_PART_END_SCALE, <0.5,0.5,0.0>
    ];

    llParticleSystem(params);

    llSetTimerEvent(0.5); //* die after that
}

integer stateBall = 0;
vector oldPos; //* for testing only to return back to original pos


shoot(float time)
{
    stateBall = 0;
    //tail(); //* no, save some for explode
    playsoundWhistle();
    if (time==0)
    {
        float speed = llVecMag(llGetVel()); //* meter per seconds
        //llOwnerSay((string)(speed));
        if (speed == 0)
            time = 2;
        else
            time = (speed/9.8); //* calc the time when reach the top (speed is 0)
    }

    llSetTimerEvent(time);
}

clear()
{
    llSetLinkPrimitiveParams(LINK_THIS, [PRIM_POINT_LIGHT, FALSE, <1,1,1>, 0, 0, 0, PRIM_GLOW, ALL_SIDES, 0.5]);
}

init()
{
    llSetTimerEvent(0);
    llParticleSystem([]);
    clear();
}

default
{
    state_entry()
    {
        oldPos = llGetPos();
        init();
        stateBall = 0;
    }

    on_rez(integer number)
    {
        llParticleSystem([]);
        if (number > 0) {
            llSetObjectDesc((string)number);
            llSetStatus(STATUS_PHYSICS, TRUE);
            llSetPrimitiveParams([PRIM_TEMP_ON_REZ, TRUE]);
            shoot(0); //* time will use speed
        }
    }

    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            oldPos = llGetPos();
            llSetStatus(STATUS_PHYSICS, TRUE);
//            llPushObject(llGetKey(), <0,0,15>, <0,0,0>, FALSE);
            shoot(0);
        }
    }

    timer()
    {
        if (stateBall == 0)
        {
            stateBall++;
            explode();
            llSetTimerEvent(1);
        }
        else
        {
            stateBall = 0;
            llSetTimerEvent(0);

            if ((integer)llGetObjectDesc()>0) //* not testing
            {
                clear();
                llSetPrimitiveParams([PRIM_TEMP_ON_REZ, TRUE]);
                llSetAlpha(0, ALL_SIDES);
                llSleep(0.5);
                llDie();
                //* https://community.secondlife.com/forums/topic/421302-lldie-not-working/
                llSleep(0.5); //* sleep before end script, idk if that resolve non dead balls in the client
            }
            else //* Testing, return back to original pos
            {
                llSetRegionPos(oldPos);
                init();
            }
        }
    }
}
